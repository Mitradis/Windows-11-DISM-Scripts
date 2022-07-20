# Remove all revisions except Pro
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
# Mounting
mkdir Z:\Install
dism /mount-image /imagefile:Z:\install.wim /index:1 /mountdir:Z:\Install
# Adding a response file
mkdir Z:\Install\Windows\Panther
move Z:\unattend.xml Z:\Install\Windows\Panther
# Removing components
dism /image:Z:\Install /remove-capability /capabilityname:App.StepsRecorder~~~~0.0.1.0
dism /image:Z:\Install /remove-capability /capabilityname:App.Support.QuickAssist~~~~0.0.1.0
dism /image:Z:\Install /remove-capability /capabilityname:Hello.Face.20134~~~~0.0.1.0
dism /image:Z:\Install /remove-capability /capabilityname:MathRecognizer~~~~0.0.1.0
dism /image:Z:\Install /remove-capability /capabilityname:OneCoreUAP.OneSync~~~~0.0.1.0
$letters=@("D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")
foreach ($letter in $letters) {
	if ([System.IO.File]::Exists($letter+":\sources\install.wim"))
	{
		$found=$letter+":\sources\sxs\"
	}
}
# Installation .NET Framework 3.5
dism /image:Z:\Install /enable-feature /featurename:NetFx3 /all /source:$found /limitaccess
# Activation Direct Play
dism /image:Z:\Install /enable-feature /featurename:DirectPlay /all /source:$found /limitaccess
# Removing Pre-Installation Packages
$apps=@(
"Microsoft.549981C3F5F10_2.2106.2807.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.BingNews_4.7.28001.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.BingWeather_4.9.2002.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.GamingApp_2021.427.138.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.GetHelp_10.2008.32311.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.Getstarted_10.2.41172.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.MicrosoftOfficeHub_18.2104.12721.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.MicrosoftSolitaireCollection_4.6.3102.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.MicrosoftStickyNotes_4.1.2.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.People_2020.901.1724.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.PowerAutomateDesktop_10.0.561.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.ScreenSketch_2021.2104.2.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.StorePurchaseApp_12008.1001.113.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.Todos_2.33.33351.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.Windows.Photos_21.21030.25003.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsAlarms_2021.2101.27.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsCalculator_2020.2012.21.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsCamera_2020.503.58.0_neutral_~_8wekyb3d8bbwe",
"microsoft.windowscommunicationsapps_16005.12827.20400.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsFeedbackHub_2021.427.1821.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsMaps_2021.2012.10.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsNotepad_10.2102.13.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsSoundRecorder_2021.2012.41.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.WindowsStore_12104.1001.113.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.Xbox.TCUI_1.23.28002.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.XboxGameOverlay_1.46.11001.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.XboxGamingOverlay_2.50.24002.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.XboxIdentityProvider_12.50.6001.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.XboxSpeechToTextOverlay_1.17.29001.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.YourPhone_2019.430.2026.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.ZuneMusic_2019.21012.10511.0_neutral_~_8wekyb3d8bbwe",
"Microsoft.ZuneVideo_2019.21012.10511.0_neutral_~_8wekyb3d8bbwe"
)
foreach ($app in $apps) {
	dism /image:Z:\Install /remove-provisionedappxpackage /packagename:$app
}
