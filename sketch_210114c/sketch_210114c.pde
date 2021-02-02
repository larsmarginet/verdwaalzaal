import codeanticode.syphon.*;
import processing.serial.*;    // Importing the serial library to communicate with the Arduino 
Serial myPort;                 // Initializing a vairable named 'myPort' for serial communication
float background_color ;       // Variable for changing the background color

PGraphics canvas;
SyphonServer server;

boolean recording = false; 

void setup () {
  size(3840, 1080, P3D);
  canvas = createGraphics(3840, 1080, P3D);
  server = new SyphonServer(this, "Processing Syphon");
  myPort  =  new Serial (this, "/dev/tty.usbmodem142101",  9600); // Set the com port and the baud rate according to the Arduino IDE
  myPort.bufferUntil ( '\n' );   // Receiving the data from the Arduino IDE
} 

void serialEvent (Serial myPort) {
  background_color  =  float (myPort.readStringUntil ( '\n' ) ) ;  // Changing the background color according to received data
} 

void keyPressed() {
  if (key == 'r' || key == 'R' ) {
      recording = !recording;
  }
}

void draw ( ) {
  // create everything in the secondary canvas in order to show it in syphon
  // canvas.background ( 150, 50, background_color );   // Initial background color, when we will open the serial window 
  canvas.beginDraw();
  canvas.background(150, 50, background_color);
  canvas.endDraw();
  image(canvas, 0, 0);
  
  if (recording) {
    saveFrame("output/frame_####.png");
  }
  println(frameRate);
  server.sendImage(canvas);
}
