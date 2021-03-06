### t1.图像放大缩小
> M * N 的灰度图I变成 P * Q 的图像J，要求使用双线性插值。

* <a href="https://github.com/LWTang/graph-matlab/blob/master/t1.m">src code</a>
* 算法
```
初始化 图像J的像素值为0
读取 图像I
for ( i=0; i<P; i++ ) {
  获取访问图像I像素值的指针p
  获取访问图像J第i行的指针des
  for ( j=0; j<Q; j++ ) {
    计算图像J每个像素点在I上映射的double类型坐标: J_x=M/P * i, J_y=N/Q *j
    计算在I上映射的int类型坐标: J_x1=M/P * i, J_y1=N/Q *j
    通过4个坐标点计算水平方向的线性插值:
      Q11=(J_x-J_x1)*(p[J_x1, J_y1+1]-p[J_x1, J_y1]) + p[J_x1, J_y1]
      Q22=(J_x-J_x1)*(p[J_x1+1, J_y1+1]-p[J_x1+1, J_y1]) + p[J_x1+1, J_y1]
    计算垂直方向的线性插值,即为图像J最终的像素值:
      des[j]=(J_y-J_y1)*(Q22-Q11) + Q11
  }
}

```

### t2.图像旋转
> M * N 的灰度图I逆时针旋转 A 度得到图像J，要求使用近邻插值。

* <a href="https://github.com/LWTang/graph-matlab/blob/master/t2.m">src code</a>
* 算法
参考：<a href="https://blog.csdn.net/liyuan02/article/details/6750828">原理</a>和<a href="https://blog.csdn.net/lkj345/article/details/50555870">实现</a>

图像旋转3步：
1. 图像坐标转换为数学坐标
2. 通过旋转公式对图像进行旋转
3. 将旋转后的数学坐标转换为图像坐标
```
初始化 图像J的像素值为0
读取 图像I
计算J的高和宽：
  P=ceil(abs(M*cos(A)) + abs(N*sin(A)))
  Q=ceil(abs(N*cos(A)) + abs(M*sin(A)))
计算坐标变换的矩阵：
  rm1=[1 0 0; 0 -1 0; -0.5*Q 0.5*P 1]
  rm2=[cos(A) -sin(A) 0; sin(A) cos(A) 0; 0 0 1]
  rm3=[1 0 0; 0 -1 0; 0.5*N 0.5*M 1]
  for i=1:P
    for j=1:Q
      计算J上每个像素对应在I上的像素值：
        src_coordinate=[j i 1]*rm1*rm2*rm3
        row=round(src_coordinate(2))
        col=round(src_coordinate(1))
        if row<1 || col<1 || row>M || col>N
            imgdes(i,j)=0;
        else
            imgdes(i,j)=imgsrc(row,col);
```

### t3.直方图均衡化
> M * N 的灰度图I中灰度为g的像素数为h(g)，对I进行直方图均衡化得到J。

* <a href="https://github.com/LWTang/graph-matlab/blob/master/t3.m">src code</a>
* 算法
```
读取 图像I M * N
初始化 图像J的像素值为0
统计每个像素值的个数：
  for i=1:M
    for j=1:N
        cnt(1,I(i, j)+1)=cnt(1,I(i, j)+1)+1
计算每个像素值的概率：
  f=zeros(1,256)
  for i=1:256
    f(1, i) = cnt(1, i)/(M * N)
求累积概率：
  for i=2:256
    f(1, i) = f(1, i-1)+f(1, i)
实现像素值的均匀分布：
  for i=1:256
    f(1, i) = f(1, i)*255
赋给J：
  for i=1:M
    for j=1:N
        desimg(i, j)=f(1, imgsrc(i,j)+1)
```

### t4.直方图规定化
> M * N 的灰度图I中灰度为g的像素数为h(g)，另给定一个直方图t(g)，对I进行变换，使变换后的直方图与t相同(近似相等)。

* <a href="https://github.com/LWTang/graph-matlab/blob/master/t4.m">src code</a>
* 算法
```
读取 图像I M1 * N1 图像T M2 * N2
初始化 图像J的像素值为0
两个图像的直方图：
  src1hist=imhist(I)/(M1*N1);
  src2hist=imhist(T)/(M2*N2);
两个累积直方图：
  f1=zeros(1,256)
  f1(1,1)=src1hist(1,1)
  f2=zeros(1,256)
  f2(1,1)=src2hist(1,1)
  for i=2:256
    f1(1,i)=f1(1,i-1)+src1hist(i,1)
    f2(1,i)=f2(1,i-1)+src2hist(i,1)
求与I各像素值分布最接近的T的像素值：
  for i=1:256
    value{i}=abs(f2-f1(1,i))
    [temp index(i)]=min(value{i})
赋给J：
  for i=1:M1
    for j=1:N1
        imgdes(i,j)=index(imgsrc1(i,j)+1)-1
```

