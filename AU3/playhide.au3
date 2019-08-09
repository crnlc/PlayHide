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
Global $LogSetting = IniRead($SettingsFile, "Settings", "Log", "")
Global $LanguageFile = @ScriptDir & "\lang\" & $Language & ".ini"
Global $ServerList = @ScriptDir & "\config\servers.ini"
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

### Language Strings
Global $String_no = IniRead($LanguageFile, "Strings", "no", "")
Global $String_yes = IniRead($LanguageFile, "Strings", "yes", "")
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
Global $String_setup_msg3 = IniRead($LanguageFile, "Strings", "setup_msg3", "")
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
Global $String_mac_copy = IniRead($LanguageFile, "Strings", "mac_copy", "")

TraySetState(16)
TraySetToolTip ($AppName)
Local $sFile = "icon.ico"
TraySetIcon($sFile)
_SetTheme("DarkPlayHide")
#_SetTheme("DarkTealV2")


#include <playhide\checkupdate.au3>


If Not FileExists($LoginFile) then
   If Not IsAdmin() Then
			_Metro_MsgBox(0, $String_error, $String_start_msg)
						Exit
					 else
#include <playhide\auth.au3>
			RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule name="' & $AppName & '" dir=in action=allow protocol=' & $ServerProto & ' localport=' & $ServerPort , "", @SW_HIDE)
			RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow' , "", @SW_HIDE)
			$Setup = _Metro_MsgBox(0, $String_setup_info, $String_setup_msg)
			$DevResult = Run(@ComSpec & ' /c netsh interface show interface name="' & $AppName & '"', "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
			ProcessWaitClose($DevResult)
			$ReadResultDev = StdoutRead($DevResult)
			$DevExist = StringInStr($ReadResultDev, $AppName)
			if Not $DevExist then
			$osv = @OSVersion
			If $osv = "WIN_7" Then
			RunWait('driver\tap.exe')
			Else
			RunWait('driver\tap-win10.exe')
		EndIf
	EndIf
			Run($ConnectSetup, "", @SW_HIDE)
			_Metro_MsgBox(0, $String_info, $String_setup_msg2)
			Sleep(15000)
			If ProcessExists("openvpn.exe") And Ping($ServerSubnet & "1") Then
			Sleep(100)
			RunWait(@ComSpec & " /c " & 'Powershell.exe -executionpolicy Bypass -File "driver\SetAdapter.ps1" -Subnet ' & $ServerSubnet & '* -Name ' & '"' & $AppName & '"', "", @SW_HIDE)
			RunWait('netsh interface ipv4 set interface "' &  $AppName & '" metric=1')
			ProcessClose("openvpn.exe")
			_Metro_MsgBox($MB_SYSTEMMODAL, $String_success, $String_setup_success_msg)
		    $msg = _Metro_MsgBox (4,$String_info,$String_setup_msg3)
    If $msg = "NO" Then
		ElseIf $msg = "YES" Then
			RunWait(@ComSpec & " /c " & 'net stop server /y', "", @SW_HIDE)
			RunWait(@ComSpec & " /c " & 'regedit.exe /S .\tools\Disable-SMB.reg', "", @SW_HIDE)
			RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=445 name="Block_SMB-445"', "", @SW_HIDE)
			RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=137 name="Block_SMB-137"', "", @SW_HIDE)
			RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=138 name="Block_SMB-138"', "", @SW_HIDE)
			RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=139 name="Block_SMB-139"', "", @SW_HIDE)
			RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=445 name="Block_SMB-445"', "", @SW_HIDE)
			RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=137 name="Block_SMB-137"', "", @SW_HIDE)
			RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=138 name="Block_SMB-138"', "", @SW_HIDE)
			RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=139 name="Block_SMB-139"', "", @SW_HIDE)
		EndIf
		if Not FileExists(@DesktopDir & "\" & $AppName & ".lnk") Then
			FileCreateShortcut(@AutoItExe, @DesktopDir & "\" & $AppName & ".lnk", @ScriptDir)
		else
	EndIf
		 	RestartScript()
			Exit
		else
			_Metro_MsgBox($MB_SYSTEMMODAL, $String_error, $String_setup_failed)
			ProcessClose("openvpn.exe")
			FileDelete ($LoginFile)
   			Exit
		EndIf
	EndIf
			Sleep(1000)
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
       		Local $iStatus = TrayCreateItem($String_not_connected)
			TrayItemSetState ($iStatus, $TRAY_DISABLE)
			TrayCreateItem("") ; Create a separator line.
       		Local $iOpen = TrayCreateItem($String_open)
	   	If $AuthSetting >0 then
	   	   	Local $iLogin = TrayCreateItem($String_login)
		Else
	   	   	Local $iLogin = ""
		EndIf
#include <playhide\chat.au3>
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
#include <playhide\autoconnect.au3>

EndIf

While 1
#include <playhide\switches_ui.au3>
#include <playhide\switches_tray.au3>
#include <playhide\timer.au3>
WEnd