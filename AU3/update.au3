DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1) ; This disables 32bit applications from being redirected to syswow64 instead of system32 by default ;
#include "MetroGUI-UDF\MetroGUI_UDF.au3"
#include "MetroGUI-UDF\_GUIDisable.au3"
_SetTheme("DarkPlayHide")

If FileExists("PlayHide.7z") then
			ProcessClose("PlayHide.exe")
			sleep(50)
   			RunWait(@ComSpec & " /c " & "bin32\7z.exe x .\PlayHide.7z -y" , "", @SW_HIDE)
			sleep(50)
   			FileDelete("PlayHide-Installer.exe")
   			FileDelete("PlayHide.7z")
			_Metro_MsgBox(0,"Info","Update is done!")
			Run("PlayHide.exe")
Exit
Else
       _Metro_MsgBox(0,"Info","No Update file")
	   EndIf
