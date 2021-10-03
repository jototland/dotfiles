#SingleInstance
SetWorkingDir %A_ScriptDir%
return

#Include hotstrings.ahk
#Include capslock.ahk
#Include rdplogin.ahk

; Global hotkeys
#IfWinActive
#m::Run, mstsc.exe
#+R::Run, wt.exe

; hotkeys for windows desktop
#IfWinActive ahk_class WorkerW
r::reload
#IfWinActive ahk_class Progman
r::reload
#IfWinActive

debugmsg(text) {
    TrayTip, Debug, %text%, 1
}
