const int vibrationPin = D2;
unsigned long vibrationStartTime;  // Define variable to store the start time
const unsigned long vibrationDuration = 10000;  // 10 seconds

void setup() {
  Serial.begin(115200);

  pinMode(vibrationPin, OUTPUT);
}

void loop() {
  digitalWrite(vibrationPin, HIGH);
    delay(1000);  // Vibration ON duration
    digitalWrite(vibrationPin, LOW);
    for (int i = 0; i < 5; i++) {
      activateVibrationPattern(i);
      digitalWrite(vibrationPin, HIGH);
      delay(1000);  // Vibration ON duration
      digitalWrite(vibrationPin, LOW);
  }

  // Wait for 9 seconds (10 seconds total period)
  delay(9000);
}

void activateVibrationPattern(int patternNumber) {
  vibrationStartTime = millis();  // Record the start time of the vibration

  switch (patternNumber) {
    case 0:
      // Pattern 1: Vibrate for 0.2 seconds, pause for 0.2 seconds, repeat
      while (millis() - vibrationStartTime < vibrationDuration) {
        Serial.println("Vibration 1");
        digitalWrite(vibrationPin, HIGH);
        delay(200);  // Vibration ON duration
        digitalWrite(vibrationPin, LOW);
        delay(200);  // Vibration OFF duration
      }
      break;
    case 1:
      // Pattern 2: Vibrate for 0.8 seconds, pause for 0.2 seconds, repeat
      while (millis() - vibrationStartTime < vibrationDuration) {
        Serial.println("Vibration 2");

        digitalWrite(vibrationPin, HIGH);
        delay(800);  // Vibration ON duration
        digitalWrite(vibrationPin, LOW);
        delay(200);  // Vibration OFF duration
      }
      break;
    case 2:
      // Pattern 3: Vibrate for 0.5 seconds, pause for 0.4 seconds, repeat
      while (millis() - vibrationStartTime < vibrationDuration) {
        Serial.println("Vibration 3");

        digitalWrite(vibrationPin, HIGH);
        delay(500);  // Vibration ON duration
        digitalWrite(vibrationPin, LOW);
        delay(400);  // Vibration OFF duration
      }
      break;
    case 3:
      // Pattern 4: Vibrate for 0.3 seconds, pause for 0.3 seconds, repeat
      while (millis() - vibrationStartTime < vibrationDuration) {
        Serial.println("Vibration 4");

        digitalWrite(vibrationPin, HIGH);
        delay(300);  // Vibration ON duration
        digitalWrite(vibrationPin, LOW);
        delay(300);  // Vibration OFF duration
      }
      break;
    case 4:
      // Pattern 5: Vibrate for 0.2 seconds, pause for 0.1 seconds, repeat
      while (millis() - vibrationStartTime < vibrationDuration) {
        Serial.println("Vibration 5");

        digitalWrite(vibrationPin, HIGH);
        delay(200);  // Vibration ON duration
        digitalWrite(vibrationPin, LOW);
        delay(100);  // Vibration OFF duration
      }
      break;
    default:
      break;
  }

  digitalWrite(vibrationPin, LOW);
}
