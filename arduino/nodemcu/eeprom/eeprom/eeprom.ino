//Libraries
#include <EEPROM.h>  //https://github.com/esp8266/Arduino/blob/master/libraries/EEPROM/EEPROM.h

//Constants
#define EEPROM_SIZE 12
int boardId;
int param;
void setup() {
}

void loop() {

  //Init Serial USB
  Serial.begin(9600);
  Serial.println(F("Initialize System"));
  //Init EEPROM
  EEPROM.begin(EEPROM_SIZE);
  int address = 0;

  //Read data from eeprom
  address = 0;
  int readId;
  EEPROM.get(address, readId);
  Serial.print("Read Id = ");
  Serial.println(readId);
  Serial.println("\n");
  address += sizeof(readId);  //update address value

  int readParam;
  EEPROM.get(address, readParam);  //readParam=EEPROM.readFloat(address);
  Serial.print("Read param = ");
  Serial.println(readParam);
  Serial.println("\n");
  param=readParam;
  boardId=readId;
  boardId++;
  param++;
  delay(2000);


  //Write data into eeprom
  address = 0;

  EEPROM.put(address, boardId);
  address += sizeof(boardId);  //update address value


  EEPROM.put(address, param);
  EEPROM.commit();
  delay(2000);



  EEPROM.end();
}