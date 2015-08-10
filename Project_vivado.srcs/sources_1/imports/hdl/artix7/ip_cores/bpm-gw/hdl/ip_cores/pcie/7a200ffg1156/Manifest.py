if (action == "synthesis"):

    files = ["bram_x64.ngc",
             "eb_fifo_counted_resized.ngc",
             "mbuf_128x72.ngc",
             "prime_FIFO_plain.ngc",
             "sfifo_15x128.ngc"]

else:

    files = ["bram_x64.vhd",
             "eb_fifo_counted_resized.vhd",
             "mbuf_128x72.vhd",
             "prime_FIFO_plain.vhd",
             "sfifo_15x128.vhd"]

modules = {"local" : ["pcie_core/source",
                      "ddr_core_2_3/user_design"]}
                      #"ddr_core/user_design"]}
