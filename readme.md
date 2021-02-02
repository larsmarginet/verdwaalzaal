# 8 - PROCESSING & NEUROSKY LOGARITHM

This is a sketch to connect your neurosky EEG sensor to Processing and read the values by taking the logarithm and then normalizing them.

In the Neurosky [documentation](http://support.neurosky.com/kb/development-2/eeg-band-power-values-units-amplitudes-and-meaning) it states that the values are exponential, thus you can bring them down within the same range by taking the logarithm.

To make this work, you'll need to download the tool [thinkgearconnector](http://developer.neurosky.com/docs/doku.php?id=thinkgear_connector_tgc). This enables the communication between the two and will return the result in JSON.

You will also have to add the [Thinkgear-Java-Socket](https://github.com/borg/ThinkGear-Java-socket) library to Processing.

![example](sketch.png "Example")