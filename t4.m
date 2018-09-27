imgsrc1=imread('cameraman.tif');

[M1, N1]=size(imgsrc1);
imgdes=zeros(M1,N1,'uint8');
src1hist=imhist(imgsrc1)/(M1*N1);
imgsrc2=imread('tire.tif');
[M2, N2]=size(imgsrc2);
src2hist=imhist(imgsrc2)/(M2*N2);

Iout=histeq(imgsrc1, imhist(imgsrc2));

% ����ͼ���ۻ�ֱ��ͼ
f1=zeros(1,256);
f1(1,1)=src1hist(1,1);
f2=zeros(1,256);
f2(1,1)=src2hist(1,1);
for i=2:256
    f1(1,i)=f1(1,i-1)+src1hist(i,1);
    f2(1,i)=f2(1,i-1)+src2hist(i,1);
end 

% index(i)�洢��Դͼ����ֵΪiռ����ӽ��ı�׼ͼ�е�����ֵ
for i=1:256
    value{i}=abs(f2-f1(1,i));
    [temp index(i)]=min(value{i});
end

for i=1:M1
    for j=1:N1
        imgdes(i,j)=index(imgsrc1(i,j)+1)-1;
    end
end

subplot(241);
imshow(imgsrc1);
title('ԭͼ');

subplot(242);
imshow(imgsrc2);
title('��׼ͼ');

subplot(243);
imshow(imgdes);
title('���ͼ');

subplot(244);
imshow(Iout);
title('histeq���ͼ');

subplot(245);
imhist(imgsrc1);
title('ԭͼ');

subplot(246);
imhist(imgsrc2);
title('��׼ͼ');

subplot(247);
imhist(imgdes);
title('���ͼ');

subplot(248);
imhist(Iout);
title('histeq���ͼ');