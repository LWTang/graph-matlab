imgsrc=imread('tire.tif');
imgdes=double(imgsrc);
imgdes=uint8(40*(log(imgdes+1)));

subplot(131);
imshow(imgsrc);
title('源图像');

x=1:255;
y=(40*(log(x+1)));
subplot(132);
plot(x,y);
title('函数曲线图');

subplot(133);
imshow(imgdes);
title('对数变换后图像');