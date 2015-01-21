function [ max_index ] = max_bb( BBs )

max_area = -1;
max_index = -1;

for  i = 1:length(BBs)
    area = BBs(i).BoundingBox(3) * BBs(i).BoundingBox(4);
    if area > max_area
        max_area = area;
        max_index = i;
    end
end

end

