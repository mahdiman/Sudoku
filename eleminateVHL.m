function [I] =  eleminateVHL(I)
    
    % get lines using hough, then run dfs algorithm from points on line and
    % change pixels densities
    disk = strel('disk',2);
    Temp = I;
    I = imdilate(I,disk);
    [H,T,R] = hough(I,'RhoResolution',5);
    P = houghpeaks(H, 10, 'threshold',ceil(0.3*max(H(:))));
    Lines = houghlines(I, T, R, P,'MinLength',100);
    set(0,'RecursionLimit',512*512);
    for i = 1 : length(Lines)
        x = Lines(i).point1(1);
        y = Lines(i).point1(2);
        I = dfs(I, x, y);
    end
    %I = imerode(I,disk);
    I = I.*Temp;
end