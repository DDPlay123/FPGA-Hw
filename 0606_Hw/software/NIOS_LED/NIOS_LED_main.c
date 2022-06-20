#include <stdio.h>
#include <system.h>
#include <altera_avalon_pio_regs.h>
#include <unistd.h>

int main()
{
  while(1) {
      // Reset
      if (IORD_ALTERA_AVALON_PIO_DATA(SW_BASE)==0) {
          IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0xff);
      } else {
          // LED Display
          IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x80);
          // Delay 0.5s
          usleep(500000);
          IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x40);
          usleep(500000);
          IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x20);
          usleep(500000);
          IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x10);
          usleep(500000);
          IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x08);
          usleep(500000);
          IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x04);
          usleep(500000);
          IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x02);
          usleep(500000);
          IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x01);
          usleep(500000);
      }
  }
  return 0;
}
