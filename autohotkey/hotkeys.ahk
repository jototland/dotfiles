+Backspace::
    SendInput, {Delete}
return

show_hide_launch(name, cmd, hide:=False) {
    local USERPROFILE
    if WinExist(name) {
        if WinActive(name) {
            if (hide) {
                WinHide, %name%
            } else {
                WinMinimize, %name%
            }
        } else {
            WinActivate, %name%
        }
    } else {
        WinShow, %name%
        if WinExist(name) {
            WinActivate, %name%
        } else {
            EnvGet, USERPROFILE, USERPROFILE
            cmd := StrReplace(cmd, "%USERPROFILE%", USERPROFILE)
            Run, %cmd%, USERPROFILE
        }
    }
}

SC121::
Launch_App2::
    show_hide_launch("ahk_class Rgui", """%USERPROFILE%\scoop\apps\r\current\bin\x64\Rgui.exe"" --quiet --no-save --no-restore", hide:=True)
return
+SC121::
+Launch_App2::
    show_hide_launch("ahk_class CASCADIA_HOSTING_WINDOW_CLASS", "wt.exe")
return


#IfWinActive ahk_exe OUTLOOK.EXE
^+v::
    ; Keywait, v
    SendInput {F10}e2
    Sleep, 100
    SendInput, vt
return
    ; SendInput, {Ctrl up}{Shift up}{Alt down}e{Alt up}
    ; Sleep, 200
    ; SendInput, 2vt                                ; paste as value
#IfWinActive ahk_exe EXCEL.EXE
^+v::SendInput {Alt down}h{Alt up}vv                                ; paste as value
^7::SendInput {Shift down}{F10}{Shift up}f{Tab}{Home}{Enter}        ; format number as "General"
^+7::SendInput {Shift down}{F10}{Shift up}f{Tab}{Home}Date{Enter}   ; format number as ''
#IfWinActive ahk_exe WINWORD.EXE
^+v::SendInput {Alt down}h{Alt up}vt                                ; paste as value
#IfWinActive


; Work in progress: fix terminal after vim
#IfWinActive ahk_exe Windows Terminal.exe
^+r::SendinPut {Alt down}{space}{Alt up}s{Down}{Down}{Up}{Right{Right}}{Left}{Esc}
#IfWinActive


; Toggle appmode in Windows to dark/light:
#+d::
    RegRead, appMode, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize, AppsUseLightTheme
    ; MsgBox, %appMode%
    If (appMode = 0) ; dark
        RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize, AppsUseLightTheme, 1
    else   ; If (appMode = 1) light
        RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize, AppsUseLightTheme, 0
return

