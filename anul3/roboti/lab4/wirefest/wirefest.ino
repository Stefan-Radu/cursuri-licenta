// define arduino input connections

const int seg1 = 7,
          seg2 = 6,
          seg3 = 5,
          seg4 = 4;

const int displayCount = 4;
const int displayDigits[] = {
  seg1, seg2, seg3, seg4
};

// DS
const int dataPin = 12; // DS
const int latchPin = 11; // STCP 
const int clockPin = 10; // SHCP

int digitArray[16] = {
//A B C D E F G DP 
  B11111100, // 0
  B01100000, // 1
  B11011010, // 2
  B11110010, // 3
  B01100110, // 4
  B10110110, // 5
  B10111110, // 6
  B11100000, // 7
  B11111110, // 8
  B11110110, // 9
  B11101110, // A
  B00111110, // b
  B10011100, // C
  B01111010, // d
  B10011110, // E
  B10001110  // F
};

void writeRegister(int digit) {
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, MSBFIRST, digit);
  digitalWrite(latchPin, HIGH);
}

void showDigit(int displayNumber) {
  for (int i = 0; i < displayCount; ++ i) {
    digitalWrite(displayDigits[i], HIGH);
  }
  digitalWrite(displayDigits[displayNumber], LOW);
}

int delayAmount = 5;

void writeNumber(int number) {
  int currentNumber = number;
  int displayDigit = 0;
  int lastDigit;
  while (currentNumber) {
    lastDigit = currentNumber % 10;
    showDigit(displayDigit);
    writeRegister(digitArray[lastDigit]);
    currentNumber /= 10;
    displayDigit ++;
    delay(delayAmount);
  }
}

void setup () {
  pinMode(dataPin, OUTPUT);
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  for (int i = 0; i < displayCount; ++ i) {
    pinMode(displayDigits[i], OUTPUT);
    digitalWrite(displayDigits[i], LOW);
  }
  Serial.begin(9600);
}

int hm = 1;

void loop() {
   writeNumber(millis() / 100);
   
   //delayAmount += hm;
   //if (delayAmount == 500 || delayAmount == 0) hm *= -1;
   //delay(10);
  //writeRegister(digitArray[2]);
//  for (int i = 0; i < 8; ++ i) {
//    registers[i] = LOW;
//    writeRegister();
//    delay(100);
//  }
//  
//  for (int i = 7; i >= 0; -- i) {
//    registers[i] = HIGH;
//    writeRegister();
//    delay(100);
//  }
}
