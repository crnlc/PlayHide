#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         Kip

 Script Function:
	TCP UDF v3

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#cs

Functions:

	_TCP_Server_Create($iPort, $sIP="0.0.0.0")
	_TCP_Server_Broadcast($sData)
	_TCP_Server_ClientList()
	_TCP_Server_ClientIP($hSocket)
	_TCP_Server_DisconnectClient($hSocket)
	_TCP_Server_Stop()


	_TCP_Client_Create($sIP , $iPort)
	_TCP_Client_Stop($hSocket)


	_TCP_Send($hSocket, $sText)
	_TCP_RegisterEvent($hSocket, $iEvent, $sFunction)


Register event values:

	$TCP_SEND				; Function ($hSocket, $iError)
	$TCP_RECEIVE			; Function ($hSocket, $sReceived, $iError)
	$TCP_CONNECT			; Function ($hSocket, $iError)					=> Client only
	$TCP_DISCONNECT			; Function ($hSocket, $iError)
	$TCP_NEWCLIENT			; Function ($hSocket, $iError) 					=> Server only


#ce


Global Const $FD_READ = 1
Global Const $FD_WRITE = 2
Global Const $FD_OOB = 4
Global Const $FD_ACCEPT = 8
Global Const $FD_CONNECT = 16
Global Const $FD_CLOSE = 32
Global $hWs2_32 = -1

Global Const $TCP_SEND = 1
Global Const $TCP_RECEIVE = 2
Global Const $TCP_CONNECT = 4
Global Const $TCP_DISCONNECT = 8
Global Const $TCP_NEWCLIENT = 16


TCPStartup()
Global Const $__TCP_WINDOW = GUICreate("Async Sockets UDF")
Global $__TCP_SOCKETS[1][7]





; #FUNCTION# ;===============================================================================
;
; Name...........: _TCP_Server_Create
; Description ...: Initializes the server.
; Syntax.........: _TCP_Server_Create($iPort, $sIP="0.0.0.0")
; Parameters ....: 	$iPort	- The port number the server should listen to.
;					$sIP	- IP address. (Default = "0.0.0.0")
; Return values .: The socket handle.
; Author ........: Kip
; Modified.......:
; Remarks .......: Only 1 server can be created per script.
; Related .......:
; Link ..........;
; Example .......;
;
; ;==========================================================================================

Func _TCP_Server_Create($iPort, $sIP="0.0.0.0")

	Local $hListenSocket = ___ASocket()


	___ASockSelect( $hListenSocket, $__TCP_WINDOW, 0x0400, $FD_ACCEPT)
	GUIRegisterMsg( 0x0400, "___TCP_OnAccept" )


	___ASockListen( $hListenSocket, $sIP, $iPort )

	$__TCP_SOCKETS[0][0] = $hListenSocket
	$__TCP_SOCKETS[0][1] = 0x0400

	Return $hListenSocket

EndFunc





Func ___TCP_OnAccept($hWnd, $iMsgID, $WParam, $LParam)

	Local $hSocket = $WParam
	Local $iError = ___HiWord( $LParam )
	Local $iEvent = ___LoWord( $LParam )

	Local $hClient, $uBound

	Abs($hWnd) ; Stupid AU3Check...

	If $iMsgID = $__TCP_SOCKETS[0][1] Then

		If $iEvent = $FD_ACCEPT Then

			If Not $iError Then

				ReDim $__TCP_SOCKETS[UBound($__TCP_SOCKETS)+1][7]
				$uBound = UBound($__TCP_SOCKETS)

				$hClient = TCPAccept($hSocket)

				___ASockSelect($hClient, $__TCP_WINDOW, 0x0400 + $uBound - 1, BitOR($FD_READ, $FD_WRITE, $FD_CLOSE))
				GUIRegisterMsg(0x0400 + $uBound - 1, "___TCP_Server_OnSocketEvent" )

				$__TCP_SOCKETS[UBound($__TCP_SOCKETS)-1][0] = $hClient
				$__TCP_SOCKETS[UBound($__TCP_SOCKETS)-1][1] = 0x0400 + $uBound - 1

				Call($__TCP_SOCKETS[0][6], $hClient, $iError)

			Else

				Call($__TCP_SOCKETS[0][6], 0, $iError)

			EndIf

		ElseIf $iEvent = $FD_CONNECT Then

			Call($__TCP_SOCKETS[0][4], $hSocket, $iError)

		EndIf

	EndIf


