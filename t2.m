imgsrc=imread('test.jpg');
imgsrc=rgb2gray(imgsrc);
[M, N]=size(imgsrc);
A=pi/2;
P=ceil(abs(M*cos(A)) + abs(N*sin(A)));
Q=ceil(abs(N*cos(A)) + abs(M*sin(A)));
imgdes=zeros(P,Q,'uint8');
rm1=[1 0 0; 0 -1 0; -0.5*Q 0.5*P 1];
rm2=[cos(A) -sin(A) 0; sin(A) cos(A) 0; 0 0 1];
rm3=[1 0 0; 0 -1 0; 0.5*N 0.5*M 1];

for i=1:P
    for j=1:Q
        src_coordinate=[j i 1]*rm1*rm2*rm3;
        row=round(src_coordinate(2));
        col=round(src_coordinate(1));
        if row<1 || col<1 || row>M || col>N
            imgdes(i,j)=0;
        else
            imgdes(i,j)=imgsrc(row,col);
        end
    end
end
imshow(imgdes);
        
        
