#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_HiDpi=y
#AutoIt3Wrapper_Res_Comment=
#AutoIt3Wrapper_Res_Description=
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "MetroGUI-UDF\MetroGUI_UDF.au3"
#include "MetroGUI-UDF\_GUIDisable.au3"
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
#traymenu()
_Metro_EnableHighDPIScaling()
Opt("TrayMenuMode",3)
$AppName = "PlayHide VPN"
Global $SettingsFile = @ScriptDir & "\Settings.ini"
Global $Language = IniRead($SettingsFile, "Settings", "Language", "")
Global $CheckUpdateSetting = IniRead($SettingsFile, "Settings", "CheckUpdate", "")
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
Global $Params = "--client --nobind --resolv-retry infinite --persist-key --persist-tun --auth-nocache --remote-cert-tls server --verb 0 --mute-replay-warnings"
Global $ConnectSetup = @ComSpec & " /c " & 'bin32\openvpn.exe ' & $Params & ' --remote ' & $ServerIP & ' ' & $ServerPort & ' --ca .\certs\' & $ServerCA & ' --dev ' & $ServerDev & ' --proto ' & $ServerProto & ' --config .\config\' & $ServerConfig & ' --auth-user-pass ' & $LoginFile
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


TraySetState(16)
TraySetToolTip ($AppName)
Local $sFile = "icon.ico"
TraySetIcon($sFile)
_SetTheme("DarkPlayHide")
#_SetTheme("DarkTealV2")

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

Func _IPDetails()
    Local $oWMIService = ObjGet('winmgmts:\\' & '.' & '\root\cimv2')
    Local $oColItems = $oWMIService.ExecQuery('Select * From Win32_NetworkAdapterConfiguration Where DHCPServer="' & $ServerDHCP & '"', 'WQL', 0x30), $aReturn[5] = [0]
    If IsObj($oColItems) Then
        For $oObjectItem In $oColItems
            If $oObjectItem.IPAddress(0) == @IPAddress1 Then
                $aReturn[0] = 4
                $aReturn[1] = $oObjectItem.IPAddress(0)
            EndIf
        Next
    EndIf
    Return SetError($aReturn[0] = 0, 0, $aReturn)
 EndFunc