EndFunc






; #FUNCTION# ;===============================================================================
;
; Name...........: _TCP_Client_Stop
; Description ...: Stops the client.
; Syntax.........: _TCP_Client_Stop($hSocket)
; Parameters ....: 	$hSocket	- Client socket.
; Return values .: Success	- True
;				   Failure	- False
; Author ........: Kip
; Modified.......:
; Remarks .......: The client socket is the return value of _TCP_Client_Create().
; Related .......:
; Link ..........;
; Example .......;
;
; ;==========================================================================================

Func _TCP_Client_Stop($hSocket)
	Local $iElement, $i

	$iElement = 0

	For $i = 1 to UBound($__TCP_SOCKETS)-1

		If $__TCP_SOCKETS[$i][0] = $hSocket Then
			$iElement = $i
			ExitLoop
		EndIf

	Next

	If $iElement Then

		___ASockShutdown($__TCP_SOCKETS[$iElement][0])
		TCPCloseSocket($__TCP_SOCKETS[$iElement][0])

		___ArrayDelete($__TCP_SOCKETS, $iElement)

		Return True

	EndIf

	Return False

EndFunc







; #FUNCTION# ;===============================================================================
;
; Name...........: _TCP_Server_Stop
; Description ...: Stops the server, and closes all client connections.
; Syntax.........: _TCP_Server_Stop()
; Parameters ....:
; Return values .: True
; Author ........: Kip
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ;==========================================================================================

Func _TCP_Server_Stop()

	Local $i

	___ASockShutdown($__TCP_SOCKETS[0][0])
	TCPCloseSocket($__TCP_SOCKETS[0][0])

	$__TCP_SOCKETS[0][0] = ""
	$__TCP_SOCKETS[0][1] = ""
	$__TCP_SOCKETS[0][2] = ""
	$__TCP_SOCKETS[0][3] = ""
	$__TCP_SOCKETS[0][4] = ""
	$__TCP_SOCKETS[0][5] = ""
	$__TCP_SOCKETS[0][6] = ""

	For $i = UBound($__TCP_SOCKETS)-1 to 1 Step -1
		___ArrayDelete($__TCP_SOCKETS, $i)
	Next

	Return True

EndFunc






Func ___TCP_Server_OnSocketEvent( $hWnd, $iMsgID, $WParam, $LParam )

	Local $hSocket = $WParam
	Local $iError = ___HiWord( $LParam )
	Local $iEvent = ___LoWord( $LParam )

	Local $sDataBuff, $iElement, $i

	Abs($hWnd)

	$hSocket = 0
	$iElement = 0

	For $i = 1 to UBound($__TCP_SOCKETS)-1

		If $__TCP_SOCKETS[$i][1] = $iMsgID Then
			$hSocket = $__TCP_SOCKETS[$i][0]
			$iElement = $i
			ExitLoop
		EndIf

	Next

    If $hSocket Then

		Switch $iEvent
			Case $FD_READ

				$sDataBuff = TCPRecv($hSocket, 1024)

				Call($__TCP_SOCKETS[0][2], $hSocket, $sDataBuff, $iError)

			Case $FD_WRITE

				Call($__TCP_SOCKETS[0][3], $hSocket, $iError)

			Case $FD_CLOSE

				___ASockShutdown($hSocket)
				TCPCloseSocket($hSocket)

				Call($__TCP_SOCKETS[0][5], $hSocket, $iError)

				___ArrayDelete($__TCP_SOCKETS, $iElement)

		EndSwitch

	EndIf


EndFunc






; #FUNCTION# ;===============================================================================
;
; Name...........: _TCP_Server_DisconnectClient
; Description ...: Disconnects a client of the server.
; Syntax.........: _TCP_Server_DisconnectClient($hSocket)
; Parameters ....: 	$hSocket	- Client socket.
; Return values .: Success	- True
;				   Failure	- False
; Author ........: Kip
; Modified.......:
; Remarks .......: The client socket is the $hSocket parameter of a _TCP_RegisterEvent callback function.
; Related .......:
; Link ..........;
; Example .......;
;
; ;==========================================================================================

