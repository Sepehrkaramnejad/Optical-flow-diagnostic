clc
clear all
close all
%% Inputs & defining parameters
FrameDiff=18;   %difference between two pictures
IW=20;  %interrogation window size
SW=100; %search window size
Filter=1; %1:if you wnat to filtration , 0: if you do not want filtration
n=2;  %number of filtration iteration
dev=0.5;  %deviation between mean velocity and absolute velocity
%% defining ratios
TimeDiff=FrameDiff*0.033;
Ratio=round(SW/IW);
Difference=ceil((SW-IW)/2);
Average=round((SW+IW)/2);
%% Importing picture datas
Pic1=imread('DSC_4038129.jpg');
Pic2=imread('DSC_4038225.jpg');
%% Converting colorful picture to gray picture (rgb2gray)
Pic1=(Pic1(:,:,1)+Pic1(:,:,2)+Pic1(:,:,3))/3;
Pic2=(Pic2(:,:,1)+Pic2(:,:,2)+Pic2(:,:,3))/3;
%or we can use rgb2gray syntax
%Pic1=rgb2gray(DSC_4038129.jpg)
%Pic2=rgb2gray(DSC_4038129.jpg)
%% rounding pictures to have integer interrogation size
Pic1size=size(Pic1);
Pic2size=size(Pic2);
Pic1width=IW*floor(Pic1size(2)/IW);
Pic2width=IW*floor(Pic2size(2)/IW);
Pic1height=IW*floor(Pic1size(1)/IW);
Pic2height=IW*floor(Pic2size(1)/IW);
Pic1=Pic1(1:Pic1height,1:Pic1width);
Pic2=Pic2(1:Pic2height,1:Pic2width);
%% defining grid of first picture which are interrogation windows
Height=floor(Pic1size(1)/IW);
Width=floor(Pic1size(2)/IW);
Reference=cell(Height,Width);
for i=1:Height
    for j=1:Width
        Reference{i,j}=Pic1((i-1)*IW+1:i*IW,(j-1)*IW+1:j*IW);
    end
end
X2=zeros(Height-Ratio,Width-Ratio);
Y2=zeros(Height-Ratio,Width-Ratio);
%NumberOfIntWins=(Height-2*Ratio)*(Width-2*Ratio)
pause(1)
IntWinNo=0;
E=0;
%% Correlation Process
for i=Ratio+1:Height-Ratio
    for j=Ratio+1:Width-Ratio
        f=Reference{i,j}; 
        g=Pic2((i-1)*IW-Difference+1:i*IW+Difference,(j-1)*IW-Difference+1:j*IW+Difference);
        R=normxcorr2(f,g);
        [rmax1 j1]=sort(max(R));
        Rt=R';
        [rmax2 i1]=sort(max(Rt));
        rmax1=fliplr(rmax1);rmax1=rmax1(1);
        h(i,j)=rmax1;
        if h(i,j)<0.5
            E=E+1;
        end
        j1=fliplr(j1);
        j1=j1(1);
        i1=fliplr(i1);
        i1=i1(1);
        X2(i,j)=j1;
        Y2(i,j)=-i1;
        IntWinNo=IntWinNo+1;
    end
end  
%Subtraction of Constant Values from Velocity Components
X2=X2(Ratio+1:Height-Ratio,Ratio+1:Width-Ratio)-Average;
Y2=Y2(Ratio+1:Height-Ratio,Ratio+1:Width-Ratio)+Average;
%% Classification of Filtering
if Filter==0    
elseif Filter==1
    Itter=0;
