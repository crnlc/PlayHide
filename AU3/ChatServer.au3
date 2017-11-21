#cs
##########################################
Autoit Chat By Protex (Server)
##########################################

#ce



#include <Array.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#Include <GuiEdit.au3>
#include <TCP.au3>

Global $userArray[1], $DataString
$hConsole = GUICreate("Server Console",200,200,1,1,$WS_POPUP)
$hConsoleList = GUICtrlCreateEdit("",10,10,180,180,$ES_READONLY)

_consoleWrite('Server Started')
_consoleWrite('Server IP : ' &@IPAddress1)
GUISetState()
 $hServer = _TCP_Server_Create(88); A server. Tadaa!
_TCP_RegisterEvent($hServer, $TCP_NEWCLIENT, "NewClient"); Whooooo! Now, this function (NewClient) get's called when a new client connects to the server.
_TCP_RegisterEvent($hServer, $TCP_DISCONNECT, "Disconnect"); And this,... this will get called when a client disconnects.
_TCP_RegisterEvent($hServer, $TCP_RECEIVE, "_Received")

 While 1
 WEnd


Func _consoleWrite($String)
	$DataString = $DataString&@CRLF&$String
	GUICtrlSetData($hConsoleList,$DataString)
	_GUICtrlEdit_LineScroll($hConsoleList, 0, _GUICtrlEdit_GetLineCount($hConsoleList))
EndFunc
Func _FormatRecieved($String)
	$aArray = StringSplit($String,'~',2)
	Return $aArray
EndFunc
Func _Received($hSocket, $sReceived, $iError)
	$sReceived = _FormatRecieved($sReceived)
	If $sReceived[0] = 'clientAdd' Then
		_UserArraydel($sReceived[1],$hSocket, $iError)
		_UserArrayAdd($sReceived[1],$hSocket, $iError)
	ElseIf $sReceived[0] = 'clientdel' Then
		_UserArraydel($sReceived[1],$hSocket, $iError)
	Elseif $sReceived[0] = 'chat' Then
		_consoleWrite('Client Broadcast'&@CRLF&'(Message: '&$sReceived[1]& ' Socket: '&$hSocket&')')
		_TCP_Server_Broadcast('chat~'&$sReceived[1])
	ENdif
EndFunc
 Func NewClient($hSocket, $iError); Yo, check this out! It's a $iError parameter! (In case you didn't noticed: It's in every function)
		 _TCP_Send($hSocket, 'Connected')
 EndFunc

 Func Disconnect($hSocket, $iError); Damn, we lost a client. Time of death: @Hour & @Min & @Sec :P
		_consoleWrite("Client Disconnected"&@CRLF&"(Socket: "&$hSocket&')')
EndFunc

Func _UserArrayAdd($Nick,$hSocket, $iError)
	_consoleWrite("Client Connected"&@CRLF&"(NickName: "&$Nick& " Socket: "&$hSocket&')')
	_ArrayAdd($userArray,$Nick)
	_sendUserArray($hSocket,$iError)
EndFunc

Func _UserArraydel($Nick,$hSocket, $iError)
	$index = _ArraySearch($userArray,$Nick,1,UBound($userArray)-1)
	If $index > 0 Then
	_ArrayDelete($userArray,$index)
	_sendUserArray($hSocket, $iError)
	EndIf
EndFunc

Func _sendUserArray($hSocket, $iError)
	$userString = _ArrayToString($userArray)
	_TCP_Server_Broadcast('userArray~'&$userString)
EndFunc