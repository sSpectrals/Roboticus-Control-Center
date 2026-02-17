#include <ArduinoJson.h> // Important note the syntax used in this example is ArduinoJson V7

// Define structs for the data types
struct Sensor {
  const char* name;
  float input;
  const char* operator_str;
  float threshold;
  int x;
  int y;
};

struct Vector {
  const char* name;
  float rotation;
  const char* color;
  int x;
  int y;
};

// Create arrays of sensors
Sensor sensors[] = {
  // Temperature sensors
  { "temperature_1", 23.5, ">=", 30.0, 10, 20 },
  { "temperature_2", 18.2, "<=", 20.0, 12, 22 },
  { "temperature_3", 31.7, ">=", 28.0, 14, 24 },
  { "temperature_4", 22.1, "<=", 25.0, 16, 26 },
  { "temperature_5", 27.8, ">=", 26.5, 18, 28 },
  { "temperature_6", 19.4, "<=", 22.0, 20, 30 },
  { "temperature_7", 33.2, ">=", 32.0, 22, 32 },
  { "temperature_8", 24.6, "<=", 26.0, 24, 34 },

  // Humidity sensors
  { "humidity_1", 65.2, "<=", 70.0, 11, 21 },
  { "humidity_2", 82.5, ">=", 80.0, 13, 23 },
  { "humidity_3", 45.8, "<=", 50.0, 15, 25 },
  { "humidity_4", 73.1, ">=", 72.0, 17, 27 },
  { "humidity_5", 55.3, "<=", 60.0, 19, 29 },
  { "humidity_6", 88.7, ">=", 85.0, 21, 31 },
  { "humidity_7", 38.9, "<=", 40.0, 23, 33 },
  { "humidity_8", 76.4, ">=", 75.0, 25, 35 },
};

// Create arrays of vectors
Vector vectors[] = {
  // Motors
  { "motor_1", 45.0, "#FF5733", 5, 10 },
  { "motor_2", 90.0, "#33FF57", 8, 12 },
  { "motor_3", 135.0, "#3357FF", 11, 14 },
  { "motor_4", 180.0, "#FF33F5", 14, 16 },
  { "motor_5", 225.0, "#F5FF33", 17, 18 },
  { "motor_6", 270.0, "#33FFF5", 20, 20 },
  { "motor_7", 315.0, "#FF33A8", 23, 22 },
  { "motor_8", 360.0, "#A833FF", 26, 24 },

  // Servos
  { "servo_1", 30.0, "#FF8C33", 29, 26 },
  { "servo_2", 60.0, "#33FF8C", 32, 28 },
  { "servo_3", 120.0, "#8C33FF", 35, 30 },
  { "servo_4", 150.0, "#FF338C", 38, 32 },
  { "servo_5", 210.0, "#33FFC4", 41, 34 },
  { "servo_6", 240.0, "#C433FF", 44, 36 },
  { "servo_7", 300.0, "#FFC433", 47, 38 },
  { "servo_8", 330.0, "#33A8FF", 50, 40 },
};

// Calculate array sizes
const int numSensors = sizeof(sensors) / sizeof(sensors[0]);
const int numVectors = sizeof(vectors) / sizeof(vectors[0]);


void setup() {

  Serial.begin(115200);
}

void loop() {
  JsonDocument doc;
  doc["timestamp"] = millis();

  // Add sensors array
  JsonArray sensorsArray = doc["sensors"].to<JsonArray>();

  for (int i = 0; i < numSensors; i++) {
    // Add object to array - v7 syntax using add<JsonObject>()
    JsonObject sensorObj = sensorsArray.add<JsonObject>();
    sensorObj["name"] = sensors[i].name;
    sensorObj["input"] = sensors[i].input;
    sensorObj["operator"] = sensors[i].operator_str;
    sensorObj["threshold"] = sensors[i].threshold;


    JsonObject location = sensorObj["location"].to<JsonObject>();
    location["x"] = sensors[i].x;
    location["y"] = sensors[i].y;
  }

  // Add vectors array
  JsonArray vectorsArray = doc["vectors"].to<JsonArray>();

  for (int i = 0; i < numVectors; i++) {
    JsonObject vectorObj = vectorsArray.add<JsonObject>();
    vectorObj["name"] = vectors[i].name;
    vectorObj["rotation"] = vectors[i].rotation;
    vectorObj["color"] = vectors[i].color;

    JsonObject location = vectorObj["location"].to<JsonObject>();
    location["x"] = vectors[i].x;
    location["y"] = vectors[i].y;
  }

  // This is optional according to ArduinoJson docs, decreases memory usage by a lot.
  doc.shrinkToFit();


  serializeJson(doc, Serial);
  Serial.println();  // VERY IMPORTANT! \n or the "new line" character is used as a delimiter, without this the application won't be able to parse the json document

  for (int i = 0; i < numSensors; i++) {
    sensors[i].input += 1.0;  
  }


}
