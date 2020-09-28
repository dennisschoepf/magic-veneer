import processing.serial.*;

Serial arduinoPort;
String receivedMessage;
boolean cameIntoThreshhold = false;
boolean objectPlacedDown = false;

PShape branch;
PShape leftWing;
PShape rightWing;
ArrayList<PShape> flyOverObjects = new ArrayList<PShape>();
float velocity = 6;
float backgroundOffset = 0;
float placementIndicatorOffsetX = 0;
int placementIndicatorAnimationCounter = 0;
String placementIndicatorAnimationDirection = "right";
float cocoonOpenDegrees = 0;
String cocoonAnimationDirection = "close";
boolean cocoonAnimationFinished = false;
float wingOpacity = 0;
float treeOffset = 0;
float wingWidth = 100;
boolean wingsSpread = false;
String wingDirection = "smaller";

void setup() {
  /* Set up screen */
  fullScreen();
  background(0);

  /* Load external files */
  branch = loadShape("branch.svg");
  leftWing = loadShape("leftwing.svg");
  rightWing = loadShape("rightwing.svg");

  /* Spawn random objects the butterfly can fly over */
  for (int i = 0; i < 40; i++) {
    float x = random(5, width / 10 - 5) * 10;
    float y = random(4800, 12000);
    float radius = random(1, 10) * 25;
    PShape object = createShape(ELLIPSE, x, -y, radius, radius);
    object.setFill(color(150, 150, 150));
    object.setStroke(color(150, 150, 150));
    flyOverObjects.add(object);
  }

  /* Set up communication with arduino */
  String portName = Serial.list()[Serial.list().length - 1]; //change index to match your port
  arduinoPort = new Serial(this, portName, 9600);
}

void draw() {
  if ( arduinoPort.available() > 0)  {
    String rec = arduinoPort.readStringUntil('\n');
    if (rec != null) {
      receivedMessage = rec;
    }

    // Check for specific events and act upon them
    if (receivedMessage != null) {
      if (receivedMessage.contains("indicatePlacement")) {
        cameIntoThreshhold = true;
      } else {
         cameIntoThreshhold = false;
      }

      if (receivedMessage.contains("startAnimation")) {
        objectPlacedDown = true;
      } else {
        objectPlacedDown = false;
      }
    }
  }

  // Set up fill and let background move
  background(0);
  translate(0, backgroundOffset - 100);

  if (objectPlacedDown == true) {
    backgroundOffset = backgroundOffset + velocity;
  }

  // Draw fly-over objects
  for (int i = 0; i < flyOverObjects.size(); i++) {
    PShape object = flyOverObjects.get(i);
    shape(object);
  }

  if (cameIntoThreshhold == true) {
    /* START - Create and animate placementIndicator */
    placementIndicator(width / 2, (height / 2) + 220 - backgroundOffset ,110, 8, placementIndicatorOffsetX);

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
  }

  /* START - Scene 1 Bugs going by */
  bug(100, -100, 1);
  bug(400, -400, 1);
  bug(width - 200, -600, 1);
  bug(width - 400, -300, 1);
  /* END - Scene 1 Bugs going by */


  if (backgroundOffset < 2450) {
    /* START - Scene 2 Crawling on branch */
    shape(branch, 0, -2980, width, width);
    /* END - Scene 2 Crawling on branch */
  } else if (backgroundOffset > 2450 && backgroundOffset < 4400) {
    if (cocoonAnimationFinished == false) {
      if (cocoonAnimationDirection == "close" && cocoonOpenDegrees < 165) {
        cocoonOpenDegrees++;
      } else if (cocoonAnimationDirection == "close" && cocoonOpenDegrees >= 165) {
        cocoonOpenDegrees = 165;
        cocoonAnimationDirection = "open";
      } if (cocoonAnimationDirection == "open" && cocoonOpenDegrees > 0) {
        cocoonOpenDegrees--;
      } if (cocoonAnimationDirection == "open" && cocoonOpenDegrees <= 0) {
        cocoonOpenDegrees = 0;
        cocoonAnimationFinished = true;
      }

      fill(255);
      noStroke();
      arc(width / 2, -1580 - (backgroundOffset - 2450), 500, 1100, radians(260 - cocoonOpenDegrees), radians(280 + cocoonOpenDegrees), PIE);

      shape(branch, 0, -2980 - (backgroundOffset - 2450), width, width);
    }

    // 3. Let tree move again
    /* END - Scene 3 Cocooning */
  } else if (backgroundOffset > 4400 && backgroundOffset < 13000) {
    shape(branch, 0, -3200 - (backgroundOffset - 2450) + treeOffset, width, width);
    treeOffset = treeOffset + velocity;
    /* START - Scene 4 Butterfly */

    if (wingWidth < 620 && wingsSpread == false) {
      wingDirection = "bigger";
    } else if (wingWidth >= 620 && wingsSpread == false)  {
      wingWidth = 620;
      wingsSpread = true;
    } else if (wingsSpread == true && wingWidth < 540) {
      wingDirection = "bigger";
    } else if (wingsSpread == true && wingWidth >= 620) {
      wingDirection = "smaller";
    }

    if (wingDirection == "smaller") {
      wingWidth -= 4;
    } else if (wingDirection == "bigger") {
      wingWidth += 4;
    }

    shape(leftWing, width / 2 - wingWidth - 65, (height / 2 - wingWidth * 0.8 + 220) - backgroundOffset, wingWidth, wingWidth * 1.5);
    shape(rightWing, width / 2 + 65, (height / 2 - wingWidth * 0.8 + 220) - backgroundOffset, wingWidth, wingWidth * 1.5);


    /* END - Scene 4 Butterfly */
  } else if (backgroundOffset > 13000) {
    background(255);
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

PShape bugLeg(float scale, boolean mirrored) {
  PShape bugLeg = createShape();
  bugLeg.beginShape();
  bugLeg.fill(255);
  bugLeg.stroke(255);

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