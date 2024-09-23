#!/usr/bin/env wish
package require Tk

proc runScript{USB} {
set script "ghistory.js"
set command "node $script $USB"

if { [catch {exec {*}$command} result]} {
tk_messageBox -icon error -message "ghistory not working: $result"}

else{tk_messageBox -icon info -message "Script worked: $result"}
}

wm title .msg "History Collector"

ttk::combobox .selectUSB -state readonly .selectUSB set "Select USB"
set pathway [glob -nocomplain -directory /Volumes *] .selectUSB configure -values $pathway

button .runButton -text "Enter" -command {set selectedUSB [.pathway get]
	if {$selectedUSB ne "Select USB"}{
		runScript $selectedUSB
	}else{
		tk_messageBox -icon warning -message "error select usb"
	}
}

pack .selectUSB
pack .runButton
