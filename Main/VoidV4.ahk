#Requires AutoHotkey v2.0

ih := InputHook("V")
ih.KeyOpt("{All}","N")

ih.OnKeyDown := KeyDown
ih.OnKeyUp := KeyUp
global finished:=[]
global down:=Map()
KeyDown(hook,VK,SC){
    key := GetKeyName(Format("vk{:x}sc{:x}", VK, SC))
    down[key]:=A_TickCount
}
KeyUp(hook,VK,SC){
    key := GetKeyName(Format("vk{:x}sc{:x}", VK, SC))
    finished.Push([key,A_TickCount-down[key]])
    ;MsgBox key,A_TickCount-down[key]
}

ih.Start()
F1::Reload
F2::{
    ih.Stop()
    strings:=""
    for input in finished{
        strings .= "0%" input[1] input[2] "&"
    }
    MsgBox SubStr(strings,1,StrLen(strings))
}
/*
    global pressStartTime:=0
    ~d::
    {
        global  pressStartTime
        if A_TickCount-pressStartTime>5000{
            pressStartTime := A_TickCount  ; Capture the time when the key is pressed
        }
        return
    }

    ; Detect when the "a" key is released
    ~d up::
    {
        global pressStartTime
        pressDuration := A_TickCount - pressStartTime  ; Calculate the duration
        MsgBox "You held the 'a' key for " pressDuration " milliseconds."
        A_Clipboard := pressDuration
        pressStartTime:=0
        return
    }
*/