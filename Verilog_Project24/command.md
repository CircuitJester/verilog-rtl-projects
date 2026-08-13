# Project 24 — Yosys Synthesis Commands

```bash
cd /mnt/e/VLSI_projects_CHIP/Verilog_projects/Verilog_Project24

rm -f synth/schematics/*.dot
rm -f synth/schematics/*.svg
rm -f synth/netlists/*.v

yosys synth/scripts/synth_if_id_pipeline_register.ys
yosys synth/scripts/synth_id_ex_pipeline_register.ys
yosys synth/scripts/synth_ex_mem_pipeline_register.ys
yosys synth/scripts/synth_mem_wb_pipeline_register.ys
yosys synth/scripts/synth_pipeline_control_unit.ys
yosys synth/scripts/synth_pipelined_alu_top.ys

rm -f synth/schematics/*.dot
```