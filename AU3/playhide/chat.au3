If $ChatSetting >0 then
    Local $iOpenChat = TrayCreateItem("Chat")
    TrayItemSetState ($iOpenChat, $TRAY_ENABLE)
Else
   Local $iOpenChat = ""
   TrayItemSetState ($iOpenChat, $TRAY_DISABLE)
EndIf