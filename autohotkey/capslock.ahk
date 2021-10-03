#SingleInstance

; disable Caps Lock
Capslock::
+Capslock::
^Capslock::
^+Capslock::
!Capslock::
!+Capslock::
!^Capslock::
!^+Capslock::
#Capslock::
#+Capslock::
#^Capslock::
#^+Capslock::
#!Capslock::
#!+Capslock::
#!^Capslock::
#!^+Capslock::
    return

; replace Caps Lock with both shift keys
~LShift::
~Rshift::
If (A_ThisHotkey = "~LShift")
    KeyWait, RShift, D T.5
Else
    KeyWait, LShift, D T.5
If Not ErrorLevel
    SetCapsLockState, % GetKeyState("CapsLock","T") ? "Off" : "On"
return

; Some new uses for Caps Lock (used as a modifier)
#If GetKeyState("CapsLock", "P")
a::Esc
h::Left
j::Down
k::Up
l::Right
y::Home
u::PgDn
i::PgUp
o::End
9::«
0::»
+(::‹
+)::›
^9::“
^0::”
^+(::‘
^+)::’
'::æ
+'::Æ
`;::ø
+`;::Ø
[::å
+[::Å
#If
