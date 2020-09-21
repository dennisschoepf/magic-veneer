import processing.serial.*;

Serial arduinoPort;
String receivedMessage;
boolean cameIntoThreshhold = false;

float placementIndicatorOffsetX = 0;
int placementIndicatorAnimationCounter = 0;
String placementIndicatorAnimationDirection = "right";

void setup() {
  /* Set up screen */
  fullScreen();
  background(0);

  /* Set up communication with arduino
  String portName = Serial.list()[Serial.list().length - 1]; //change index to match your port
  arduinoPort = new Serial(this, portName, 9600); */
}

void draw() {
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
  }*/
}

void placementIndicator(float polygonRadius, int npoints, float offsetX) {
  float centerX = width / 2;
  float centerY = height / 2;

  polygon(centerX + offsetX, centerY + polygonRadius * 2.75, polygonRadius * 0.8, npoints);
  polygon(centerX + offsetX * 0.9, centerY + polygonRadius * 1.6, polygonRadius, npoints);
  polygon(centerX + offsetX * 0.7, centerY, polygonRadius, npoints);
  polygon(centerX + offsetX * 0.3, centerY - polygonRadius * 1.6, polygonRadius, npoints);
  head(centerX, centerY, polygonRadius, 8);
}

void polygon(float x, float y, float radius, int npoints) {
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

void head(float x, float y, float polygonRadius, int npoints) {
  polygon(x, y - polygonRadius * 2.75, polygonRadius * 0.8, npoints);

  PShape leftAntenna = antenna(2);
  PShape rightAntenna = antenna(2);

  pushMatrix();
  leftAntenna.translate(x - 45, y - polygonRadius * 3.7);
  leftAntenna.rotate(radians(350));
  shape(leftAntenna);
  popMatrix();

  pushMatrix();
  rightAntenna.translate(x + 35, y - polygonRadius * 3.7);
  rightAntenna.rotate(radians(10));
  shape(rightAntenna);
  popMatrix();
}

PShape antenna(float scale) {
  PShape antenna = createShape(RECT, 0, 0, 5 * scale, 25 * scale);
  antenna.setFill(color(255));
  antenna.setStroke(color(255));
  antenna.endShape();

  return antenna;
}