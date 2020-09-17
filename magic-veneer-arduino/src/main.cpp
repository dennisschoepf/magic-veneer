#include <Arduino.h>
#include <SharpIR.h>

SharpIR sensor(SharpIR::GP2Y0A02YK0F, A0);

void setup()
{
  Serial.begin(9600);
  pinMode(A0, INPUT);
  // put your setup code here, to run once:
}

void loop()
{
  int distance = sensor.getDistance();

  if (distance < 40)
  {
    Serial.println("isWithinThreshhold");
  }
  delay(100);
}