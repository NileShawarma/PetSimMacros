#Requires AutoHotkey v2.0
#Include %A_MyDocuments%\PS99_Macros\MyOwnFiles\MyOwnModules\Useful_Funcs.ahk
basicPath := A_MyDocuments . "\PS99_Macros"
RobloxInst:=[WinGetList("ahk_exe RobloxPlayerBeta.exe"),WinGetList("Roblox","Roblox")]
global NumberValueMap := Map(
    "TpWaitTime", 7000,
    "ClickNumber", 4,
    "ClickDelay", 250,
    "LoopDownTime", 0,
    "ColorBuyMaxTime", 5000,
)
stuffToGet := Map(
    "\MyOwnFiles\Design.png", {type: "image", link: "https://raw.githubusercontent.com/NileShawarma/PetSimMacros/main/Design.png"}
)

for item, desc in stuffToGet {
    itemType := desc.type
    fullPath := basicPath . item
    FileDelete(fullPath)

    if itemType = "image" {      
        Download(desc.link,fullPath)
    }
}

Funcs:=["Teleport","World","WaitPreset","Wait","RawInput","ScreenClick","SearchUntilFound","SearchUntilNotFound"]
; Create a GUI window
TestGui := Gui()
TestGui.AddTab3(,["Page 1"]).Move(,,375,475)
TestGui.Show("w400 h500")

ddl1 := TestGui.Add("DropDownList", "vOptionChoiceMain1 x100 y100 w100", Funcs)
ddl1.OnEvent("Change", (*) => UpdateNext("OptionChoiceMain1",1))

path2 := TestGui.Add("DropDownList", "vOptionChoicePath1 x200 y100 w75 h10 r5.5")

