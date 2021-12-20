mode_flicker(mode, status) {
    SplashImage, , B w%A_ScreenWidth% h%A_ScreenHeight% cwBlack NA
    Sleep, 50
    SplashImage, off
    status := status ? "on" : "off"
    ToolTip, %mode%: %status%
    SetTimer, mode_flicker_remove_tooltip, -1000
}

mode_flicker_remove_tooltip:
ToolTip
return

arrow_mode(cmd) {
    static status := 0
    if (cmd == "status") {
        return status
    }
    if (cmd == "toggle") {
        status := !status
        mode_flicker("Arrow mode", status)
        return
    }
    if (status != cmd) {
        status := cmd
        mode_flicker("Arrow mode", status)
    }
}


#if % arrow_mode("status")
*r::Home
*v::End
*w::PgUp
*x::PgDn
*s::Left
*d::return
*e::Up
*f::Right

*u::Home
*m::End
*o::PgUp
*.::PgDn
*j::Left
*k::return
*i::Up
*l::Right

*`::return
*1::return
*2::return
*3::return
*4::return
*5::return
*6::return
*7::return
*8::return
*9::return
*0::return
*-::return
*=::return

*q::return
*t::return
*y::return
*p::return
*[::return
*]::return

*a::return
*g::return
*h::return
*`;::return
*'::return
*\::return

*z::return
*c::SendInput, {Down}
*b::return
*n::return
*,::SendInput, {Down}
*/::return

Space::
CapsLock::
Esc::
Tab::
^c::
    arrow_mode(0)
return
#if
