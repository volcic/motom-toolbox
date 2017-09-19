Why are there additional C-files here?
=====================================

Matlab's shared library doesn't work with nested structures at all, and it only partially works with structure arrays. You only can get the first entry directly with
```
    get(<pointer>, 'Value'));
```
 and if you manually adjust the pointer, you have a chance of reading the data out - once. I found it unstable, so I wrote these wrapper functions that does the job, and returns arrays instead.

IMPORTANT: You need to have the system properly initialised to be able to use these functions!
--------------------------------------


For the Position3D data, the format is X-Y-Z for each marker you have.

For instance, a 10 marker setup will produce an array that is 30 entries wide.

You can read what these do in detail in the C code, or by typing
```
    help <function_name>
```
Otherwise:
```
    [fail, framecounter, position3d_array, flags] = DataGetNext3D_as_array();
    [fail, framecounter, position3d_array, flags] = DataGetLatest3D_as_array();
    [fail, framecounter, transformation_array, rotation_array, position3d_array, flags] = DataGetNextTransforms2_as_array(number_of_markers_used);
    [fail, framecounter, transformation_array, rotation_array, position3d_array, flags] = DataGetLatestTransforms2_as_array(number_of_markers_used);
    [fail] = RigidBodyAddFromFile(rigid_body_ID, start_marker, <rigid_body_file>);
    [] = optotrak_tell_me_what_went_wrong();
```

