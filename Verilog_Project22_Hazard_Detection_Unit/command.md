# Project 22 — Yosys Synthesis Commands

```bash
rm -f synth/schematics/*.dot
rm -f synth/schematics/*.svg
rm -f synth/netlists/*.v

yosys synth/scripts/synth_register_comparator.ys
yosys synth/scripts/synth_hazard_detection_logic.ys
yosys synth/scripts/synth_pipeline_stall_generator.ys
yosys synth/scripts/synth_hazard_controller_fsm.ys
yosys synth/scripts/synth_hazard_detection_unit.ys

rm -f synth/schematics/*.dot
```