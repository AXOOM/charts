Param ([string]$Version = "0.1-pre", [Switch]$RegisterLocal)
$ErrorActionPreference = "Stop"
Push-Location $(Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

$assets = `
  "networks/traefik-internal", "networks/traefik-internal", "networks/ssh-jump", `
  "mixins/expose-internal", "mixins/expose-public", "mixins/expose-ssh-jump", "mixins/axoom-service", "mixins/axoom-portal-app"

foreach ($asset in $assets) {
  0install run http://assets.axoom.cloud/tools/ax.xml release --verbose --refresh "$asset.yml" $Version

  # Register temporary local override to support dependencies between the individual assets
  0install add-feed --batch "$asset-$Version.xml"
}

# Keep the temporary overrides as permanent if desired
if (!$RegisterLocal) {
  foreach ($asset in $assets) {
    0install remove-feed --batch "$asset-$Version.xml"
  }
}

Pop-Location
