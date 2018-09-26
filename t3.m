imgsrc=imread('tire.tif');

%imgsrc=rgb2gray(imgsrc);
subplot(1,2,1);
imshow(imgsrc);
title('source image');

[M, N]=size(imgsrc);
desimg=zeros(M,N,'uint8');
cnt=zeros(1, 256);
% ͳ��ÿ������ֵ�ĸ���
for i=1:M
    for j=1:N
        cnt(1,imgsrc(i, j)+1)=cnt(1,imgsrc(i, j)+1)+1;
    end
end

f=zeros(1,256);
for i=1:256
    f(1, i) = cnt(1, i)/(M*N);
end

% ���ۻ����ʣ����ۻ�ֱ��ͼ
for i=2:256
    f(1, i) = f(1, i-1)+f(1, i);
end

% ʵ��[0 255]��ӳ��
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

