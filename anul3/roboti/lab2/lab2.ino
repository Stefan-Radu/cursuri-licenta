const int pushButton = 2;
const int ledPin = 8;

int cnt = 0;
bool ledState = LOW;
bool lastState = LOW;
bool reading = LOW;
bool buttonState = LOW;

unsigned int debounceDelay = 50;
unsigned int lastDebounceTimer = 0;

void setup() {
  Serial.begin(9600);
  pinMode(pushButton, INPUT_PULLUP);
  pinMode(ledPin, OUTPUT);
}

void loop() {
  reading = digitalRead(pushButton);
  if (reading != lastState) {
    lastDebounceTimer = millis();
  }

  if (millis() - lastDebounceTimer > debounceDelay) {
    if (reading != buttonState) {
      buttonState = reading;
      if (buttonState == HIGH) {
        ledState = !ledState;
      }
      digitalWrite(ledPin, ledState);
    }
  }

  lastState = reading;
}
