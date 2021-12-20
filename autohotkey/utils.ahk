log_xor(a, b) {
    if (a)
        return !b
    else
        return b
}

small_big(small, big) {
    if log_xor(GetkeyState("Shift", "P") , GetKeyState("CapsLock", "T"))
        return big
    else
        return small
}

correct_case_of(letter) {
    letter := RegExReplace(letter, "\+(.)", "$1")
    if (log_xor(GetKeyState("Shift", "P"), GetKeyState("CapsLock", "T"))) {
        StringUpper, letter, letter
    } else {
        StringLower, letter, letter
    }
    return letter
}
