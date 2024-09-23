#!/usr/bin/env wish

package require Tk

# Procedure to run the script
proc runScript {USB} {
    set script "/path/to/ghistory.js" ;# Use absolute path
    if {![file exists $script]} {
        tk_messageBox -icon error -message "Script not found at $script"
        return
    }
    
    set command "node $script $USB"
    
    # Use catch to handle errors during execution
    if {[catch {exec $command} result]} {
        # Get additional error info
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

# Configure the combobox with the volumes
.selectUSB configure -values $pathway

# Create a button to run the script
button .runButton -text "Enter" -command {
    # Use catch to handle errors in this block
    if {[catch {
        set selectedUSB [.selectUSB get]
        
        # Debugging: Print selected USB for verification
        puts "Selected USB: $selectedUSB"
        
        if {$selectedUSB ne ""} {
            runScript $selectedUSB
        } else {
            tk_messageBox -icon warning -message "Please select a USB device."
        }
    } errMsg]} {
        # Get additional error info
        set errorInfo [info errorstack]
        tk_messageBox -icon error -message "An error occurred: $errMsg\nError Info: $errorInfo"
    }
}

# Pack the widgets
pack .selectUSB
pack .runButton
