$path = 'HKLM:\SYSTEM\ControlSet001\Services\WinDefend'
$Acl = Get-ACL $path
$AccessRule = New-Object System.Security.AccessControl.RegistryAccessRule((New-Object System.Security.Principal.SecurityIdentifier('S-1-1-0')),'SetValue','Deny')
$Acl.AddAccessRule($AccessRule)
Set-Acl $path $Acl
