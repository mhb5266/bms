/*
   Simple button example
   
   This source code of graphical user interface 
   has been generated automatically by RemoteXY editor.
   To compile this code using RemoteXY library 3.1.1 or later version 
   download by link http://remotexy.com/en/library/
   To connect using RemoteXY mobile app by link http://remotexy.com/en/download/                   
     - for ANDROID 4.5.1 or later version;
     - for iOS 1.4.1 or later version;
    
   This source code is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.    
*/

//////////////////////////////////////////////
//        RemoteXY include library          //
//////////////////////////////////////////////

// RemoteXY select connection mode and include library
//#define REMOTEXY__DEBUGLOG

#include <ESP8266WiFi.h>
#include <RemoteXY.h>


// RemoteXY configurate
#pragma pack(push, 1)
uint8_t RemoteXY_CONF[] = { 255, 1, 0, 1, 0, 27, 0, 10, 13, 2,
                            1, 0, 9, 9, 46, 46, 6, 7, 50, 50,
                            2, 31, 88, 0, 65, 4, 62, 16, 31, 31,
                            14, 62, 35, 35 };

// this structure defines all the variables and events of your control interface
struct {

  // input variables
  uint8_t button_1;  // =1 if button pressed, else =0

  // output variables
  uint8_t led_1_r;  // =0..255 LED Red brightness

  // other variable
  uint8_t connect_flag;  // =1 if wire connected, else =0

} RemoteXY;
#pragma pack(pop)



/////////////////////////////////////////////
//           END RemoteXY include          //
/////////////////////////////////////////////


CRemoteXY *remotexy;

//#include <ESP8266WiFi.h>
//#include <ThingSpeak.h>

// WiFi
const char *netName = "Mohammad";
const char *netPassword = "M0h@mmad66";
bool wifiState = 0;
WiFiClient myClient;

// ThingSpeak
//#define channelID 701131
//const int field1 = 1;
//const char *writeAPIkey = "xxxxxxxxxxxxxxxx";

void wifiStatusCheck() {
  while ((WiFi.status() == WL_CONNECTED) && wifiState == 0) {
    Serial.println("Connected!");
    wifiState = 1;
  }
  while ((WiFi.status() == WL_DISCONNECTED) && wifiState == 1) {
    Serial.println("Disconnected!");
    wifiState = 0;
  }
}
/*
void thingSpeakCheck(int sentData)
{
  if (sentData == 200)
  {
    Serial.println("Channel updated successful.");
  }
  else
  {
    Serial.println("Problem updating channel.");
  }
}
*/


void setup() {
  Serial.begin(9600);
  //ThingSpeak.begin(myClient);
  //WiFi.mode(WIFI_STA);
  WiFi.begin(netName, netPassword);
  delay(4000);
  Serial.println("");
  Serial.println("Connecting to network... ");
  Serial.println("");

  while ((WiFi.status() == WL_CONNECTED) && wifiState == 0) {
    Serial.println("Connected!");
    wifiState = 1;
  }
  while ((WiFi.status() == WL_DISCONNECTED) && wifiState == 1) {
    Serial.println("Disconnected!");
    wifiState = 0;
  }
 pinMode(LED_BUILTIN, OUTPUT); // تعریف پایه خروجی برای ال ای دی
  // TODO you setup code
}
void loop() {
  remotexy = new CRemoteXY(
    RemoteXY_CONF_PROGMEM,
    &RemoteXY,
    new CRemoteXYConnectionCloud(
      new CRemoteXYComm_WiFi(
        netName,                          // REMOTEXY_WIFI_SSID
        netPassword),                     // REMOTEXY_WIFI_PASSWORD
      "cloud.remotexy.com",               // REMOTEXY_CLOUD_SERVER
      6376,                               // REMOTEXY_CLOUD_PORT
      "9431e6b500936d3a7cbfe170d20faa13"  // REMOTEXY_CLOUD_TOKEN
      ));
  remotexy->handler();

  if (RemoteXY.button_1) RemoteXY.led_1_r = 255;
  else RemoteXY.led_1_r = 0;
  digitalWrite(LED_BUILTIN, HIGH);  // روشن شدن ال ای دی
  delay(1000);                      // پس از یک ثانیه
  digitalWrite(LED_BUILTIN, LOW);   // خاموش شدن ال ای دی
  delay(1000);                      // پس از یک ثانیه
  // TODO you loop code
  // use the RemoteXY structure for data transfer
  // do not call delay()


  /*
  delay(2000);
  wifiStatusCheck();
  if (wifiState)
  {
    int value = random(20, 40);
    int sentData = ThingSpeak.writeField(channelID, field1, value, writeAPIkey);
    thingSpeakCheck(sentData);
    delay(20000);
  }
  else
    Serial.println("Could not connect to network");
    */
}