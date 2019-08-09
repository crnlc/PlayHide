If $AuthSetting >0 then
    $Username = _Metro_InputBox2($String_username, 15, "", False, False)
    $Passwort = _Metro_InputBox2($String_password, 15, "", true, False)
    $file = FileOpen($LoginFile, 2)
    FileFlush($file)
    FileWrite($file, $Username & @CRLF)
    FileWrite($file, $Passwort)
    FileClose($file)
    else
       Local $file = FileOpen($LoginFile, 2)
    FileFlush($file)
    FileWrite($file, _RandomText(10) & @CRLF)
    FileWrite($file, _RandomText(10))
    FileClose($file)
    Endif