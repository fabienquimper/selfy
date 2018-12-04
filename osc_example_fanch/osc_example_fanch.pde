/*
Template for OSC control
Aris Bezas Tue, 03 May 2011, 18:17
*/

import processing.opengl.*;
import oscP5.*;  
import netP5.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
OscP5 oscP5;
NetAddress myRemoteLocation;

PFont  font;
int varName;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();

  oscP5 = new OscP5(this, 12000);   //listening
  //myRemoteLocation = new NetAddress("127.0.0.1", 57120);  //  speak to
  myRemoteLocation = new NetAddress("192.168.1.43", 57120);  //  speak to  
  // The method plug take 3 arguments. Wait for the <keyword>
  oscP5.plug(this, "varName", "keyword");
}

void draw() {
  scale(2);
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  for (int i = 0; i < faces.length; i++) {
   // println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    
    println("x*y=" + faces[i].x + " "+ faces[i].y + "  w/h=" + faces[i].width + " "+ faces[i].height);
    
    OscMessage newMessage = new OscMessage("mouseX position");  
    newMessage.add(faces[i].x + " " + faces[i].y + " " + faces[i].width + " " + faces[i].height);
    varName(faces[i].x);
    oscP5.send(newMessage, myRemoteLocation);
  }
}

public void varName(int _varName) {
  varName = _varName;
}

void captureEvent(Capture c) {
  c.read();
}
