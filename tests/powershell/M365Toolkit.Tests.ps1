Describe 'M365Toolkit module' {
    It 'Imports the module' {
        Import-Module "$PSScriptRoot/../../powershell/M365Toolkit.psd1" -Force
        Get-Command Connect-M365Toolkit | Should -Not -BeNullOrEmpty
    }
}