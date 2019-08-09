        Local $iStatus = TrayCreateItem($String_not_connected)
        TrayItemSetState ($iStatus, $TRAY_DISABLE)
        TrayCreateItem("") ; Create a separator line.
        Local $iOpen = TrayCreateItem($String_open)
    If $AuthSetting >0 then
    Local $iLogin = TrayCreateItem($String_login)
        Else
        Local $iLogin = ""
    EndIf
    If $ChatSetting >0 then
        Local $iOpenChat = TrayCreateItem("Chat")
        TrayItemSetState ($iOpenChat, $TRAY_ENABLE)
    Else
        Local $iOpenChat = ""
        TrayItemSetState ($iOpenChat, $TRAY_DISABLE)
    EndIf
        TrayCreateItem("") ; Create a separator line.
        Local $iAutoConnect = TrayCreateItem($String_autoconnect, -1, -1, $TRAY_ITEM_NORMAL)
        TrayItemSetState ($iAutoConnect, $TRAY_UNCHECKED)
        Local $iAutostart = TrayCreateItem($String_autostart)
        Local $iDesktopIcon = TrayCreateItem($String_shortcut)
    if FileExists(@DesktopDir & "\" & $AppName & ".lnk") Then
        TrayItemSetState ($iDesktopIcon, $TRAY_DISABLE)
    Else
        TrayItemSetState ($iDesktopIcon, $TRAY_ENABLE)
    EndIf
        TrayCreateItem("") ; Create a separator line.
        Local $iWebsite = TrayCreateItem("Vers: " & $ReadVersion & " / " & $String_website, -1, -1, $TRAY_ITEM_NORMAL)
        Local $idExit = TrayCreateItem($String_close)