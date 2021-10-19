
#include <includes.c>

// Global enable interrupts
#asm("sei")
      lcd_puts("hi");
      delay_ms(2000);
      lcd_clear();
      delay_ms(500);
while (1)
      {
      // Place your code here
        lcd_putchar(heater);
        lcd_putchar(cooler);
        lcd_putchar(motor);
      }
}
