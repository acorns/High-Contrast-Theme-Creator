/*
Name: 
Version 1.0 (Saturday, February 25, 2017)
Created: Saturday, February 25, 2017
Author: tidbit
Credit: 

Hotkeys:

Description:

*/



#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #singleInstance, off
#singleInstance, force

menu, dummy1, add, Save, menuh
menu, dummy1, add, Save As, menuh
menu, dummy1, add, blah long item, menuh
menu, dummy1, add
menu, dummy1, add, Exit, menuh

menu, dummy2, add, Copy, menuh
menu, dummy2, add, Paste, menuh
menu, dummy2, add
menu, dummy2, add, Poptart, menuh
menu, dummy2, add
menu, dummy2, add, Settings, menuh
menu, dummy3, add, Help, menuh

menu, dummy3, add, About, menuh

menu, mbar, add, File, :dummy1
menu, mbar, add, Edit, :dummy2
menu, mbar, add, `tHelp, :dummy3
menu, mbar, add, This window only shows what controls look like AFTER the theme is applied, menuh
menu, mbar, disable, This window only shows what controls look like AFTER the theme is applied
gui, test: menu, mbar

gui, test: +theme +ownDialogs

;ENABLED
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
; •Text, Edit, UpDown, Picture
; •Button, Checkbox, Radio
; •DropDownList, ComboBox
; •ListBox, ListView, TreeView
; •Link, Hotkey, DateTime, MonthCal
; •Slider, Progress
; •GroupBox, Tab, StatusBar
guiControlGet, pos, test: pos, tab1

; SysGet, cap, 4
; ttt:=posy+posh+20
; gui, test: add, progress, x%posx% y%ttt% w300 h%cap% section cred, 100
; gui, test: add, text, xp+15 yp w300 h%cap% backgroundTrans 0x200, Inactive Title Text

; gui, test: add, progress, xs+15 y+-5 w300 h%cap% section cblue, 100
; gui, test: add, text, xp+15 yp w300 h%cap% backgroundTrans 0x200, Active Title Text


gui, test: show,, The title of this test window.
msgBox, Dear %A_DDDD%`nHere is a msgbox too.`nSor testing`n`nofcourse
return

testguiClose:
testguiEscape:
	exitapp
return

menuh:
	msgBox, 35, msgbox title, You clicked %A_thisMenuItem%`nFrom: %A_thisMenu%
return