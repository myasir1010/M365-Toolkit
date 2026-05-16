$ScriptFolders = @(
    'private','public','users','groups','licenses','exchange','sharepoint','onedrive','teams','devices','security','active-directory','reports'
)

foreach ($Folder in $ScriptFolders) {
    $Path = Join-Path -Path $PSScriptRoot -ChildPath $Folder
    if (Test-Path $Path) {
        Get-ChildItem -Path $Path -Filter '*.ps1' -Recurse | ForEach-Object {
            . $_.FullName
        }
    }
}

$PublicFunctions = Get-ChildItem -Path $PSScriptRoot -Filter '*.ps1' -Recurse |
    Where-Object { $_.DirectoryName -notmatch '\\private$' } |
    Select-Object -ExpandProperty BaseName

Export-ModuleMember -Function $PublicFunctions
r