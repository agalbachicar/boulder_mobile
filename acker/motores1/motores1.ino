// Motor A
 
int enA = 3;
int in1 = 4;
int in2 = 5;
 
// Motor B
 
int enB = 8;
int in3 = 6;
int in4 = 7;
 
// Speed control potentiometers
 
int SpeedControl1 = A0;  
int SpeedControl2 = A1;
 
 
// Motor Speed Values - Start at zero
 
int MotorSpeed1 = 
int MotorSpeed2 = 78;
 
void setup()
 
{
 
  // Set all the motor control pins to outputs
 
  pinMode(enA, OUTPUT);
  pinMode(enB, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  pinMode(in3, OUTPUT);
  pinMode(in4, OUTPUT);
  
   
}
 
void loop() {
  
  // Set Motor A forward
 
  digitalWrite(in1, HIGH);
  digitalWrite(in2, LOW);
 
 // Set Motor B forward
 
  digitalWrite(in3, HIGH);
  digitalWrite(in4, LOW);
  
  // Read the values from the potentiometers
    
 // MotorSpeed1 = analogRead(SpeedControl1); 
 // MotorSpeed2 = analogRead(SpeedControl2);
  
  // Convert to range of 0-255
  
 // MotorSpeed1 = map(MotorSpeed1, 0, 1023, 0, 255);
 // MotorSpeed2 = map(MotorSpeed2, 0, 1023, 0, 255);  
  
  // Adjust to prevent "buzzing" at very low speed
  
  if (MotorSpeed1 < 8)MotorSpeed1 = 0;
        
  if (MotorSpeed2 < 8)MotorSpeed2 = 0;
    
  
  // Set the motor speeds
  
  analogWrite(enA, MotorSpeed1);
  analogWrite(enB, MotorSpeed2);
  delay(1000);
  
  
  analogWrite(enA, 0);
  analogWrite(enB, 0);
  delay(1000);
 
 // Set Motor A reverse
 
  digitalWrite(in2, HIGH);
  digitalWrite(in1, LOW);
 
 // Set Motor B reverse
 
  digitalWrite(in4, HIGH);
  digitalWrite(in3, LOW);
   
  
  analogWrite(enA, MotorSpeed1);
  analogWrite(enB, MotorSpeed2);
  delay(1000);
  
 // Set Motor A forward
 
  digitalWrite(in1, HIGH);
  digitalWrite(in2, LOW);
 
 // Set Motor B reverse
 
  digitalWrite(in4, HIGH);
  digitalWrite(in3, LOW);
   
  
  analogWrite(enA, MotorSpeed1);
  analogWrite(enB, MotorSpeed2);
  delay(1000);
   
  // Set Motor A reverse
 
  digitalWrite(in2, HIGH);
  digitalWrite(in1, LOW);
 
 // Set Motor B forward
 
  digitalWrite(in3, HIGH);
  digitalWrite(in4, LOW);
   
  
  analogWrite(enA, MotorSpeed1);
  analogWrite(enB, MotorSpeed2);
  delay(1000);
  
  
  MotorSpeed1 +=5;
  MotorSpeed2 +=5; 
 
  if (MotorSpeed1 >254)MotorSpeed1 = 28;
        
  if (MotorSpeed2 > 254)MotorSpeed2 = 28;
  
  
    
}
