Why are these files here?
============================
These files are not needed for day-to-day use in the toolbox. However, it might help with debugging.
Files are:
-DataReceiveLatest3D_as_array.c: Non-blocking mode doesn't seem to work from Matlab, even if I wrote this in C.
-RequestLatest3D_data.c: Non-blocking mode doesn't seem to work from Matlab, even if I wrote this in C.
-optotrak_test.c: I used this small function to learn how mex files worked in Matlab. you can use it to make your own helper scripts, if you want to.
-dump_config_file_for_streaming_with_blocking.c: This initialises the Optotrak system, and saves a WORKING config file. You can edit this file to change settings. You can use OptotrakSetupCollectionFromFile(), OptotrakGetStatus() and OptotrakSetupCollection() to change settings programmatically. This way, it won't crash.
-dump_config_file_for_streaming_with_blocking.c: For some reason, blocking mode doesn't work in Matlab. It doesn't work, even when I call the same function in C. I think this is an API bug.

