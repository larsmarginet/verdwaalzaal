import gifAnimation.*;
import processing.serial.*;   
Serial myPort;   

/*

 ASDF Pixel Sort
 Kim Asendorf | 2010 | kimasendorf.com
 
 sorting mode: brightness
 
 */

// image path is relative to sketch directory
PImage[] animation;
PImage img;
String imgFileName = "sunset";
String fileType = "gif";
int frame = 0;
int loops = 1;

// threshold values to determine sorting start and end pixels
int blackValue = -16000000;
float brightnessValue = 10;
int whiteValue = -13000000;

int row = 0;
int column = 0;

boolean saved = false;

void setup() {
  frameRate(24);
  animation = Gif.getPImages(this, imgFileName+"."+fileType);
  img = animation[frame];
  
  // use only numbers (not variables) for the size() command, Processing 3
  size(1, 1);
  
  myPort  =  new Serial (this, "/dev/tty.usbmodem142101",  9600); // Set the com port and the baud rate according to the Arduino IDE
  myPort.bufferUntil ( '\n' );   // Receiving the data from the Arduino IDE
  
  
  // allow resize and update surface to image dimensions
  surface.setResizable(true);
  surface.setSize(img.width, img.height);
  
  // load image onto surface - scale to the available width,height for display
  image(img, 0, 0, width, height);
}

void serialEvent (Serial myPort) {
  brightnessValue  =  float (myPort.readStringUntil ( '\n' ) ) ;  // Changing the background color according to received data
  println(brightnessValue);
  column = 0;
  row = 0;
} 

void draw() {
  if (frame < animation.length - 1) {
    // while: all done in one frame
    // if: each frame another col & row
    // loop through columns
    while(column < img.width-1) {
      img.loadPixels(); 
      sortColumn();
      column++;
      img.updatePixels();
    }
    
    // loop through rows
    while(row < img.height-1) {
      img.loadPixels(); 
      sortRow();
      row++;
      img.updatePixels();
    }
 

    // load updated image onto surface and scale to fit the display width,height
    image(img, 0, 0, width, height);
    frame++;
    img = animation[frame];
  
    column = 0;
    row = 0;
  }  else {
    println("reset");
    // always reset the original frame (not the glitchy one!!)
    frame = 0;
  }
  
}

void sortRow() {
  int y = row;
  int x = 0;
  int xend = 0;
  
  while(xend < img.width - 1) {
   
    x = getFirstBrightX(x, y);
    xend = getNextDarkX(x, y);
    
    if(x < 0) break;
    
    int sortLength = xend-x;
    
    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];
    
    for(int i=0; i<sortLength; i++) {
      unsorted[i] = img.pixels[x + i + y * img.width];
    }
    
    sorted = sort(unsorted);
    
    for(int i=0; i<sortLength; i++) {
      img.pixels[x + i + y * img.width] = sorted[i];      
    }
    
    x = xend+1;
  }
}


void sortColumn() {
  // current column
  int x = column;
  
  // where to start sorting
  int y = 0;
  
  // where to stop sorting
  int yend = 0;
  
  while(yend < img.height-1) {
   
    y = getFirstBrightY(x, y);
    yend = getNextDarkY(x, y);

    if(y < 0) break;
    
    int sortLength = yend-y;
    
    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];
    
    for(int i=0; i<sortLength; i++) {
      unsorted[i] = img.pixels[x + (y+i) * img.width];
    }
    
    sorted = sort(unsorted);
    
    for(int i=0; i<sortLength; i++) {
      img.pixels[x + (y+i) * img.width] = sorted[i];
    }
    
    y = yend+1;
  }
}

// brightness x
int getFirstBrightX(int x, int y) {
  while(brightness(img.pixels[x + y * img.width]) < brightnessValue) {
    x++;
    if(x >= img.width)
      return -1;
  }
  return x;
}

int getNextDarkX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  while(brightness(img.pixels[x + y * img.width]) > brightnessValue) {
    x++;
    if(x >= img.width) return img.width-1;
  }
  return x-1;
}

// brightness y
int getFirstBrightY(int x, int y) {
  if(y < img.height) {
    while(brightness(img.pixels[x + y * img.width]) < brightnessValue) {
      y++;
      if(y >= img.height)
        return -1;
    }
  }
  return y;
}

int getNextDarkY(int x, int y) {
  y++;
  if(y < img.height) {
    while(brightness(img.pixels[x + y * img.width]) > brightnessValue) {
      y++;
      if(y >= img.height)
        return img.height-1;
    }
  }
  return y-1;
}
