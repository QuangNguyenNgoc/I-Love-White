;**********************************************************************************
; Screen Capture - Utilities for screen capture
;**********************************************************************************

; Capture the entire Roblox window
CaptureRoblox() {
    global windowX, windowY, windowWidth, windowHeight
    
    if !GetRobloxHWND() {
        return 0
    }
    
    GetRobloxClientPos()
    return Gdip_BitmapFromScreen(windowX "|" windowY "|" windowWidth "|" windowHeight)
}

; Capture a specific region of Roblox window
CaptureRegion(x1, y1, x2, y2) {
    global windowX, windowY
    
    absX := windowX + x1
    absY := windowY + y1
    width := x2 - x1
    height := y2 - y1
    
    return Gdip_BitmapFromScreen(absX "|" absY "|" width "|" height)
}

; Save a bitmap to file
SaveBitmap(pBM, filename) {
    if !pBM {
        return false
    }
    
    Gdip_SaveBitmapToFile(pBM, filename)
    return true
}

; Capture and save for debugging
DebugCapture(name := "debug") {
    pBM := CaptureRoblox()
    if pBM {
        filename := "data\logs\" name "_" A_Now ".png"
        SaveBitmap(pBM, filename)
        Gdip_DisposeImage(pBM)
        LogDebug("Debug capture saved: " filename)
        return true
    }
    return false
}
