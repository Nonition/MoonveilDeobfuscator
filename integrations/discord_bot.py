"""Slash-command example. Credentials are read from the environment, never shipped.

Install optional dependencies: python -m pip install -e '.[bot]'
Production: use MOONVEIL_WORKER_IMAGE and read docs/SECURITY.md first.
"""

from __future__ import annotations
import asyncio
import io
import os
import time
import discord
from discord import app_commands
from discord.ext import commands
from .worker import run_job, MAX_UPLOAD

TOKEN = os.environ.get("DISCORD_TOKEN")
ALLOWED = {
    int(x.strip())
    for x in os.environ.get("MOONVEIL_ALLOWED_USERS", "").split(",")
    if x.strip()
}
PUBLIC = os.environ.get("MOONVEIL_ALLOW_PUBLIC") == "1"
GUILD = os.environ.get("DISCORD_GUILD_ID")
SEMAPHORE = asyncio.Semaphore(1)
RECENT = {}


class Bot(commands.Bot):
    async def setup_hook(self):
        if GUILD:
            guild = discord.Object(id=int(GUILD))
            self.tree.copy_global_to(guild=guild)
            await self.tree.sync(guild=guild)
        else:
            await self.tree.sync()


bot = Bot(command_prefix="!", intents=discord.Intents.default())


async def handle(
    interaction: discord.Interaction, attachment: discord.Attachment, mode: str
):
    if not PUBLIC and interaction.user.id not in ALLOWED:
        await interaction.response.send_message(
            "You are not authorized to use this worker.", ephemeral=True
        )
        return
    if attachment.size > MAX_UPLOAD or not attachment.filename.lower().endswith(
        (".lua", ".luau", ".txt")
    ):
        await interaction.response.send_message(
            "Only .lua/.luau/.txt files up to 512 KiB; no links or archives.",
            ephemeral=True,
        )
        return
    now = time.monotonic()
    if now - RECENT.get(interaction.user.id, 0) < 20:
        await interaction.response.send_message(
            "Please wait 20 seconds between jobs.", ephemeral=True
        )
        return
    if SEMAPHORE.locked():
        await interaction.response.send_message(
            "Worker is busy. Please try again later.", ephemeral=True
        )
        return
    RECENT[interaction.user.id] = now
    # Bounded cooldown metadata; no source text is logged.
    for user, timestamp in list(RECENT.items()):
        if now - timestamp > 300:
            RECENT.pop(user, None)
    await SEMAPHORE.acquire()
    try:
        await interaction.response.defer(thinking=True, ephemeral=True)
        contents = await attachment.read()
        result = await run_job(contents, mode)
        status = result.report.get("status", "internal_error")
        message = (
            f"Status: **{status}**. "
            "Experimental profile-based tool; no guarantee for all MoonVeil 2.0.26. "
            "Result is not verified in a real runtime."
        )
        if result.payload is None:
            message += (
                "\n"
                + str(
                    result.report.get(
                        "structure_error",
                        result.report.get("reason", "No complete source emitted."),
                    )
                )[:1500]
            )
            await interaction.followup.send(message, ephemeral=True)
        else:
            await interaction.followup.send(
                message,
                file=discord.File(io.BytesIO(result.payload), filename=result.filename),
                ephemeral=True,
            )
    except Exception:
        await interaction.followup.send(
            "Job failed; no confirmed source. Check the admin-side worker configuration.",
            ephemeral=True,
        )
    finally:
        SEMAPHORE.release()


@bot.tree.command(
    name="deobfuscate",
    description="Recover a supported MoonVeil profile; never executes the payload",
)
@app_commands.describe(source="Lua/Luau file up to 512 KiB")
async def deobfuscate(interaction: discord.Interaction, source: discord.Attachment):
    await handle(interaction, source, "deobfuscate")


@bot.tree.command(
    name="moonveil_analyze",
    description="Emit constants, CFG, and data bundle for AI/analyst",
)
@app_commands.describe(source="Lua/Luau file up to 512 KiB")
async def analyze(interaction: discord.Interaction, source: discord.Attachment):
    await handle(interaction, source, "analyze")


if __name__ == "__main__":
    if not TOKEN:
        raise SystemExit("Set DISCORD_TOKEN in the environment.")
    if not ALLOWED and not PUBLIC:
        raise SystemExit(
            "Set MOONVEIL_ALLOWED_USERS, or explicitly opt into MOONVEIL_ALLOW_PUBLIC=1."
        )
    bot.run(TOKEN, log_handler=None)
