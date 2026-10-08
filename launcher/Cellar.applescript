-- Cellar.app: opens Windows Excel from the Dock, Launchpad, or Finder's "Open With".

property cellarCLI : (POSIX path of (path to home folder)) & "Library/Application Support/Cellar/bin/cellar"

on run
	launchExcel({})
end run

on open droppedFiles
	launchExcel(droppedFiles)
end open

on launchExcel(fileList)
	set cli to quoted form of cellarCLI
	try
		set state to do shell script cli & " status"
	on error
		set state to "no-bottle"
	end try

	if state is "no-bottle" then
		display dialog "Cellar needs to create its Windows bottle first. This takes about a minute." buttons {"Cancel", "Set Up"} default button "Set Up" with title "Cellar"
		runInTerminal(cli & " setup")
		return
	end if

	if state is "no-excel" then
		display dialog "Excel isn't installed in the bottle yet. Choose your Office installer (setup.exe, .iso, or .img)." buttons {"Cancel", "Choose Installer…"} default button 2 with title "Cellar"
		set installer to choose file with prompt "Choose your Office installer"
		runInTerminal(cli & " install " & quoted form of POSIX path of installer)
		return
	end if

	set args to ""
	repeat with f in fileList
		set args to args & " " & quoted form of POSIX path of f
	end repeat
	do shell script cli & " run" & args & " > /dev/null 2>&1 &"
end launchExcel

on runInTerminal(command)
	tell application "Terminal"
		activate
		do script command
	end tell
end runInTerminal
