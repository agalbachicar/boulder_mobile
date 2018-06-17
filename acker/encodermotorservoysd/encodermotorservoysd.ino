#include <Servo.h> 
#include <SD.h>
#include <SPI.h>

// variables de la memoria sd
File myFile;
int pinCS = 53; 

 /// Variables //////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Definicion de pines
// Motor A
 
int enA = 3;
int in1 = 4;
int in2 = 5;
 
// Motor B
 
int enB = 8;
int in3 = 6;
int in4 = 7;

int i;
int MotorSpeed1 = 80;
int MotorSpeed2 = 80;
 
Servo myservo;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
int pos = 50;    // variable to store the servo position 
int intervalo=1000;




int encoder_pin = 19;             //Pin 2, donde se conecta el encoder       
int encoder_pin1 = 18;             //Pin 2, donde se conecta el encoder       

unsigned int rpm = 0;           // Revoluciones por minuto calculadas.
float velocity = 0;                 //Velocidad en [Km/h]
unsigned int rpm1 = 0;           // Revoluciones por minuto calculadas.
float velocity1 = 0;                 //Velocidad en [Km/h]


volatile byte pulses = 0;       // Número de pulsos leidos por el Arduino en un segundo
volatile byte pulses1 = 0;       // Número de pulsos leidos por el Arduino en un segundo

unsigned long timeold = 0;  // Tiempo 
unsigned int pulsesperturn = 48; // Número de muescas que tiene el disco del encoder.
const int wheel_diameter = 65;   // Diámetro de la rueda pequeña[mm]
static volatile unsigned long debounce = 0; // Tiempo del rebote.


