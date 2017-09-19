%This script wipes everything. This allows you to re-compile the object
%files.

clear all;
clc;

%Assuming this is running in the toolbox, we need to clean up.
if(isunix)
    system('rm generated_binaries/*');
    system('rm temp/*');
else
    system('del /s /q generated_binaries');
    system('del /s /q temp');
end

%Add some placeholder files to these directories, so git will sync it properly.
fp = fopen('generated_binaries/compiled_binaries_will_come_here', 'w+');
fprintf(fp, 'I tried to think about writing something funny here, but I decided not to. Enjoy.');
fclose(fp);
fp = fopen('temp/temp_directory_nothing_to_see_here', 'w+');
fprintf(fp, 'If you are reading this, you are way too curious! Which is brilliant. Keep it on!');
fclose(fp);

