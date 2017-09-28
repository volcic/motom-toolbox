% RUNME.m
% Run this script if you are starting from scratch.
% This script looks around your matlab environment: checks architecture,
% looks for the correct binaries and header files.
% Once everything is OK, it generates the required matlab files as well.
%
% The error messages here help you set up your system to use this toolbox.

clear all;
clc;

%Assuming this is running in the toolbox, we need to clean up.
make_mrproper;
%% Check architecture. Throw error message if not supported.

architecture = computer('arch');

switch architecture
    case 'win64'
        fprintf('You are using Matlab on Windows. ')
        %The presence of this file determines whether the 32 or 64-bit to use.
        fp = fopen(sprintf('generated_binaries/use_64_bits'), 'w');
        fclose(fp);
    case 'glnxa64'
        fprintf('you are using Matlab on Linux.')
        %The presence of this file determines whether the 32 or 64-bit to use.
        fp = fopen(sprintf('generated_binaries/use_64_bits'), 'w');
        fclose(fp);
    case 'win32'
        warning('You are using a 32-bit version of Matlab.')
    case 'maci64'
        error('The Optotrak API does not work on Mac.')
    otherwise
        fprintf('Detected achitecture is: %s\n', architecture)
        error('The optotrak API supports x86, amd64 architectures, and only Windows and Linux.')
end


%% Now, check if there is a supported compiler.

compiler_info = mex.getCompilerConfigurations('C++', 'selected');

%This is hard-coded to this version. Not sure if this works with the newer
%version. Change it as/when necessary.
if( ~strcmp(compiler_info.Name, 'Microsoft Visual C++ 2015 Professional') && ...
        ~strcmp(compiler_info.Name, 'gcc 4.9.3'))
    fprintf('It seems that your system doesn''t have a supported C++ compiler installed and/or registered in Matlab.\n')
    fprintf('Type:\n\nmex -setup C++\n to see what you have.\n')
    fprintf('If running Windows, you need to install Visual Studio Community 2015, WITH C++ SUPPORT ENABLED.\n')
    fprintf('Linux users should be OK with a current version of gcc and g++,\nand just add your compiler to this statement to get through this error message.\n')
    error('No supported C++ compiler found.')
end

fprintf('Detected compiler is: %s\n', compiler_info.Name)

%% Check if the library and header file are there.
%You need to get these files from NDI by purchasing the API. Also, you need
%to modify the header files, consult the documentation for this.
header_file_list = {'ndhost.h', 'ndopto.h', 'ndpack.h', 'ndtypes.h'};
binary_file_list = {'oapi64.dll', 'oapi.dll', 'oapi64.lib', 'oapi.lib'};

fprintf('Checking for NDI''s API files...\n');
%Again, hard-coded, we need to check for four files.
for(i = 1:4)
    %This bit checks the header files
    if(exist(sprintf('source/%s', header_file_list{i}), 'file') == 2)
        fprintf('%s found.\n', header_file_list{i})
    else
        fprintf('Missing file! -> source/%s\n', header_file_list{i})
        error('There is a missing header file. Make sure you copy them to the source directory!')
    end
    
    %...and this bit checks the binaries.
    if(exist(sprintf('bin/%s', binary_file_list{i}), 'file') == 2)
        fprintf('%s found.\n', binary_file_list{i})
    else
        fprintf('Missing file! -? bin/%s\n', binary_file_list{i})
        error('There is a missing binary file. Make sure you copy them to the bin directory!')
    end
end

%% If we made it this far, we can compile.
% at this point, we need to depend on platforms.

cd generated_binaries;
% This step shouldn't fail. If it does, you'll need to look at the
% compiler's output of the file concerned.
if(isunix)
    [~, warnings] = loadlibrary('../bin/oapi64.lib', '../source/ndopto.h', 'addheader', '../source/ndtypes.h', 'addheader', '../source/ndhost.h', 'addheader', '../source/ndpack.h', 'mfilename','api_prototypes');
else
    %Windows can also have a 32-bit version, which we have to worry about
    %If you want to see the compiler warning output, remove the semicolon
    %from the loadlibrary() statement.
    if(exist('use_64_bits', 'file') == 2)
        % Compile the 64bit stuff.
        [~, warnings] = loadlibrary('../bin/oapi64.dll', '../source/ndopto.h', 'addheader', '../source/ndtypes.h', 'addheader', '../source/ndhost.h', 'addheader', '../source/ndpack.h', 'mfilename', 'api_prototypes');
    else
        %32-bit stuff.
        [~, warnings] = loadlibrary('../bin/oapi.dll', '../source/ndopto.h', 'addheader', '../source/ndtypes.h', 'addheader', '../source/ndhost.h', 'addheader', '../source/ndpack.h', 'mfilename','api_prototypes');
    end
end
% warnings is a string, but you should also see this in the console.
fprintf('If you see this message, the compiler succeeded and it generated the binaries Matlab needs.\nThis is a good thing.\n')
cd ..

%Okay, if we survived for this long, we should be OK for the rest.
toolbox_path = pwd;
addpath(toolbox_path); %root dir
addpath(sprintf('%s/bin', toolbox_path)); %This is where the binaries are
addpath(sprintf('%s/api_functions', toolbox_path)); %This allows you to conveniently all the functions as described in NDI's manual
addpath(sprintf('%s/convenience', toolbox_path)); %This is where some pre-made convenience functions are located.
addpath(sprintf('%s/generated_binaries', toolbox_path)); %This is only required for the function prototypes
addpath(sprintf('%s/plotting', toolbox_path)); %Added some plotting scripts
msgbox('The toolbox has been set up, and it has been added to the path. To make this permanent, click ''yes'' at the next prompt if it pops up.', 'Toolbox setup successful');



%% compile helper functions written in C.
%Add the names of the C files you want to compile during toolbox set-up.
fprintf('Now compiling the helper functions...\n')
files_to_compile = {'DataGetLatest3D_as_array.c', 'DataGetNext3D_as_array.c', 'DataGetLatestTransforms2_as_array.c', 'DataGetNextTransforms2_as_array.c', 'RigidBodyAddFromFile_euler.c', 'optotrak_tell_me_what_went_wrong.c', 'optotrak_convert_raw_file_to_position3d_array.c', 'optotrak_convert_raw_file_to_rigid_euler_array.c', 'optotrak_align_coordinate_system.c', 'optotrak_register_system_static.c', 'optotrak_register_system_dynamic.c'};
cd generated_binaries
for(i = 1:length(files_to_compile))
    fprintf('\nCompiling %s:\n', files_to_compile{i});
    file_string = sprintf('../source/%s', files_to_compile{i});
    % if we made it this far, the rest of the stuff compiled, and
    % everything is set up for the platform it will run on.
    if(new_or_old)
        mex(file_string, '../bin/oapi64.lib');
    else
        mex(file_string, '../bin/oapi64.lib');
    end
    pause(0.5); %wait for the compilation process to finish.
end
cd(toolbox_path);
fprintf('Compiling the mex files didn''t fail!\n');

%unload library.
optotrak_kill;



%savepath; %Make these permanent.
fprintf('Toolbox path added, all done!\n')