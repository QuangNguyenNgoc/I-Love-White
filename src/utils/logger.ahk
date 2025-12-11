;**********************************************************************************
; Logger - Simple logging utilities
;**********************************************************************************

global LOG_LEVEL := "INFO"  ; DEBUG, INFO, WARN, ERROR
global LOG_FILE := "data\logs\macro.log"

; Internal log function
_Log(level, message) {
    global LOG_LEVEL, LOG_FILE
    
    levels := Map("DEBUG", 0, "INFO", 1, "WARN", 2, "ERROR", 3)
    
    if levels[level] < levels[LOG_LEVEL]
        return
    
    timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
    logLine := "[" timestamp "] [" level "] " message "`n"
    
    ; Print to stdout (for debugging)
    ; OutputDebug logLine
    
    ; Append to log file
    try {
        FileAppend logLine, LOG_FILE
    }
}

; Public logging functions
LogDebug(message) {
    _Log("DEBUG", message)
}

LogInfo(message) {
    _Log("INFO", message)
}

LogWarn(message) {
    _Log("WARN", message)
}

LogError(message) {
    _Log("ERROR", message)
}

; Set log level
SetLogLevel(level) {
    global LOG_LEVEL
    LOG_LEVEL := level
}
