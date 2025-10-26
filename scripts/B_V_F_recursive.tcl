cd [file join $INITIAL_DIRECTORY "sources" "MSS"]
if {[catch {exec git describe --all --tags --abbrev=8 --long} result]} {
    puts "Error: $result"
} else {
    puts "-----------------------------------------------------------"
    puts "Running MSS module version: $result"
    puts "-----------------------------------------------------------"
}
cd $local_dir

import_mss_component -file $MSS_COMPONENT_PATH
set mss_component_name [file rootname [file tail $MSS_COMPONENT_PATH]]
puts "MSS filename: $mss_component_name"


safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "scripts" "hdl_source.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "clocks_and_resets" "CORERESET_0.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "clocks_and_resets" "INIT_MONITOR.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "clocks_and_resets" "FPGA_CCC_C0.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "FIC0_INITIATOR.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "clocks_and_resets" "CLK_DIV.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "clocks_and_resets" "GLITCHLESS_MUX.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "clocks_and_resets" "TRANSMIT_PLL.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "clocks_and_resets" "PCIE_REF_CLK.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "FIC3_INITIATOR.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "clocks_and_resets" "OSCILLATOR_160MHz.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "clocks_and_resets" "ADC_MCLK_CCC.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "clocks_and_resets" "CLOCKS_AND_RESETS.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "MIV_IHC_C0.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "BVF_RISCV_SUBSYSTEM.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "ADAPTER.tcl"]
safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "components" "BVF_GATEWARE.tcl"]

#
# // Ensure no open-ended AXI4 BIF
#
if {[info exists AXI_STOP_CAP]} {
    safe_source [file join $INITIAL_DIRECTORY "sources" "MSS" "scripts" "axi_stop_cap.tcl"]
}

set_root -module ${top_level_name}::work