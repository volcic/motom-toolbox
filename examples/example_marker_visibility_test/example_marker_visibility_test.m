% This piece of code initialises the system, and checks if the markers are visible with the current configuration

clear all;
clc;


% So, this works by initialising the Optotrak system, loading a standard camera file,
% and in an infinite loop, we get the marker positions, and plot their status.
% If a marker coordinate is NaN, the marker is not visible.



optotrak_startup; % Breathe some life into the system
optotrak_set_up_system('standard', 'this_works_with_the_ndi_cube.ini'); % Standard camera file

% Loop. It automatically updates the plot. It also adapts to the numbner of markers too.

while(1)
    [fail, framecounter, position3d_array, flags] = DataGetNext3D_as_array();
    optotrak_plot_marker_status(position3d_array);
end