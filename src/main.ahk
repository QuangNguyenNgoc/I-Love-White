;**********************************************************************************
; White Macro BSS - Main Entry Point
; Version: 0.1.0
;**********************************************************************************

#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; INCLUDES
; ============================================================================
#Include "..\lib\Gdip_All.ahk"
#Include "..\lib\Gdip_ImageSearch.ahk"
#Include "..\lib\JSON.ahk"
#Include "..\lib\Roblox.ahk"
#Include "..\lib\HyperSleep.ahk"

#Include "core\image-tracker.ahk"
#Include "core\screen-capture.ahk"
#Include "utils\logger.ahk"
#Include "utils\config.ahk"

; ============================================================================
; GLOBAL VARIABLES
; ============================================================================
global pToken := 0                    ; GDI+ token
global windowX := 0, windowY := 0     ; Roblox window position
global windowWidth := 0, windowHeight := 0
global isRunning := false
global config := Map()
global stats := Map()

; ============================================================================
; INITIALIZATION
; ============================================================================
Init() {
    global pToken
    
    ; Start GDI+
    pToken := Gdip_Startup()
    if !pToken {
        MsgBox "Không thể khởi tạo GDI+!", "Error", "Icon!"
        ExitApp
    }
    
    ; Load config
    LoadConfig()
    
    ; Initialize stats
    stats["sessionStart"] := A_Now
    stats["honey"] := 0
    stats["honeyRate"] := 0
    
    LogInfo("White Macro BSS initialized!")
}

; ============================================================================
; MAIN LOOP
; ============================================================================
MainLoop() {
    global isRunning
    
    while isRunning {
        ; Check if Roblox is running
        if !GetRobloxHWND() {
            LogWarn("Roblox not found!")
            Sleep 1000
            continue
        }
        
        ; Update window position
        GetRobloxClientPos()
        
        ; TODO: Add stat tracking logic here
        ; - Capture screen
        ; - Search for stat images
        ; - Calculate rates
        ; - Export data
        
        Sleep 100  ; Main loop interval
    }
}

; ============================================================================
; HOTKEYS
; ============================================================================

; F1 - Start/Stop tracking
F1::{
    global isRunning
    isRunning := !isRunning
    
    if isRunning {
        LogInfo("Tracking started!")
        MsgBox "Tracking started!", "Info", "Iconi T2"
        MainLoop()
    } else {
        LogInfo("Tracking stopped!")
        MsgBox "Tracking stopped!", "Info", "Iconi T2"
    }
}

; F2 - Take screenshot (for testing)
F2::{
    global windowX, windowY, windowWidth, windowHeight
    if GetRobloxHWND() {
        GetRobloxClientPos()
        pBM := Gdip_BitmapFromScreen(windowX "|" windowY "|" windowWidth "|" windowHeight)
        savePath := A_ScriptDir "\..\data\screenshot_" A_Now ".png"
        Gdip_SaveBitmapToFile(pBM, savePath)
        Gdip_DisposeImage(pBM)
        LogInfo("Screenshot saved: " savePath)
        MsgBox "Screenshot saved!`n" savePath, "Success", "Iconi T2"
    } else {
        LogWarn("Roblox not found!")
        MsgBox "Roblox not found!", "Warning", "Icon! T2"
    }
}

; ESC - Exit application
Esc::{
    global pToken
    Gdip_Shutdown(pToken)
    LogInfo("White Macro BSS closed!")
    ExitApp
}

; ============================================================================
; START
; ============================================================================
Init()
MsgBox "White Macro BSS`n`nF1 - Start/Stop tracking`nF2 - Screenshot`nESC - Exit", "Ready!", "Iconi"
