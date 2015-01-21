function [corners,centers] = get_corners( BW )

% -------------------------------------------------------------------------
% Function: Get Corners
% Description: Given a binary image of a polygon of 4 lines, this func. 
% returns the cartesian coordinates of the 4 corners of the polygon.

% inputs: 
% 1- BW: binary image of the polygon

% outputs: 
% 1- corners: a 4-by-2 matrix containing the coordinates of the polygon 
% corners.
% 2- centers: a 4-by-2 matrix containing the coordinates of the ceters of
% bounding the polygon.
% -------------------------------------------------------------------------


%--------------------------- Initializations ------------------------------
points = zeros(8,2);
corners = zeros(4,2);
centers = zeros(4,2);
lines = corners;
%--------------------------------------------------------------------------

%--------------------------- Edge Detection -------------------------------
kernel = strel('disk', 1);
edges = imerode(BW, kernel);
edges = BW-edges;
%--------------------------------------------------------------------------

%--------------------- Hough Transform | Line Detection -------------------
[H,T,R] = hough(edges,'RhoResolution',5);
P = houghpeaks(H, 4, 'threshold',ceil(0.5*max(H(:))));
Lines = houghlines(edges, T, R, P,'MinLength',10);
%--------------------------------------------------------------------------

%-------------------- Infinite Lines Construction -------------------------
index = 1;
for i =1:size(Lines,2)
    [p1,p2] = infinite_line(Lines(1,i).point1, Lines(1,i).point2, 512, 512);
    points(index,1) = p1(1);
    points(index,2) = p1(2);
    points(index+1,1) = p2(1);
    points(index+1,2) = p2(2);
    index = index + 2;
end

figure, imshow(edges);
hold on
for i =1:size(Lines,2)
    plot([Lines(1,i).point1(1) Lines(1,i).point2(1)],[Lines(1,i).point1(2) Lines(1,i).point2(2)], 'Color','r', 'LineWidth',1);
end
hold off

%--------------------------------------------------------------------------


%----------------------- Getting Intersection points-----------------------
index = 1;
for i = 1:4
    lines(1:2,:) = points(2*i-1:2*i,:);
    for j = i+1:4
        lines(3:4,:) = points(2*j-1:2*j,:);
        tempP = linlinintersect(lines);
        if ~(isnan(tempP(1,1)) || tempP(1,1) == Inf || tempP(1,1) == -Inf || isnan(tempP(1,2)) || tempP(1,2) == Inf || tempP(1,2) == -Inf || tempP(1,1) < 1 || tempP(1,1) > 512 ||tempP(1,2) < 1 || tempP(1,2) > 512)
          corners(index,:) = round(tempP(1,:));
          index = index + 1;
        end
    end
end
%--------------------------------------------------------------------------

%------------------------ Sorting Points ----------------------------------
% (1) Top Left
% (2) Top Right
% (3) Bottom Left
% (4) Bottom Right
for i = 1:4
    for j = i+1:4
        if corners(j,2) < corners(i,2)
            tmp = corners(j,:);
            corners(j,:) = corners(i,:);
            corners(i,:) = tmp;
        end
    end
end

if corners(1,1) > corners(2,1)
    tmp = corners(1,:);
    corners(1,:) = corners(2,:);
    corners(2,:) = tmp;
end

if corners(3,1) > corners(4,1)
    tmp = corners(3,:);
    corners(3,:) = corners(4,:);
    corners(4,:) = tmp;
end
%--------------------------------------------------------------------------

%-------------------------- Centers ---------------------------------------

% (1)Top Left and Top Right
% (2)Top Left and Bottom Left
% (3)Top Right and Bottom Right
% (4)Bottom Left and Bottom Right

centers(1,1) = round((corners(1,1)+corners(2,1)) / 2);
centers(1,2) = round((corners(1,2)+corners(2,2)) / 2);

centers(2,1) = round((corners(1,1)+corners(3,1)) / 2);
centers(2,2) = round((corners(1,2)+corners(3,2)) / 2);

centers(3,1) = round((corners(2,1)+corners(4,1)) / 2);
centers(3,2) = round((corners(2,2)+corners(4,2)) / 2);

centers(4,1) = round((corners(3,1)+corners(4,1)) / 2);
centers(4,2) = round((corners(3,2)+corners(4,2)) / 2);
%--------------------------------------------------------------------------