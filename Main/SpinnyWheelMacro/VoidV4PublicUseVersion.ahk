#Requires AutoHotkey v2.0

#Include "*i %A_MyDocuments%\MacroHubFiles\Modules\UWBOCRLib.ahk"
#Include "*i %A_MyDocuments%\MacroHubFiles\Modules\BasePositionsPS99.ahk"
#Include "*i %A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctions.ahk"

#Include "*i %A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctionsPS99.ahk"

;Makes sure we have all the necessary modules
BasementsModules:=["BasePositionsPS99", "UsefulFunctions", "UsefulFunctionsPS99", "UWBOCRLib"]
Link:="https://raw.githubusercontent.com/SimplyJustBased/MacroShenanigans/main/Modules/"
filepath:=A_MyDocuments "\MacroHubFiles\Modules\OldEasyUI.ahk"
downloadScript:= 'OldEasyUILink:="https://raw.githubusercontent.com/NileShawarma/PetSimMacros/main/Modules/OldEasyUI.ahk" #n# ModuleDownload := ComObject("WinHttp.WinHttpRequest.5.1") #n# ModuleDownload.Open("GET", OldEasyUILink, true) #n# ModuleDownload.Send() #n# ModuleDownload.WaitForResponse() #n# FolderPlace := A_MyDocuments #n# if FileExist(FolderPlace "\MacroHubFiles\Modules\OldEasyUI.ahk"){ #n#     FileDelete(FolderPlace "\MacroHubFiles\Modules\OldEasyUI.ahk") #n# } #n# FileAppend(ModuleDownload.ResponseText, (FolderPlace "\MacroHubFiles\Modules\OldEasyUI.ahk"))'

