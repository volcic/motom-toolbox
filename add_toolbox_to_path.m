%temporarily. I don't want to ruin the existing optotrak installation by
%permanently overwriting the function access

toolbox_path = pwd;

addpath(toolbox_path); %root dir
addpath(sprintf('%s/bin', toolbox_path)); %This is where the binaries are
addpath(sprintf('%s/api_functions', toolbox_path)); %This allows you to conveniently all the functions as described in NDI's manual
addpath(sprintf('%s/convenience', toolbox_path)); %This is where some pre-made convenience functions are located.
addpath(sprintf('%s/generated_binaries', toolbox_path)); %This is only required for the function prototypes
addpath(sprintf('%s/calibration', toolbox_path)); %This has the calibration scripts.