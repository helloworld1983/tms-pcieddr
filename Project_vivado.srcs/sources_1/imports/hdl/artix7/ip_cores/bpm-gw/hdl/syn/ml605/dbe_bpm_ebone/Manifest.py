target = "xilinx"
action = "synthesis"

syn_device = "xc6vlx240t"
syn_grade = "-1"
syn_package = "ff1156"
syn_top = "dbe_bpm_ebone"
syn_project = "dbe_bpm_ebone.xise"

modules = { "local" : [ "../../../top/ml_605/dbe_bpm_ebone" ] };
