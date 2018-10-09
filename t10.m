imgsrc = imread('test.jpg');
imgsrc = rgb2gray(imgsrc);
imgnois = imnoise(imgsrc, 'salt & pepper', 0.03);
[M,N] = size(imgnois);
imgdes = imgnois;
imgout = medfilt2(imgnois);
for i=1:M-2
    for j=1:N-2
        mn = imgnois(i:i+2,j:j+2);
        mn = mn(:);
        mid = median(mn);
        imgdes(i+1,j+1) = mid;
    end
end

subplot(141);
imshow(imgsrc);
title('原图');

subplot(142);
imshow(imgnois);
title('椒盐噪声处理图');

subplot(143);
imshow(imgdes);
title('中值滤波后图像');

subplot(144);
imshow(imgout);
title('medfilt2中值滤波');