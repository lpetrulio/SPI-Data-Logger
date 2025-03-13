set_property PACKAGE_PIN E3 [get_ports clk_in]
set_property IOSTANDARD LVCMOS33 [get_ports clk_in]
create_clock -period 10.000 [get_ports clk_in]  # Defines 100 MHz clock (10 ns period)

## Reset Button
set_property PACKAGE_PIN B9 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## Start Data Logging Button
set_property PACKAGE_PIN B8 [get_ports start]
set_property IOSTANDARD LVCMOS33 [get_ports start]

## SPI for Thermocouple (Read-Only)
set_property PACKAGE_PIN D12 [get_ports miso_tc]
set_property IOSTANDARD LVCMOS33 [get_ports miso_tc]

set_property PACKAGE_PIN B11 [get_ports sclk_tc]
set_property IOSTANDARD LVCMOS33 [get_ports sclk_tc]

set_property PACKAGE_PIN A11 [get_ports cs_tc]
set_property IOSTANDARD LVCMOS33 [get_ports cs_tc]

## SPI for SD Card (Full SPI)
set_property PACKAGE_PIN F3 [get_ports miso_sd]
set_property IOSTANDARD LVCMOS33 [get_ports miso_sd]

set_property PACKAGE_PIN F4 [get_ports mosi_sd]
set_property IOSTANDARD LVCMOS33 [get_ports mosi_sd]

set_property PACKAGE_PIN D3 [get_ports sclk_sd]
set_property IOSTANDARD LVCMOS33 [get_ports sclk_sd]

set_property PACKAGE_PIN D4 [get_ports cs_sd]
set_property IOSTANDARD LVCMOS33 [get_ports cs_sd]

## UART for Debugging
set_property PACKAGE_PIN D10 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
