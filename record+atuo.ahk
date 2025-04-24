#SingleInstance Force
#MaxThreadsPerHotkey 2
SetBatchLines -1
SetMouseDelay -1

; Global vars
global isRecording := false
global isPlaying := false
global Toggle := false
global movements := []
global currentIndex := 1
global clickStates := []
global clickPoints := []

F1::  ; Start recording
isRecording := true
movements := []
clickStates := []
clickPoints := []
currentIndex := 1
SetTimer, RecordMouse, 10
return

F2::  ; Stop recording
isRecording := false
SetTimer, RecordMouse, Off
return

F3::  ; Start playback
if (!isPlaying) {
   isPlaying := true
   currentIndex := 1
   SetTimer, PlaybackMouse, 10
}
return

F4::  ; Stop playback
isPlaying := false
SetTimer, PlaybackMouse, Off
Toggle := false
return

F5::  ; Toggle auto-clicking
Toggle := !Toggle
if (isRecording) {
   clickStates.Push([currentIndex, Toggle])
}
if (Toggle) {
   SetTimer, FastClick, -1
} else {
   SetTimer, FastClick, Off
}
return

~LButton::  ; Record clicks
if (isRecording) {
   MouseGetPos, clickX, clickY
   clickPoints.Push([currentIndex, clickX, clickY])
}
return

RecordMouse:
MouseGetPos, xpos, ypos
movements.Push([xpos, ypos])
return

PlaybackMouse:
if (!isPlaying)
   return
if (currentIndex > movements.Length()) {
   currentIndex := 1
   clickStates := []
}
if (movements.Length() > 0) {
   ; Check for recorded clicks
   For index, clickPoint in clickPoints {
       if (clickPoint[1] = currentIndex) {
           MouseMove, % clickPoint[2], % clickPoint[3], 0
           Click
       }
   }
   
   ; Check auto-click state
   For index, clickState in clickStates {
       if (clickState[1] = currentIndex) {
           Toggle := clickState[2]
           if (Toggle)
               SetTimer, FastClick, -1
           else
               SetTimer, FastClick, Off
       }
   }
   
   pos := movements[currentIndex]
   MouseMove, pos[1], pos[2], 0
   currentIndex++
}
return

FastClick:
while (Toggle) {
   Click
   Sleep 50  ; Increased delay to 50ms for slower clicking
}
return

; Universal stop keys
~*a::
~*b::
~*c::
~*d::
~*e::
~*f::
~*g::
~*h::
~*i::
~*j::
~*k::
~*l::
~*m::
~*n::
~*o::
~*p::
~*q::
~*r::
~*s::
~*t::
~*u::
~*v::
~*w::
~*x::
~*y::
~*z::
~*1::
~*2::
~*3::
~*4::
~*5::
~*6::
~*7::
~*8::
~*9::
~*0::
~*Space::
~*Enter::
~*Tab::
~*Esc::
Toggle := false
SetTimer, FastClick, Off
return