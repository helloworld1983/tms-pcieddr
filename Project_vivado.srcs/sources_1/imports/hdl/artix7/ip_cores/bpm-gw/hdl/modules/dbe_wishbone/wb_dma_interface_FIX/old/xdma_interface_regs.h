/*
  Register definitions for slave core: Wishbone DMA Streaming Interface

  * File           : xdma_interface_regs.h
  * Author         : auto-generated by wbgen2 from xdma_interface_wb.wb
  * Created        : Thu Sep 27 15:39:56 2012
  * Standard       : ANSI C

    THIS FILE WAS GENERATED BY wbgen2 FROM SOURCE FILE xdma_interface_wb.wb
    DO NOT HAND-EDIT UNLESS IT'S ABSOLUTELY NECESSARY!

*/

#ifndef __WBGEN2_REGDEFS_XDMA_INTERFACE_WB_WB
#define __WBGEN2_REGDEFS_XDMA_INTERFACE_WB_WB

#include <inttypes.h>

#if defined( __GNUC__)
#define PACKED __attribute__ ((packed))
#else
#error "Unsupported compiler?"
#endif

#ifndef __WBGEN2_MACROS_DEFINED__
#define __WBGEN2_MACROS_DEFINED__
#define WBGEN2_GEN_MASK(offset, size) (((1<<(size))-1) << (offset))
#define WBGEN2_GEN_WRITE(value, offset, size) (((value) & ((1<<(size))-1)) << (offset))
#define WBGEN2_GEN_READ(reg, offset, size) (((reg) >> (offset)) & ((1<<(size))-1))
#define WBGEN2_SIGN_EXTEND(value, bits) (((value) & (1<<bits) ? ~((1<<(bits))-1): 0 ) | (value))
#endif


/* definitions for register: Control/Status register */

/* definitions for field: Start Transaction in reg: Control/Status register */
#define DMA_IFACE_CTL_START                   WBGEN2_GEN_MASK(0, 1)

/* definitions for field: DMA complete in reg: Control/Status register */
#define DMA_IFACE_CTL_DONE                    WBGEN2_GEN_MASK(1, 1)

/* definitions for field: DMA overflow in reg: Control/Status register */
#define DMA_IFACE_CTL_OVF                     WBGEN2_GEN_MASK(2, 1)

/* definitions for register: Transaction Counter */

/* definitions for register: FIFO 'FIFO C2B (Core -> DMA) synchronization' data output register 0 */

/* definitions for field: Output FIFO data value in reg: FIFO 'FIFO C2B (Core -> DMA) synchronization' data output register 0 */
#define DMA_IFACE_FIFO_C2B_R0_DATA_MASK       WBGEN2_GEN_MASK(0, 32)
#define DMA_IFACE_FIFO_C2B_R0_DATA_SHIFT      0
#define DMA_IFACE_FIFO_C2B_R0_DATA_W(value)   WBGEN2_GEN_WRITE(value, 0, 32)
#define DMA_IFACE_FIFO_C2B_R0_DATA_R(reg)     WBGEN2_GEN_READ(reg, 0, 32)

/* definitions for register: FIFO 'FIFO C2B (Core -> DMA) synchronization' data output register 1 */

/* definitions for field: Transaction Last Data in reg: FIFO 'FIFO C2B (Core -> DMA) synchronization' data output register 1 */
#define DMA_IFACE_FIFO_C2B_R1_LAST            WBGEN2_GEN_MASK(0, 1)

/* definitions for register: FIFO 'FIFO C2B (Core -> DMA) synchronization' control/status register */

/* definitions for field: FIFO full flag in reg: FIFO 'FIFO C2B (Core -> DMA) synchronization' control/status register */
#define DMA_IFACE_FIFO_C2B_CSR_FULL           WBGEN2_GEN_MASK(16, 1)

