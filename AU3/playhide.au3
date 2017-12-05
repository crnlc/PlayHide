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
#RequireAdmin
#traymenu()
_Metro_EnableHighDPIScaling()
Opt("TrayMenuMode",3)
TraySetState(16)
TraySetToolTip ("PlayHide Service")
Local $sFile = "icon.ico"
TraySetIcon($sFile)
_SetTheme("DarkPlayHide")

Func users()
    Global $dOldData = ""
    Local $dData = InetRead("http://vpn.playhide.tk/users_online.php",1)
    Local $sData = BinaryToString($dData)
	    If $dOlddata <> $dData Then
        $dOlddata = $dData
	 EndIf
	 	Local $users = GUICtrlCreateLabel('Online Users: ' & $sData, 150, 140, 300, 30)
	 GUICtrlSetState($users, $GUI_SHOW)
	 	 GUICtrlSetState($users, $GUI_HIDE)

GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
EndFunc

Func _IPDetails()
    Local $oWMIService = ObjGet('winmgmts:{impersonationLevel = impersonate}!\\' & '.' & '\root\cimv2')
    Local $oColItems = $oWMIService.ExecQuery('Select * From Win32_NetworkAdapterConfiguration Where IPConnectionMetric=1', 'WQL', 0x30), $aReturn[5] = [0]
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

$VersionsInfo = "http://playhide.tk/files/version.ini"
$oldVersion = IniRead("updater.ini","Version","Version","NotFound")
$newVersion = "0.0"
$Ini = InetGet($VersionsInfo,@ScriptDir & "\version.ini") ;download version.ini

If $Ini = 0 Then ;was the download of version.ini successful?
    _Metro_MsgBox(0,"ERROR","The server seems to be offline.")
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
            ProgressSet(100 , "Done", "Complete");show complete progressbar
            sleep(500)
            ProgressOff() ;close progress window
            IniWrite("updater.ini","version","version",$NewVersion) ;updates update.ini with the new version
            InetClose($dlhandle)
            _Metro_MsgBox(-1,"Success","Update will start!")
            EndIf
    EndIf
EndIf
FileDelete(@ScriptDir & "\version.ini")
If Not IsAdmin() Then
			_Metro_MsgBox(0, "Error", "Admin required!")
						Exit
			   else
If FileExists("PlayHide.7z") then
			Run(@ComSpec & " /c " & "update.exe" , "", @SW_HIDE)

   exit
else
If Not FileExists("login.txt") then
   			Local $file = FileOpen("login.txt", 2)
			FileFlush($file)
			FileWrite($file, _RandomText(10) & @CRLF)
			FileWrite($file, _RandomText(10))
			FileClose($file)
			RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule name="PlayHide VPN" dir=in action=allow protocol=UDP localport=1400' , "", @SW_HIDE)
			RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow' , "", @SW_HIDE)
			$Setup = _Metro_MsgBox(0, "First run", "Setup required! Takes 30 Sec after TAP Installer")
			#RunWait(@ComSpec & " /c " & '"' & @ScriptDir & '\driver\tapinstall.exe" install ' & '"' & @ScriptDir & '\driver\OemVista.inf" tap0901')
			RunWait('driver\tap.exe')
			Run(@ComSpec & " /c " & "bin32\openvpn.exe .\config\client.ovpn" , "", @SW_HIDE)
			Sleep(10000)
			If ProcessExists("openvpn.exe") And Ping("10.5.1.1") Then
			RunWait(@ComSpec & " /c " & 'Powershell.exe -executionpolicy Bypass -File "driver\SetAdapter.ps1"', "", @SW_HIDE)
			#Run(@ComSpec & " /c " & "install.cmd" , "", @SW_HIDE)
			RunWait('netsh interface ipv4 set interface "PlayHide VPN" metric=1')
			ProcessClose("openvpn.exe")
			_Metro_MsgBox($MB_SYSTEMMODAL, "Finish", "Setup is finish! Now start PlayHide again!")
			if Not FileExists(@DesktopDir & "\PlayHide VPN.lnk") Then
			FileCreateShortcut(@AutoItExe, @DesktopDir & "\PlayHide VPN.lnk", @ScriptDir)
		 else
			EndIf
			Exit
		 else
			    _Metro_MsgBox($MB_SYSTEMMODAL, "ERROR", "No Connection to Network")
						 ProcessClose("openvpn.exe")
						 FileDelete ('login.txt')
   Exit
EndIf
			Sleep(1000)
else
If ProcessExists("openvpn.exe") Then
       _Metro_MsgBox($MB_SYSTEMMODAL, "Error", "Only one Connection possible!")
   Exit
