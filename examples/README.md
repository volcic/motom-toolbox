***
# [Examples](../tree/master/examples)
All examples use their own .ini config files, which is found in each directory. There is also a collection of config files in the `example_config_files` directory.

***
### `example_marker_visibility_test.m`
This one can be used to check for marker visibility. It can be particularly useful when creating a new set-up, and one needs to determine the minimum marker power.

***

### `example_simple_experiment.m`
This script configures the Optotrak system to stream data, and the trials are recorded in a 3D array, and stored in the memory. Probably this is the simplest way to use the system, and can be viable for small experiments. However, note that every trial is stored in the memory, and you will lose this information when the system crashes.

***

### `example_fileio_experiment.m`
This script uses data buffering. Every trial gets recorded using the data buffer functions, and every trial is saved as a separate raw data file in the `data` directory. Then, after re-initialising the system, the raw data files are loaded back, to calculate the 3D positions recorded in each trial.

***

### `example_advanced_experiment.m`
The experiment collects a couple of trials using the buffer. Instead of saving every raw data file, a single temporary data file is being periodically overwritten. After the end of each trial, `optotrak_convert_raw_file_to_position3d_array()` will get called to get the buffered that. Note that there are two nested loops included:
* The experimental loop,
...which gets executed for every trial, and handles the data buffer and the raw-to-position data conversion.
* The real-time loop,
...which handles real-time data. Note that the execution of the real-time loop is not tied to the frame rate or the experimental loop. It will keep running until the `framecounter` variable indicates that the appropriate number of frames have been collected to the data buffer within the trial.

***

### `example_rigid_body_handling.m`
This example uses real-time data, and it loads a cube that NDI has supplied, as can be seen at `RigidBodyAddFromFile_eruler()` Then it executes `DataGetNextTransforms2_as_array()`, which will enable to get access to the:
* Frame counter
* Translation coordinates
* Rotation angles (IN RADIANS!)
* ...and if the number of markers are given, the marker positions themselves
The translation of the rigid body is visualised as Marker 1.

***

### `example_rigid_body_handling_with_buffer.m`
This example is for heavy users. It's similar to `example_advanced_experiment.m` in the sense that a raw data file is being recorded during the trial. However, the rigid body transforms are fetched using `optotrak_convert_raw_file_to_rigid_euler_array()`, which returns the marker coordinates as well.
There are two nester loops here:
* The experimental loop, which handles the raw data recording:
 The data is recorded via `DataBufferInitializeFile()` -> `DataBufferStart()` —> `optotrak_stop_buffering_and_write_out()`.
* The real-time loop, which allows monitoring of the rigid body and the marker coordinates:
 Since in this application the frame rate is faster than the real-time data access time, `DataGetLatestTransforms2_as_array()` is used. To check how the frames are not accessible as real-time data, check the `framecounter` variable.

***

### `example_virtual_marker_handling.m`

This example requires 3D printing, the .stl file and a picture of the set-up is given in the example directory.
* The Volciclab Universal Rigid Body with 6 markers
* A simple marker pad

The example uses real-time data to get the rigid body transform. It is required to keep the marker pad steady, as its coordinate will be used to create the virtual marker. Then, by using the definition created, the virtual marker positions are plotted, provided that the rigid body transform was successful.

***

### `example_virtual_marker_test.m`
This example shows what happens when an incorrectly made rigid body file returns false data. When the device is at right angles, everything is fine, but the directions of some axes are reversed, and some of the are swapped too. Please have a similar test method in place in your set-up, so you know that all your rigid bodies are behaving correctly.

You can manually change the virtual marker definition too, see what it does and how it works.

***

# *A note on performance*
`DataGetLatest3D_as_array()` and `DataGetLatestTransforms2_as_array()` takes about 10 milliseconds to return data on our computer.
`DataGetNext3D_as_array()` and `DataGetNextTransforms2_as_array()` will take one frame time, or about 10 milliseconds, whichever is higher.
Consequently, if the frame rate is over approximately 100 Hz, not every frame will be accessible as real-time data. This means that the real-time data will be *subsampled*, and thus it is necessary to record data via buffering.
**It is the responsibility of the experimenter to determine whether if this subsampling effect is harmful.**