function Sudoku( path )

close all;
BW = preprocessing(path);
% rempve lines
BW = eleminateVHL(im2bw(BW));

figure;
imshow(BW);

ch = size(BW, 1) / 9;
cw = size(BW, 2) / 9;

D = zeros(9, 9);

for i = 0 : 8
    for j = 0 : 8
        sx = round( i * ch + 8);
        sy = round( j * cw + 8);
        ex = round(sx + cw - 16);
        ey = round(sy + ch - 16);
        
        figure(1),
        imshow( BW(sx:ex, sy:ey, :) );
        
        text = ocr( BW(sx:ex, sy:ey, :), 'CharacterSet', '0123456789', 'TextLayout', 'Block');
        BW(sx:ex, sy:ey, :) = 0;
        
        if isempty( text.Text )
            D(i+1, j+1) = 0;
        else
            D(i+1, j+1) = 0;
            for k = 1 : length( text.Text )
                num = round(text.Text(k) - '0');
                if( num >= 1 && num <= 9) 
                    D(i+1, j+1) = round(text.Text(k) - '0');
                    break;
                end
            end
        end
        fprintf('%d ', D(i+1, j+1));
    end
    fprintf('\n');
end
D = solve(D);
 
fprintf('\n\n----- solution-------\n------------------------\n');

for i = 1 : 9
    for j = 1 : 9
        if j == 1
            fprintf('|');
        end
        
        position = [round((j-1)*cw + 0.35*cw), round((i-1)*ch + 0.35*ch)];
        BW = insertText(im2double(BW),position, num2str(D(i,j)), 'TextColor', 'white', 'BoxColor', ...
            'black', 'AnchorPoint', 'Center', 'FontSize', 40); 
        fprintf('%d|', D(i, j));
    end
    fprintf('\n');
end

figure; imshow(BW);
end
