puts "Running AXI stopper script" 

set workFolder "$project_dir/component/work"
puts "Workfolder: $workFolder"

set xmlContent ""

set drcFiles [glob -nocomplain "$workFolder/*/*_DRC.xml"]

if {[llength $drcFiles]} {
    set unconnectedPinsBySD {}
    
    foreach xmlFilePath $drcFiles {
        set sd_name [file tail [file dirname $xmlFilePath]]
        set xmlFile [open $xmlFilePath r]
        set fileContent [read $xmlFile]
        close $xmlFile
        set xmlLines [split $fileContent "\n"]

        foreach line $xmlLines {
            if {[string match "*Unconnected bus interface pin*" $line]} {
                if {[regexp {Unconnected bus interface pin (.+)</detail>} $line match pin]} {
                    lappend unconnectedPinsBySD [list $sd_name $pin]
                }
            }
        }
    }

    puts "Unconnected bus interface pins (by SmartDesign):"
    foreach pinInfo $unconnectedPinsBySD {
        lassign $pinInfo sd_name pin
        puts "SmartDesign: $sd_name, Pin: $pin"
    }

    set basePins {
        AWREADY
        WREADY
        BID
        BRESP
        BVALID
        ARREADY
        RID
        RDATA
        RRESP
        RLAST
        RVALID
        BUSER
        RUSER
    }

    foreach pinInfo $unconnectedPinsBySD {
        lassign $pinInfo sd_name pin

        if {[regexp {(.+):AXI4mslave(\d+)} $pin match baseName slaveNum]} {
            set slaveName "${baseName}:SLAVE${slaveNum}"

            foreach basePin $basePins {
                set fullPinName "${slaveName}_${basePin}"

                sd_connect_pins_to_constant -sd_name $sd_name -pin_names $fullPinName -value {GND}
                puts "Connected: $fullPinName in $sd_name"
            }

            generate_component -component_name ${sd_name}
            puts "Generated SmartDesign: $sd_name"
        }
    }

    auto_promote_pad_pins -promote_all 1
    save_project

} else {
    puts "No _DRC.xml files found."
}