/* definitions for field: FIFO empty flag in reg: FIFO 'FIFO C2B (Core -> DMA) synchronization' control/status register */
#define DMA_IFACE_FIFO_C2B_CSR_EMPTY          WBGEN2_GEN_MASK(17, 1)

/* definitions for field: FIFO counter in reg: FIFO 'FIFO C2B (Core -> DMA) synchronization' control/status register */
#define DMA_IFACE_FIFO_C2B_CSR_USEDW_MASK     WBGEN2_GEN_MASK(0, 8)
#define DMA_IFACE_FIFO_C2B_CSR_USEDW_SHIFT    0
#define DMA_IFACE_FIFO_C2B_CSR_USEDW_W(value) WBGEN2_GEN_WRITE(value, 0, 8)
#define DMA_IFACE_FIFO_C2B_CSR_USEDW_R(reg)   WBGEN2_GEN_READ(reg, 0, 8)

/* definitions for register: FIFO 'FIFO B2C (Bus -> Core) synchronization' data input register 0 */

/* definitions for field: Input FIFO data value in reg: FIFO 'FIFO B2C (Bus -> Core) synchronization' data input register 0 */
#define DMA_IFACE_FIFO_B2C_R0_DATA_MASK       WBGEN2_GEN_MASK(0, 32)
#define DMA_IFACE_FIFO_B2C_R0_DATA_SHIFT      0
#define DMA_IFACE_FIFO_B2C_R0_DATA_W(value)   WBGEN2_GEN_WRITE(value, 0, 32)
#define DMA_IFACE_FIFO_B2C_R0_DATA_R(reg)     WBGEN2_GEN_READ(reg, 0, 32)

/* definitions for register: FIFO 'FIFO B2C (Bus -> Core) synchronization' control/status register */

/* definitions for field: FIFO full flag in reg: FIFO 'FIFO B2C (Bus -> Core) synchronization' control/status register */
#define DMA_IFACE_FIFO_B2C_CSR_FULL           WBGEN2_GEN_MASK(16, 1)

/* definitions for field: FIFO empty flag in reg: FIFO 'FIFO B2C (Bus -> Core) synchronization' control/status register */
#define DMA_IFACE_FIFO_B2C_CSR_EMPTY          WBGEN2_GEN_MASK(17, 1)

/* definitions for field: FIFO counter in reg: FIFO 'FIFO B2C (Bus -> Core) synchronization' control/status register */
#define DMA_IFACE_FIFO_B2C_CSR_USEDW_MASK     WBGEN2_GEN_MASK(0, 8)
#define DMA_IFACE_FIFO_B2C_CSR_USEDW_SHIFT    0
#define DMA_IFACE_FIFO_B2C_CSR_USEDW_W(value) WBGEN2_GEN_WRITE(value, 0, 8)
#define DMA_IFACE_FIFO_B2C_CSR_USEDW_R(reg)   WBGEN2_GEN_READ(reg, 0, 8)

PACKED struct DMA_IFACE_WB {
  /* [0x0]: REG Control/Status register */
  uint32_t CTL;
  /* [0x4]: REG Transaction Counter */
  uint32_t TR_CNTR;
  /* [0x8]: REG FIFO 'FIFO C2B (Core -> DMA) synchronization' data output register 0 */
  uint32_t FIFO_C2B_R0;
  /* [0xc]: REG FIFO 'FIFO C2B (Core -> DMA) synchronization' data output register 1 */
  uint32_t FIFO_C2B_R1;
  /* [0x10]: REG FIFO 'FIFO C2B (Core -> DMA) synchronization' control/status register */
  uint32_t FIFO_C2B_CSR;
  /* [0x14]: REG FIFO 'FIFO B2C (Bus -> Core) synchronization' data input register 0 */
  uint32_t FIFO_B2C_R0;
  /* [0x18]: REG FIFO 'FIFO B2C (Bus -> Core) synchronization' control/status register */
  uint32_t FIFO_B2C_CSR;
};

#endif
