#cs
##########################################
Autoit Chat By Protex (Client)
##########################################

#ce
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
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so /rm /pe
#Au3Stripper_Ignore_Funcs=_iHoverOn,_iHoverOff,_iFullscreenToggleBtn,_cHvr_CSCP_X64,_cHvr_CSCP_X86,_iControlDelete
#AutoIt3Wrapper_Res_HiDpi=y
_Metro_EnableHighDPIScaling()
Local $sFile = "icon.ico"
#TraySetIcon($sFile)

#include <Date.au3>
#include <EditConstants.au3>
#include <File.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <IE.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <Color.au3>
#include <TCP.au3>
#include <Array.au3>
#include "MetroGUI-UDF\MetroGUI_UDF.au3"
#include "MetroGUI-UDF\_GUIDisable.au3"
#include-once
#NoTrayIcon

Global $GUITitle="PlayHide Chat"
Global $ImageDir = @ScriptDir& '/Data/png/'
Global $ServerPort = 88
Global $myColor="0xFF8700"
Global $mypw="PWbTSAE"
Global $SysErrorColor = '0xFF0000'
Global $SysColor = '0x00FF00'
Global $sock = 0
Global $NickName = IniRead(@ScriptDir &'/Settings.ini','Settings','NickName','Guest'&Random(1,100,1))
Global $ServerIP = "10.5.1.10"
If $NickName = '' Then $NickName = 'Guest'&Random(1,100,1)
Global $constatus = 'Disconnected'
Global $hChild, $hGraphic, $aSmileyFiles, $ahImage, $ahDummy
Global $hSocket, $iError, $hClient
Global $connected = False
Global $LastSendString
Opt("TrayMenuMode",0)
#TraySetState(8)
#TraySetToolTip ("PlayHide Chat")
_SetTheme("DarkTeal")

				If ProcessExists("openvpn.exe") Then

Local $hGUI = _Metro_CreateGUI($GUITitle, 595, 392, -1, -1, true,false)
	    GUICtrlSetBkColor($hGUI, 0x191919)
$Control_Buttons = _Metro_AddControlButtons(True,False,True,False,False)
$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]

Global $Chat = _Chatbox_Create($hGUI, 20, 70, 400, 225, 0x191919, "")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Info = GUICtrlCreateLabel('Name :    ' & $NickName ,10,5,150,50)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$ChatInput = GUICtrlCreateInput('',20,315,400,20)
    GUICtrlSetBkColor($ChatInput, 0x191919)
	GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)


