#include "board.h"
#include "inttypes.h"
#include "fmc150.h"

// Delay in number of processor clock cycles
#define SPI_DELAY 300
#define SPI_BUSY_MAX_TRIES 10

/* Register values for cdce72010 */
uint32_t cdce72010_regs[CDCE72010_NUMREGS] = {
    //internal reference clock. Default config.
    /*0x683C0310,
      0x68000021,
      0x83040002,
      0x68000003,
      0xE9800004,
      0x68000005,
      0x68000006,
      0x83800017,
      0x68000098,
      0x68050CC9,
      0x05FC270A,
      0x0280044B,
      0x0000180C*/

    //3.84MHz ext clock. Does not lock.
    /*0x682C0290,
      0x68840041,
      0x83840002,
      0x68400003,
      0xE9800004,
      0x68000005,
      0x68000006,
      0x83800017,
      0x68000098,
      0x68000C49,
      0x0BFC02FA,
      0x8000050B,
      0x0000180C*/

    //61.44MHz ext clock. LOCK.
    /*0x682C0290,
      0x68840041,
      0x83040002,
      0x68400003,
      0xE9800004,
      0x68000005,
      0x68000006,
      0x83800017,
      0x68000098,
      0x68000049,
      0x0024009A,
      0x8000050B,
      0x0000180C*/

    //7.68MHz ext clock. Lock.
    // Use with Libera RF & clock generator. RF = 291.840MHz, MCf = 7.680MHz, H = 38
    // DDS = 3.072MHz -> Phase increment = 2048d
    0x682C0290,
    0x68840041,
    0x83860002,  //divide by 5
    //0x83840002,       //divide by 4
    0x68400003,
    0xE9800004,
    0x68000005,
    0x68000006,
    0x83800017,
    0x68000098,
    0x68000049,
    0x007C003A, // PFD_freq = 1.92MHz
    0x8000050B,
    //0x0000180C

    //15.36MHz ext clock.
    /*0x682C0290,
      0x68840041,
      0x83840002,
    /*;83020002,;divide by 6
    ;83860002,  ;divide by 5
    ;83800002,  ;divide by 2
    ;83840002,  ;divide by 4
    ;83060002,  ;divide by 8
    0x68400003,
    0xE9800004,
    0x68000005,
    0x68000006,
    0x83800017,
    0x68000098,
    0x68000049,
    0x003C003A,
    0x8000050B,
    0x0000180C*/

    //9.6MHz ext clock.
    /*0x682C0290,
      0x68840041,
      0x83860002,//;divide by 5
      0x68400003,
      0xE9800004,
      0x68000005,
      0x68000006,
      0x83800017,
      0x68000098,
      0x68000049,
      0x007C004A,
      0x8000050B,
      0x0000180C*/

    //9.250MHz ext clock. No lock
    /*0x682C0290,
      0x68840041,
      0x83860002,
      0x68400003,
      0xE9800004,
      0x68000005,
      0x68000006,
      0x83800017,
      0x68000098,
      0x68000049,
      0x5FFC39CA,
    //0x8000390B,   // DIvide by 32
    0x8000050B, //Divide by 8
    0x0000180C*/

    //10.803 (originally 10.803 actually) ext clock.
    //Could it be something related to the lock window? see cdce72010 datasheet
    /*0x682C0290,
      0x68840041,
      0x83840002,
      0x68400003,
      0xE9800004,
      0x68000005,
      0x68000006,
      0x83800017,
      0x68000098,
      0x68000049,
      0x03FC02CA,
      0x8000050B,
      0x0000180C*/
};

// Global FMC150 handler.
fmc150_t *fmc150;

int fmc150_init(void)
{
    if (fmc150_devl->devices){
        // get first gpio device found
        fmc150 = (fmc150_t *)fmc150_devl->devices->base;//BASE_FMC150;
        return 0;
    }

    return -1;
}

void update_fmc150_adc_delay(uint8_t adc_strobe_delay, uint8_t adc_cha_delay, uint8_t adc_chb_delay)
{
    fmc150->ADC_DLY = (uint32_t) FMC150_ADC_DLY_STR_W(adc_strobe_delay) +
        (uint32_t) FMC150_ADC_DLY_CHA_W(adc_cha_delay) +
        (uint32_t) FMC150_ADC_DLY_CHB_W(adc_chb_delay);
    fmc150->FLGS_PULSE = 0x1;
}

/* Check if 150 is busy */
int fmc150_spi_busy(void)
{
    return fmc150->FLGS_OUT & FMC150_FLGS_OUT_SPI_BUSY;
}

int read_fmc150_register(uint32_t cs, uint32_t addr, uint32_t* data)
{
    // Test if SPI interface is busy
    if (fmc150_spi_busy())
        return -1;

    // Set bit to read from SPI
    fmc150->FLGS_IN |= FMC150_FLGS_IN_SPI_RW;

    // Set address to read from
    fmc150->ADDR = addr;

    // Toggle chipselect
    fmc150->CS ^= cs;

    // Sleeps SPI_DELAY*4 processor cycles. Is that enough? */
    delay(SPI_DELAY);

    // Get data from register
    *data = fmc150->DATA_OUT;

    return 0;
}

int write_fmc150_register(uint32_t cs, uint32_t addr, uint32_t data)
{
    // Test if SPI interface is busy
    if (fmc150_spi_busy())
        return -1;

    // Set bit to write from SPI
    fmc150->FLGS_IN &= ~FMC150_FLGS_IN_SPI_RW;

    // Set address to write to
    fmc150->ADDR = addr;

    // Set value to write to
    fmc150->DATA_IN = data;

    // Toggle chipselect
    fmc150->CS ^= cs;

    return 0;
}

static int fmc150_spi_busy_loop()
{
    int i = 0;

    for(i = 0; i < SPI_BUSY_MAX_TRIES; ++i){
        if(!fmc150_spi_busy())
            break;

        delay(SPI_DELAY);
    }

    // return error (-1) if max tries reached
    if (i == SPI_BUSY_MAX_TRIES)
        return -1;
    else
        return 0;
}

// TODO: implement a register structure and associate permissions
// (RO, RW, WO)
int init_cdce72010()
{
    int i;
    uint32_t reg;

    /* Write regs to cdce72010 statically */
    // Do not write the last register, as it is Read-only
    for(i = 0; i < CDCE72010_NUMREGS; ++i){
        if(fmc150_spi_busy_loop() < 0){
            pp_printf("init_cdce72010: max SPI tries excceded!\n");
            return -1;
        }

        pp_printf("init_cdce72010: writing data: 0x%x at register addr: 0x%x\n", cdce72010_regs[i], i);

        // The CDCE72010 chip word addressed , hence the "i" addressing index
        write_fmc150_register(FMC150_CS_CDCE72010, i, cdce72010_regs[i]);

        // Do a write-read cycle in order to ensure that we wrote the correct value
        delay(SPI_DELAY);

        if(fmc150_spi_busy_loop() < 0){
            pp_printf("init_cdce72010: max SPI tries excceded!\n");
            return -1;
        }

        // The CDCE72010 chip word addressed , hence the "i" addressing index
        read_fmc150_register(FMC150_CS_CDCE72010, i, &reg);
        pp_printf("init_cdce72010: reading data: 0x%x at register addr: 0x%x\n", reg, i);

        // Check if value written is the same of the value just read
        if(cdce72010_regs[i] != reg){
            pp_printf("init_cdce72010: error: data written (0x%x) != data read (0x%x)!\n",
                    cdce72010_regs[i], reg);
            return -1;
        }

        delay(SPI_DELAY);
    }

    return 0;
}
