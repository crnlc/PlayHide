#include-once
#cs ----------------------------------------------------------------------------
	Author:         BB_19
	Material Themes for MetroGUI UDF
	If you want to create your own themes, check out flatcolors.net, you can find there many random material/flat colors :)
#ce ----------------------------------------------------------------------------

;#Set Default Theme
Global $GUIThemeColor = "0x13161C" ; GUI Background Color
Global $FontThemeColor = "0xFFFFFF" ; Font Color
Global $GUIBorderColor = "0x2D2D2D" ; GUI Border Color
Global $ButtonBKColor = "0x00796b" ; Metro Button BacKground Color
Global $ButtonTextColor = "0xFFFFFF" ; Metro Button Text Color
Global $CB_Radio_Color = "0xFFFFFF" ;Checkbox and Radio Color (Box/Circle)
Global $GUI_Theme_Name = "DarkTealV2" ;Theme Name (For internal usage)
Global $CB_Radio_Hover_Color = "0xD8D8D8" ; Checkbox and Radio Hover Color (Box/Circle)
Global $CB_Radio_CheckMark_Color = "0x1a1a1a" ; Checkbox and Radio checkmark color

Func _SetTheme($ThemeSelect = "DarkTeal")
	$GUI_Theme_Name = $ThemeSelect
	Switch ($ThemeSelect)
		Case "LightTeal"
			$GUIThemeColor = "0xcccccc"
			$FontThemeColor = "0x000000"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0x00796b"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xE8E8E8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkTeal"
			$GUIThemeColor = "0x191919"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0x00796b"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
	    Case "Dark3DNS"
			$GUIThemeColor = "0x191919"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0x1E88E5"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
	    Case "DarkPlayHide"
			$GUIThemeColor = "0x191919"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0xFF7500"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkTealV2"
			$GUIThemeColor = "0x13161C"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0x35635B"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkRuby"
			$GUIThemeColor = "0x191919"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0x712043"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkMidnightTeal"
			$GUIThemeColor = "0x0A0D16"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x242B47"
			$ButtonBKColor = "0x336058"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkMidnightCyan"
			$GUIThemeColor = "0x0A0D16"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x242B47"
			$ButtonBKColor = "0x0D5C63"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkMidnightBlue"
			$GUIThemeColor = "0x0A0D16"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x242B47"
			$ButtonBKColor = "0x1A4F70"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkMidnight"
			$GUIThemeColor = "0x0A0D16"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x242B47"
			$ButtonBKColor = "0x3C4D66"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkBlue"
			$GUIThemeColor = "0x191919"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x303030"
			$ButtonBKColor = "0x1E648C"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkBlueV2"
			$GUIThemeColor = "0x040D11"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x303030"
			$ButtonBKColor = "0x1E648C"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "LightBlue"
			$GUIThemeColor = "0xcccccc"
			$FontThemeColor = "0x000000"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0x244E80"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xE8E8E8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "LightCyan"
			$GUIThemeColor = "0xD7D7D7"
			$FontThemeColor = "0x000000"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0x00838f"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xE8E8E8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkCyan"
			$GUIThemeColor = "0x191919"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0x00838f"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "LightGray"
			$GUIThemeColor = "0xcccccc"
			$FontThemeColor = "0x000000"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0x3F5863"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xE8E8E8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "LightGreen"
			$GUIThemeColor = "0xD7D7D7"
			$FontThemeColor = "0x000000"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0x2E7D32"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xE8E8E8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkGreen"
			$GUIThemeColor = "0x191919"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0x5E8763"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkGreenV2"
			$GUIThemeColor = "0x061319"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x242B47"
			$ButtonBKColor = "0x5E8763"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "LightRed"
			$GUIThemeColor = "0xD7D7D7"
			$FontThemeColor = "0x000000"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0xc62828"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xE8E8E8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkGray"
			$GUIThemeColor = "0x1B2428"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x4F6772"
			$ButtonBKColor = "0x607D8B"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkAmber"
			$GUIThemeColor = "0x191919"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0xffa000"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "LightOrange"
			$GUIThemeColor = "0xD7D7D7"
			$FontThemeColor = "0x000000"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0xBC5E05"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xE8E8E8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkOrange"
			$GUIThemeColor = "0x191919"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0xC76810"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "LightPurple"
			$GUIThemeColor = "0xD7D7D7"
			$FontThemeColor = "0x000000"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0x512DA8"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xE8E8E8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "DarkPurple"
			$GUIThemeColor = "0x191919"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0x512DA8"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case "LightPink"
			$GUIThemeColor = "0xD7D7D7"
			$FontThemeColor = "0x000000"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0xE91E63"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xE8E8E8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
		Case Else
			ConsoleWrite("Metro-UDF-Error: Theme not found, using default theme." & @CRLF)
			$GUIThemeColor = "0x191919"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0x00796b"
			$ButtonTextColor = "0xFFFFFF"
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1a1a1a"
			$GUI_Theme_Name = "DarkTealV2"
	EndSwitch
EndFunc   ;==>_SetTheme