Func _TCP_Server_DisconnectClient($hSocket)

	Local $iElement, $i

	$iElement = 0

	For $i = 1 to UBound($__TCP_SOCKETS)-1

		If $__TCP_SOCKETS[$i][0] = $hSocket Then
			$iElement = $i
			ExitLoop
		EndIf

	Next

    If $iElement Then

		___ASockShutdown($hSocket)
		TCPCloseSocket($hSocket)

		___ArrayDelete($__TCP_SOCKETS, $iElement)

		Return True

	EndIf

	Return False

EndFunc






; #FUNCTION# ;===============================================================================
;
; Name...........: _TCP_Server_ClientList
; Description ...: Returns the sockets of all connected clients.
; Syntax.........: _TCP_Server_ClientList()
; Parameters ....:
; Return values .: An 1 dimensional array of all connected clients.
; Author ........: Kip
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ;==========================================================================================

Func _TCP_Server_ClientList()

	Local $aReturn[1], $i

	For $i = 1 to UBound($__TCP_SOCKETS)-1
		If $__TCP_SOCKETS[$i][0] Then
			ReDim $aReturn[UBound($aReturn)+1]
			$aReturn[UBound($aReturn)-1] = $__TCP_SOCKETS[$i][0]
		EndIf
	Next

	$aReturn[0] = UBound($aReturn)-1

	Return $aReturn

EndFunc



; #FUNCTION# ;===============================================================================
;
; Name...........: _TCP_Server_Broadcast
; Description ...: Sends data to all connected clients.
; Syntax.........: _TCP_Server_Broadcast($sData)
; Parameters ....: 	$sData	- The data to send.
; Return values .: True
; Author ........: Kip
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ;==========================================================================================

Func _TCP_Server_Broadcast($sData)

	Local $i

	For $i = 1 to UBound($__TCP_SOCKETS)-1

		If $__TCP_SOCKETS[$i][0] Then TCPSend($__TCP_SOCKETS[$i][0], $sData)

	Next

	Return True

EndFunc





; #FUNCTION# ;===============================================================================
;
; Name...........: _TCP_Client_Create
; Description ...: Creates a new client.
; Syntax.........: _TCP_Client_Create($sIP , $iPort)
; Parameters ....: 	$sIP	- The IP address to connect to.
;					$iPort	- Port on which the created socket will be connected.
; Return values .: Client socket handle.
; Author ........: Kip
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ;==========================================================================================

Func _TCP_Client_Create($sIP , $iPort)

	ReDim $__TCP_SOCKETS[UBound($__TCP_SOCKETS)+1][7]

	local $hSocket = ___ASocket()

	$__TCP_SOCKETS[UBound($__TCP_SOCKETS)-1][0] = $hSocket
	$__TCP_SOCKETS[UBound($__TCP_SOCKETS)-1][1] = 0x0400 + (UBound($__TCP_SOCKETS)-1)

	___ASockSelect( $hSocket, $__TCP_WINDOW, 0x0400 + (UBound($__TCP_SOCKETS)-1), BitOR( $FD_READ, $FD_WRITE, $FD_CONNECT, $FD_CLOSE ) )
	GUIRegisterMsg( 0x0400 + (UBound($__TCP_SOCKETS)-1), "___TCP_Client_OnSocketEvent" )
	___ASockConnect( $hSocket, $sIP, $iPort )

	Return $hSocket

EndFunc





; #FUNCTION# ;===============================================================================
;
; Name...........: _TCP_RegisterEvent
; Description ...: Registers an event.
; Syntax.........: _TCP_RegisterEvent($hSocket, $iEvent, $sFunction)
; Parameters ....: 	$hSocket	- Socket of the server or a client.
;					$iEvent		- Event number. It can be any these values:
;									* $TCP_SEND
;									* $TCP_RECEIVE
;									* $TCP_CONNECT			=> Client only
;									* $TCP_DISCONNECT
;									* $TCP_NEWCLIENT		=> Server only
; Return values .: Success	- True
;				   Failure	- False
; Author ........: Kip
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ;==========================================================================================

