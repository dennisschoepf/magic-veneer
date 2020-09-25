#include <Arduino.h>
#include <SharpIR.h>

SharpIR sensorProx(SharpIR::GP2Y0A02YK0F, A0);
SharpIR sensorDown(SharpIR::GP2Y0A02YK0F, A7);

void setup()
{
  Serial.begin(9600);
  pinMode(A0, INPUT);
  pinMode(A7, INPUT);
}

void loop()
{
  int distanceProx = sensorProx.getDistance();
  // int distanceDown = sensorDown.getDistance();
  delay(250);

  if (distanceProx < 30)
  {
    Serial.println("indicatePlacement");
    delay(2000);
    Serial.println("startAnimation");
  }
}