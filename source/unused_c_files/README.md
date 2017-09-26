Why are these files here?
============================
These files are not needed for day-to-day use in the toolbox. However, it might help with debugging.
Files are:
* `DataReceiveLatest3D_as_array.c`: Non-blocking mode doesn't seem to work from Matlab, even if I wrote this in C.
* `dump_config_file_for_buffered.c`: Creates a WORKING config file for buffered mode.
* `dump_config_file_for_streaming_with_blocking.c`: This initialises the Optotrak system, and saves a WORKING config file. You can edit this file to change settings. You can use OptotrakSetupCollectionFromFile(), OptotrakGetStatus() and OptotrakSetupCollection() to change settings programmatically. This way, it won't crash.
* `dump_config_file_for_streaming_without_blocking.c`: For some reason, non-blocking mode doesn't work in Matlab. It doesn't work, even when I call the same function in C. I think this is an API bug.
* `garbage_buffer_allocate_for_raw_data.c`: When I tried to get the raw data management working for Matlab.
* `garbage_download_position_buffer_as_array.c` If you use buffered mode, save the raw data instead, and convert after you finished collecting data. Less likely to crash, less likely to lose data.
* `optotrak_convert_raw_data.c`: I re-wrote this, and now it's in the toolbox.
* `optotrak_register_and_align_many_cameras.c`: This one makes the system hang and there is weird traffic going on the network
* `optotrak_test.c`: I used this small function to learn how mex files worked in Matlab. you can use it to make your own helper scripts, if you want to.
* `RequestLatest3D_data.c`: Non-blocking mode doesn't seem to work from Matlab, even if I wrote this in C.


