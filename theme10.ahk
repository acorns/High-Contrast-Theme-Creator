/*
Name: Theme10
Version 1.1 (Saturday, March 25, 2017)
Created: Friday, February 24, 2017
Author: tidbit
Credit: 
	Tank: CrossHair()
	maestrith: color picker: Dlg_Color()
	just me: controlcolors class
	hotkeyit: implementing the test gui in the main gui
	
Hotkeys:
	ctrl+s     = Save
	ctrl+alt+s = Save to clipboard
	ctrl+alt+s = Open/load a .theme file
	arrows     = While color picker (crosshair) is active, moves cursor by 1 pixel
	
Description:
	Create/edit the colors of a .theme file, usually for high-contrast themes. Has a preview and other goodies.
*/



#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #singleInstance, off
#singleInstance, force
setBatchLines, -1
; #includes are at the bottom

_name_:="Theme10"
_version_:="v1.0"

onExit, goBackToYourUglyOS
fontSize:=10


template:=A_ScriptDir "\theme\Template-DO_NOT_EDIT.theme"

if (!fileExist(template))
	gosub, createTemplate

iniread, loaded, %template%, Control Panel\Colors

SysGet, xbord, 32
SysGet, ybord, 33
SysGet, cap, 4

gosub, loadPrev

; this gets around the expression length limit
defaults=
(
text,Window|mode,2|fg,255 255 255|bg,100 080 030
text,Window Frame|mode,2|fg,255 255 255|bg,100 080 030
text,Background|mode,2|fg,255 255 255|bg,100 080 030
text,Window Text|mode,1|fg,255 255 255|bg,255 080 030
text,Gray Text|mode,1|fg,255 255 255|bg,100 080 030
text,Info Window|mode,2|fg,255 255 255|bg,100 080 030
text,Info Text|mode,1|fg,255 255 255|bg,100 080 030
text,Active Border|mode,2|fg,255 255 255|bg,100 080 030
text,Gradient Active Title|mode,2|fg,255 255 255|bg,100 080 030
text,Active Title|mode,2|fg,255 255 255|bg,100 080 030
text,Title Text|mode,1|fg,255 255 255|bg,100 080 030
text,Inactive Border|mode,2|fg,255 255 255|bg,100 080 030
text,Gradient Inactive Title|mode,2|fg,255 255 255|bg,100 080 030
text,Inactive Title|mode,2|fg,255 255 255|bg,100 080 030
text,Inactive Title Text|mode,1|fg,255 255 255|bg,100 080 030
text,App Workspace|mode,2|fg,255 255 255|bg,100 080 030
text,Button Face|mode,2|fg,255 255 255|bg,100 080 030
text,Button Text|mode,1|fg,255 255 255|bg,100 080 030
text,Button Alternate Face|mode,2|fg,255 255 255|bg,100 080 030
text,Button Light|mode,2|fg,255 255 255|bg,100 080 030
text,Button Light Text|mode,3|fg,255 255 255|bg,100 080 030
text,Button Hilight|mode,2|fg,255 255 255|bg,100 080 030
text,Button Shadow|mode,2|fg,255 255 255|bg,100 080 030
text,Button Dk Shadow|mode,2|fg,255 255 255|bg,100 080 030
text,Hilight|mode,2|fg,255 255 255|bg,100 080 030
text,Hilight Text|mode,1|fg,255 255 255|bg,100 080 030
text,Hot Tracking Color|mode,2|fg,255 255 255|bg,100 080 030
text,Menu|mode,2|fg,255 255 255|bg,100 080 030
text,Menu Text|mode,1|fg,255 255 255|bg,100 080 030
text,Menu Bar|mode,2|fg,255 255 255|bg,100 080 030
text,Menu Hilight|mode,2|fg,255 255 255|bg,100 080 030
text,Menu Hilight Text|mode,3|fg,255 255 255|bg,100 080 030
text,Scrollbar|mode,2|fg,255 255 255|bg,100 080 030
)

gui, main: font, s%fontSize%

descWidth:=fontSize*15
colWidth:=fontSize*9+3+30 ; font * ??? + margin + button size

gui, main: margin, 3, 3
gui, main: add, text, xm ym r1.5 0x200, Theme Name:
ttt:=fontSize*16
gui, main: add, edit, x+m yp w%ttt% hp 0x200 vname gnewName, Test Theme
gui, main: add, Button, x+3 yp w45 hp grandomize vrname, R

gui, main: add, text, xm y+10 w%descWidth% center, Description
gui, main: add, text, x+m yp w%colWidth% center, RGB Color

cpColors:={}
colWidth:=fontSize*9

for k, ttt in strSplit(defaults, "`n", "`r")
{
	loop, parse, ttt, |
	{
		stuff:=strSplit(A_loopField, ",")
		name:=strReplace(stuff[2], " ")
		if (!cpColors.hasKey(name) && A_index=1)
			ttt:=cpColors[name]:={}
			, var:=name
			
		ttt[stuff[1]]:=stuff[2]
	}
	text:=cpColors[var, "text"]
	gui, main: add, text, xm y+0 w%descWidth% r1.5 0x200 hwndh%var%t vt%var%, % " " text

	if (ttt["mode"]=3)
	{
		CtlColors.attach(h%var%t, randC, "ffffff")
		continue
	}
	gui, main: add, edit, x+m yp w%colWidth% hp vfg%var%, % getColor(var)
	gui, main: add, button, x+m yp w30 hp vbfg%var% gcolDLG, ...

	gui, main: font, s%fontSize%, wingdings
	gui, main: add, button, x+m yp w30 hp vp%var% gpickColor, 8
	gui, main: font,
	gui, main: font, s%fontSize%
}

