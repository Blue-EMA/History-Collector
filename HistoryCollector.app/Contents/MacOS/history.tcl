#!/usr/bin/env wish

package require Tk

# Procedure to run the script
proc runScript {USB} {
    # Execution
	if {[catch {exec node ghistory.js $USB} result]} {
        # More error info
        set errorInfo [info errorstack]
        tk_messageBox -icon error -message "ghistory not working: $result\nError Info: $errorInfo"
    } else {
        tk_messageBox -icon info -message "Script worked: $result"
    }
}


# Set window title
wm title . "History Collector"

# Create a combobox for USB selection
ttk::combobox .selectUSB -state readonly

# Get the list of mounted volumes
set pathway [glob -nocomplain -directory /Volumes *]

set usbNames {}

foreach volume $pathway {
    lappend usbNames [file tail $volume]
}

puts "extracted usb names $usbNames"
.selectUSB configure -values $usbNames

# Create a button to run the script
button .runButton -text "Enter" -command {
    
    if {[catch {
        set selectedUSB [.selectUSB get]
        
        set usbString [join $selectedUSB " "]
        if {$selectedUSB ne ""} {
            runScript $usbString
            break
        } else {
            tk_messageBox -icon warning -message "Please select a USB device."
        }
    } errMsg]} {
        # more error info
        set errorInfo [info errorstack]
        tk_messageBox -icon error -message "An error occurred: $errMsg\nError Info: $errorInfo"
    }
}

# Pack the widgets
pack .selectUSB
pack .runButton

vwait forever
