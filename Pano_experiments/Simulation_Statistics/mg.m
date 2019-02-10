function [result]=mg(img,x,y)
[H,W]=size(img);
x=ceil(x);
y=ceil(y);
G1=[0,0,0,0,0;      %垂直方向亮度差
    1,3,8,3,1;
    0,0,0,0,0;
    -1,-3,-8,-1,-1;
    0,0,0,0,0];

G2=[0,0,1,0,0;      %主对角线亮度差
    0,8,3,0,0;
    1,3,0,-3,-1;
    0,0,-3,-8,0;
    0,0,-1,0,0];

G3=[0,0,1,0,0;      %副对角线亮度差
    0,0,3,8,0;
    -1,-3,0,3,1;
    0,-8,-3,0,0;
    0,0,-1,0,0];

G4=[0,1,0,-1,0;     %水平方向亮度差
    0,3,0,-3,0;
    0,8,0,-8,0;
    0,3,0,-3,0;
    0,1,0,-1,0];

result=max(abs([Grad(img,G1,x,y),Grad(img,G2,x,y),Grad(img,G3,x,y),Grad(img,G4,x,y)])); 
end



