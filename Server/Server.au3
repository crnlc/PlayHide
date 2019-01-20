DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1)
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so /rm /pe
#Au3Stripper_Ignore_Funcs=_iHoverOn,_iHoverOff,_iFullscreenToggleBtn,_cHvr_CSCP_X64,_cHvr_CSCP_X86,_iControlDelete
#AutoIt3Wrapper_Res_HiDpi=y
#include "MetroGUI-UDF\MetroGUI_UDF.au3"
#include "MetroGUI-UDF\_GUIDisable.au3"
#include <GUIConstants.au3>
#include <String.au3>
#include <Array.au3>
#include <ColorConstants.au3>
#include <TrayConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPIFiles.au3>
#include <InetConstants.au3>
#include <GuiButton.au3>
#include <Misc.au3>
#traymenu()
_Metro_EnableHighDPIScaling()
Opt("TrayMenuMode",3)
$AppName = "PlayHide VPN - Server"


TraySetState(16)
TraySetToolTip ($AppName)
Local $sFile = "icon.ico"
TraySetIcon($sFile)
_SetTheme("DarkPlayHide")

Global $OpenVPNExe = "openvpn_server.exe"
Global $SettingsFile = ".\Settings.ini"
Global $Language = IniRead($SettingsFile, "Settings", "Language", "")
Global $CheckUpdateSetting = IniRead($SettingsFile, "Settings", "CheckUpdate", "")
Global $LanguageFile = ".\lang\" & $Language & ".ini"
Global $ServerIP = IniRead($SettingsFile, "Server", "IP", "")
Global $ServerPort = IniRead($SettingsFile, "Server", "Port", "")
Global $ServerProto = IniRead($SettingsFile, "Server", "Protocol", "")
Global $ServerDev = IniRead($SettingsFile, "Server", "Interface", "")
Global $ServerSubnet = IniRead($SettingsFile, "Server", "Subnet", "")
Global $ServerSubnetMask = IniRead($SettingsFile, "Server", "SubnetMask", "")
Global $ServerStartRange = IniRead($SettingsFile, "Server", "StartRange", "")
Global $ServerEndRange = IniRead($SettingsFile, "Server", "EndRange", "")
Global $ServerCA = IniRead($SettingsFile, "Server", "Cert", "")
Global $AdapterName = IniRead($SettingsFile, "Server", "AdapterName", "")
Global $Params = "--mode server --tls-server --resolv-retry infinite --keepalive 10 60 --reneg-sec 432000 --persist-key --persist-tun --client-cert-not-required --cipher AES-128-CBC --client-to-client --username-as-common-name --compress lz4-v2 --duplicate-cn --remote-cert-tls server --verb 0 --mute-replay-warnings --ca .\certs\server\ca.crt --cert .\certs\server\server.crt --key .\certs\server\server.key --dh .\certs\server\dh2048.pem --script-security 3 --auth-user-pass-verify .\config\auth.bat via-env"
Global $Connect = @ComSpec & " /c " & 'bin32\' & $OpenVPNExe & ' ' & $Params & ' --server-bridge ' & $ServerIP & ' 255.255.255.0 ' & $ServerSubnet & $ServerStartRange & ' ' & $ServerSubnet & $ServerEndRange & ' --port ' & $ServerPort & ' --proto ' & $ServerProto & ' --dev ' & $ServerDev & ' --config .\config\server.ovpn' & ' --dev-node "' & $AdapterName & '"' & ' --ifconfig ' & $ServerIP & ' ' & $ServerSubnetMask

