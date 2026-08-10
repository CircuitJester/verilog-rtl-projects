# Project 18 – Simulation and Synthesis Commands

## GTKWave

### Interrupt Request Register

```bash
iverilog -o build/interrupt_request_register.out RTL/interrupt_request_register.v tb/tb_interrupt_request_register.v
vvp build/interrupt_request_register.out
gtkwave waves/interrupt_request_register.vcd
```

### Interrupt Mask Register

```bash
iverilog -o build/interrupt_mask_register.out RTL/interrupt_mask_register.v tb/tb_interrupt_mask_register.v
vvp build/interrupt_mask_register.out
gtkwave waves/interrupt_mask_register.vcd
```

### Interrupt Priority Encoder

```bash
iverilog -o build/interrupt_priority_encoder.out RTL/interrupt_priority_encoder.v tb/tb_interrupt_priority_encoder.v
vvp build/interrupt_priority_encoder.out
gtkwave waves/interrupt_priority_encoder.vcd
```

### Interrupt Controller FSM

```bash
iverilog -o build/interrupt_controller_fsm.out RTL/interrupt_controller_fsm.v tb/tb_interrupt_controller_fsm.v
vvp build/interrupt_controller_fsm.out
gtkwave waves/interrupt_controller_fsm.vcd
```

### Interrupt Controller Top-Level

```bash
iverilog -o build/interrupt_controller_top.out RTL/*.v tb/tb_interrupt_controller_top.v
vvp build/interrupt_controller_top.out
gtkwave waves/interrupt_controller_top.vcd
```

## Yosys

### Interrupt Request Register

```bash
rm -f synth/schematics/interrupt_request_register.dot
rm -f synth/schematics/interrupt_request_register.svg
rm -f synth/netlists/interrupt_request_register_netlist.v
yosys synth/scripts/synth_interrupt_request_register.ys
rm -f synth/schematics/interrupt_request_register.dot
```

### Interrupt Mask Register

```bash
rm -f synth/schematics/interrupt_mask_register.dot
rm -f synth/schematics/interrupt_mask_register.svg
rm -f synth/netlists/interrupt_mask_register_netlist.v
yosys synth/scripts/synth_interrupt_mask_register.ys
rm -f synth/schematics/interrupt_mask_register.dot
```

### Interrupt Priority Encoder

```bash
rm -f synth/schematics/interrupt_priority_encoder.dot
rm -f synth/schematics/interrupt_priority_encoder.svg
rm -f synth/netlists/interrupt_priority_encoder_netlist.v
yosys synth/scripts/synth_interrupt_priority_encoder.ys
rm -f synth/schematics/interrupt_priority_encoder.dot
```

### Interrupt Controller FSM

```bash
rm -f synth/schematics/interrupt_controller_fsm.dot
rm -f synth/schematics/interrupt_controller_fsm.svg
rm -f synth/netlists/interrupt_controller_fsm_netlist.v
yosys synth/scripts/synth_interrupt_controller_fsm.ys
rm -f synth/schematics/interrupt_controller_fsm.dot
```

### Interrupt Controller Top-Level

```bash
rm -f synth/schematics/interrupt_controller_top.dot
rm -f synth/schematics/interrupt_controller_top.svg
rm -f synth/netlists/interrupt_controller_top_netlist.v
yosys synth/scripts/synth_interrupt_controller_top.ys
rm -f synth/schematics/interrupt_controller_top.dot
```
