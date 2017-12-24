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
#Include <ButtonConstants.Au3>
#Include <EditConstants.Au3>
#Include <GUIConstantsEx.Au3>
#Include <StaticConstants.Au3>
#Include <WindowsConstants.Au3>
#Include <GUIEdit.Au3>
#Include <Misc.Au3>
#NoTrayIcon
#include "MetroGUI-UDF\MetroGUI_UDF.au3"
#include "MetroGUI-UDF\_GUIDisable.au3"
DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1)

#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so /rm /pe
#Au3Stripper_Ignore_Funcs=_iHoverOn,_iHoverOff,_iFullscreenToggleBtn,_cHvr_CSCP_X64,_cHvr_CSCP_X86,_iControlDelete
#AutoIt3Wrapper_Res_HiDpi=y
_Metro_EnableHighDPIScaling()
Opt("GUIOnEventMode", 0)

_SetTheme("DarkPlayHide")
				If ProcessExists("openvpn.exe") Then

Global $Server = -1, $Logs
Local $IP = "10.5.1.10"
Local $Port = "50"
Local $AppName = "PlayHide Chat"
Local $sFile = "icon.ico"

$IniFile = "..\Settings.ini"
$ReadUserName = IniRead($IniFile, "Settings", "NickName", "")
$username = _Metro_InputBox2("Nickname", 14, $ReadUserName, False, True)
IniWrite($IniFile, "Settings", "NickName", $username)
TcpStartUp ()
_Start ()

$GUI = _Metro_CreateGUI($AppName, 375, 350, -1, -1, true,false)
$Control_Buttons = _Metro_AddControlButtons(True,False,True,False,False)
$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
GUISetIcon($sFile)
GUICtrlCreateLabel($AppName, 10, 10, 200, 30)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
$History = GUICtrlCreateEdit ('', 0, 32, 375, 248, 2103360 + $ES_MULTILINE)
GUICtrlSetFont ($History, 10, -1, -1, 'Segoe UI Light')
GUICtrlSetBkColor ($History, 0x191919)
GUICtrlSetColor ($History, 0xFFFFFF)
$Send = GUICtrlCreateEdit ('', 0, 280, 375, 70, 2101248)
GUICtrlSetFont ($Send, 10, -1, -1, 'Segoe UI Light')
GUICtrlSetColor ($Send, 0xffffff)
GUICtrlSetBkColor ($Send, 0x191919)
GUISetState (@SW_SHOW)

Else
	Opt("GUIOnEventMode", 0)
    _Metro_MsgBox($MB_SYSTEMMODAL, "ERROR", "PlayHide musst run / conntected!")
	Exit
	EndIf

While 1
	Sleep (15)
	If $Server <> -1 Then
		$Recv = TcpRecv ($Server, 1000000)
		If @Error Then
			GUISetState (@SW_HIDE, $GUI)
			WinSetOnTop ($GUI, '', 0)
			Sleep (100)
			MsgBox (48, 'Notice','You have been disconnected from the server.')
			_Disconnect ()
		EndIf
		If $Recv = 'Error:Username.Exists;' Then
			GUISetState (@SW_HIDE, $GUI)
			WinSetOnTop ($GUI, '', 0)
			Sleep (100)
			MsgBox (48, 'Notice','Your username is already in use, please change it and try again.')
			_Disconnect ()
		ElseIf $Recv = 'Error:Max.Connections;' Then
			GUISetState (@SW_HIDE, $GUI)
			WinSetOnTop ($GUI, '', 0)
			Sleep (100)
			MsgBox (48, 'Notice','Max amount of connections reached, try again later.')
			_Disconnect ()
		ElseIf $Recv = 'Error:IP.Banned;' Then
			GUISetState (@SW_HIDE, $GUI)
			WinSetOnTop ($GUI, '', 0)
			Sleep (100)
			MsgBox (48, 'Notice','Your IP address has been banned.')
			_Disconnect ()
		ElseIf StringLeft ($Recv, 4) = '.log' Then
			FileWriteLine ('Logged.txt', StringTrimLeft ($Recv, 5))
		ElseIf $Recv <> '' Then
			_Log (StringReplace ($Recv, '%Time', @HOUR & ':' & @MIN))
		EndIf
		If _IsPressed ('0D') And GUICtrlRead ($Send) <> '' And ControlGetFocus ($GUI) = 'Edit2' Then
			$Read = StringReplace (GUICtrlRead ($Send), @CRLF, '')
			$Read = StringReplace ($Read, @CR, '')
			$Read = StringReplace ($Read, @LF, '')
			If $Read = '.clear' Then
				GUICtrlSetData ($History, '')
			ElseIf $Read = '.logs' Then
				_Logs ()
			ElseIf $Read = '.save' Then
				FileWrite (@MDAY & '-' & @MON & '-' & @YEAR & '_' & @HOUR & '-' & @MIN & '-' & @SEC & '_Logs.txt', GUICtrlRead ($History))
			ElseIf $Read = '.disconnect' Or $Read = '.exit' Then
				_Disconnect ()
			Else
				TcpSend ($Server, $Read)
			EndIf
			GUICtrlSetData ($Send, '')
		EndIf
	 EndIf
	     $nMsg = GUIGetMsg()
    Switch $nMsg
	  Case $GUI_EVENT_CLOSE, $GUI_CLOSE_BUTTON
		 _Metro_GUIDelete($GUI)
		 Exit
	  Case $GUI_MINIMIZE_BUTTON
		 			GUISetState(@SW_MINIMIZE, $GUI)
	  EndSwitch
WEnd

Func _Logs ()
	$Logs = GUICreate ('Admin Logs', 375, 203, -1, -1, -1, 128)
	GUISetOnEvent ($GUI_EVENT_CLOSE, '_Delete')
	$Edit = GUICtrlCreateEdit ('', 0, 1, 375, 203, 2103360 + $ES_MULTILINE)
	GUICtrlSetFont ($Edit, 10, -1, -1, 'Segoe UI Light')
	GUICtrlSetBkColor ($Edit, 0x83B4FC)
	GUICtrlSetColor ($Edit, 0xFFFFFF)
	GUISetState (@SW_SHOW)
	GUICtrlSetData ($Edit, FileRead ('Logged.txt'))
	WinSetOnTop ($Logs, '', 1)
EndFunc

Func _Delete ()
	GUIDelete ($Logs)
EndFunc

Func _Disconnect ()
	GUICtrlSetData ($History, '')
	TcpCloseSocket ($Server)
	$Server = -1
Exit
EndFunc

Func _Toggle ()
	GUICtrlSetData ($History, '')
	TcpCloseSocket ($Server)
	$Server = -1
Exit
EndFunc

Func _Log ($Data)
	GUICtrlSetData ($History, GUICtrlRead ($History) & $Data & @CRLF)
	_GUICtrlEdit_LineScroll ($History, 0, _GUICtrlEdit_GetLineCount ($History) - 1)
EndFunc

Func _Start ()
	If $username == '' Then Return @Error
	$Server = TcpConnect ($IP, $Port)
	If $Server = -1 Or @Error Then
		Sleep (100)
		 _Metro_MsgBox($MB_SYSTEMMODAL, 'Fatal Error','Unable to connect to the server, change your settings and try again.')
		 Exit
		Return @Error
	EndIf
	Sleep (150)
	TcpSend ($Server, $username)
EndFunc