while Itter<=n
vsize=size(X2);
width=vsize(2);
height=vsize(1);
i=1;
     j=1;
        AveU=(X2(i+1,j)+X2(i,j+1))/2;
        DevU=abs((X2(i,j)-AveU)/AveU)*100;
        AveV=(Y2(i+1,j)+Y2(i,j+1))/2;
        DevV=abs((Y2(i,j)-AveV)/AveV)*100;
        if DevU>dev
            X2(i,j)=AveU;
        end
        if DevV>dev
            Y2(i,j)=AveV;
        end

     j=width;
        AveU=(X2(i+1,j)+X2(i,j-1))/2;
        DevU=abs((X2(i,j)-AveU)/AveU)*100;
        AveV=(Y2(i+1,j)+Y2(i,j-1))/2;
        DevV=abs((Y2(i,j)-AveV)/AveV)*100;
        if DevU>dev
            X2(i,j)=AveU;
        end
        if DevV>dev
            Y2(i,j)=AveV;
        end
 i=height;
     j=1;
        AveU=(X2(i-1,j)+X2(i,j+1))/2;
        DevU=abs((X2(i,j)-AveU)/AveU)*100;
        AveV=(Y2(i-1,j)+Y2(i,j+1))/2;
        DevV=abs((Y2(i,j)-AveV)/AveV)*100;
        if DevU>dev
            X2(i,j)=AveU;
        end
        if DevV>dev
            Y2(i,j)=AveV;
        end
     j=width;
        AveU=(X2(i-1,j)+X2(i,j-1))/2;
        DevU=abs((X2(i,j)-AveU)/AveU)*100;
        AveV=(Y2(i-1,j)+Y2(i,j-1))/2;
        DevV=abs((Y2(i,j)-AveV)/AveV)*100;
        if DevU>dev
            X2(i,j)=AveU;
        end
        if DevV>dev
            Y2(i,j)=AveV;
        end
 
for i=2:height-1
     j=1;
        AveU=(X2(i-1,j)+X2(i+1,j)+X2(i,j+1))/3;
        DevU=abs((X2(i,j)-AveU)/AveU)*100;
        AveV=(Y2(i-1,j)+Y2(i+1,j)+Y2(i,j+1))/3;
        DevV=abs((Y2(i,j)-AveV)/AveV)*100;
        if DevU>dev
            X2(i,j)=AveU;
        end
        if DevV>dev
            Y2(i,j)=AveV;
        end
     j=width;
        AveU=(X2(i-1,j)+X2(i+1,j)+X2(i,j-1))/3;
        DevU=abs((X2(i,j)-AveU)/AveU)*100;
        AveV=(Y2(i-1,j)+Y2(i+1,j)+Y2(i,j-1))/3;
        DevV=abs((Y2(i,j)-AveV)/AveV)*100;
        if DevU>dev
            X2(i,j)=AveU;
        end
        if DevV>dev
            Y2(i,j)=AveV;
        end
end
 i=1;
    for j=2:width-1
        AveU=(X2(i+1,j)+X2(i,j-1)+X2(i,j+1))/3;
        DevU=abs((X2(i,j)-AveU)/AveU)*100;
        AveV=(Y2(i+1,j)+Y2(i,j-1)+Y2(i,j+1))/3;
        DevV=abs((Y2(i,j)-AveV)/AveV)*100;
        if DevU>dev
            X2(i,j)=AveU;
        end
        if DevV>dev
            Y2(i,j)=AveV;
        end
    end
 i=height;
    for j=2:width-1
        AveU=(X2(i-1,j)+X2(i,j-1)+X2(i,j+1))/3;
        DevU=abs((X2(i,j)-AveU)/AveU)*100;
        AveV=(Y2(i-1,j)+Y2(i,j-1)+Y2(i,j+1))/3;
        DevV=abs((Y2(i,j)-AveV)/AveV)*100;
        if DevU>dev
            X2(i,j)=AveU;
        end
        if DevV>dev
            Y2(i,j)=AveV;
        end
    end
for i=2:height-1
    for j=2:width-1
        AveU=(X2(i-1,j)+X2(i+1,j)+X2(i,j-1)+X2(i,j+1))/4;
        DevU=abs((X2(i,j)-AveU)/AveU)*100;
        AveV=(Y2(i-1,j)+Y2(i+1,j)+Y2(i,j-1)+Y2(i,j+1))/4;
        DevV=abs((Y2(i,j)-AveV)/AveV)*100;
        if DevU>dev
            X2(i,j)=AveU;
        end
        if DevV>dev
            Y2(i,j)=AveV;
        end
    end
end
Itter=Itter+1;
end
end
%% Plotting Outputs: Velocity Field
Vsize=size(X2);
Width=Vsize(2);
Height=Vsize(1);
x=linspace(0,IW*Width,Width+1);
y=linspace(0,IW*Height,Height+1);
for i=1:Height
    for j=1:Width
        X1(i,j)=x(j)+IW/2;
        Y1(i,j)=y(i)+IW/2;
    end
end
X1=X1;
Y1=Y1;
X2=X2;
Y2=Y2;
quiver(X1,Y1,X2,Y2)
title(' Velocity Field ')
xlabel(' X-Direction (pixel)')
ylabel(' Y-Direction (pixel)')
legend ('Velocity vector')
axis equal