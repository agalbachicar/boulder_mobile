#include <DCMotor.h>
#include <Ping.h>

#define SONAR_PIN         A1
#define LEFT_ENCODER_PIN  A0
#define RIGHT_ENCODER_PIN A2

PingSensor ping(SONAR_PIN);
DCMotor motor0(M0_EN, M0_D0, M0_D1);
DCMotor motor1(M1_EN, M1_D0, M1_D1);

unsigned long demo_start_time = 0;
unsigned long demo_duration = 60 * 1000;
unsigned long last_update_time = 0;
unsigned long update_period = 40;
int last_left_encoder_state = LOW;
unsigned long left_encoder_ticks = 0;
int last_right_encoder_state = LOW;
unsigned long right_encoder_ticks = 0;

void setup () 
{
  Serial.begin(9600);
  Serial.print("measurement_time");
  Serial.print("\t");
  Serial.print("sonar_distance_in_cm");
  Serial.print("\t");
  Serial.print("left_encoder_ticks");
  Serial.print("\t");
  Serial.println("right_encoder_ticks");
  pinMode(LEFT_ENCODER_PIN, INPUT);
  last_left_encoder_state = digitalRead(LEFT_ENCODER_PIN);
  pinMode(RIGHT_ENCODER_PIN, INPUT);
  last_right_encoder_state = digitalRead(LEFT_ENCODER_PIN);
  motor0.setClockwise(true);
  motor0.setSpeed(50.0);
  motor1.setClockwise(false);
  motor1.setSpeed(50.0);
//  motor0.setSpeed(-50.0);
//  motor1.setSpeed(50.0);
//  motor0.setSpeed(50.0);
//  motor1.setSpeed(-50.0);
  demo_start_time = millis();
  last_update_time = millis();
}

void loop () {
  unsigned long current_time = millis();
  unsigned long time_since_last_update = current_time - last_update_time;
  
  int left_encoder_state = digitalRead(LEFT_ENCODER_PIN);
  if (left_encoder_state != last_left_encoder_state 
      && left_encoder_state == HIGH) {
    left_encoder_ticks += 1;
  }
  last_left_encoder_state = left_encoder_state;
  
  int right_encoder_state = digitalRead(RIGHT_ENCODER_PIN);
  if (right_encoder_state != last_right_encoder_state
      && right_encoder_state == HIGH) {
    right_encoder_ticks += 1;
  }
  last_right_encoder_state = right_encoder_state;
  
  if (time_since_last_update > update_period) {
    Serial.print(current_time);
    Serial.print("\t");
    Serial.print(ping.measureCM());
    Serial.print("\t");
    Serial.print(left_encoder_ticks);
    Serial.print("\t");
    Serial.println(right_encoder_ticks);
    last_update_time = current_time;
  }

  if (current_time - demo_start_time > demo_duration) {
    motor0.brake();
    motor1.brake();
  }
}


