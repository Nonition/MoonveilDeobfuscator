# Invoke-Moonveil.ps1
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$InputFile,
    [Parameter(Mandatory = $true)][string]$Output,
    [ValidateSet('deobfuscate', 'analyze')][string]$Mode = 'deobfuscate',
    [ValidateRange(1, 300)][int]$Seconds = 120,
    [switch]$Force,
    [switch]$RequireVerified
)
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$ResolvedInput = (Resolve-Path -LiteralPath $InputFile).Path
$ResolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Output)
if (Get-Command py -ErrorAction SilentlyContinue) {
    $Python = 'py'
    $Prefix = @('-3')
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    $Python = 'python'
    $Prefix = @()
} else {
    throw 'Python 3.10+ is required.'
}
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    throw 'Node.js 18+ is required. No npm install is needed.'
}
$CommandArgs = $Prefix + @('-m', 'moonveil', $Mode, $ResolvedInput, '-o', $ResolvedOutput, '--seconds', [string]$Seconds)
if ($Force) { $CommandArgs += '--force' }
if ($RequireVerified) { $CommandArgs += '--require-verified' }
Push-Location $Root
try {
    # Argument-array invocation, never Invoke-Expression or concatenated shell code.
    & $Python @CommandArgs
    $ResultCode = $LASTEXITCODE
} finally {
    Pop-Location
}
exit $ResultCode
