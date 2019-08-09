Switch TrayGetMsg()
    Case $idExit
			ProcessClose("openvpn.exe")
			_Metro_GUIDelete($Form1)
			Exit

	Case $iOpenChat
		If $ChatSetting >0 then
			ShellExecute("http://chat.vpn")
		EndIf

	Case $iWebsite
			ShellExecute("https://playhide.eu")

	Case $iOpen
			GUISetState(@SW_SHOW)

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
		If $AuthSetting >0 then
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
			GUICtrlSetState($ButtonDisconnect, $GUI_HIDE)
			GUICtrlSetState($ButtonConnect, $GUI_HIDE)
			GUICtrlSetState($ButtonConnect, $GUI_SHOW)
			GUICtrlSetData($LabelShowIP,$String_not_connected)
			TrayItemSetText($iStatus, $String_not_connected)
		EndIf
EndSwitch