-- 
-- This script is part of the SPB Project : http://github.com/henri/spb/
-- It is useful as when you close a window, the program will be left running
-- It would be great if this is reliable to simply have it clean up things in an
-- automated way.
--
-- Suggestions on improving this monstrosorty are very welcome.
-- 
-- Show dialog for any browsers which is detected to not have windows
-- This is a very complext script for what should be simple.
-- Finding programs which are full screen on other spaces on macOS presents challanges
-- If it is possible to simplfy this script that would be great
-- Uses kill -9 PID when Quit is chosen
-- Version History 
--    1.0 - initial release
--
-- 

set browserList to {"Brave Browser", "Chromium", "Google Chrome", "Ungoogled Chromium", "Vivaldi", "Microsoft Edge", "Arc", "Safari", "Firefox", "Pale Moon"}

tell application "System Events"
	set appList to name of every process whose background only is false
	set appCount to count of appList
end tell

display dialog "Checking " & appCount & " running applications..." buttons {"OK"} default button 1

tell application "System Events"
	key code 48 using command down -- Start Command–Tab cycle
	delay 0.3
	
	repeat with i from 1 to appCount
		try
			set frontApp to (name of first process whose frontmost is true)
			set appPID to (unix id of first process whose frontmost is true)
			
			set winCount to 0
			try
				tell process frontApp
					set winCount to count of windows
				end tell
			end try
			
			set childCount to do shell script "pgrep -P " & appPID & " | wc -l | tr -d ' '"
			set childInt to childCount as integer
			
			set possibleWindows to "No"
			if frontApp is in browserList then
				if childInt > 4 or winCount > 0 then set possibleWindows to "Yes"
			else if winCount > 0 then
				set possibleWindows to "Yes"
			end if
			
			-- Only show dialog for browsers
			if frontApp is in browserList and possibleWindows is "No" then
				key up command
				delay 0.1
				
				set userChoice to button returned of (display dialog ¬
					"Application: " & frontApp & return & ¬
					"PID: " & appPID & return & ¬
					"Regular windows: " & winCount & return & ¬
					"Child processes: " & childInt & return & ¬
					"No open windows detected." & return & return & ¬
					"Force quit this browser with kill -9?" buttons {"Skip", "Quit"} default button "Skip")
				
				if userChoice is "Quit" then
					try
						do shell script "kill -9 " & appPID
						delay 0.5
					end try
				end if
				
				key code 48 using command down
				delay 0.3
				
			else
				-- Automatically skip for non-browsers or active windows
				key code 48 using {command down, shift down}
				delay 0.4
			end if
			
		end try
	end repeat
	
	key up command
end tell