addMore := TestGui.Add("Button","vAddMore x275 y100 w20 h20", "+")
addMore.OnEvent("Click", (*) => Adds("AddMore"))
Sumbit :=TestGui.Add("Button", "vSumbit x275 y130 h20", "Submit")
Sumbit.OnEvent("Click", (*)=> CalcString())
controls:=[
    [[ddl1,1],[path2,1]]
]
global controlsReplaced := 0
global godString:=""
global NumRows:=1
global RawUISCreated := 0
CreateRAWUI(a,b){
    global RawUISCreated
    RawUISCreated += 1
    AddRow(*){
        global NumRows

        if NumRows=7{
            SubmitRow.Move(,95+(NumRows-1)*45)
            addRows.Visible := false
            return
        }

        RAWSetUpGUI.AddText("x30 y" 80+NumRows*45 " w80","Key Press " NumRows+1).SetFont("bold")

        RAWSetUpGUI.AddEdit("vRawUI" RawUISCreated "Row" NumRows+1 "Delay w70 x40 y" 95+NumRows*45 " number")
        RAWSetUpGUI.AddUpDown("range0-10000000")
    
        RAWSetUpGUI.AddEdit("vRawUI" RawUISCreated "Row" NumRows+1 "Key w65 x115 y" 95+NumRows*45,"None")
    
        RAWSetUpGUI.AddEdit("vRawUI" RawUISCreated "Row" NumRows+1 "Duration w70 x180 y" 95+NumRows*45 " number")
        RAWSetUpGUI.AddUpDown("range0-10000000")

        addRows.Move(,95+NumRows*45,,)
        SubmitRow.Move(,115+NumRows*45)
        NumRows +=1
    }
    SubmitRows(*){
        superstring :=""
        Loop NumRows {
            delay:=RAWSetUpGUI["RawUI" RawUISCreated "Row" A_Index "Delay"].Text
            key:=SubStr(RAWSetUpGUI["RawUI" RawUISCreated "Row" A_Index "Key"].Text,1,1)
            duration:=RAWSetUpGUI["RawUI" RawUISCreated "Row" A_Index "Duration"].Text
            superstring := superstring delay "%" key duration "&"
        }
        superstring := SubStr(superstring,1,StrLen(superstring)-1)
        TestGui.Restore()
        controls[b][2][1].Text := superstring
        RAWSetUpGUI.Hide()
    }
    RAWSetUpGUI := Gui()
    TestGui.Hide()
    
    RAWSetUpGUI.Show("w350 h450")
    RAWSetUpGUI.AddTab3(,["KeyPresses"]).Move(,,325,425)

    RAWSetUpGUI.AddText("x15 y30 h24 w300", "Custom keys presses").SetFont("s12 bold")

    RAWSetUpGUI.AddText("x30 y60 w80","Key Press 1").SetFont("bold")

    RAWSetUpGUI.AddText("x40 y80","Delay").SetFont("s9")
    RAWSetUpGUI.AddText("x115 y80","Key").SetFont("s9")
    RAWSetUpGUI.AddText("x180 y80","Duration").SetFont("s9")

    RAWSetUpGUI.AddEdit("vRawUI" RawUISCreated "Row" NumRows "Delay w70 x40 y95 number")
    RAWSetUpGUI.AddUpDown("range0-10000000")

    RAWSetUpGUI.AddEdit("vRawUI" RawUISCreated "Row" NumRows "Key w65 x115 y95","None")

    RAWSetUpGUI.AddEdit("vRawUI" RawUISCreated "Row" NumRows "Duration w70 x180 y95 number")
    RAWSetUpGUI.AddUpDown("range0-10000000")

    addRows := RAWSetUpGUI.Add("Button","vRawUI" RawUISCreated "AddMoreRows x260 y95 w20 h20", "+")
    addRows.OnEvent("Click",AddRow)

    SubmitRow := RAWSetUpGUI.Add("Button","vRawUI" RawUISCreated "SubmitRows x260 y115 w50 h20", "Submit")
    SubmitRow.OnEvent("Click",SubmitRows)

    RAWSetUpGUI.OnEvent("Close", (*) => TestGui.Restore())
}
CalcString(){ 
    global godString
    for pair in controls{
        for control in pair{
            if control[1].Text="Teleport"{
                godString := godString . "Tp:" . pair[2][1].Text . "|"
            } else if control[1].Text = "World"{
                godString := godString . "w:" . pair[2][1].Text . "|"
            } else if control[1].Text="Wait"{
                godString := godString . "wt:" . pair[2][1].Text . "|"
            } else if control[1].Text="WaitPreset"{
                godString := godString . "w_nV:" . pair[2][1].Text . "|"
            } else if control[1].Text="RawInput"{
                godString := godString . "r:[" . pair[2][1].Text . "]|"
            } else if control[1].Text="ScreenClick"{
                godString := godString . "sc:[" . pair[2][1].Text . "]|"
            } else if control[1].Text="SearchUntilFound"{
                godString := godString . "spl:" . pair[2][1].Text . "|"
            } else if control[1].Text="SearchUntilNotFound"{
                godString := godString . "aspl:" . pair[2][1].Text . "|"
            }
            break
        }
    }
    godString := SubStr(godString,1,StrLen(godString)-1)
    MsgBox godString
    A_Clipboard := godString
}
Adds(control){
    numControls:=controls.Length

    if numControls=12{
        TestGui["AddMore"].Text:="New Page"
        TestGui["Addmore"].Move(,,70,)
        return
    }
    selectedControl:=TestGui[control]
    selectedControl.GetPos(,&posY,,)
    selectedControl.Move(,posY+30,,)
    TestGui["Sumbit"].Move(,posY+60,,)

    cont:=TestGui.Add("DDL","vOptionChoiceMain" numControls+1 " x100 y" 100+30*(numControls) " w100",Funcs)
    TestGui.Add("DDL","vOptionChoicePath" numControls+1 " x200 y" 100+30*(numControls) " w75 r5.5",[])
    ;MsgBox "OptionChoicePath" numControls+1
    Sleep 500
    controls.Push([[TestGui["OptionChoiceMain" numControls+1],numControls+1],[TestGui["OptionChoicePath" numControls+1],numControls+1]])
    ;MsgBox controls.Length
    c:="OptionChoicePath" . controls.Length
    cont.OnEvent("Change", (*) => UpdateNext("OptionChoiceMain" numControls+1,numControls+1))
    ;MsgBox c
    ;control[controls.Length].Move(175,posY+30,,)
}
changeToInput(control,pos){
    global controlsReplaced
    controlsReplaced:=controlsReplaced+1
    selectedControl:=TestGui[control]
    local x,y,w,h
    selectedControl.GetPos(&x,&y,&w,&h)
    selectedControl.Visible := false

    newPath := TestGui.Add("Edit","vOptionChoiceReplacePath" controlsReplaced " x" x " y" y " w" w " h" h )
    controls[pos][2][1] := newPath
    return newPath
}
ChangeToDDL(control,pos){
    global controlsReplaced
    controlsReplaced:=controlsReplaced+1
    selectedControl:=TestGui[control]
    local x,y,w,h
    selectedControl.GetPos(&x,&y,&w,&h)
    selectedControl.Visible := false

    newPath := TestGui.Add("DDL","vOptionChoiceReplacePath" controlsReplaced " x" x " y" y " w" w " h" h )
    controls[pos][2][1] := newPath
    return newPath
}
UpdateNext(control,num){
    selectedControl:=TestGui[control]
    selectedChoicePath:=controls[num][2][1]
    selectedText := selectedControl.Text
    ;MsgBox(selectedText)
    if (selectedChoicePath.Type="DDL") { 
        selectedChoicePath.Delete() 
    }
          ; Clear current items

    if (selectedText = "Teleport") {
        changeToInput("OptionChoicePath" num,num)
    } else if (selectedText = "WaitPreset") {
        newControl:=ChangeToDDL("OptionChoicePath" num,num)
        tempArray :=[]
        for key,val in NumberValueMap{
            tempArray.Push(key)
        }
        newControl.Add(tempArray)
    } else if (selectedText = "Wait"){
        changeToInput("OptionChoicePath" num,num)
    } else if (selectedText = "ScreenClick"){
        changeToInput("OptionChoicePath" num,num)
    } else if (selectedText = "SearchUntilFound"){
        changeToInput("OptionChoicePath" num,num)
    } else if (selectedText = "SearchUntilNotFound"){
        changeToInput("OptionChoicePath" num,num)
    } else if (selectedText = "RawInput"){
        changeToInput("OptionChoicePath" num,num)
        Sleep 100
        CreateRAWUI("OptionChoicePath" num,num)
    }
}

F3::{
    loop{
        WinMove(,,816,638,"ahk_id " RobloxInst[1][1])
        Sleep 100
    }
}

F6::Pause -1
F7::Reload
F8::ExitApp
