%This script is called by RUNME.m
%So far, if we got here, we know that the script is being run on a compatible system.
%But, we don't know if we can compile the C-code yet, because we don't have a clue about what compiler is available.
%Different compilers will need specific settings, despite the C-code being written as generally as possible.
%the compiler string is stored in the string compiler_info.Name. If some stuff is picky, we might need to incorporate
%separate statements for different versions of the same compiler as well. This is stored in compiler_info.Version.


compiler_info = mex.getCompilerConfigurations('C++', 'selected'); %This shows what the current compiler is.
%This is a semaphore. If no suitable compiler is found, this variable will not get updated, and the error message
%defined at the bottom of the screen will be displayed.
compiler_found = 0;

%% ADD YOUR COMPILER NAME HERE, CHANGE THIS LINE!
% Change this comment too, so we will know how did you get it to work.
if(strcmp(compiler_info.Name, 'ADD YOUR COMPILER NAME HERE') && ~compiler_found)
    %Maybe only certain versions of your compiler is usable. Perhaps you will need to do a version check
    %Note that the version number is also stored as a string.
    if(strcmp(compiler_info.Version, 'ADD YOUR COMPILER VERSION HERE'))
        %Note that we always APPEND to the compiler flags. The default flags are set in the $COMPFLAGS environment
        %variable and is used by Matlab's mex command.
        compiler_flags = ''; %You may not need to add any extra compiler flags, but if you do, add them here.

        compiler_found = 1;
    end
end

%% Microsoft Windows SDK 7.1 (C++)
% You need the version .NET framework 4.0 and not the later ones to install this compiler
if(strcmp(compiler_info.Name, 'Microsoft Windows SDK 7.1 (C++)') && ~compiler_found)
    %Maybe only certain versions of your compiler is usable. Perhaps you will need to do a version check
    %Note that the version number is also stored as a string.
    if(strcmp(compiler_info.Version, '7.1'))
        %Note that we always APPEND to the compiler flags. The default flags are set in the $COMPFLAGS environment
        %variable and is used by Matlab's mex command.
        compiler_flags = ''; %You may not need to add any extra compiler flags, but if you do, add them here.
        error('This compiler has been reported not to work with the C-code included in the toolbox. If you feel lucky, you can still use it, by simply commenting out this error message in compilers.m.')
        compiler_found = 1;
    end
end

%% Microsoft Visual Studio 2013
if(strcmp(compiler_info.Name, 'Microsoft Visual C++ 2013 Professional') && ~compiler_found)
    %Maybe only certain versions of your compiler is usable. Perhaps you will need to do a version check
    %Note that the version number is also stored as a string.
    if(strcmp(compiler_info.Version, '12.0'))
        %Note that we always APPEND to the compiler flags. The default flags are set in the $COMPFLAGS environment
        %variable and is used by Matlab's mex command.
        compiler_flags = '/O2 /Wall'; %You may not need to add any extra compiler flags, but if you do, add them here.
         compiler_found = 1;
    end
end

%% Microsoft Visual C++ 2015 Professional
%This is the compiler I used during development.
if(strcmp(compiler_info.Name, 'Microsoft Visual C++ 2015 Professional') && ~compiler_found)
    %if we got here, we have found our compiler.
    compiler_found = 1;
    %For each compiler and each version, different compiler flags are needed.
    compiler_flags = '/O2 /Wall'; %Optimise binary for performance, and display everything in the command window.
end

%% Microsoft Visual C++ 2015
%This is bundled with Visual Studio.
if(strcmp(compiler_info.Name, 'Microsoft Visual C++ 2015') && ~compiler_found)
    %if we got here, we have found our compiler.
    compiler_found = 1;
    %For each compiler and each version, different compiler flags are needed.
    compiler_flags = '/O2 /Wall'; %Optimise binary for performance, and display everything in the command window.
end

