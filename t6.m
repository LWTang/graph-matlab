imgsrc = imread('tire.tif');
[M,N] = size(imgsrc);
imgdes = zeros(M,N,'uint8');

for i=1:M
    for j=1:N
        if(imgsrc(i,j)<12)
            imgdes(i,j) = 0;
        elseif(imgsrc(i,j)<243)
            imgdes(i,j) = round((imgsrc(i,j)-12)*(256/230));
        else
            imgdes(i,j) = 255;
        end
    end
end

subplot(221);
imshow(imgsrc);
title('source image');

subplot(222);
imshow(imgdes);
title('target image');

subplot(223);
imhist(imgsrc);
title('source image');

subplot(224);
imhist(imgdes);
title('target image');