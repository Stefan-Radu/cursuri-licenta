#include "LedControl.h" //  need the library
const int dinPin = 12;
const int clockPin = 11;
const int loadPin = 10;

const int matrixSize = 8;
const int xPin = A0;
const int yPin = A1;

int xValue = 0;
int yValue = 0;

byte xPos = 0;
byte yPos = 0;

byte xLastPos = 0;
byte yLastPos = 0;

int matrixBrightness = 5;
const int minThreshold = 200;
const int maxThreshold = 600;

unsigned long lastMoved = 0;
const int moveInterval = 100;
LedControl lc = LedControl(dinPin, clockPin, loadPin, 1); //DIN, CLK, LOAD, No. DRIVER

bool matrixUpdate = true;

// bool matrix[matrixSize][matrixSize] = {
//   {0, 0, 0, 0, 0, 0, 0, 0},
//   {0, 0, 0, 0, 0, 0, 0, 0},
//   {0, 0, 0, 0, 0, 0, 0, 0},
//   {0, 0, 0, 0, 0, 0, 0, 0},
//   {0, 0, 0, 0, 0, 0, 0, 0},
//   {0, 0, 0, 0, 0, 0, 0, 0},
//   {0, 0, 0, 0, 0, 0, 0, 0},
//   {0, 0, 0, 0, 0, 0, 0, 0}  
// };

byte matrix[matrixSize] = {
  B01110000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000
};


void setup() {
  Serial.begin(9600);
  // the zero refers to the MAX7219 number, it is zero for 1 chip
  lc.shutdown(0, false); // turn off power saving, enables display
  lc.setIntensity(0, matrixBrightness); // sets brightness (0~15 possible values)
  lc.clearDisplay(0);// clear screen
}

void loop() {
  // game logic
  
  
  updateDisplay();
//   if (millis() - lastMoved > moveInterval) {
//     updatePositions();
//     lastMoved = millis();
//   }
  
//   // display function
//   if (joyMoved == true) {
//     updateDisplay();
//     joyMoved = false;
//   }
}

void updateDisplay() {
  for (int i = 0; i < 8; ++i) {
    for (int j = 0; j < 8; ++ j) {
      lc.setLed(0, i, j, true);
      delay(50);
    }
  }

  for (int i = 0; i < 8; ++i) {
    for (int j = 0; j < 8; ++ j) {
      lc.setLed(0, i, j, false);
      delay(50);
    }
  }
}

void updatePositions() {
  xLastPos = xPos;
  yLastPos = yPos;
  xValue = analogRead(xPin);
  yValue = analogRead(yPin);
  if (xValue < minThreshold) {
    if (xPos > 0) {
      xPos--;
    }
    else {
      xPos = matrixSize - 1;
    }
  }
  
  if (xValue > maxThreshold) {
    if (xPos < matrixSize - 1) {
      xPos++;
    }
    else {
      xPos = 0;
    }
  }
  
  if (yValue < minThreshold) {
    if (yPos > 0) {
      yPos--;
    }
    else {
      yPos = matrixSize - 1;
    }
  }
  
  if (yValue > maxThreshold) {
    if (yPos < matrixSize - 1) {
      yPos++;
    }
    else {
      yPos = 0;
    }
  }
  
  if (xLastPos != xPos || yLastPos != yPos) {
    matrixUpdate = true;
  }
  // matrix[xPos][yPos] = 1;
  // matrix[xLastPos][yLastPos] = 0;
}
