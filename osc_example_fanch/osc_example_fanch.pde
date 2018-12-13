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
import controlP5.*;

Capture video;
OpenCV opencv;
OscP5 oscP5;
NetAddress myRemoteLocation;

//0: NO TRANSFORMATION
//1: IMAGE REPLACEMENT
//2: VIDEO REPLACEMENT
int faceTransformation = 1;
// Control vars
ControlP5 cp5;
int buttonColor;
int buttonBgColor;

PFont  font;
int varName;
PImage  face;
Movie faceVid;

void setup() {
  face = loadImage("face.png");
  faceVid = new Movie(this, "face.mov");
  faceVid.loop();
  faceVid.play();  
  
  size(640, 480);
  
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();

  oscP5 = new OscP5("79.90.218.54", 12000);   //listening
  //oscP5 = new OscP5(this, 12000);   //listening
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);  //  speak to
//  myRemoteLocation = new NetAddress("79.90.218.54", 57120);  //  speak to
  //myRemoteLocation = new NetAddress("79.90.218.54", 57120);  //  speak to
 // myRemoteLocation = new NetAddress("192.168.1.43", 57120);  //  speak to  
  // The method plug take 3 arguments. Wait for the <keyword>
  oscP5.plug(this, "varName", "keyword");
  

  // Init Controls
  cp5 = new ControlP5(this);  // Slider for threshold
  cp5.addSlider("faceTransformation")
     .setLabel("Face transformation")
     .setPosition(10,10)
     .setRange(0,2)
     ;
  //faceTransformation = cp5.getController("faceTransformation");
   //cp5.getController("faceTransformation").setLock(true);
  //cp5.getController("faceTransformation").setColorBackground(color(buttonBgColor));
  //cp5.getController("faceTransformation").setColorForeground(color(buttonColor));
  
  // Store the default background color, we gonna need it later
  //buttonColor = cp5.getController("faceTransformation").getColor().getForeground();
  //buttonBgColor = cp5.getController("faceTransformation").getColor().getBackground();
}

void draw() {
  //scale(2);
  opencv.loadImage(video);
  
  // Face video
  //opencv.loadImage(faceVid);

  image(video, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  println(faces.length);


  OscMessage newMessage = new OscMessage("mouseX position"); 
  for (int i = 0; i < faces.length; i++) {
   // println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    
    println("x*y=" + faces[i].x + " "+ faces[i].y + "  w/h=" + faces[i].width + " "+ faces[i].height);
    //newMessage.add(faces[i].x + " " + faces[i].y + " " + faces[i].width + " " + faces[i].height);  
   // newMessage.add(i);
    newMessage.add(faces[i].x);
    newMessage.add(faces[i].y);   
    newMessage.add(faces[i].width);
    newMessage.add(faces[i].height);   
    //varName(faces[i].x);
    //println(newMessage);
    
    // LOAD THE IMAGE
    if (faceTransformation == 1) {
      image(face, faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    
    // LOAD THE VIDEO
    } else if (faceTransformation == 2) {
      image(faceVid, faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }
  }
  
  oscP5.send(newMessage, myRemoteLocation);
}

public void varName(int _varName) {
  varName = _varName;
}

void captureEvent(Capture c) {
  c.read();
}

void movieEvent(Movie m) {
  m.read();
}
