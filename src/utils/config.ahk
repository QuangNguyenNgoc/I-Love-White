;**********************************************************************************
; Config - Configuration management
;**********************************************************************************

global CONFIG_FILE := "data\config.json"

; Load configuration from JSON file
LoadConfig() {
    global config, CONFIG_FILE
    
    if !FileExist(CONFIG_FILE) {
        ; Create default config
        config := Map(
            "updateInterval", 100,
            "screenshotOnStart", false,
            "logLevel", "INFO",
            "trackHoney", true,
            "trackPollen", true,
            "autoKeys", Map(
                "enabled", false,
                "interval", 1000
            )
        )
        SaveConfig()
        LogInfo("Created default config file")
        return
    }
    
    try {
        jsonStr := FileRead(CONFIG_FILE)
        config := JSON.parse(jsonStr)
        LogInfo("Config loaded successfully")
    } catch as e {
        LogError("Failed to load config: " e.Message)
        config := Map()
    }
}

; Save configuration to JSON file
SaveConfig() {
    global config, CONFIG_FILE
    
    try {
        jsonStr := JSON.stringify(config, 2)
        FileDelete CONFIG_FILE
        FileAppend jsonStr, CONFIG_FILE
        LogInfo("Config saved successfully")
        return true
    } catch as e {
        LogError("Failed to save config: " e.Message)
        return false
    }
}

; Get a config value with default
GetConfig(key, default := "") {
    global config
    return config.Has(key) ? config[key] : default
}

; Set a config value
SetConfig(key, value) {
    global config
    config[key] := value
}
