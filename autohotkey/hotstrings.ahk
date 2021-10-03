#SingleInstance

#Hotstring EndChars `;

hs_replace_timeout() {
    return -1000
}

hs_replace(to) {
    from := substr(A_ThisHotKey, 6)
    global hs_replace_from := from . ";"
    global hs_replace_to := to
    sendinput %hs_replace_to%
    hotkey, `;, hs_undo_replace, on
    timeout := hs_replace_timeout()
    settimer, hs_disable_undo_replace, %timeout%
}

hs_undo_replace:
    settimer, hs_disable_undo_replace, off
    hotkey, `;, hs_undo_replace, off
    global hs_replace_from, hs_replace_to
    hslen := strlen(hs_replace_to)
    sendinput {bs %hslen%}%hs_replace_from%
    hotkey, `;, hs_redo_replace, on
    timeout := hs_replace_timeout()
    settimer, hs_disable_redo_replace, %timeout%
return

hs_disable_undo_replace:
    settimer, hs_disable_undo_replace, off
    hotkey, `;, hs_undo_replace, off
return

hs_redo_replace:
    settimer, hs_disable_redo_replace, off
    hotkey, `;, hs_redo_replace, off
    global hs_replace_from, hs_replace_to
    hslen := strlen(hs_replace_from)
    sendinput {bs %hslen%}%hs_replace_to%
    hotkey, `;, hs_undo_replace, on
    timeout := hs_replace_timeout()
    settimer, hs_disable_undo_replace, %timeout%
return

hs_disable_redo_replace:
    settimer, hs_disable_redo_replace, off
    hotkey, `;, hs_redo_replace, off
return

; norwegian letters
:?XC:ae::hs_replace("æ")
:?XC:oe::hs_replace("ø")
:?XC:aa::hs_replace("å")
:?XC:AE::hs_replace("Æ")
:?XC:OE::hs_replace("Ø")
:?XC:AA::hs_replace("Å")

;; umlat äëïöüÄËÏÖÜ
:?XC:" ::hs_replace("̈¨")
; umlaut minuscule
:?XC:"a::hs_replace("ä")
:?XC:"e::hs_replace("ë")
:?XC:"i::hs_replace("ï")
:?XC:"o::hs_replace("ö")
:?XC:"u::hs_replace("ü")
:?XC:"y::hs_replace("ÿ")

; umlaut majuscule
:?XC:"A::hs_replace("Ä")
:?XC:"E::hs_replace("Ë")
:?XC:"I::hs_replace("Ï")
:?XC:"O::hs_replace("Ö")
:?XC:"U::hs_replace("Ü")
:?XC:"Y::hs_replace("Ÿ")

;; grave àèìòùÀÈÌÒÙ
; grave minuscule
:?XC:``a::hs_replace("à")
:?XC:``e::hs_replace("è")
:?XC:``i::hs_replace("ì")
:?XC:``o::hs_replace("ò")
:?XC:``u::hs_replace("ù")
:?XC:``y::hs_replace("ỳ")

; grave majuscule
:?XC:``A::hs_replace("À")
:?XC:``E::hs_replace("È")
:?XC:``I::hs_replace("Ì")
:?XC:``O::hs_replace("Ò")
:?XC:``U::hs_replace("Ù")
:?XC:``Y::hs_replace("Ỳ")

;; acute áćéíĺńóṕŕśúýźÁĆÉÍĹŃÓṔŔŚÚÝŹ
:?XC:' ::hs_replace("´")
; acute minuscule
:?XC:'a::hs_replace("á")
:?XC:'e::hs_replace("é")
:?XC:'i::hs_replace("í")
:?XC:'o::hs_replace("ó")
:?XC:'u::hs_replace("ú")
:?XC:'y::hs_replace("ý")

; acute majuscule
:?XC:'A::hs_replace("Á")
:?XC:'E::hs_replace("É")
:?XC:'I::hs_replace("Í")
:?XC:'O::hs_replace("Ó")
:?XC:'U::hs_replace("Ú")
:?XC:'Y::hs_replace("Ý")

;; circumflex âêĥîĵôŝûÂÊĤÎĴÔŜÛ
; circumflex minuscule
:?XC:^a::hs_replace("â")
:?XC:^e::hs_replace("ê")
:?XC:^i::hs_replace("î")
:?XC:^o::hs_replace("ô")
:?XC:^u::hs_replace("û")
:?XC:^y::hs_replace("ŷ")

; circumflex majuscule
:?XC:^A::hs_replace("Â")
:?XC:^E::hs_replace("Ê")
:?XC:^I::hs_replace("Î")
:?XC:^O::hs_replace("Ô")
:?XC:^U::hs_replace("Û")
:?XC:^Y::hs_replace("Ŷ")

;; cedilla çşģķļņÇŞĢĶĻŅ
:?XC:,c::hs_replace("ç")
:?XC:,C::hs_replace("Ç")

;; tilde ãñõÃÑÕ
:?XC:~a::hs_replace("ã")
:?XC:~A::hs_replace("Ã")
:?XC:~n::hs_replace("ñ")
:?XC:~N::hs_replace("Ñ")
:?XC:~o::hs_replace("õ")
:?XC:~O::hs_replace("Õ")

; ligatures
:?XC:oelig::hs_replace("œ")
:?XC:`ss::hs_replace("ß") ; Eszett

; quotes
:?XC:<<::hs_replace("«")
:?XC:>>::hs_replace("»")
:?XC:> ::hs_replace("›")
:?XC:< ::hs_replace("‹")
:?XC:"<::hs_replace("“") ; upper 66
:?XC:">::hs_replace("”") ; upper 99
:?XC:",::hs_replace("„") ; lower 99
; :?XC:""::hs_replace("‟") ; upper reversed 99
:?XC:'<::hs_replace("‘") ; upper 6
:?XC:'>::hs_replace("’") ; upper 9
:?XC:',::hs_replace("‚") ; lower 9
; :?XC:''::hs_replace("‛") ; upper reversed 9

; special punctuation
:?XC:??::hs_replace("¿")
:?XC:!!::hs_replace("¡")
:?XC:?!::hs_replace("‽")
:?XC:dots::hs_replace("…")

; english ordinals
:?XC:1st::hs_replace("1ˢᵗ")
:?XC:2nd::hs_replace("2ⁿᵈ")
:?XC:3rd::hs_replace("3ʳᵈ")
:?XC:4th::hs_replace("4ᵗʰ")
:?XC:5th::hs_replace("5ᵗʰ")
:?XC:6th::hs_replace("6ᵗʰ")
:?XC:7th::hs_replace("7ᵗʰ")
:?XC:8th::hs_replace("8ᵗʰ")
:?XC:9th::hs_replace("9ᵗʰ")
:?XC:0th::hs_replace("0ᵗʰ")

; typography
:?XC:shy::hs_replace("­")       ; soft hyphen
:?XC:nbsp::hs_replace(" ")      ; no break space
:?XC:hyphen::hs_replace("‐")    ; hyphen
:?XC:mdash::hs_replace("—")     ; em dash
:?XC:ndash::hs_replace("–")     ; en dash
:?XC:figdash::hs_replace("‒")   ; figure dash (digit width)
:?XC:horbar::hs_replace("―")    ; horizontal bar
:?XC:swungdash::hs_replace("⁓") ; swung dash
:?XC:emsp::hs_replace(" ")      ; em space
:?XC:ensp::hs_replace(" ")      ; en dash
:?XC:figsp::hs_replace(" ")     ; figure space (digit width)
:?XC:thinsp::hs_replace(" ")    ; thin space (inside quotation marks)

; other signs
:?XC:numero::hs_replace("№")
:?XC:section::hs_replace("§")
:?XC:paragraph::hs_replace("¶")
:?XC:euro::hs_replace("€")
:?XC:pound::hs_replace("£")
:?XC:cent::hs_replace("¢")
:?XC:yen::hs_replace("¥")
:?XC:lira::hs_replace("₤")
:?XC:copyright::hs_replace("©")
:?XC:registered::hs_replace("®")
:?XC:trademark::hs_replace("™")
:?XC:severdighet::hs_replace("⌘")
:?XC:openbox::hs_replace("␣")

; math
:?XC:degrees::hs_replace("°")
:?XC:infinity::hs_replace("∞")
:?XC:proportional::hs_replace("∝")
:?XC:angle::hs_replace("∡")
:?XC:diameter::hs_replace("⌀")
:?XC:permille::hs_replace("‰")
:?XC:mul::hs_replace("×")
:?XC:div::hs_replace("÷")
:?XC:minus::hs_replace("−")
:?XC:+-::hs_replace("±")
:?XC:-+::hs_replace("∓")
:?XC:sqroot::hs_replace("√")
:?XC:3root::hs_replace("∛")
:?XC:4root::hs_replace("∜")
:?XC:lceil::hs_replace("⌈")
:?XC:rceil::hs_replace("⌉")
:?XC:lfloor::hs_replace("⌊")
:?XC:rfloor::hs_replace("⌋")
:?XC:identical::hs_replace("≡")
:?XC:neq::hs_replace("≠")
:?XC:approx::hs_replace("≈")
:?XC:notApprox::hs_replace("≉")
:?XC:lte::hs_replace("≤")
:?XC:gte::hs_replace("≥")
:?XC:nLte::hs_replace("≰")
:?XC:nGte::hs_replace("≱")
:?XC:muchGt::hs_replace("≪")
:?XC:muchLt::hs_replace("≫")
:?XC:notApprox::hs_replace("≉")
:?XC:<-::hs_replace("←")
:?XC:->::hs_replace("→")
:?XC:lrarrow::hs_replace("↔")
:?XC:<=::hs_replace("⇐")
:?XC:=>::hs_replace("⇒")
:?XC:mdot::hs_replace("·")
:?XC:bullet::hs_replace("•")
:?XC:not::hs_replace("¬")
:?XC:<=::hs_replace("≤")
:?XC:>=::hs_replace("≥")
:?XC:!=::hs_replace("≠")
:?XC:emptyset::hs_replace("∅")
:?XC:complement::hs_replace("∁")
:?XC:forall::hs_replace("∀")
:?XC:exists::hs_replace("∃")
:?XC:notExists::hs_replace("∄")
:?XC:in::hs_replace("∈")
:?XC:notIn::hs_replace("∉")
:?XC:contains::hs_replace("∋")
:?XC:notContains::hs_replace("∌")
:?XC:and::hs_replace("∧")
:?XC:or::hs_replace("∨")
:?XC:intersect::hs_replace("∩")
:?XC:union::hs_replace("∪")
:?XC:subset::hs_replace("⊂")
:?XC:superset::hs_replace("⊃")
:?XC:notSubset::hs_replace("⊄")
:?XC:notSuperset::hs_replace("⊅")
:?XC:subsetEq::hs_replace("⊆")
:?XC:supersetEq::hs_replace("⊇")
:?XC:notSubsetEq::hs_replace("⊈")
:?XC:notSupersetEq::hs_replace("⊉")
:?XC:therefore::hs_replace("∴")
:?XC:because::hs_replace("∵")
:?XC:qed::hs_replace("∎")
:?XC:integral::hs_replace("∫")
:?XC:doubleIntegral::hs_replace("∬")
:?XC:tripleIntegral::hs_replace("∭")
:?XC:contourIntegral::hs_replace("∮")
:?XC:surfaceIntegral::hs_replace("∯")
:?XC:volumeIntegral::hs_replace("∰")
:?XC:partial::hs_replace("∂")
:?XC:increment::hs_replace("∆")
:?XC:del::hs_replace("∇")
:?XC:nabla::hs_replace("∇")
:?XC:prod::hs_replace("∏")
:?XC:coProd::hs_replace("∐")
:?XC:sum::hs_replace("∑")
:?XC:^0::hs_replace("⁰")
:?XC:^1::hs_replace("¹")
:?XC:^2::hs_replace("²")
:?XC:^3::hs_replace("³")
:?XC:^4::hs_replace("⁴")
:?XC:^5::hs_replace("⁵")
:?XC:^6::hs_replace("⁶")
:?XC:^7::hs_replace("⁷")
:?XC:^8::hs_replace("⁸")
:?XC:^9::hs_replace("⁹")
:?XC:_0::hs_replace("₀")
:?XC:_1::hs_replace("₁")
:?XC:_2::hs_replace("₂")
:?XC:_3::hs_replace("₃")
:?XC:_4::hs_replace("₄")
:?XC:_5::hs_replace("₅")
:?XC:_6::hs_replace("₆")
:?XC:_7::hs_replace("₇")
:?XC:_8::hs_replace("₈")
:?XC:_9::hs_replace("₉")

; greek
:?XC:alpha::hs_replace("α")
:?XC:Alpha::hs_replace("Α")
:?XC:beta::hs_replace("β")
:?XC:Beta::hs_replace("Β")
:?XC:gamma::hs_replace("γ")
:?XC:Gamma::hs_replace("Γ")
:?XC:delta::hs_replace("δ")
:?XC:Delta::hs_replace("Δ")
:?XC:epsilon::hs_replace("ε")
:?XC:Epsilon::hs_replace("Ε")
:?XC:zeta::hs_replace("ζ")
:?XC:Zeta::hs_replace("Ζ")
:?XC:eta::hs_replace("η")
:?XC:Eta::hs_replace("Η")
:?XC:theta::hs_replace("θ")
:?XC:Theta::hs_replace("Θ")
:?XC:iota::hs_replace("ι")
:?XC:Iota::hs_replace("Ι")
:?XC:kappa::hs_replace("κ")
:?XC:Kappa::hs_replace("Κ")
:?XC:lambda::hs_replace("λ")
:?XC:Lambda::hs_replace("Λ")
:?XC:mu::hs_replace("μ")
:?XC:Mu::hs_replace("Μ")
:?XC:nu::hs_replace("ν")
:?XC:Nu::hs_replace("Ν")
:?XC:xi::hs_replace("ξ")
:?XC:Xi::hs_replace("Ξ")
:?XC:omicron::hs_replace("ο")
:?XC:Omicron::hs_replace("Ο")
:?XC:pi::hs_replace("π")
:?XC:Pi::hs_replace("Π")
:?XC:sigma::hs_replace("σ")
:?XC:Sigma::hs_replace("Σ")
:?XC:tau::hs_replace("τ")
:?XC:Tau::hs_replace("Τ")
:?XC:upsilon::hs_replace("υ")
:?XC:Upsilon::hs_replace("Υ")
:?XC:phi::hs_replace("φ")
:?XC:Phi::hs_replace("Φ")
:?XC:chi::hs_replace("χ")
:?XC:Chi::hs_replace("Χ")
:?XC:psi::hs_replace("ψ")
:?XC:Psi::hs_replace("Ψ")
:?XC:omega::hs_replace("ω")
:?XC:Omega::hs_replace("Ω")

; current date
hs_date() {
    hs_replace(A_YYYY . "-" . A_MM . "-" . A_DD)
}
:?XC:date::hs_date()
