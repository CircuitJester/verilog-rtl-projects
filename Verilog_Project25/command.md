# Project 25 — Yosys Synthesis Commands

```bash
cd /mnt/e/VLSI_projects_CHIP/Verilog_projects/Verilog_Project25

rm -f synth/schematics/*.dot
rm -f synth/schematics/*.svg
rm -f synth/netlists/*.v

yosys synth/scripts/synth_hazard_detection_unit.ys

rm -f synth/schematics/*.dot
```