#include <SoftwareSerial.h>

// GSM module pins
SoftwareSerial gsm(7, 8); // RX, TX

// Pin for the light sensor
const int lightSensorPin = A0; // Analog pin for LDR
const int threshold = 300; // Threshold value for light detection
const String phoneNumber = "1234567890"; // Replace with your phone number
const int pollNumber = 1; // Example poll number

void setup() {
  Serial.begin(9600);
  gsm.begin(9600);
  delay(100);
  Serial.println("System Starting...");
}

void loop() {
  int lightValue = analogRead(lightSensorPin);
  Serial.print("Light Sensor Value: ");
  Serial.println(lightValue);

  // Check if the light has stopped working
  if (lightValue < threshold) {
    sendSMS();
    delay(60000); // Wait for 1 minute before checking again to avoid spamming
  }
  
  delay(5000); // Check every 5 seconds
}

void sendSMS() {
  Serial.println("Sending SMS...");
  
  // Check if the GSM module is responding
  gsm.println("AT"); 
  delay(100);
  
  // Set SMS to text mode
  gsm.println("AT+CMGF=1");
  delay(100);
  
  // Construct the message
  String message = "Alert! The street light has stopped working at poll number: " + String(pollNumber);
  
  // Set the recipient number
  gsm.println("AT+CMGS=\"" + phoneNumber + "\"");
  delay(100);
  
  // Send the SMS message
  gsm.println(message);
  delay(100);
  
  // Indicate the end of the message
  gsm.println((char)26); // Send Ctrl+Z to indicate end of message
  Serial.println("SMS sent.");
}

