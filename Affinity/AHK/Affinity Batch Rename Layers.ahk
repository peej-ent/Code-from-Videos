; =====================================
; Affinity Layer Batch Rename (Auto)
; =====================================
; F8   = set base name
; F11  = set how many layers to auto-rename
; F9   = START auto-rename (after setting amount)
; F10  = retry last rename (if it failed)
; ESC  = kill script / stop auto-rename
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

; Retry last rename (if something went wrong)
F10::
if (baseName = "" || counter <= 1)
{
    MsgBox, Nothing to retry yet.
    return
}
counter--
Gosub, DoRename
return

; Set batch amount (doesn't start yet)
F11::
InputBox, batchCount, Set Batch Amount, How many layers to rename?, , 300, 150, , , , , %batchCount%
if (batchCount = "" || batchCount < 1)
    batchCount := 50
MsgBox, Batch amount set to %batchCount% layers.`n`nClick on first layer, then press F9 to start!
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
return

; The actual rename logic
DoRename:
; Create padded number (e.g., 001, 002, 003)
numStr := SubStr("000" . counter, -(padding - 1))
newName := baseName . "_" . numStr

; Select all text in the rename field
Send, ^a
Sleep, 80

; Type the new name slowly and reliably
SendRaw, %newName%
Sleep, 100

; Move to next layer (Tab commits the rename automatically in Affinity)
Send, {Tab}
Sleep, 120

counter++
return