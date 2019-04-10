Param ([string]$Version = "0.1-dev")
$ErrorActionPreference = "Stop"
Push-Location $(Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Ensure 0install is in PATH
if (!(Get-Command 0install -ErrorAction SilentlyContinue)) {
    echo "Downloading 0install"
    mkdir -Force "$env:TEMP\zero-install" | Out-Null
    Invoke-WebRequest "https://0install.de/files/0install.exe" -OutFile "$env:TEMP\zero-install\0install.exe"
    $env:PATH = "$env:TEMP\zero-install;$env:PATH"
}

if (!(Test-Path ~\.helm)) {
    0install run --batch http://repo.roscidus.com/kubernetes/helm init --client-only
}

foreach ($file in $(Get-ChildItem charts -Directory).FullName) {
    0install run --batch http://repo.roscidus.com/kubernetes/helm package "$file" --version $Version --dependency-update
    if ($LASTEXITCODE -ne 0) {throw "Failed with exit code $LASTEXITCODE"}
}

Pop-Location
