#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

const char* ssid = "TO_DO";
const char* pass = "TO_DO";
const int vibration_pin = D2;
const int check_every = 30 * 60;  // 30 minutes Stored in Seconds
const String api_alarms = "https://users.it.teithe.gr/~it185369/Haptics/api/v1/microcontroller/micro.php";
unsigned long vibrationDuration = 30000;  // 30 seconds
unsigned long Wifi_Check_Millis =  millis();  
unsigned long vibrationStartTime = 0;

float find_sec(String timeString);
String get_AlarmType(String jsonResponse);
String timeString;
void setup() {
  Serial.begin(115200);
  pinMode(vibration_pin, OUTPUT);
  digitalWrite(vibration_pin, LOW);
  // Wifi_Connection
  Serial.println("Connecting to Wi-Fi...");
  WiFi.begin(ssid, pass);
  WiFi.setHostname("MY_ESP");
  while (WiFi.status() != WL_CONNECTED) {

    //Trying to Connect  for 10 Seconds
    if (millis() - Wifi_Check_Millis > 10000) {
      Serial.println("\n Failed to connect to Wi-Fi within 10 seconds. Going for deep sleep.");
      Wifi_Check_Millis = millis();  
      ESP.deepSleep(check_every * 1000000);
    } else {
      delay(250);
      Serial.print(".");
    }
  }
  Serial.println("\nConnected to Wi-Fi!");

// Prepare the Get Request
  HTTPClient http;
  WiFiClientSecure wifiClientSecure;
  wifiClientSecure.setInsecure();

  http.begin(wifiClientSecure, api_alarms);
  int status_code = http.GET();
  if (status_code == 200) {
    String response = http.getString();
    http.end();
    WiFi.disconnect()
  
    float second = find_sec(response);
    if (second > 10) {
      // Serial.println("Sleeping for 10 seconds to 30 minutes");
      ESP.deepSleep((second - 10) * 1000000);
    } else if (second < 10) {
      vibrationStartTime = millis();  
      digitalWrite(vibration_pin, HIGH);
      while (millis() - vibrationStartTime < vibrationDuration) {
        String alarmType = get_AlarmType(response); 
        if (alarmType.equals("Emergency")) {
                // Serial.println("Emergency");
                digitalWrite(vibration_pin, HIGH);
                delay(500);  
                digitalWrite(vibration_pin, LOW);
                delay(400);  
            }
            else if (alarmType.equals("Standar")) {
                // Serial.println("Standar");
                digitalWrite(vibration_pin, HIGH);
                delay(200);  
                digitalWrite(vibration_pin, LOW);
                delay(200); 
            }
      }
      digitalWrite(vibration_pin, LOW);  
      http.end();
      // Serial.println("DeepSleep for 1 miliSecond and check again");
      ESP.deepSleep(1000);
    }
    http.end();
  } else if (status_code == 404) {
    //Serial.println("DeepSleep for 30 minutes and check again");
    ESP.deepSleep(check_every * 1000000);
    http.end();

  } else {
    // Serial.println("Problem with the server. Sleep for 30 minutes and check again");
    ESP.deepSleep(check_every * 1000000);
  }
}

// Functions

 float find_sec(String jsonResponse) {
  int startIndex = jsonResponse.indexOf("\"time_diff\":\"") + 13;
  int endIndex = jsonResponse.indexOf("\"", startIndex);
  String timeString = jsonResponse.substring(startIndex, endIndex);
  int minutes = timeString.substring(3, 5).toInt();
  int seconds = timeString.substring(6, 8).toInt();
  return (minutes * 60 + seconds);
 }

String get_AlarmType(String jsonResponse) {
  int startIndex = jsonResponse.indexOf("\"Type\":\"") + 8;  
  int endIndex = jsonResponse.indexOf("\"", startIndex);
  return jsonResponse.substring(startIndex, endIndex);
}

void loop() {
}