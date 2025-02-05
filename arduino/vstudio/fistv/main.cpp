// Include the libraries we need
#include <arduino.h>
#include <SoftwareSerial.h>
#include <string.h>
#include <OneWire.h>
#include <DallasTemperature.h>


#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels

// Declaration for an SSD1306 display connected to I2C (SDA, SCL pins)
// The pins for I2C are defined by the Wire-library. 
// On an arduino UNO:       A4(SDA), A5(SCL)
// On an arduino MEGA 2560: 20(SDA), 21(SCL)
// On an arduino LEONARDO:   2(SDA),  3(SCL), ...
#define OLED_RESET     -1 // Reset pin # (or -1 if sharing Arduino reset pin)
#define SCREEN_ADDRESS 0x3D ///< See datasheet for Address; 0x3D for 128x64, 0x3C for 128x32
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

#define NUMFLAKES     10 // Number of snowflakes in the animation example

#define LOGO_HEIGHT   16
#define LOGO_WIDTH    16

#define rxPin D7
#define txPin D6
#define SIMRST D0
SoftwareSerial mySerial(rxPin, txPin);
String number;
String order;
String mytemp;

// Data wire is plugged into port 2 on the Arduino
#define ONE_WIRE_BUS 2

// Setup a oneWire instance to communicate with any OneWire devices (not just Maxim/Dallas temperature ICs)
OneWire oneWire(ONE_WIRE_BUS);

// Pass our oneWire reference to Dallas Temperature.
DallasTemperature sensors(&oneWire);

// arrays to hold device addresses
DeviceAddress insideThermometer, outsideThermometer;


// function to print the temperature for a device
void printTemperature(DeviceAddress deviceAddress)
{
  float tempC = sensors.getTempC(deviceAddress);
  mytemp=sensors.getTempC(deviceAddress);
  Serial.print("Temp C: ");
  Serial.print(tempC);
  Serial.print(" `C");
  //Serial.print(" Temp F: ");
  //Serial.print(DallasTemperature::toFahrenheit(tempC));
  Serial.print("\n");
}

void updateSerial()
{
  delay(500);
  while (Serial.available())
  {
    mySerial.write(Serial.read()); // Forward what Serial received to Software Serial Port
  }

  while (mySerial.available())
  {
    Serial.write(mySerial.read()); // Forward what Software Serial received to Serial Port
  }
}

/*
 * Setup function. Here we do the basics
 */
void printAddress(DeviceAddress deviceAddress)
{
  for (uint8_t i = 0; i < 8; i++)
  {
    if (deviceAddress[i] < 16) Serial.print("0");
    Serial.print(deviceAddress[i], HEX);
  }
}
void setup(void)
{

  // SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
  if(!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
    Serial.println(F("SSD1306 allocation failed"));
    for(;;); // Don't proceed, loop forever
  }

  // Show initial display buffer contents on the screen --
  // the library initializes this with an Adafruit splash screen.
  display.display();
  delay(2000); // Pause for 2 seconds

  // Clear the buffer
  display.clearDisplay();

  // Draw a single pixel in white
  display.drawPixel(10, 10, SSD1306_WHITE);


  // start serial port
  Serial.begin(9600);
  Serial.println("Dallas Temperature IC Control Library Demo");

  // locate devices on the bus
  Serial.print("Locating devices...");
  sensors.begin();
  Serial.print("Found ");
  Serial.print(sensors.getDeviceCount(), DEC);
  Serial.println(" devices.");

  // report parasite power requirements
  Serial.print("Parasite power is: ");
  if (sensors.isParasitePowerMode()) Serial.println("ON");
  else Serial.println("OFF");

  // Assign address manually. The addresses below will beed to be changed
  // to valid device addresses on your bus. Device address can be retrieved
  // by using either oneWire.search(deviceAddress) or individually via
  // sensors.getAddress(deviceAddress, index)
  // Note that you will need to use your specific address here
  //insideThermometer = { 0x28, 0x1D, 0x39, 0x31, 0x2, 0x0, 0x0, 0xF0 };

  // Method 1:
  // Search for devices on the bus and assign based on an index. Ideally,
  // you would do this to initially discover addresses on the bus and then
  // use those addresses and manually assign them (see above) once you know
  // the devices on your bus (and assuming they don't change).
  if (!sensors.getAddress(insideThermometer, 0)) Serial.println("Unable to find address for Device 0");

  // method 2: search()
  // search() looks for the next device. Returns 1 if a new address has been
  // returned. A zero might mean that the bus is shorted, there are no devices,
  // or you have already retrieved all of them. It might be a good idea to
  // check the CRC to make sure you didn't get garbage. The order is
  // deterministic. You will always get the same devices in the same order
  //
  // Must be called before search()
  //oneWire.reset_search();
  // assigns the first address found to insideThermometer
  //if (!oneWire.search(insideThermometer)) Serial.println("Unable to find address for insideThermometer");

  // show the addresses we found on the bus
  Serial.print("Device 0 Address: ");
  printAddress(insideThermometer);
  Serial.println();

  // set the resolution to 9 bit (Each Dallas/Maxim device is capable of several different resolutions)
  sensors.setResolution(insideThermometer, 9);

  Serial.print("Device 0 Resolution: ");
  Serial.print(sensors.getResolution(insideThermometer), DEC);
  Serial.println();

    // locate devices on the bus
  Serial.print("Found ");
  Serial.print(sensors.getDeviceCount(), DEC);
  Serial.println(" devices.");

  // boolean aaa = 0;
  pinMode(SIMRST, OUTPUT); // تعریف پایه خروجی برای ال ای دی
  digitalWrite(SIMRST, HIGH);
  pinMode(LED_BUILTIN, OUTPUT); // تعریف پایه خروجی برای ال ای دی
  pinMode(rxPin, INPUT);
  pinMode(txPin, OUTPUT);
  mySerial.begin(9600);
  Serial.begin(9600);
  mySerial.setTimeout(1000);
  Serial.println("Initializing...");
  delay(5000);
  mySerial.println("ATE0");
  updateSerial();
  mySerial.println("AT");
  updateSerial();
  mySerial.println("AT+CPIN?");
  updateSerial();

  // Once the handshake test is successful, it will back to OK

  mySerial.println("AT+CSQ"); // Signal quality test, value range is 0-31 , 31 is the best
  updateSerial();
  mySerial.println("AT+CCID"); // Read SIM information to confirm whether the SIM is plugged
  updateSerial();
  mySerial.println("AT+CMGF=1"); // text mode
  updateSerial();
  mySerial.println("AT+CNMI=0,1,0,0,0"); // disable new sms indication
  updateSerial();
  mySerial.println("AT+CMGDA=DEL ALL");
  // mySerial.println("AT+CMGDA=DEL ALL");
  //  Configuring TEXT mode
  updateSerial();
  // mySerial.println("AT+CMGS=+989376921503");
  // mySerial.println("AT+CMGS=\"+989376921503\"");
  // change ZZ with country code and xxxxxxxxxxx with phone number to sms
  // updateSerial();
  // mySerial.print("System Is Restarting");
  // text content
  // updateSerial();
  // mySerial.write(26);
}


