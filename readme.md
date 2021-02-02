# 2 - P5 & SCREENCAPTURE

This is a simple script to make a screencapture of a P5 sketch.
Note that this captures the canvas and not just the screen. This means a framedrop, will not be seen in the final clip.

The serial communication to the browser happens over websockets with a tool called [P5.serialcontrol](https://github.com/p5-serial/p5.serialport).

On line 2 of the sketch the port is set to /dev/tty.usbmodem142101, but it might be a different one for you, so be sure to set it to the right one.
