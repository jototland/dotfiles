#SingleInstance
#Warn

; Set Caps Lock to Compose Key.
; You can still double press if you want the original Caps Lock.
; You can also use Caps Lock as a modifier (see below)
$*CapsLock up::
    if (A_PriorHotKey == "$*CapsLock") {
        if (!compose_dbl_click) {
            compose()
        }
    }
return

$*CapsLock::
    compose_init()
    if (A_PriorHotkey == "$*CapsLock up" && A_TimeSincePriorHotkey < 200) {
        compose_dbl_click := True
        compose_found := False
        compose_input_hook.stop()
        SetCapsLockState, % GetKeyState("CapsLock", "T") ? "Off": "On"
    } else {
        compose_dbl_click := False
    }
return

#If GetKeyState("CapsLock", "P")
a::Home
c::CtrlBreak
d::Del
e::End
h::Left
j::Down
k::Up
l::Right
n::PgDn
p::PgUp
v::paste_text()
9::«
0::»
+(::‹
+)::›
^9::“
^0::”
^+(::‘
^+)::’
'::SendEvent, % GetKeyState("CapsLock", "T") ? "Æ" : "æ"
+'::SendEvent, % GetKeyState("CapsLock", "T") ? "æ" : "Æ"
`;::SendEvent, % GetKeyState("CapsLock", "T") ? "Ø" : "ø"
+`;::SendEvent, % GetKeyState("CapsLock", "T") ? "ø" : "Ø"
[::SendEvent, % GetKeyState("CapsLock", "T") ? "Å" : "å"
+[::SendEvent, % GetKeyState("CapsLock", "T") ? "å" : "Å"
#If

paste_text() {
    saveOldClipboard := ClipBoardAll
    Clipboard := ClipBoard
    SendInput ^v
    Sleep 50
    ClipBoard := saveOldClipboard
}

; Use the ISO extra key for something useful too
VKE2::
return

compose() {
    global compose_sequences
    global compose_found
    global compose_input_hook
    compose_input_hook.start()
    compose_input_hook.wait()
    text := compose_input_hook.input
    if (compose_found) {
        replacement := compose_sequences.item(text)
        SendInput, %replacement%
    } else {
        SendInput, %text%
    }
}

compose_key_down(ih, vk, sc) {
    global compose_sequences
    global compose_found
    text := ih.input
    still_hope := False
    compose_found := False
    for key in compose_sequences {
        if (key == text) {
            compose_found := True
            break
        }
        if RegExMatch(key, "^\Q" . text . "\E")
            still_hope := True
    }
    if (compose_found || !still_hope) {
        ih.stop()
    }
}

compose_init() {
    static init := False
    if (!init) {
        init := True
        global compose_input_hook := InputHook("", "{CtrlBreak}")
        compose_input_hook.KeyOpt("{All}", "N")
        compose_input_hook.OnKeyDown := Func("compose_key_down")
        global compose_sequences := ComObjCreate("Scripting.Dictionary")
        compose_sequences.Add("ae", "æ")
        compose_sequences.Add("o/", "ø")
        compose_sequences.Add("aa", "å")
        compose_sequences.Add("AE", "Æ")
        compose_sequences.Add("O/", "Ø")
        compose_sequences.Add("AA", "Å")

        ;; umlaut äëïöüÄËÏÖÜ
        compose_sequences.Add(""" ", "̈¨")
        ; umlaut minuscule
        compose_sequences.Add("""a", "ä")
        compose_sequences.Add("""e", "ë")
        compose_sequences.Add("""i", "ï")
        compose_sequences.Add("""o", "ö")
        compose_sequences.Add("""u", "ü")
        compose_sequences.Add("""y", "ÿ")
        ; umlaut majuscule
        compose_sequences.Add("""A", "Ä")
        compose_sequences.Add("""E", "Ë")
        compose_sequences.Add("""I", "Ï")
        compose_sequences.Add("""O", "Ö")
        compose_sequences.Add("""U", "Ü")
        compose_sequences.Add("""Y", "Ÿ")
        ;; grave àèìòùÀÈÌÒÙ
        ; grave minuscule
        compose_sequences.Add("``a", "à")
        compose_sequences.Add("``e", "è")
        compose_sequences.Add("``i", "ì")
        compose_sequences.Add("``o", "ò")
        compose_sequences.Add("``u", "ù")
        compose_sequences.Add("``y", "ỳ")
        ; grave majuscule
        compose_sequences.Add("``A", "À")
        compose_sequences.Add("``E", "È")
        compose_sequences.Add("``I", "Ì")
        compose_sequences.Add("``O", "Ò")
        compose_sequences.Add("``U", "Ù")
        compose_sequences.Add("``Y", "Ỳ")
        ;; acute áćéíĺńóṕŕśúýźÁĆÉÍĹŃÓṔŔŚÚÝŹ
        compose_sequences.Add("' ", "´")
        ; acute minuscule
        compose_sequences.Add("'a", "á")
        compose_sequences.Add("'e", "é")
        compose_sequences.Add("'i", "í")
        compose_sequences.Add("'o", "ó")
        compose_sequences.Add("'u", "ú")
        compose_sequences.Add("'y", "ý")
        ; acute majuscule
        compose_sequences.Add("'A", "Á")
        compose_sequences.Add("'E", "É")
        compose_sequences.Add("'I", "Í")
        compose_sequences.Add("'O", "Ó")
        compose_sequences.Add("'U", "Ú")
        compose_sequences.Add("'Y", "Ý")
        ;; circumflex âêĥîĵôŝûÂÊĤÎĴÔŜÛ
        ; circumflex minuscule
        compose_sequences.Add("^a", "â")
        compose_sequences.Add("^e", "ê")
        compose_sequences.Add("^i", "î")
        compose_sequences.Add("^o", "ô")
        compose_sequences.Add("^u", "û")
        compose_sequences.Add("^y", "ŷ")
        ; circumflex majuscule
        compose_sequences.Add("^A", "Â")
        compose_sequences.Add("^E", "Ê")
        compose_sequences.Add("^I", "Î")
        compose_sequences.Add("^O", "Ô")
        compose_sequences.Add("^U", "Û")
        compose_sequences.Add("^Y", "Ŷ")
        ;; cedilla çşģķļņÇŞĢĶĻŅ
        compose_sequences.Add(",c", "ç")
        compose_sequences.Add(",C", "Ç")
        ;; tilde ãñõÃÑÕ
        compose_sequences.Add("~a", "ã")
        compose_sequences.Add("~A", "Ã")
        compose_sequences.Add("~n", "ñ")
        compose_sequences.Add("~N", "Ñ")
        compose_sequences.Add("~o", "õ")
        compose_sequences.Add("~O", "Õ")
        ; ligatures
        compose_sequences.Add("oe", "œ")
        compose_sequences.Add("`ss", "ß") ; Eszett
        ; quotes
        compose_sequences.Add("<<", "«")
        compose_sequences.Add(">>", "»")
        compose_sequences.Add("> ", "›")
        compose_sequences.Add("< ", "‹")
        compose_sequences.Add("""<", "“") ; upper 66
        compose_sequences.Add(""">", "”") ; upper 99
        compose_sequences.Add(""",", "„") ; lower 99
        ; """": "‟" ; upper reversed 99
        compose_sequences.Add("'<", "‘") ; upper 6
        compose_sequences.Add("'>", "’") ; upper 9
        compose_sequences.Add("',", "‚") ; lower 9
        ; "''": "‛" ; upper reversed 9
        ; special punctuation
        compose_sequences.Add("??", "¿")
        compose_sequences.Add("!!", "¡")
        compose_sequences.Add("?!", "‽")    ; interrobang
        compose_sequences.Add("!?", "‽")
        compose_sequences.Add("...", "…")
        ; english ordinals
        compose_sequences.Add("^st", "ˢᵗ")
        compose_sequences.Add("^nd", "ⁿᵈ")
        compose_sequences.Add("^rd", "ʳᵈ")
        compose_sequences.Add("^th", "ᵗʰ")
        ; typography
        compose_sequences.Add("-h", "‐")        ; hyphen
        compose_sequences.Add("-m", "—")        ; em dash
        compose_sequences.Add("-n", "–")        ; en dash
        compose_sequences.Add("-s", "­")        ; soft hyphen
        compose_sequences.Add("-f", "‒")        ; figure dash (digit width)
        compose_sequences.Add("--", "―")        ; horizontal bar
        compose_sequences.Add("-~", "⁓")        ; swung dash
        compose_sequences.Add(" !", " ")        ; no break space
        compose_sequences.Add(" m", " ")        ; em space
        compose_sequences.Add(" n", " ")        ; en dash
        compose_sequences.Add(" 0", " ")        ; figure space (digit width)
        compose_sequences.Add(" t", " ")        ; thin space (inside quotation marks)
        ; other signs
        compose_sequences.Add("No", "№")            ; numero
        compose_sequences.Add("co", "℅")            ; c/o
        compose_sequences.Add("AS", "⅍")            ; A/S
        compose_sequences.Add("So", "§")            ; section
        compose_sequences.Add("PP", "¶")            ; pilcrow / paragraph
        compose_sequences.Add("dg", "†")            ; dagger
        compose_sequences.Add("ddg", "‡")           ; double dagger
        compose_sequences.Add("O*", "⎈")            ; helm
        compose_sequences.Add("b.", "•")            ; bullet
        compose_sequences.Add("vv", "✓")            ; checkmark
        compose_sequences.Add("xx", "✗")            ; ballot x
        compose_sequences.Add("E=", "€")            ; euro
        compose_sequences.Add("S=", "$")            ; dollar
        compose_sequences.Add("L=", "£")            ; pound / Lira
        compose_sequences.Add("c=", "¢")            ; cent
        compose_sequences.Add("Y=", "¥")            ; yen: Japan, China
        compose_sequences.Add("R=", "₽")            ; ruble: Russia
        compose_sequences.Add("r=", "₹")            ; rupee: India
        compose_sequences.Add("W=", "₩")            ; won: Korea
        compose_sequences.Add("s=", "₪")            ; shekel: Israel
        compose_sequences.Add("l=", "₺")            ; lira: Turkey
        compose_sequences.Add("B=", "₿")            ; bitcoin
        compose_sequences.Add("o=", "¤")            ; pillow / generic currency
        compose_sequences.Add("OC", "©")            ; copyright
        compose_sequences.Add("OR", "®")            ; registered
        compose_sequences.Add("OP", "℗")            ; phonogram
        compose_sequences.Add("TM", "™")            ; trademark
        compose_sequences.Add("Ho", "⌘")            ; severdighet
        compose_sequences.Add("  ", "␣")            ; underbox
        ; math
        compose_sequences.Add("oo", "°")            ; degrees
        compose_sequences.Add("oC", "℃")            ; degrees Celcius
        compose_sequences.Add("oF", "℉")            ; degrees Fahrenheit
        compose_sequences.Add("88", "∞")            ; infinity
        compose_sequences.Add("8c", "∝")            ; proportional
        compose_sequences.Add("vo", "∡")            ; angle
        compose_sequences.Add("vt", "⟂")            ; straight angle
        compose_sequences.Add("diam", "⌀")          ; diameter
        compose_sequences.Add("%0", "‰")            ; per mille
        compose_sequences.Add("%.", "‱")            ; per then thousand
        compose_sequences.Add("mx", "×")            ; cross product
        compose_sequences.Add("m/", "÷")            ; division
        compose_sequences.Add("m-", "−")            ; minus
        compose_sequences.Add("+-", "±")            ; plus/minus
        compose_sequences.Add("-+", "∓")            ; minus/plus
        compose_sequences.Add("2v", "√")            ; square root
        compose_sequences.Add("3v", "∛")            ; third root
        compose_sequences.Add("4v", "∜")            ; fourth root
        compose_sequences.Add("t(", "⌈")            ; left ceiling
        compose_sequences.Add("t)", "⌉")            ; right ceiling
        compose_sequences.Add("l(", "⌊")            ; left floor
        compose_sequences.Add("l)", "⌋")            ; right floor
        compose_sequences.Add("!=", "≠")            ; not equal
        compose_sequences.Add("==", "≡")            ; identical
        compose_sequences.Add("~~", "≈")            ; approximately equal
        compose_sequences.Add("!~", "≉")            ; not approximately equal
        compose_sequences.Add("<=", "≤")            ; less than or equal
        compose_sequences.Add(">=", "≥")            ; greater than or equal
        compose_sequences.Add("!<<", "≮")           ; not less than
        compose_sequences.Add("!>>", "≯")           ; not greater than
        compose_sequences.Add("!<=", "≰")           ; not less than or equal
        compose_sequences.Add("!>=", "≱")           ; not greater than or equal
        compose_sequences.Add("<!=", "≨")           ; less than not equal
        compose_sequences.Add(">!=", "≩")           ; greater than not equal
        compose_sequences.Add("<.<", "≪")           ; much less than
        compose_sequences.Add(">.>", "≫")           ; much greater than
        compose_sequences.Add("-<", "←")            ; left arrow
        compose_sequences.Add("->", "→")            ; right arrow
        compose_sequences.Add("<>", "↔")            ; left/right arrow
        compose_sequences.Add("=<", "⇐")            ; left double arrow
        compose_sequences.Add("=>", "⇒")            ; right double arrow
        compose_sequences.Add("m.", "·")            ; dot product
        compose_sequences.Add("mo", "∘")            ; ring operator
        compose_sequences.Add("not", "¬")           ; not
        compose_sequences.Add("empt", "∅")          ; empty set
        compose_sequences.Add("cc", "∁")            ; complement
        compose_sequences.Add("fa", "∀")            ; for all
        compose_sequences.Add("ex", "∃")            ; exists
        compose_sequences.Add("!ex", "∄")           ; not exists
        compose_sequences.Add("in", "∈")            ; in
        compose_sequences.Add("!in", "∉")           ; not in
        compose_sequences.Add("ni", "∋")            ; has
        compose_sequences.Add("!ni", "∌")           ; not has
        compose_sequences.Add("and", "∧")           ; and
        compose_sequences.Add("or", "∨")            ; or
        compose_sequences.Add("cap", "∩")           ; intersection
        compose_sequences.Add("cup", "∪")           ; union
        compose_sequences.Add("((", "⊂")            ; subset
        compose_sequences.Add("))", "⊃")            ; superset
        compose_sequences.Add("!((", "⊄")           ; not subset
        compose_sequences.Add("!))", "⊅")           ; not superset
        compose_sequences.Add("(=", "⊆")            ; subset or equal
        compose_sequences.Add(")=", "⊇")            ; superset or equal
        compose_sequences.Add("!(=", "⊈")           ; not subset or equal
        compose_sequences.Add("!)=", "⊉")           ; not superset or equal
        compose_sequences.Add("(!=", "⊊")           ; subset not equal
        compose_sequences.Add(")!=", "⊋")           ; superset not equal
        compose_sequences.Add(".^", "∴")            ; therefore
        compose_sequences.Add(".v", "∵")            ; because
        compose_sequences.Add("qed", "∎")
        compose_sequences.Add("SS", "∫")            ; integral
        compose_sequences.Add("2SS", "∬")           ; double integral
        compose_sequences.Add("3SS", "∭")           ; triple integral
        compose_sequences.Add("oSS", "∮")           ; countour integral
        compose_sequences.Add("sSS", "∯")           ; surface integral
        compose_sequences.Add("vSS", "∰")           ; volume integral
        compose_sequences.Add("pd", "∂")            ; partial derivative
        compose_sequences.Add("Delta", "∆")
        compose_sequences.Add("del", "∇")
        compose_sequences.Add("nabla", "∇")
        compose_sequences.Add("prod", "∏")
        compose_sequences.Add("dorp", "∐")
        compose_sequences.Add("sum", "∑")
        compose_sequences.Add("^0", "⁰")
        compose_sequences.Add("^1", "¹")
        compose_sequences.Add("^2", "²")
        compose_sequences.Add("^3", "³")
        compose_sequences.Add("^4", "⁴")
        compose_sequences.Add("^5", "⁵")
        compose_sequences.Add("^6", "⁶")
        compose_sequences.Add("^7", "⁷")
        compose_sequences.Add("^8", "⁸")
        compose_sequences.Add("^9", "⁹")
        compose_sequences.Add("_0", "₀")
        compose_sequences.Add("_1", "₁")
        compose_sequences.Add("_2", "₂")
        compose_sequences.Add("_3", "₃")
        compose_sequences.Add("_4", "₄")
        compose_sequences.Add("_5", "₅")
        compose_sequences.Add("_6", "₆")
        compose_sequences.Add("_7", "₇")
        compose_sequences.Add("_8", "₈")
        compose_sequences.Add("_9", "₉")
        compose_sequences.Add("NN", "ℕ")
        compose_sequences.Add("ZZ", "ℤ")
        compose_sequences.Add("QQ", "ℚ")
        compose_sequences.Add("RR", "ℝ")
        compose_sequences.Add("CC", "ℂ")
        compose_sequences.Add("HH", "ℍ")
        compose_sequences.Add("FF", "ℱ")
        ; greek
        compose_sequences.Add("ga", "α")                ; alpha
        compose_sequences.Add("gA", "Α")
        compose_sequences.Add("gb", "β")                ; beta
        compose_sequences.Add("gB", "Β")
        compose_sequences.Add("gg", "γ")                ; gamma
        compose_sequences.Add("gG", "Γ")
        compose_sequences.Add("gd", "δ")                ; delta
        compose_sequences.Add("gD", "Δ")
        compose_sequences.Add("gep", "ε")               ; epsilon
        compose_sequences.Add("gEp", "Ε")
        compose_sequences.Add("gz", "ζ")                ; zeta
        compose_sequences.Add("gZ", "Ζ")
        compose_sequences.Add("get", "η")               ; eta
        compose_sequences.Add("gEt", "Η")
        compose_sequences.Add("gth", "θ")               ; theta
        compose_sequences.Add("gTh", "Θ")
        compose_sequences.Add("gi", "ι")                ; iota
        compose_sequences.Add("gI", "Ι")
        compose_sequences.Add("gk", "κ")                ; kappa
        compose_sequences.Add("gK", "Κ")
        compose_sequences.Add("gl", "λ")                ; lambda
        compose_sequences.Add("gL", "Λ")
        compose_sequences.Add("gm", "μ")                ; mu
        compose_sequences.Add("gM", "Μ")
        compose_sequences.Add("gn", "ν")                ; nu
        compose_sequences.Add("gN", "Ν")
        compose_sequences.Add("gx", "ξ")                ; xi
        compose_sequences.Add("gX", "Ξ")
        compose_sequences.Add("go", "ο")                ; omicron
        compose_sequences.Add("gO", "Ο")
        compose_sequences.Add("gpi", "π")               ; pi
        compose_sequences.Add("gPi", "Π")
        compose_sequences.Add("gr", "ρ")                ; rho
        compose_sequences.Add("gR", "Ρ")
        compose_sequences.Add("gs", "σ")                ; sigma
        compose_sequences.Add("gS", "Σ")
        compose_sequences.Add("gta", "τ")               ; tau
        compose_sequences.Add("gTa", "Τ")
        compose_sequences.Add("gy", "υ")                ; upsilon
        compose_sequences.Add("gY", "Υ")
        compose_sequences.Add("gf", "φ")                ; phi
        compose_sequences.Add("gF", "Φ")
        compose_sequences.Add("gc", "χ")                ; chi
        compose_sequences.Add("gC", "Χ")
        compose_sequences.Add("gps", "ψ")               ; psi
        compose_sequences.Add("gPs", "Ψ")
        compose_sequences.Add("gw", "ω")                ; omega
        compose_sequences.Add("gW", "Ω")
        ; hebrew
        compose_sequences.Add("ha", "ℵ")                ; aleph
        compose_sequences.Add("hb", "ℶ")                ; beth
        compose_sequences.Add("hg", "ℷ")                ; gimel
        compose_sequences.Add("hd", "ℸ")                ; dalet
        ; emoji / other symbols
        compose_sequences.Add("gear", "⚙")              ; gear wheel
        compose_sequences.Add("warn", "⚠")              ; warning sign
        compose_sequences.Add("el", "⚡")               ; high voltage
        compose_sequences.Add("nucl", "☢")              ; nuclear warning
        compose_sequences.Add("bio", "☣")               ; biohazard warning
        compose_sequences.Add("net", "🖧")              ; computer networkk
        compose_sequences.Add("cycl", "♲")              ; recycling
        compose_sequences.Add("male", "♂")              ; male symbol
        compose_sequences.Add("fema", "♀")              ; female symbol

        ;;;;;;;;;;;;;;;;;
        global compose_found := False
    }
}
