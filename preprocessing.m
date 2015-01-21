function I = preprocessing( image_path )

I = imread(image_path);
I = imresize(I,[512 512]);
figure; imshow(I), title('ORIGINAL');

%% Binarization
bw_img_local = BinarizeImage(I,25);
figure; imshow(bw_img_local), title('BW');

%% Largest Connected Component (Sudoku)
BBs = regionprops(bw_img_local, 'BoundingBox');
Convs = regionprops(bw_img_local, 'ConvexHull');
max_area_index = max_bb(BBs);
ICrop = imcrop(bw_img_local, BBs(max_area_index).BoundingBox);
figure; imshow(ICrop), title('CROPPED');


%% ConvexHull of Largest Connected Component
maxConv = convhull(Convs(max_area_index).ConvexHull(:,1),Convs(max_area_index).ConvexHull(:,2) ,'simplify', true);
Points = zeros(length(maxConv),2);
% get points
for i = 1:length(maxConv)
    Points(i,:) = Convs(max_area_index).ConvexHull(maxConv(i),:);
end


%% Keep only points within Sudoku
x = Points(:,1);
y = Points(:,2);
mask = poly2mask(x, y, 512, 512);
OnlySudoku = bw_img_local .* mask;
[corn,cent] = get_corners(mask);

figure, imshow(OnlySudoku);
hold on
for i = 1 : size(corn,1)
    plot(corn(i,1),corn(i,2),'Marker','.','Color',[1 0 0],'MarkerSize',20);
    plot(cent(i,1),cent(i,2),'Marker','.','Color',[1 0 0],'MarkerSize',20);
end


% Camera Calibration
hw = 512;
moving = [corn(1,1), corn(1,2); corn(2,1), corn(2,2); corn(3,1), corn(3,2); corn(4,1), corn(4,2); cent(1,1), cent(1,2); cent(2,1), cent(2,2); cent(3,1), cent(3,2); cent(4,1), cent(4,2)];
fixed =  [1,1; hw,1; 1,hw; hw,hw; hw/2,1; 1,hw/2; hw,hw/2; hw/2,hw/2];  


hgte1 = vision.GeometricTransformEstimator('Transform','projective','ExcludeOutliers',false);
tform = step(hgte1, moving(1:4,:), fixed(1:4,:));
hgt = vision.GeometricTransformer;
I = step(hgt, OnlySudoku, tform);
I = imresize(I,[512 512]);

figure; imshow(I);

end