////  Configuración del Arduino /////////////////////////////////////////////////////////
void setup()
{
   Serial.begin(9600); // Configuración del puerto serie  
  pinMode(pinCS, OUTPUT); 
     myservo.attach(9);  // attaches the servo on pin 9 to the servo object 
  pinMode(enA, OUTPUT);
  pinMode(enB, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  pinMode(in3, OUTPUT);
  pinMode(in4, OUTPUT);
   
   pinMode(encoder_pin, INPUT); // Configuración del pin nº2
   pinMode(encoder_pin1, INPUT); // Configuración del pin nº2
  
  // inicializo sd
  
   if (SD.begin())
      {
        Serial.println("SD card is ready to use.");
      } else
      {
        Serial.println("SD card initialization failed");
        return;
      }
  
   // Create/Open file 
      myFile = SD.open("taco.csv", FILE_WRITE);
      
      myFile.print("Pos ");
      myFile.print(";");
      myFile.print("Seconds ");
      myFile.print(";");
      myFile.print("RPM ");
      myFile.print(";");
      myFile.print("Pulses ");
      myFile.print(";");
      myFile.print("Velocity[Km/h]");
      myFile.print(";");
      myFile.print("RPM1 ");
      myFile.print(";");
      myFile.print("Pulses1 ");
      myFile.print(";");
      myFile.print("Velocity1[Km/h]");
      myFile.println(";");
      delay(4000);
  
for(i=89;i<120;i++)
{
myservo.write(i);
delay(17);
}
for(i=120;i>60;i--)
{
myservo.write(i);
delay(17);
}
for(i=60;i<89;i++)
{
myservo.write(i);
delay(17);
}
  myservo.write(89);

  
  Serial.print("Seconds ");
  Serial.print("RPM ");
  Serial.print("Pulses ");
  Serial.print("Velocity[Km/h]");

Serial.print("     ");

  Serial.print("RPM ");
  Serial.print("Pulses ");
  Serial.println("Velocity[Km/h]");
  // Set Motor A forward
    digitalWrite(in1, HIGH);
    digitalWrite(in2, LOW);
     // Set Motor B forward
    digitalWrite(in3, HIGH);
    digitalWrite(in4, LOW);
     analogWrite(enA, MotorSpeed1);
          analogWrite(enB, MotorSpeed2);
    delay(200);
analogWrite(enA, 0);
          analogWrite(enB, 0);
          
   attachInterrupt(4, counter, RISING); // Configuración de la interrupción 0, donde esta conectado. 
   attachInterrupt(5, counter1, RISING); // Configuración de la interrupción 0, donde esta conectado. 
   
   pulses = 0;
   pulses1 = 0;
   rpm = 0;
   rpm1 = 0;
   timeold = 0;
 

}

byte sent = 0;

int banfin=0;

////  Programa principal ///////////////////////////////////////////////////////////////////////
 void loop()
 {
   if ((millis() - timeold) >= intervalo){  // Se actualiza cada segundo
      noInterrupts(); //Don't process interrupts during calculations // Desconectamos la interrupción para que no actué en esta parte del programa.
      rpm = (60 * 1000 / pulsesperturn )/ (millis() - timeold)* pulses; // Calculamos las revoluciones por minuto
      rpm1 = (60 * 1000 / pulsesperturn )/ (millis() - timeold)* pulses1; // Calculamos las revoluciones por minuto
      
      velocity = rpm * 3.1416 * wheel_diameter * 60 / 1000000; // Cálculo de la velocidad en [Km/h] 
      velocity1 = rpm1 * 3.1416 * wheel_diameter * 60 / 1000000; // Cálculo de la velocidad en [Km/h] 
      
      timeold = millis(); // Almacenamos el tiempo actual.
    
    
      Serial.print(millis()/1000); Serial.print("       ");// Se envia al puerto serie el valor de tiempo, de las rpm y los pulsos.
      Serial.print(rpm,DEC); Serial.print("   ");
      Serial.print(pulses,DEC); Serial.print("     ");
      Serial.print(velocity,2); 

      Serial.print("     ");
  
      Serial.print(rpm1,DEC); Serial.print("   ");
      Serial.print(pulses1,DEC); Serial.print("     ");
      Serial.println(velocity1,2); 
 
 if(banfin==0)
 {
  // grabo en la sd
      myFile.print(pos);
      myFile.print(";");
      myFile.print(millis()/1000); 
     myFile.print(";");
      myFile.print(rpm,DEC); 
     myFile.print(";");
      myFile.print(pulses,DEC);
     myFile.print(";");
      myFile.print(velocity,2); 
      myFile.print(";");
      myFile.print(rpm1,DEC);
     myFile.print(";");
      myFile.print(pulses1,DEC);
     myFile.print(";");
      myFile.println(velocity1,2); 
 
 }  
  
    if(sent==0)
     {
    
       sent=1;
     }
    else
    {
       sent=0;
       pos=pos+1;
       if(pos>=20) {
                     pos=0;
                    Serial.print("termino");
                    banfin=1;
                    MotorSpeed1 += 2;
                    MotorSpeed2 += 2;
                    
                    Serial.println("Speed");
                    Serial.println(MotorSpeed1);
                    
                    
                    myFile.println("Speed");
                    myFile.println(MotorSpeed1);
                    
                    
                    
                    if(MotorSpeed1 >= 140)
                    {
                      myFile.close();
                      while(1);
                    }
       }
     }
         sentido_giro(sent); // Set Motor A forward
         analogWrite(enA, 0);
        analogWrite(enB, 0); 
        delay(300);
  
          analogWrite(enA, MotorSpeed1);
          analogWrite(enB, MotorSpeed2);
          myservo.write(89);
      pulses = 0;  // Inicializamos los pulsos.
      pulses1 = 0;
      interrupts(); // Restart the interrupt processing // Reiniciamos la interrupción
   }
   
 
 
  }
////Fin de programa principal //////////////////////////////////////////////////////////////////////////////////
///////////////////////////Función que cuenta los pulsos buenos ///////////////////////////////////////////
 void counter(){
  if(  digitalRead (encoder_pin) && (micros()-debounce > 500) && digitalRead (encoder_pin) ) 
  { 
// Vuelve a comprobar que el encoder envia una señal buena y luego comprueba que el tiempo es superior a 1000 microsegundos y vuelve a comprobar que la señal es correcta.
        debounce = micros(); // Almacena el tiempo para comprobar que no contamos el rebote que hay en la señal.
        pulses++;
      }  // Suma el pulso bueno que entra.
        else ; 
      
    } 

 void counter1(){
  if(  digitalRead (encoder_pin1) && (micros()-debounce > 500) && digitalRead (encoder_pin1) ) 
  { 
// Vuelve a comprobar que el encoder envia una señal buena y luego comprueba que el tiempo es superior a 1000 microsegundos y vuelve a comprobar que la señal es correcta.
        debounce = micros(); // Almacena el tiempo para comprobar que no contamos el rebote que hay en la señal.
        pulses1++;
      }  // Suma el pulso bueno que entra.
        else ; 
      
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


