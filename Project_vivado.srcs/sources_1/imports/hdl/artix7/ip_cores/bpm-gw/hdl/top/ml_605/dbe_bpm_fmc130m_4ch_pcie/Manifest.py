#files = [ "dbe_bpm_fmc130m_4ch_pcie.vhd", "sys_pll.vhd", "clk_gen.vhd", "dbe_bpm_fmc130m_4ch_pcie.ucf", "pcie.ucf" ];
files = [ "dbe_bpm_fmc130m_4ch_pcie.vhd", "sys_pll.vhd", "clk_gen.vhd", "dbe_bpm_fmc130m_4ch_pcie.ucf",
"dbe_bpm_fmc130m_4ch_pcie.xcf" ];

modules = { "local" :
            ["../../..",
             "../../../top/pcie",
             "../../../modules/pcie",
             "../../../ip_cores/pcie/ml605"
            ]
          };
