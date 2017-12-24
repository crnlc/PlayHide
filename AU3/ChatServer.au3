#Include <ButtonConstants.Au3>
#Include <EditConstants.Au3>
#Include <GUIConstantsEx.Au3>
#Include <StaticConstants.Au3>
#Include <WindowsConstants.Au3>
#Include <File.Au3>
#Include <String.Au3>
#NoTrayIcon

Opt ('GUIOnEventMode', 1)

Global $Max = 10, $Socket[$Max + 1], $User[$Max + 1], $Server = -1, $Admin = -1, $Admin_Pw = 'password', $Connected = 0
For $A = 1 To $Max
    $Socket[$A] = -1
    $User[$A] = -1
Next

$GUI = GUICreate ('Server Settings', 180, 100, -1, -1, -1, 128)
GUISetOnEvent  ($GUI_EVENT_CLOSE, '_Exit')
GUICtrlCreateGroup  ('', 5, 0, 170, 94)
$IP = GUICtrlCreateInput (@IpAddress1, 12, 13, 100, 21, 1)
$Port = GUICtrlCreateInput (50, 117, 13, 50, 21, 1)
$Start = GUICtrlCreateButton ('Start', 12, 39, 46, 20, $WS_GROUP)
GUICtrlSetOnEvent ($Start, '_Start')
$Stop = GUICtrlCreateButton ('Stop', 63, 39, 49, 20, $WS_GROUP)
GUICtrlSetState ($Stop, $GUI_DISABLE)
GUICtrlSetOnEvent ($Stop, '_Stop')
$Pw = GUICtrlCreateInput ($Admin_Pw, 12, 65, 100, 21, BitOr (1, $ES_PASSWORD))
$Set = GUICtrlCreateButton ('Set Pw', 118, 66, 49, 20, $WS_GROUP)
GUICtrlSetOnEvent ($Set, '_Set')
GUISetState (@SW_SHOW)
WinSetOnTop ($GUI, '', 1)

