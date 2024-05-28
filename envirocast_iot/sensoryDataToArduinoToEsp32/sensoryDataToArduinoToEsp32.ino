#include <DHT.h>

#define MQ5_PIN A0
#define MQ7_PIN A1
#define MQ135_PIN A2
#define DHT_PIN 2
#define DHT_TYPE DHT11
#define DUST_SENSOR_LED_PIN 3
#define DUST_SENSOR_VOUT_PIN A3

DHT dht(DHT_PIN, DHT_TYPE);

void setup() {
  Serial.begin(9600); // Initialize Serial communication
  dht.begin(); // Initialize DHT sensor
  pinMode(DUST_SENSOR_LED_PIN, OUTPUT); // Set the LED pin as output
}

void loop() {
  // Read gas sensor values
  float mq5Value = analogRead(MQ5_PIN);
  float mq7Value = analogRead(MQ7_PIN);
  float mq135Value = analogRead(MQ135_PIN);

  // Read DHT11 sensor values
  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();

  // Read dust sensor value
  digitalWrite(DUST_SENSOR_LED_PIN, LOW); // Power on the LED
  delayMicroseconds(280); // Wait 280us
  int dustValue = analogRead(DUST_SENSOR_VOUT_PIN); // Read the dust sensor value
  digitalWrite(DUST_SENSOR_LED_PIN, HIGH); // Power off the LED
  delayMicroseconds(9680); // Wait 9680us

  // Send values to ESP32
  Serial.print(mq5Value); Serial.print(",");
  Serial.print(mq7Value); Serial.print(",");
  Serial.print(mq135Value); Serial.print(",");
  Serial.print(humidity); Serial.print(",");
  Serial.print(temperature); Serial.print(",");
  Serial.println(dustValue);

  delay(2000); // Wait for 2 seconds before the next reading
}
