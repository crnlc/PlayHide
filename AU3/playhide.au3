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
_SetTheme("DarkTeal")

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
			$Setup = _Metro_MsgBox(0, "First run", "Setup required! Takes 30 Sec after TAP Installer")
			#RunWait(@ComSpec & " /c " & '"' & @ScriptDir & '\driver\tapinstall.exe" install ' & '"' & @ScriptDir & '\driver\OemVista.inf" tap0901')
			RunWait('driver\tap.exe')
			Run(@ComSpec & " /c " & "bin32\openvpn.exe .\config\client.ovpn" , "", @SW_HIDE)
			Sleep(10000)
			If ProcessExists("openvpn.exe") And Ping("10.5.1.1",400) Then
			RunWait(@ComSpec & " /c " & "driver\SetAdapter.exe" , "", @SW_HIDE)
			#Run(@ComSpec & " /c " & "install.cmd" , "", @SW_HIDE)
			RunWait('netsh interface ipv4 set interface "PlayHide VPN" metric=1')
			ProcessClose("openvpn.exe")
			_Metro_MsgBox($MB_SYSTEMMODAL, "Finish", "Setup is finish! Now start PlayHide again!")
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
$Form1 = _Metro_CreateGUI("PlayHide by 3DNS", 250, 180, -1, -1, true,false)
$Control_Buttons = _Metro_AddControlButtons(True,False,True,False,False)
$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
GUISetIcon($sFile)
GUICtrlCreateLabel("PlayHide VPN", 10, 10, 300, 30)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
Local $LabelNotConnected = GUICtrlCreateLabel("Not connected", 150, 150, 300, 30)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$link = GUICtrlCreateLabel("PlayHide VPN", 65, 40, 300, 30)
GUICtrlSetFont(-1, 14, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$ButtonConnect = _Metro_CreateButton("Connect", 70, 85, 99, 50, 0xFF7500)
 _GUICtrlButton_Click($ButtonConnect)
$ButtonDisconnect = _Metro_CreateButton("Disconnect", 70, 85, 99, 50, 0xFF7500)
$ButtonChat = _Metro_CreateButton("Chat", 70, 115, 99, 25)
GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
GUICtrlSetState($ButtonChat, $GUI_HIDE)
$UpdaterVersionFile = @ScriptDir & "\updater.ini"
$ReadVersion = IniRead($UpdaterVersionFile, "Version", "Version", "")
$link = GUICtrlCreateLabel("Vers: " & $ReadVersion & " / Website", 10, 150, 300, 30)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
       Local $iStatus = TrayCreateItem("Not Connected")
TrayItemSetState ($iStatus, $TRAY_DISABLE)
TrayCreateItem("") ; Create a separator line.
       Local $iOpen = TrayCreateItem("Open")
	   Local $iOpenChat = TrayCreateItem("Chat")
	   TrayCreateItem("") ; Create a separator line.
    Local $iAutoConnect = TrayCreateItem("Auto-Connect", -1, -1, $TRAY_ITEM_NORMAL)
			 TrayItemSetState ($iAutoConnect, $TRAY_UNCHECKED)
   Local $iAutostart = TrayCreateItem("Autostart (Systemboot)")
    TrayCreateItem("") ; Create a separator line.
   Local $iWebsite = TrayCreateItem("Vers: " & $ReadVersion & " / Website", -1, -1, $TRAY_ITEM_NORMAL)
    Local $idExit = TrayCreateItem("Exit")
GUISetState(@SW_SHOW)

      Local $SettingsFile = @ScriptDir & "\Settings.ini"
$AutoConnectSetting = IniRead($SettingsFile, "Settings", "AutoConnect", "")
If $AutoConnectSetting >0 then
		 TrayItemSetState ($iAutoConnect, $TRAY_CHECKED)
		 Run(@ComSpec & " /c " & "bin32\openvpn.exe .\config\client.ovpn" , "", @SW_HIDE)
		 GUICtrlSetState($ButtonConnect, $GUI_HIDE)
		 GUICtrlSetState($LabelNotConnected, $GUI_HIDE)
		 GUICtrlSetState($ButtonDisconnect, $GUI_SHOW)
		 TraySetState(1)
		 GUISetState(@SW_HIDE, $Form1)
      Sleep(5000)
   Local $aArray = _IPDetails()
Local $sData = 'IP: ' & $aArray[1]
	  Local $LabelShowIP = GUICtrlCreateLabel($sData, 150, 150, 300, 30)
				If ProcessExists("openvpn.exe") And Ping("10.5.1.1",400) Then
			       Local $sData = 'IP: ' & $aArray[1]
		 GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
		 GUICtrlSetColor(-1, 0xFFFFFF)
		 GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		 TrayItemSetText($iStatus, 'IP: ' & $aArray[1])
	  Else
		 TrayItemSetState ($iAutoConnect, $TRAY_UNCHECKED)
		 TrayItemSetText($iStatus, "Not Connected")
		 ProcessClose("openvpn.exe")
GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
GUICtrlSetState($ButtonConnect, $GUI_SHOW)
GUICtrlSetState($LabelShowIP, $GUI_HIDE)
GUICtrlSetState($LabelNotConnected, $GUI_SHOW)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		   			_GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
    _Metro_MsgBox($MB_SYSTEMMODAL, "ERROR", "No Connection to Network")
				_GUIDisable($Form1)
EndIf
   else
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
		 GUICtrlSetState($LabelNotConnected, $GUI_HIDE)
		 GUICtrlSetState($ButtonDisconnect, $GUI_SHOW)
      Sleep(5000)
   Local $aArray = _IPDetails()
Local $sData = 'IP: ' & $aArray[1]
	  Local $LabelShowIP = GUICtrlCreateLabel($sData, 150, 150, 300, 30)
				If ProcessExists("openvpn.exe") And Ping("10.5.1.1",400) Then
			       Local $sData = 'IP: ' & $aArray[1]
				   TrayItemSetText($iStatus, 'IP: ' & $aArray[1])
				  TrayTip("Connected", 'IP: ' & $aArray[1], 3, $TIP_ICONASTERISK)
		 GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
		 GUICtrlSetColor(-1, 0xFFFFFF)
		 GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	  Else
		 ProcessClose("openvpn.exe")
GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
GUICtrlSetState($ButtonConnect, $GUI_SHOW)
GUICtrlSetState($LabelShowIP, $GUI_HIDE)
GUICtrlSetState($LabelNotConnected, $GUI_SHOW)
TrayItemSetText($iStatus, "Not Connected")
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		   			_GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
    _Metro_MsgBox($MB_SYSTEMMODAL, "ERROR", "No Connection to Network")
				_GUIDisable($Form1)
EndIf
		         Case $ButtonDisconnect
		 ProcessClose("openvpn.exe")
		 		 GUICtrlSetState($ButtonConnect, $GUI_SHOW)
						GUICtrlSetState($LabelShowIP, $GUI_HIDE)
						GUICtrlSetState($ButtonChat, $GUI_HIDE)
				 		 GUICtrlSetState($LabelNotConnected, $GUI_SHOW)
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

		 Case $iAutostart
			FileCreateShortcut(@AutoItExe, @StartupDir & "\" & @ScriptName & ".lnk", @ScriptDir) ;für den aktuellen Benutzer
			_GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
			_Metro_MsgBox($MB_SYSTEMMODAL, "Info", "PlayHide is now StartUp with your System!")
			_GUIDisable($Form1)

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
WEnd