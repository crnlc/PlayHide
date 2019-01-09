DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1)
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so /rm /pe
#Au3Stripper_Ignore_Funcs=_iHoverOn,_iHoverOff,_iFullscreenToggleBtn,_cHvr_CSCP_X64,_cHvr_CSCP_X86,_iControlDelete
#AutoIt3Wrapper_Res_HiDpi=y
;~ Coded by Ian Maxwell (llewxam)
;~ Based off threaded IP script by Manadar
;~ http://www.autoitscript.com/forum/topic/104334-whats-wrong-with-ping-or-with-me/page__view__findpost__p__740697

;~ Build date January 25 2014

#include "MetroGUI-UDF\MetroGUI_UDF.au3"
#include "MetroGUI-UDF\_GUIDisable.au3"
#include <iNet.au3>
#include <ClipBoard.au3>
#include <Constants.au3>
#include <GuiListBox.au3>
#include <GuiListView.au3>
#include <GuiStatusBar.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>

#NoTrayIcon
TCPStartup()
_Metro_EnableHighDPIScaling()
Local $sFile = "icon.ico"
_SetTheme("DarkPlayHide")
#_SetTheme("DarkTealV2")

$Appname = "PlayHide VPN - Network Scan"
if _Singleton($Appname, 1) = 0 Then
	       _Metro_MsgBox($MB_SYSTEMMODAL, "Error", "Scanner already run!")
    Exit
 EndIf
			if Not ProcessExists("openvpn.exe") then
			_Metro_MsgBox($MB_SYSTEMMODAL, "Error", "Connect PlayHide VPN!")
			Exit
			 EndIf
;~ $HowManyReq = 1 ; number of ping requests in _MSPing
$TimeoutDefault = 500 ; timeout in miliseconds
Global $HostName, $WhichList, $List, $Used, $StartTime, $Finished, $CurrentIP, $CurrentIndex, $FreeCount, $Progress, $CurrentlyScanning, $FinishMessage, $fDblClkMessage
Global Const $MAX_PROCESS = 30 ; maximum processes at once
Global $fDblClk = False, $aLV_Click_Info

$Found = 0 ;how many active connections you have
$LocalIP1 = @IPAddress1
If $LocalIP1 <> "0.0.0.0" Then $Found += 1

If $Found == 0 Then
	MsgBox(16, "OOPS", "There are no adapters with an IP address present.  Please check your adapters and cables.")
	Exit
EndIf
If $Found > 1 Then ; if there is more than one network available you will be prompted to choose which to scan
	$Choose = GUICreate("Choose an IP range", 240, 115, (@DesktopWidth / 2) - 120, @DesktopHeight / 4)
	GUISetBkColor(0xb2ccff, $Choose)
	GUISetFont(8.5)
	$IPShow = StringSplit($LocalIP1, ".")
	$Button1 = GUICtrlCreateButton($IPShow[1] & "." & $IPShow[2] & "." & $IPShow[3] & ".xxx", 5, 5, 110, 40)
	$IPShow = StringSplit($LocalIP2, ".")
	$Button2 = GUICtrlCreateButton($IPShow[1] & "." & $IPShow[2] & "." & $IPShow[3] & ".xxx", 125, 5, 110, 40)
	$IPShow = StringSplit($LocalIP3, ".")
	$Button3 = GUICtrlCreateButton($IPShow[1] & "." & $IPShow[2] & "." & $IPShow[3] & ".xxx", 5, 50, 110, 40)
	$IPShow = StringSplit($LocalIP4, ".")
	$Button4 = GUICtrlCreateButton($IPShow[1] & "." & $IPShow[2] & "." & $IPShow[3] & ".xxx", 125, 50, 110, 40)
	If @IPAddress1 == "0.0.0.0" Then GUICtrlDelete($Button1)
	GUISetState(@SW_SHOW, "Choose an IP range")
	Do
		$MSG = GUIGetMsg()
		If $MSG == $GUI_EVENT_CLOSE Then Exit
		If $MSG == $Button1 Then
			$ChosenIP = @IPAddress1
			ExitLoop
		EndIf
	Until 1 == 2
	GUIDelete("Choose an IP range")
Else ; if only one network is available, skip the selection GUI and go
	If $LocalIP1 <> "0.0.0.0" Then $ChosenIP = $LocalIP1
