#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_HiDpi=y
#AutoIt3Wrapper_Res_Comment=
#AutoIt3Wrapper_Res_Description=
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <MetroGUI-UDF\MetroGUI_UDF.au3>
#include <MetroGUI-UDF\_GUIDisable.au3>
#include <GUIConstants.au3>
#include <String.au3>
#include <Array.au3>
#include <ColorConstants.au3>
#include <TrayConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <InetConstants.au3>
#include <GuiButton.au3>
#include <Misc.au3>
#include <playhide\functions.au3>
#traymenu()
_Metro_EnableHighDPIScaling()
Opt("TrayMenuMode",3)
$AppName = "PlayHide VPN"
$UpdaterVersionFile = ".\version.ini"
Global $ReadVersion = IniRead($UpdaterVersionFile, "Version", "Version", "")

Global $SettingsFile = @ScriptDir & "\Settings.ini"
Global $Language = IniRead($SettingsFile, "Settings", "Language", "")
Global $CheckUpdateSetting = IniRead($SettingsFile, "Settings", "CheckUpdate", "")
Global $SetupDone = IniRead($SettingsFile, "Settings", "Setup", "")
Global $LogSetting = IniRead($SettingsFile, "Settings", "Log", "")
Global $LanguageFile = @ScriptDir & "\lang\" & $Language & ".ini"
Global $CustomServerListEnabled = IniRead($SettingsFile, "Settings", "CustomList", "")
if $CustomServerListEnabled = 1 Then
Global $ServerList = @ScriptDir & "\config\servers_custom.ini"
Else
Global $ServerList = @ScriptDir & "\config\servers.ini"
EndIf	
Global $ServerSaved = IniRead($SettingsFile, "Settings", "Server", "")
Global $ServerIP = IniRead($ServerList, $ServerSaved, "IP", "")
Global $ServerPort = IniRead($ServerList, $ServerSaved, "Port", "")
Global $ServerProto = IniRead($ServerList, $ServerSaved, "Protocol", "")
Global $ServerDev = IniRead($ServerList, $ServerSaved, "Interface", "")
Global $ServerSubnet = IniRead($ServerList, $ServerSaved, "Subnet", "")
Global $ServerDHCP = IniRead($ServerList, $ServerSaved, "DHCP_Server", "")
Global $ServerCA = IniRead($ServerList, $ServerSaved, "Cert", "")
Global $ServerConfig = IniRead($ServerList, $ServerSaved, "Config", "")
Global $ServerLogin = IniRead($ServerList, $ServerSaved, "Login", "")
Global $LoginFile =  ".\config\" & $ServerLogin
If $LogSetting >0 then
DirCreate(".\logs")
Global $ParamsLog = "--verb " & $LogSetting & " --log-append .\logs\openvpn.log"
else
Global $ParamsLog = ""
EndIf
Global $Params = "--client --nobind --resolv-retry infinite --persist-key --persist-tun --auth-nocache --remote-cert-tls server --mute-replay-warnings " & $ParamsLog
Global $ConnectSetup = @ComSpec & " /c " & 'bin\openvpn.exe ' & $Params & ' --remote ' & $ServerIP & ' ' & $ServerPort & ' --ca .\certs\' & $ServerCA & ' --dev ' & $ServerDev & ' --proto ' & $ServerProto & ' --config .\config\' & $ServerConfig & ' --auth-user-pass ' & $LoginFile
Global $Connect = $ConnectSetup & ' --dev-node "' & $AppName & '"'
Global $ChatSetting = IniRead($SettingsFile, "Settings", "Chat", "")
Global $AuthSetting = IniRead($SettingsFile, "Settings", "Auth", "")

#include <playhide\strings.au3>

TraySetState(16)
TraySetToolTip ($AppName)
Local $sFile = "icon.ico"
TraySetIcon($sFile)
_SetTheme("DarkPlayHide")

#include <playhide\checkupdate.au3>

If $SetupDone = 0 then
   If Not IsAdmin() Then
			_Metro_MsgBox(0, $String_error, $String_start_msg)
						Exit
					 else
#include <playhide\auth.au3>
#include <playhide\setup.au3>

		else
		if _Singleton($Appname, 1) = 0 Then
	      	_Metro_MsgBox($MB_SYSTEMMODAL, $String_error, $String_start_msg2)
    		Exit
		EndIf
		If ProcessExists("openvpn.exe") Then
       		_Metro_MsgBox($MB_SYSTEMMODAL, $String_error, $String_start_msg3)
   			Exit
		EndIf
			Local $hTimer = TimerInit()
			$Form1 = _Metro_CreateGUI($AppName, 250, 200, -1, -1, true,false)
			$Control_Buttons = _Metro_AddControlButtons(False,False,True,False,True)
			$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
			$GUI_MENU_BUTTON = $Control_Buttons[6]
			GUISetIcon($sFile)
			GUICtrlCreateLabel($AppName, 50, 7, 80, 30)
			GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
			GUICtrlSetColor(-1, 0xFFFFFF)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			Local $LabelShowIP = GUICtrlCreateLabel($String_not_connected, 150, 150, 300, 30)
			GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
			GUICtrlSetColor(-1, 0xFFFFFF)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlCreateLabel($AppName, 65, 40, 300, 30)
			GUICtrlSetFont(-1, 14, Default, Default, "Segoe UI Light", 5)
			GUICtrlSetColor(-1, 0xFFFFFF)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			$ButtonConnect = _Metro_CreateButtonEx2($String_connect, 70, 85, 99, 50, $ButtonBKColor)
			$ButtonDisconnect = _Metro_CreateButtonEx2($String_disconnect, 70, 85, 99, 50, $ButtonBKColor)
			GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
			$ShowServerLabel = GUICtrlCreateLabel("Server: " & $ServerSaved, 150, 170, 300, 30)
			GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
			GUICtrlSetColor(-1, 0xFFFFFF)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			$link = GUICtrlCreateLabel("Vers: " & $ReadVersion & " / " & $String_website, 10, 170, 300, 30)
			GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
			GUICtrlSetColor(-1, 0xFFFFFF)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

#include <playhide\tray.au3>
#include <playhide\autoconnect.au3>
EndIf

While 1
#include <playhide\switches_ui.au3>
#include <playhide\switches_tray.au3>
#include <playhide\timer.au3>
WEnd