target = "xilinx"
action = "synthesis"

syn_device = "xc6vlx240t"
syn_grade = "-1"
syn_package = "ff1156"
syn_top = "dbe_bpm_dsp"
syn_project = "dbe_bpm_dsp.xise"
syn_tool = "ise"

modules = { "local" : [ "../../../top/ml_605/dbe_bpm_dsp_fmc130m_4ch" ] };