EndIf
$GUI = _Metro_CreateGUI("Network Scan", 340, 360, -1, -1, true,false)
$Control_Buttons = _Metro_AddControlButtons(True,False,False,False,False)
$GUI_CLOSE_BUTTON = $Control_Buttons[0]
GUICtrlCreateLabel($AppName, 10, 7, 300, 30)
GUICtrlSetFont(-1, 11, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$Rescan = _Metro_CreateButtonEx2("Rescan", 240, 40, 90, 30, $ButtonBKColor)
$CopyToClip = _Metro_CreateButtonEx2("Copy IP", 10, 40, 100, 30, $ButtonBKColor)
$Used = _GUICtrlListView_Create($GUI, "IP Address|Hostname|Ping", 10, 85, 320, 250)
#_GUICtrlListView_SetBkColor($Used, 0x191919)
_GUICtrlListView_SetColumnWidth($Used, 0, 80)
_GUICtrlListView_SetColumnWidth($Used, 1, 180)
_GUICtrlListView_SetColumnWidth($Used, 2, 60)
 _GUICtrlListView_SetOutlineColor($Used, 0xffffff)
Local $AccelKeys[8][2] = [["^c", $CopyToClip],["^n", $Rescan]]
GUISetAccelerators($AccelKeys)
GUISetState(@SW_SHOW, $GUI)

GUIRegisterMsg($WM_NOTIFY, "_DoubleClick")

$Gateway=_GetGateway()
_Scan()

Do
	$MSG = GUIGetMsg()
	If $MSG == $GUI_CLOSE_BUTTON Then Exit
	If $MSG == $CopyToClip Then _CopyToClip()
	If $MSG == $Rescan Then
		_GUICtrlListView_DeleteAllItems($Used)
		_Scan()
	EndIf
	If $fDblClk Then
		$fDblClk = False
		Switch $aLV_Click_Info[1]
			Case 0 ; On Item
				$sText = _GUICtrlListView_GetItemText($Used, $aLV_Click_Info[0])
				_PingSpecific($sText)
		EndSwitch
	EndIf
Until 1 == 2
Exit


func _GetGateway()
	$zPID = Run(@ComSpec & " /c" & "ipconfig","", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	Local $zOutput = ""
	While 1
		$zOutput &= StdoutRead($zPID)
		If @error Then ExitLoop
	Wend
	$zBreak=StringSplit($zOutput,@CR)
	for $a=1 to $zBreak[0]
		if StringInStr($zBreak[$a],$ChosenIP) Then
			$zGetGatewayLine=$zBreak[$a+2]
			$zGetGateway=StringMid($zGetGatewayLine,41,StringLen($zGetGatewayLine)-40)
			ExitLoop
		EndIf
	next
	return $zGetGateway
EndFunc

Func _Scan()
	GUICtrlDelete($FinishMessage)
	GUICtrlDelete($fDblClkMessage)
	GUICtrlSetState($CopyToClip, $GUI_DISABLE)
	GUICtrlSetState($Rescan, $GUI_DISABLE)
	$Progress = GUICtrlCreateProgress(10, 340, 318, 10)

	Local $a_process[$MAX_PROCESS] ; an array to keep a reference to spawned processes, in the next loop we fill it with value 0
	For $n = 0 To UBound($a_process) - 1
		$a_process[$n] = 0
	Next

	$Oct = StringSplit($ChosenIP, ".")
	$Range = $Oct[1] & "." & $Oct[2] & "." & $Oct[3] & "." ; now we just add an incrementing number and ping away
	Local $Address[255]
	For $i = 0 To 254
		$Address[$i] = $Range & $i ; we generate some IPs
	Next

	Local $i = 0 ; a pointer to run through the $Address array
	$Finished = 0 ; <==== new line
	$CurrentIndex = 0; needed to keep the _GUICtrlListView_AddSubItem working right...
	$FreeCount = 0
	AdlibRegister("_Display", 100)
	$StartTime = TimerInit()

	Do
		; check on the current processes, and look if there is one finished for use with our next host in line (from $Address)
		For $n = 0 To UBound($a_process) - 1
			$MSG = GUIGetMsg()
			If $MSG == $GUI_EVENT_CLOSE Then Exit
			If($i <> UBound($Address) And $a_process[$n] == 0) Then ; check if we need a spot, and there is an existing spot
				; there is an empty spot
				$a_process[$n] = _MSPing($Address[$i])
				$i += 1
			Else
				; something is running here, let's check on the output
				If($a_process[$n] <> 0 And _MSPingIsReady($a_process[$n])) Then
					$CurrentIP = _MSPingGetHostname($a_process[$n])
					$PingTime = _MSPingGetResult($a_process[$n])
					$ShowHost = StringSplit($CurrentIP, ".")
					$LastOct = StringFormat("%.3i", $ShowHost[4])
					If($PingTime <> -1) Then
						_GUICtrlListView_AddItem($Used, $ShowHost[1] & "." & $ShowHost[2] & "." & $ShowHost[3] & "." & $LastOct, $CurrentIndex)
						_GUICtrlListView_AddSubItem($Used, $CurrentIndex, $PingTime & "ms", 2)
						_GUICtrlListView_AddSubItem($Used, $CurrentIndex, "Scan Client.....", 1)
						$HostName = _HostName($CurrentIP)
						_GUICtrlListView_AddSubItem($Used, $CurrentIndex, $HostName, 1)

						$CurrentIndex += 1
					Else
						$FreeCount += 1
					EndIf
					; free up an empty space for the next address to Ping
					$a_process[$n] = 0
					$Finished += 1 ; <=== new line
					If($Finished == UBound($Address)) Then
						ExitLoop 2 ; return
					EndIf
				EndIf
			EndIf
		Next
	Until 1 == 2
	AdlibUnRegister()
	_Display()
	GUICtrlDelete($Progress)
	GUICtrlSetState($CopyToClip, $GUI_ENABLE)
	GUICtrlSetState($Rescan, $GUI_ENABLE)
EndFunc   ;==>_Scan

Func _CopyToClip()
	$IP = ""
	$Index = _GUICtrlListView_GetSelectedIndices($Used, False)
	If $Index <> "" Then $IP = _GUICtrlListView_GetItemText($Used, $Index, 0)
	If $IP <> "" Then
		$Oct = StringSplit($IP, ".")
		$Last = Number($Oct[4]) ; strips out any leading 0s
		$FinalIP = $Oct[1] & "." & $Oct[2] & "." & $Oct[3] & "." & $Last
		_ClipBoard_SetData($FinalIP)
				  _Metro_MsgBox($MB_SYSTEMMODAL, "Info", "IP address " & $FinalIP & " sent to clipboard")
				  _GUIDisable($GUI)

	Else
				 _Metro_MsgBox($MB_SYSTEMMODAL, "Error", "You have not selected an IP address yet.")
				 _GUIDisable($GUI)
	EndIf
 EndFunc   ;==>_CopyToClip

Func _PingSpecific($PingIP)
	SplashTextOn("", "Please wait, pinging " & $PingIP, 200, 80, (@DesktopWidth / 2) - 100, (@DesktopHeight / 2) - 40)
	$CMD = "ping " & $PingIP & " -n 4"
	$PID = Run($CMD, @ScriptDir, @SW_HIDE, "0x2")
	$Text = ""
	While ProcessExists($PID)
		$Line = StdoutRead($PID, 0)
		If @error Then ExitLoop
		$Text &= $Line
	WEnd
	SplashOff()
   _Metro_MsgBox($MB_SYSTEMMODAL, "Result", $Text)
   _GUIDisable($GUI)
EndFunc   ;==>_PingSpecific

Func _MSPing($CurrentIP, $Timeout = $TimeoutDefault)
	Local $Return_Struc[4]
	; [0] = Result (in ms)
	; [1] = The hostname originally used
	; [2] = Process handle (for internal use only)
	; [3] = Buffer (for internal use only)
	$Return_Struc[1] = $CurrentIP
	$Return_Struc[2] = Run("ping " & $CurrentIP & " -n 1 -w " & $Timeout, "", @SW_HIDE, $STDOUT_CHILD)
	Return $Return_Struc
EndFunc   ;==>_MSPing
Func _MSPingIsReady(ByRef $Return_Struc)
	Return ___MSPingReadOutput($Return_Struc)
EndFunc   ;==>_MSPingIsReady
Func _MSPingGetResult($Return_Struc)
	Return $Return_Struc[0]
EndFunc   ;==>_MSPingGetResult
Func _MSPingGetHostname($Return_Struc)
	Return $Return_Struc[1]
EndFunc   ;==>_MSPingGetHostname
; Internal use only
Func ___MSPingReadOutput(ByRef $Return_Struc)
	$data = StdoutRead($Return_Struc[2])
	If(@error) Then
		___MSPingParseResult($Return_Struc)
		Return 1
	Else
		$Return_Struc[3] &= $data
		Return 0
	EndIf
EndFunc   ;==>___MSPingReadOutput
; Internal use only
Func ___MSPingParseResult(ByRef $Return_Struc)
	$Result = StringRegExp($Return_Struc[3], "([0-9]*)ms", 3)
	If @error Then
		$Return_Struc[0] = -1
	Else
		$Return_Struc[0] = $Result[0]
	EndIf
EndFunc   ;==>___MSPingParseResult

Func _HostName($CurIP)
	GUICtrlSetData($CurrentlyScanning, $CurrentIP)
	$DevName = _TCPIpToName($CurIP)
	If @error Then $DevName = "Unknown"
	if $CurIP==$ChosenIP Then
		$DevName&=" (** this PC)"
	endif
	if $CurIP==$Gateway Then
		$DevName&=" (** gateway)"
	endif
	Return $DevName
EndFunc   ;==>_HostName

Func _Display()
	GUICtrlSetData($Progress, ($Finished / 255) * 100)
	GUICtrlSetData($CurrentlyScanning, $CurrentIP)
EndFunc   ;==>_Display

; WM_NOTIFY event handler
Func _DoubleClick($hWnd, $iMsg, $iwParam, $ilParam)
	Local $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	If HWnd(DllStructGetData($tNMHDR, "hWndFrom")) == $Used And DllStructGetData($tNMHDR, "Code") == $NM_DBLCLK Then
		$aLV_Click_Info = _GUICtrlListView_SubItemHitTest($Used)
		; as long as the click was on an item or subitem
		If $aLV_Click_Info[0] <> -1 Then $fDblClk = True
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_DoubleClick