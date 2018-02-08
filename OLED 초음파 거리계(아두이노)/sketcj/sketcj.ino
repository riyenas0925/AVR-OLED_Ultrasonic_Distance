#include <SoftwareSerial.h>

SoftwareSerial esp8266(2, 3);

void setup()
{
  Serial.begin(9600);
  esp8266.begin(9600);

  Serial.flush();

  esp8266.print("AT+RST\r\n"); // reset for esp8266
  delay(500);
  esp8266.flush();//clear serial1
  // Check AT
  esp8266.print("AT"); // reset for esp8266
  esp8266.print("AT+CIFSR\r\n");// learn the ip which token for esp8266
  delay(500);
  if (esp8266.find("ready"))
  {
    esp8266.flush();
    esp8266.print("AT+CIFSR\r\n");
    delay(500);
    Serial.println("CIHAZ IP ADRESI:" + esp8266.readString()); // print esp8266 ip

  }
  else
  {
    Serial.println("there is no internet connection");
  }
  esp8266.print("AT+CIPMUX=1\r\n");//ser mux 1 so we want to connect as multiple users
  delay(500);
  if (esp8266.find("OK"))
  {
    Serial.println("Mux ok");
  }
  else
  {
    Serial.println("MUX failed");
  }
  esp8266.print("AT+CIPSERVER=1,23\r\n");// set esp8266 as server
  delay(500);
  if (esp8266.find("OK"))
  {
    Serial.println("SERVER started");
  }
  else
  {
    Serial.println("SERVER failed");
  }

}
void loop()
{

  if (esp8266.available())
  {
    Serial.print(esp8266.readString()); // get message which comes from clients.
  }
}
