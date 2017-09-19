%This just plots a 3D array:
% dimension 1 is frames
% dimension 2 is the number of markers
% dimension 3 is x-y-z

[frames, coords] = size(position_frames);
triplets = coords/3; %because we have x-y-z stuff.
%Filter out non-visible markers
for(i=1:frames)
    for(j=1:coords)
        if(position_frames(i, j) < -1E+10)
            position_frames(i, j) = NaN; %not a number.
        end
    end
end

figure;
hold on;
for(j=1:triplets)
    scatter3( position_frames(:, ((j-1)*3)+1), position_frames(:, ((j-1)*3)+2), position_frames(:, ((j-1)*3)+3) );
    plot3( position_frames(:, ((j-1)*3)+1), position_frames(:, ((j-1)*3)+2), position_frames(:, ((j-1)*3)+3) );
end
grid on;