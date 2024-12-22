$Host.UI.RawUI.WindowTitle = 'Remove all revisions except Pro'
if ([System.IO.File]::Exists("Z:\EN.txt"))
{
	dism /delete-image /imagefile:Z:\install.wim /index:10
	dism /delete-image /imagefile:Z:\install.wim /index:9
	dism /delete-image /imagefile:Z:\install.wim /index:8
	dism /delete-image /imagefile:Z:\install.wim /index:7
	dism /delete-image /imagefile:Z:\install.wim /index:6
	dism /delete-image /imagefile:Z:\install.wim /index:4
	dism /delete-image /imagefile:Z:\install.wim /index:3
	dism /delete-image /imagefile:Z:\install.wim /index:2
	dism /delete-image /imagefile:Z:\install.wim /index:1
}
else
{
	dism /delete-image /imagefile:Z:\install.wim /index:5
	dism /delete-image /imagefile:Z:\install.wim /index:4
	dism /delete-image /imagefile:Z:\install.wim /index:2
	dism /delete-image /imagefile:Z:\install.wim /index:1
}

$Host.UI.RawUI.WindowTitle = 'Mounting install.wim'
mkdir Z:\Install
dism /mount-image /imagefile:Z:\install.wim /index:1 /mountdir:Z:\Install

$Host.UI.RawUI.WindowTitle = 'Adding a response file'
mkdir Z:\Install\Windows\Panther
move Z:\unattend.xml Z:\Install\Windows\Panther

$Host.UI.RawUI.WindowTitle = 'Removing capability'
dism /image:Z:\Install /remove-capability /capabilityname:App.StepsRecorder~~~~0.0.1.0
dism /image:Z:\Install /remove-capability /capabilityname:Hello.Face.20134~~~~0.0.1.0
dism /image:Z:\Install /remove-capability /capabilityname:MathRecognizer~~~~0.0.1.0
dism /image:Z:\Install /remove-capability /capabilityname:OneCoreUAP.OneSync~~~~0.0.1.0

$Host.UI.RawUI.WindowTitle = 'Toggle features'
$letters=@("D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")
foreach ($letter in $letters) {
	if ([System.IO.File]::Exists($letter+":\sources\install.wim"))
	{
		$found=$letter+":\sources\sxs\"
	}
}
dism /image:Z:\Install /enable-feature /featurename:NetFx3 /all /source:$found /limitaccess
dism /image:Z:\Install /enable-feature /featurename:DirectPlay /all /source:$found /limitaccess
dism /image:Z:\Install /disable-feature /featurename:Windows-Defender-Default-Definitions

$Host.UI.RawUI.WindowTitle = 'Removing Pre-Installation Packages'
$apps=@(
"Clipchamp.Clipchamp_3.0.10220.0_neutral_~_yxz26nhyzhsrt",
"Microsoft.ApplicationCompatibilityEnhancements_1.2401.10.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.BingNews_4.1.24002.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.BingSearch_2022.0.79.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.BingWeather_4.53.52892.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.GamingApp_2024.311.2341.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.GetHelp_10.2302.10601.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.MicrosoftOfficeHub_18.2308.1034.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.MicrosoftSolitaireCollection_4.19.3190.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.MicrosoftStickyNotes_4.6.2.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.OutlookForWindows_1.0.0.0_neutral__8wekyb3d8bbwe",
"Microsoft.PowerAutomateDesktop_11.2401.28.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.StorePurchaseApp_22312.1400.6.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.Todos_2.104.62421.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.Windows.DevHome_0.100.128.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.Windows.Photos_24.24010.29003.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsAlarms_2022.2312.2.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsCalculator_2021.2311.0.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsCamera_2022.2312.3.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsFeedbackHub_2024.125.1522.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsNotepad_11.2312.18.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsSoundRecorder_2021.2312.5.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsStore_22401.1400.6.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsTerminal_3001.18.10301.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.Xbox.TCUI_1.23.28005.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.XboxGamingOverlay_2.624.1111.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.XboxIdentityProvider_12.110.15002.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.XboxSpeechToTextOverlay_1.97.17002.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.YourPhone_1.24012.105.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.ZuneMusic_11.2312.8.0_neutral_~_8wekyb3d8bbwe",
"MicrosoftCorporationII.QuickAssist_2024.309.159.0_neutral_~_8wekyb3d8bbwe",
"MicrosoftWindows.CrossDevice_1.23101.22.0_neutral_~_cw5n1h2txyewy",
"MSTeams_1.0.0.0_x64__8wekyb3d8bbwe"
)
foreach ($app in $apps) {
	$Host.UI.RawUI.WindowTitle = 'Remove package: ' + $app
	dism /image:Z:\Install /remove-provisionedappxpackage /packagename:$app
}
