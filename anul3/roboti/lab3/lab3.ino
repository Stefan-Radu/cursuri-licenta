const int pinA = 2;
const int pinB = 3;
const int pinC = 4;
const int pinD = 5;
const int pinE = 6;
const int pinF = 7;
const int pinG = 8;
const int pinDP = 9;

const int segSize = 8;

int segments[segSize] = {
  pinA, pinB, pinC, pinD, pinE, pinF, pinG, pinDP
};

int state[segSize] = {
  LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW
};

const int noOfDigits = 10;

byte digitMatrix[noOfDigits][segSize] = {
// a  b  c  d  e  f  g
  {1, 1, 1, 1, 1, 1, 0, 0}, // 0
  {0, 1, 1, 0, 0, 0, 0, 0}, // 1
  {1, 1, 0, 1, 1, 0, 1, 0}, // 2
  {1, 1, 1, 1, 0, 0, 1, 0}, // 3
  {0, 1, 1, 0, 0, 1, 1, 0}, // 4
  {1, 0, 1, 1, 0, 1, 1, 0}, // 5
  {1, 0, 1, 1, 1, 1, 1, 0}, // 6
  {1, 1, 1, 0, 0, 0, 0, 0}, // 7
  {1, 1, 1, 1, 1, 1, 1, 0}, // 8
  {1, 1, 1, 1, 0, 1, 1, 0}  // 9
};

int digit = 0;
bool point = false;

const int pinSW = 13; // digital pin connected to switch output
const int pinX = A0; // A0 - analog pin connected to X output
const int pinY = A1;

int switchValue;
int xValue = 0;
int yValue = 0;

void setup() {
  // put your setup code here, to run once:

  pinMode(pinSW, INPUT_PULLUP);
  // Start the serial communication.
  Serial.begin(9600);
  
  for (int i = 0; i < segSize; ++ i) {
    pinMode(segments[i], OUTPUT);
    digitalWrite(segments[i], LOW);
  }
}

int moved = false;
int lastState = HIGH;

void loop() {
  
  // put your main code here, to run repeatedly:

  for (int i = 0; i < segSize; ++ i) {
    digitalWrite(segments[i], digitMatrix[digit][i]); 
  }
  digitalWrite(segments[segSize - 1], point);

  switchValue = digitalRead(pinSW);
  if (switchValue != lastState) {
    if (switchValue == LOW) {
      point = !point;
    }
  }
  lastState = switchValue;
  
  yValue = analogRead(pinY);

  if (yValue > 1000 && !moved) {
    digit++;
    moved = true;
  }
  else if (yValue < 200 && !moved) {
    digit--;
    moved = true;
  }

  if (yValue >= 200 && yValue <= 1000) {
    moved = false;
  }

  if (digit == -1) digit = 9;
  else if (digit == 10) digit = 0;

  // delay(200);
}
