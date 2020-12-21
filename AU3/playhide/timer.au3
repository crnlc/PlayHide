
		If TimerDiff($hTimer) > 5*1000 Then
			$Timer = TimerInit()
		If ProcessExists("openvpn.exe") Then
			$ip = _IPDetails()
		if valid_ipv4($ip[1]) Then
			$sData = 'IP: ' & $ip[1]
			TrayItemSetText($iStatus, 'IP: ' & $ip[1])
			GUICtrlSetData($LabelShowIP,$sData)
		EndIf
	  	Else
			GUICtrlSetData($LabelShowIP,$String_not_connected)
			TrayItemSetText($iStatus, $String_not_connected)
	  	EndIf
	  		Local $hTimer = TimerInit()
    EndIf