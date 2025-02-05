#include <ESP8266WiFi.h>
#include <WiFiUDP.h>

const char* ssid = "Turbodigital";
const char* pass = "123456789";    

unsigned int localPort = 12346;     
WiFiUDP Udp;

void printWifiStatus() {
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);
}

void setup(){
  Serial.begin(115200);
  WiFi.disconnect();
  Serial.println();
  Serial.println();
  WiFi.begin(ssid,pass);
  WiFi.mode(WIFI_STA);
  int tries=0;
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
    tries++;
    if (tries > 30){
      break;
    }
  }
  Serial.println();
  printWifiStatus();
  Udp.begin(localPort);
   pinMode(LED_BUILTIN, OUTPUT); // تعریف پایه خروجی برای ال ای دی
}

void loop()
{
    // Acknowlege package
    Udp.beginPacket({192,168,4,1}, 12345);
    Udp.write("1111");
    Udp.endPacket();
  digitalWrite(LED_BUILTIN,HIGH); // روشن شدن ال ای دی 
  delay(1000);  // پس از یک ثانیه        

    Udp.beginPacket({192,168,4,1}, 12345);
    Udp.write("0000");
    Udp.endPacket();


  
  digitalWrite(LED_BUILTIN, LOW); // خاموش شدن ال ای دی
  delay(1000);         // پس از یک ثانیه   
}