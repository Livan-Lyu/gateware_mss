puts "======== Adapter option: QSPI ========"

namespace eval adapter {

    proc remove_pin {name} {

        set sd_name {BVF_RISCV_SUBSYSTEM}

        switch $name {
            "SPI_1_SS1" {
                sd_delete_ports -sd_name ${sd_name} -port_names {SPI_1_SS1}
                sd_delete_instances -sd_name ${sd_name} -instance_names {SPI_1_SS1_BIBUF}
                sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_SS_F2M} -value {GND}
                sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_SS1_M2F}
                sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_SS1_OE_M2F}
            }
            "SPI_1_CLK" {
                sd_delete_ports -sd_name ${sd_name} -port_names {SPI_1_CLK}
                sd_delete_instances -sd_name ${sd_name} -instance_names {SPI_1_CLK_BIBUF}
                sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_CLK_F2M} -value {GND}
                sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_CLK_M2F}
                sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_CLK_OE_M2F}
            }
            "SPI_1_DI" {
                sd_delete_ports -sd_name ${sd_name} -port_names {SPI_1_DI}
                sd_delete_instances -sd_name ${sd_name} -instance_names {SPI_1_DI_BIBUF}
                sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_DI_F2M} -value {GND}
            }
            "SPI_1_DO" {
                sd_delete_ports -sd_name ${sd_name} -port_names {SPI_1_DO}
                sd_delete_instances -sd_name ${sd_name} -instance_names {SPI_1_DO_BIBUF}
                sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_DO_M2F}
                sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_DO_OE_M2F}
            }
            default {
                error "Pin '$name' unknown!"
            }
        }
        puts "Info: Pin '$name' removed."
    }
}

set sd_name {BVF_RISCV_SUBSYSTEM}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0


#-------------------------------------------------------------------------------
# Connect ADC.
#-------------------------------------------------------------------------------

# Add SPI_1_SS1_BIBUF instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {BIBUF} -instance_name {SPI_1_SS1_BIBUF}
sd_connect_pins -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_SS1_OE_M2F SPI_1_SS1_BIBUF:E}
sd_connect_pins -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_SS_F2M SPI_1_SS1_BIBUF:Y}
sd_connect_pins -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_SS1_M2F SPI_1_SS1_BIBUF:D}
sd_connect_pin_to_port -sd_name ${sd_name} -pin_name {SPI_1_SS1_BIBUF:PAD} -port_name {SPI_1_SS1} 

# Add SPI_1_CLK_BIBUF instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {BIBUF} -instance_name {SPI_1_CLK_BIBUF}
sd_connect_pins -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_CLK_OE_M2F SPI_1_CLK_BIBUF:E}
sd_connect_pins -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_CLK_F2M SPI_1_CLK_BIBUF:Y}
sd_connect_pins -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_CLK_M2F SPI_1_CLK_BIBUF:D}
sd_connect_pin_to_port -sd_name ${sd_name} -pin_name {SPI_1_CLK_BIBUF:PAD} -port_name {SPI_1_CLK} 

# Add SPI_1_DI_BIBUF instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {BIBUF} -instance_name {SPI_1_DI_BIBUF}
sd_connect_pins -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_DI_F2M SPI_1_DI_BIBUF:Y}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {SPI_1_DI_BIBUF:D} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {SPI_1_DI_BIBUF:E} -value {GND}
sd_connect_pin_to_port -sd_name ${sd_name} -pin_name {SPI_1_DI_BIBUF:PAD} -port_name {SPI_1_DI} 

# Add SPI_1_DO_BIBUF instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {BIBUF} -instance_name {SPI_1_DO_BIBUF}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {SPI_1_DO_BIBUF:Y}
sd_connect_pins -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_DO_M2F SPI_1_DO_BIBUF:D}
sd_connect_pins -sd_name ${sd_name} -pin_names {PF_SOC_MSS:SPI_1_DO_OE_M2F SPI_1_DO_BIBUF:E}
sd_connect_pin_to_port -sd_name ${sd_name} -pin_name {SPI_1_DO_BIBUF:PAD} -port_name {SPI_1_DO} 

sd_connect_pin_to_port -sd_name ${sd_name} -pin_name {PF_SOC_MSS:GPIO_0_12_OUT} -port_name {SD_CARD_CS}
sd_connect_pin_to_port -sd_name ${sd_name} -pin_name {PF_SOC_MSS:QSPI_SS0} -port_name {ADC_CSn}
sd_connect_pin_to_port -sd_name ${sd_name} -pin_name {PF_SOC_MSS:QSPI_CLK} -port_name {ADC_SCK}
sd_connect_pin_to_port -sd_name ${sd_name} -pin_name {PF_SOC_MSS:QSPI_DATA0} -port_name {ADC_MOSI}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ADC_MISO} -port_direction {INOUT}
sd_connect_pins -sd_name ${sd_name} -pin_names {PF_SOC_MSS:QSPI_DATA1 ADC_MISO}
sd_connect_pins -sd_name ${sd_name} -pin_names {"ADC_IRQn" "PF_SOC_MSS:GPIO_1_20_IN" }



# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1

# Save the smartDesign
save_smartdesign -sd_name ${sd_name}
generate_component -component_name ${sd_name}
