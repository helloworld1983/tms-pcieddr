files = ["bpm_pcie_a7.vhd",
        "bpm_pcie_k7.vhd",
        "bpm_pcie_ml605.vhd",
        "bpm_pcie_a7_priv_pkg.vhd",
        "bpm_pcie_k7_priv_pkg.vhd",
        "bpm_pcie_ml605_priv_pkg.vhd",
        "bpm_pcie_a7_const_pkg.vhd",
        "bpm_pcie_k7_const_pkg.vhd",
        "bpm_pcie_ml605_const_pkg.vhd"
        ]

modules = {"local" : ["common"],
        "git" : ["https://github.com/lerwys/general-cores.git"]}
# original version hosted at OHWR:
#        "git" : ["git://ohwr.org/hdl-core-lib/general-cores.git"]}

fetchto = "../../ip_cores"

