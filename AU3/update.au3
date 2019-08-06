#include <_webDownloader.au3>
#include <GUIConstants.au3>
#include <MsgBoxConstants.au3>
#include <InetConstants.au3>

$App = "PlayHide VPN"
$AppExe = "playhide.exe"
$url = "http://files.playhide.eu/PlayHide-VPN.7z"
$urlVersion = "http://files.playhide.eu/version.ini"

$file = "update.7z"
$name = $App & " - Update"
$tmp = ".\tmp"
$installcommand = "bin\7z.exe x " & $tmp & "\" & $file & " -o.\ -y"
$OpenVPN = "openvpn.exe"

$oldVersion = IniRead(".\version.ini","Version","Version","NotFound")
$newVersion = "0.0"
If Not FileExists($tmp) Then DirCreate($tmp)
$Ini = InetGet($urlVersion,$tmp & "\version.ini", $INET_FORCERELOAD)
If $Ini = 0 Then 
    MsgBox($MB_OK,"Updater","Error!", 10)
Else
    $newVersion = IniRead ($tmp & "\version.ini","Version","Version","")
    If $NewVersion = $oldVersion Then
    Run(".\PlayHide.exe")
    exit
    Else
                If ProcessExists($AppExe) Then
                    ProcessClose($AppExe)
                EndIf
                
                If ProcessExists($OpenVPN) Then
                    ProcessClose($OpenVPN)
                EndIf
                
                $test = _webDownloader($url, $file, $name, $tmp, False)
                If $test Then
                    ProgressSet(100, "Extract Update...", "Update / Install " & $name)
                    RunWait(@ComSpec & " /c " & $installcommand , "", @SW_HIDE)
                    ProgressSet(100, "Installation Done!")
                    Sleep(3000)
                    ProgressOff()
                    FileDelete($test)
                Else
                    ProgressOff()
                EndIf
EndIf
EndIf
FileDelete($tmp & "\version.ini")
Run(".\PlayHide.exe")
Exit
