#SingleInstance

; hotkeys for windows desktop
#IfWinActive ahk_class WorkerW
s::set_pincode()
#IfWinActive ahk_class Progman
s::set_pincode()
#IfWinActive

#F12::report_winsize()
report_winsize() {
    WinGetActiveStats title, width, height, x, y
    info := "width: " . width . " pixels.`n"
    . "els`nheight: " . height . " pixels."
    Traytip, %title% :, %info%
}

init_pincode() {
    static init := False
    if (!init) {
        init := True
        global secret_pincode_set = "no"
        global secret_pincode := ""
    }
}

set_pincode() {
    global secret_pincode, secret_pincode_set
    inputbox secret_pincode, What`'s your pincode?, What`'s your pincode?, hide
    if (errorlevel == 0) {
        secret_pincode_set := "yes"
        sleep, 100
        return 1
    } else {
        secret_pincode_set := ""
        secret_pincode := ""
        Traytip, Warning: No pincode set, No pincode set!
        return 0
    }
}

ensure_pincode_set() {
    global secret_pincode, secret_pincode_set
    if (secret_pincode_set <> "yes") {
        set_pincode()
    }
}

; fill out credentials for user n
credentials_send_pincode_for_user(n) {
    init_pincode()
    global secret_pincode, secret_pincode_set
    if WinActive("Windows Security") {
        WinGetActiveStats title, width, height, x, y
        if ((height >= 347 and height <= 351) || (height >= 520 and height <= 524)) {  ; scale 100%, 150%
            MouseClick, left, 100, 130
            SendInput, {Tab 2}{Space}
            Sleep, 100
            tabs := n + 1
            SendInput, {Tab %tabs%}{Space}
            Sleep, 100
            WinGetActiveStats title, width, height, x, y
            if (height >= 350) {
                MouseClick, left, 150, 225
                ensure_pincode_set()
                if (secret_pincode_set == "yes") {
                    SendInput, %secret_pincode%
                    SendInput, {Enter}
                } else
                    SendInput, {Esc}
            }
        }
    }
}

#IFWinActive Windows Security ; credentials popup
^i::
    credentials_send_pincode_for_user(1)
return
^u::
    credentials_send_pincode_for_user(2)
return
#IfWinActive

#IfWinActive ahk_class #32770 ; mstsc.exe start screen
^i::
    SendInput, {Alt down}n{Alt up}
    WinWait, Windows Security,, 2
    if (!ErrorLevel) {
        sleep, 500
        credentials_send_pincode_for_user(1)
    }
return
^u::
    SendInput, {Alt down}n{Alt up}
    WinWait, Windows Security,, 2
    if (!ErrorLevel) {
        sleep, 500
        credentials_send_pincode_for_user(2)
    }
return
#IfWinActive
