# 4 - PROCESSING & ARDUINO - MADMAPPER

This is a simple sketch to test the communication between an Arduino, processing and MadMapper (a tool for project mapping).

The communication with the Arduino happens over over the Serial library that is included in Processing.

The communication with MadMapper happens over a library called Syphon. Do note that Syphon is Mac-only. To have a similar result on Windows, you can use [Spout](https://spout.zeal.co/)

On line 14 of the sketch the port is set to /dev/tty.usbmodem142101, but it might be a different one for you, so be sure to set it to the right one.
