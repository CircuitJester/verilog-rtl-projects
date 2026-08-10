# Project 19 – Yosys Synthesis Commands

## Address Decoder

```bash
rm -f synth/schematics/address_decoder.dot
rm -f synth/schematics/address_decoder.svg
rm -f synth/netlists/address_decoder_netlist.v
yosys synth/scripts/synth_address_decoder.ys
rm -f synth/schematics/address_decoder.dot
```

## AXI Read Channel

```bash
rm -f synth/schematics/axi_read_channel.dot
rm -f synth/schematics/axi_read_channel.svg
rm -f synth/netlists/axi_read_channel_netlist.v
yosys synth/scripts/synth_axi_read_channel.ys
rm -f synth/schematics/axi_read_channel.dot
```

## AXI Write Channel

```bash
rm -f synth/schematics/axi_write_channel.dot
rm -f synth/schematics/axi_write_channel.svg
rm -f synth/netlists/axi_write_channel_netlist.v
yosys synth/scripts/synth_axi_write_channel.ys
rm -f synth/schematics/axi_write_channel.dot
```

## Register File

```bash
rm -f synth/schematics/register_file.dot
rm -f synth/schematics/register_file.svg
rm -f synth/netlists/register_file_netlist.v
yosys synth/scripts/synth_register_file.ys
rm -f synth/schematics/register_file.dot
```

## AXI Slave Top-Level

```bash
rm -f synth/schematics/axi_slave_top.dot
rm -f synth/schematics/axi_slave_top.svg
rm -f synth/netlists/axi_slave_top_netlist.v
yosys synth/scripts/synth_axi_slave_top.ys
rm -f synth/schematics/axi_slave_top.dot
```

