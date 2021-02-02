# 1 - P5 & ARDUINO

This is a simple script to control a P5 sketch with an Arduino. In this case I connected a potentiometer on pin A0 (see sketch_arduino-p5).
The serial communication to the browser happens over websockets with a tool called [P5.serialcontrol](https://github.com/p5-serial/p5.serialport).

On line 2 of the sketch the port is set to /dev/tty.usbmodem142101, but it might be a different one for you, so be sure to set it to the right one.
![example](sketch.png "Example")
