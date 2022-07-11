Set oWS = WScript.CreateObject("WScript.Shell")
sLinkFile = WScript.Arguments(0)
Set oLink = oWS.CreateShortcut(sLinkFile)
oLink.TargetPath = WScript.Arguments(1)
oLink.Save