else
Local $hTimer = TimerInit()
Local $SettingsFile = @ScriptDir & "\Settings.ini"
$ChatSetting = IniRead($SettingsFile, "Settings", "Chat", "")
$Form1 = _Metro_CreateGUI("PlayHide VPN", 250, 180, -1, -1, true,false)
$Control_Buttons = _Metro_AddControlButtons(True,False,True,False,False)
$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
GUISetIcon($sFile)
GUICtrlCreateLabel("PlayHide VPN", 10, 10, 300, 30)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
Local $LabelShowIP = GUICtrlCreateLabel("Not connected", 150, 150, 300, 30)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreateLabel("PlayHide VPN", 65, 40, 300, 30)
GUICtrlSetFont(-1, 14, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$ButtonConnect = _Metro_CreateButtonEx2("Connect", 70, 85, 99, 50, $ButtonBKColor)
$ButtonDisconnect = _Metro_CreateButtonEx2("Disconnect", 70, 85, 99, 50, $ButtonBKColor)
$ButtonChat = _Metro_CreateButton("Chat", 70, 115, 99, 25)
GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
GUICtrlSetState($ButtonChat, $GUI_HIDE)
$UpdaterVersionFile = @ScriptDir & "\updater.ini"
$ReadVersion = IniRead($UpdaterVersionFile, "Version", "Version", "")
$link = GUICtrlCreateLabel("Vers: " & $ReadVersion & " / Website", 10, 150, 300, 30)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
       Local $iStatus = TrayCreateItem("Not connected")
TrayItemSetState ($iStatus, $TRAY_DISABLE)
TrayCreateItem("") ; Create a separator line.
       Local $iOpen = TrayCreateItem("Open")
	   Local $iOpenChat = TrayCreateItem("Chat")
	   If $ChatSetting >0 then
			 TrayItemSetState ($iOpenChat, $TRAY_ENABLE)
	Else
	   		 TrayItemSetState ($iOpenChat, $TRAY_DISABLE)
EndIf

	   TrayCreateItem("") ; Create a separator line.
    Local $iAutoConnect = TrayCreateItem("Auto-Connect", -1, -1, $TRAY_ITEM_NORMAL)
			 TrayItemSetState ($iAutoConnect, $TRAY_UNCHECKED)
   Local $iAutostart = TrayCreateItem("Autostart (Systemboot)")
   Local $iDesktopIcon = TrayCreateItem("Desktop Shortcut")
   if FileExists(@DesktopDir & "\PlayHide VPN.lnk") Then
			TrayItemSetState ($iDesktopIcon, $TRAY_DISABLE)
			Else
			TrayItemSetState ($iDesktopIcon, $TRAY_ENABLE)
			EndIf
    TrayCreateItem("") ; Create a separator line.
   Local $iWebsite = TrayCreateItem("Vers: " & $ReadVersion & " / Website", -1, -1, $TRAY_ITEM_NORMAL)
    Local $idExit = TrayCreateItem("Exit")
$AutoConnectSetting = IniRead($SettingsFile, "Settings", "AutoConnect", "")
If $AutoConnectSetting >0 then
		 TrayItemSetState ($iAutoConnect, $TRAY_CHECKED)
		 Run(@ComSpec & " /c " & "bin32\openvpn.exe .\config\client.ovpn" , "", @SW_HIDE)
		 GUICtrlSetState($ButtonConnect, $GUI_HIDE)
		 GUICtrlSetState($ButtonDisconnect, $GUI_SHOW)
		 TraySetState(1)
		 GUISetState(@SW_HIDE, $Form1)
		 		 sleep(500)
				If ProcessExists("openvpn.exe") Then
		 GUICtrlSetData($LabelShowIP,"Determine IP")
		 TrayItemSetText($iStatus, 'Determine IP')
		 sleep(15000)
		 $aArray = _IPDetails()
		 $sData = 'IP: ' & $aArray[1]
		 TrayTip("Connected", 'IP: ' & $aArray[1], 3, $TIP_ICONASTERISK)
	  Else
		 TrayItemSetState ($iAutoConnect, $TRAY_UNCHECKED)
		 TrayItemSetText($iStatus, "Not connected")
		 GUICtrlSetData($LabelShowIP,"Not connected")
		 ProcessClose("openvpn.exe")
		 GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
		 GUICtrlSetState($ButtonConnect, $GUI_SHOW)
				GUISetState(@SW_SHOW)
		   			_GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
    _Metro_MsgBox($MB_SYSTEMMODAL, "ERROR", "No Connection to Network")
				_GUIDisable($Form1)
EndIf
   else
	  				GUISetState(@SW_SHOW)

   EndIf
   EndIf
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

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
	  Case $GUI_EVENT_CLOSE, $GUI_CLOSE_BUTTON
		 ProcessClose("openvpn.exe")
		 _Metro_GUIDelete($Form1)
		 Exit

			   Case $GUI_MINIMIZE_BUTTON
			   TraySetState(1)
			   GUISetState(@SW_HIDE, $Form1)
			Case $link
            ShellExecute("http://playhide.tk")

		 Case $ButtonConnect
		 Run(@ComSpec & " /c " & "bin32\openvpn.exe .\config\client.ovpn" , "", @SW_HIDE)
		 GUICtrlSetState($ButtonConnect, $GUI_HIDE)
		 GUICtrlSetState($ButtonDisconnect, $GUI_SHOW)
		 sleep(500)
				If ProcessExists("openvpn.exe") Then
		 TrayItemSetText($iStatus, 'Determine IP')
		 GUICtrlSetData($LabelShowIP,"Determine IP")
		 sleep(5000)
	  Else
		 ProcessClose("openvpn.exe")
		 GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
		 GUICtrlSetState($ButtonConnect, $GUI_SHOW)
		 GUICtrlSetData($LabelShowIP,"Not connected")
		 TrayItemSetText($iStatus, "Not connected")
		   			_GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
    _Metro_MsgBox($MB_SYSTEMMODAL, "ERROR", "No Connection to Network")
				_GUIDisable($Form1)
EndIf
		         Case $ButtonDisconnect
		 ProcessClose("openvpn.exe")
		 		 GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
		 		 GUICtrlSetState($ButtonConnect, $GUI_SHOW)
						GUICtrlSetData($LabelShowIP,"Not connected")
						GUICtrlSetState($ButtonChat, $GUI_HIDE)
						 TrayItemSetText($iStatus, "Not Connected")


			 		  EndSwitch


        Switch TrayGetMsg()
            Case $idExit
			   		 ProcessClose("openvpn.exe")
		 _Metro_GUIDelete($Form1)
		 Exit

	  Case $iOpenChat
			if Not ProcessExists("chat.exe") then
			run("bin32\chat.exe")
			else
   		   			_GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
			_Metro_MsgBox($MB_SYSTEMMODAL, "ERROR", "Chat is already running!")
				_GUIDisable($Form1)
			 EndIf

		  Case $iWebsite
			             ShellExecute("http://playhide.tk")

		 Case $iDesktopIcon
			if Not FileExists(@DesktopDir & "\PlayHide VPN.lnk") Then
			FileCreateShortcut(@AutoItExe, @DesktopDir & "\PlayHide VPN.lnk", @ScriptDir) ;für den aktuellen Benutzer
			_GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
			_Metro_MsgBox($MB_SYSTEMMODAL, "Info", "Shortcut created!")
			_GUIDisable($Form1)
					 else
			_GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
			_Metro_MsgBox($MB_SYSTEMMODAL, "Info", "Shortcut already exist!")
			_GUIDisable($Form1)
		 EndIf

					 Case $iAutostart
			if Not FileExists(@StartupDir & "\PlayHide.lnk") Then
			FileCreateShortcut(@AutoItExe, @StartupDir & "\PlayHide.lnk", @ScriptDir) ;für den aktuellen Benutzer
			_GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
			_Metro_MsgBox($MB_SYSTEMMODAL, "Info", "PlayHide is now StartUp with your System!")
			_GUIDisable($Form1)
		 else
			FileDelete(@StartupDir & "\PlayHide.lnk")
			_GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
			_Metro_MsgBox($MB_SYSTEMMODAL, "Info", "PlayHide is removed as Autostart!")
			_GUIDisable($Form1)
			EndIf
		  Case $iAutoConnect
			 if $AutoConnectSetting >0 Then
			   IniWrite($SettingsFile, "Settings", "AutoConnect", "0")
			   _GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
			   _Metro_MsgBox($MB_SYSTEMMODAL, "Info", "Auto Connect is off! (Change after Restart)")
				_GUIDisable($Form1)
			 else
				 IniWrite($SettingsFile, "Settings", "AutoConnect", "1")
				 			      		   			_GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
    _Metro_MsgBox($MB_SYSTEMMODAL, "Info", "Auto Connect is on! (Change after Restart)")
				_GUIDisable($Form1)
			 EndIf

   Case $iOpen
ConsoleWrite("up" & @CRLF)
$ok = GUISetState(@SW_SHOW)
ConsoleWrite($ok & @CRLF)
	  EndSwitch

		 If TimerDiff($hTimer) > 15*1000 Then
		 $Timer = TimerInit()
		 If ProcessExists("openvpn.exe") Then
		 $aArray = _IPDetails()
		 $sData = 'IP: ' & $aArray[1]
		 TrayItemSetText($iStatus, 'IP: ' & $aArray[1])
		 GUICtrlSetData($LabelShowIP,$sData)
		 #TrayTip("Connected", 'IP: ' & $aArray[1], 3, $TIP_ICONASTERISK)
	  Else
GUICtrlSetData($LabelShowIP,"Not connected")
TrayItemSetText($iStatus, "Not connected")
#TrayTip("ERROR", "Connection is no longer active!", 3, $TIP_ICONASTERISK)
	  EndIf
	  		 Local $hTimer = TimerInit()
    EndIf
WEnd