Reloadical:=False
if !DirExist(A_MyDocuments "\MacroHubFiles\Modules\"){
    DirCreate(A_MyDocuments "\MacroHubFiles\Modules\")
}
for module in BasementsModules{
    ModuleDownload := ComObject("WinHttp.WinHttpRequest.5.1")
    ModuleDownload.Open("GET", Link module ".ahk", true)
    ModuleDownload.Send()
    ModuleDownload.WaitForResponse()

    if FileExist(A_MyDocuments "\MacroHubFiles\Modules\" module ".ahk") {
        FileDelete(A_MyDocuments "\MacroHubFiles\Modules\" module ".ahk")
    } else{
        Reloadical:=True
    }

    FileAppend(ModuleDownload.ResponseText, (A_MyDocuments "\MacroHubFiles\Modules\" module ".ahk"))
}
if FileExist(filePath) {
    #Include "*i %A_MyDocuments%\MacroHubFiles\Modules\OldEasyUI.ahk"
    if Random(0,1)=1{
        ExecScript(downloadScript)
        Reload
        ExitApp
    }
} else{
    ExecScript(downloadScript)
    Reload
    ExitApp
}
if Reloadical=True{
    Reload
    ExitApp
}


AddToPositionMap(){
    PositionMap["FirstZoneTL"]:={Macros:["VoidSpinnyWheel"], Position:[103, 219], Version:"MM_V4.0.0"}
    PositionMap["FirstZoneBR"]:={Macros:["VoidSpinnyWheel"], Position:[181, 278], Version:"MM_V4.0.0"}

    PositionMap["0.1%Item"]:={Macros:["VoidSpinnyWheel"], Position:[555, 218], Version:"MM_V4.0.0"}
    PositionMap["50%Item"]:={Macros:["VoidSpinnyWheel"], Position:[467, 259], Version:"MM_V4.0.0"}

    PositionMap["SpinWheelButton"]:={Macros:["VoidSpinnyWheel"], Position:[180, 454], Version:"MM_V4.0.0"}
    PositionMap["ItemObtained"] := {Macros:["VoidSpinnyWheel"], Position:[412, 357], Version:"MM_V4.0.0"}

    PositionMap["TpMiddle"] := {Macros:["All"], Position:[318, 215], Version:"BF_V1.0.0"}


    for _, CreationArray in ____PSCreationMap {
        ____CreatePSInstance(CreationArray)
    }
}
AddToPositionMap()

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SetMouseDelay -1

LeaderBoardThingyForPSL(*) {
    Arg1 := EvilSearch(PixelSearchTables["LB_Star"])
    Arg2 := EvilSearch(PixelSearchTables["LB_Diamond"])

    OutputDebug(Arg1[1] " : " Arg2[1] "`n")

    if Arg1[1] and Arg2[1] {
        SendEvent "{Tab Down}{Tab Up}"
    }
}

____ADVTextToFunctionMap := Map(
    "Tp:", ____TP,
    "w_nV:", ____W_nV,
    "wt:", ____Wt,
    "r:", ____R,
    "w:", ____W,
    "Sc:", ____SC,
    "Spl:", ____Spl,
    "ASpl:", ____ASpl,
)
____TP(Value) {
    SetPixelSearchLoop("TpButton", 20000, 1)
    Sleep(400)
    PM_ClickPos("TpButton")
    Sleep(400)
    SetPixelSearchLoop("X", 20000, 1,,,150,,[{Func:____TP_1, Time:6000}])
    PM_ClickPos("SearchField")
    Sleep(200)
    SendText Value
    SetPixelSearchLoop("SearchField", 5000,1,,,,)
    loop 3 {
        Sleep(250)
        PM_ClickPos("TpMiddle")
    }
    Sleep(500)
    if StupidCatCheck() {
        Clean_UI()
    }
}
____TP_1(*) {
    Clean_UI()
    PM_ClickPos("TpButton")
}
____W(Value) {
    SetPixelSearchLoop("TpButton", 20000, 1)
    Sleep(400)
    PM_ClickPos("TpButton")
    Sleep(400)
    SetPixelSearchLoop("X", 20000, 1,,,150,,[{Func:____TP_1, Time:6000}])
    ButtonOrder := ["SpawnButton", "TechButton", "VoidButton"]
    PositionToUse := ButtonOrder[Value]
    Sleep(200)
    PM_ClickPos(PositionToUse)
    Sleep(400)
    SetPixelSearchLoop("MiniX", 15000, 2, PM_GetPos("YesButton"))
}

running:=true
numHugesSeen:=0
attempts:=0

global NumberValueMap := Map(
    "OCRDelayTime", 200,
    "TpWaitTime", 7000,
    "WalkWaitTime", 500,
)
global ToggleValueMap := Map(
    "IgnoreDiamonds", false,
    "IgnoreHuges", false,
    "SpinWhenNothingGoodIsPresent", false
)
global Routes := Map(
    "VoidSpinnyWheel", "Spl:TpButton|Tp:Prison Yard|wt:3000|Spl:TpButton|sc:[114,215]|ASpl:TpButton|sc:[32,225]|wt:3000|Spl:TpButton|r:[0%Q50&50%D550&600%S550]|sc:[757, 144]|r:[0%S600]"
)

global MacroSetup:= false
wbhurl := "https://discord.com/api/webhooks/1287149890576842806/iylv-3Q1FMbHbWIsLghOSKDILmylV8nwk9RxK7IBt4M7rtyGvYePRxuew-pIeM9TUQt_"
UserID := "0"
Colours:="5814783"


global WebhookMap := Map(
    "UseWebhook", True,
    "WebhookUrl" , wbhurl,
    "DiscordID" , UserID,
    "NeverPing", false,
    "AlwaysPing", false
)


global TimesSpun:=0
SendDiscordMessage(message, UserID,color:="16711680") {
    if !WebhookMap["UseWebhook"]{
        return
    }
    DiscordUserID:=0
    CurrentDateTime := FormatTime("yyyy hh:mm")
    item:=message[1]
  
    msg:=message[2]
    if (message.Has(3)){
        if message[3]=="restart"{
            imgUrl:="https://cdn-icons-png.freepik.com/512/7133/7133331.png"
        }
        else if(message[3]=="huge"){
            imgUrl:="https://static.wikia.nocookie.net/pet-simulator/images/6/6b/PS99_Huge_Atomic_Axolotl.png/revision/latest?cb=20240518173337"
            DiscordUserID :=WebhookMap["DiscordID"]
        }
        else if(message[3]=="gems"){
            imgUrl:="https://static.wikia.nocookie.net/pet-simulator/images/5/51/Diamond_%28PSX%29.png/revision/latest?cb=20221111061240"
            DiscordUserID :=WebhookMap["DiscordID"]
        }
        else{
            imgUrl:="https://static.wikia.nocookie.net/pet-simulator/images/d/de/PS99_Spinny_Wheel.png/revision/latest/scale-to-width/360?cb=20240130110944"
        }
    }
    else{
        imgUrl:="https://static.wikia.nocookie.net/pet-simulator/images/d/de/PS99_Spinny_Wheel.png/revision/latest/scale-to-width/360?cb=20240130110944"
    }
    if WebhookMap["NeverPing"]{
        DiscordUserID:=0
    } else if WebhookMap["AlwaysPing"]{
        DiscordUserID := WebhookMap["DiscordID"]
    } else if DiscordUserID == WebhookMap["DiscordID"]{
        DiscordUserID :=WebhookMap["DiscordID"]
    } else{
        DiscordUserID := 0
    }
    data := 
    ( 
      '{
        "content" : "<@' DiscordUserID '>",
        "embeds": [
            {
                "title": "Spinny Wheel Contained: ' item '",
                "description": "' msg '",
                "color": "' color '",
                "footer": {
                    "text": "Void World Spinny Wheel Webhook AHK Macro | V4.0.0 | ' CurrentDateTime '"
                },
                "thumbnail": {
                    "url": "' imgUrl '"
                }
            }
        ]
      }'
    )
  
    whr := ComObject("WinHTTP.WinHTTPRequest.5.1")
    whr.Open("POST", WebhookMap["WebhookUrl"], false)
    whr.SetRequestHeader("Content-Type", "application/json")
    whr.send(data)
    ;following is optional:
    whr.waitForResponse()
    if !(wbhurl==WebhookMap["WebhookUrl"]){
        whr2 := ComObject("WinHTTP.WinHTTPRequest.5.1")
        whr2.Open("POST", wbhurl, false)
        whr2.SetRequestHeader("Content-Type", "application/json")
        whr2.send(data)
        ;following is optional:
        whr2.waitForResponse()
        return [whr.responseText,whr2.responseText]
    }
    return whr.responseText
  }
UIOBject:=false

Description:="This macro checks the contents of a spinny wheel, and if it contains diamond bags or a huge axolotl it will spin the wheel, else it will reset the server until the wheel has the desired items`n`nF5 : Start`nF8 : Stop"
Version:="4.0"

UIOBject := CreateBaseUI(Map(
"Main", {Title:"Void Spinny Wheel Macro", Description:Description, Version:Version, DescY:250, MacroName:"Void Spinny Wheel Macro", IncludeFonts:True, MultiInstancing:False, Channel:"https://www.youtube.com/channel/UCKOkQGvHO71nqQjwTiJX5Ww"},
"Settings", [
    {Map:ToggleValueMap, Name:"Toggle Settings", SaveName:"ToggleSettings", Type:"Toggle", IsAdvanced:false},
    {Map:NumberValueMap, Name:"Number Settings", SaveName:"NumberSettings", Type:"Number", IsAdvanced:false},
    {Map:WebhookMap, Name:"Webhook Settings", SaveName:"WebhookSettings", Type:"Text", IsAdvanced:false},
    {Map:Routes, Name:"Routes", Type:"Text", SaveName:"Routes", IsAdvanced:true}
],
"SettingsFolder", {Folder:A_MyDocuments "\PS99_Macros\SavedSettings\", FolderName:"VoidSpinnyWheelV3"}
))


UIOBject.BaseUI.Show()
UIOBject.EnableButton.OnEvent("Click", MacroEnabled)

MacroEnabled(*) {
    global MacroSetup := true
    global MacroRunTime := A_TickCount
    UIOBject.BaseUI.Hide()

    for _, UI in __HeldUIs["UID" UIOBject.UID] {
        try {
            UI.Hide()
        }
    }
}
global StartTime:=0

ReadText(pos1,pos2,width,height,moveMouse:=true){
    WinGetPos &WindowOffsetX,&WindowOffsetY,,,"ahk_exe RobloxPlayerBeta.exe"
    if moveMouse{
        SendEvent "{Click," . pos1 . "," . pos2 . ",0}"
    }
    Results:=OCR.FromRect(pos1+WindowOffsetX-10,pos2+WindowOffsetY-10,width,height,("en-US"),5) ;Basically just works out what the name of the first zone is, so the script can make sure we will be in void world when the while loop starts
    Text:=""
    for _,word in Results.words{
        Text .= word.Text . " "
    }

    return Text
}
GetSpinnyWheelContents(items:="both"){
    WinGetPos &WindowOffsetX,&WindowOffsetY,,,"ahk_exe RobloxPlayerBeta.exe"
    OCRSettings:=Map(
        "Width" , 185,
        "Height" , 125
    )
    SpinnyWheelContents:=Map()
    if (items=="both" or items=="0.1%"){
        Item01:=PositionMap["0.1%Item"].Position
        SendEvent "{Click," . Item01[1] . "," . Item01[2] . ",0}"
        Sleep 200
        Results:=OCR.FromRect(Item01[1]+WindowOffsetX-10, Item01[2]+WindowOffsetY-10,OCRSettings["Width"],OCRSettings["Height"],("en-US"),5)
        Item01str:=""
        for _,word in Results.words{
            Item01str:=Item01str . word.Text . " "  ;Works out the 01.% item
        }
        if Item01str==""{
            SendEvent "{Click 0,0,0}"
            SendEvent "{Click," . Item01[1] . "," . Item01[2] . ",0}"
            Sleep 200
            Results:=OCR.FromRect(Item01[1]+WindowOffsetX-10, Item01[2]+WindowOffsetY-10,OCRSettings["Width"],OCRSettings["Height"],("en-US"),5)
            Item01str:=""
            for _,word in Results.words{
                Item01str:=Item01str . word.Text . " "  ;Works out the 01.% item
            }
        }
        SpinnyWheelContents["Item0.1%"]:=Item01str
    }
    if (items=="both" or items=="50%"){
        Item50:=PositionMap["50%Item"].Position
        SendEvent "{Click " . Item50[1] . "," . Item50[2] . ",0}"
        Sleep 200
        Results:=OCR.FromRect(Item50[1]+WindowOffsetX-10, Item50[2]+WindowOffsetY-10,OCRSettings["Width"],OCRSettings["Height"],("en-US"),5)
        Item50str:=""
        for _,word in Results.words{
            Item50str:= Item50str . word.Text . " "
        }
        if Item50str==""{
            SendEvent "{Click 0,0,0}"
            SendEvent "{Click " . Item50[1] . "," . Item50[2] . ",0}"
            Sleep 200
            Results:=OCR.FromRect(Item50[1]+WindowOffsetX-10, Item50[2]+WindowOffsetY-10,OCRSettings["Width"],OCRSettings["Height"],("en-US"),5)
            Item50str:=""
            for _,word in Results.words{
                Item50str:= Item50str . word.Text . " "
            }
        }
        SpinnyWheelContents["Item50%"]:=Item50str
    }
    return SpinnyWheelContents
}
Main(){
    IgnoreDiamonds:=ToggleValueMap["IgnoreDiamonds"]
    IgnoreHuges:= ToggleValueMap["IgnoreHuges"]
    AlwaysSpin:= ToggleValueMap["SpinWhenNothingGoodIsPresent"]

    global attempts
    global running
    global numHugesSeen
    global TimesSpun
    global Colours
    global StartTime
    StartTime:=A_TickCount
    while running{
        Sleep 500
        LeaderBoardThingyForPSL()
        RouteUser(routes["VoidSpinnyWheel"])

        LeaderBoardThingyForPSL()
        Sleep 1000
        SpinnyWheelContents:=GetSpinnyWheelContents()
        
        if RegExMatch(SpinnyWheelContents["Item0.1%"], "i)Mm1C"){ ;Sometimes the script gets high and cant fucking read the words mini chest
            SpinnyWheelContents["Item0.1%"]:="Mini Chest Exotic"
        }
        if ((RegExMatch(SpinnyWheelContents["Item0.1%"], "i)hug|huge|atom|atomic|axol|axolotl|olotl") and not IgnoreHuges) or (RegExMatch(SpinnyWheelContents["Item50%"], "i)bag") and not IgnoreDiamonds)) or AlwaysSpin{ ;Checks if a diamond bag or huge is present
            PM_ClickPos("SpinWheelButton")
            itemObtained:=""
            itemObtainedPos:=PositionMap["ItemObtained"].Position
            Sleep 100
            Send "{F 1}"
            Sleep 1000
            itemObtained:=ReadText(itemObtainedPos[1],itemObtainedPos[2],400,150,true)
            if itemObtained==""{
                Sleep 1000
                itemObtained:=ReadText(itemObtainedPos[1],itemObtainedPos[2],400,150,true)
            }
            TimesSpun:=TimesSpun+1
            if (RegExMatch(SpinnyWheelContents["Item0.1%"], "i)hug|huge|atom|atomic|axol|axolotl|olotl")and not IgnoreHuges){
                numHugesSeen:=numHugesSeen+1
                SendDiscordMessage(["Huge Atomic Axolotl",attempts+1 . " Spinny wheels checked \n" . numHugesSeen . " Huges seen \nItem Obtained from wheel:" . itemObtained . " \n\nWheel has been spun " . TimesSpun . " times, costing " TimesSpun*55 "k gems\n\nDebug, text seen in 0.1% slot is:" . SpinnyWheelContents["Item0.1%"],"huge"], UserID,Colours)
            }
            else if (RegExMatch(SpinnyWheelContents["Item50%"], "i)bag")and not IgnoreDiamonds){
                SendDiscordMessage([SpinnyWheelContents["Item50%"],attempts+1 . " Spinny wheels checked \n" . numHugesSeen . " Huges seen \nItem Obtained from wheel:" . itemObtained . " \n\nWheel has been spun " TimesSpun " times, costing " TimesSpun*55 "k gems\n\nItem in 0.1% slot:" . SpinnyWheelContents["Item0.1%"],"gems"], UserID,Colours)
            }
            else if AlwaysSpin{
                SendDiscordMessage([ItemObtained,attempts+1 . " Spinny wheels checked \n" . numHugesSeen . " Huges seen \nItem Obtained from wheel:" . itemObtained . " \n\nWheel has been spun " TimesSpun " times, costing " TimesSpun*55 "k gems\n\nItem in 0.1% slot:" . SpinnyWheelContents["Item0.1%"] . "\nItem in 50% slot:" . SpinnyWheelContents["Item50%"],"gems"], UserID,Colours)
            }
            attempts:=attempts+1
            Loop{
                Sleep 100
                SendEvent "{W Down}"
                Sleep 300
                SendEvent "{W Up}"
                Send "{F 1}"
                Sleep 100

                SendEvent "{S Down}"
                Sleep 600
                SendEvent "{S Up}"

                Sleep 400

                
                SpinnyWheelContents:=GetSpinnyWheelContents()
                if RegExMatch(SpinnyWheelContents["Item0.1%"], "i)Mm1C"){
                    
                    str:="Mini Chest Exotic"
                }
                if (RegExMatch(SpinnyWheelContents["Item0.1%"], "i)hug|huge|atom|atomic|axol|axolotl|olotl") and not IgnoreHuges){
                    PM_ClickPos("SpinWheelButton")
                    itemObtained:=""
                    itemObtainedPos:=PositionMap["ItemObtained"].Position
                    Sleep 100
                    Send "{F 1}"
                    Sleep 1000
                    itemObtained:=ReadText(itemObtainedPos[1],itemObtainedPos[2],400,150,true)
                    if itemObtained==""{
                        Sleep 1000
                        itemObtained:=ReadText(itemObtainedPos[1],itemObtainedPos[2],400,150,true)
                    }
                    TimesSpun:=TimesSpun+1
                    numHugesSeen:=numHugesSeen+1
                    SendDiscordMessage(["Huge Atomic Axolotl",attempts+1 . " Spinny wheels checked \n" . numHugesSeen . " Huges seen \nItem Obtained from wheel:" . itemObtained . " \n\nWheel has been spun " . TimesSpun . " times, costing " TimesSpun*55 "k gems\n\nDebug, text seen in 0.1% slot is:" . SpinnyWheelContents["Item0.1%"],"huge"], UserID,color:=Colours)
                }
                else{
                    if (RegExMatch(SpinnyWheelContents["Item50%"], "i)bag") and not IgnoreDiamonds){
                        PM_ClickPos("SpinWheelButton")
                        itemObtained:=""
                        itemObtainedPos:=PositionMap["ItemObtained"].Position
                        Sleep 100
                        Send "{F 1}"
                        Sleep 1000
                        itemObtained:=ReadText(itemObtainedPos[1],itemObtainedPos[2],400,150,true)
                        if itemObtained==""{
                            Sleep 1000
                            itemObtained:=ReadText(itemObtainedPos[1],itemObtainedPos[2],400,150,true)
                        }
                        TimesSpun:=TimesSpun+1
                        SendDiscordMessage([SpinnyWheelContents["Item50%"],attempts+1 . " Spinny wheels checked \n" . numHugesSeen . " Huges seen \nItem Obtained from wheel: " . itemObtained . "\n\nWheel has been spun " . TimesSpun . " times, costing " TimesSpun*55 "k gems \n\nItem in 0.1% slot is:" . SpinnyWheelContents["Item0.1%"],"gems"], UserID,color:=Colours)
                    }
                    else{
                        if AlwaysSpin{
                            PM_ClickPos("SpinWheelButton")
                            itemObtained:=""
                            itemObtainedPos:=PositionMap["ItemObtained"].Position
                            Sleep 100
                            Send "{F 1}"
                            Sleep 1000
                            itemObtained:=ReadText(itemObtainedPos[1],itemObtainedPos[2],400,150,true)
                            if itemObtained==""{
                                Sleep 1000
                                itemObtained:=ReadText(itemObtainedPos[1],itemObtainedPos[2],400,150,true)
                            }
                            TimesSpun:=TimesSpun+1
                            SendDiscordMessage([SpinnyWheelContents["Item0.1%"],attempts+1 . " Spinny wheels checked \n" . numHugesSeen . " Huges seen \nItem Obtained from wheel: " . itemObtained . "\n\nWheel has been spun " . TimesSpun . " times, costing " TimesSpun*55 "k gems \n\nItem in 50% slot is:" . SpinnyWheelContents["Item50%"]], UserID)

                        }
                        else{
                            SendDiscordMessage([SpinnyWheelContents["Item0.1%"],attempts+1 . " Spinny wheels checked \n" . numHugesSeen . " Huges seen \nItem in 50% Slot: " . SpinnyWheelContents["Item50%"] . "\n\nWheel has been spun " . TimesSpun . " times, costing " TimesSpun*55 "k gems\n\nDid not spin"], 0)
                            break
                        }
                    }
                }
                attempts:=attempts+1
            }
        } 
        else{
            SendDiscordMessage([SpinnyWheelContents["Item0.1%"],attempts+1 . " Spinny wheels checked \n" . numHugesSeen . " Huges seen \nItem in 50% Slot: " . SpinnyWheelContents["Item50%"] . "\n\nWheel has been spun " . TimesSpun . " times, costing " TimesSpun*55 "k gems\n\nDid not spin"], 0)
            attempts:=attempts+1
        }

        SendEvent "{W Down}"
        Sleep 500
        SendEvent "{W Up}"
        Send "{F 2}"
        Sleep 2000
        RouteUser("W:2|Wt:3000|Spl:TpButton")
        LeaderBoardThingyForPSL()
        Sleep 100
        RouteUser("W:3")

        Sleep 3000

        ;Waits for the teleport from world to world to finish, by checking if the teleport button is loaded
        RouteUser("Spl:TpButton")
        LeaderBoardThingyForPSL()
    }
}
F5::{
    if (not MacroSetup){
        return
    }
    AddToPositionMap()
    if not WinActive("ahk_exe RobloxPlayerBeta.exe"){
        if not WinExist("ahk_exe RobloxPlayerBeta.exe"){
            MsgBox "Bro did you even open roblox smh"
            return
        }
        else{
            WinActivate "ahk_exe RobloxPlayerBeta.exe"
            WinMove(,,816,638,"ahk_exe RobloxPlayerBeta.exe")
        }
    } else {
        WinActivate "ahk_exe RobloxPlayerBeta.exe"
        WinMove(,,816,638,"ahk_exe RobloxPlayerBeta.exe")
    }
    IgnoreDiamonds:=ToggleValueMap["IgnoreDiamonds"]
    IgnoreHuges:= ToggleValueMap["IgnoreHuges"]
    AlwaysSpin:= ToggleValueMap["SpinWhenNothingGoodIsPresent"]


    global attempts
    global running
    global numHugesSeen
    global TimesSpun
    global Colours
    global StartTime
    StartTime:=A_TickCount
    LeaderBoardThingyForPSL()
    PM_ClickPos("TpButton")
    SetPixelSearchLoop("TpButtonCheck", 12000, 1,,,,1,[{Func:LeaderBoardThingyForPSL, Time:1000}])
    Sleep 100
    SendEvent "{Click 20,20,0}"
    Sleep 500
    WinGetPos &WindowOffsetX,&WindowOffsetY,,,"ahk_exe RobloxPlayerBeta.exe"
    Results:=OCR.FromRect(PositionMap["FirstZoneTL"].Position[1]+WindowOffsetX,PositionMap["FirstZoneTL"].Position[2]+WindowOffsetY,78,59,("en-US"),5) ;Basically just works out what the name of the first zone is, so the script can make sure we will be in void world when the while loop starts
    FirstZone:=""
    for _,word in Results.words{
        FirstZone:= FirstZone . word.Text . " "
    }
    
    WorldIn:=""

    if (RegExMatch(FirstZone,"i)Pris|Prison|rison|Tower")){
        WorldIn:= "Void World"
    }
    else if(RegExMatch(FirstZone,"i)Tech")){
        WorldIn:= "Tech World"
    }
    else if(RegExMatch(FirstZone,"i)Spawn")){
        WorldIn:= "Spawn World"
    }
    else{
        MsgBox "We are so cooked, cya"
        ExitApp
    }

    Sleep 500
    PM_ClickPos("X")
    
    if (WorldIn!="Void World"){
        RouteUser("W:3")
    }
    Sleep 500
    LeaderBoardThingyForPSL()
    Main()
}
F6::{
    ExitApp
}
F7::{
    Pause -1
}
F8::{
    Reload
}
ExecScript(script) {
    tempFile := A_Temp "\temp_script.ahk"
    if FileExist(tempFile){
        FileDelete tempFile ; Delete if the file already exists
    }
    str:= '#Requires AutoHotkey v2.0', tempFile
    newScript:=StrSplit(script,"#n#")
    for part in newScript{
        str:= str . "`n" . part
    }
    FileAppend str, tempFile

    ; Run the temporary script and wait for it to finish
    RunWait tempFile
    FileDelete tempFile ; Clean up

}
F9::{
    userInput := ""
    IB := InputBox(userInput, "Enter AHK Code", "x400 y150")
    if (IB.Result=="Cancel"){
        return ; User pressed Cancel
    }
    ; Check if the user wants to exit
    if (IB.Value == "exit") {
        MsgBox "Exiting the script."
        return
    }
    userInput:=IB.Value
    ; Execute the user-inputted code
    try {
        ; Run the user input as a new AutoHotkey script
        MsgBox userInput
        ExecScript(userInput)
    } catch as e {
        MsgBox "An error occurred:`n" e.Message
    }
}
