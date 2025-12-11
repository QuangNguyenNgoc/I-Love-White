;**********************************************************************************
; Image Tracker - GDI+ Image Search Wrapper
;**********************************************************************************

class ImageTracker {
    ; Cache for loaded bitmaps
    static bitmaps := Map()
    
    ; Load a bitmap from file and cache it
    static LoadBitmap(name, path) {
        if !FileExist(path) {
            LogError("Bitmap not found: " path)
            return false
        }
        
        pBM := Gdip_CreateBitmapFromFile(path)
        if !pBM {
            LogError("Failed to load bitmap: " path)
            return false
        }
        
        this.bitmaps[name] := pBM
        LogDebug("Loaded bitmap: " name)
        return true
    }
    
    ; Load all bitmaps from a directory
    static LoadDirectory(dir, prefix := "") {
        count := 0
        Loop Files dir "\*.png" {
            name := prefix . StrReplace(A_LoopFileName, ".png", "")
            if this.LoadBitmap(name, A_LoopFilePath)
                count++
        }
        LogInfo("Loaded " count " bitmaps from " dir)
        return count
    }
    
    ; Search for an image on screen
    ; Returns: {found: bool, x: int, y: int}
    static Search(name, variation := 20, region := "") {
        global windowX, windowY, windowWidth, windowHeight
        
        if !this.bitmaps.Has(name) {
            LogError("Bitmap not cached: " name)
            return {found: false, x: 0, y: 0}
        }
        
        ; Determine search region
        if region = "" {
            x1 := 0, y1 := 0
            x2 := windowWidth, y2 := windowHeight
        } else if region = "top" {
            x1 := 0, y1 := 0
            x2 := windowWidth, y2 := windowHeight // 2
        } else if region = "bottom" {
            x1 := 0, y1 := windowHeight // 2
            x2 := windowWidth, y2 := windowHeight
        } else if region = "left" {
            x1 := 0, y1 := 0
            x2 := windowWidth // 2, y2 := windowHeight
        } else if region = "right" {
            x1 := windowWidth // 2, y1 := 0
            x2 := windowWidth, y2 := windowHeight
        }
        
        ; Capture screen
        pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY "|" windowWidth "|" windowHeight)
        if !pBMScreen {
            LogError("Failed to capture screen")
            return {found: false, x: 0, y: 0}
        }
        
        ; Search
        result := Gdip_ImageSearch(pBMScreen, this.bitmaps[name], &pos, x1, y1, x2, y2, variation)
        
        ; Cleanup
        Gdip_DisposeImage(pBMScreen)
        
        if result = 1 {
            coords := StrSplit(pos, ",")
            return {found: true, x: Integer(coords[1]), y: Integer(coords[2])}
        }
        
        return {found: false, x: 0, y: 0}
    }
    
    ; Search and click if found
    static SearchAndClick(name, variation := 20, region := "", delay := 100) {
        global windowX, windowY
        
        result := this.Search(name, variation, region)
        if result.found {
            ; Click at found position (center of image)
            MouseClick "Left", windowX + result.x, windowY + result.y
            Sleep delay
            return true
        }
        return false
    }
    
    ; Dispose all cached bitmaps
    static Dispose() {
        for name, pBM in this.bitmaps {
            Gdip_DisposeImage(pBM)
        }
        this.bitmaps.Clear()
        LogInfo("Disposed all cached bitmaps")
    }
}
