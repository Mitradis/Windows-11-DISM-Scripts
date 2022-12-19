reg export %1\shellex\ContextMenuHandlers Z:\_temp.reg /y
Z:\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\reg.exe /CommandLine "delete %1\shellex\ContextMenuHandlers /f" /RunAs 8 /WaitProcess 1 /Run
Z:\PostClear\AdvancedRun.exe /EXEFilename Z:\SubinAcl.exe  /CommandLine "/keyreg %1\shellex /grant=S-1-5-18=F" /RunAs 8 /WaitProcess 1 /Run
Z:\PostClear\AdvancedRun.exe /EXEFilename Z:\SubinAcl.exe  /CommandLine "/keyreg %1\shellex /grant=S-1-5-32-544=F" /RunAs 8 /WaitProcess 1 /Run
reg import Z:\_temp.reg
del /f /q Z:\_temp.reg
