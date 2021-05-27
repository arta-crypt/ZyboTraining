

##########################################################################################
####    I/O Assign
##########################################################################################

# CLK
set_property PACKAGE_PIN K17 [get_ports CLK]
# RST
set_property PACKAGE_PIN Y16 [get_ports RST]
# LED
set_property PACKAGE_PIN M14 [get_ports {LED[0]}]
set_property PACKAGE_PIN M15 [get_ports {LED[1]}]
set_property PACKAGE_PIN G14 [get_ports {LED[2]}]
set_property PACKAGE_PIN D18 [get_ports {LED[3]}]
#Buttons
set_property PACKAGE_PIN K18 [get_ports {BTN[0]}]
set_property PACKAGE_PIN P16 [get_ports {BTN[1]}]

##########################################################################################
####    I/O Level
##########################################################################################

set_property IOSTANDARD LVCMOS33 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports RST]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTN[*]}]

##########################################################################################
####    I/O CURRENT_STRENGTH
##########################################################################################

set_property DRIVE 4 [get_ports {LED[3]}]
set_property DRIVE 4 [get_ports {LED[2]}]
set_property DRIVE 4 [get_ports {LED[1]}]
set_property DRIVE 4 [get_ports {LED[0]}]

##########################################################################################
####    Slew Rate
##########################################################################################

set_property SLEW SLOW [get_ports {LED[*]}]

##########################################################################################
####    instance Setting
##########################################################################################

# fast io
set_property IOB TRUE [get_ports RST]
set_property IOB TRUE [get_ports {LED[*]}]
set_property IOB TRUE [get_ports {BTN[*]}]

# pull up










#**************************************************************
# Virtual Clock
#**************************************************************

create_clock -period 8.000 -name V_SYSCLK_125M -waveform {0.000 4.000}

#**************************************************************
# Create Clock
#**************************************************************

create_clock -period 8.000 -name SYSCLK_125M -waveform {0.000 4.000} [get_ports CLK]

#**************************************************************
# Create Generated Clock
#**************************************************************

#**************************************************************
# Set Clock Groups
#**************************************************************

#**************************************************************
# Set False Path
#**************************************************************

#**************************************************************
# Set Input Delay
#**************************************************************


set_input_delay -clock [get_clocks V_SYSCLK_125M] -max 4.000 [get_ports {BTN[*]}]
set_input_delay -clock [get_clocks V_SYSCLK_125M] -min 0.500 [get_ports {BTN[*]}]
set_input_delay -clock [get_clocks V_SYSCLK_125M] -max 4.000 [get_ports RST]
set_input_delay -clock [get_clocks V_SYSCLK_125M] -min 0.500 [get_ports RST]

#**************************************************************
# Set Output Delay
#**************************************************************


set_output_delay -clock [get_clocks V_SYSCLK_125M] -max 5.000 [get_ports {LED[*]}]
set_output_delay -clock [get_clocks V_SYSCLK_125M] -min -1.000 [get_ports {LED[*]}]
set_multicycle_path -setup -end -from [get_pins {U_LED_PWM/U_PWM/pwm_out_reg[*]/C}] -to [get_ports {LED[*]}] 2
set_multicycle_path -hold -end -from [get_pins {U_LED_PWM/U_PWM/pwm_out_reg[*]/C}] -to [get_ports {LED[*]}] 1


#**************************************************************
# Set Maximum Delay
#**************************************************************

#**************************************************************
# Set Minimum Delay
#**************************************************************


