#include <WiFi.h>
#include <Firebase_ESP_Client.h>

// Provide the token generation process info.
#include <addons/TokenHelper.h>

// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>

// Replace these with your WiFi credentials
#define WIFI_SSID "Tenda_0E9270"
#define WIFI_PASSWORD "Pakistan"

// Replace these with your Firebase project credentials
#define DATABASE_URL "https://aqi-testing3-default-rtdb.europe-west1.firebasedatabase.app/"
#define API_KEY "AIzaSyAmP9IpsbyS5ww6ABJgCpKmPFDafNXvNuk" // Web API Key from Firebase project settings

// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
bool signupOK = false;

void setup() {
  Serial.begin(115200); // Initialize Serial communication with Arduino
  Serial2.begin(9600, SERIAL_8N1, 16, 17); // Initialize Serial2 communication with Arduino Uno (RX, TX)

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  // Firebase configuration
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  
  // Sign up
  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("Firebase SignUp OK");
    signupOK = true;
  } else {
    Serial.printf("Firebase SignUp Failed: %s\n", config.signer.signupError.message.c_str());
  }

  // Assign the callback function for the long running token generation task
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop() {
  if (Firebase.ready() && signupOK) {
    if (Serial2.available()) {
      String data = Serial2.readStringUntil('\n');
      Serial.println("Received data: " + data); // Debug print received data
      float mq5Value, mq7Value, mq135Value, humidity, temperature;
      int dustValue;
      
      // Parse received data
      int values = sscanf(data.c_str(), "%f,%f,%f,%f,%f,%d", &mq5Value, &mq7Value, &mq135Value, &humidity, &temperature, &dustValue);

      if (values == 6) {
        // Create JSON object
        FirebaseJson json;
        json.set("mq5", mq5Value);
        json.set("mq7", mq7Value);
        json.set("mq135", mq135Value);
        json.set("humidity", humidity);
        json.set("temperature", temperature);
        json.set("dust", dustValue);

        // Send data to Firebase
        if (Firebase.RTDB.setJSON(&fbdo, "sensor_data", &json)) {
          Serial.println("Data sent to Firebase successfully");
        } else {
          Serial.printf("Failed to send data to Firebase: %s\n", fbdo.errorReason().c_str());
        }

        // Print received data to Serial
        Serial.printf("MQ5: %f, MQ7: %f, MQ135: %f, Humidity: %f, Temperature: %f, Dust: %d\n", mq5Value, mq7Value, mq135Value, humidity, temperature, dustValue);
      } else {
        Serial.println("Error: Received string format is incorrect");
      }
    }
  }
}
