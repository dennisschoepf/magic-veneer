import processing.serial.*;

Serial arduinoPort;
String receivedMessage;
boolean cameIntoThreshhold = false;

int radius = 0;

void setup() {
  /* Set up screen */
  fullScreen();
  background(0);

  /* Set up communication with arduino
  String portName = Serial.list()[Serial.list().length - 1]; //change index to match your port
  arduinoPort = new Serial(this, portName, 9600); */
}

void draw() {
  println("Test");
  /* if ( arduinoPort.available() > 0)  {
    String rec = arduinoPort.readStringUntil('\n');
    if (rec != null) {
      receivedMessage = rec;
    }

    // Check for specific events and act upon them
    if (receivedMessage != null && receivedMessage.contains("isWithinThreshhold")) {
      cameIntoThreshhold = true;
    }
  }

  circle(width / 2, height / 2, radius);
  fill(0);
  radius += 10; */
}