### t5.图像灰度的对数/指数变换
> 图像I整体偏暗，为了更好的区分暗区中的对象，应选用对数变换还是指数变换，给出变换方法。

* <a href="https://github.com/LWTang/graph-matlab/blob/master/t5.m">src code</a>
* 算法
应该使用对数变换，扩展低灰度区，使暗区对比度更高，容易区分
```
读取 图像I
J=double(I)
J=uint8(40*(log(J+1)))
```

### t6.图像灰度的分段线性拉伸
<ol>
  <li>对灰度图I，给出灰度分段线性变换方法，使J中5%的像素灰度变为0，5%的像素灰度变为255</li>
  <li>设计一个连续且光滑的灰度变换曲线</li>
  <li>matlab 中 adapthisteq 的实现原理是什么</li>
</ol>

* <a href="https://github.com/LWTang/graph-matlab/blob/master/t6.m">src code</a>
* 算法
直接把像素值0-12置0,243-255置255，直接作出分段函数，根据像素值产生新的映射。
```
读取图像imgsrc M * N
for i=1:M
    for j=1:N
        if(imgsrc(i,j)<12)
            imgdes(i,j) = 0
        elseif(imgsrc(i,j)<243)
            imgdes(i,j) = round((imgsrc(i,j)-12)*(256/230))
        else
            imgdes(i,j) = 255
```

### t7.边界跟踪
> 找出二值图像I的边界。

* <a href="https://github.com/LWTang/graph-matlab/blob/master/t19.m">src code</a>
* 算法
```
构造一个顺时针的8邻域矩阵；
遍历图像：
  如果当前像素像素值为1，则将8邻域的像素值为0的点像素值改为1；
```

### t8.canny算子matlab实现
> 实现canny算子的边缘检测。

* <a href="https://github.com/LWTang/graph-matlab/blob/master/t17.m">src code</a>
* 算法
```
用高斯滤波器平滑图像；
用一阶偏导的有限差分进行计算梯度的幅值和方向：
对梯度幅值在其梯度方向上进行非极大值抑制；
用双阈值算法检测和连接边缘；
```

### t9.基于傅里叶变换的频域低通滤波
> 基于傅里叶变换的频域低通滤波。

* <a href="https://github.com/LWTang/graph-matlab/blob/master/t14.m">src code</a>
* 算法
```
对有噪声的图像进行傅里叶变换，得到频谱；
对得到的频谱进行理想低通滤波(采用理想低通滤波器)：
对滤波后的频谱进行反傅里叶变换，得到结果图像；
```

### t10.中值滤波
> 使用大小为3×3的模板对图像I进行中值滤波，得到图像J。

* <a href="https://github.com/LWTang/graph-matlab/blob/master/t10.m">src code</a>
* 算法
此处实现的算法对图像边缘一圈的像素没做处理。
```
读取 图像I
对I加椒盐噪声后的图像为imgnois
用imgnois初始化J
for i=1:M-2
    for j=1:N-2
        mn = imgnois(i:i+2,j:j+2)
        mn = mn(:)
        mid = median(mn)
        J(i+1,j+1) = mid
```

### t11.中值滤波的特性
<ol>
  <li>中值滤波的特性和适用场合</li>
  <li>设计一个能保持图像中细小尺寸的边缘（如线状目标）的滤波方法</li>
</ol>

* 特性：使用一个滑动窗口来把窗口内的像素值排序，取排序中间的值作为像素点的值，有效得去除与周围像素值相差过大的像素值。
* 适用场合：对于消除随机噪声很有用，同时保护边缘少受模糊。

### t12.统计排序滤波
<ol>
  <li>最大值滤波的实现方法？产生什么效果？</li>
  <li>最小值滤波的实现方法？产生什么效果？</li>
</ol>

* 在3 * 3的滤波器里找到像素值最大的值赋给中心像素，matlab实现：ordfilt2(imgsrc, 9, ones(3,3))
* 在3 * 3的滤波器里找到像素值最小的值赋给中心像素，matlab实现：ordfilt2(imgsrc, 1, ones(3,3))