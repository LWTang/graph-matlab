img=imread('bin1.jpg');
img = rgb2gray(img);
img=img>128;

[m, n]=size(img);
 
imgn=zeros(m,n);        %�߽���ͼ��
ed=[-1 -1;0 -1;1 -1;1 0;1 1;0 1;-1 1;-1 0]; %�����Ͻ������ж�
for i=2:m-1
    for j=2:n-1
        if img(i,j)==1      %�����ǰ������ǰ������
            
            for k=1:8
                ii=i+ed(k,1);
                jj=j+ed(k,2);
                if img(ii,jj)==0    %��ǰ������Χ����Ǳ������߽���ͼ����Ӧ���ر��
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