$nMsg = GUIGetMsg()
Switch $nMsg
	Case $GUI_MINIMIZE_BUTTON
			TraySetState(1)
			GUISetState(@SW_HIDE, $Form1)
	Case $link
			ShellExecute("https://playhide.eu")

	Case $LabelShowIP
			$aArray = _IPDetails()
		If $aArray[1] Then
			$MAC = GET_MAC($sData)
			_Metro_MsgBox($MB_SYSTEMMODAL, $String_info, "MAC: " & $MAC)
			ClipPut($MAC)
			_Metro_MsgBox($MB_SYSTEMMODAL, $String_info, $String_mac_copy)
			_GUIDisable($Form1)
		EndIf

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
		if $ServerMode = 1 Then
			Local $MenuButtonsArray[5] = [$String_language, $String_network, $String_close]
			Else
			Local $MenuButtonsArray[5] = ["Servers", $String_language, $String_network, "Chat", $String_close]
			EndIf
			Local $MenuSelect = _Metro_MenuStart($Form1, 150, $MenuButtonsArray)

		if $ServerMode = 1 Then
			Switch $MenuSelect
				Case "0"
						LanguageList()
					 Case "1"
						$aArray = _IPDetails()
					 If $aArray[1] Then
						run(".\bin\network-scan.exe " & $aArray[1])
					 EndIf
				Case "2"
						ProcessClose("openvpn.exe")
						_Metro_GUIDelete($Form1)
						Exit
				EndSwitch
			Else
Switch $MenuSelect
	Case "0"
			ServerList()
	Case "1"
			LanguageList()
	Case "2"
			$aArray = _IPDetails()
		 If $aArray[1] Then
			run(".\bin\network-scan.exe " & $aArray[1])
		 EndIf
	Case "3"
			ShellExecute("http://chat.vpn")
	Case "4"
			ProcessClose("openvpn.exe")
			_Metro_GUIDelete($Form1)
			Exit
	EndSwitch
EndIf

EndSwitch