Func _TCP_RegisterEvent($hSocket, $iEvent, $sFunction)

	Local $iSelected = 0
	Local $i

	If $__TCP_SOCKETS[0][0] Then

		$iSelected = 0

	Else

		For $i = 0 to UBound($__TCP_SOCKETS)-1
			If $__TCP_SOCKETS[$i][0] = $hSocket Then
				$iSelected = $i
				ExitLoop
			EndIf
		Next

		If Not $iSelected Then Return 0

	EndIf

	Switch $iEvent
		Case $TCP_SEND
			$__TCP_SOCKETS[$iSelected][3] = $sFunction
		Case $TCP_RECEIVE
			$__TCP_SOCKETS[$iSelected][2] = $sFunction
		Case $TCP_CONNECT
			$__TCP_SOCKETS[$iSelected][4] = $sFunction
		Case $TCP_DISCONNECT
			$__TCP_SOCKETS[$iSelected][5] = $sFunction
		Case $TCP_NEWCLIENT
			$__TCP_SOCKETS[$iSelected][6] = $sFunction
		Case Else
			Return False
	EndSwitch

	Return True


EndFunc




; #FUNCTION# ;===============================================================================
;
; Name...........: _TCP_Server_ClientIP
; Description ...: Converts a client socket handle to IP address.
; Syntax.........: _TCP_Server_ClientIP($hSocket)
; Parameters ....: 	$hSocket	- Client socket handle.
; Return values .: A string with the IP address.
; Author ........: Unknown
; Modified.......: Kip
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ;==========================================================================================

Func _TCP_Server_ClientIP($hSocket)

	Local $pSocketAddress, $aReturn

	$pSocketAddress = DllStructCreate("short;ushort;uint;char[8]")
    $aReturn = DllCall("Ws2_32.dll", "int", "getpeername", "int", $hSocket, "ptr", DllStructGetPtr($pSocketAddress), "int*", DllStructGetSize($pSocketAddress))
	If @error Or $aReturn[0] <> 0 Then Return 0

	$aReturn = DllCall("Ws2_32.dll", "str", "inet_ntoa", "int", DllStructGetData($pSocketAddress, 3))
	If @error Then Return 0

    $pSocketAddress = 0

    Return $aReturn[0]

EndFunc





; #FUNCTION# ;===============================================================================
;
; Name...........: _TCP_Send
; Description ...: Sends data to a server or client.
; Syntax.........: _TCP_Send($hSocket, $sText)
; Parameters ....: 	$hSocket	- Client or server socket handle.
;					$sText		- Data to send.
; Return values .:
; Author ........: Kip
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ;==========================================================================================

Func _TCP_Send($hSocket, $sText)

	Return TCPSend($hSocket, $sText)

EndFunc



Func ___TCP_Client_OnSocketEvent( $hWnd, $iMsgID, $WParam, $LParam )

    Local $iError = ___HiWord( $LParam )
    Local $iEvent = ___LoWord( $LParam )

	Local $hSocket, $iElement, $i, $sDataBuff

	Abs($hWnd)
	Abs($WParam)

	$hSocket = 0
	$iElement = 0

	For $i = 1 to UBound($__TCP_SOCKETS)-1

		If $__TCP_SOCKETS[$i][1] = $iMsgID Then
			$hSocket = $__TCP_SOCKETS[$i][0]
			$iElement = $i
			ExitLoop
		EndIf

	Next

    If $hSocket Then

        Switch $iEvent
            Case $FD_READ; Data has arrived!

				$sDataBuff = TCPRecv( $hSocket, 1024)

				Call($__TCP_SOCKETS[$i][2], $hSocket, $sDataBuff, $iError)

				$sDataBuff = ""

            Case $FD_WRITE

				Call($__TCP_SOCKETS[$i][3], $hSocket, $iError)

            Case $FD_CONNECT

				Call($__TCP_SOCKETS[$i][4], $hSocket, $iError)

            Case $FD_CLOSE

				___ASockShutdown( $hSocket )
                TCPCloseSocket( $hSocket )

				Call($__TCP_SOCKETS[$i][5], $hSocket, $iError)

				___ArrayDelete($__TCP_SOCKETS, $iElement)

		EndSwitch

	EndIf

