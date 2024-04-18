# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "You must run this script as an Administrator."
    pause
    exit
}

# Get the current directory
$CurrentDirectory = Get-Location

# Get the base name of the current directory
$RuleName = Split-Path -Leaf $CurrentDirectory

Write-Host "- Add Block In & Out Firewall rules for all *.exe & *.dll files"
Write-Host "- located at '$CurrentDirectory' (inc subfolders)"
Write-Host "- creating $RuleName as the Firewall rule name"
Write-Host ""
Write-Host "Press any key to continue or CTRL+C to terminate now ..."
pause

Get-ChildItem -Path $CurrentDirectory -Recurse -Include *.exe,*.dll | ForEach-Object {
    Write-Host $_.FullName
    New-NetFirewallRule -DisplayName "$RuleName-$($_.Name)" -Direction Inbound -Program $_.FullName -Action Block
    New-NetFirewallRule -DisplayName "$RuleName-$($_.Name)" -Direction Outbound -Program $_.FullName -Action Block
}

Write-Host ""
Write-Host "Done. Goodbye"
Write-Host ""
Write-Host "Press a key to exit ..."
pause
