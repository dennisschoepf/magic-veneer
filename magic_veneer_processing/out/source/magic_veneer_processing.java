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

float placementIndicatorOffsetX = 0;
int placementIndicatorAnimationCounter = 0;
String placementIndicatorAnimationDirection = "right";

public void setup() {
  /* Set up screen */
  
  background(0);

  /* Set up communication with arduino
  String portName = Serial.list()[Serial.list().length - 1]; //change index to match your port
  arduinoPort = new Serial(this, portName, 9600); */
}

public void draw() {
  /* START - Create and animate placementIndicator */
  background(0);
  placementIndicator(80, 8, placementIndicatorOffsetX);

  if (placementIndicatorAnimationCounter < 5) {
    if (placementIndicatorAnimationDirection == "right" && placementIndicatorOffsetX < 30) {
      placementIndicatorOffsetX += 2;
    } else if (placementIndicatorAnimationDirection == "right" && placementIndicatorOffsetX <= 30) {
      placementIndicatorAnimationDirection = "left";
      placementIndicatorOffsetX -= 2;
      placementIndicatorAnimationCounter++;
    } else if (placementIndicatorAnimationDirection == "left" && placementIndicatorOffsetX >= -30) {
      placementIndicatorOffsetX -= 2;
    } else if (placementIndicatorAnimationDirection == "left" && placementIndicatorOffsetX <= -30) {
      placementIndicatorAnimationDirection = "right";
      placementIndicatorOffsetX += 2;
      placementIndicatorAnimationCounter++;
    }
  } else {
    placementIndicatorOffsetX = 0;
  }
  /* END - Create and animate placementIndicator */

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

public void placementIndicator(float polygonRadius, int npoints, float offsetX) {
  float centerX = width / 2;
  float centerY = height / 2;

  polygon(centerX + offsetX, centerY + polygonRadius * 2.75f, polygonRadius * 0.8f, npoints);
  polygon(centerX + offsetX * 0.9f, centerY + polygonRadius * 1.6f, polygonRadius, npoints);
  polygon(centerX + offsetX * 0.7f, centerY, polygonRadius, npoints);
  polygon(centerX + offsetX * 0.3f, centerY - polygonRadius * 1.6f, polygonRadius, npoints);
  head(centerX, centerY, polygonRadius, 8);
}

public void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  fill(255);
  stroke(255);
  endShape(CLOSE);
}

public void head(float x, float y, float polygonRadius, int npoints) {
  polygon(x, y - polygonRadius * 2.75f, polygonRadius * 0.8f, npoints);

  PShape leftAntenna = antenna(2);
  PShape rightAntenna = antenna(2);

  pushMatrix();
  leftAntenna.translate(x - 45, y - polygonRadius * 3.7f);
  leftAntenna.rotate(radians(350));
  shape(leftAntenna);
  popMatrix();

  pushMatrix();
  rightAntenna.translate(x + 35, y - polygonRadius * 3.7f);
  rightAntenna.rotate(radians(10));
  shape(rightAntenna);
  popMatrix();
}

public PShape antenna(float scale) {
  PShape antenna = createShape(RECT, 0, 0, 5 * scale, 25 * scale);
  antenna.setFill(color(255));
  antenna.setStroke(color(255));
  antenna.endShape();

  return antenna;
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
