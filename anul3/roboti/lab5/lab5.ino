#include <LiquidCrystal.h>

const int RS = 12,
          enable = 11,
          d4 = 5,
          d5 = 4,
          d6 = 3,
          d7 = 2,
          trig = 8,
          echo = 7;

LiquidCrystal lcd(RS, enable, d4, d5, d6, d7);

long duration = 0;
float distance = 0;
String incomingString = "";

void setup() {
  // put your setup code here, to run once:
  lcd.begin(16, 2);
  // lcd.print("Hello world");

  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);

  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  // lcd.setCursor(0, 1);

//  lcd.scrollDisplayLeft();
//  delay(500);
//
//  digitalWrite(trig, LOW);
//  delayMicroseconds(2);
//  digitalWrite(trig, HIGH);
//  delayMicroseconds(10);
//  digitalWrite(trig, LOW);
//
//  duration = pulseIn(echo, HIGH);
//  float readDistance = duration * 0.034 / 2;
//
//  if (readDistance <= 50) {
//    distance = readDistance;
//  }
//
//  Serial.println(distance);
//  lcd.setCursor(0, 1);
//  lcd.clear();
//  lcd.print(distance);
//
//  delay(500);
    if (Serial.available() > 0) {
      byte incomingByte = Serial.read();

      if (incomingByte == 10) {
        lcd.clear();
        lcd.print(incomingString);
        incomingString = "";
      }
      else {
        incomingString += char(incomingByte);
      }
    }

//    Serial.read();
    
}