GUICtrlSetState($ChatInput,$GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$UserListe = GUICtrlCreateList("", 450, 70, 130, 160,$ES_READONLY)
    GUICtrlSetBkColor($UserListe, 0x191919)
	GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$btnSmileys = _Metro_CreateButton('Emoji',455,247,120,20)
GUIctrlSetState($btnSmileys,$GUI_DISABLE)
GUIctrlSetState($btnSmileys,$GUI_HIDE)
$btnConfig = _Metro_CreateButton('Nickname',455,270,120,20)
$btnConnect = _Metro_CreateButton('Reconnect',455,247,120,20)
$btnSenden = _Metro_CreateButton('Send',455,318,120,50)
GUIctrlSetState($btnSenden,$GUI_DISABLE)
Dim $AccelKeys[2][2]=[["{ENTER}", $btnSenden], ["{ESC}", $GUI_EVENT_CLOSE]]
GUISetAccelerators($AccelKeys)

GUISetState(@SW_SHOW)
_Try2Connect()
Else
    _Metro_MsgBox($MB_SYSTEMMODAL, "ERROR", "No Connection to Network")
	Exit
				EndIf

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $GUI_CLOSE_BUTTON
			_Disconnected($hClient, $iError)
			_exit()
					 _Metro_GUIDelete($hGUI)

						   Case $GUI_MINIMIZE_BUTTON
			GUISetState(@SW_MINIMIZE, $hGUI)
		Case $btnSenden
			_Try2Send()
		Case $btnConnect
			_Try2Connect()
		Case $btnConfig
			_configGUI($hClient, $iError)
		Case $btnSmileys
			_Chatbox_SmileyToText($ChatInput,$ImageDir, -1, -1, $hGUI)
			GUICtrlSetState($ChatInput, $GUI_FOCUS)
		 EndSwitch

WEnd

Func _Try2Connect()
	If $connected = False Then
		$hClient = _TCP_Client_Create($ServerIP, 88); Create the client. Which will connect to the local ip address on port 88
		;_TCP_RegisterEvent($hClient, $TCP_CONNECT, "_Connected"); And func "Connected" will get called when the client is connected.
		_TCP_RegisterEvent($hClient, $TCP_RECEIVE, "_Received"); Function "Received" will get called when something is received
		_TCP_RegisterEvent($hClient, $TCP_DISCONNECT, "_Disconnected"); And "Disconnected" will get called when the server disconnects us, or when the connection is lost.

	Else
		_Disconnected($hClient, $iError)
	EndIf
EndFunc
Func _Connected(); We registered this (you see?), When we're connected (or not) this function will be called.
		GUIctrlSetState($btnSenden,$GUI_ENABLE)
		GUICtrlSetState($ChatInput,$GUI_ENABLE)
		GUIctrlSetState($btnSmileys,$GUI_ENABLE)
		GUICtrlSetData($btnConnect,'Disconnect')
		_TCP_Send($hClient,'clientAdd~'&$NickName)
		$constatus = 'Connected'
		$connected = True
		_setInfo()
		_Chatbox_SetData($Chat, "[b][" & _NowTime() & "]  " & 'Connected to Server	 [/b]', $SysColor)
		GUICtrlSetState($ChatInput, $GUI_FOCUS)
EndFunc
Func _FormatRecieved($String)
	$aArray = StringSplit($String,'~',2)
	Return $aArray
EndFunc


Func _Received($hClient, $sReceived, $iError)
	$sReceived = _FormatRecieved($sReceived)
	If $sReceived[0] = 'Connected' Then
			_Connected()
	ElseIf $sReceived[0] = 'userArray' Then
			_userArrayUpdate($sReceived[1])
	Elseif $sReceived[0] = 'chat' Then
			_Chatbox_SetData($Chat, "[b][" & _NowTime() & "]  " & $NickName &': ' & $sReceived[1], 0x68838B)
	EndIf
EndFunc

Func _userArrayUpdate($userString)
	GUICtrlSetData($UserListe,'')
	GUICtrlSetData($UserListe,$userString)
EndFunc
Func _Disconnected($hClient, $iError); Our disconnect function. Notice that all functions should have an $iError parameter.
	$connected = False
	$constatus = 'Disconnected'
	_setInfo()
	GUIctrlSetState($btnSenden,$GUI_DISABLE)
	GUICtrlSetState($ChatInput,$GUI_DISABLE)
	GUIctrlSetState($btnSmileys,$GUI_DISABLE)
	GUICtrlSetData($btnConnect,'Connect')
	_TCP_Send($hClient,'clientdel~'&$NickName)
	_TCP_Client_Stop($hClient)
	_Chatbox_SetData($Chat, "[b][" & _NowTime() & "]  " & 'Disconnected from Server [/b]', $SysErrorColor)
	GUICtrlSetData($UserListe,'')
EndFunc

Func _setInfo()
	GUICtrlSetData($info,'Name :    ' & $NickName)
EndFunc
Func _Try2Send()
	If GUICtrlRead($ChatInput) <> '' Then
		_TCP_Send($hClient, 'chat~'&GUICtrlRead($ChatInput))
		GUICtrlSetData($ChatInput,'')
	EndIf
EndFunc
Func _exit()
	_writeCfg()
	TCPShutdown()
	Exit
EndFunc
Func _configGUI($hClient, $iError)
	$oldNick = $NickName
	$NickName = _Metro_InputBox2("Your NickName",$NickName, "", False, False)
	If $constatus = 'Connected' Then
	_TCP_Send($hClient,'clientdel~'&$oldNick)
	Sleep(100)
	_TCP_Send($hClient,'clientAdd~'&$NickName)
EndIf
	_setInfo()
	_writeCfg()
EndFunc
Func _writeCfg()
	IniWrite(@ScriptDir & '/Settings.ini','Settings','NickName',$NickName)
 EndFunc

Func _Chatbox_Create($hWnd, $iLeft, $iTop, $iWidth, $iHeight, $iBgColor = 0x191919, $sLogfile = '', $sImgPath = '')
	Local $ahChat[5], $sTempFile, $oBody
	$ahChat[0] = _IECreateEmbedded()
	If @error Then Return SetError(1, 0, 0)
	GUISwitch($hWnd)
	$ahChat[1] = GUICtrlCreateObj($ahChat[0], $iLeft, $iTop, $iWidth, $iHeight)
	GUICtrlSetResizing(-1, 1)
	If $ahChat[1] = 0 Then Return SetError(2, 0, 0)
	If Not FileExists($sImgPath) Then $sImgPath = @ScriptDir & '\png\'
	If StringRight($sImgPath, 1) <> '\' Then $sImgPath &= '\'
	$ahChat[2] = '<html>' & @CRLF & '<head>' & @CRLF & '<title>Chatbox</title>' & @CRLF & '<style type="text/css">body { background-color:#' & Hex($iBgColor, 6)
	$ahChat[2] &= '; padding:0px; margin:4px; } p { margin:4px; }</style>' & @CRLF & '</head>' & @CRLF & '<body>' & @CRLF & '</body>' & @CRLF & '</html>'
	$sTempFile = @TempDir & '\ChatboxTemp.html'
	$hFile = FileOpen($sTempFile, 2)
	FileWrite($hFile, $ahChat[2])
	FileClose($hFile)
	_IENavigate($ahChat[0], $sTempFile)
	$ahChat[3] = ''
	If $sLogfile <> '' Then
		If FileCopy($sTempFile, $sLogfile, 9) Then $ahChat[3] = $sLogfile
	EndIf
	FileDelete($sTempFile)
	$ahChat[4] = $sImgPath
	Return $ahChat
EndFunc   ;==>_Chatbox_Create

Func _Chatbox_SetData(ByRef $ahChat, $sMsg, $iColor = 0xffffff, $iSize = 2, $iImgSize = 19)
	If Not IsArray($ahChat) Then Return SetError(1, 0, 0)
	If UBound($ahChat) <> 5 Then Return SetError(2, 0, 0)
	Local $hFile, $oBody
	$sMsg = StringRegExpReplace($sMsg, '(?s)<.*?>', '')
	$sMsg = StringRegExpReplace($sMsg, '(?s)(?i)\[hr\]', '<hr>')
	$sMsg = StringRegExpReplace($sMsg, '(?s)(?i)\[(\/*b|\/*i|\/*u)\]', '<$1>')
	$sMsg = StringRegExpReplace($sMsg, '(?s)(?i)\[(color=.+?)\](.*?)\[\/(color)\]', '<font $1>$2</font>')
	$sMsg = StringRegExpReplace($sMsg, '(?s)(?i)\[(size=.+?)\](.*?)\[\/(size)\]', '<font $1>$2</font>')
    $sMsg = '<p><font face="tahoma" color="#' & Hex($iColor, 6) & '" size="' & $iSize & '">' & $sMsg & '</font></p>'
	$sMsg = StringReplace($sMsg, @CRLF, '<br>')
	$sMsg = _Chatbox_ConvertSmilies($sMsg, $ahChat[4], $iImgSize)
	$sMsg = _Chatbox_ConvertMailto($sMsg)
	$sMsg = _Chatbox_ConvertHyperlink($sMsg)
	$oBody = _IETagNameGetCollection($ahChat[0], 'body', 0)
	_IEDocInsertHTML($oBody, $sMsg)
	$oBody.scrollTop = 0x5FFFFFFF
	If $ahChat[3] <> '' Then
		$ahChat[2] = StringRegExpReplace($ahChat[2], '(?s)(.+<body>.*)(</body>.+</html>)', '$1' & $sMsg & @CRLF & '$2')
		$hFile = FileOpen($ahChat[3], 2)
		If $hFile = -1 Then Return SetError(3, 0, 0)
		FileWrite($hFile, $ahChat[2])
		FileClose($hFile)
	EndIf
	Return 1
EndFunc   ;==>_Chatbox_SetData

Func _Chatbox_ConvertSmilies($sMsg, $sImgPath, $iImgSize)
	Local $sImgDim = ' width="' & $iImgSize & '" height="' & $iImgSize & '">'
	Local $aSmilies[18][2] = [ _
			[':-)', 'smile'],[';-)', 'hehe'],[':-D', 'haha'],[':-(', 'sad'],[':-/', 'hmm'], _
			[':-o', 'oh'],[':-p', 'grimace'],[':cry:', 'cry'],[':love:', 'love'],[':mute:', 'mute'], _
			[':angry:', 'angry'],[':cool:', 'cool'],[':shame:', 'shame'],[':sleep:', 'sleep'], _
			[':sick:', 'sick'],[':kiss:', 'kiss'],[':yum:', 'yum'],[':wacko:', 'wacko']]
	$sImgPath = StringReplace($sImgPath, '\', '/')
	For $i = 0 To UBound($aSmilies) - 1
		$sMsg = StringReplace($sMsg, $aSmilies[$i][0], ' <img src="file:///' & $sImgPath & $aSmilies[$i][1] & '.png"' & $sImgDim)
	Next
	Return $sMsg
EndFunc   ;==>_Chatbox_ConvertSmilies

Func _Chatbox_ConvertMailto($sMsg)
	Local $aReplace = StringRegExp($sMsg, '([a-zA-Z0-9\-.]+@[a-zA-Z0-9\-.]+\.[a-zA-Z0-9\-.]+)', 3)
	If Not IsArray($aReplace) Then Return $sMsg
	For $i = 0 To UBound($aReplace) - 1
		$sMsg = StringReplace($sMsg, $aReplace[$i], ' <a href="mailto:' & $aReplace[$i] & '">' & $aReplace[$i] & '</a>')
	Next
	Return $sMsg
EndFunc   ;==>_Chatbox_ConvertMailto

Func _Chatbox_ConvertHyperlink($sMsg)
	Return StringRegExpReplace($sMsg, ' [http:\/\/]*([a-zA-Z0-9\-]+\.[a-zA-Z0-9\-]+\.[a-zA-Z0-9_\/\-\.\?&%=\+]+)', '<a href="http://$1" target="_blank">$1</a>')
EndFunc   ;==>_Chatbox_ConvertHyperlink

Func _Chatbox_SmileyToText($hID, $sImgPath = '', $iLeft = -1, $iTop = -1, $hParent = '')
	Local $aSmilies[18][2] = [ _
			[' :-)', 'smile'],[' ;-)', 'hehe'],[' :-D', 'haha'],[' :-(', 'sad'],[' :-/', 'hmm'], _
			[' :-o', 'oh'],[' :-p', 'grimace'],[' :cry:', 'cry'],[' :love:', 'love'],[' :mute:', 'mute'], _
			[' :angry:', 'angry'],[' :cool:', 'cool'],[' :shame:', 'shame'],[' :sleep:', 'sleep'], _
			[' :sick:', 'sick'],[':kiss:', 'kiss'],[':yum:', 'yum'],[':wacko:', 'wacko']]
	Local $iWidth, $iSmiley, $aInfo, $sReturn = ''
	If Not GUICtrlGetHandle($hID) Then Return SetError(1, 0, 0)
	If $sImgPath = '' Then $sImgPath = @ScriptDir & '\png\'
	$aSmileyFiles = _FileListToArray($sImgPath, '*.png', 1)
	If @error Then Return SetError(2, 0, 0)
	If $aSmileyFiles[0] <> UBound($aSmilies) Then Return SetError(3, 0, 0)
	Global $ahImage[$aSmileyFiles[0]], $ahDummy = $ahImage
	Local $iOld = Opt('GUIOnEventMode', 0)
	_GDIPlus_Startup()
	$iWidth = 16 + $aSmileyFiles[0] * 27
	$hChild = GUICreate('SmileyToText', $iWidth, 64, $iLeft, $iTop, 0x00080000, Default, $hParent)
	GUISetIcon($sImgPath & 'prog.ico')
	GUISetBkColor(0xBBBBBB)
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hChild)
	GUISetState()
	If $hParent <> '' Then WinSetState($hParent, '', @SW_DISABLE)
	GUIRegisterMsg($WM_PAINT, '__Chatbox_WM_PAINT')
	For $i = 1 To $aSmileyFiles[0]
		$ahDummy[$i - 1] = GUICtrlCreateLabel('', 8 + ($i - 1) * 27, 8, 19, 19)
		$ahImage[$i - 1] = _GDIPlus_ImageLoadFromFile($sImgPath & $aSmileyFiles[$i])
		_GDIPlus_GraphicsDrawImage($hGraphic, $ahImage[$i - 1], 8 + ($i - 1) * 27, 8)
	Next
	While True
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				$sReturn = ''
				ExitLoop
			Case $GUI_EVENT_PRIMARYUP
				$aInfo = GUIGetCursorInfo($hChild)
				$iSmiley = $aInfo[4] - $ahDummy[0]
				If $iSmiley >= 0 Then
					For $i = 0 To UBound($aSmilies) - 1
						If StringInStr($aSmileyFiles[$iSmiley + 1], $aSmilies[$i][1]) Then
							$sReturn = $aSmilies[$i][0]
							GUICtrlSetData($hID, $sReturn, 1)
							ExitLoop 2
						EndIf
					Next
				EndIf
			 EndSwitch
	WEnd
	For $i = 1 To $aSmileyFiles[0]
		_GDIPlus_ImageDispose($ahImage[$i - 1])
	Next
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	GUIDelete($hChild)
	If $hParent <> '' Then WinSetState($hParent, '', @SW_ENABLE)
	Opt('GUIOnEventMode', $iOld)
EndFunc   ;==>_Chatbox_SmileyToText

Func __Chatbox_WM_PAINT($hWnd, $Msg, $wParam, $lParam)
	_WinAPI_RedrawWindow($hChild, 0, 0, $RDW_UPDATENOW)
	For $i = 1 To $aSmileyFiles[0]
		_GDIPlus_GraphicsDrawImage($hGraphic, $ahImage[$i - 1], 8 + ($i - 1) * 27, 8)
	Next
	_WinAPI_RedrawWindow($hChild, 0, 0, $RDW_VALIDATE)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>__Chatbox_WM_PAINT

