        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule name="' & $AppName & '" dir=in action=allow protocol=' & $ServerProto & ' localport=' & $ServerPort , "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow' , "", @SW_HIDE)
        $Setup = _Metro_MsgBox(0, $String_setup_info, $String_setup_msg)
        $DevResult = Run(@ComSpec & ' /c netsh interface show interface name="' & $AppName & '"', "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
        ProcessWaitClose($DevResult)
        $ReadResultDev = StdoutRead($DevResult)
        $DevExist = StringInStr($ReadResultDev, $AppName)
    if checkTAP_Interface($AppName) = false then
        $osv = @OSVersion
    If $osv = "WIN_7" Then
        RunWait('driver\tap.exe')
    Else
        RunWait('driver\tap-win10.exe')
    EndIf
EndIf
        Run($ConnectSetup, "", @SW_HIDE)
        _Metro_MsgBox(0, $String_info, $String_setup_msg2)
        Sleep(15000)
    If ProcessExists("openvpn.exe") And Ping($ServerSubnet & "1") Then
        Sleep(100)
        RunWait(@ComSpec & " /c " & 'Powershell.exe -executionpolicy Bypass -File "driver\SetAdapter.ps1" -Subnet ' & $ServerSubnet & '* -Name ' & '"' & $AppName & '"', "", @SW_HIDE)
        RunWait('netsh interface ipv4 set interface "' &  $AppName & '" metric=1')
        ProcessClose("openvpn.exe")
        _Metro_MsgBox($MB_SYSTEMMODAL, $String_success, $String_setup_success_msg)
        $msg = _Metro_MsgBox (4,$String_info,$String_setup_msg3)
        IniWrite($SettingsFile, "Settings", "Setup", 1)
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