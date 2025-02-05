/*
   -- New project --
   
   This source code of graphical user interface 
   has been generated automatically by RemoteXY editor.
   To compile this code using RemoteXY library 3.1.10 or later version 
   download by link http://remotexy.com/en/library/
   To connect using RemoteXY mobile app by link http://remotexy.com/en/download/                   
     - for ANDROID 4.13.1 or later version;
     - for iOS 1.10.1 or later version;
    
   This source code is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.    
*/

//////////////////////////////////////////////
//        RemoteXY include library          //
//////////////////////////////////////////////

// you can enable debug logging to Serial at 115200
//#define REMOTEXY__DEBUGLOG    

// RemoteXY select connection mode and include library 
#define REMOTEXY_MODE__HARDSERIAL


#include <ESP8266WiFi.h> 
#include <RemoteXY.h>

// RemoteXY connection settings 
#define REMOTEXY_SERIAL Serial
#define REMOTEXY_SERIAL_SPEED 9600
#define REMOTEXY_ACCESS_PASSWORD "mhb5266"




// RemoteXY configurate  
#pragma pack(push, 1)
uint8_t RemoteXY_CONF[] =   // 65 bytes
  { 255,1,0,1,0,58,0,17,0,0,0,16,3,106,200,108,200,200,84,1,
  1,2,0,70,14,18,18,18,14,18,18,18,151,39,24,23,154,12,135,0,
  2,46,19,50,15,47,19,51,15,143,14,40,12,0,135,0,31,31,79,78,
  0,79,70,70,0 };
  
// this structure defines all the variables and events of your control interface 
struct {

    // input variables
  uint8_t switch_01; // =1 if switch ON and =0 if OFF

    // output variables
  uint8_t led_01; // led state

    // other variable
  uint8_t connect_flag;  // =1 if wire connected, else =0

} RemoteXY;
#pragma pack(pop)
 
/////////////////////////////////////////////
//           END RemoteXY include          //
/////////////////////////////////////////////




void setup() 
{
  remotexy = new CRemoteXY (
    RemoteXY_CONF_PROGMEM, 
    &RemoteXY, 
    new CRemoteXYConnectionCloud (
      new CRemoteXYComm_WiFi (
        "Mohammad",       // REMOTEXY_WIFI_SSID
        "M0h@mmad66"),          // REMOTEXY_WIFI_PASSWORD
      "cloud.remotexy.com",   // REMOTEXY_CLOUD_SERVER
      6376,                   // REMOTEXY_CLOUD_PORT
      "9431e6b500936d3a7cbfe170d20faa13"  // REMOTEXY_CLOUD_TOKEN
    )
  ); 
  
  
  // TODO you setup code
  
}

void loop() 
{ 
  RemoteXY_Handler ();
  digitalWrite(LED_BUILTIN,HIGH); // روشن شدن ال ای دی 
  RemoteXY_delay(1000);  // پس از یک ثانیه                    
  digitalWrite(LED_BUILTIN, LOW); // خاموش شدن ال ای دی
  RemoteXY_delay(1000);         // پس از یک ثانیه   
  
  // TODO you loop code
  // use the RemoteXY structure for data transfer
  // do not call delay(), use instead RemoteXY_delay() 


}