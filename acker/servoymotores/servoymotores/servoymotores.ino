/* 
Funcion: prueba el servo del ackerman en su maximo rango de a 1 grado entre 0 y 180 grados


*/

#include <Servo.h> 
 


// Definicion de pines
// Motor A
 
int enA = 3;
int in1 = 4;
int in2 = 5;
 
// Motor B
 
int enB = 8;
int in3 = 6;
int in4 = 7;


int MotorSpeed1 = 130;
int MotorSpeed2 = 130;
 
Servo myservo;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
int pos = 50;    // variable to store the servo position 
int intervalo=800;


void setup() 
{ 
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object 
  pinMode(enA, OUTPUT);
  pinMode(enB, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  pinMode(in3, OUTPUT);
  pinMode(in4, OUTPUT);
  //time_ant=millis();
} 
 
byte sent = 0;
long int time_ant =0;


void loop() 
{ 
  
  if (MotorSpeed1 < 8)MotorSpeed1 = 0;
  if (MotorSpeed2 < 8)MotorSpeed2 = 0;
 
  myservo.write(pos);              // tell servo to go to position in variable 'pos' 
  delay(15);   
 
  if ((millis() - time_ant) >= intervalo) 
  {  
    analogWrite(enA, 0);
    analogWrite(enB, 0); 
    delay(300);
  
    if(sent==0)
     {
      sent=1;
     }
    else
    {
       sent=0;
       pos=pos+4;
       if(pos>=130) pos=50; 
     }
          sentido_giro(sent); // Set Motor A forward
          analogWrite(enA, MotorSpeed1);
          analogWrite(enB, MotorSpeed2);
        time_ant = millis(); // Almacenamos el tiempo actual  .
  } 
 

  
} 


// define el sentido de giro 0: adelante 1 : atras

void sentido_giro(byte dir)
{
  if(dir==0)
  {  
    // Set Motor A forward
    digitalWrite(in1, HIGH);
    digitalWrite(in2, LOW);
     // Set Motor B forward
    digitalWrite(in3, HIGH);
    digitalWrite(in4, LOW);
  }

  if(dir==1)
  {
    digitalWrite(in2, HIGH);
    digitalWrite(in1, LOW);
      // Set Motor B forward
    digitalWrite(in4, HIGH);
    digitalWrite(in3, LOW);

  }
}
