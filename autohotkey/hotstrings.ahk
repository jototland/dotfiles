#SingleInstance

; #Hotstring EndChars `;

; hs_replace(to) {
;     from := substr(A_ThisHotKey, 6)
;     global hs_replace_from := from . ";"
;     global hs_replace_to := to
;     sendinput %hs_replace_to%
;     hotkey, `;, hs_undo_replace, on
;     settimer, hs_disable_undo_replace, -1000
; }

; hs_undo_replace:
;     settimer, hs_disable_undo_replace, off
;     hotkey, `;, hs_undo_replace, off
;     global hs_replace_from, hs_replace_to
;     hslen := strlen(hs_replace_to)
;     sendinput {bs %hslen%}%hs_replace_from%
;     hotkey, `;, hs_redo_replace, on
;     settimer, hs_disable_redo_replace, -1000
; return

; hs_disable_undo_replace:
;     settimer, hs_disable_undo_replace, off
;     hotkey, `;, hs_undo_replace, off
; return

; hs_redo_replace:
;     settimer, hs_disable_redo_replace, off
;     hotkey, `;, hs_redo_replace, off
;     global hs_replace_from, hs_replace_to
;     hslen := strlen(hs_replace_from)
;     sendinput {bs %hslen%}%hs_replace_to%
;     hotkey, `;, hs_undo_replace, on
;     settimer, hs_disable_undo_replace, -1000
; return

; hs_disable_redo_replace:
;     settimer, hs_disable_redo_replace, off
;     hotkey, `;, hs_redo_replace, off
; return

; ; :?*C:dog::poodle
; ; :?*C:poj::poodle

; ; english ordinals
; :?XC:1st::hs_replace("1ˢᵗ")
; :?XC:2nd::hs_replace("2ⁿᵈ")
; :?XC:3rd::hs_replace("3ʳᵈ")
; :?XC:4th::hs_replace("4ᵗʰ")
; :?XC:5th::hs_replace("5ᵗʰ")
; :?XC:6th::hs_replace("6ᵗʰ")
; :?XC:7th::hs_replace("7ᵗʰ")
; :?XC:8th::hs_replace("8ᵗʰ")
; :?XC:9th::hs_replace("9ᵗʰ")
; :?XC:0th::hs_replace("0ᵗʰ")

; ; current date
; hs_date() {
;     hs_replace(A_YYYY . "-" . A_MM . "-" . A_DD)
; }
; :?XC:date::hs_date()
