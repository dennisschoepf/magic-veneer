import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class magic_veneer_processing extends PApplet {



Serial arduinoPort;
String receivedMessage;
boolean cameIntoThreshhold = false;

int radius = 0;

public void setup() {
  /* Set up screen */
  
  background(0);

  /* Set up communication with arduino
  String portName = Serial.list()[Serial.list().length - 1]; //change index to match your port
  arduinoPort = new Serial(this, portName, 9600); */
}

public void draw() {
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
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "magic_veneer_processing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