; preview gui loopkup table
; preview gui : main gui
pvLookup:={"InactiveTitle":"InactiveTitle", "InactiveTitleText":"InactiveTitleText"
,"InactiveBtn1":"ButtonFace", "InactiveBtn2":"ButtonFace", "InactiveBtn3":"ButtonFace"
,"InactiveBorder":"InactiveTitle", "InactiveMain":"ButtonFace", "ActiveTitle":"ActiveTitle"
,"ActiveTitleText":"TitleText", "ActiveTitleBtn1":"Window", "ActiveTitleBtn2":"Window"
,"ActiveTitleBtn3":"Window", "ActiveBorder":"ActiveTitle", "ActiveMenu":"ButtonFace"
,"ActiveMenu2":"MenuBar", "ActiveText":"MenuText", "Main":"ButtonFace", "EditBG":"Window"
,"ScrollMain":"ButtonHilight", "ScrollThing":"ButtonFace", "EditText":"WindowText", "EditText2":"WindowText"
,"selBG":"Hilight", "selFG":"HilightText", "TextEnabled":"WindowText", "TextDisabled":"GrayText"
,"TextLink":"HotTrackingColor", "TextLink2":"HotTrackingColor", "Btn":"ButtonFace", "BtnText":"ButtonText", "BtnH":"Hilight"
,"BtnHText":"HilightText", "BtnDB":"GrayText", "BtnD":"ButtonFace", "BtnDText":"GrayText"}

words1:=["Seduction","Gorgeous","Stunning","Cute","Hot","Sexy","Attractive","Handsome","Appealing","Admirable","Beautiful","Charming","Classy","Dazzling","Delightful","Divine","Elegant","Enticing","Alluring","Exquisite","Excellent","Fair","Fascinating","Fine","Foxy","Good-Looking","Grand","Lovely","Magnificent","Marvelous","Ravishing","Sightly"]
words2:=["Bobcat","Bean","Fennel","Tropicbird","Parsley","Chinchilla","Ostrich","Dachshund","Amaranth","Okra","Cichlid","Squash","Chinook","Liger","Porcupine","Quail","Lotus","Quoll","Alligator","Pumpkin","Flamingo","Sparrow","Cabbage","Bloodhound","Catsear","Javanese","Peanut","Hippopotamus","Earthnut","Daikon","Artichoke","Rhinoceros","Lemming","Cougar","Crab","Watercress","Moose","Purslane","Quokka","Dulse","Woodpecker","Axolotl","Kale","Bamboo","Kohlrabi","Silver","Numbat","Maize","Indri","Snowshoe","Broccoli","Bunya","Okapi","Bologi","Tigernut","Chestnut","Angelfish","Drever","Jackal","Sprout","Antelope","Water","Anteater","Rabbit","Cuttlefish","Soybean","Raccoon","Hare","Ladybird","Skunk","Pig","Aubergine","Rottweiler","Eggplant","Carrot","Havanese","Greens","Plum","Desert","Walrus","Echidna","Nuts","Endive","Coyote","Pike","Tiger","Sorrel","Oyster","Melon","Coriander","Newt","Bear","Mouse","Greyhound","Piranha","Flounder","Goat","Burmese","Mongrel","Scorpion","Collie","Jaguar","Llama","Chickweed","Lizard"]

menu, copypaste, add, Copy, menuh
menu, copypaste, add, Paste, menuh
menu, copypaste, add, Reset, menuh

menu, fmenu, add, Open...`tO, menuh
menu, fmenu, add, Open Save Location`tL, menuh
menu, fmenu, add,
menu, fmenu, add, Save`tS, save
menu, fmenu, add, Save To Clipboard`tC, save
menu, fmenu, add
menu, fmenu, add, Apply Theme, menuh
menu, fmenu, add
menu, fmenu, add, Undo All Changes`tU, menuh
menu, fmenu, add
menu, fmenu, add, Quit`tQ, menuh
menu, menubar, add, &File, :fmenu
menu, menubar, add, Randomize &Dark, randomize
menu, menubar, add, Randomize &Light, randomize
menu, menubar, add, Show / Hide &Test Window, menuh


gui, frame: menu, MenuBar

first:=1
if (first=1)
	gosub, load

gui, frame: +hwndMYFRAME +resize
gui, main: +hwndMYGUI +scroll +parentframe -border
gui, prev: +hwndPREVGUI parentframe -border +Disabled

ttt:=descWidth+colWidth+30+30+40

GoSub, testGui

gui, frame: add, gui, x0 y0 w592 vTestGui, test
ControlGetPos,,,,hhh,,ahk_id %hTestGui%
hhh-=30
guiControl, frame: Hide, TestGui
gui, frame: show, w500 h600 hide, %_name_% - %_version_%
gui, main: show, x0 y0 w%ttt% h%hhh% , %_name_% - %_version_%

ttt:=ttt+6
gui, prev: show, x%ttt% y0, %_name_% - Preview

winGetPos,,,www,, ahk_id %PREVGUI%
winGetPos,,,www2,hhh, ahk_id %MYGUI%
www+=www2
gui, frame: show, w%www% h%hhh%
first:=0
return


