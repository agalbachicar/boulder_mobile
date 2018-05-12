/* Fecha 07/05/18

Este codigo mueve los motores del duinobot en linea recta supestamente los motores estan en direccion contraria o sea que para que vaya derecho hay que poner negativo en uno y positivo en otro

setup se ejecuta una sola vez y loop se ejecuta loop infinito
*/
 

#include <DCMotor.h>

DCMotor motor0(M0_EN, M0_D0, M0_D1);
DCMotor motor1(M1_EN, M1_D0, M1_D1);

void setup()
{
  motor0.setSpeed(-50.0);     // esto se invierte en funcion de que quiera ir marcha atras o 					adelante
  motor1.setSpeed(50.0);
  delay(5000);

  motor0.brake();
  motor1.brake();
}

void loop()
{ }