EndFunc



;==================================================================================================================
;
; Zatorg's Asynchronous Sockets UDF Starts from here.
;
;==================================================================================================================


Func ___ASocket($iAddressFamily = 2, $iType = 1, $iProtocol = 6)
	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )
	Local $hSocket = DllCall($hWs2_32, "uint", "socket", "int", $iAddressFamily, "int", $iType, "int", $iProtocol)
	If @error Then
		SetError(1, @error)
		Return -1
	EndIf
	If $hSocket[ 0 ] = -1 Then
		SetError(2, ___WSAGetLastError())
		Return -1
	EndIf
	Return $hSocket[ 0 ]
EndFunc   ;==>_ASocket

Func ___ASockShutdown($hSocket)
	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )
	Local $iRet = DllCall($hWs2_32, "int", "shutdown", "uint", $hSocket, "int", 2)
	If @error Then
		SetError(1, @error)
		Return False
	EndIf
	If $iRet[ 0 ] <> 0 Then
		SetError(2, ___WSAGetLastError())
		Return False
	EndIf
	Return True
EndFunc   ;==>_ASockShutdown

Func ___ASockClose($hSocket)
	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )
	Local $iRet = DllCall($hWs2_32, "int", "closesocket", "uint", $hSocket)
	If @error Then
		SetError(1, @error)
		Return False
	EndIf
	If $iRet[ 0 ] <> 0 Then
		SetError(2, ___WSAGetLastError())
		Return False
	EndIf
	Return True
EndFunc   ;==>_ASockClose

Func ___ASockSelect($hSocket, $hWnd, $uiMsg, $iEvent)
	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )
	Local $iRet = DllCall( _
			$hWs2_32, _
			"int", "WSAAsyncSelect", _
			"uint", $hSocket, _
			"hwnd", $hWnd, _
			"uint", $uiMsg, _
			"int", $iEvent _
			)
	If @error Then
		SetError(1, @error)
		Return False
	EndIf
	If $iRet[ 0 ] <> 0 Then
		SetError(2, ___WSAGetLastError())
		Return False
	EndIf
	Return True
EndFunc   ;==>_ASockSelect

; Note: you can see that $iMaxPending is set to 5 by default.
; IT DOES NOT MEAN THAT DEFAULT = 5 PENDING CONNECTIONS
; 5 == SOMAXCONN, so don't worry be happy
Func ___ASockListen($hSocket, $sIP, $uiPort, $iMaxPending = 5); 5 == SOMAXCONN => No need to change it.
	Local $iRet
	Local $stAddress

	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )

	$stAddress = ___SockAddr($sIP, $uiPort)
	If @error Then
		SetError(@error, @extended)
		Return False
	EndIf

	$iRet = DllCall($hWs2_32, "int", "bind", "uint", $hSocket, "ptr", DllStructGetPtr($stAddress), "int", DllStructGetSize($stAddress))
	If @error Then
		SetError(3, @error)
		Return False
	EndIf
	If $iRet[ 0 ] <> 0 Then
		$stAddress = 0; Deallocate
		SetError(4, ___WSAGetLastError())
		Return False
	EndIf

	$iRet = DllCall($hWs2_32, "int", "listen", "uint", $hSocket, "int", $iMaxPending)
	If @error Then
		SetError(5, @error)
		Return False
	EndIf
	If $iRet[ 0 ] <> 0 Then
		$stAddress = 0; Deallocate
		SetError(6, ___WSAGetLastError())
		Return False
	EndIf

	Return True
EndFunc   ;==>_ASockListen

Func ___ASockConnect($hSocket, $sIP, $uiPort)
	Local $iRet
	Local $stAddress

	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )

	$stAddress = ___SockAddr($sIP, $uiPort)
	If @error Then
		SetError(@error, @extended)
		Return False
	EndIf

	$iRet = DllCall($hWs2_32, "int", "connect", "uint", $hSocket, "ptr", DllStructGetPtr($stAddress), "int", DllStructGetSize($stAddress))
	If @error Then
		SetError(3, @error)
		Return False
	EndIf

	$iRet = ___WSAGetLastError()
	If $iRet = 10035 Then; WSAEWOULDBLOCK
		Return True; Asynchronous connect attempt has been started.
	EndIf
	SetExtended(1); Connected immediately
	Return True