### Language Strings
Global $String_ok = IniRead($LanguageFile, "Strings", "ok", "")
Global $String_done = IniRead($LanguageFile, "Strings", "done", "")
Global $String_success = IniRead($LanguageFile, "Strings", "success", "")
Global $String_complete = IniRead($LanguageFile, "Strings", "complete", "")
Global $String_username = IniRead($LanguageFile, "Strings", "username", "")
Global $String_password = IniRead($LanguageFile, "Strings", "password", "")
Global $String_website = IniRead($LanguageFile, "Strings", "website", "")
Global $String_error = IniRead($LanguageFile, "Strings", "error", "")
Global $String_error_msg = IniRead($LanguageFile, "Strings", "error_msg", "")
Global $String_setup_info = IniRead($LanguageFile, "Strings", "setup_info", "")
Global $String_setup_msg = IniRead($LanguageFile, "Strings", "setup_msg", "")
Global $String_setup_msg2 = IniRead($LanguageFile, "Strings", "setup_msg2", "")
Global $String_setup_success = IniRead($LanguageFile, "Strings", "setup_success", "")
Global $String_setup_success_msg = IniRead($LanguageFile, "Strings", "setup_success_msg", "")
Global $String_setup_failed = IniRead($LanguageFile, "Strings", "setup_failed", "")
Global $String_start_msg = IniRead($LanguageFile, "Strings", "start_msg", "")
Global $String_start_msg2 = IniRead($LanguageFile, "Strings", "start_msg2", "")
Global $String_start_msg3 = IniRead($LanguageFile, "Strings", "start_msg3", "")
Global $String_info = IniRead($LanguageFile, "Strings", "info", "")
Global $String_connect = IniRead($LanguageFile, "Strings", "connect", "")
Global $String_connected = IniRead($LanguageFile, "Strings", "connected", "")
Global $String_not_connected = IniRead($LanguageFile, "Strings", "not_connected", "")
Global $String_disconnect = IniRead($LanguageFile, "Strings", "disconnect", "")
Global $String_open = IniRead($LanguageFile, "Strings", "open", "")
Global $String_login = IniRead($LanguageFile, "Strings", "login", "")
Global $String_exit = IniRead($LanguageFile, "Strings", "exit", "")
Global $String_close = IniRead($LanguageFile, "Strings", "close", "")
Global $String_apply = IniRead($LanguageFile, "Strings", "apply", "")
Global $String_language = IniRead($LanguageFile, "Strings", "language", "")
Global $String_server_switched = IniRead($LanguageFile, "Strings", "server_switched", "")
Global $String_lang_switched = IniRead($LanguageFile, "Strings", "lang_switched", "")
Global $String_client_ping = IniRead($LanguageFile, "Strings", "client_ping", "")
Global $String_client_ping_failed = IniRead($LanguageFile, "Strings", "client_ping_failed", "")
Global $String_client_ping_info = IniRead($LanguageFile, "Strings", "client_ping_info", "")
Global $String_connection_error = IniRead($LanguageFile, "Strings", "connection_error", "")
Global $String_determine_ip = IniRead($LanguageFile, "Strings", "determine_ip", "")
Global $String_login_wrong = IniRead($LanguageFile, "Strings", "login_wrong", "")
Global $String_shortcut = IniRead($LanguageFile, "Strings", "shortcut", "")
Global $String_shortcut_info = IniRead($LanguageFile, "Strings", "shortcut_info", "")
Global $String_shortcut_info2 = IniRead($LanguageFile, "Strings", "shortcut_info2", "")
Global $String_autostart = IniRead($LanguageFile, "Strings", "autostart", "")
Global $String_autostart_info = IniRead($LanguageFile, "Strings", "autostart_info", "")
Global $String_autostart_info2 = IniRead($LanguageFile, "Strings", "autostart_info2", "")
Global $String_autoconnect = IniRead($LanguageFile, "Strings", "autoconnect", "")
Global $String_autoconnect_info = IniRead($LanguageFile, "Strings", "autoconnect_info", "")
Global $String_autoconnect_info2 = IniRead($LanguageFile, "Strings", "autoconnect_info2", "")
Global $String_network = IniRead($LanguageFile, "Strings", "network", "")
Global $String_scanner_msg = IniRead($LanguageFile, "Strings", "scanner_msg", "")

