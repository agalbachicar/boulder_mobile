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
int encoder_pin = 19;             //Pin 2, donde se conecta el encoder       
int encoder_pin1 = 18;             //Pin 2, donde se conecta el encoder       

Servo myservo;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
int servo_offset = 5;
float max_steering_delta = 25;
float base_steering = 90;
float l = 0.155;
float w = 0.158;
float kmax = tan(max_steering_delta * M_PI / 180) / l;

const unsigned long interval=100;
const unsigned long duration=10000;

volatile unsigned long pulses = 0;       // Número de pulsos leidos por el Arduino en un segundo
volatile unsigned long pulses1 = 0;       // Número de pulsos leidos por el Arduino en un segundo
volatile unsigned long debounce = 0; // Tiempo del rebote.
volatile unsigned long debounce1 = 0; // Tiempo del rebote.

unsigned long start_time = 0;  // Tiempo 
unsigned long last_time = 0;  // Tiempo 
//unsigned int pulsesperturn = 48; // Número de muescas que tiene el disco del encoder.
//const int wheel_diameter = 65;   // Diámetro de la rueda pequeña[mm]

////  Configuración del Arduino /////////////////////////////////////////////////////////
void setup()
{
  Serial.begin(9600); // Configuración del puerto serie  

  pinMode(pinCS, OUTPUT);   
  pinMode(enA, OUTPUT);
  pinMode(enB, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  pinMode(in3, OUTPUT);
  pinMode(in4, OUTPUT);
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object  
  pinMode(encoder_pin, INPUT); // Configuración del pin nº2
  pinMode(encoder_pin1, INPUT); // Configuración del pin nº2
  attachInterrupt(4, counter, RISING); // Configuración de la interrupción 0, donde esta conectado. 
  attachInterrupt(5, counter1, RISING); // Configuración de la interrupción 0, donde esta conectado.

  // inicializo sd
  if (SD.begin())
  {
    Serial.println("SD card is ready to use.");
  }
  else
  {  
    Serial.println("SD card initialization failed");
    return;
  }

  // Create/Open file 
  myFile = SD.open("clothoid.csv", FILE_WRITE);
  delay(1000);

  // Set Motor A forward
  digitalWrite(in1, HIGH);
  digitalWrite(in2, LOW);
  // Set Motor B forward
  digitalWrite(in3, HIGH);
  digitalWrite(in4, LOW);

  for (int i = 90; i>70; --i) {
    myservo.write(i-servo_offset);
    delay(15);
  }
  for (int i = 70; i<110; ++i) {
    myservo.write(i-servo_offset);
    delay(15);
  }
  for (int i = 110; i>90; --i) {
    myservo.write(i-servo_offset);
    delay(15);
  }
  myservo.write(90-servo_offset);
  delay(100);
  start_time = last_time = millis();
}

bool running = true;

////  Programa principal ///////////////////////////////////////////////////////////////////////
void loop()
{
  unsigned long pulses_buf, pulses1_buf;

  unsigned long current_time = millis();
  if (running) {
    if ((current_time - start_time) < duration) {
      if ((current_time - last_time) >= interval) {  // Se actualiza cada segundo
        noInterrupts(); //Don't process interrupts during calculations // Desconectamos la interrupción para que no actué en esta parte del programa.
        pulses_buf = pulses;
        pulses1_buf = pulses1;
        interrupts(); // Restart the interrupt processing // Reiniciamos la interrupción
        
        Serial.print(current_time);
        Serial.print("\t");// Se envia al puerto serie el valor de tiempo, de las rpm y los pulsos.
        Serial.print(pulses_buf, DEC);
        Serial.print("\t");
        Serial.print(pulses1_buf, DEC);
        Serial.print("\n");
        
        // grabo en la sd
        myFile.print(current_time); 
        myFile.print("\t");
        myFile.print(pulses_buf,DEC);
        myFile.print("\t");
        myFile.print(pulses1_buf,DEC);
        myFile.print("\n");
        
        last_time = current_time; // Almacenamos el tiempo actual.
      }

      float k = kmax * (current_time - start_time)/duration;
      float d = 180 * atan(l * k) / M_PI;
      float n = 1.0;
      if (k != 0.0) {
        float R = 1 / k;
        n = (R < 0) ? sqrt((-R - w/2) / (-R + w/2)) : sqrt((R + w/2)/(R - w/2));
      }
      float servo_pos = base_steering - d;
      myservo.write(servo_pos - servo_offset);
      float motor_speed_1 = 100*n;
      float motor_speed_2 = 100/n;
      analogWrite(enA, motor_speed_1);
      analogWrite(enB, motor_speed_2);
    }
    else
    {
        myservo.write(base_steering - servo_offset);
        analogWrite(enA, 0);
        analogWrite(enB, 0);
        myFile.print("---\n");
        myFile.close();
    }
  }
}
////Fin de programa principal //////////////////////////////////////////////////////////////////////////////////
///////////////////////////Función que cuenta los pulsos buenos ///////////////////////////////////////////
void counter() {
  if(digitalRead(encoder_pin) && (micros() - debounce > 500)) 
  { 
    // Vuelve a comprobar que el encoder envia una señal buena y luego comprueba que el tiempo es superior a 1000 microsegundos y vuelve a comprobar que la señal es correcta.
    debounce = micros(); // Almacena el tiempo para comprobar que no contamos el rebote que hay en la señal.
    pulses++;
  }
} 

void counter1() {
  if(digitalRead(encoder_pin1) && (micros() - debounce1 > 500)) 
  { 
    // Vuelve a comprobar que el encoder envia una señal buena y luego comprueba que el tiempo es superior a 1000 microsegundos y vuelve a comprobar que la señal es correcta.
    debounce1 = micros(); // Almacena el tiempo para comprobar que no contamos el rebote que hay en la señal.
    pulses1++;
  }
} 


