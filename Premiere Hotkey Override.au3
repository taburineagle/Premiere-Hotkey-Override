#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Comment=Premiere Hotkey Override allows for more flexibility when scrubbing through the timeline in Adobe Premiere versions before CC.
#AutoIt3Wrapper_Res_Description=Premiere Hotkey Override allows for more flexibility when scrubbing through the timeline in Adobe Premiere versions before CC.
#AutoIt3Wrapper_Res_Fileversion=1.0.111217
#AutoIt3Wrapper_Res_LegalCopyright=2015-2017 Zach Glenwright
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Global $hotKeysActive = false ; whether or not the hotkeys are active (Premiere is main)
Global $turboMode = false ; whether or not you're in turbo mode (advancing 4 seconds in each hit)
Global $HotkeyList[3] = ["+{LEFT}", "+{RIGHT}", "!T"] ; the list of hotkeys to override

Opt("SendKeyDelay", 2) ; put the key delay to 2 so it doesn't send the command too quickly

TraySetIcon("C:\Program Files\Adobe\Adobe Premiere Pro CS6\Adobe Premiere Pro.exe") ; sets the little icon in the tray to the Premiere icon

Func loadHotKeys($loadOrCancel) ; load or cancel the hotkeys
	For $i = 0 To (UBound($HotkeyList) - 1)
		If $loadOrCancel = 1 Then
			HotKeySet($HotkeyList[$i], "hotKeyPressed") ; load each hotkey into it's event handler
			$hotKeysActive = true
		Else
			HotKeySet($HotkeyList[$i]) ; clear each hotkey from it's event handler (so it doesn't funk up typing)
			$hotKeysActive = false
		EndIf
	Next
EndFunc

Func hotKeyPressed() ; when you press a hotkey
	Switch @HotKeyPressed
		Case "+{LEFT}"
				If $turboMode = false Then
					Send("{NUMPADSUB}{NUMPAD1}{NUMPADDOT}{NUMPADENTER}")
				Else
					Send("{NUMPADSUB}{NUMPAD4}{NUMPADDOT}{NUMPADENTER}")
				EndIf
			Case "+{RIGHT}"
				If $turboMode = false Then
					Send("{NUMPADADD}{NUMPAD1}{NUMPADDOT}{NUMPADENTER}")
				Else
					Send("{NUMPADADD}{NUMPAD4}{NUMPADDOT}{NUMPADENTER}")
				EndIf
		Case "!T" ; when you hit SHIFT-ALT-T, it turns Turbo Mode (4 seconds instead of 1) ON and OFF
			If $turboMode = false Then
				$turboMode = True
				displayMessage("TURBO: ON")
			Else
				$turboMode = False
				displayMessage("TURBO: OFF")
			EndIf
	EndSwitch
EndFunc

Func displayMessage($theMessage)
	SplashTextOn("","Premiere Hotkey Override | " & $theMessage, 515, 17, 1312, 0, 37, "Segoe UI", 10, 600)
	Sleep(1000)
EndFunc

While ProcessExists("Adobe Premiere Pro.exe")
	If WinActive("[CLASS:Premiere Pro]") or WinActive("[CLASS:DroverLord - Window Class]") Then
		If $hotkeysActive = false Then
			loadHotKeys(1)
			If $turboMode = true Then
				displayMessage("Hotkeys and Turbo mode are now active!")
			Else
				displayMessage("Hotkeys are now enabled!")
			EndIf
		EndIf
	Else
		If $hotKeysActive = true Then
			loadHotKeys(0) ; if the hotkeys are active, disable them (to fix typing issues)
			displayMessage("Hotkeys are now disabled!")
		EndIf
	EndIf

	Sleep(500)
WEnd