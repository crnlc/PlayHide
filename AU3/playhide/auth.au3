If $AuthSetting >0 then
    $Username = _Metro_InputBox2($String_username, 15, "", False, False)
    $Passwort = _Metro_InputBox2($String_password, 15, "", true, False)
    Write_Login($LoginFile,$Username,$Passwort)
   else
    Write_Login($LoginFile,_RandomText(10),_RandomText(10))
 Endif