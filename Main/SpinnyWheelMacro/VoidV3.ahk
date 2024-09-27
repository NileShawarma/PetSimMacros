#Requires AutoHotkey v2.0

#Include "%A_MyDocuments%\PS99_Macros\MyOwnFiles\MyOwnModules\routes.ahk"
#Include "%A_MyDocuments%\PS99_Macros\MyOwnFiles\MyOwnModules\UI_Positions.ahk"
#Include "%A_MyDocuments%\PS99_Macros\MyOwnFiles\MyOwnModules\Gdip\AHKv2-Gdip-master\AHKv2-Gdip-master\Gdip_All.ahk"
#Include "%A_MyDocuments%\PS99_Macros\MyOwnFiles\MyOwnModules\UWBOCRLib.ahk"
#Include "%A_MyDocuments%\PS99_Macros\MyOwnFiles\MyOwnModules\EasyUI.ahk"
#Include "%A_MyDocuments%\PS99_Macros\Modules\BasePositions.ahk"
#Include "%A_MyDocuments%\PS99_Macros\Modules\UsefulFunctions.ahk"

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SetMouseDelay -1

running:=true
numHugesSeen:=0
attempts:=0

global UI_PxCoords_List:=UI_PxCoords()
global UI_Positions_List:=UI_Positions()
global UIPxColours_List:=UI_PxColours()
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
    "VoidSpinnyWheel", "spl:TpButton|Tp:Prison Yard|wt:3000|spl:TpButton|sc:[114,215]|aspl:TpButton|sc:[32,225]|wt:3000|spl:TpButton|r:[0%Q50&50%D550&600%S550]|sc:[757, 144]|r:[0%S600]"
)
/*
    global WebhookMap := Map(
        "Webhook URL" , wbhurl,
        "DiscordID" , UserID,
        "NeverPing", false,
        "AlwaysPing", false
    )
*/
global MacroSetup:= false
wbhurl := "https://discord.com/api/webhooks/1258848709068980295/RsFEDpF6NxWsMyBVF9wWfnwr1VEEvEJgF8yhmXJAYdxmYBiz7j09qhWOvZV_67yhQg9x"
UserID := "778270946946580530"
Colours:="5814783"
global TimesSpun:=0
SendDiscordMessage(message, UserID,color:="16711680") {
    CurrentDateTime := FormatTime("yyyy hh:mm")
    item:=message[1]
  
    msg:=message[2]
    if (message.Has(3)){
        if message[3]=="restart"{
            imgUrl:="https://cdn-icons-png.freepik.com/512/7133/7133331.png"
        }
        else if(message[3]=="huge"){
            imgUrl:="https://static.wikia.nocookie.net/pet-simulator/images/6/6b/PS99_Huge_Atomic_Axolotl.png/revision/latest?cb=20240518173337"
        }
        else if(message[3]=="gems"){
            imgUrl:="https://static.wikia.nocookie.net/pet-simulator/images/5/51/Diamond_%28PSX%29.png/revision/latest?cb=20221111061240"
        }
        else{
            imgUrl:="https://static.wikia.nocookie.net/pet-simulator/images/d/de/PS99_Spinny_Wheel.png/revision/latest/scale-to-width/360?cb=20240130110944"
        }
    }
    else{
        imgUrl:="https://static.wikia.nocookie.net/pet-simulator/images/d/de/PS99_Spinny_Wheel.png/revision/latest/scale-to-width/360?cb=20240130110944"
    }
    data := 
    ( 
      '{
        "content" : "<@' UserID '>",
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
    whr.Open("POST", wbhurl, false)
    whr.SetRequestHeader("Content-Type", "application/json")
    whr.send(data)
    ;following is optional:
    whr.waitForResponse()
    return whr.responseText
  }
UIOBject:=false

Description:="This macro checks the contents of a spinny wheel, and if it contains diamond bags or a huge axolotl it will spin the wheel, else it will reset the server until the wheel has the desired items`n`nF5 : Start`nF8 : Stop"
Version:="3.0"

UIOBject := CreateBaseUI(Map(
"Main", {Title:"Void Spinny Wheel Macro", Description:Description, Version:Version, DescY:250, MacroName:"Void Spinny Wheel Macro", IncludeFonts:true, Channel:"https://www.youtube.com/channel/UCKOkQGvHO71nqQjwTiJX5Ww"},
"Settings", [
    {Map:ToggleValueMap, Name:"Toggle Settings", SaveName:"ToggleSettings", Type:"Toggle", IsAdvanced:false},
    {Map:NumberValueMap, Name:"Number Settings", SaveName:"NumberSettings", Type:"Number", IsAdvanced:false},
    {Map:UI_Positions_List, Name:"Positioning Settings", SaveName:"PositionSettings", Type:"Position", IsAdvanced:false},
    {Map:UI_PxCoords_List, Name:"PxCoords Settings", SaveName:"PxCoordsSettings", Type:"Position", IsAdvanced:true},
    {Map:UIPxColours_List, Name:"PxColours Settings", SaveName:"PxColoursSettings", Type:"Colour",IsAdvanced:true},
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
    SetNewValues(UI_Positions_List,UI_PxColours_List,UI_PxCoords_List)
}
global StartTime:=0
Path := A_MyDocuments "\PS99_Macros\SavedSettings\" "\" "VoidSpinnyWheelV3"
FileToSaveTo := Path "\MacroData\" "Data.ini"
OldData:=Map(
    "numHuges" , IniRead(FileToSaveTo,"SpinnyWheel","NumHugesSeen"),
    "SpinnyWheelsChecked" , IniRead(FileToSaveTo, "SpinnyWheel", "SpinnyWheelsChecked"),
    "SpinnyWheelsSpun" , IniRead(FileToSaveTo, "SpinnyWheel", "SpinnyWheelsSpun"),
    "GemsSpent" , IniRead(FileToSaveTo, "SpinnyWheel", "GemsSpent"),
    "TimeSpent" , IniRead(FileToSaveTo,"SpinnyWheel","TimeSpent")
)
UpdateData(){
    global numHugesSeen
    global attempts
    global TimesSpun
    global StartTime
    global OldData
    Path := A_MyDocuments "\PS99_Macros\SavedSettings\" "\" "VoidSpinnyWheelV3"
    FileToSaveTo := Path "\MacroData\" "Data.ini"

    IniWrite(numHugesSeen+OldData["numHuges"], FileToSaveTo, "SpinnyWheel", "NumHugesSeen")
    IniWrite(attempts+OldData["SpinnyWheelsChecked"], FileToSaveTo, "SpinnyWheel", "SpinnyWheelsChecked")
    IniWrite(TimesSpun+OldData["SpinnyWheelsSpun"], FileToSaveTo, "SpinnyWheel", "SpinnyWheelsSpun")
    IniWrite((TimesSpun*55000)+OldData["GemsSpent"], FileToSaveTo, "SpinnyWheel", "GemsSpent")
    IniWrite((A_TickCount-StartTime)+OldData["TimeSpent"], FileToSaveTo,"SpinnyWheel","TimeSpent")
}
AddToPositionMap(){
    PositionMap["TpButton"]:={Macros:["All"],Position:[116, 195], Version:"BF_V1.0.0"}
    PositionMap["TpButtonTL"]:={Macros:["All"],Position:[112, 190], Version:"BF_V1.0.0"}
    PositionMap["TpButtonBR"]:={Macros:["All"],Position:[120, 200], Version:"BF_V1.0.0"}

    PositionMap["FirstZoneTL"]:={Macros:["VoidSpinnyWheel"], Position:[103, 219], Version:"MM_V4.0.0"}
    PositionMap["FirstZoneBR"]:={Macros:["VoidSpinnyWheel"], Position:[181, 278], Version:"MM_V4.0.0"}

    PositionMap["0.1%Item"]:={Macros:["VoidSpinnyWheel"], Position:[555, 218], Version:"MM_V4.0.0"}
    PositionMap["50%Item"]:={Macros:["VoidSpinnyWheel"], Position:[467, 259], Version:"MM_V4.0.0"}

    PositionMap["SpinWheelButton"]:={Macros:["VoidSpinnyWheel"], Position:[180, 454], Version:"MM_V4.0.0"}
    PositionMap["ItemObtained"] := {Macros:["VoidSpinnyWheel"], Position:[412, 357], Version:"MM_V4.0.0"}

    for _, CreationArray in ____PSCreationMap {
        ____CreatePSInstance(CreationArray)
    }
}
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
        ;MsgBox Results
        Item01str:=""
        for _,word in Results.words{
            Item01str:=Item01str . word.Text . " "  ;Works out the 01.% item
        }
        if Item01str==""{
            SendEvent "{Click 0,0,0}"
            SendEvent "{Click," . Item01[1] . "," . Item01[2] . ",0}"
            Sleep 200
            Results:=OCR.FromRect(Item01[1]+WindowOffsetX-10, Item01[2]+WindowOffsetY-10,OCRSettings["Width"],OCRSettings["Height"],("en-US"),5)
            ;MsgBox Results
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
        LeaderBoardThingy()

        RouteUser(routes["VoidSpinnyWheel"])

        /*if (CompareColours("SpinnyWheel")){ ;Checks the user is actually at the spinny wheel
        ;    Sleep 100
        ;}
        ;else{
            attempt:=0
            loop{
                Reset_World()
                Sleep 3000

                RouteUser(routes["VoidSpinnyWheel"])
        
                Sleep 1500
                attempt:=attempt+1
                ;if (CompareColours("SpinnyWheel")){ ;Checks the user is actually at the spinny wheel
                break
                ;}
                if (attempt>5){
                    break
                }
            }
        ;}
        */
        LeaderBoardThingy()

        SpinnyWheelContents:=GetSpinnyWheelContents()
        
        if RegExMatch(SpinnyWheelContents["Item0.1%"], "i)Mm1C"){ ;Sometimes the script gets high and cant fucking read the words mini chest
            Static image := A_MyDocuments '\PS99_Macros\MyOwnFiles\DeBugFolder\captura.png'
            SoundBeep 1500
            pToken  := Gdip_Startup()
            pBitmap := Gdip_BitmapFromScreen("0|0|" A_ScreenWidth "|" A_ScreenHeight)
            Gdip_SaveBitmapToFile(pBitmap, image)
            Gdip_DisposeImage(pBitmap), Gdip_Shutdown(pToken) ;Records a screenshot of this text it couldnt read so I can debug it : D 
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
            UpdateData()
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

                Sleep 100

                
                SpinnyWheelContents:=GetSpinnyWheelContents()
                if RegExMatch(SpinnyWheelContents["Item0.1%"], "i)Mm1C"){
                    Static image := A_MyDocuments '\PS99_Macros\MyOwnFiles\DeBugFolder\captura.png'
                    SoundBeep 1500
                    pToken  := Gdip_Startup()
                    pBitmap := Gdip_BitmapFromScreen("0|0|" A_ScreenWidth "|" A_ScreenHeight)
                    Gdip_SaveBitmapToFile(pBitmap, image)
                    Gdip_DisposeImage(pBitmap), Gdip_Shutdown(pToken)
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
                UpdateData()
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
        RouteUser("W:2|Wt:3000|spl:TpButton")
        LeaderBoardThingy()
        Sleep 100
        RouteUser("W:3")

        Sleep 3000

        ;Waits for the teleport from world to world to finish, by checking if the teleport button is loaded
        RouteUser("spl:TpButton")
        LeaderBoardThingy()
        UpdateData()
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
            WinMove(,,816,638,"ahk_ahk_exe RobloxPlayerBeta.exe")
        }
    }
    IgnoreDiamonds:=ToggleValueMap["IgnoreDiamonds"]
    IgnoreHuges:= ToggleValueMap["IgnoreHuges"]
    AlwaysSpin:= ToggleValueMap["SpinWhenNothingGoodIsPresent"]

    Loop{ ;Creates a screenshot so the user knowns how many gems they have
        newPath := A_MyDocuments "\PS99_Macros\SavedSettings\\VoidSpinnyWheelV3\MacroData\Gems\Starting\StartingGems" A_Index ".png"
        if not FileExist(newPath){
            image := A_MyDocuments "\PS99_Macros\SavedSettings\\VoidSpinnyWheelV3\MacroData\Gems\Starting\StartingGems" A_Index ".png"
            SoundBeep 1500
            pToken  := Gdip_Startup()
            pBitmap := Gdip_BitmapFromScreen("0|0|" A_ScreenWidth "|" A_ScreenHeight)
            Gdip_SaveBitmapToFile(pBitmap, image)
            Gdip_DisposeImage(pBitmap), Gdip_Shutdown(pToken)
            Sleep 500
            break
        }
    }

    global attempts
    global running
    global numHugesSeen
    global TimesSpun
    global Colours
    global StartTime
    StartTime:=A_TickCount
    LeaderBoardThingy()
    TpButton:=UI_Positions_List["TPButton"]
    PM_ClickPos("TpButton")
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
        A_Clipboard := FirstZone

        Static image := A_MyDocuments '\PS99_Macros\MyOwnFiles\DeBugFolder\FirstZone.png' ;If the script doesnt know wtf is happening we take a screenshot!
        SoundBeep 1500
        pToken  := Gdip_Startup()
        pBitmap := Gdip_BitmapFromScreen("0|0|" A_ScreenWidth "|" A_ScreenHeight)
        Gdip_SaveBitmapToFile(pBitmap, image)
        Gdip_DisposeImage(pBitmap), Gdip_Shutdown(pToken)

        ExitApp
    }

    Sleep 500

    if (WorldIn!="Void World"){
        PM_ClickPos("X")
        RouteUser("W:3")
    }
    Sleep 500
    LeaderBoardThingy()
    Main()
}
F6::{
    AddToPositionMap()
    con:=GetSpinnyWheelContents()
    MsgBox con["Item0.1%"] . con["Item50%"]

}
F7::{
    Pause -1
}
F8::{
    Loop{
        newPath := A_MyDocuments "\PS99_Macros\SavedSettings\\VoidSpinnyWheelV3\MacroData\Gems\Final\Gems" A_Index ".png"
        if not FileExist(newPath){
            image := A_MyDocuments "\PS99_Macros\SavedSettings\\VoidSpinnyWheelV3\MacroData\Gems\Final\Gems" A_Index ".png"
            SoundBeep 1500
            pToken  := Gdip_Startup()
            pBitmap := Gdip_BitmapFromScreen("0|0|" A_ScreenWidth "|" A_ScreenHeight)
            Gdip_SaveBitmapToFile(pBitmap, image)
            Gdip_DisposeImage(pBitmap), Gdip_Shutdown(pToken)
            Sleep 500
            break
        }
    }
    Reload
}
ExecScript(script) {
    tempFile := A_Temp "\temp_script.ahk"
    if FileExist(tempFile){
        FileDelete tempFile ; Delete if the file already exists
    }
    str:= '#Requires AutoHotkey v2.0 `n#Include "%A_MyDocuments%\PS99_Macros\MyOwnFiles\MyOwnModules\routes.ahk" `n#Include "%A_MyDocuments%\PS99_Macros\MyOwnFiles\MyOwnModules\UI_Positions.ahk" `n#Include "%A_MyDocuments%\PS99_Macros\MyOwnFiles\MyOwnModules\Useful_Funcs.ahk"`n', tempFile
    newScript:=StrSplit(script,"#n#")
    for part in newScript{
        str:= str . "`n" . part
    }
    FileAppend str, tempFile

    ; Run the temporary script and wait for it to finish
    RunWait tempFile
    FileDelete tempFile ; Clean up
    Poss:=[848, 558],    [913, 558],    [841, 590],    [901, 593]

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
