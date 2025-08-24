-- Function to log to a file
on logMessage(msg)
    set safeMsg to my escapeSingleQuotes(msg)
    set timestamp to do shell script "date '+%Y-%m-%d %H:%M:%S'"
    do shell script "echo '[ " & timestamp & " ] " & safeMsg & "' >> deploy.log"
end logMessage

-- Escape single quotes for shell logging
on escapeSingleQuotes(txt)
    set AppleScript's text item delimiters to "'"
    set parts to every text item of txt
    set AppleScript's text item delimiters to "'\\''"
    set escaped to parts as string
    set AppleScript's text item delimiters to ""
    return escaped
end escapeSingleQuotes

-- Wireless deployment script for Filebrowser iOS app
on run argv
    if (count of argv) < 2 then
        display dialog "Usage: osascript deploy.scpt <workspace‑path> <device‑name>"
        return
    end if
    set projectPath to item 1 of argv
    set targetDevice to item 2 of argv

    logMessage("Starting wireless deployment...")

    -- Activate Xcode and open project
    logMessage("Activating Xcode...")
    tell application "Xcode"
        activate
        delay 2

        -- Open the project
        try
            open projectPath
        on error
            display dialog "Failed to open Xcode project. Please check the path."
            return
        end try
        delay 5
    end tell

    logMessage("Xcode project opened.")

    -- Ensure project window is frontmost
    logMessage("Focusing Xcode window...")
    tell application "System Events"
        tell process "Xcode"
            set frontmost to true
        end tell
    end tell

    -- Select wireless device
    logMessage("Selecting target device: " & targetDevice)
    tell application "System Events"
        tell process "Xcode"
            try
                click menu button 1 of toolbar of window 1
                delay 1
                click menu item targetDevice of menu 1 of menu button 1 of toolbar of window 1
                delay 2
            on error
                display dialog "Failed to select target device. Please check the device name."
                return
            end try
        end tell
    end tell

    -- Trigger build/run
    logMessage("Running the project via Product > Run...")
    tell application "System Events"
        tell process "Xcode"
            try
                click menu item "Run" of menu "Product" of menu bar 1
            on error
                display dialog "Failed to trigger Run. Please check Xcode state."
                return
            end try
        end tell
    end tell

    -- Handle Replace dialog if shown
    logMessage("Checking for Replace dialog...")
    delay 3
    tell application "System Events"
        tell process "Xcode"
            try
                if exists (window 1 whose name contains "Replace") then
                    click button "Replace" of window 1
                    logMessage("Clicked Replace in dialog.")
                end if
            end try
        end tell
    end tell

    -- Wait for build to start
    logMessage("Waiting for build to complete and app to start...")
    set timeoutSeconds to 90
    set elapsed to 0
    set buildStarted to false

    repeat until buildStarted or (elapsed > timeoutSeconds)
        delay 1
        set elapsed to elapsed + 1
        try
            tell application "System Events"
                tell process "Xcode"
                    set stopEnabled to enabled of menu item "Stop" of menu "Product" of menu bar 1
                    if stopEnabled is true then
                        set buildStarted to true
                    end if
                end tell
            end tell
        on error
            -- menu not available yet, keep looping
        end try
    end repeat

    -- Stop session and notify result
    if buildStarted then
        logMessage("App is running. Stopping debug session via Product > Stop...")
        delay 5
        tell application "System Events"
            tell process "Xcode"
                click menu item "Stop" of menu "Product" of menu bar 1
            end tell
        end tell
        display notification "App successfully deployed to device!" with title "Deployment Complete"
        logMessage("Deployment complete.")
    else
        display dialog "Build may have failed. Please check Xcode for errors."
        logMessage("Build timeout or failure.")
    end if

    logMessage("Force quitting Xcode...")
    delay 2
    do shell script "pkill -9 Xcode"
end run