While 1
    If $Server <> -1 Then
        If $Connected < $Max Then
            $Accept = TcpAccept ($Server)
            If $Accept <> -1 Then
                If _IsBanned (_SocketGetIP ($Accept)) = 0 Then
                    $Open = _Open ()
                    $Timer = TimerInit ()
                    Do
                        Sleep (15)
                        $Recv = TcpRecv ($Accept, 1000000)
                    Until $Recv <> '' Or TimerDiff ($Timer) >= 500
                    If $Recv <> '' Then
                        If _Check ($Recv) = 1 Then
                            $User[$Open] = $Recv
                            $Socket[$Open] = $Accept
                            $Connected = $Connected + 1
                            _SendAll ('[%Time] ' & $User[$Open] & ' has connected.')
                        Else
                            TcpSend ($Accept, 'Error:Username.Exists;')
                            Sleep (250)
                            TcpCloseSocket ($Accept)
                        EndIf
                    Else
                        TcpCloseSocket ($Accept)
                    EndIf
                Else
                    TcpSend ($Accept, 'Error:IP.Banned;')
                    Sleep (250)
                    TcpCloseSocket ($Accept)
                EndIf
            EndIf
        ElseIf $Connected = $Max Then
            $Accept = TcpAccept ($Server)
            If $Accept <> -1 Then
                $Timer = TimerInit ()
                Do
                    Sleep (15)
                    $Recv = TcpRecv ($Accept, 1000000)
                Until $Recv <> '' Or TimerDiff ($Timer) >= 500
                Sleep (250)
                TcpSend ($Accept, 'Error:Max.Connections;')
                TcpCloseSocket ($Accept)
            EndIf
        EndIf
        For $A = 1 To $Max
            If $Socket[$A] <> -1 And $User[$A] <> -1 Then
                $Recv = TcpRecv ($Socket[$A], 1000000)
                If @Error Then _Disconnect ($A)
                If $Recv <> '' Then
                    If StringLeft ($Recv, 6) = '.admin' Then
                        If $Admin <> -1 Then
                            TcpSend ($Socket[$A], '[%Time] Server : An admin is already logged in.')
                        Else
                            If StringTrimLeft ($Recv, 7) == $Admin_Pw Then
                                $Admin = $User[$A]
                                _SendAll ('[%Time] ' & $User[$A] & ' is now an admin.')
                            Else
                                TcpSend ($Socket[$A], '[%Time] Server : Incorrect admin password.')
                            EndIf
                        EndIf
                    ElseIf StringLeft ($Recv, 7) = '.logout' Then
                        If $User[$A] == $Admin Then
                            $Admin = -1
                            _SendAll ('[%Time] ' & $User[$A] & ' is no longer an admin.')
                        Else
                            TcpSend ($Socket[$A], '[%Time] Server : You do not have this power.')
                        EndIf
                    ElseIf StringLeft ($Recv, 5) = '.kick' Then
                        If $User[$A] == $Admin Then
                            $Who = StringTrimLeft ($Recv, 6)
                            If $Who = $Admin Then
                                TcpSend ($Socket[$A], '[%Time] Server : You cannot kick an admin.')
                            ElseIf _UserGetSocket ($Who) <> -1 Then
                                _Disconnect (_UserGetSocket ($Who))
                            Else
                                TcpSend ($Socket[$A], '[%Time] Server : User does not exist.')
                            EndIf
                        Else
                            TcpSend ($Socket[$A], '[%Time] Server : You do not have this power.')
                        EndIf
                    ElseIf StringLeft ($Recv, 6) = '.stats' Then
                        $Stats = @CRLF & 'Total Online : ' & $Connected & @CRLF
                        For $B = 1 To $Max
                            If $Socket[$B] <> -1 And $User[$B] <> -1 Then
                                $Stats = $Stats & '[' & $B& '] ' & $User[$B] & @CRLF
                            EndIf
                        Next
                        TcpSend ($Socket[$A], $Stats)
                    ElseIf StringLeft ($Recv, 3) = '.ip' Then
                        If $User[$A] == $Admin Then
                            $Who = StringTrimLeft ($Recv, 4)
                            $wID = _UserGetSocket ($Who)
                            If $wID <> -1 Then
                                TcpSend ($Socket[$A], '[%Time] Server : ' & $Who & "'s IP : " & _SocketGetIP ($Socket[$wID]))
                            Else
                                TcpSend ($Socket[$A], '[%Time] Server : User does not exist.')
                            EndIf
                        Else
                            TcpSend ($Socket[$A], '[%Time] Server : You do not have this power.')
                        EndIf
                    ElseIf StringLeft ($Recv, 4) = '.ban' Then
                        If $User[$A] == $Admin Then
                            $Who = StringTrimLeft ($Recv, 5)
                            $wID = _UserGetSocket ($Who)
                            If $Who = $Admin Then
                                TcpSend ($Socket[$A], '[%Time] Server : You cannot ban an admin.')
                            ElseIf $wID <> -1 Then
                                $IP = _SocketGetIP ($Socket[$wID])
                                FileWriteLine ('Banned.txt', $IP)
                                For $B = 1 To $Max
                                    If $Socket[$B] <> -1 And $User[$B] <> -1 Then
                                        If _SocketGetIP ($Socket[$B]) = $IP Then _Disconnect ($B)
                                    EndIf
                                Next
                                _SendAll ('[%Time] IP : ' & $IP & ' has been banned.')
                                Sleep (500)
                                TcpSend ($Socket[$A], '.log Ban Added : Username : ' & $Who & ', IP : ' & $IP)
                            Else
                                TcpSend ($Socket[$A], '[%Time] Server : User does not exist.')
                            EndIf
                        Else
                            TcpSend ($Socket[$A], '[%Time] Server : You do not have this power.')
                        EndIf
                    ElseIf StringLeft ($Recv, 6) = '.unban' Then
                        If $User[$A] == $Admin Then
                            $IP = StringTrimLeft ($Recv, 7)
                            If _IsBanned ($IP) = 1 Then
                                _Remove ($IP)
                                _SendAll ('[%Time] IP ' & $IP & ' is un-banned.')
                                Sleep (500)
                                TcpSend ($Socket[$A], '.log Ban Removed : ' & $IP)
                            Else
                                TcpSend ($Socket[$A], '[%Time] Server : ' & $IP & ' is not banned.')
                            EndIf
                        Else
                            TcpSend ($Socket[$A], '[%Time] Server : You do not have this power.')
                        EndIf
                    ElseIf StringLeft ($Recv, 3) = '.pm' Then
                        $Data = StringSplit (StringTrimLeft ($Recv, 4), ',')
                        If @Error <> 1 Then
                            $Who = $Data[1]
                            $wID = _UserGetSocket ($Who)
                            $Msg = $Data[2]
                            If $Who = $User[$A] Then
                                TcpSend ($Socket[$A], '[%Time] Server : You cannot message your self.')
                            Else
                                If $wID <> -1 Then
                                    TcpSend ($Socket[$A], '[%Time] [PM] ' & $User[$A] & ': ' & $Msg)
                                    TcpSend ($Socket[$wID], '[%Time] [PM] ' & $User[$A] & ': ' & $Msg)
                                Else
                                    TcpSend ($Socket[$A], '[%Time] Server : User does not exist.')
                                EndIf
                            EndIf
                        Else
                            TcpSend ($Socket[$A], '[%Time] Server : Syntax Error.')
                        EndIf
                    Else
                        _SendAll ('[%Time] ' & $User[$A] & ': ' & $Recv)
                    EndIf
                EndIf
            EndIf
        Next
    EndIf
    Sleep (15)
