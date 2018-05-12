/* 

lee los encoders y los manda por puerto serie !hay que mover la rueda a mano!

*/

void setup()
{
  Serial.begin(9600);
}

// run over and over again
void loop()
{
  Serial.print("Sensor 1: ");
  Serial.println(analogRead(1));
  
  Serial.print("Sensor 1: ");
  Serial.println(analogRead(2));
  
  delay(50);  // esto hay que variarlo probando
}







