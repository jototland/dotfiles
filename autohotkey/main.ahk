#SingleInstance
#NoEnv
#InstallKeybdHook
#Warn
SetWorkingDir %A_ScriptDir%
EnvGet USERPROFILE, USERPROFILE
return ; end of auto-execute section

#Include utils.ahk
#Include hotstrings.ahk
#Include capslock.ahk
#Include rdplogin.ahk
#Include hotkeys.ahk
#Include iso_extra_key.ahk
#Include number_and_arrow_mode.ahk

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
