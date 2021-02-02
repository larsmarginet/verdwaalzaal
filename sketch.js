// https://github.com/wangyasai/Perlin-Noise/blob/gh-pages/js/sketch.js

let serial; // variable to hold an instance of the serialport library
let portName = '/dev/tty.usbmodem142101';
let inData;
let capturer;
let btn;


let particles = [];
let maxLife;


let options = {  
  Background : '#0a0a0a',
  Color1 : '#cf4a4a',
  Color2 : '#1cb3d4',
  Color3 : '#ffd100',
  Length : 5,
  Nums : 400,
  Size : 2,
  noiseScale: 800,
}


function setup() {
  createCanvas(windowWidth, windowHeight);
  background(options.Background);
  // creates 2500 particles
  for(var i = 0; i < 2500; i++){
    particles[i] = new Particle();
  }
  arduino();
  createButton();
}



function draw() {
  noStroke();
  smooth();  

  maxLife = options.Length;
  for(let i = 1; i < options.Nums; i++){
      let iterations = map(i, 0, options.Nums, 5, 1);
      // adjust thickness of lines
      let radius = 2;
      
      particles[i].move(iterations);
      particles[i].checkEdge();
      
      let alpha = 255;
      let particleColor;
      let fadeRatio;
      fadeRatio = min(particles[i].life * 5 / maxLife, 1);
      fadeRatio = min((maxLife - particles[i].life) * 5 / maxLife, fadeRatio);
      
      // Calculates the distance between particle and center 
      let distance = dist(particles[i].pos.x, particles[i].pos.y, width/2, height/2);
      // normalizes the distance between 0 and 400
      let percent1 = norm(distance, 0, 400);
      // normalizes the distance between 0 and the edge of the screen (x-axis)
      let percent2 = norm(distance, 400, width/2);
      from = color(options.Color1);
      middle = color(options.Color2);
      to = color(options.Color3);
      between1 = lerpColor(from, middle, percent1);
      between2 = lerpColor(middle, to, percent2);
      if (distance < 400) {
          particleColor = between1;
      } else {
          particleColor = between2;   
      }    
      fill(red(particleColor), green(particleColor), blue(particleColor), alpha * fadeRatio);
      particles[i].display(radius);
  } 
  if (capturer) {
    capturer.capture(document.getElementById("defaultCanvas0"));
  }
}

function Particle(){
  this.vel = createVector(0, 0);
  this.pos = createVector(random(-50, width+50), random(-50, height+50));
  this.life = random(0, 5);    
  this.move = function(iterations){
      if ((this.life -= 0.01666) < 0) this.respawn();

      while (iterations > 0) {
          var angle = noise(this.pos.x/options.noiseScale, this.pos.y/options.noiseScale)*TWO_PI*options.noiseScale;
          this.vel.x = cos(angle);
          this.vel.y = sin(angle);
          // determines velocity of particle
          this.vel.mult(.2);
          this.pos.add(this.vel);
          --iterations;
      }
  }

  this.checkEdge = function(){
      if(this.pos.x > width || this.pos.x < 0 || this.pos.y > height || this.pos.y < 0){
          this.respawn();
      }
  }
  
  this.respawn = function(){
      this.pos.x = random(-50, width+50);
      this.pos.y = random(-50, height+50);
      this.life = maxLife;
  }

  this.display = function(r){
      ellipse(this.pos.x, this.pos.y, r, r);
  }
}

// function touchStarted(){
//   background(options.Background);
//   for(var i = 0; i < options.Nums; i++){
//       particles[i].respawn();
//       particles[i].life = random(0,maxLife);
//   }
// }












function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
  background(options.Background);
}

function mousePressed() {
  if (mouseX > 0 && mouseX < 100 && mouseY > 0 && mouseY < 100) {
    let fs = fullscreen();
    fullscreen(!fs);
  }
}

function record() {
  capturer = new CCapture({
    format: "webm",
    framerate: 24,
    verbose: true,
    quality: 15, 
    timeLimit: 10,
  });
  capturer.start();
  btn.textContent = "stop recording";
  btn.onclick = e => {
    capturer.stop();
    capturer.save();
    capturer = null;
    btn.textContent = "start recording";
    btn.onclick = record;
  };
}

const createButton = () => {
  btn = document.createElement("button");
  btn.textContent = "start recording";
  document.body.appendChild(btn);
  btn.style.display = 'none'
  btn.onclick = record;
  setTimeout(() => {
    //btn.click(); //start recording automatically
  }, 3000);
}

const arduino = () => {
  serial = new p5.SerialPort();             // make a new instance of the serialport library
  serial.on('list', printList);             // set a callback function for the serialport list event
  serial.on('connected', serverConnected);  // callback for connecting to the server
  serial.on('open', portOpen);              // callback for the port opening
  serial.on('data', serialEvent);           // callback for when new data arrives
  serial.on('error', serialError);          // callback for errors
  serial.on('close', portClose);            // callback for the port closing
 
  //serial.list();                          // list the serial ports
  serial.open(portName);                    // open a serial port
}

// get the list of ports:
function printList(portList) {
  // portList is an array of serial port names
  for (var i = 0; i < portList.length; i++) {
    // Display the list the console:
    console.log(i + portList[i]);
  }
}

function serverConnected() {
  console.log('connected to server.');
}
 
function portOpen() {
  console.log('the serial port opened.')
}
 
function serialEvent() {
  inData = -(Number(serial.read()) - 250);
}
 
function serialError(err) {
  console.log('Something went wrong with the serial port. ' + err);
}
 
function portClose() {
  console.log('The serial port closed.');
}