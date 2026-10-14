# Invoke-Moonveil21.ps1
[CmdletBinding()]
param(
 [Parameter(Mandatory=$true)][string]$InputFile,
 [Parameter(Mandatory=$true)][string]$OutputDirectory,
 [switch]$TraceReviewed,
 [switch]$Force
)
$ErrorActionPreference='Stop'
$Root=Split-Path -Parent $PSScriptRoot
$InputPath=(Resolve-Path -LiteralPath $InputFile).Path
$OutputPath=$ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputDirectory)
if(Get-Command py -ErrorAction SilentlyContinue){$Python='py';$Prefix=@('-3')}
elseif(Get-Command python -ErrorAction SilentlyContinue){$Python='python';$Prefix=@()}
else{throw 'Python 3.10+ is required.'}
if(-not(Get-Command node -ErrorAction SilentlyContinue)){throw 'Node.js 18+ is required.'}
$CommandArgs=$Prefix+@('-m','moonveil21','analyze',$InputPath,'-o',$OutputPath)
if($TraceReviewed){$CommandArgs+='--trace-reviewed'}
if($Force){$CommandArgs+='--force'}
Push-Location $Root
try{& $Python @CommandArgs;$Code=$LASTEXITCODE}finally{Pop-Location}
exit $Code
