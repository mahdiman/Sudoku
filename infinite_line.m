function [p1,p2] = infinite_line(point1, point2, n, m)


p1 = zeros(2,1);
p2 = zeros(2,1);

Xdiff = point1(1)-point2(1);
Ydiff = point1(2)-point2(2);
% vertical
if Xdiff == 0
    p1(1) = point1(1);
    p1(2) = 1;
    p2(1) = point1(1);
    p2(2) = n;
    
elseif Ydiff == 0
    %horizontal
    p1(1) = 1;
    p1(2) = point1(2);
    p2(1) = m;
    p2(2) = point1(2);
else
    m1 = Xdiff/Ydiff;
    c1 = -1*m1*point1(2) + point1(1);
    if abs(Xdiff) > abs(Ydiff)
        % horizontal
        p1(1) = 1;
        p1(2) = round((1 - c1)/m1);
        p2(1) = m;
        p2(2) = round((m - c1)/m1);
    else
        %vertical
        p1(1) = round(m1 + c1);
        p1(2) = 1;
        p2(1) = round(m1*n + c1);
        p2(2)= n;
    end
end


end