/*
 * Main function. It will request the tempC from the sensors and display on Serial.
 */
void loop(void)
{
  // call sensors.requestTemperatures() to issue a global temperature
  // request to all devices on the bus
  Serial.print("Requesting temperatures...");
  sensors.requestTemperatures(); // Send the command to get temperatures
  Serial.println("DONE");

  // It responds almost immediately. Let's print out the data
  printTemperature(insideThermometer); // Use a simple function to print out the data
  
  // digitalWrite(SIMRST, HIGH);
  String msg = "";
  mySerial.println("AT+CMGR=1");
  Serial.println("AT+CMGR=1");
  // updateSerial();
  String c = mySerial.readString();
  c.toUpperCase();
  // updateSerial();
  Serial.println(c);
  int a;
  a = c.indexOf("+CMGR");
  number = "";
  // order = "";
  if (a >= 0)
  {
    mySerial.println("AT+CMGDA=DEL READ");

    a = c.indexOf("+989");
    number = c.substring(a, a + 13);
    // Serial.print(number);
    a = c.indexOf("#");
    int d = c.indexOf("*");
    order = (c.substring(a + 1, d));
    // Serial.print(order);
    Serial.print("order->   ");
    Serial.print(order);
    Serial.print("\n");
    Serial.print("number->   ");

    Serial.println(number);
  }

  // c = mySerial.readString();
  if (order.indexOf("ON") >= 0)
  {
    msg = "Led Is ON";
    digitalWrite(LED_BUILTIN, LOW);
  
  }
  else if (order.indexOf("OFF") >= 0)
  {
    msg = "Led Is OFF";
    digitalWrite(LED_BUILTIN, HIGH);
  }
  else if (order.indexOf("BLINK") >= 0)
  {
    digitalWrite(LED_BUILTIN, HIGH);
    delay(500);
    digitalWrite(LED_BUILTIN, LOW);
    delay(500);
    msg = "Led Is Blinking";
  }
  else
  {
    delay(500);
    msg = "";
  }
  a = number.indexOf("+989");
  if (msg != "" && a >= 0)
  {

    number = "\"" + number;
    number = number + "\"";
    number = "AT+CMGS=" + number;
    Serial.println(number);

    mySerial.println(number);

    // change ZZ with country code and xxxxxxxxxxx with phone number to sms
    updateSerial();
    msg=msg+"\n";
    msg=msg+"Temp= ";
    msg=msg+mytemp;
    mySerial.print(msg);
    // text content
    updateSerial();
    mySerial.write(26);
    c = "";
  }
  Serial.print("\n");
}
