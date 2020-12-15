    if checkTAP_Interface($AppName) = false then
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule name="' & $AppName & '" dir=in action=allow protocol=' & $ServerProto & ' localport=' & $ServerPort , "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow' , "", @SW_HIDE)
        #_Metro_MsgBox(0, $String_setup_info, $String_setup_msg)

        $osv = @OSVersion
    If $osv = "WIN_7" Then
        RunWait(@ComSpec & " /c " & 'driver\Win7\tapinstall.exe install driver\Win7\OemVista.inf tap0901' , "", @SW_HIDE)
    Else
        RunWait(@ComSpec & " /c " & 'driver\Win10\tapinstall.exe install driver\Win10\OemVista.inf tap0901' , "", @SW_HIDE)
    EndIf
 EndIf
	  $Params = "--mode server --tls-server --resolv-retry infinite --keepalive 10 60 --reneg-sec 432000 --persist-key --persist-tun --cipher AES-128-CBC --client-to-client --remote-cert-tls server --verb 0 --mute-replay-warnings --ca .\certs\server\ca.crt --cert .\certs\server\server.crt --key .\certs\server\server.key --dh .\certs\server\dh2048.pem"
	  $SelfTest = @ComSpec & " /c " & 'bin\openvpn.exe ' & $Params & ' --port 1400 --dev tap --proto udp --ifconfig 172.16.0.1 255.255.255.0'
        Run($SelfTest, "", @SW_HIDE)
        _Metro_MsgBox(0, $String_info, $String_setup_msg2)
        Sleep(15000)
    If ProcessExists("openvpn.exe") Then
        RunWait(@ComSpec & " /c " & 'Powershell.exe -executionpolicy Bypass -File "driver\SetAdapter.ps1" -ip 172.16.0.1 -name "' & $AppName & '"', "", @SW_HIDE)
        RunWait('netsh interface ipv4 set interface "' &  $AppName & '" metric=1')
        ProcessClose("openvpn.exe")
        _Metro_MsgBox($MB_SYSTEMMODAL, $String_success, $String_setup_success_msg)
        $msg = _Metro_MsgBox (4,$String_info,$String_setup_msg3)
    If $msg = "NO" Then
    ElseIf $msg = "YES" Then
        RunWait(@ComSpec & " /c " & 'net stop server /y', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'regedit.exe /S .\tools\Disable-SMB.reg', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=445 name="Block_SMB-445"', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=137 name="Block_SMB-137"', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=138 name="Block_SMB-138"', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=139 name="Block_SMB-139"', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=445 name="Block_SMB-445"', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=137 name="Block_SMB-137"', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=138 name="Block_SMB-138"', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=139 name="Block_SMB-139"', "", @SW_HIDE)
EndIf
    if Not FileExists(@DesktopDir & "\" & $AppName & ".lnk") Then
        FileCreateShortcut(@AutoItExe, @DesktopDir & "\" & $AppName & ".lnk", @ScriptDir)
    else
EndIf
        RestartScript()
        Exit
    else
        _Metro_MsgBox($MB_SYSTEMMODAL, $String_error, $String_setup_failed)
        ProcessClose("openvpn.exe")
        IniWrite($SettingsFile, "Settings", "Setup", 0)
        Exit
    EndIf
EndIf
        Sleep(1000)