Func RestartScript()
    If @Compiled = 1 Then
        Run( FileGetShortName(@ScriptFullPath))
    Else
        Run( FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
    EndIf
    Exit
 EndFunc

Func _Metro_InputBox2($Promt, $Font_Size = 11, $DefaultText = "", $PW = False, $EnableEnterHotkey = True, $ParentGUI = "")
	Local $Metro_Input, $Metro_Input_GUI
	If $ParentGUI = "" Then
		$Metro_Input_GUI = _Metro_CreateGUI($Promt, 460, 170, -1, -1, False)
	Else
		$Metro_Input_GUI = _Metro_CreateGUI(WinGetTitle($ParentGUI, "") & ".Input", 460, 170, -1, -1, False, $ParentGUI)
	EndIf
	_Metro_SetGUIOption($Metro_Input_GUI, True)
	GUICtrlCreateLabel($Promt, 3 * $gDPI, 3 * $gDPI, 454 * $gDPI, 60 * $gDPI, BitOR(0x1, 0x0200), 0x00100000)
	GUICtrlSetFont(-1, $Font_Size, 400, 0, "Segoe UI")
	GUICtrlSetColor(-1, $FontThemeColor)
	If $PW Then
		$Metro_Input = GUICtrlCreateInput($DefaultText, 16 * $gDPI, 75 * $gDPI, 429 * $gDPI, 28 * $gDPI, 32)
	Else
		$Metro_Input = GUICtrlCreateInput($DefaultText, 16 * $gDPI, 75 * $gDPI, 429 * $gDPI, 28 * $gDPI)
	EndIf
	GUICtrlSetFont(-1, 11, 500, 0, "Segoe UI")

	GUICtrlSetState($Metro_Input, 256)
	Local $cEnter = GUICtrlCreateDummy()
	Local $aAccelKeys[1][2] = [["{ENTER}", $cEnter]]
	Local $Button_Continue = _Metro_CreateButtonEx2("OK", 170, 120, 100, 36, $ButtonBKColor, $ButtonTextColor, "Segoe UI")
	GUICtrlSetState($Button_Continue, 512)

	GUISetState(@SW_SHOW)

	If $EnableEnterHotkey Then
		GUISetAccelerators($aAccelKeys, $Metro_Input_GUI)
	EndIf

	If $mOnEventMode Then Opt("GUIOnEventMode", 0) ;Temporarily deactivate oneventmode

	While 1
		$input_nMsg = GUIGetMsg()
		Switch $input_nMsg
			Case $Button_Continue, $cEnter
				Local $User_Input = GUICtrlRead($Metro_Input)
				If Not ($User_Input = "") Then
					_Metro_GUIDelete($Metro_Input_GUI)
					If $mOnEventMode Then Opt("GUIOnEventMode", 1) ;Reactivate oneventmode
					Return $User_Input
				EndIf
		EndSwitch
	WEnd
 EndFunc   ;==>_Metro_InputBox

if _Singleton($Appname, 1) = 0 Then
	       _Metro_MsgBox($MB_SYSTEMMODAL, $String_error, $String_start_msg2)
    Exit
 EndIf

Local $hTimer = TimerInit()
$Form1 = _Metro_CreateGUI($AppName, 250, 200, -1, -1, true,false)
$Control_Buttons = _Metro_AddControlButtons(False,False,True,False,True)
#$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
$GUI_MENU_BUTTON = $Control_Buttons[6]
GUISetIcon($sFile)
GUICtrlCreateLabel($AppName, 50, 7, 300, 30)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
Local $LabelShowIP = GUICtrlCreateLabel($String_not_connected, 150, 170, 300, 30)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreateLabel($AppName, 40, 40, 300, 30)
GUICtrlSetFont(-1, 14, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$ButtonConnect = _Metro_CreateButtonEx2($String_connect, 70, 85, 99, 50, $ButtonBKColor)
$ButtonDisconnect = _Metro_CreateButtonEx2($String_disconnect, 70, 85, 99, 50, $ButtonBKColor)
GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
$UpdaterVersionFile = @ScriptDir & "\updater.ini"
$ReadVersion = IniRead($UpdaterVersionFile, "Version", "Version", "")
$link = GUICtrlCreateLabel("Vers: " & $ReadVersion & " / " & $String_website, 10, 170, 300, 30)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
       Local $iStatus = TrayCreateItem($String_not_connected)
TrayItemSetState ($iStatus, $TRAY_DISABLE)
TrayCreateItem("") ; Create a separator line.
       Local $iOpen = TrayCreateItem($String_open)

	   TrayCreateItem("") ; Create a separator line.
    Local $iAutoConnect = TrayCreateItem($String_autoconnect, -1, -1, $TRAY_ITEM_NORMAL)
			 TrayItemSetState ($iAutoConnect, $TRAY_UNCHECKED)
   Local $iAutostart = TrayCreateItem($String_autostart)
   Local $iDesktopIcon = TrayCreateItem($String_shortcut)
   if FileExists(@DesktopDir & "\" & $AppName & ".lnk") Then
			TrayItemSetState ($iDesktopIcon, $TRAY_DISABLE)
			Else
			TrayItemSetState ($iDesktopIcon, $TRAY_ENABLE)
			EndIf
    TrayCreateItem("") ; Create a separator line.
    Local $iWebsite = TrayCreateItem("Vers: " & $ReadVersion & " / " & $String_website, -1, -1, $TRAY_ITEM_NORMAL)
    Local $idExit = TrayCreateItem($String_close)
			 GUISetState(@SW_SHOW)

   $AutoConnectSetting = IniRead($SettingsFile, "Settings", "AutoConnect", "")
If $AutoConnectSetting >0 then
		 TrayItemSetState ($iAutoConnect, $TRAY_CHECKED)
		 Run($Connect, "", @SW_HIDE)
		 GUICtrlSetState($ButtonConnect, $GUI_HIDE)
		 GUICtrlSetState($ButtonDisconnect, $GUI_SHOW)
		 TraySetState(1)
		 GUISetState(@SW_HIDE, $Form1)
		 sleep(1000)
				If ProcessExists($OpenVPNExe) Then
		 GUICtrlSetData($LabelShowIP,$String_determine_ip)
		 TrayItemSetText($iStatus, $String_determine_ip)
		 TrayTip($String_connected, 'IP: ' & $ServerIP, 3, $TIP_ICONASTERISK)
	  Else
		 TrayItemSetState ($iAutoConnect, $TRAY_UNCHECKED)
		 TrayItemSetText($iStatus, $String_not_connected)
		 GUICtrlSetData($LabelShowIP,$String_not_connected)
		 ProcessClose($OpenVPNExe)
		 GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
		 GUICtrlSetState($ButtonConnect, $GUI_SHOW)
		 GUISetState(@SW_SHOW)
	  EndIf
	  EndIf
Func LanguageList()
			$GUIServer = _Metro_CreateGUI($AppName, 160, 80, -1, -1, false,false)
			#$ContentList = IniReadSectionNames($ServerList)
			$English = "en"
			$German = "de"
			$LangList = $German & "|" & $English
			$Chooser = GUICtrlCreateCombo("", 30, 15, 99, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData($Chooser, $LangList,$English)
			$ButtonServerOK = _Metro_CreateButtonEx2($String_apply, 40, 40, 80, 30, $ButtonBKColor)
			GUICtrlSetState($Chooser, $GUI_SHOW)
			GUISetState(@SW_SHOW, $GUIServer)
While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
	Case $ButtonServerOK
	  $ChooserPick = GUICtrlRead($Chooser)
	  IniWrite($SettingsFile, "Settings", "Language", $ChooserPick)
	      _Metro_MsgBox($MB_SYSTEMMODAL, $String_info, $String_lang_switched)
				_GUIDisable($GUIServer)
		 _Metro_GUIDelete($GUIServer)
		 ProcessClose($OpenVPNExe)
		 RestartScript()
		 Exit
	  EndSwitch
	  WEnd
   EndFunc


While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
			   Case $GUI_MINIMIZE_BUTTON
			   TraySetState(1)
			   GUISetState(@SW_HIDE, $Form1)
			Case $link
            ShellExecute("http://playhide.tk")

		 Case $ButtonConnect
		 Run($Connect, "", @SW_HIDE)
		 GUICtrlSetState($ButtonConnect, $GUI_HIDE)
		 GUICtrlSetState($ButtonDisconnect, $GUI_SHOW)
		 sleep(500)
				If ProcessExists($OpenVPNExe) Then
		 TrayItemSetText($iStatus, $String_determine_ip)
		 GUICtrlSetData($LabelShowIP,$String_determine_ip)
	  Else
		 ProcessClose($OpenVPNExe)
		 GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
		 GUICtrlSetState($ButtonConnect, $GUI_SHOW)
		 GUICtrlSetData($LabelShowIP,$String_not_connected)
		 TrayItemSetText($iStatus, $String_not_connected)
		 _GUIDisable($Form1, 0, 30)
		 _Metro_MsgBox($MB_SYSTEMMODAL, $String_error, $String_connection_error)
				_GUIDisable($Form1)
EndIf
		         Case $ButtonDisconnect
				  ProcessClose($OpenVPNExe)
		 		  GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
		 		  GUICtrlSetState($ButtonConnect, $GUI_SHOW)
				  GUICtrlSetData($LabelShowIP,$String_not_connected)
				  TrayItemSetText($iStatus, $String_not_connected)

		Case $GUI_MENU_BUTTON
		 Local $MenuButtonsArray[5] = [$String_language, $String_network, $String_close]
			Local $MenuSelect = _Metro_MenuStart($Form1, 150, $MenuButtonsArray)
			Switch $MenuSelect
			   Case "0"
					 LanguageList()
				  Case "1"
			   run(".\bin32\network-scan.exe")
				Case "2"
					 ProcessClose($OpenVPNExe)
					_Metro_GUIDelete($Form1)
					Exit
			EndSwitch

			 		  EndSwitch

        Switch TrayGetMsg()
            Case $idExit
			   		 ProcessClose($OpenVPNExe)
		 _Metro_GUIDelete($Form1)
		 Exit

		  Case $iWebsite
			   ShellExecute("http://playhide.tk")

		 Case $iDesktopIcon
			if Not FileExists(@DesktopDir & "\" & $AppName & ".lnk") Then
			FileCreateShortcut(@AutoItExe, @DesktopDir & "\" & $AppName & ".lnk", @ScriptDir)
			_GUIDisable($Form1, 0, 30)
			_Metro_MsgBox($MB_SYSTEMMODAL, $String_info, $String_shortcut_info)
			_GUIDisable($Form1)
					 else
			_GUIDisable($Form1, 0, 30)
			_Metro_MsgBox($MB_SYSTEMMODAL, $String_info, $String_shortcut_info2)
			_GUIDisable($Form1)
		 EndIf

		 Case $iAutostart
			if Not FileExists(@StartupDir & "\" & $AppName & ".lnk") Then
			FileCreateShortcut(@AutoItExe, @StartupDir & "\" & $AppName & ".lnk", @ScriptDir)
			_GUIDisable($Form1, 0, 30)
			_Metro_MsgBox($MB_SYSTEMMODAL, $String_info, $String_autostart_info)
			_GUIDisable($Form1)
		 else
			FileDelete(@StartupDir & "\" &  $AppName & ".lnk")
			_GUIDisable($Form1, 0, 30)
			_Metro_MsgBox($MB_SYSTEMMODAL, $String_info, $String_autostart_info2)
			_GUIDisable($Form1)
			EndIf
		  Case $iAutoConnect
			 if $AutoConnectSetting >0 Then
			   IniWrite($SettingsFile, "Settings", "AutoConnect", "0")
			   _GUIDisable($Form1, 0, 30)
			   _Metro_MsgBox($MB_SYSTEMMODAL, $String_info, $String_autoconnect_info)
				_GUIDisable($Form1)
			 else
				 IniWrite($SettingsFile, "Settings", "AutoConnect", "1")
				 			      		   			_GUIDisable($Form1, 0, 30)
			   _Metro_MsgBox($MB_SYSTEMMODAL, $String_info, $String_autoconnect_info2)
				_GUIDisable($Form1)
			 EndIf
   Case $iOpen
$ok = GUISetState(@SW_SHOW)
	  EndSwitch

		 If TimerDiff($hTimer) > 5*1000 Then
		 $Timer = TimerInit()
		 If ProcessExists($OpenVPNExe) Then
		 TrayItemSetText($iStatus, 'IP: ' & $ServerIP)
		 GUICtrlSetData($LabelShowIP,'IP: ' & $ServerIP)
	  Else
GUICtrlSetData($LabelShowIP,$String_not_connected)
TrayItemSetText($iStatus, $String_not_connected)
	  EndIf
	  		 Local $hTimer = TimerInit()
		  EndIf

WEnd