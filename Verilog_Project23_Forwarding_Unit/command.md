# Project 23 — Yosys Synthesis Commands

```bash
cd /mnt/e/VLSI_projects_CHIP/Verilog_projects/Verilog_Project23_Forwarding_Unit

rm -f synth/schematics/*.dot
rm -f synth/schematics/*.svg
rm -f synth/netlists/*.v

yosys synth/scripts/synth_forwarding_comparator.ys
yosys synth/scripts/synth_forwarding_control_logic.ys
yosys synth/scripts/synth_forwarding_datapath.ys
yosys synth/scripts/synth_forwarding_mux.ys
yosys synth/scripts/synth_forwarding_unit.ys

rm -f synth/schematics/*.dot
```