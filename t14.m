img = imread('test.jpg');
img = rgb2gray(img);
imgsrc = imnoise(img, 'salt');
[m,n] = size(imgsrc);
imgdes = zeros(m,n);
m_mid = fix(m/2);
n_mid = fix(n/2);

img_f=fftshift(fft2(double(imgsrc)));%����Ҷ�任
for i=1:m
    for j=1:n
        d = sqrt((i-m_mid)^2 + (j-n_mid)^2);%�����ͨ�˲�
        if d<40
            h(i,j) = 1;
        else
            h(i,j) = 0;
        end
        imgdes(i,j) = h(i,j)*img_f(i,j);
    end
end
imgdes = ifftshift(imgdes);
imgdes = uint8(real(ifft2(imgdes)));%ȡʵ��

subplot(1,2,1);
imshow(imgsrc);
title('source image');

subplot(1,2,2);
imshow(imgdes);
title('destination image');


