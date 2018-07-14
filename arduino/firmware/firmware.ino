/*
 * Handles the boulder_mobile.s
 */

#include <stdlib.h>
#include <stdint.h>

#include <ros.h>
#include <std_msgs/String.h>
#include <std_msgs/Empty.h>
#include <std_msgs/UInt8.h>
#include <std_msgs/UInt16.h>

#include <Servo.h>

//--------------------------------------------------------------------------------------------------------------------
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

//volatile unsigned long pulses = 0;       // Número de pulsos leidos por el Arduino en un segundo
//volatile unsigned long pulses1 = 0;       // Número de pulsos leidos por el Arduino en un segundo
//volatile unsigned long debounce = 0; // Tiempo del rebote.
//volatile unsigned long debounce1 = 1; // Tiempo del rebote.
volatile uint16_t pulses = 0;       // Número de pulsos leidos por el Arduino en un segundo
volatile uint16_t pulses1 = 0;       // Número de pulsos leidos por el Arduino en un segundo
volatile uint16_t debounce = 0; // Tiempo del rebote.
volatile uint16_t debounce1 = 1; // Tiempo del rebote.
//--------------------------------------------------------------------------------------------------------------------
ros::NodeHandle  nh;

// Commands
uint8_t steering_cmd{90};             // Center position
uint8_t left_wheel_speed_cmd{0};      // Stopped
uint8_t right_wheel_speed_cmd{0};     // Stopped

// Positions
uint16_t steering_position{0};
uint16_t left_wheel_position{0};
uint16_t right_wheel_position{0};

// Publishers
std_msgs::UInt8 steering_msg;
ros::Publisher steering_publisher("joint_states/steering", &steering_msg);
std_msgs::UInt16 left_wheel_msg;
ros::Publisher left_wheel_publisher("joint_states/left_wheel", &left_wheel_msg);
std_msgs::UInt16 right_wheel_msg;
ros::Publisher right_wheel_publisher("joint_states/right_wheel", &right_wheel_msg);

// Subscribers
void steering_cmd_callback(const std_msgs::UInt8& data){
  const uint8_t steering_value = data.data;
  if (steering_value < 70) {
    steering_cmd = 70;
  } else if (steering_cmd > 110) {
    steering_cmd = 110;
  } else {
    steering_cmd = steering_value;
  }
  steering_position = steering_cmd;
}

ros::Subscriber<std_msgs::UInt8> steering_cmd_subscriber("command/steering", steering_cmd_callback );

void left_wheel_cmd_callback( const std_msgs::UInt8& data){
  left_wheel_speed_cmd = data.data;
  analogWrite(enA, left_wheel_speed_cmd);
}
ros::Subscriber<std_msgs::UInt8> left_wheel_command_subscriber("command/left_wheel_speed", left_wheel_cmd_callback );

void right_wheel_cmd_callback( const std_msgs::UInt8& data){
  right_wheel_speed_cmd = data.data;
  analogWrite(enB, right_wheel_speed_cmd);
}
ros::Subscriber<std_msgs::UInt8> right_wheel_command_subscriber("command/right_wheel_speed", right_wheel_cmd_callback );

//--------------------------------------------------------------------------------------------------------------------

// Publishes all the data
void publish_all_sensors() {
  steering_msg.data = steering_position;
  steering_publisher.publish(&steering_msg);
  
  left_wheel_msg.data = left_wheel_position;
  left_wheel_publisher.publish(&left_wheel_msg);
  
  right_wheel_msg.data = right_wheel_position;
  right_wheel_publisher.publish(&right_wheel_msg);
}
//--------------------------------------------------------------------------------------------------------------------

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

//--------------------------------------------------------------------------------------------------------------------

void setup()
{
  // Motors initialization
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

  // Set Motor A forward
  digitalWrite(in1, HIGH);
  digitalWrite(in2, LOW);
  // Set Motor B forward
  digitalWrite(in3, HIGH);
  digitalWrite(in4, LOW);

  // Center position
  myservo.write(90-servo_offset);
  delay(100);

  // Stop the motors
  analogWrite(enA, left_wheel_speed_cmd);
  analogWrite(enB, right_wheel_speed_cmd);
  
  // ROS Initialization
  nh.initNode();
  // Publishers
  nh.advertise(steering_publisher);
  nh.advertise(left_wheel_publisher);
  nh.advertise(right_wheel_publisher);

  // Subscribers
  nh.subscribe(steering_cmd_subscriber);
  nh.subscribe(left_wheel_command_subscriber);
  nh.subscribe(right_wheel_command_subscriber);
}

void loop()
{
  noInterrupts(); //Don't process interrupts during calculations
  left_wheel_position = pulses;
  right_wheel_position = pulses1;
  interrupts(); // Restart the interrupt processing
  publish_all_sensors();
  
  myservo.write(steering_cmd-servo_offset);
  
  nh.spinOnce();
  delay(100);
}
