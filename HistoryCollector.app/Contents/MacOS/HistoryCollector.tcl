#!/usr/bin/env wish
package require Tk 

proc runScript {USB} {

set nodeScript "ghistory.js"
set command "node $nodeScript $USB"

if { [catch {exec {*}$command} result] } {
    tk_messageBox -icon error -message "Lets see Error running nodejs: $result"
}else{
	tk_messageBox -icon info -message "Script worked: $result"
}
}
wm title . "History Collector"
ttk::combobox .selectUSB -state readonly 
.selectUSB set "Select USB"

set USBDev [glob -nocomplain -directory /Volumes *]
.selectUSB configure -values $USBDev

button .runButton -text "Enter" -command {
	set selectedUSB [.selectUSB get]
	if {$selectedUSB eq "Select USB"}{
		tk_messageBox -icon warning -message "plz select USB"
	}else{
	runScript $selectedUSB
	}

}

pack .selectUSB
pack .runButton
vwait forever
