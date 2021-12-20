#SingleInstance
#Warn

; Set Caps Lock to Compose Key
*CapsLock::return
CapsLock::
    compose()
return

; Also use Caps Lock as a modifier
#If GetKeyState("CapsLock", "P")
    a::
        if (GetKeyState("CapsLock", "T")) {
            SetCapsLockState, off
        } else {
            SetCapsLockState, on
        }
    return
    c::
        compose_stop()
        SendEvent, {Ctrl down}{CtrlBreak}{Ctrl up}
    return
    e::
        compose_stop()
        SendEvent, {Escape}
    return
    Space::
        compose_stop()
        arrow_mode("toggle")
    return
    s::
        compose_stop()
        SendEvent, {ScrollLock}
    return
    i::
        compose_stop()
        SendEvent, {Insert}
    return
    '::
        compose_stop()
        SendInput, æ
    return
    "::
        compose_stop()
        SendInput, Æ
    return
    `;::
        compose_stop()
        SendInput, ø
    return
    :::
        compose_stop()
        SendInput, Ø
    return
    [::
        compose_stop()
        SendInput, å
    return
    {::
        compose_stop()
        SendInput, Å
    return
    *h::
        compose_stop()
        SendInput, {Blind}{Left}
    return
    *j::
        compose_stop()
        SendInput, {Blind}{Down}
    return
    *k::
        compose_stop()
        SendInput, {Blind}{Up}
    return
    *l::
        compose_stop()
        SendInput, {Blind}{Right}
    return
    *u::
        compose_stop()
        SendInput, {Blind}{Home}
    return
    *m::
        compose_stop()
        SendInput, {Blind}{End}
    return
    *o::
        compose_stop()
        SendInput, {Blind}{PgUp}
    return
    *.::
        compose_stop()
        SendInput, {Blind}{PgDn}
    return
#If

compose() {
    global compose_sequences
    global compose_found
    global compose_input_hook
    compose_init()
    compose_found := False
    compose_input_hook.start()
    compose_input_hook.wait()
    text := compose_input_hook.input
    if (compose_found) {
        replacement := compose_sequences.item(text)
        if (IsFunc(replacement)) {
            replacement.Call()
        } else {
            SendInput, %replacement%
        }
    } else {
        SendInput, %text%
    }
}

compose_stop() {
    compose_init()
    global compose_input_hook
    compose_input_hook.stop()
}

compose_key_down(ih, vk, sc) {
    global compose_sequences
    global compose_found
    text := ih.input
    still_hope := False
    compose_found := False
    if (compose_sequences.Exists(text)) {
        compose_found := True
    } else {
        for key in compose_sequences {
            if RegExMatch(key, "^\Q" . text . "\E")
                still_hope := True
        }
    }
    if (compose_found || !still_hope) {
        ih.stop()
    }
}

vim() {
    local USERPROFILE
    EnvGet USERPROFILE, USERPROFILE
    Run, gvim.bat, %USERPROFILE%
}

compose_init() {
    static init := False
    if (!init) {
        init := True
        global compose_input_hook := InputHook("", "{CtrlBreak}{Esc}{Backspace}{Del}{CapsLock}{ScrollLock}")
        compose_input_hook.KeyOpt("{All}", "N")
        compose_input_hook.OnKeyDown := Func("compose_key_down")
        global compose_sequences := ComObjCreate("Scripting.Dictionary")
        ; Norway: æøå
        compose_sequences.Add("ae", "æ")
        compose_sequences.Add("/o", "ø")
        compose_sequences.Add("oa", "å")
        compose_sequences.Add("AE", "Æ")
        compose_sequences.Add("/O", "Ø")
        compose_sequences.Add("oA", "Å")

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
        compose_sequences.Add("'`n", "´")
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
        compose_sequences.Add("````", "“") ; upper 66 quote
        compose_sequences.Add("''", "”") ; upper 99 quote
        compose_sequences.Add(",,", "„") ; lower 99 quote
        compose_sequences.Add("`` ", "‘") ; upper 6 quote
        compose_sequences.Add("' ", "’") ; upper 9 quote
        compose_sequences.Add(", ", "‚") ; lower 9 quote
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
        compose_sequences.Add("c/o", "℅")            ; c/o
        compose_sequences.Add("AS", "⅍")            ; A/S
        compose_sequences.Add("So", "§")            ; section
        compose_sequences.Add("PP", "¶")            ; pilcrow / paragraph
        compose_sequences.Add("dag", "†")            ; dagger
        compose_sequences.Add("ddag", "‡")           ; double dagger
        compose_sequences.Add("*O", "⎈")            ; helm
        compose_sequences.Add("bul", "•")           ; bullet
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
        compose_sequences.Add("deg", "°")           ; degrees
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
        compose_sequences.Add("c(", "⌈")            ; left ceiling
        compose_sequences.Add("c)", "⌉")            ; right ceiling
        compose_sequences.Add("f(", "⌊")            ; left floor
        compose_sequences.Add("f)", "⌋")            ; right floor
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
        compose_sequences.Add("<.", "≪")            ; much less than
        compose_sequences.Add(">.", "≫")            ; much greater than
        compose_sequences.Add("-<", "←")            ; left arrow
        compose_sequences.Add("->", "→")            ; right arrow
        compose_sequences.Add("-^", "↑")            ; right arrow
        compose_sequences.Add("-v", "↓")            ; right arrow
        compose_sequences.Add("<>", "↔")            ; left/right arrow
        compose_sequences.Add("=<", "⇐")            ; left double arrow
        compose_sequences.Add("=>", "⇒")            ; right double arrow
        compose_sequences.Add("=^", "⇑")            ; right double arrow
        compose_sequences.Add("=v", "⇓")            ; right double arrow
        compose_sequences.Add("m.", "·")            ; dot product
        compose_sequences.Add("mo", "∘")            ; ring operator
        compose_sequences.Add("not", "¬")           ; not
        compose_sequences.Add("o/", "∅")            ; empty set
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
        compose_sequences.Add("xU", "∩")            ; union
        compose_sequences.Add("UU", "∪")            ; union
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
        compose_sequences.Add("[[", "⊏")            ; image of
        compose_sequences.Add("]]", "⊐")            ; original of
        compose_sequences.Add("[=", "⊑")            ; image of or equal
        compose_sequences.Add("]=", "⊒")            ; original of or equal
        compose_sequences.Add("![=", "⋢")           ; not image of or equal
        compose_sequences.Add("!]=", "⋣")           ; not original of or equal
        compose_sequences.Add("O-", "⊖")            ; circled minus
        compose_sequences.Add("O+", "⊕")            ; circled plus
        compose_sequences.Add("Ox", "⊗")            ; circled multiply
        compose_sequences.Add("O.", "⊙")            ; circled dot
        compose_sequences.Add("O/", "⊘")            ; circled slash
        compose_sequences.Add("Oo", "⊚")            ; circled ring
        compose_sequences.Add("O*", "⊛")            ; circled star
        compose_sequences.Add("T<", "⊣")            ; circled star
        compose_sequences.Add("T>", "⊢")            ; circled star
        compose_sequences.Add("T^", "⊥")            ; circled star
        compose_sequences.Add("Tv", "⊤")            ; circled star
        compose_sequences.Add("oo", "∘")            ; ring operator

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
        compose_sequences.Add("ge", "ε")                ; epsilon
        compose_sequences.Add("gE", "Ε")
        compose_sequences.Add("gz", "ζ")                ; zeta
        compose_sequences.Add("gZ", "Ζ")
        compose_sequences.Add("gh", "η")                ; eta
        compose_sequences.Add("gH", "Η")
        compose_sequences.Add("gq", "θ")                ; theta
        compose_sequences.Add("gQ", "Θ")
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
        compose_sequences.Add("gp", "π")                ; pi
        compose_sequences.Add("gP", "Π")
        compose_sequences.Add("gr", "ρ")                ; rho
        compose_sequences.Add("gR", "Ρ")
        compose_sequences.Add("gs", "σ")                ; sigma
        compose_sequences.Add("gS", "Σ")
        compose_sequences.Add("gt", "τ")                ; tau
        compose_sequences.Add("gT", "Τ")
        compose_sequences.Add("gu", "υ")                ; upsilon
        compose_sequences.Add("gU", "Υ")
        compose_sequences.Add("gf", "φ")                ; phi
        compose_sequences.Add("gF", "Φ")
        compose_sequences.Add("gc", "χ")                ; chi
        compose_sequences.Add("gC", "Χ")
        compose_sequences.Add("gy", "ψ")                ; psi
        compose_sequences.Add("gY", "Ψ")
        compose_sequences.Add("gw", "ω")                ; omega
        compose_sequences.Add("gW", "Ω")
        ; hebrew
        compose_sequences.Add("ha", "ℵ")                ; aleph
        compose_sequences.Add("hb", "ℶ")                ; beth
        compose_sequences.Add("hg", "ℷ")                ; gimel
        compose_sequences.Add("hd", "ℸ")                ; dalet
        ; emoji / other symbols
        compose_sequences.Add("cog", "⚙")              ; gear wheel
        compose_sequences.Add("war", "⚠")              ; warning sign
        compose_sequences.Add("el", "⚡")               ; high voltage
        compose_sequences.Add("nuc", "☢")              ; nuclear warning
        compose_sequences.Add("bio", "☣")               ; biohazard warning
        compose_sequences.Add("net", "🖧")              ; computer networkk
        compose_sequences.Add("cyc", "♲")              ; recycling
        compose_sequences.Add("mal", "♂")              ; male symbol
        compose_sequences.Add("fem", "♀")              ; female symbol

        compose_sequences.Add("lorem", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
        lorem5 =
(
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vulputate volutpat sem, et varius nisl rutrum ac. Nam elementum maximus feugiat. Vestibulum vulputate sodales pretium. Etiam a venenatis erat. Aliquam non sagittis sem. Morbi aliquam gravida neque eget mattis. Donec efficitur augue tellus, faucibus aliquam nisi suscipit sit amet. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Fusce ut lacus eleifend, vestibulum sem quis, auctor odio.

Proin blandit purus a erat placerat, vel venenatis lectus feugiat. Cras nec diam gravida, imperdiet libero ut, mattis velit. Vivamus cursus, turpis eget tincidunt tristique, augue arcu condimentum purus, sit amet luctus elit libero quis lorem. Proin pharetra orci in libero accumsan, eleifend mattis justo tempor. Morbi nec rutrum neque. Maecenas lobortis lectus ac augue hendrerit, id semper dui posuere. Vivamus at suscipit nulla.

Vestibulum imperdiet laoreet erat vitae faucibus. Sed et felis sed massa laoreet tincidunt. Quisque commodo ante et sapien sagittis pulvinar. Aenean tempor auctor nisl, sed dignissim libero facilisis et. Curabitur vitae nibh efficitur arcu accumsan lacinia nec a risus. Praesent eleifend tempus ex, vel vestibulum sem aliquet in. Ut fringilla orci eget molestie elementum. Quisque mi ex, semper ut porta at, varius in lacus. Quisque sed quam faucibus, pharetra diam in, pharetra nulla. Fusce in euismod diam. Ut enim odio, posuere eu turpis at, suscipit bibendum elit.

Proin tincidunt imperdiet justo eu consectetur. Cras tempor vel ipsum quis interdum. Nulla tincidunt nibh in lacus euismod, id vestibulum dolor tristique. Ut ipsum orci, rutrum vel porta sed, malesuada id turpis. Morbi eu ullamcorper nibh. Maecenas lectus justo, varius vel ipsum vitae, ultricies commodo neque. Vestibulum tempor nibh vel venenatis maximus. Proin ultrices mauris tincidunt efficitur lacinia. Nullam congue ultricies purus sit amet pretium. Pellentesque sodales bibendum magna, a cursus arcu dignissim ac. Maecenas elementum viverra mi, sed ultrices libero facilisis et. Praesent at posuere nibh. Integer vehicula id nisl aliquam vulputate. Maecenas euismod, leo eget gravida finibus, nulla mauris fringilla neque, ut pulvinar nisl quam ullamcorper lectus. Donec dapibus metus nisi.

Aliquam at magna diam. Nam aliquam euismod ante a interdum. Cras semper erat ut nulla fermentum ullamcorper. Nunc rutrum lorem feugiat urna pharetra rhoncus. Praesent luctus tellus ut libero cursus volutpat. Aenean lobortis urna in lacinia faucibus. Nunc elementum, velit vitae tristique aliquam, dolor purus porta nibh, nec accumsan nisl augue sed metus. Aliquam sit amet sodales urna, a dignissim nisi. Aenean ut placerat felis, ac maximus turpis. Integer sagittis scelerisque turpis, ac vulputate eros interdum ac.
)
        compose_sequences.Add("5lorem", lorem5)
    }
}
