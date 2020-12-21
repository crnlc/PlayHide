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
	If valid_ipv4($aArray[1]) Then
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