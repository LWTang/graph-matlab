img=imread('bin1.jpg');
img = rgb2gray(img);
img=img>128;

[m, n]=size(img);
 
imgn=zeros(m,n);        %边界标记图像
ed=[-1 -1;0 -1;1 -1;1 0;1 1;0 1;-1 1;-1 0]; %从左上角像素判断
for i=2:m-1
    for j=2:n-1
        if img(i,j)==1      %如果当前像素是前景像素
            
            for k=1:8
                ii=i+ed(k,1);
                jj=j+ed(k,2);
                if img(ii,jj)==0    %当前像素周围如果是背景，边界标记图像相应像素标记
                    imgn(ii,jj)=1;
                end
            end
        end
    end
end
    
subplot(1,2,1);
imshow(img);
title('source image');

subplot(1,2,2);
imshow(imgn,[]);
title('destination image');