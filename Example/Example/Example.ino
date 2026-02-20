#include <ArduinoJson.h> // Important note the syntax used in this example is ArduinoJson V7

// Define structs for the data types
struct Sensor {
  String name; // if not given then app will show as "no name given"
  float input; // booleans also work (bool gets automatically parsed as 0.0
               // or 1.0) // If not given then app will show as "-1"
  String operatorStr;
  float threshold; // booleans also work (bool gets automatically parsed as 0.0
                   // or 1.0) // If not given then app will show as "-1"
  int x;           // if not given then app will show as 0
  int y;           // if not given then app will show as 0

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
  String name;
  float rotation;
  String color;
  int x;
  int y;
};

// Create arrays of sensors  ||  name | input | operatorStr | threshold | x | y
Sensor sensors[] = {
    // 20 points on a circle (radius 10) - every 18 degrees
    {"IR_1", 23.5, ">=", 30.0, 10.0, 0.0},
    {"IR_2", 18.2, "<=", 20.0, 9.51, 3.09},
    {"IR_3", 31.7, ">", 28.0, 8.09, 5.88},
    {"IR_4", 22.1, "<", 25.0, 5.88, 8.09},
    {"IR_5", true, "==", true, 3.09, 9.51},
    {"IR_6", 23.5, ">=", 30.0, 0.0, 10.0},
    {"IR_7", 18.2, "<=", 20.0, -3.09, 9.51},
    {"IR_8", 31.7, ">", 28.0, -5.88, 8.09},
    {"IR_9", 22.1, "<", 25.0, -8.09, 5.88},
    {"IR_10", true, "==", true, -9.51, 3.09},
    {"IR_11", 23.5, ">=", 30.0, -10.0, 0.0},
    {"IR_12", 18.2, "<=", 20.0, -9.51, -3.09},
    {"IR_13", 31.7, ">", 28.0, -8.09, -5.88},
    {"IR_14", 22.1, "<", 25.0, -5.88, -8.09},
    {"IR_15", true, "==", true, -3.09, -9.51},
    {"IR_16", 23.5, ">=", 30.0, 0.0, -10.0},
    {"IR_17", 18.2, "<=", 20.0, 3.09, -9.51},
    {"IR_18", 31.7, ">", 28.0, 5.88, -8.09},
    {"IR_19", 22.1, "<", 25.0, 8.09, -5.88},
    {"IR_20", true, "==", true, 9.51, -3.09},
    
    // Right arm (+X direction) - 4 points
    {"IR_21", 23.5, ">=", 30.0, 13.0, 0.0},
    {"IR_22", 18.2, "<=", 20.0, 16.0, 0.0},
    {"IR_23", 31.7, ">", 28.0, 18.5, 0.0},
    {"IR_24", 22.1, "<", 25.0, 20.0, 0.0},
    
    // Left arm (-X direction) - 4 points
    {"IR_25", true, "==", true, -13.0, 0.0},
    {"IR_26", 23.5, ">=", 30.0, -16.0, 0.0},
    {"IR_27", 18.2, "<=", 20.0, -18.5, 0.0},
    {"IR_28", 31.7, ">", 28.0, -20.0, 0.0},
    
    // Top arm (+Y direction) - 4 points
    {"IR_29", 22.1, "<", 25.0, 0.0, 13.0},
    {"IR_30", true, "==", true, 0.0, 16.0},
    {"IR_31", 23.5, ">=", 30.0, 0.0, 18.5},
    {"IR_32", 18.2, "<=", 20.0, 0.0, 20.0},
    
    // Bottom arm (-Y direction) - 4 points
    {"IR_33", 31.7, ">", 28.0, 0.0, -13.0},
    {"IR_34", 22.1, "<", 25.0, 0.0, -16.0},
    {"IR_35", true, "==", true, 0.0, -18.5},
    {"IR_36", 23.5, ">=", 30.0, 0.0, -20.0}
};


// Create arrays of vectors
Vector vectors[] = {
    {"Line avoidance", 45.0, "#FF5733", -15, -15},
    {"Line tracker", 90.0, "#33FF57", -18, -15},
    {"Ball", 135.0, "#3357FF", -10, -15},
};

// Calculate array sizes
const int numSensors = sizeof(sensors) / sizeof(sensors[0]);
const int numVectors = sizeof(vectors) / sizeof(vectors[0]);

void setup() { SerialUSB.begin(115200); }

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

  for (int i = 0; i < numSensors; i++) {
    sensors[i].input += 1.0;
  }

  vectors[0].rotation += 1.0;
  vectors[1].rotation += 3.0;
  vectors[2].rotation += 9.0;

  // This is optional according to ArduinoJson docs, decreases memory usage by a
  // lot.
  doc.shrinkToFit();

  serializeJson(doc, SerialUSB);
  SerialUSB.println(); // IMPORTANT!! The app parses the json with a new line as a
                    // delimiter, without this line the app will not be able to
                    // parse the json correctly
}
