/*
automee
Arduino Tutorial Series
Author: Davood Dorostkar
Website: www.automee.ir
*/
#include <ESP8266WiFi.h>
#include <ThingSpeak.h>
//const char* ssid = "Mohammad";
//const char* password = "M0h@mmad66";
// WiFi
const char *netName = "Mohammad";
const char *netPassword = "M0h@mmad66";
bool wifiState = 0;
WiFiClient myClient;

// ThingSpeak
#define channelID 2391555
const int field1 = 1;
//const char *writeAPIkey = "RCB9XUIPTZN1785T";
const char *writeAPIkey = "welcome-feed";
welcome-feed
void wifiStatusCheck()
{
  while ((WiFi.status() == WL_CONNECTED) && wifiState == 0)
  {
    Serial.println("Connected!");
    wifiState = 1;
  }
  while ((WiFi.status() == WL_DISCONNECTED) && wifiState == 1)
  {
    Serial.println("Disconnected!");
    wifiState = 0;
  }
}

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

void setup()
{
  Serial.begin(115200);
  ThingSpeak.begin(myClient);
  WiFi.mode(WIFI_STA);
  WiFi.begin(netName, netPassword);
  delay(4000);
  Serial.println("");
  Serial.println("Connecting to network... ");
  Serial.println("");
}
void loop()
{
  delay(2000);
  wifiStatusCheck();
  if (wifiState)
  {
    int value = random(1, 10);
    int sentData = ThingSpeak.writeField(channelID, field1, value, writeAPIkey);
    thingSpeakCheck(sentData);
    delay(5000);
  }
  else
    Serial.println("Could not connect to network");
}/*
#include <ESP8266WebServer-impl.h>
#include <ESP8266WebServer.h>
#include <ESP8266WebServerSecure.h>
#include <Parsing-impl.h>
#include <Uri.h>

#include <ArduinoWiFiServer.h>
#include <BearSSLHelpers.h>
#include <CertStoreBearSSL.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiAP.h>
#include <ESP8266WiFiGeneric.h>
#include <ESP8266WiFiGratuitous.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266WiFiSTA.h>
#include <ESP8266WiFiScan.h>
#include <ESP8266WiFiType.h>
#include <WiFiClient.h>
#include <WiFiClientSecure.h>
#include <WiFiClientSecureBearSSL.h>
#include <WiFiServer.h>
#include <WiFiServerSecure.h>
#include <WiFiServerSecureBearSSL.h>
#include <WiFiUdp.h>


const char* ssid = "Mohammad";
const char* password = "M0h@mmad66";


void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  ESP8266WebServer server(80);


  pinMode(LED_BUILTIN, OUTPUT);     // استفاده از پایه داخلی ال ای دی برد Nodemcu
}




void loop() {
    Serial.begin(115200);
    WiFi.begin(ssid, password);
    WiFi.softAP(ssid, password);             // Start the access point
    while (WiFi.status() != WL_CONNECTED) {

      digitalWrite(LED_BUILTIN, LOW);   // روشن شدن ال ای دی  با Low شدن خروجی                          
      delay(3000);                      // تاخیر به مدت ۱ ثانیه
      digitalWrite(LED_BUILTIN, HIGH);  //خاموش شدن ال ای دی  با High شدن خروجی
      delay(500);                      // با تاخیر یک ثانیه 
    Serial.println("Connecting to WiFi...");
    }
    while (WiFi.status() == WL_CONNECTED) {

      digitalWrite(LED_BUILTIN, LOW);   // روشن شدن ال ای دی  با Low شدن خروجی                          
      delay(500);                      // تاخیر به مدت ۱ ثانیه
      digitalWrite(LED_BUILTIN, HIGH);  //خاموش شدن ال ای دی  با High شدن خروجی
      delay(500);                      // با تاخیر یک ثانیه 
    Serial.println("Connecting to WiFi...");
    }
  Serial.println("Connected to WiFi!");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
                   // با تاخیر یک ثانیه 
}
*/