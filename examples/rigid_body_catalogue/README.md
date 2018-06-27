# What's in here?

Here are a few 3D-printable objects.

## How to get these rigid bodies to work with my system

1. Print the `.stl` file
2. Assemble the markers as shown on the photos with the same file name
3. Connect the markers to the strober, and load the `.rig` file using `RigidBodyAddFromFile_euler()`.

Hope you can find a use for these.

# What about the cube?
The cube is sold by NDI pre-assembled. It has an Optotrak 3020 interface, so a converter is required to be used with the Optotrak Certus.  
While it comes with a pre-defined rigid body file, we decided to build a different one:
* The origin is now at the corner of the object.
* The Z=0 plane is the top of the object, and the positive Z values are towards the handle

This now can simplify the alignment process: Simply place the cube upside down on a table, and the table will become the X-Y plane.

Z