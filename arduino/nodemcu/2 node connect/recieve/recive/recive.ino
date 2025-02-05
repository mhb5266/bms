#include <ESP8266WiFi.h>
#include <WiFiUDP.h>
#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "DHT.h"
#define DHTTYPE DHT22
uint8_t DHTPin = D7; 
DHT dht(DHTPin, DHTTYPE); 
float Temperature;
float Humidity; 
#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels
#define OLED_ADDR 0x3C   // Address may be different for your module, also try with 0x3D if this doesn't work

// Declaration for an SSD1306 display connected to I2C (SDA, SCL pins)
#define OLED_RESET -1 // Reset pin # (or -1 if sharing Arduino reset pin)
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

const char* ssid = "Turbodigital";
const char* pass = "123456789";    

unsigned int localPort = 12345;     
byte packetBuffer[512];
WiFiUDP Udp;

void printWifiStatus() {
  IPAddress ip = WiFi.softAPIP();
  Serial.print("IP Address: ");
  Serial.println(ip);
}

void setup(){
   pinMode(LED_BUILTIN, OUTPUT); // تعریف پایه خروجی برای ال ای دی
  Serial.begin(115200);
  WiFi.disconnect();
  pinMode(2,OUTPUT);
  digitalWrite(2,0);
  WiFi.softAP(ssid,pass);
  WiFi.mode(WIFI_AP);
  
  Udp.begin(localPort);
  Serial.println();
  printWifiStatus();
      display.begin(SSD1306_SWITCHCAPVCC, 0x3C);  
    display.clearDisplay();
    display.setTextSize(2);
    display.setTextColor(WHITE);
    display.setCursor(0,0);
    display.println("Hello");
    //display.println(Temperature);
    display.display();
    delay(2000);
}

void loop(){
  int noBytes = Udp.parsePacket();
  String received_command = "";
 
  if ( noBytes ) {
    Udp.read(packetBuffer,noBytes);
    for (int i=1;i<=noBytes;i++)
    {
      received_command += char(packetBuffer[i - 1]);
    } 
    Serial.println(received_command);
    if (received_command == "1111"){
      digitalWrite(2,1);
      display.setCursor(32,90);
      display.println("1");
      digitalWrite(LED_BUILTIN,HIGH); // روشن شدن ال ای دی 
      //delay(1000);  // پس از یک ثانیه    
    }

    if (received_command == "0000"){
      digitalWrite(2,0);
      display.setCursor(32,90);
      display.println("0");   
      digitalWrite(LED_BUILTIN, LOW); // خاموش شدن ال ای دی
      //delay(1000);         // پس از یک ثانیه          
    }
  }
  Serial.begin(9600);
  delay(100);
  pinMode(DHTPin, INPUT);
 
  dht.begin(); 
  Humidity = dht.readHumidity();
  Temperature= dht.readTemperature();

      // initialize with the I2C addr 0x3C


}




