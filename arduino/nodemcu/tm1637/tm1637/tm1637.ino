#include <TM1637Display.h>
const int CLK_PIN = D3;  // CLK pin connected to D5
const int DIO_PIN = D4;  // DIO pin connected to D6
uint8_t ROSHAN;
int num;
TM1637Display display(CLK_PIN, DIO_PIN);  // Initialize the TM1637 display
void setup() {
  display.setBrightness(7);  // Set display brightness (0-7)
}
void loop() {
  display.showNumberDec(num);  // Display the number 1234
  delay(2000);                 // Delay for 2 seconds
  //display.clear();              // Clear the display
  //delay(1000);                  // Delay for 1 second
  display.setBrightness(ROSHAN);

  if (ROSHAN >= 7) {
    ROSHAN = 0;
  }
  ROSHAN++;
  num = ROSHAN;
}