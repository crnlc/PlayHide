
                $osv = @OSVersion
    If $osv = "WIN_7" Then
        RunWait(@ComSpec & " /c " & 'driver\Win7\tapinstall.exe remove tap0901' , "", @SW_HIDE)
	  ElseIf $osv = "WIN_8" Or $osv = "WIN_81" Then
        RunWait(@ComSpec & " /c " & 'driver\Win7\tapinstall.exe remove tap0901' , "", @SW_HIDE)
    Else
        RunWait(@ComSpec & " /c " & 'driver\Win10\tapinstall.exe remove tap0901' , "", @SW_HIDE)
	 EndIf
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall delete rule name="' & $AppName & '" dir=in protocol=' & $ServerProto & ' localport=' & $ServerPort , "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & 'net start server /y', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'regedit.exe /S .\tools\Enable-SMB.reg', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall delete rule dir=in protocol=TCP localport=445 name="Block_SMB-445-TCP"', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall delete rule dir=in protocol=TCP localport=137 name="Block_SMB-137-TCP"', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall delete rule dir=in protocol=TCP localport=138 name="Block_SMB-138-TCP"', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall delete rule dir=in protocol=TCP localport=139 name="Block_SMB-139-TCP"', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall delete rule dir=in protocol=UDP localport=445 name="Block_SMB-445-UDP"', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall delete rule dir=in protocol=UDP localport=137 name="Block_SMB-137-UDP"', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall delete rule dir=in protocol=UDP localport=138 name="Block_SMB-138-UDP"', "", @SW_HIDE)
        RunWait(@ComSpec & " /c " & 'netsh advfirewall firewall delete rule dir=in protocol=UDP localport=139 name="Block_SMB-139-UDP"', "", @SW_HIDE)
	    FileDelete(@DesktopDir & "\" & $AppName & ".lnk")

		 _Metro_MsgBox($MB_SYSTEMMODAL, $String_uninstall, $String_uninstall_msg)
    		Exit