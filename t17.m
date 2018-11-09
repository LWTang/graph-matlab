srcimg1 = imread('tire.tif');

srcimg2 = double(srcimg1);

[Ay, Ax] = size(srcimg1);
m = zeros(Ay, Ax); 
theta = zeros(Ay, Ax);
sector = zeros(Ay, Ax);
canny1 = zeros(Ay, Ax);%非极大值抑制
canny2 = zeros(Ay, Ax);%双阈值检测和连接
bin = zeros(Ay, Ax);

ed = edge(srcimg1, 'canny', 0.5);

gausFilter = fspecial('gaussian', [3,3], 1);
srcimg= imfilter(srcimg2, gausFilter, 'replicate');



for y = 1:(Ay-1)
    for x = 1:(Ax-1)
        gx =  srcimg(y, x) + srcimg(y+1, x) - srcimg(y, x+1)  - srcimg(y+1, x+1);
        gy = -srcimg(y, x) + srcimg(y+1, x) - srcimg(y, x+1) + srcimg(y+1, x+1);
        m(y,x) = (gx^2+gy^2)^0.5 ;

        theta(y,x) = atand(gx/gy)  ;
        tem = theta(y,x);

        if (tem<67.5)&&(tem>22.5)
            sector(y,x) =  0;    
        elseif (tem<22.5)&&(tem>-22.5)
            sector(y,x) =  3;    
        elseif (tem<-22.5)&&(tem>-67.5)
            sector(y,x) =   2;    
        else
            sector(y,x) =   1;    
        end       
    end    
end

for y = 2:(Ay-1)
    for x = 2:(Ax-1)        
        if 0 == sector(y,x) %右上 - 左下
            if ( m(y,x)>m(y-1,x+1) )&&( m(y,x)>m(y+1,x-1)  )
                canny1(y,x) = m(y,x);
            else
                canny1(y,x) = 0;
            end
        elseif 1 == sector(y,x) %竖直方向
            if ( m(y,x)>m(y-1,x) )&&( m(y,x)>m(y+1,x)  )
                canny1(y,x) = m(y,x);
            else
                canny1(y,x) = 0;
            end
        elseif 2 == sector(y,x) %左上 - 右下
            if ( m(y,x)>m(y-1,x-1) )&&( m(y,x)>m(y+1,x+1)  )
                canny1(y,x) = m(y,x);
            else
                canny1(y,x) = 0;
            end
        elseif 3 == sector(y,x) %横方向
            if ( m(y,x)>m(y,x+1) )&&( m(y,x)>m(y,x-1)  )
                canny1(y,x) = m(y,x);
            else
                canny1(y,x) = 0;
            end
        end        
    end
end

ratio = 3;
lowTh = 20;%低阈值
for y = 2:(Ay-1)
    for x = 2:(Ax-1)        
        if canny1(y,x)<lowTh %低阈值处理
            canny2(y,x) = 0;
            bin(y,x) = 0;
            continue;
        elseif canny1(y,x)>ratio*lowTh %高阈值处理
            canny2(y,x) = canny1(y,x);
            bin(y,x) = 1;
            continue;
        else %介于之间的看其8领域有没有高于高阈值的，有则可以为边缘
            tem =[canny1(y-1,x-1), canny1(y-1,x), canny1(y-1,x+1);
                       canny1(y,x-1),    canny1(y,x),   canny1(y,x+1);
                       canny1(y+1,x-1), canny1(y+1,x), canny1(y+1,x+1)];
            temMax = max(tem);
            if temMax(1) > ratio*lowTh
                canny2(y,x) = temMax(1);
                bin(y,x) = 1;
                continue;
            else
                canny2(y,x) = 0;
                bin(y,x) = 0;
                continue;
            end
        end
    end
end

subplot(1,3,1);
imshow(srcimg1);
title('source image');

subplot(1,3,3);
imshow(ed);
title('edge function');

subplot(1,3,2);
imshow(bin);
title('destination image');