#if (usingPicker=1)
	*lbutton::return
	*rbutton::return
	up::mouseMove,0, -1,, R
	down::mouseMove,0, 1,, R
	left::mouseMove,-1, 0,, R
	right::mouseMove,1, 0,, R
#if


; ~esc::
mainGuiClose:
prevGuiClose:
frameGuiClose:
goBackToYourUglyOS:
	cColors.Free()
	CrossHair(true)
exitapp


frameGuiSize:
	winMove, ahk_id %MYGUI%,,0,0,,%A_guiHeight%
	; WinGetPos,x,y,w,h,ahk_id %testGui%
	guiControlGet, pos, frame: pos, testGui
	w:=A_guiWidth
	h:=A_guiHeight
	guiControl, frame: move, testGui, w%w% h%h%
return


mainGuiContextMenu:
	menuCont:=strReplace(A_guiControl, " ")
	menuCont:=subStr(menuCont, 2)
	if (subStr(A_guiControl, 1, 1)="t")
		menu, copypaste, show
return


newName:
	guiControlGet, name, main:
		winSetTitle, ahk_id %MYFRAME%,, %_name_% - %_version_% - %name%
	; winSetTitle, ahk_id %PREVGUI%,, %_name_% - Preview - %name%
	GUID:=ComObjCreate("Scriptlet.TypeLib").Guid
return


colDLG:
	cont:=subStr(A_guiControl, 4)
	ttt:=strSplit(getColor(cont), " ")
	ttt:=ttt[3] " " ttt[2] " " ttt[1] ; make it BGR
	selColor:=format("{:06}", RGB(dlg_color("0x" rgbToHex(ttt), MYGUI)))
	selColor:=hexToRGB(selColor)
	; toolTip % ttt "/" selColor ":" selColor2 "/" rgbToHex(ttt)
	guiControl, main:, fg%cont%, %selColor%
return


