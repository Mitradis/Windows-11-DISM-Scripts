title Block Start&Search
taskkill /f /im StartMenuExperienceHost.exe
taskkill /f /im ShellExperienceHost.exe
taskkill /f /im DesktopStickerEditorWin32Exe.exe
taskkill /f /im FESearchHost.exe
taskkill /f /im LogonWebHostProduct.exe
taskkill /f /im MiniSearchHost.exe
taskkill /f /im ScreenClippingHost.exe
taskkill /f /im SearchHost.exe
taskkill /f /im TextInputHost.exe
taskkill /f /im WebExperienceHostApp.exe
TIMEOUT /T 2 /NOBREAK >nul
set BLOCKLIST=Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\StartMenuExperienceHost.exe MicrosoftWindows.Client.CBS_cw5n1h2txyewy\DesktopStickerEditorWin32Exe\DesktopStickerEditorWin32Exe.exe MicrosoftWindows.Client.CBS_cw5n1h2txyewy\FESearchHost.exe MicrosoftWindows.Client.CBS_cw5n1h2txyewy\LogonWebHostProduct.exe MicrosoftWindows.Client.CBS_cw5n1h2txyewy\MiniSearchHost.exe MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe MicrosoftWindows.Client.CBS_cw5n1h2txyewy\WebExperienceHostApp.exe
if not exist %windir%\zh-CN\explorer.exe.mui (
	set BLOCKLIST=%BLOCKLIST% MicrosoftWindows.Client.CBS_cw5n1h2txyewy\ScreenClippingHost.exe MicrosoftWindows.Client.CBS_cw5n1h2txyewy\TextInputHost.exe
)
for %%a in (%BLOCKLIST%) do (
	takeown /f %windir%\SystemApps\%%a
	icacls %windir%\SystemApps\%%a /grant "%username%":f /c /l /q
	icacls %windir%\SystemApps\%%a /deny "*S-1-1-0:(W,D,X,R,RX,M,F)" "*S-1-5-7:(W,D,X,R,RX,M,F)"
)
TIMEOUT /T 1 /NOBREAK >nul
title Editing .dll
set EDITDLL=%windir%\System32\InputSwitch.dll
if not exist %windir%\zh-CN\explorer.exe.mui (
	takeown /f %EDITDLL%
	icacls %EDITDLL% /grant "%username%":f /c /l /q
	cscript %programdata%\PostClear\BytesReplacer.vbs %EDITDLL% %EDITDLL%.mod
	if exist %EDITDLL%.mod (
		del /f /q %EDITDLL%
		move %EDITDLL%.mod %EDITDLL%
	)
)
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path %windir%\System32\control.exe | Set-Acl -Path %EDITDLL%"
title Deleting Edge services
sc delete edgeupdate
sc delete edgeupdatem
title Block EdgeUpdate folder
mkdir "%programfiles(x86)%\Microsoft\EdgeUpdate"
icacls "%programfiles(x86)%\Microsoft\EdgeUpdate" /deny *S-1-1-0:(W,D,X,R,RX,M,F) *S-1-5-7:(W,D,X,R,RX,M,F)
title Deleting tasks
schtasks /delete /tn Microsoft\XblGameSave\XblGameSaveTask /f
schtasks /delete /tn "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /f
schtasks /delete /tn "Microsoft\Windows\Application Experience\PcaPatchDbTask" /f
schtasks /delete /tn "Microsoft\Windows\Application Experience\ProgramDataUpdater" /f
schtasks /delete /tn "Microsoft\Windows\Application Experience\StartupAppTask" /f
schtasks /delete /tn Microsoft\Windows\Autochk\Proxy /f
schtasks /delete /tn Microsoft\Windows\CloudExperienceHost\CreateObjectTask /f
schtasks /delete /tn "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /f
schtasks /delete /tn "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /f
schtasks /delete /tn Microsoft\Windows\Defrag\ScheduledDefrag /f
schtasks /delete /tn Microsoft\Windows\Diagnosis\Scheduled /f
schtasks /delete /tn Microsoft\Windows\DiskCleanup\SilentCleanup /f
schtasks /delete /tn Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector /f
schtasks /delete /tn "Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh" /f
schtasks /delete /tn Microsoft\Windows\Feedback\Siuf\DmClient /f
schtasks /delete /tn Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload /f
schtasks /delete /tn "Microsoft\Windows\FileHistory\File History (maintenance mode)" /f
schtasks /delete /tn Microsoft\Windows\Flighting\FeatureConfig\ReconcileFeatures /f
schtasks /delete /tn Microsoft\Windows\Flighting\FeatureConfig\UsageDataFlushing /f
schtasks /delete /tn Microsoft\Windows\Flighting\FeatureConfig\UsageDataReporting /f
schtasks /delete /tn Microsoft\Windows\Flighting\OneSettings\RefreshCache /f
schtasks /delete /tn "Microsoft\Windows\International\Synchronize Language Settings" /f
schtasks /delete /tn Microsoft\Windows\LanguageComponentsInstaller\Installation /f
schtasks /delete /tn Microsoft\Windows\Maintenance\WinSAT /f
schtasks /delete /tn Microsoft\Windows\Maps\MapsToastTask /f
schtasks /delete /tn Microsoft\Windows\Maps\MapsUpdateTask /f
schtasks /delete /tn Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents /f
schtasks /delete /tn Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic /f
schtasks /delete /tn Microsoft\Windows\NetTrace\GatherNetworkInfo /f
schtasks /delete /tn "Microsoft\Windows\Offline Files\Background Synchronization" /f
schtasks /delete /tn "Microsoft\Windows\Offline Files\Logon Synchronization" /f
schtasks /delete /tn Microsoft\Windows\PI\Sqm-Tasks /f
schtasks /delete /tn "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /f
schtasks /delete /tn Microsoft\Windows\PushToInstall\LoginCheck /f
schtasks /delete /tn Microsoft\Windows\PushToInstall\Registration /f
schtasks /delete /tn Microsoft\Windows\RetailDemo\CleanupOfflineContent /f
schtasks /delete /tn Microsoft\Windows\Setup\SetupCleanupTask /f
schtasks /delete /tn Microsoft\Windows\Shell\FamilySafetyMonitor /f
schtasks /delete /tn Microsoft\Windows\Shell\FamilySafetyRefreshTask /f
schtasks /delete /tn Microsoft\Windows\Shell\IndexerAutomaticMaintenance /f
schtasks /delete /tn Microsoft\Windows\Speech\SpeechModelDownloadTask /f
schtasks /delete /tn Microsoft\Windows\Sysmain\WsSwapAssessmentTask /f
schtasks /delete /tn Microsoft\Windows\SystemRestore\SR /f
schtasks /delete /tn "Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" /f
schtasks /delete /tn "Microsoft\Windows\Time Synchronization\SynchronizeTime" /f
schtasks /delete /tn "Microsoft\Windows\Time Zone\SynchronizeTimeZone" /f
schtasks /delete /tn Microsoft\Windows\UNP\RunUpdateNotificationMgr /f
schtasks /delete /tn "Microsoft\Windows\User Profile Service\HiveUploadTask" /f
schtasks /delete /tn Microsoft\Windows\WaaSMedic\PerformRemediation /f
schtasks /delete /tn "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /f
schtasks /delete /tn "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /f
schtasks /delete /tn "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /f
schtasks /delete /tn "Microsoft\Windows\Windows Defender\Windows Defender Verification" /f
schtasks /delete /tn "Microsoft\Windows\Windows Error Reporting\QueueReporting" /f
schtasks /delete /tn "Microsoft\Windows\WindowsUpdate\Scheduled Start" /f
if exist %windir%\en-US\explorer.exe.mui (
	schtasks /create /tn "Microsoft\Windows\WindowsUpdate\Scheduled Start" /tr %windir%\explorer.exe /sc once /sd 11/30/1999 /st 00:00 /ru SYSTEM
)
if exist %windir%\zh-CN\explorer.exe.mui (
	schtasks /create /tn "Microsoft\Windows\WindowsUpdate\Scheduled Start" /tr %windir%\explorer.exe /sc once /sd 1999/11/30 /st 00:00 /ru SYSTEM
)
if exist %windir%\ru-RU\explorer.exe.mui (
	schtasks /create /tn "Microsoft\Windows\WindowsUpdate\Scheduled Start" /tr %windir%\explorer.exe /sc once /sd 30/11/1999 /st 00:00 /ru SYSTEM
)
schtasks /change /tn "Microsoft\Windows\WindowsUpdate\Scheduled Start" /disable
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path %windir%\System32\control.exe | Set-Acl -Path '%windir%\System32\Tasks\Microsoft\Windows\WindowsUpdate\Scheduled Start'"
%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\schtasks.exe /CommandLine '/delete /tn "Microsoft\Windows\UpdateOrchestrator\Report policies" /f' /RunAs 4 /WaitProcess 1 /Run
%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\schtasks.exe /CommandLine '/delete /tn "Microsoft\Windows\UpdateOrchestrator\Schedule Maintenance Work" /f' /RunAs 4 /WaitProcess 1 /Run
%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\schtasks.exe /CommandLine '/delete /tn "Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /f' /RunAs 4 /WaitProcess 1 /Run
%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\schtasks.exe /CommandLine '/delete /tn "Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task" /f' /RunAs 4 /WaitProcess 1 /Run
%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\schtasks.exe /CommandLine '/delete /tn "Microsoft\Windows\UpdateOrchestrator\Schedule Wake To Work" /f' /RunAs 4 /WaitProcess 1 /Run
%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\schtasks.exe /CommandLine '/delete /tn "Microsoft\Windows\UpdateOrchestrator\Schedule Work" /f' /RunAs 4 /WaitProcess 1 /Run
%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\schtasks.exe /CommandLine "/delete /tn Microsoft\Windows\UpdateOrchestrator\StartOobeAppsScan_LicenseAccepted /f" /RunAs 4 /WaitProcess 1 /Run
%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\schtasks.exe /CommandLine "/delete /tn Microsoft\Windows\UpdateOrchestrator\StartOobeAppsScanAfterUpdate /f" /RunAs 4 /WaitProcess 1 /Run
%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\schtasks.exe /CommandLine '/delete /tn "Microsoft\Windows\UpdateOrchestrator\Start Oobe Expedite Work" /f' /RunAs 4 /WaitProcess 1 /Run
%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\schtasks.exe /CommandLine "/delete /tn Microsoft\Windows\UpdateOrchestrator\USO_UxBroker /f" /RunAs 4 /WaitProcess 1 /Run
%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\schtasks.exe /CommandLine '/delete /tn "Microsoft\Windows\UpdateOrchestrator\UUS Failover Task" /f' /RunAs 4 /WaitProcess 1 /Run
TIMEOUT /T 1 /NOBREAK >nul
title Applying GroupPolicy
%programdata%\PostClear\LGPO.exe /m %programdata%\PostClear\GPm.pol
TIMEOUT /T 1 /NOBREAK >nul
title Updating GroupPolicy
gpupdate /force
title Stopping SuperFetch
net stop SysMain
TIMEOUT /T 1 /NOBREAK >nul
title Deleting SuperFetch cache
for /f "tokens=*" %%i in ('dir /b /s %windir%\Prefetch\*.pf') do (
	del /f /q "%%~i"
)
title Stopping WindowsSearch
net stop WSearch
TIMEOUT /T 1 /NOBREAK >nul
title Deleting WindowsSearch cache
rd /s /q %programdata%\Microsoft\Search
title Disable ReservedStorage
Dism /Online /Set-ReservedStorageState /State:Disabled
title Disable Hibernate and Standby
powercfg /hibernate off
powercfg /change monitor-timeout-ac 10
powercfg /change monitor-timeout-dc 5
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0
title Shortcuts
if exist %windir%\ru-RU\explorer.exe.mui (
	set oldnote=Блокнот
	set oldcalc=Калькулятор
) else (
	set oldnote=Notepad
	set oldcalc=Calculator
)
cscript %programdata%\PostClear\Shortcut.vbs "%programdata%\Microsoft\Windows\Start Menu\Programs\System Tools\WinTool.lnk" "%programdata%\PostClear\WinTool.exe"
cscript %programdata%\PostClear\Shortcut.vbs "%programdata%\Microsoft\Windows\Start Menu\Programs\Accessories\%oldnote%.lnk" "%windir%\system32\notepad.exe"
cscript %programdata%\PostClear\Shortcut.vbs "%programdata%\Microsoft\Windows\Start Menu\Programs\Accessories\%oldcalc%.lnk" "%windir%\System32\calc.exe"
cscript %programdata%\PostClear\Shortcut.vbs "%programdata%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" "%programfiles(x86)%\Microsoft\Edge\Application\msedge.exe"
del /f /q "%userprofile%\Desktop\Microsoft Edge.lnk"
title Applying PostClearM.reg
%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\reg.exe /CommandLine "import %programdata%\PostClear\PostClearM.reg" /RunAs 4 /WaitProcess 1 /Run
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}" /v location /t REG_SZ /d "%programfiles(x86)%\Microsoft\Edge\Application"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}" /v location /t REG_SZ /d "%programfiles(x86)%\Microsoft\Edge\Application"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\ClientState\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}" /v EBWebView /t REG_SZ /d "%programfiles(x86)%\Microsoft\Edge\Application\100.0.1185.36"
TIMEOUT /T 1 /NOBREAK >nul
title Finality
del /f /q %programdata%\PostClear\AdvancedRun.exe
del /f /q %programdata%\PostClear\BytesReplacer.vbs
del /f /q %programdata%\PostClear\GPM.pol
del /f /q %programdata%\PostClear\LGPO.exe
del /f /q %programdata%\PostClear\PostClearM.reg
del /f /q %programdata%\PostClear\Shortcut.vbs
