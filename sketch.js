let serial; // variable to hold an instance of the serialport library
let portName = '/dev/tty.usbmodem142101';
let inData;

let font, points;


let capturer;
let btn;
function record() {
  capturer = new CCapture({
    format: "webm",
    framerate: 24,
    verbose: true,
    quality: 99, 
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

function preload() {
	font = loadFont("assets/RobotoMono-Regular.ttf");
}

function setup() {
  let p5Canvas = createCanvas(window.innerWidth, window.innerHeight);
  background(0x08, 0x16, 0x40);
  genType('MEMENTO', height / 4);
  serial = new p5.SerialPort();             // make a new instance of the serialport library
  serial.on('list', printList);             // set a callback function for the serialport list event
  serial.on('connected', serverConnected);  // callback for connecting to the server
  serial.on('open', portOpen);              // callback for the port opening
  serial.on('data', serialEvent);           // callback for when new data arrives
  serial.on('error', serialError);          // callback for errors
  serial.on('close', portClose);            // callback for the port closing
 
  //serial.list();                          // list the serial ports
  serial.open(portName);                    // open a serial port
 

  btn = document.createElement("button");
  btn.textContent = "start recording";
  document.body.appendChild(btn);
  btn.onclick = record;
  setTimeout(() => {
    btn.click(); //start recording automatically
  }, 500);
}



function draw() {
  background(0);
	translate(width / 2, height / 2);

	for(let i = 0; i < points.length; i++) {
    let p = points[i];
		let s = inData / 10 + sin(i * .25 + frameCount * .05) * 10;
		circle(p.x, p.y, s);
  }
  
  if (capturer) {
    capturer.capture(document.getElementById("defaultCanvas0"));
  }
}

function genType(txtString, txtSize) {
	// grab bounding box of text
	let bounds = font.textBounds(txtString, 0, 0, txtSize);

	// textToPoints(txt, x, y, size, options)
	points = font.textToPoints(txtString, -bounds.w / 2, bounds.h / 2, txtSize, {
		sampleFactor: .07,
		simplifyThreshold: 0
	});
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