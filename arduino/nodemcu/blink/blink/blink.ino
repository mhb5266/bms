//#include <EEPROM.h>
//#define EEPROM_SIZE 12
//EEPROM.begin(EEPROM_SIZE);
//unsigned long i;
int i = 1000;
int b;
int c;
void setup() {

  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);  // تعریف پایه خروجی برای ال ای دی
}
// ایجاد حلقه
void loop() {

  digitalWrite(LED_BUILTIN, HIGH);  // روشن شدن ال ای دی
  delay(i);                         // پس از یک ثانیه
  digitalWrite(LED_BUILTIN, LOW);   // خاموش شدن ال ای دی
  delay(i);                         // پس از یک ثانیه
  b++;
  Serial.println(b);
}