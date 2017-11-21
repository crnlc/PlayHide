DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1) ; This disables 32bit applications from being redirected to syswow64 instead of system32 by default ;
#include "MetroGUI-UDF\MetroGUI_UDF.au3"
#include "MetroGUI-UDF\_GUIDisable.au3"
#RequireAdmin

If FileExists("PlayHide.7z") then
   			RunWait(@ComSpec & " /c " & "taskkill /im PlayHide.exe" , "", @SW_HIDE)
   			RunWait(@ComSpec & " /c " & "bin32\7z.exe x .\PlayHide.7z -y" , "", @SW_HIDE)
   			RunWait(@ComSpec & " /c " & "del .\PlayHide-Installer.exe" , "", @SW_HIDE)
   			RunWait(@ComSpec & " /c " & "del .\PlayHide.7z" , "", @SW_HIDE)
			_Metro_MsgBox(0,"Info","Update is done!")
			RunWait(@ComSpec & " /c " & "start .\PlayHide.exe" , "", @SW_SHOW)
Exit
Else
       _Metro_MsgBox(0,"Info","No Update file")
	   EndIf
