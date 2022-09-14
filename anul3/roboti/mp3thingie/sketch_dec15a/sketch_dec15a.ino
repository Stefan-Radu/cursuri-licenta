#include "Arduino.h"
#include "SoftwareSerial.h"
#include "DFRobotDFPlayerMini.h" // Requisite Library

SoftwareSerial mySoftwareSerial(10, 11); // RX, TX
DFRobotDFPlayerMini myDFPlayer;

void setup() {
  mySoftwareSerial.begin(9600);
  Serial.begin(9600);
  Serial.println();
  Serial.println(F("MP3 TF 16P Module Test"));
  Serial.println(F("Initializing MP3 TF 16P >>> (May take a couple of seconds)"));

  if (!myDFPlayer.begin(mySoftwareSerial)) { 
    Serial.println(F("Unable to begin:"));
    Serial.println(F("1.Please recheck the connection!"));
    Serial.println(F("2.Please insert the SD card!"));
    while(true);
  }

  Serial.println(F("MP3 TF 16P Module Active!"));

  myDFPlayer.volume(5);  //Set volume value to 30
  myDFPlayer.play(1);  //Play the first mp3
}

void loop() {
}
