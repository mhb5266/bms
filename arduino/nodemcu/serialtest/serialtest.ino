#include <arduino.h>
#include <SoftwareSerial.h>
//#include <ESP_EEPROM.h>
#define rxPin D2
#define txPin D1
#define SIMRST D0
SoftwareSerial mySerial(rxPin, txPin);

void updateSerial() {
  delay(500);
  while (Serial.available()) {
    mySerial.write(Serial.read());  //Forward what Serial received to Software Serial Port
  }

  while (mySerial.available()) {
    Serial.write(mySerial.read());  //Forward what Software Serial received to Serial Port
  }
}
void setup() {
  bool a = 0;
  pinMode(SIMRST, OUTPUT);  // تعریف پایه خروجی برای ال ای دی
  digitalWrite(SIMRST, HIGH);
  //pinMode(LED_BUILTIN, OUTPUT); // تعریفd:\bms\arduino\nodemcu\serialtest\ESP_EEPROM.h پایه خروجی برای ال ای دی
  pinMode(rxPin, INPUT);
  pinMode(txPin, OUTPUT);
  mySerial.begin(9600);
  Serial.begin(9600);
  mySerial.setTimeout(1000);
  Serial.println("Initializing...");
  delay(1000);
  mySerial.println("ATE0");
  updateSerial();
  mySerial.println("AT");
  updateSerial();
  mySerial.println("AT+CPIN?");
  updateSerial();
  /*
  mySerial.println("AT+CIURC=1");
  updateSerial();
  do {
    String c = mySerial.readString();
    Serial.print(c);
    updateSerial();
    if (c = "SMS Ready") {
      a = 1;
    }
  } while (a == 1);
  */
  //Once the handshake test is successful, it will back to OK

  mySerial.println("AT+CSQ");  //Signal quality test, value range is 0-31 , 31 is the best
  updateSerial();
  mySerial.println("AT+CCID");  //Read SIM information to confirm whether the SIM is plugged

  mySerial.println("AT+CMGF=1");
  // Configuring TEXT mode
  updateSerial();
  //mySerial.println("AT+CMGS=+989376921503");
  mySerial.println("AT+CMGS=\"+989376921503\"");
  //change ZZ with country code and xxxxxxxxxxx with phone number to sms
  updateSerial();
  mySerial.print("System Is Restarting");
  //text content
  updateSerial();
  mySerial.write(26);
}

void loop() {
  digitalWrite(SIMRST, HIGH);

  mySerial.println("AT+CMGR=1");
  String c = mySerial.readString();
  Serial.print(c);
  digitalWrite(SIMRST, HIGH);
  //digitalWrite(LED_BUILTIN,TOGGLE);
  // روشن شدن ال ای دی
  digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
  delay(1000);
}