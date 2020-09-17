import processing.serial.*;

Serial arduinoPort;
String receivedMessage;
boolean cameIntoThreshhold = false;

void setup() {
  String portName = Serial.list()[Serial.list().length - 1]; //change the 0 to a 1 or 2 etc. to match your port
  arduinoPort = new Serial(this, portName, 9600);
}

void draw() {
  if ( arduinoPort.available() > 0)  {
    String rec = arduinoPort.readStringUntil('\n');
    if (rec != null) {
      receivedMessage = rec;
    }
    
    // Check for specific events and act upon them
    if (receivedMessage != null && receivedMessage.contains("isWithinThreshhold")) {
      cameIntoThreshhold = true;
    }
  }
}
