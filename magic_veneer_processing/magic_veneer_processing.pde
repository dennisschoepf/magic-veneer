import processing.serial.*;

Serial arduinoPort;
String receivedMessage;
boolean cameIntoThreshhold = false;

PShape branch;
float backgroundOffset = 0;
float placementIndicatorOffsetX = 0;
int placementIndicatorAnimationCounter = 0;
String placementIndicatorAnimationDirection = "right";

void setup() {
  /* Set up screen */
  fullScreen();
  background(0);

  /* Load external files */
  branch = loadShape("branch.svg");

  /* Set up communication with arduino
  String portName = Serial.list()[Serial.list().length - 1]; //change index to match your port
  arduinoPort = new Serial(this, portName, 9600); */
}

void draw() {
  background(255);
  translate(0, backgroundOffset);
  backgroundOffset+= 4;

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

  /* START - Create and animate placementIndicator */
  placementIndicator(width / 2, (height / 2) - backgroundOffset ,80, 8, placementIndicatorOffsetX);

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

  /* START - Scene 1 Bugs going by */
  bug(100, -100, 1);
  bug(400, -400, 1);
  bug(width - 200, -600, 1);
  bug(width - 400, -300, 1);
  /* END - Scene 1 Bugs going by */

  if (backgroundOffset < 2450) {
    /* START - Scene 2 Crawling on branch */
    println("Under threshhold");
    shape(branch, 0, -3200, width, width);
    /* END - Scene 2 Crawling on branch */
  }
  if (backgroundOffset > 2450 && backgroundOffset < 5000) {
    /* START - Scene 3 Cocooning */
    // 1. Place tree at initial position minus delta (Offset at entering threshhold to current threshhold)
    shape(branch, 0, -3200 - (backgroundOffset - 2450), width, width);
    // 2. Start cocoon animation

    // 3. Keep cocoon for x amount of time
    /* END - Scene 3 Cocooning */
  } else if (backgroundOffset > 5000) {
    /* START - Scene 4 Butterfly */
    println("Over threshhold");
    /* END - Scene 4 Butterfly */
  }
}

void bug(float x, float y, float scale) {
  PShape leftUpperLeg = bugLeg(scale, false);
  PShape leftMiddleLeg = bugLeg(scale, false);
  PShape leftLowerLeg = bugLeg(scale, false);
  PShape rightUpperLeg = bugLeg(scale, true);
  PShape rightMiddleLeg = bugLeg(scale, true);
  PShape rightLowerLeg = bugLeg(scale, true);

  pushMatrix();

  translate(x, y);
  polygon(60 * scale, 40 * scale , 40 * scale, 6);

  pushMatrix();
  leftUpperLeg.translate(5 * scale, 0);
  shape(leftUpperLeg);
  popMatrix();

  pushMatrix();
  leftMiddleLeg.translate(0, 20 * scale);
  shape(leftMiddleLeg);
  popMatrix();

  pushMatrix();
  leftLowerLeg.translate(5 * scale, 45 * scale);
  shape(leftLowerLeg);
  popMatrix();

  pushMatrix();
  rightUpperLeg.translate(85 * scale, 0);
  shape(rightUpperLeg);
  popMatrix();

  pushMatrix();
  rightMiddleLeg.translate(90 * scale, 20 * scale);
  shape(rightMiddleLeg);
  popMatrix();

  pushMatrix();
  rightLowerLeg.translate(85 * scale, 45 * scale);
  shape(rightLowerLeg);
  popMatrix();

  popMatrix();
}

void placementIndicator(float x, float y, float polygonRadius, int npoints, float offsetX) {
  polygon(x + offsetX, y + polygonRadius * 2.75, polygonRadius * 0.8, npoints);
  polygon(x + offsetX * 0.9, y + polygonRadius * 1.6, polygonRadius, npoints);
  polygon(x + offsetX * 0.7, y, polygonRadius, npoints);
  polygon(x + offsetX * 0.3, y - polygonRadius * 1.6, polygonRadius, npoints);
  head(x, y, polygonRadius, 8);
}

void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  fill(0);
  stroke(0);
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
  antenna.setFill(color(0));
  antenna.setStroke(color(0));
  antenna.endShape();

  return antenna;
}

PShape bugLeg(float scale, boolean mirrored) {
  PShape bugLeg = createShape();
  bugLeg.beginShape();
  bugLeg.fill(0);
  bugLeg.stroke(0);

  if (mirrored == true) {
    bugLeg.vertex(0, 20);
    bugLeg.vertex(15, 20);
    bugLeg.vertex(30, 5);
    bugLeg.vertex(30, 0);
    bugLeg.vertex(15, 15);
    bugLeg.vertex(0, 15);
  } else {
    bugLeg.vertex(0, 0);
    bugLeg.vertex(15, 15);
    bugLeg.vertex(30, 15);
    bugLeg.vertex(30, 20);
    bugLeg.vertex(15, 20);
    bugLeg.vertex(0, 5);
  }

  bugLeg.endShape(CLOSE);

  return bugLeg;
}