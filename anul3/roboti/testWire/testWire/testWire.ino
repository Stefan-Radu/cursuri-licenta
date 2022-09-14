#include <Wire.h>

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Serial.println("master");
  
  Wire.begin();
  
  Wire.beginTransmission(7);
  Wire.write(0);
  Wire.endTransmission();

  int received;
  while (true) {  
    received = 0;
    Wire.requestFrom(7, 7 * 2 * 2 + 2);
    while (true) {
      int note, duration;
      Wire.readBytes((byte*)&note, sizeof(note));
      if (note == -1) {
        received = 0;
        break;
      } else if (note == -2) {
        break;
      }
      Wire.readBytes((byte*)&duration, sizeof(duration)); 
      Serial.print(note);
      Serial.print(" ");
      Serial.println(duration);
      //delay(200);
      received += sizeof(note) + sizeof(duration);
    }
    // Serial.println(received);
    if (received == 0) {
      Serial.println("done");
      break;
    }
  }
}

void loop() {
  // put your main code here, to run repeatedly:

}
