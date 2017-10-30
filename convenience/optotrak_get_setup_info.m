function [ setup_info_struct ] = optotrak_get_setup_info(  )
%OPTOTRAK_GET_SETUP_INFO
% [ setup_info_struct ] = optotrak_get_setup_info(  )
% This function determines how the Optotrak system is configured. Essentially, it calls OptotrakGetStatus(), but it does all the variable declarations for you. You can get all the information with just a single line, which is extremely convenient.
%   -> There are no input arguments.
% -Output argument is a structure, with all the parameters conveniently
%  named in the fields.


% I wrote this function because I got sick and tired of pasting a pages'
% worth of variable declarations for no apparent reason.

    fail = 0;
    setup_info_struct.number_of_sensors = 0;
    setup_info_struct.number_of_odaus = 0;
    setup_info_struct.number_of_loaded_rigid_bodies = 0;
    setup_info_struct.number_of_markers = 0;
    setup_info_struct.frame_rate_in_fps = 0;
    setup_info_struct.marker_frequency_in_hz = 0;
    setup_info_struct.image_threshold_value_in_pixels = 0;
    setup_info_struct.sensor_gain = 0;
    setup_info_struct.are_we_streaming = 0;
    setup_info_struct.marker_power_duty_cycle = 0;
    setup_info_struct.marker_voltage = 0;
    setup_info_struct.collection_time = 0;
    setup_info_struct.pretrigger_time = 0;
    setup_info_struct.flags = 0;


    [fail, setup_info_struct.number_of_sensors, setup_info_struct.number_of_odaus, setup_info_struct.number_of_loaded_rigid_bodies, setup_info_struct.number_of_markers, setup_info_struct.frame_rate_in_fps, setup_info_struct.marker_frequency_in_hz, setup_info_struct.image_threshold_value_in_pixels, setup_info_struct.sensor_gain, setup_info_struct.are_we_streaming, setup_info_struct.marker_power_duty_cycle, setup_info_struct.marker_voltage, setup_info_struct.collection_time, setup_info_struct.pretrigger_time, setup_info_struct.flags] = OptotrakGetStatus(setup_info_struct.number_of_sensors, setup_info_struct.number_of_odaus, setup_info_struct.number_of_loaded_rigid_bodies, setup_info_struct.number_of_markers, setup_info_struct.frame_rate_in_fps, setup_info_struct.marker_frequency_in_hz, setup_info_struct.image_threshold_value_in_pixels, setup_info_struct.sensor_gain, setup_info_struct.are_we_streaming, setup_info_struct.marker_power_duty_cycle, setup_info_struct.marker_voltage, setup_info_struct.collection_time, setup_info_struct.pretrigger_time, setup_info_struct.flags);

    if(fail)
        error('OptotrakGetStatus() failed. Is your system initialised at all? Did you lose communication to it perhaps?')
    end

    %Alternatively, you can use this one-liner here:
    setup_info_struct.decoded_flags = optotrak_device_flag_decoder(setup_info_struct.flags);


end

