# Project 20 – Yosys Synthesis Commands

## DMA Address Generator

```bash
rm -f synth/schematics/dma_address_generator.dot
rm -f synth/schematics/dma_address_generator.svg
rm -f synth/netlists/dma_address_generator_netlist.v
yosys synth/scripts/synth_dma_address_generator.ys
rm -f synth/schematics/dma_address_generator.dot
```

## DMA Control Register

```bash
rm -f synth/schematics/dma_control_register.dot
rm -f synth/schematics/dma_control_register.svg
rm -f synth/netlists/dma_control_register_netlist.v
yosys synth/scripts/synth_dma_control_register.ys
rm -f synth/schematics/dma_control_register.dot
```

## DMA Controller FSM

```bash
rm -f synth/schematics/dma_controller_fsm.dot
rm -f synth/schematics/dma_controller_fsm.svg
rm -f synth/netlists/dma_controller_fsm_netlist.v
yosys synth/scripts/synth_dma_controller_fsm.ys
rm -f synth/schematics/dma_controller_fsm.dot
```

## DMA Transfer Counter

```bash
rm -f synth/schematics/dma_transfer_counter.dot
rm -f synth/schematics/dma_transfer_counter.svg
rm -f synth/netlists/dma_transfer_counter_netlist.v
yosys synth/scripts/synth_dma_transfer_counter.ys
rm -f synth/schematics/dma_transfer_counter.dot
```

## DMA Top-Level

```bash
rm -f synth/schematics/dma_top.dot
rm -f synth/schematics/dma_top.svg
rm -f synth/netlists/dma_top_netlist.v
yosys synth/scripts/synth_dma_top.ys
rm -f synth/schematics/dma_top.dot
```

