imgsrc=imread('tire.tif');

%imgsrc=rgb2gray(imgsrc);
subplot(1,2,1);
imshow(imgsrc);
title('source image');

[M, N]=size(imgsrc);
desimg=zeros(M,N,'uint8');
cnt=zeros(1, 256);
% 统计每个像素值的个数
for i=1:M
    for j=1:N
        cnt(1,imgsrc(i, j)+1)=cnt(1,imgsrc(i, j)+1)+1;
    end
end

f=zeros(1,256);
for i=1:256
    f(1, i) = cnt(1, i)/(M*N);
end

% 求累积概率，得累积直方图
for i=2:256
    f(1, i) = f(1, i-1)+f(1, i);
end

% 实现[0 255]的映射
for i=1:256
    f(1, i) = f(1, i)*255;
end

for i=1:M
    for j=1:N
        desimg(i, j)=f(1, imgsrc(i,j)+1);
    end
end

subplot(1,2,2);
imshow(desimg);
title('destination image');

