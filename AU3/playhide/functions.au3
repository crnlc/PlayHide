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
            If $oObjectItem.IPAddress(0) Then
                $aReturn[0] = 4
                $aReturn[1] = $oObjectItem.IPAddress(0)
            EndIf
        Next
    EndIf
    Return SetError($aReturn[0] = 0, 0, $aReturn)
 EndFunc


 Func checkTAP_Interface($AppName)
    $DevResult = Run(@ComSpec & ' /c netsh interface show interface name="' & $AppName & '"', "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
    ProcessWaitClose($DevResult)
    $ReadResultDev = StdoutRead($DevResult)
    $DevExist = StringInStr($ReadResultDev, $AppName)
    if Not $DevExist then
        Return false
    Else
        Return true
    EndIf
 EndFunc

 Func Write_Login($LoginFile,$Username,$Passwort)
    $file = FileOpen($LoginFile, 2)
    FileFlush($file)
    FileWrite($file, $Username & @CRLF)
    FileWrite($file, $Passwort)
    FileClose($file)
 EndFunc

Func RestartScript()
    If @Compiled = 1 Then
        Run( FileGetShortName(@ScriptFullPath))
    Else
        Run( FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
    EndIf
    Exit
 EndFunc

Func GET_MAC($_MACsIP)
    Local $_MAC,$_MACSize
    Local $_MACi,$_MACs,$_MACr,$_MACiIP
    $_MAC = DllStructCreate("byte[6]")
    $_MACSize = DllStructCreate("int")
    DllStructSetData($_MACSize,1,6)
    $_MACr = DllCall ("Ws2_32.dll", "int", "inet_addr", "str", $_MACsIP)
    $_MACiIP = $_MACr[0]
    $_MACr = DllCall ("iphlpapi.dll", "int", "SendARP", "int", $_MACiIP, "int", 0, "ptr", DllStructGetPtr($_MAC), "ptr", DllStructGetPtr($_MACSize))
    $_MACs  = ""
    For $_MACi = 0 To 5
    If $_MACi Then $_MACs = $_MACs & ":"
        $_MACs = $_MACs & Hex(DllStructGetData($_MAC,1,$_MACi+1),2)
    Next
    DllClose($_MAC)
    DllClose($_MACSize)
    Return $_MACs
EndFunc

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

 Func _Ping()
	$Ping = _Metro_InputBox2("Ping Client", 15, "1", False, False)
	Local $iPing = Ping($ServerSubnet & $Ping, 600)

	If $iPing Then
	  	_Metro_MsgBox($MB_SYSTEMMODAL, $String_info, $String_client_ping & $iPing & "ms.")
	Else
		_Metro_MsgBox($MB_SYSTEMMODAL, $String_error, $String_client_ping_failed)
	EndIf
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