WEnd

Func _IsBanned ($Data)
    For $A = 1 To _FileCountLines ('Banned.txt')
        If FileReadLine ('Banned.txt', $A) = $Data Then Return 1
    Next
    Return 0
EndFunc

Func _Remove ($IP)
    $Count = _FileCountLines ('Banned.txt')
    If $Count = 1 And FileReadLine ('Banned.txt', 1) = $IP Then
        FileDelete ('Banned.txt')
    ElseIf $Count > 0 Then
        For $A = 1 To $Count
            $Line = FileReadLine ('Banned.txt', $A)
            If $Line <> $IP Then FileWriteLine ('Banned_Temp.txt', $Line)
        Next
    EndIf
    FileCopy ('Banned_Temp.txt','Banned.txt', 1)
    FileDelete ('Banned_Temp.txt')
EndFunc

Func _SocketGetIP ($Data)
    Local $Struct, $Return
    $Struct = DllStructCreate ('short;ushort;uint;char[8]')
    $Return = DllCall ('Ws2_32.dll','int','getpeername','int', $Data, 'ptr', DllStructGetPtr ($Struct), 'int*', DllStructGetSize($Struct))
    If @Error Or $Return[0] <> 0 Then Return 0
    $Return = DllCall ('Ws2_32.dll','str','inet_ntoa','int', DllStructGetData ($Struct, 3))
    If @Error Then Return 0
    $Struct = 0
    Return $Return[0]
EndFunc

Func _UserGetSocket ($Data)
    For $A = 1 To $Max
        If $User[$A] = $Data Then Return $A
    Next
    Return -1
EndFunc

Func _Check ($Data)
    For $A = 1 To $Max
        If $User[$A] = $Data Then Return 0
    Next
    Return 1
EndFunc

Func _Disconnect ($ID)
    _SendAll ('[%Time] ' & $User[$ID] & ' has disconnected.')
    If $User[$ID] = $Admin Then $Admin = -1
    TcpCloseSocket ($Socket[$ID])
    $Socket[$ID] = -1
    $User[$ID] = -1
    $Connected = $Connected - 1
EndFunc

Func _SendAll ($Msg)
    For $A = 1 To $Max
        If $Socket[$A] <> -1 And $User[$A] <> -1 Then
            TcpSend ($Socket[$A], $Msg)
        EndIf
    Next
EndFunc

Func _Open ()
    For $A = 1 To $Max
        If $Socket[$A] = -1 And $User[$A] = -1 Then Return $A
    Next
EndFunc

Func _Start ()
    If GUICtrlRead ($IP) == '' Or GUICtrlRead ($Port) == '' Then Return @Error
    TcpStartUp ()
    $Server = TcpListen (GUICtrlRead ($IP), GUICtrlRead ($Port))
    If $Server = -1 Or @Error Then
        WinSetOnTop ($GUI, '', 0)
        Sleep (100)
        MsgBox (16, 'Fatal Error','Unable to start the server, change your settings and try again.')
        WinSetOnTop ($GUI, '', 1)
        TcpCloseSocket ($Server)
        _Reset ()
    Else
        GUICtrlSetState ($IP, $GUI_DISABLE)
        GUICtrlSetState ($Port, $GUI_DISABLE)
        GUICtrlSetState ($Start, $GUI_DISABLE)
        GUICtrlSetState ($Stop, $GUI_ENABLE)
    EndIf
EndFunc

Func _Stop ()
    TcpCloseSocket ($Server)
    $Server = -1
    $Connected = 0
    $Admin = -1
    _Reset ()
EndFunc

Func _Set ()
    $Admin_Pw = GUICtrlRead ($Pw)
EndFunc

Func _Reset ()
    For $A = 1 To $Max
        If $Socket[$A] <> -1 Or $User[$A] <> -1 Then
            TcpCloseSocket ($Socket[$A])
            $Socket[$A] = -1
            $User[$A] = -1
        EndIf
    Next
    TcpShutDown ()
    GUICtrlSetState ($IP, $GUI_ENABLE)
    GUICtrlSetState ($Port, $GUI_ENABLE)
    GUICtrlSetState ($Start, $GUI_ENABLE)
    GUICtrlSetState ($Stop, $GUI_DISABLE)
EndFunc

Func _Exit ()
    Exit
EndFunc