
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