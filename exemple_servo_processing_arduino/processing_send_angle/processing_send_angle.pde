/*
Controlling servo from Processing 
(Processing code)
*/

import processing.serial.*;        

Serial port;  

int position = 0;
float lineX = 0;
float lineY = 0;

void setup() {
  size(720, 360);
  frameRate(100);
  printArray(Serial.list());
  port = new Serial(this, Serial.list()[32], 115200); 
}

void draw() {
  screen(180 - (mouseX / 4));
}


void screen(int p) {

  position = p;
  
  lineX = map(sin((position * PI / 180) + PI/2), -1, 1, 0, 720);
  lineY = map(cos((position * PI / 180) + PI/2), -1, 1, 0, 720);
  
  background(0);
  
  fill(255); 
  arc(360, 360, 720, 720, PI, PI*2);
  
  fill(0); 
  line(360, 360, lineX, lineY);
  
  fill(0, 102, 153);
  text(position + "º", 360, 340, 30); 
  
  port.write("s" + round(position)); 
}
