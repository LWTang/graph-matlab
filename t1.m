imgsrc=imread('test.jpg');
imgsrc=rgb2gray(imgsrc);
%imshow(imgsrc);
[M,N]=size(imgsrc);
P=140;Q=240;
imgdes=zeros(P,Q,'uint8');
sx=Q/N;sy=P/M;
for i=1:P
    for j=1:Q
        x1=j/sx;
        y1=i/sy;
        xf=floor(x1);xc=ceil(x1);
        if(xf<1)
            xf=1;
        end
        yf=floor(y1);yc=ceil(y1);
        if(yf<1)
            yf=1;
        end
        Q11=(imgsrc(xc,yf)-imgsrc(xf,yf))*(x1-xf)+imgsrc(xf,yf);
        Q22=(imgsrc(xc,yc)-imgsrc(xf,yc))*(x1-xf)+imgsrc(xf,yc);
        imgdes(i,j)=(Q22-Q11)*(y1-yf)+Q11;
    end
end
imshow(imgdes);
        