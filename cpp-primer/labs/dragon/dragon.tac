vtable (_Main) { Main:
    main;
}

function (main) {
main:
    _T4 := 233
    _T1 := _T4
    _T5 := 0
    _T2 := _T5
    _T6 := LOAD Hello, DragonLang!
    _T3 := _T6
    parm _T1
    call _PrintInt
    parm _T2
    call _PrintBool
    parm _T3
    call _PrintString
    _T7 := LOAD Please input a number:
    parm _T7
    call _PrintString
    _T8 :=  call _ReadInteger
    _T1 := _T8
    _T9 := 1
    _T2 := _T9
    _T10 := LOAD Please input a string:
    parm _T10
    call _PrintString
    _T11 :=  call _ReadLine
    _T3 := _T11
    parm _T1
    call _PrintInt
    parm _T2
    call _PrintBool
    parm _T3
    call _PrintString
}

