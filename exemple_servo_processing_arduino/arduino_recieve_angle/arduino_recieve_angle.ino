/*
Controlling servo from Processing 
(Arduino code)
*/

#include <Servo.h> 
 
Servo servo;

void setup() { 
  servo.attach(7);
  Serial.begin(115200);
} 
  
void loop() { 
  float n = 0;
  static int v = 0;

  if(Serial.available()) {
    char ch = Serial.read();

    switch(ch) {
      case '0'...'9':
        v = v * 10 + ch - '0';
        break;
      case 's':
       n = map(v, 1, 180, 0, 255); 
       
       servo.write(v);
        v = 0;
        break;
    }
  }
  
} 
