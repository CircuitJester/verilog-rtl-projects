# Project 17 – Simulation and Synthesis Commands

## GTKWave

### SPI Chip Select

```bash
iverilog -o build/spi_chip_select.out RTL/spi_chip_select.v tb/tb_spi_chip_select.v
vvp build/spi_chip_select.out
gtkwave waves/spi_chip_select.vcd
```

### SPI Clock Divider

```bash
iverilog -o build/spi_clock_divider.out RTL/spi_clock_divider.v tb/tb_spi_clock_divider.v
vvp build/spi_clock_divider.out
gtkwave waves/spi_clock_divider.vcd
```

### SPI Shift Register

```bash
iverilog -o build/spi_shift_register.out RTL/spi_shift_register.v tb/tb_spi_shift_register.v
vvp build/spi_shift_register.out
gtkwave waves/spi_shift_register.vcd
```

### SPI Master FSM

```bash
iverilog -o build/spi_master_fsm.out RTL/spi_master_fsm.v tb/tb_spi_master_fsm.v
vvp build/spi_master_fsm.out
gtkwave waves/spi_master_fsm.vcd
```

### SPI Master Top-Level

```bash
iverilog -o build/spi_master_top.out RTL/*.v tb/tb_spi_master_top.v
vvp build/spi_master_top.out
gtkwave waves/spi_master_top.vcd
```

## Yosys

### SPI Chip Select

```bash
rm -f synth/schematics/spi_chip_select.dot
rm -f synth/schematics/spi_chip_select.svg
rm -f synth/netlists/spi_chip_select_netlist.v
yosys synth/scripts/synth_spi_chip_select.ys
rm -f synth/schematics/spi_chip_select.dot
```

### SPI Clock Divider

```bash
rm -f synth/schematics/spi_clock_divider.dot
rm -f synth/schematics/spi_clock_divider.svg
rm -f synth/netlists/spi_clock_divider_netlist.v
yosys synth/scripts/synth_spi_clock_divider.ys
rm -f synth/schematics/spi_clock_divider.dot
```

### SPI Master FSM

```bash
rm -f synth/schematics/spi_master_fsm.dot
rm -f synth/schematics/spi_master_fsm.svg
rm -f synth/netlists/spi_master_fsm_netlist.v
yosys synth/scripts/synth_spi_master_fsm.ys
rm -f synth/schematics/spi_master_fsm.dot
```

### SPI Shift Register

```bash
rm -f synth/schematics/spi_shift_register.dot
rm -f synth/schematics/spi_shift_register.svg
rm -f synth/netlists/spi_shift_register_netlist.v
yosys synth/scripts/synth_spi_shift_register.ys
rm -f synth/schematics/spi_shift_register.dot
```

### SPI Master Top-Level

```bash
rm -f synth/schematics/spi_master_top.dot
rm -f synth/schematics/spi_master_top.svg
rm -f synth/netlists/spi_master_top_netlist.v
yosys synth/scripts/synth_spi_master_top.ys
rm -f synth/schematics/spi_master_top.dot
```
