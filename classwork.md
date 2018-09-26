### 图像放大缩小
> M * N 的灰度图I变成 P * Q 的图像J，要求使用双线性插值。

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

### 图像旋转
> M * N 的灰度图I逆时针旋转 A 度得到图像J，要求使用近邻插值。

* 算法
参考：<a href="https://blog.csdn.net/liyuan02/article/details/6750828">原理</a>和<a href="https://blog.csdn.net/lkj345/article/details/50555870">实现</a>
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

### 直方图均衡化
> M * N 的灰度图I中灰度为g的像素数为h(g)，对I进行直方图均衡化得到J。

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

### 直方图规定化
> M * N 的灰度图I中灰度为g的像素数为h(g)，另给定一个直方图t(g)，对I进行变换，使变换后的直方图与t相同(近似相等)。

* 算法