Func RestartScript()
    If @Compiled = 1 Then
        Run( FileGetShortName(@ScriptFullPath))
    Else
        Run( FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
    EndIf
    Exit
 EndFunc

$VersionsInfo = "http://playhide.tk/files/version.ini"
$oldVersion = IniRead("updater.ini","Version","Version","NotFound")
$newVersion = "0.0"
$Ini = InetGet($VersionsInfo,@ScriptDir & "\version.ini") ;download version.ini

If $CheckUpdateSetting >0 then

If $Ini = 0 Then ;was the download of version.ini successful?
Else
    $newVersion = IniRead (@ScriptDir & "\version.ini","Version","Version","") ;reads the new version out of version.ini
    If $NewVersion = $oldVersion Then ;compare old and new
    Else
        $msg = _Metro_MsgBox (4,"Update","There is a new version existing: " & $newVersion & " ! You are using: " & $oldVersion & ". Do you want to download the new version?")
        If $msg = "NO" Then ;No was pressed
            FileDelete(@ScriptDir & "\version.ini")
        ElseIf $msg = "YES" Then ;OK was pressed
            $downloadLink = IniRead(@ScriptDir & "\version.ini","Version","7z","NotFound")
            $dlhandle = InetGet($downloadLink,@ScriptDir & "\PlayHide.7z",1,1)
            _Metro_CreateProgress(100, 195, 300, 26)
            $Size = InetGetSize($downloadLink,1) ;get the size of the update
            While Not InetGetInfo($dlhandle, 2)
                $Percent = (InetGetInfo($dlhandle,0)/$Size)*100
                ProgressSet( $Percent, $Percent & " percent");update progressbar
                Sleep(1)
            WEnd
            ProgressSet(100 , $String_done, $String_complete);show complete progressbar
            sleep(500)
            ProgressOff() ;close progress window
            IniWrite("updater.ini","version","version",$NewVersion) ;updates update.ini with the new version
            InetClose($dlhandle)
            EndIf
    EndIf
 EndIf
    EndIf

FileDelete(@ScriptDir & "\version.ini")
If FileExists("PlayHide.7z") then
			Run(@ComSpec & " /c " & "update.exe" , "", @SW_HIDE)
   exit
else
If Not FileExists($LoginFile) then
   If Not IsAdmin() Then
			_Metro_MsgBox(0, $String_error, $String_start_msg)
						Exit
					 else
			If $AuthSetting >0 then
			$Username = _Metro_InputBox2($String_username, 15, "", False, False)
			$Passwort = _Metro_InputBox2($String_password, 15, "", true, False)
			$file = FileOpen($LoginFile, 2)
			FileFlush($file)
			FileWrite($file, $Username & @CRLF)
			FileWrite($file, $Passwort)
			FileClose($file)
else
   			Local $file = FileOpen($LoginFile, 2)
			FileFlush($file)
			FileWrite($file, _RandomText(10) & @CRLF)
			FileWrite($file, _RandomText(10))
			FileClose($file)
			Endif
			RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule name="' & $AppName & '" dir=in action=allow protocol=' & $ServerProto & ' localport=' & $ServerPort , "", @SW_HIDE)
			RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow' , "", @SW_HIDE)
			$Setup = _Metro_MsgBox(0, $String_setup_info, $String_setup_msg)
			$DevResult = Run(@ComSpec & ' /c netsh interface show interface name="' & $AppName & '"', "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
			ProcessWaitClose($DevResult)
			$ReadResultDev = StdoutRead($DevResult)
			$DevExist = StringInStr($ReadResultDev, $AppName)
			if Not $DevExist then
			RunWait('driver\tap.exe')
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
#$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
$GUI_MENU_BUTTON = $Control_Buttons[6]
GUISetIcon($sFile)
GUICtrlCreateLabel($AppName, 50, 7, 300, 30)
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
	   	   If $AuthSetting >0 then
	   	   Local $iLogin = TrayCreateItem($String_login)
		  Else
	   	   Local $iLogin = ""
		   EndIf
	   If $ChatSetting >0 then
		 Local $iOpenChat = TrayCreateItem("Chat")
		 TrayItemSetState ($iOpenChat, $TRAY_ENABLE)
		  Else
		 Local $iOpenChat = ""
		 TrayItemSetState ($iOpenChat, $TRAY_DISABLE)
EndIf

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
   $AutoConnectSetting = IniRead($SettingsFile, "Settings", "AutoConnect", "")
If $AutoConnectSetting >0 then
		 TrayItemSetState ($iAutoConnect, $TRAY_CHECKED)
		 Run($Connect, "", @SW_HIDE)
		 GUICtrlSetState($ButtonConnect, $GUI_HIDE)
		 GUICtrlSetState($ButtonDisconnect, $GUI_SHOW)
		 TraySetState(1)
		 GUISetState(@SW_HIDE, $Form1)
		 sleep(1000)
				If ProcessExists("openvpn.exe") Then
		 GUICtrlSetData($LabelShowIP,$String_determine_ip)
		 TrayItemSetText($iStatus, $String_determine_ip)
		 $aArray = _IPDetails()
		 $sData = 'IP: ' & $aArray[1]
		 if $aArray[1] Then
		 TrayTip($String_connected, 'IP: ' & $aArray[1], 3, $TIP_ICONASTERISK)
		 EndIf
	  Else
		 TrayItemSetState ($iAutoConnect, $TRAY_UNCHECKED)
		 TrayItemSetText($iStatus, $String_not_connected)
		 GUICtrlSetData($LabelShowIP,$String_not_connected)
		 ProcessClose("openvpn.exe")
		 GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
		 GUICtrlSetState($ButtonConnect, $GUI_SHOW)
				GUISetState(@SW_SHOW)
EndIf
   else
	  				GUISetState(@SW_SHOW)

   EndIf
EndIf
EndIf

Func _RandomText($length)
    $text = ""
    For $i = 1 To $length
        $temp = Random(65, 122, 1)
        While $temp >= 90 And $temp <= 96
            $temp = Random(65, 122, 1)
        WEnd
        $temp = Chr($temp)
        $text &= $temp
    Next
    Return $text
 EndFunc

Func ServerList()
			$GUIServer = _Metro_CreateGUI($AppName, 160, 80, -1, -1, false,false)
			$ContentList = IniReadSectionNames($ServerList)
			$Chooser = GUICtrlCreateCombo("", 30, 15, 99, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData($Chooser, _ArraytoString($ContentList, "|", 1), $ContentList[1])
			$ButtonServerOK = _Metro_CreateButtonEx2($String_apply, 40, 40, 80, 30, $ButtonBKColor)
			GUICtrlSetState($Chooser, $GUI_SHOW)
			GUISetState(@SW_SHOW, $GUIServer)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
	Case $ButtonServerOK
	  $ChooserPick = GUICtrlRead($Chooser)
	  IniWrite($SettingsFile, "Settings", "Server", $ChooserPick)
	      _Metro_MsgBox($MB_SYSTEMMODAL, $String_info, $String_server_switched)
				_GUIDisable($GUIServer)
		 _Metro_GUIDelete($GUIServer)
		 ProcessClose("openvpn.exe")
		 RestartScript()
		 Exit
	  EndSwitch
	  WEnd
   EndFunc

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
		 ProcessClose("openvpn.exe")
		 RestartScript()
		 Exit
	  EndSwitch
	  WEnd
   EndFunc

Func _Ping()
   $Ping = _Metro_InputBox2("Ping Client", 15, "1", False, False)
    Local $iPing = Ping($ServerSubnet & $Ping, 600)

    If $iPing Then
	  _Metro_MsgBox($MB_SYSTEMMODAL, $String_info, $String_client_ping & $iPing & "ms.")
    Else
	  _Metro_MsgBox($MB_SYSTEMMODAL, $String_error, $String_client_ping_failed)
	 EndIf
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
				If ProcessExists("openvpn.exe") Then
		 TrayItemSetText($iStatus, $String_determine_ip)
		 GUICtrlSetData($LabelShowIP,$String_determine_ip)
	  Else
		 ProcessClose("openvpn.exe")
		 GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
		 GUICtrlSetState($ButtonConnect, $GUI_SHOW)
		 GUICtrlSetData($LabelShowIP,$String_not_connected)
		 TrayItemSetText($iStatus, $String_not_connected)
		 _GUIDisable($Form1, 0, 30)
		 _Metro_MsgBox($MB_SYSTEMMODAL, $String_error, $String_connection_error)
				_GUIDisable($Form1)
EndIf
		         Case $ButtonDisconnect
				  ProcessClose("openvpn.exe")
		 		  GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
		 		  GUICtrlSetState($ButtonConnect, $GUI_SHOW)
				  GUICtrlSetData($LabelShowIP,$String_not_connected)
				  TrayItemSetText($iStatus, $String_not_connected)

		Case $GUI_MENU_BUTTON
		 Local $MenuButtonsArray[5] = ["Servers", $String_language, $String_network, $String_close]
			Local $MenuSelect = _Metro_MenuStart($Form1, 150, $MenuButtonsArray)
			Switch $MenuSelect
			   Case "0"
					 ServerList()
			   Case "1"
					 LanguageList()
				  Case "2"
			   run(".\bin32\network-scan.exe")
				Case "3"
					 ProcessClose("openvpn.exe")
					_Metro_GUIDelete($Form1)
					Exit
			EndSwitch

			 		  EndSwitch

        Switch TrayGetMsg()
            Case $idExit
			   		 ProcessClose("openvpn.exe")
		 _Metro_GUIDelete($Form1)
		 Exit

	  Case $iOpenChat

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
			 Case $iLogin
			$ReadUsername = FileReadLine($LoginFile,1)
			$ReadPasswort = FileReadLine($LoginFile,2)
			$Username = _Metro_InputBox2($String_username, 15, $ReadUsername, False, False)
			$Passwort = _Metro_InputBox2($String_password, 15, $ReadPasswort, true, False)
			_GUIDisable($Form1)
			$file = FileOpen($LoginFile, 2)
			FileFlush($file)
			FileWrite($file, $Username & @CRLF)
			FileWrite($file, $Passwort)
			FileClose($file)
			ProcessClose("openvpn.exe")
			sleep(500)
			Run($Connect, "", @SW_HIDE)
						sleep(3000)
									if Not ProcessExists("openvpn.exe") Then
			   _GUIDisable($Form1, 0, 30)
			   _Metro_MsgBox($MB_SYSTEMMODAL, $String_error, $String_login_wrong)
			   _GUIDisable($Form1)
			EndIf
			ProcessClose("openvpn.exe")
			GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
			GUICtrlSetState($ButtonConnect, $GUI_HIDE)
			GUICtrlSetState($ButtonConnect, $GUI_SHOW)
			GUICtrlSetData($LabelShowIP,$String_not_connected)
			TrayItemSetText($iStatus, $String_not_connected)
   Case $iOpen
ConsoleWrite("up" & @CRLF)
$ok = GUISetState(@SW_SHOW)
ConsoleWrite($ok & @CRLF)
	  EndSwitch

		 If TimerDiff($hTimer) > 5*1000 Then
		 $Timer = TimerInit()
		 If ProcessExists("openvpn.exe") Then
		 $aArray = _IPDetails()
		 $sData = 'IP: ' & $aArray[1]
		 if $aArray[1] Then
		 TrayItemSetText($iStatus, 'IP: ' & $aArray[1])
		 GUICtrlSetData($LabelShowIP,$sData)
		 EndIf
	  Else
GUICtrlSetData($LabelShowIP,$String_not_connected)
TrayItemSetText($iStatus, $String_not_connected)
	  EndIf
	  		 Local $hTimer = TimerInit()
    EndIf
WEnd