EndFunc   ;==>_ASockConnect

; A wrapper function to ease all the pain in creating and filling the sockaddr struct
Func ___SockAddr($sIP, $iPort, $iAddressFamily = 2)
	Local $iRet
	Local $stAddress

	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )

	$stAddress = DllStructCreate("short; ushort; uint; char[8]")
	If @error Then
		SetError(1, @error)
		Return False
	EndIf

	DllStructSetData($stAddress, 1, $iAddressFamily)
	$iRet = DllCall($hWs2_32, "ushort", "htons", "ushort", $iPort)
	DllStructSetData($stAddress, 2, $iRet[ 0 ])
	$iRet = DllCall($hWs2_32, "uint", "inet_addr", "str", $sIP)
	If $iRet[ 0 ] = 0xffffffff Then; INADDR_NONE
		$stAddress = 0; Deallocate
		SetError(2, ___WSAGetLastError())
		Return False
	EndIf
	DllStructSetData($stAddress, 3, $iRet[ 0 ])

	Return $stAddress
EndFunc   ;==>__SockAddr

Func ___WSAGetLastError()
	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )
	Local $iRet = DllCall($hWs2_32, "int", "WSAGetLastError")
	If @error Then
		;ConsoleWrite("+> _WSAGetLastError(): WSAGetLastError() failed. Script line number: " & @ScriptLineNumber & @CRLF)
		SetExtended(1)
		Return 0
	EndIf
	Return $iRet[ 0 ]
EndFunc   ;==>_WSAGetLastError


; Got these here:
; http://www.autoitscript.com/forum/index.php?showtopic=5620&hl=MAKELONG
Func ___MakeLong($LoWord, $HiWord)
	Return BitOR($HiWord * 0x10000, BitAND($LoWord, 0xFFFF)); Thanks Larry
EndFunc   ;==>_MakeLong

Func ___HiWord($Long)
	Return BitShift($Long, 16); Thanks Valik
EndFunc   ;==>_HiWord

Func ___LoWord($Long)
	Return BitAND($Long, 0xFFFF); Thanks Valik
EndFunc   ;==>_LoWord


; ========================================= Array functions

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayDelete
; Description ...: Deletes the specified element from the given array.
; Syntax.........: _ArrayDelete(ByRef $avArray, $iElement)
; Parameters ....: $avArray  - Array to modify
;                  $iElement - Element to delete
; Return values .: Success - New size of the array
;                  Failure - 0, sets @error to:
;                  |1 - $avArray is not an array
;                  |3 - $avArray has too many dimensions (only up to 2D supported)
;                  |(2 - Deprecated error code)
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - array passed ByRef, Ultima - 2D arrays supported, reworked function (no longer needs temporary array; faster when deleting from end)
; Remarks .......: If the array has one element left (or one row for 2D arrays), it will be set to "" after _ArrayDelete() is used on it.
; Related .......: _ArrayAdd, _ArrayInsert, _ArrayPop, _ArrayPush
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func ___ArrayDelete(ByRef $avArray, $iElement)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $iUBound = UBound($avArray, 1) - 1

	If Not $iUBound Then
		$avArray = ""
		Return 0
	EndIf

	; Bounds checking
	If $iElement < 0 Then $iElement = 0
	If $iElement > $iUBound Then $iElement = $iUBound

	; Move items after $iElement up by 1
	Switch UBound($avArray, 0)
		Case 1
			For $i = $iElement To $iUBound - 1
				$avArray[$i] = $avArray[$i + 1]
			Next
			ReDim $avArray[$iUBound]
		Case 2
			Local $iSubMax = UBound($avArray, 2) - 1
			For $i = $iElement To $iUBound - 1
				For $j = 0 To $iSubMax
					$avArray[$i][$j] = $avArray[$i + 1][$j]
				Next
			Next
			ReDim $avArray[$iUBound][$iSubMax + 1]
		Case Else
			Return SetError(3, 0, 0)
	EndSwitch

	Return $iUBound
EndFunc   ;==>_ArrayDelete
