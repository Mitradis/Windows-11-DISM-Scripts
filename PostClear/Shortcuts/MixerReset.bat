@echo off
title Press any key to confirm
pause
title Work...
net stop Audiosrv
net stop AudioEndpointBuilder
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore"
net start Audiosrv
