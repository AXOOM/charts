Param ($InputDir = ".", $OutputDir = ".", $Format = "png")
Get-ChildItem $InputDir -Filter *.dot | ForEach { 0install run http://repo.roscidus.com/utils/graphviz $_ -T $Format -o $([IO.Path]::Combine($OutputDir, [IO.Path]::GetFileNameWithoutExtension($_) + ".$Format")) }
