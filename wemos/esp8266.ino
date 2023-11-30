#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

unsigned long vibrationStartTime = 0;
const char* ssid = "**";
const char* pass = "**";
const String api_alarms = "https://users.it.teithe.gr/~it185369/Haptics/api/v1/microcontroller/micro.php";
unsigned long vibrationDuration = 30000;  // 30 seconds
const int ledPin = D2;
const int check_every = 30 * 60;  // 30 minutes
// Assuming the LED is connected to GPIO pin D2
String extractTimeDiff(String jsonResponse);
float find_sec(String timeString);
String get_AlarmType(String jsonResponse);
unsigned long Wifi_Check_Millis = millis();  // Record the start time

void setup() {
  Serial.begin(115200);
  pinMode(ledPin, OUTPUT);

  // Wifi_Connection
  Serial.println("Connecting to Wi-Fi...");
  WiFi.begin(ssid, pass);
  WiFi.setHostname("MY_ESP");
  while (WiFi.status() != WL_CONNECTED) {
    if (millis() - Wifi_Check_Millis > 10000) {//If not connected in 10 seconds Go to deep  sleep
      Serial.println("\n Failed to connect to Wi-Fi within 10 seconds. Going for deep sleep.");
      ESP.deepSleep(check_every * 1000000);
      break;  // Exit the while loop
    }
    
    delay(250);
    Serial.print(".");
  }
  Serial.println("\nConnected to Wi-Fi!");

  digitalWrite(ledPin, LOW);
  HTTPClient http;
  WiFiClientSecure wifiClientSecure;
  wifiClientSecure.setInsecure();
  http.begin(wifiClientSecure, api_alarms);
  int status_code = http.GET();

  if (status_code == 200) {
    String response = http.getString();
    String time_diff = extractTimeDiff(response);
    float second = find_sec(time_diff);
    Serial.println(response);
    Serial.println(second);

    if (second > 10) {
      Serial.println("Sleeping for 10 seconds to 30 minutes");
      ESP.deepSleep((second - 10) * 1000000);

    } else if (second < 10) {
      vibrationStartTime = millis();  // Record the start time of the vibration
      digitalWrite(ledPin, HIGH);
      while (millis() - vibrationStartTime < vibrationDuration) {
        String alarmType = get_AlarmType(response);  // Get the alarm type once
        if (alarmType.equals("Emergency")) {
                Serial.println("Emergency");
                digitalWrite(ledPin, HIGH);
                delay(1000);  // Vibration ON duration
                digitalWrite(ledPin, LOW);
                delay(200);  // Vibration OFF duration
  
            }
            else if (alarmType.equals("Standar")) {
                Serial.println("Standar");
                digitalWrite(ledPin, HIGH);
                delay(500);  // Vibration ON duration
                digitalWrite(ledPin, LOW);
                Serial.println("Not Vibrating");
                delay(200);  // Vibration OFF duration
            }
      }
        digitalWrite(ledPin, LOW);  // Turn off the LED

      http.end();
      Serial.println("DeepSleep for 1 second and check again");
      ESP.deepSleep(1000);
    }

    digitalWrite(ledPin, LOW);  // Turn off the LED

    http.end();

  } else if (status_code == 404) {
    Serial.println("DeepSleep for 30 minutes and check again");
    ESP.deepSleep(check_every * 1000000);
    http.end();

  } else {
    Serial.println("Problem with the server. Sleep for 30 minutes and check again");
    ESP.deepSleep(check_every * 1000000);
    http.end();
  }
}

// Functions
float find_sec(String timeString) {
  int minutes = timeString.substring(3, 5).toInt();
  int seconds = timeString.substring(6, 8).toInt();
  return (minutes * 60 + seconds);
}

String get_AlarmType(String jsonResponse) {
  int startIndex = jsonResponse.indexOf("\"Type\":\"") + 8;  // Adjusted the offset
  int endIndex = jsonResponse.indexOf("\"", startIndex);
  return jsonResponse.substring(startIndex, endIndex);
}

String extractTimeDiff(String jsonResponse) {
  int startIndex = jsonResponse.indexOf("\"time_diff\":\"") + 13;
  int endIndex = jsonResponse.indexOf("\"", startIndex);
  return jsonResponse.substring(startIndex, endIndex);
}

void loop() {
  // Empty loop as your program doesn't require continuous execution in the loop.
}
