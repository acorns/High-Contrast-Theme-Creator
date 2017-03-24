/*
Name: 
Version 1.0 (Monday, March 13, 2017)
Created: Monday, March 13, 2017
Author: tidbit
Credit: 

Hotkeys:

Description:

*/

www:=500
hhh:=400
www2:=www//1.5
hhh2:=hhh//2

gui, prev: margin, 3, 3
gui, prev: color, 100xaaaaaa

menu, prevmenu, add, About, pmenu
gui, prev: menu, prevmenu


; inactive
gui, prev: add, progress, xm ym w%www% h32 section c0x454545 background0xffffff vInactiveTitle, 0
gui, prev: add, text, xp+20 yp wp hp 0x200 backgroundTrans vInactiveTitleText, Inactive Window Title
ttt:=www-52
gui, prev: add, progress, x%ttt% yp+1 w50 h30 c0x003400 background0xffffff vInactiveBtn1, 0
ttt:=www-52*2
gui, prev: add, progress, x%ttt% yp w50 hp c0x003400 background0xffffff vInactiveBtn2, 0
ttt:=www-52*3
gui, prev: add, progress, x%ttt% yp w50 hp c0x003400 background0xffffff vInactiveBtn3, 0

; inactive border
gui, prev: add, progress, xs ys+32 w%www% h%hhh2% section c0x606060 background0xffffff vInactiveBorder, 0
ttt:=hhh2-6
ttt2:=www-12
gui, prev: add, progress, xp+6 yp w%ttt2% h%ttt% c0x333333 background0xffffff vInactiveMain, 0

; active
gui, prev: add, progress, xs+30 ys+25 w%www% h32 section c0xff4400 background0xffffff vActiveTitle, 0
gui, prev: add, text, xp+20 yp wp hp 0x200 backgroundTrans vActiveTitleText, Active Window Title
ttt:=www+30-52
gui, prev: add, progress, x%ttt% yp+1 w50 h30 c0xaa3388 background0xffffff vActiveTitleBtn1, 0
ttt:=www+30-52*2
gui, prev: add, progress, x%ttt% yp w50 hp c0xaa3388 background0xffffff vActiveTitleBtn2, 0
ttt:=www+30-52*3
gui, prev: add, progress, x%ttt% yp w50 hp c0xaa3388 background0xffffff vActiveTitleBtn3, 0


; border
gui, prev: add, progress, xs ys+32 w%www% h%hhh% section c0xaa9900 background0xffffff vActiveBorder, 0
guiControlGet, border, prev: pos, ActiveBorder ; the coords of the main draw area

; menubar
www:=www-12 ; chenge the sizes to account for the border
hhh:=hhh-12 ; chenge the sizes to account for the border
gui, prev: add, progress, xp+6 yp w%www% h16 section c0x3322ff background0xffffff vActiveMenu, 0
gui, prev: add, text, xp yp wp hp 0x200 backgroundTrans vActiveText, File   Edit   Help
gui, prev: add, progress, xp y+0 w%www% h2 section c0x3322ff background0xffffff vActiveMenu2, 0

; workarea
ttt:=borderh-16-6 ; -16=menu, -6=border
gui, prev: add, progress, xs y+0 w%www% h%ttt% section c0x336699 background0xffffff vMain, 0
guiControlGet, pos, prev: pos, main ; the coords of the main draw area

; edit box
; gui, prev: add, progress, xs y+0 w%www% h%hhh% section c0x336699 background0xffffff, 0
ttt:=posw//2
ttt2:=posh-30
gui, prev: add, progress, xs+3 ys+3 w%www2% h%ttt2% section c0x996633 background0xffffff vEditBG, 100

; scrollbar
gui, prev: add, progress, x+-16 yp w14 h%ttt2% c0xffffff background0xffffff vScrollMain, 100
gui, prev: add, progress, xp+1 yp+30 w12 h25 c0x343434 background0xffffff vScrollThing, 100

; edit text
ttt:=www2-25
gui, prev: add, text, xs+6 ys+6 w%ttt% backgroundTrans vEditText, 
(join%A_space%
Lorem ipsum dolor sit amet. Caiman jaguar cow himalayan 
javanese caracal whippet turkey snowshoe woodpecker mastiff cockroach.
Gorilla, giraffe collie nightingale capybara those, hedgehog beetle. 
`n`nSoybean those, winter spinach daikon melon much yarrow mustard soko daikon bologi? 
)
; selected text
gui, prev: add, progress, xp y+6 wp cblue c0xffffff background0xffffff vselBG, 0
gui, prev: add, text, xp+2 yp hp 0x200 backgroundTrans vselFG, Selected stuff?! 67228

; edit text
gui, prev: add, text, xs+6 y+6 w%ttt% backgroundTrans, Sea arrrgh cannon head har. South mast curse crew those curse other ashore, brothel sink.
; guiControlGet, selFG, prev: pos
; guiControl, prev: movedraw, selBG, % "x" selFGx-1 " y" selFGy-1 " w" selFGw+4 " h" selFGh

; text
ttt:=www2+posx+8 ;-(14*8)
gui, prev: add, text, x%ttt% ys c0xffffff backgroundTrans vTextEnabled, Text on window
gui, prev: add, text, xp y+3 hp c0xaaaaaa backgroundTrans vTextDisabled, Disabled text on window
gui, prev: add, text, xp y+3 hp c0xaaaaaa backgroundTrans vTextLink, A link to the past

; button
gui, prev: add, progress, xp y+8 w100 h24 c0x335577 background0xffffff vBtn, 100
gui, prev: add, text, xp yp wp hp 0x200 Center backgroundTrans vBtnText, Button
gui, prev: add, progress, xp+10 y+-8 w100 h24 c0x4488aa background0xffffff vBtnH, 100
gui, prev: add, text, xp yp wp hp 0x200 Center backgroundTrans vBtnHText, Button hover

; disabled button
ttt:=www2+posx+8 ;-(14*8)
gui, prev: add, progress, x%ttt% y+3 w100 h24 Background0x676767 vBtnDB, 0
gui, prev: add, progress, xp+1 yp+1 wp-2 hp-2 Background0x454545 vBtnD, 0
gui, prev: add, text, xp yp wp hp center 0x200 c0xffffff backgroundTrans vBtnDText, Disabled Button

return


pmenu:
	gui, prev: +ownDialogs
	msgBox, 64, About this Preview,
	(ltrim join
	This preview is not accurate for ALL windows.
	`nLots of windows handle things like menus and scrollbars differently. Also it seems 
	%a_space%High Contrast themes do not support gradient titles, atleast on win10.
	`nThis preview is just a general idea of what a typical window might look like, but NOT ALL window.

	`n`nMade for Windows 10, no promises about older OS's.
	)
return