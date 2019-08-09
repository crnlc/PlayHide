If $CheckUpdateSetting >0 then
	$tmp = ".\tmp"
	$urlVersion = "http://files.playhide.eu/version.ini"
	$newVersion = "0.0"
	If Not FileExists($tmp) Then 
		DirCreate($tmp)
	EndIf
	$Ini = InetGet($urlVersion,$tmp & "\version.ini", $INET_FORCERELOAD)
	If $Ini = 0 Then 
	Else
		$newVersion = IniRead ($tmp & "\version.ini","Version","Version","")
		If $NewVersion = $ReadVersion Then
		Else
		Run(".\update.exe")
		exit
	EndIf
EndIf
FileDelete($tmp & "\version.ini")
EndIf	