menuH:
	gui, frame: +ownDialogs
	if (A_thisMenuItem="Quit`tQ")
		exitapp
		
	if (A_thisMenuItem="Show / Hide &Test Window")
	{
		if DllCall("IsWindowVisible", "PTR", hTestGui)
			guicontrol,frame: hide, testGui 
		else 
			guicontrol,frame: show, testGui 
	}
	
	if (A_thisMenuItem="Apply Theme")
	{
		; if (fileExist(A_ScriptDir "\theme\"))
		
		msgBox, 52, Save first?, Would you like to save first? otherwise any unsaved changes won't be applied.
		ifmsgbox, yes
		{
			saveFromElsewhere:=1
			gosub, Save
		}
			
		toApply:=A_ScriptDir "\theme\" name ".theme"
		if (fileExist(toSave))
			run, %toSave%
		else if (fileExist(toLoad) && !inStr(toLoad, "DO_NOT_EDIT"))
			run, %toLoad%
		else if (fileExist(toSave))
			run, %toApply%
		else
			msgBox, 16, E.33461, You must first save or load a file before applying a theme.
	}
	
	if (A_thisMenuItem="Open Save Location`tL")
		run, %A_scriptDir%\theme
		
	if (A_thisMenuItem="Copy")
		clipboard:=cpColors[menuCont, (cpColors[menuCont, "mode"]=1) ? "fg" : "bg"]
		
	if (A_thisMenuItem="Paste")
		if (clipboard~="(?:(?:#|0x)?[a-fA-F0-9]{6}|\d{1,3} \d{1,3} \d{1,3})")
			guiControl, main:, fg%menuCont%, %clipboard%
			
	if (A_thisMenuItem="Reset")
			guiControl, main:, fg%menuCont%, % originals[menuCont]
			
	if (A_thisMenuItem="Undo All Changes`tU")
	{
		msgBox, 36, Confirm, Are you sure you want to undo all your changes to this theme?
		ifmsgbox, no
			return
		for k, color in originals
			guiControl, main:, fg%k%, %color%
	}
			; guiControl, main:, fg%menuCont%, % originals[menuCont, (originals[menuCont, "mode"]=1) ? "fg" : "bg"]
	if (A_thisMenuItem="Open...`tO")
		gosub, load
return


pickColor:
	coordMode, mouse, screen
	coordMode, pixel, screen
	cont:=subStr(A_guiControl, 2)
	usingPicker:=1
	CrossHair(false)
	ttt:=0
	
	loop
	{
		sleep, 25 ; because why not.
		
		if (getKeyState("rbutton", "p"))
		{
			ttt:=1
			break
		}
		mouseGetPos, mx, my
		pixelGetColor, selColor, %mx%, %my%, RGB
		
		if (selColor=colp) ; this makes it feel weird, but in a good way. it lets you know when a color is different
			continue
		
		toolTip, % selColor " - " hexToRGB(subStr(selColor,3)) "`nClick to select`nRight click to cancel"
		colp:=selColor
	}
	until (getKeyState("lbutton", "p"))

	usingPicker:=0
	CrossHair(true)
	toolTip
	
	gui, main: show
	if (ttt!=1)
		guiControl, main:, fg%cont%, % hexToRGB(subStr(selColor, 3))
return


randomize:
	guiControlGet, rname, main:
	if (A_guiControl="rname")
	{
		name:=(rand(5)=1) ? ((lastM="Randomize Light") ? "Light " : "Dark ") : ""
		name.=(rand(2)=1) ? words1[rand(words1.length())] " " : ""
		name.=(rand(3)>1) ? words2[rand(words2.length())] " " : words2[rand(words2.length())] " " words2[rand(words2.length())]
		name:=trim(name)
		guiControl, main:, name, %name%
		GUID:=ComObjCreate("Scriptlet.TypeLib").Guid
		return
	}
	lastM:=A_thisMenuItem ; used for the names
	
	if (A_thisMenuItem="Randomize &Dark")
	{
		for k, v in cpColors
		{
			if (inStr(k, "text") || inStr(k, "HotTracking"))
				guiControl, main:, fg%k%, % rand(90,255) " " rand(90,255) " " rand(90,255)
			else
				guiControl, main:, fg%k%, % rand(80) " " rand(80) " " rand(80)
		}
	}
	if (A_thisMenuItem="Randomize &Light")
	{
		for k, v in cpColors
		{
			if (inStr(k, "text") || inStr(k, "HotTracking"))
				guiControl, main:, fg%k%, % rand(80) " " rand(80) " " rand(80)
			else
				guiControl, main:, fg%k%, % rand(120,255) " " rand(120,255) " " rand(120,255)
		}
	}
return


#if (winActive("ahk_id " MYFRAME))
^o:: goto, load ; load
^s:: ; save
!s:: ; save to Clipboard
save:
	gui, main: +ownDialogs
	if (A_thisMenuItem="Save`tS" || A_thisHotkey="^s" || saveFromElsewhere=1)
	{
		gui, main: submit, nohide
		out:=""
		splitPath, toLoad,, ttt ; ttt = dir. temp var. don't need to make more useless ones
		name:=regExReplace(trim(name, "`r`n `t"), "[*.""\/\\\[\]:;|=,]")
		toSave:=ttt "\" name ".theme"
		
		overwrite:=0
		if (fileExist(toSave))
		{
			msgBox, 36, Overwrite?, Do you want to overwrite the existing file:`nPath: %toSave%`nFile: %name%.theme
			overwrite:=1
			ifmsgbox, no
				return
		}
		
		if (toSave="")
		{
			msgBox,16 , Error 23857c, The files name cannot be blank.`nName: %toSave%
			return
		}
		FileCopy, %toLoad%, %toSave%, 1
		
		for k, v in cpColors
			IniWrite, % getColor(k), %toSave%, Control Panel\Colors, %k%
			
		IniWrite, %name%, %toSave%, Theme, DisplayName
		IniWrite, %GUID%, %toSave%, Theme, ThemeId
		; if (overwrite=0) ; only generate a new uid on new themes
		; IniWrite, {46BA21B1-54E6-4846-98C9-B09A8EAB89E8}, %toSave%, Theme, ThemeId

			
		; msgBox %toSave%
		if (saveFromElsewhere!=1)
			msgBox, 48, Success, Save Successful!`n%toSave%, 5
		saveFromElsewhere:=0
	}
	
	if (A_thisMenuItem="Save to clipboard`tC" || A_thisHotkey="!s")
	{ 
		guiControlGet, name, main:
		fileRead, ttt, %toLoad%
		for k, v in cpColors ; is this dumb or genius?
			ttt:=regExReplace(ttt, "i)" k "=.*", k "=" getColor(k))
		ttt:=regExReplace(ttt, "i)DisplayName=.*", "DisplayName=" name)
		ttt:=regExReplace(ttt, "i)ThemeId=.*", "ThemeId=" GUID)
		; ttt:=regExReplace(ttt, "i)ThemeId=.*", "ThemeId={46BA21B1-54E6-4846-98C9-B09A8EAB89E8}")
		; ttt:=regExReplace(ttt, "i)ThemeId=.*", "ThemeId=" ComObjCreate("Scriptlet.TypeLib").Guid)
		Clipboard:=ttt
		soundBeep
	}
return
#if


frameGuidropFiles:
	loop, parse, A_GuiEvent, `n, `r
	{
	    wasDropped:=A_LoopField
	    Break
	}
	gosub, load
return


load:
	if (first=1)
		toLoad:=template
	else
		if (wasDropped="")
			fileSelectFile, toLoad,, %A_ScriptDir%\theme
			
	if (wasDropped!="")
		toLoad:=wasDropped
		, wasDropped:=""
		
	iniread, loaded, %toLoad%, Control Panel\Colors
	
	
	; separate this stuff so we can keep it in the listed order. and other things.
	originals:={}
	for k, ttt in strSplit(loaded, "`n", "`r")
	{
		stuff:=strSplit(ttt, "=")
		var:=stuff[1]
		if (cpColors[var, "mode"]=1)
			cpColors[var, "fg"]:=stuff[2]
		else
			cpColors[var, "bg"]:=stuff[2]
		originals[var]:=stuff[2]
		
		text:=cpColors[var, "text"]

		if (cpColors[var, "mode"]=3)
		{
			CtlColors.attach(h%var%t, cpColors[var, "fg"], cpColors[var, "bg"])
			continue
		}
		
		guiControl, main:, fg%var%, % getColor(var)
		guiControl, main: +gupdate, fg%var%
	}
	iniread, ttt, %toLoad%, Theme, DisplayName
	iniread, GUID, %toLoad%, Theme, ThemeId
	guiControl, main:, name, %ttt%
	winSetTitle, ahk_id %MYFRAME%,, %_name_% - %_version_% - %ttt%

	; set the "child" text's to the approprate "parent" bg color
	cpColors["WindowText", "bg"]       :=cpColors["background", "bg"]
	cpColors["GrayText", "bg"]         :=cpColors["background", "bg"]
	cpColors["MenuText", "bg"]         :=cpColors["Menu", "bg"]
	cpColors["ButtonText", "bg"]       :=cpColors["ButtonFace", "bg"]
	cpColors["MenuHilightText", "bg"]  :=cpColors["MenuHilight", "bg"]
	cpColors["MenuHilightText", "fg"]  :=cpColors["MenuText", "fg"]
	cpColors["InfoText", "bg"]         :=cpColors["InfoWindow", "bg"]
	cpColors["HiLightText", "bg"]      :=cpColors["Hilight", "bg"]
	cpColors["ButtonLightText", "bg"]  :=cpColors["ButtonLight", "bg"]
	cpColors["ButtonLightText", "fg"]  :=cpColors["ButtonText", "fg"]
	cpColors["TitleText", "bg"]        :=cpColors["ActiveTitle", "bg"]
	cpColors["InactiveTitleText", "bg"]:=cpColors["InactiveTitle", "bg"]
	cpColors["HotTrackingColor", "fg"] :=cpColors["HilightText", "fg"]
	
	toUpdate:=[]
	; first:=1
	for k in cpColors
		toUpdate.push(k)
	gosub, redraw
	; first:=0
return


update:
	cont:=subStr(A_guiControl, 3)
	cont2:=A_guiControl
	mode:=cpColors[cont, "mode"]
	guiControlGet, color, main:, %cont2%
	color:=trim(color, "`r`n `t")
	; col:=cont
	if ((color~="(?:#|0x)?[a-fA-F0-9]{6}"))
	{
		color:=strReplace(strReplace(color, "0x"), "#")
		color:=hexToRGB(color)
		guiControl, main: -g, %cont2%
		guiControl, main:, %cont2%, %color%
		guiControl, main: +gupdate, %cont2%
		GuiControlGet, OutputVar, main: Hwnd, %A_guiControl%
		sendMessage, 0xB1, 0, % strLen(color),, ahk_id %OutputVar% ; 0xB1 = em_setsel
	}
	else if (!(color~="^\d{1,3} \d{1,3} \d{1,3}$"))
		return

	colorHex:=rgbToHex(color)
	; CtlColors.Change(h%cont%t, colorHex, "ffffff")
	
	changeColor(cont, colorHex, "")
	if (cpColors[cont, "mode"]=2)
		cpColors[cont, "bg"]:=color
		; , cpColors[cont, "fg"]:="255 0 255" ; adjust brightness of bg text
	else
		cpColors[cont, "fg"]:=color

	ttt:=strSplit(color, " ")

	if (first=0)
		toUpdate:=[cont]
		
	if (cont="background")
		cpColors["WindowText", "bg"]:=color
		, cpColors["GrayText", "bg"]:=color
		, toUpdate.push("WindowText", "GrayText")
	if (cont="Menu")
		cpColors["MenuText", "bg"]:=color
		, toUpdate.push("MenuText")
	if (cont="ButtonFace")
		cpColors["ButtonText", "bg"]:=color
		, toUpdate.push("ButtonText")
	if (cont="MenuHilight")
		cpColors["MenuHilightText", "bg"]:=color
		, toUpdate.push("MenuHilightText")
	if (cont="MenuText")
		cpColors["MenuHilightText", "fg"]:=color
		, toUpdate.push("MenuHilightText")
	if (cont="InfoWindow")
		cpColors["InfoText", "bg"]:=color
		, toUpdate.push("InfoText")
	if (cont="Hilight")
		cpColors["HiLightText", "bg"]:=color
		, toUpdate.push("HiLightText")
	if (cont="ButtonLight")
		cpColors["ButtonLightText", "bg"]:=color
		, toUpdate.push("ButtonLightText")
	if (cont="ButtonText")
		cpColors["ButtonLightText", "fg"]:=color
		, toUpdate.push("ButtonLightText")
	if (cont="ActiveTitle")
		cpColors["TitleText", "bg"]:=color
		, toUpdate.push("TitleText")
	if (cont="InactiveTitle")
		cpColors["InactiveTitleText", "bg"]:=color
		, toUpdate.push("InactiveTitleText")
	if (cont="HilightText")
		cpColors["HotTrackingColor", "fg"]:=color
		, toUpdate.push("HotTrackingColor")

	gosub, redraw
return


redraw:
	for k, v in toUpdate
	{
		changeColor(v, cpColors[v, "fg"], cpColors[v, "bg"])
		; msgBox % v "`n" cpColors[v, "fg"] "`n" cpColors[v, "bg"]
	}

	gui, prev: default
	gui, prev: submit, nohide

	; msgBox % st_printArr(pvLookup)
	for prevC, mainC in pvLookup
	{
		mode:=cpColors[mainC, "mode"]
		color:=(mode=2) ? cpColors[mainC, "bg"] : cpColors[mainC, "fg"]
		color:=rgbToHex(color)
		guiControlGet, val, prev:, %prevC%
		; val:=%prevC%
		; sleep, 300
		; toolTip % %prevC% ": " prevC ": " val
		
		if (inStr(prevC, "Text"))
		{
			guiControl, prev: +c%color% +backgroundTrans, %prevC%
			; guiControl, prev:, %color%
		}
		else if (val>0)
			guiControl, % "prev: +c" color " +background" rgbToHex(cpColors["ButtonText", "fg"]), %prevC%
		else
			guiControl, prev: +Background%color%, %prevC%
		; guiControl, prev:, %prevC%, % rand(75)
	}

	; special things
	; msgBox % cpColors["InactiveTitle", "bg"]
	guiControl, prev: +backgroundTrans, selFG
	ttt:=("0x" rgbToHex(cpColors["HotTrackingColor", "bg"]), -35)
	guiControl, prev: +c%ttt%, TextLink
	ttt:=somewhatAccurateBrightnessShift("0x" rgbToHex(cpColors["InactiveTitle", "bg"]), -35)
	guiControl, prev: +Background%ttt%, InactiveBtn1
	guiControl, prev: +Background%ttt%, InactiveBtn2
	guiControl, prev: +Background%ttt%, InactiveBtn3

	gui, prev: color, % somewhatAccurateBrightnessShift("0x" rgbToHex(cpColors["InactiveTitle", "bg"]), 70)
	; gui, main: submit
	gui, main: default
	WinSet, Redraw,, ahk_id %PREVGUI%

return


createTemplate:
	fileAppend,
	( ltrim
	; Copyright © Microsoft Corp.

	[Theme]
	; Windows - IDS_THEME_DISPLAYNAME_AERO
	DisplayName=Test Theme
	ThemeId={30A4D7D0-E8D2-467C-BC88-C9A557F57D63}

	[Control Panel\Desktop]
	PicturePosition=4

	[VisualStyles]
	Path=%SystemRoot%\Resources\Themes\Aero\AeroLite.msstyles
	ColorStyle=NormalColor
	Size=NormalSize
	AutoColorization=1
	ColorizationColor=0X7F000000
	VisualStyleVersion=10
	HighContrast=3

	[MasterThemeSelector]
	MTSM=RJSPBS

	[Control Panel\Colors]
	ActiveBorder=255 0 0
	ActiveTitle=0 0 128
	AppWorkspace=105 3 69
	Background=64 0 64
	ButtonAlternateFace=69 124 7
	ButtonDkShadow=45 45 45
	ButtonFace=48 22 7
	ButtonHilight=191 0 96
	ButtonLight=106 49 15
	ButtonShadow=255 0 0
	ButtonText=220 220 220
	GradientActiveTitle=164 221 181
	GradientInactiveTitle=128 128 128
	GrayText=166 166 0
	Hilight=45 0 138
	HilightText=0 255 128
	HotTrackingColor=211 67 88
	InactiveBorder=128 0 128
	InactiveTitle=214 214 214
	InactiveTitleText=133 133 133
	InfoText=220 220 220
	InfoWindow=66 66 0
	Menu=128 0 255
	MenuBar=64 0 128
	MenuHilight=0 64 128
	MenuText=230 230 230
	Scrollbar=56 68 71
	TitleText=225 225 225
	Window=30 36 38
	WindowFrame=15 15 15
	WindowText=220 220 220
	ButtonLightText=106 49 15
	MenuHilightText=0 64 128
	), %template%
return


; Test gui code
TestGui:
	menu, dummy1, add, Save, menut
	menu, dummy1, add, Save As, menut
	menu, dummy1, add, blah long item, menut
	menu, dummy1, add
	menu, dummy1, add, Exit, menut

	menu, dummy2, add, Copy, menut
	menu, dummy2, add, Paste, menut
	menu, dummy2, add
	menu, dummy2, add, Poptart, menut
	menu, dummy2, add
	menu, dummy2, add, Settings, menut
	menu, dummy3, add, Help, menut

	menu, dummy3, add, About, menut

	menu, mbar, add, File, :dummy1
	menu, mbar, add, Edit, :dummy2
	menu, mbar, add, `tHelp, :dummy3
	menu, mbar, add, This window only shows what controls look like AFTER the theme is applied, menuh
	menu, mbar, disable, This window only shows what controls look like AFTER the theme is applied
	gui, test: menu, mbar

	gui, test: +theme +ownDialogs -Caption +hwndhTestGui

	;ENABLED
	gui, test: margin, 16, 3
	gui, test: default
	gui, test: add, text, w200, ENABLED STUFF
	gui, test: add, edit, w200, edit aaa bbb ccc
	gui, test: add, edit, w200 r9, Sapiente reprehenderit perspiciatis et in quasi numquam.`nCam neque molestias nihil nam necessitatibus magni.`nExpedita, commodi ex ad nam numquam esse?`nIn, quos quibusdam ipsam dignissimos.`nEsse velit hic impedit quasi?`nEarum at maiores fugit officiis nam, obcaecati?`nCam minima aperiam, molestiae veritatis excepturi accusantium.`nFugiat in, fugiat maxime dolorum minima!`nExplicabo numquam enim vitae aut fugiat!
	gui, test: add, edit, w200, 78
	gui, test: add, UpDown,, 78
	gui, test: add, button, w200, &button
	gui, test: add, button, w200 r2, BUTTON
	gui, test: add, checkbox,, checkbox
	gui, test: add, checkbox, x+0 yp checked, CHECKBOX
	gui, test: add, checkbox, x+0 yp, check
	gui, test: add, radio, xs checked, radio
	gui, test: add, radio, x+0 yp, RADIO
	gui, test: add, radio, x+0 yp, radio radio
	gui, test: add, DropDownList, xm w200 r7, aaa|ddl||ccc|ddd|eee|fff|ggg|hhh|iii
	gui, test: add, ComboBox, w200 r7, aaa|bbb|ccc|combobo||eee|fff|ggg|hhh|iii
	gui, test: add, ListBox, w200 r5, aaa|ListBox|commodi ex ad nam numquam esse|ddd||eee|fff|ggg|hhh|iii

	gui, test: add, link, w200, links: <a id="1">this</a> or <a id="2">thaaaat link</a>
	gui, test: add, hotkey, w200, ^+a

	gui, test: add, slider, w200, 32
	gui, test: add, slider, w200 tickInterval15 toolTip, 80
	gui, test: add, progress, w200, 32
	gui, test: add, progress, w200 backgroundgreen cred, 72
	gui, test: add, progress, w200 -theme, 80

	; DISABLED
	gui, test: add, text, ym w200 disabled section, DISABLED STUFF
	gui, test: add, edit, w200 disabled, edit aaa bbb ccc
	gui, test: add, edit, w200 r9 disabled, Sapiente reprehenderit perspiciatis et in quasi numquam.`nCam neque molestias nihil nam necessitatibus magni.`nExpedita, commodi ex ad nam numquam esse?`nIn, quos quibusdam ipsam dignissimos.`nEsse velit hic impedit quasi?`nEarum at maiores fugit officiis nam, obcaecati?`nCam minima aperiam, molestiae veritatis excepturi accusantium.`nFugiat in, fugiat maxime dolorum minima!`nExplicabo numquam enim vitae aut fugiat!
	gui, test: add, edit, w200 disabled, 78
	gui, test: add, UpDown,, 78
	gui, test: add, button, w200 disabled, &button
	gui, test: add, button, w200 disabled r2, BUTTON
	gui, test: add, checkbox, disabled, checkbox
	gui, test: add, checkbox, x+0 yp disabled checked, CHECKBOX
	gui, test: add, checkbox, x+0 yp disabled, check
	gui, test: add, radio, xs disabled checked, radio
	gui, test: add, radio, x+0 yp disabled, RADIO
	gui, test: add, radio, x+0 yp disabled, radio radio
	gui, test: add, DropDownList, xs w200 disabled r7, aaa|ddl||ccc|ddd|eee|fff|ggg|hhh|iii
	gui, test: add, ComboBox, w200 disabled r7, aaa|bbb|ccc|combobo||eee|fff|ggg|hhh|iii
	gui, test: add, ListBox, w200 disabled r5, aaa|ListBox|commodi ex ad nam numquam esse|ddd||eee|fff|ggg|hhh|iii

	gui, test: add, link, w200 disabled, links: <a id="1">this</a> or <a id="2">thaaaat link</a>
	gui, test: add, hotkey, w200 disabled, ^+a

	gui, test: add, slider, w200 disabled, 32
	gui, test: add, slider, w200 disabled tickInterval15 toolTip, 80
	gui, test: add, progress, w200 disabled, 32
	gui, test: add, progress, w200 disabled backgroundgreen cred, 72
	gui, test: add, progress, w200 disabled -theme, 80

	; ENABLED
	gui, test: add, ListView, ym w200 r5, 78|45678|ENABLED STUFF
	loop, 20
	{
		random, rrr, -78, 152
		lv_add("", rrr, rrr*3, round(rrr*1.77, 2))
	}
	gui, test: add, treeView, w200 r5
	P1 := TV_Add("First parent")
	P1C1 := TV_Add("Parent 1's first child", P1)  ; Specify P1 to be this item's parent.
	P2 := TV_Add("Second parent",, "Expand")
	P2C1 := TV_Add("Parent 2's first child", P2)
	P2C2 := TV_Add("Parent 2's second child", P2)
	P2C2C1 := TV_Add("Child 2's first child", P2C2)

	gui, test: add, GroupBox, w200 r4 section, GroupBox yo
	gui, test: add, dateTime, xs+10 ys+20 w180

	gui, test: add, tab, w200 r5 y+80 vtab1, aaa||bbb|ccc|ddd
	gui, test: tab, aaa
	gui, test: add, button, xp+10 yp+30 w100 r2, beep`nboop
	gui, test: tab

	; DISABLED
	gui, test: add, ListView, ym w200 disabled r5, 78|45678|DISABLED STUFF
	loop, 20
	{
		random, rrr, -78, 152
		lv_add("", rrr, rrr*3, round(rrr*1.77, 2))
	}
	gui, test: add, treeView, w200 disabled r5
	P1 := TV_Add("First parent")
	P1C1 := TV_Add("Parent 1's first child", P1)  ; Specify P1 to be this item's parent.
	P2 := TV_Add("Second parent",, "Expand")
	P2C1 := TV_Add("Parent 2's first child", P2)
	P2C2 := TV_Add("Parent 2's second child", P2)
	P2C2C1 := TV_Add("Child 2's first child", P2C2)

	gui, test: add, GroupBox, w200 disabled r4 section, GroupBox yo
	gui, test: add, dateTime, xs+10 ys+20 w180 disabled

	gui, test: add, tab, w200 disabled r5 y+80, aaa|bbb|ccc||ddd
	gui, test: tab, ccc
	gui, test: add, button, xp+10 yp+30 w100 r2 disabled, ccc tab`nbutton
	gui, test: tab

	gui, test: add, StatusBar,,
	SB_setParts(100,100)
	SB_setText("status bar", 1)
	SB_setText("`t`tright status bar", 2)
	SB_setText("`tcenter status bar", 3)
	guiControlGet, pos, test: pos, tab1
return

testguiClose:
testguiEscape:
	return

menut:
	msgBox, 35, msgbox title, You clicked %A_thisMenuItem%`nFrom: %A_thisMenu%
return


;                        -----------------------------
;                        -----------------------------
;                        --------- FUNCTIONS ---------
;                        -----------------------------
;                        -----------------------------


getColor(item)
{
	global cpColors
	if (cpColors[item, "mode"]=1)
		return cpColors[item, "fg"]
	return cpColors[item, "bg"]
}

changeColor(ctrl, fg, bg)
{
	CtlColors.Change(h%ctrl%t, rgbToHex(bg), rgbToHex(fg))
}


rgbToHex(rrrgggbbb, delim:=" ")
{
	for k, v in strSplit(rrrgggbbb, delim)
		if (v!="")
			out.=format("{:02x}", clamp(v, 0, 255))
	return out
}

hexToRGB(rrggbb, delim:=" ")
{
	loop, 3
		out.=format("{:d}", "0x" subStr(rrggbb, (A_index=1) ? A_index : A_index+A_index-1, 2)) . delim
	return rtrim(out, delim)
}

clamp(num, min="", max="")
{
	return ((num<min && min!="") ? min : (num>max && max!="") ? max : num)
}

rand(max=100, min=1)
{
	if (min>max)
		t:=max, max:=min, min:=t
	random, r, %min%, %max%
	return r
}

somewhatAccurateBrightnessShift(hex, lum=10, mode=2) 
{
	for k, val in [substr(hex, 3, 2), substr(hex, 5, 2), substr(hex, 7, 2)] ; split the hex into an array of [##,##,##]
		val:=format("{1:d}", "0x" val) ; convert from hex, to decimal values
		, val:=round((mode=1) ? val*lum : val+lum) ; do the math
		, val:=(val<0) ? 0 : (val>255) ? 255 : val ; clamp the values between 0 and 255
		, out.=format("{1:02}", format("{1:x}", val)) ; build it again, make sure each hex thing is 2 chars long
	return out ; we're done!
}

; "false" turns it on, "true" turns it off. it's weird.
CrossHair(OnOff=1) {   ; INIT = "I","Init"; OFF = 0,"Off"; TOGGLE = -1,"T","Toggle"; ON = others
    static AndMask, XorMask, $, h_cursor
        ,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13 ; system cursors
        , b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13   ; blank cursors
        , h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13   ; handles of default cursors
    if (OnOff = "Init" or OnOff = "I" or $ = "") {      ; init when requested or at first call
        $ := "h"                                          ; active default cursors
        , VarSetCapacity( h_cursor,4444, 1 )
        , VarSetCapacity( AndMask, 32*4, 0xFF )
        , VarSetCapacity( XorMask, 32*4, 0 )
        , system_cursors := "32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650"
        StringSplit c, system_cursors, `,
        Loop, %c0%
            h_cursor   := DllCall( "LoadCursor", "uint",0, "uint",c%A_Index% )
            , h%A_Index% := DllCall( "CopyImage",  "uint",h_cursor, "uint",2, "int",0, "int",0, "uint",0 )
            , b%A_Index% := DllCall("LoadCursor", "Uint", "", "Int", IDC_CROSS := 32515, "Uint")
    }
    $ := (OnOff = 0 || OnOff = "Off" || $ = "h" && (OnOff < 0 || OnOff = "Toggle" || OnOff = "T")) ? "b" : "h"

    Loop, %c0%
        h_cursor := DllCall( "CopyImage", "uint",%$%%A_Index%, "uint",2, "int",0, "int",0, "uint",0 )
        , DllCall( "SetSystemCursor", "uint",h_cursor, "uint",c%A_Index% )
}

Dlg_Color(Color,hwnd){
    static
    if !cc{
        VarSetCapacity(CUSTOM,16*A_PtrSize,0),cc:=1,size:=VarSetCapacity(CHOOSECOLOR,9*A_PtrSize,0)
        Loop,16{
            IniRead,col,color.ini,color,%A_Index%,0
            NumPut(col,CUSTOM,(A_Index-1)*4,"UInt")
        }
    }
    NumPut(size,CHOOSECOLOR,0,"UInt"),NumPut(hwnd,CHOOSECOLOR,A_PtrSize,"UPtr")
    ,NumPut(Color,CHOOSECOLOR,3*A_PtrSize,"UInt"),NumPut(3,CHOOSECOLOR,5*A_PtrSize,"UInt")
    ,NumPut(&CUSTOM,CHOOSECOLOR,4*A_PtrSize,"UPtr")
    ret:=DllCall("comdlg32\ChooseColor","UPtr",&CHOOSECOLOR,"UInt")
    if !ret
    exit
    Loop,16
    IniWrite,% NumGet(custom,(A_Index-1)*4,"UInt"),color.ini,color,%A_Index%
    IniWrite,% Color:=NumGet(CHOOSECOLOR,3*A_PtrSize,"UInt"),color.ini,default,color
    return Color
}
rgb(c){
    setformat,IntegerFast,H
    c:=(c&255)<<16|(c&65280)|(c>>16),c:=SubStr(c,1)
    SetFormat,IntegerFast,D
    return substr(c,3)
}


loadPrev:
	#include %A_ScriptDir%\lib\prev.ahk
return

#include %A_ScriptDir%\lib\controlcolors.ahk
