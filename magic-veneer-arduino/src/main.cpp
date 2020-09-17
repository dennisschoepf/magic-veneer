#include <Arduino.h>
#include <SharpIR.h>

SharpIR sensorProx(SharpIR::GP2Y0A02YK0F, A0);
SharpIR sensorDown(SharpIR::GP2Y0A02YK0F, A1);

void setup()
{
  Serial.begin(9600);
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
}

void loop()
{
  int distanceProx = sensorProx.getDistance();
  int distanceDown = sensorDown.getDistance();
  Serial.print("Proximity");
  Serial.println(distanceProx);
  Serial.print("Down");
  Serial.println(distanceDown);
  delay(100);

  if (distanceProx < 40)
  {
    Serial.println("Through first barrier");
  }
  if (distanceDown < 35)
  {
    Serial.println("Through second barrier");
  }
  delay(100);
}