%% MinGW (downloaded from the add-on browser) - NDI's API does not support it!
%I guess this is the easiest C-compiler Matlab users have access to. Effectively, it's a re-badged GCC, but tuned to
%work on Windows. Unfortunately the NDI API does not support this compiler, because the relevant ndlib defines are
%missing from ndhost.h. Unfortunately only NDI can resolve this.
if(strcmp(compiler_info.Name, 'MinGW64 Compiler (C++)') && ~compiler_found)
    %If we got here, we found our compiler. Version dependence might play a role.
    compiler_found = 0;
    fprintf('You are using the minGW compiler. Unfortunately the Optotrak API has some defines missing,\n')
    fprintf('and the compilation process fails. Please use a Microsoft compiler. Also, check the\n')
    fprintf('Damage control FAQ in the documentation!\n')
    error('MinGW compiler detected. This compiler doesn''t work with the Optotrak API.')
end

%% MinGW64 Compiler with Windows 10 SDK or later (C++)
%This is bundled with Visual Studio Community 2017, when you install C++ desktop development stuff.
if(strcmp(compiler_info.Name, 'MinGW64 Compiler with Windows 10 SDK or later (C++)') && ~compiler_found)
    %if we got here, we have found our compiler.
    compiler_found = 1;
    %For each compiler and each version, different compiler flags are needed.
    compiler_flags = ''; %Optimise binary for performance, and display everything in the command window.
end

%% Microsoft Visual C++ 2017
%This is bundled with Visual Studio Community 2017, when you install C++ desktop development stuff.
if(strcmp(compiler_info.Name, 'Microsoft Visual C++ 2017') && ~compiler_found)
    %if we got here, we have found our compiler.
    compiler_found = 1;
    %For each compiler and each version, different compiler flags are needed.
    compiler_flags = '/O2 /Wall'; %Optimise binary for performance, and display everything in the command window.
end

%% Microsoft Visual C++ 2019
%This is bundled with Visual Studio Community 2019, when you install C++ desktop development stuff.
if(strcmp(compiler_info.Name, 'Microsoft Visual C++ 2019') && ~compiler_found)
    %if we got here, we have found our compiler.
    compiler_found = 1;
    %For each compiler and each version, different compiler flags are needed.
    compiler_flags = '/O2 /Wall'; %Optimise binary for performance, and display everything in the command window.
end

%% g++
%This is the standard Linux compiler. However, we need the old version.
%Unfortunately, the version string stays empty (Ubuntu 18.04, Matlab R2018a)
if(strcmp(compiler_info.Name, 'g++') && ~compiler_found)
    %if we got here, we found our compiler, but it's too generic to be the correct one
    compiler_found = 1;
    %We need to set which compiler we are using.
    error('You are using Linux. Make sure you have an OLD gcc installed, and edit this section of compilers.m accordingly. Just comment out this line when finished. Sorry for the pain!')
    %This assumes you are using Ubuntu 18.04, with gcc6 installed. Change this line accrodingly for your distro. This is going to be a pain.
    %compiler_flags = "GCC='/usr/bin/gcc-6' CPPLIBS='/usr/lib/x86_64-linux-gnu/libstdc++.so.6' LINKLIBS='-L""/usr/local/MATLAB/R2018a/bin/glnxa64"" -lmx -lmex -lmat -lm -loapi'";
    % For older systems, it should be something like:
    %compiler_flags = "GCC='/usr/bin/gcc' CPPLIBS='/usr/lib/libstdc++.so' LINKLIBS='-L""/usr/local/MATLAB/<your version here>/bin/"" -lmx -lmex -lmat -lm -loapi'";
end

%% Make the verdict

if(compiler_found)
    fprintf('Suitable C-compiler found. Now proceeding.\n')
else
    fprintf('It seems that there is a problem with finding a C-compiler in your system.\n')
    fprintf('Type:\n\nmex -setup C++\n to see what you have.\nIf nothing is found, you will need to install one.')
    fprintf('Consult MATLAB''s documentation about supported C compilers.')
    fprintf('Please edit ''compilers.m'' accordingly if Matlab found a compiler but you still see this error message.\n')
    fprintf('...and please submit a bug report on GitHub! :)')
    error('No supported C++ compiler found.')
end