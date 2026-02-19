#include <ArduinoJson.h> // Important note the syntax used in this example is ArduinoJson V7

// Define structs for the data types
struct Sensor {
  String name;
  float input;
  String operatorStr;
  float threshold;
  int x;
  int y;

  bool isTriggered() const {
    if (operatorStr == ">=")
      return input >= threshold;
    if (operatorStr == "<=")
      return input <= threshold;
    if (operatorStr == ">")
      return input > threshold;
    if (operatorStr == "<")
      return input < threshold;
    if (operatorStr == "==")
      return input == threshold;
    if (operatorStr == "!=")
      return input != threshold;
    return false; // Invalid operator
  }
};

struct Vector {
  const char *name;
  float rotation;
  const char *color;
  int x;
  int y;
};

// Create arrays of sensors  ||  name | input | operatorStr | threshold | x | y
Sensor sensors[] = {
    // IR sensors
    {"IR_1", 23.5, ">=", 30.0, 0, 0},
    {"IR_2", 18.2, "<=", 20.0, 1, 1},
    {"IR_3", 31.7, ">", 28.0, 2, 2},
    {"IR_4", 22.1, "<", 25.0, 3, 3},
    {"IR_5", 27.8, "==", 26.5, 4, 4}};

// Create arrays of vectors
Vector vectors[] = {
    // Motors
    {"Line avoidance", 45.0, "#FF5733", 0, -2},
    {"Line tracker", 90.0, "#33FF57", 0, -4},
    {"Ball", 135.0, "#3357FF", 0, -6},
};

// Calculate array sizes
const int numSensors = sizeof(sensors) / sizeof(sensors[0]);
const int numVectors = sizeof(vectors) / sizeof(vectors[0]);

void setup() { Serial.begin(9600); }

void loop() {
  JsonDocument doc;
  doc["timestamp"] = millis();

  // Add sensors array
  JsonArray sensorsArray = doc["sensors"].to<JsonArray>();

  for (int i = 0; i < numSensors; i++) {
    // Add object to array
    JsonObject sensorObj = sensorsArray.add<JsonObject>();
    sensorObj["name"] = sensors[i].name;
    sensorObj["input"] = sensors[i].input;
    sensorObj["isTriggered"] = sensors[i].isTriggered();
    sensorObj["threshold"] = sensors[i].threshold;

    JsonObject location = sensorObj["location"].to<JsonObject>();
    location["x"] = sensors[i].x;
    location["y"] = sensors[i].y;
  }

  // Add vectors array
  JsonArray vectorsArray = doc["vectors"].to<JsonArray>();

  for (int i = 0; i < numVectors; i++) {
    // Add object to array
    JsonObject vectorObj = vectorsArray.add<JsonObject>();
    vectorObj["name"] = vectors[i].name;
    vectorObj["rotation"] = vectors[i].rotation;
    vectorObj["color"] = vectors[i].color;

    JsonObject location = vectorObj["location"].to<JsonObject>();
    location["x"] = vectors[i].x;
    location["y"] = vectors[i].y;
  }

  // This is optional according to ArduinoJson docs, decreases memory usage by a
  // lot.
  doc.shrinkToFit();

  serializeJson(doc, Serial);

  for (int i = 0; i < numSensors; i++) {
    sensors[i].input += 1.0;
  }
}
