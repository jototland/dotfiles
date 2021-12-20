+Backspace::
    SendInput, {Delete}
return

SC121::
Launch_App2::
    if WinExist("ahk_class Rgui") {
        WinActivate
    } else {
        Run "%USERPROFILE%\scoop\apps\r\current\bin\x64\Rgui.exe" --quiet --no-save --no-restore
    }
return


#IfWinActive ahk_exe OUTLOOK.EXE
^+v::SendInput {Alt down}h{Alt up}vt                                ; paste as value
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


