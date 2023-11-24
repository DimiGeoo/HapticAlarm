
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

unsigned long vibrationStartTime = 0;
const char* ssid = "Dimitris";
const String api_alarms = "https://users.it.teithe.gr/~it185369/Haptics/api/v1/microcontroller/micro.php";
unsigned long vibrationDuration = 30000;  // 3 seconds
const int ledPin = D2;   
String extractTimeDiff(String jsonResponse);
float find_sec(String timeString);
String get_AlarmType(String jsonResponse);

void setup() {
  Serial.begin(115200);
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);

// Wifi_Connection
  Serial.println("Connecting to Wi-Fi...");
  WiFi.begin(ssid, ssid);
  WiFi.setHostname("MY_ESP");
   while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
  }
  Serial.println("\nConnected to Wi-Fi!");
  
// Make the GET  request
  HTTPClient http;
  WiFiClientSecure wifiClientSecure;
  wifiClientSecure.setInsecure();
  http.begin(wifiClientSecure, api_alarms);
  int status_code = http.GET();

  if (status_code == 200) {
    String response = http.getString();
    String time_diff = extractTimeDiff(response);
    float ms = find_sec(time_diff);
    Serial.println(response);
    Serial.println(ms);

    if (ms > 10) {
          Serial.println("Ypu 10secs-15 minites");
          ESP.deepSleep((ms-10)*1000000);

    } else if (ms < 10) {
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

      Serial.println("DeepSleep for 1 second and  check again");
      ESP.deepSleep((1)*1000000);
    }


  } else if (status_code == 404) {
        Serial.println("DeepSleep for 15 minites and check again");
        ESP.deepSleep(15*60e6);

  }else {
        Serial.println("DeepSleep for 15 minites and check again");
        ESP.deepSleep(15*60e6);

  }

  http.end();


}
// Functions




float find_sec(String timeString) {
  int minutes = timeString.substring(3, 5).toInt();
  int seconds = timeString.substring(6, 8).toInt();
  return (minutes * 60 + seconds);
}
String get_AlarmType(String jsonResponse) {
  int startIndex = jsonResponse.indexOf("\"Type\":\"") + 8; // Adjusted the offset
  int endIndex = jsonResponse.indexOf("\"", startIndex);
  return jsonResponse.substring(startIndex, endIndex);
}




String extractTimeDiff(String jsonResponse) {
  int startIndex = jsonResponse.indexOf("\"time_diff\":\"") + 13;
  int endIndex = jsonResponse.indexOf("\"", startIndex);
  return jsonResponse.substring(startIndex, endIndex);
}
void loop() {
}


