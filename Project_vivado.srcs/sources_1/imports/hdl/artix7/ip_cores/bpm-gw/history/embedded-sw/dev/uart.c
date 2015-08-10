#include <inttypes.h>

#include "board.h"      // Board definitions: UART device structure
#include "uart.h"        // UART device functions
#include "debug_print.h"
#include "memmgr.h"

#define CALC_BAUD(baudrate) \
    ( ((( (unsigned long long)baudrate * 8ULL) << (16 - 7)) + \
       (CPU_CLOCK >> 8)) / (CPU_CLOCK >> 7) )

// Global UART handler.
uart_t **uart;

int uart_init(void)
{
    int i;
    struct dev_node *dev_p = 0;

    if (!uart_devl->devices)
        return -1;

    // get all base addresses
    uart = (uart_t **) memmgr_alloc(sizeof(uart_t *)*uart_devl->size);

    for (i = 0, dev_p = uart_devl->devices; i < uart_devl->size;
            ++i, dev_p = dev_p->next) {
        uart[i] = (uart_t *) dev_p->base;
        uart[i]->BCR = CALC_BAUD(UART_BAUDRATE);
        DBE_DEBUG(DBG_UART | DBE_DBG_INFO, "> uart addr[%d]: %08X\n", i, dev_p->base);
    }

    DBE_DEBUG(DBG_UART | DBE_DBG_INFO, "> uart size: %d\n", uart_devl->size);
    //uart = (uart_t *)uart_devl->devices->base;//BASE_GPIO;
    return 0;
}

int uart_exit()
{
    // free uart structure
    memmgr_free(uart);

    return 0;
}

void uart_write_byte(unsigned int id, int b)
{
    if (b == '\n')
        uart_write_byte(id, '\r');
    while (uart[id]->SR & UART_SR_TX_BUSY) ;
    uart[id]->TDR = b;
}

void uart_write_string(unsigned int id, char *s)
{
    while (*s)
        uart_write_byte(id, *(s++));
}

void uart_write(unsigned int id, const char *s, int nbytes)
{
  int i;

  for(i = 0; i < nbytes; ++i)
    uart_write_byte(DEFAULT_UART, *(s++));
}

// Only for use with puts
static void uart_default_write_string(char *s)
{
    while (*s)
        uart_write_byte(DEFAULT_UART, *(s++));
}

// See http://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html
// for the __attribute__ explanation
int puts(const char *s) __attribute__((alias("uart_default_write_string")));

int uart_poll(unsigned int id)
{
    return uart[id]->SR & UART_SR_RX_RDY;
}

int uart_read_byte(unsigned int id)
{
    if (!uart_poll(id))
        return -1;

    return uart[id]->RDR & 0xff;
}
