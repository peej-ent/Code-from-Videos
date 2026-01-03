; =====================================
; Affinity Layer Batch Rename (Proper)
; =====================================
; F8   = set base name
; F11  = set how many layers to auto-rename
; F9   = START auto-rename
; ESC  = kill script / stop auto-rename
; =====================================
; Uses Affinity shortcuts:
; Ctrl+Shift+R = Rename layer
; Alt+[        = Previous layer
; =====================================
#NoEnv
#SingleInstance Force
SendMode Event
SetKeyDelay, 30, 30
SetTitleMatchMode, 2

counter := 1
padding := 3
baseName := ""
batchCount := 50
isRunning := false

; Kill switch / Stop auto-rename
Esc::
isRunning := false
ExitApp
return

; Ask for base name ONCE
F8::
InputBox, baseName, Layer Rename, Enter base layer name:
if (baseName = "")
    baseName := "Layer"
counter := 1
MsgBox, Base name set to: %baseName%`n`nF11 = Set batch amount (default: 50)`nF9  = START auto-rename`nESC = Stop
return

; Set batch amount (doesn't start yet)
F11::
InputBox, batchCount, Set Batch Amount, How many layers to rename?, , 300, 150, , , , , %batchCount%
if (batchCount = "" || batchCount < 1)
    batchCount := 50
MsgBox, Batch amount set to %batchCount% layers.`n`nPress F9 to start!
return

; START auto-rename with the set amount
F9::
if (baseName = "")
{
    MsgBox, Press F8 first to set the base name.
    return
}
isRunning := true
Loop, %batchCount%
{
    if (!isRunning)
        break
    Gosub, DoRename
    Sleep, 1000
}
isRunning := false
MsgBox, Finished renaming %batchCount% layers!
return

; The actual rename logic using Affinity shortcuts
DoRename:
; Create padded number (e.g., 001, 002, 003)
numStr := SubStr("000" . counter, -(padding - 1))
newName := baseName . "_" . numStr

; Open rename dialog (Ctrl+Shift+R)
Send, ^+r
Sleep, 150

; Type the new name
SendRaw, %newName%
Sleep, 100

; Confirm with Enter
Send, {Enter}
Sleep, 150

; Go to next layer (Alt+[)
Send, !{[}
Sleep, 150

counter++
return
