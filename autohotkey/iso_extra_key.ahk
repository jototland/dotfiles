*VKE2::return
VKE2 up::
    if (A_PriorHotKey == "*VKE2") {
        SendInput, {Escape}
    }
return

#If GetKeyState("VKE2", "P")
*m::SendInput, {NumPad1}
*,::SendInput, {NumPad2}
*.::SendInput, {NumPad3}
*j::SendInput, {NumPad4}
*k::SendInput, {NumPad5}
*l::SendInput, {NumPad6}
*u::SendInput, {NumPad7}
*i::SendInput, {NumPad8}
*o::SendInput, {NumPad9}
*Space::SendInput, {Numpad0}
s::ask_resize_window()
z::move_resize_window_absolute( , , , 1920, 1048)
v::paste_text()
p::send_play_pause()
[::Volume_Down
]::Volume_Up
0::Volume_Mute
-::set_brightness(get_brightness() // 10 * 10 - 10)
+-::set_brightness(0)
=::set_brightness(get_brightness() // 10 * 10 + 10)
+=::set_brightness(100)
#If

send_play_pause() {
    SendInput, {Media_Play_Pause}
}

paste_text() {
    saveOldClipboard := ClipBoardAll
    Clipboard = %ClipBoard%
    SendInput ^v
    Sleep 50
    ClipBoard := saveOldClipboard
}

mon_bounds(x, y) {
    local monitor_count, primary_monitor, mon_bounds_
    , mon_bounds_left, mon_bounds_right, mon_bounds_top, mon_bounds_bottom, found
    SysGet, primary_monitor, MonitorPrimary
    SysGet, monitor_count, 80
    found := False
    Loop, %monitor_count% {
        SysGet, mon_bounds_, MonitorWorkArea, %A_Index%
        if (mon_bounds_left <= x and x <= mon_bounds_right
        and mon_bounds_top <= y and y <= mon_bounds_bottom) {
            return {monitor: A_Index, primary: primary_monitor
            , left: mon_bounds_left, right: mon_bounds_right
            , top: mon_bounds_top, bottom: mon_bounds_bottom
            , width: mon_bounds_right - mon_bounds_left
            , height: mon_bounds_bottom - mon_bounds_top}
        }
    }
    SysGet, mon_bounds_, MonitorWorkArea, %primary_monitor%
    return {monitor: A_Index, primary: primary_monitor
    , left: mon_bounds_left, right: mon_bounds_right
    , top: mon_bounds_top, bottom: mon_bounds_bottom
    , width: mon_bounds_right - mon_bounds_left
    , height: mon_bounds_bottom - mon_bounds_top}
}

ask_resize_window() {
    local current_window, x, y, w, h, new_w, new_h, size, matches, mon
    WinGet, current_window, ID, A
    WinGetPos, x, y, w, h, ahk_id %current_window%
    mon := mon_bounds(x + w/2, y + h/2)
    Inputbox, size, Enter new size:, Current size is %w% by %h%`n`nNew size:
    if (ErrorLevel == 0) {
        if (RegExMatch(size, "O)^([0-9]*)(\%?)[xX*, ]([0-9]*)(\%?)$", matches)) {
            new_w := matches.value(1)
            new_h := matches.value(3)
            if (matches.value(2) == "%") {
                new_w := (new_w * (mon.right - mon.left)) // 100
            }
            if (matches.value(4) == "%") {
                new_h := (new_h * (mon.bottom - mon.top)) // 100
            }
            move_resize_window_absolute(current_window, , , new_w, new_h)
        }
    }
}

ask_move_window() {
    local current_window, x, y, w, h, new_x, new_y, pos, matches, mon
    WinGet, current_window, ID, A
    WinGetPos, x, y, w, h, ahk_id %current_window%
    mon := mon_bounds(x + w/2, y + h/2)
    Inputbox, pos, Enter new position:, Current position is %x%, %y%`n`nNew position:
    if (ErrorLevel == 0) {
        if (RegExMatch(size, "O)^([0-9]+)(\%?)[, ]([0-9]+)(\%?)$", matches)) {
            new_x := matches.value(1)
            new_y := matches.value(3)
            if (matches.value(2) == "%") {
                new_x := (new_x * (mon.right - mon.left)) // 100
            }
            if (matches.value(4) == "%") {
                new_y := (new_y * (mon.bottom - mon.top)) // 100
            }
            move_resize_window_absolute(current_window, new_x, new_y)
        }
    }
}

move_resize_window_absolute(window:="", new_x:="", new_y:="", new_w:="", new_h:="") {
    local x, y, w, h, mon, win
    ; win := window
    if (window == "") {
        WinGet, window, ID, A
    }
    WinGetPos, x, y, w, h, ahk_id %window%
    if (new_w == "") {
        new_w := w
    }
    if (new_h == "") {
        new_h := h
    }
    if (new_x == "") {
        new_x := x - (new_w - w) // 2
    }
    if (new_y == "") {
        new_y := y - (new_h - h) // 2
    }
    mon := mon_bounds(new_x + new_w/2, new_y + new_h/2)
    new_w := min(new_w, mon.width)
    new_h := min(new_h, mon.height)
    new_x := max(new_x, mon.left)
    new_y := max(new_y, mon.top)
    new_x := min(new_x, mon.width - new_w)
    new_y := min(new_y, mon.height - new_h)
    WinMove, ahk_id %window%, , %new_x%, %new_y%, %new_w%, %new_h%
}

move_resize_window_relative(window:="", new_x:=0, new_y:=0, new_w:=0, new_h:=0) {
    local x, y, w, h, mon
    if (window == "") {
        WinGet, window, ID, A
    }
    WinGetPos, x, y, w, h, ahk_id %window%
    mon := mon_bounds(new_x + new_w/2, new_y + new_h/2)
    new_x := x + new_x
    new_y := y + new_y
    new_w := w + new_w
    new_h := h + new_h
    move_resize_window_absolute(window, new_x, new_y, new_w, new_h)
}


; Functions
set_brightness(ByRef brightness := 50, timeout = 1) {
    if (brightness > 100) {
        brightness := 100
    }
    if (brightness < 0) {
        brightness := 0
    }
    For property in ComObjGet("winmgmts:\\.\root\WMI").ExecQuery("SELECT * FROM WmiMonitorBrightnessMethods") {
        property.WmiSetBrightness(timeout, brightness)
    }
}

get_brightness() {
    For property in ComObjGet("winmgmts:\\.\root\WMI").ExecQuery("SELECT * FROM WmiMonitorBrightness") {
        currentBrightness := property.CurrentBrightness
    }
    return currentBrightness
}
