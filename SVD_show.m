close all;clear all;clc;
I=imread("C:\Users\Sun\Pictures\微信图片_20210509163246.jpg");
imshow(I);
I1=im2double(I(:,:,1));I2=im2double(I(:,:,2));I3=im2double(I(:,:,3));
I1m=(mean(I1(:)));I2m=mean(I2(:));I3m=mean(I3(:));
I1=I1-I1m;I2=I2-I2m;I3=I3-I3m;
%viewRange = [(1.25*minI - 0.25*maxI), (1.25*maxI - 0.25*minI)];

[U1,S1,V1]=svd(I1);
[U2,S2,V2]=svd(I2);
[U3,S3,V3]=svd(I3);
N = size(I1);
newIm1 = zeros(size(I1))*I1m;
newIm2 = zeros(size(I2))*I2m;
newIm3 = zeros(size(I3))*I3m;
nWaves = 1;
demoSpeed=1000;
figure
n=1;
set(gcf,'unit','normalized','position',[0,0,1,1]);
set(gcf,'color','white');

out = VideoWriter('SVD_photo.avi');
FrameRate=10;
out.FrameRate=FrameRate;
open(out);


while n <  min(size(S1))
    if n > 20;  nWaves = 5 ; end
    if n > 100; nWaves = 50; end

    
        S1_tmp=zeros(size(S1));
        S2_tmp=zeros(size(S2));
    S3_tmp=zeros(size(S3));

     for p = 1:nWaves;
    S1_tmp(n+p-1,n+p-1)=S1(n+p-1,n+p-1);
        S2_tmp(n+p-1,n+p-1)=S2(n+p-1,n+p-1);
    S3_tmp(n+p-1,n+p-1)=S3(n+p-1,n+p-1);
     end
    I1_cur=U1*S1_tmp*V1';
     I2_cur=U2*S2_tmp*V2';
      I3_cur=U3*S3_tmp*V3';
      
        canvas1 = cat(2, real(I1 - newIm1 - I1_cur), zeros(size(I1)), newIm1);
                canvas2 = cat(2, real(I2 - newIm2 - I2_cur), zeros(size(I2)), newIm2);
                canvas3 = cat(2, real(I3 - newIm3 - I3_cur), zeros(size(I3)), newIm3);

canvasShow1=canvas1;
canvasShow2=canvas2;
canvasShow3=canvas3;
    canvasShow1(:,1:N(2)) = canvasShow1(:,1:N(2)) + I1_cur;
        canvasShow2(:,1:N(2)) = canvasShow2(:,1:N(2)) + I2_cur;
    canvasShow3(:,1:N(2)) = canvasShow3(:,1:N(2)) + I3_cur;
final_show=zeros(N(1),3*N(2),3);

    for L = [(min(max(1, round((1 + sin(linspace(-pi/2, pi/2, 100/min(20, n))))/2*N(2))), N(2)+1))   (N(2)+1)]
        canvasShow1 = canvas1;        
        canvasShow2 = canvas2;
        canvasShow3 = canvas3;
        
        canvasShow1(:,L:(L+(N(2)-1))) = canvasShow1(:,L:(L+(N(2)-1))) + I1_cur;
                canvasShow2(:,L:(L+(N(2)-1))) = canvasShow2(:,L:(L+(N(2)-1))) + I2_cur;
        canvasShow3(:,L:(L+(N(2)-1))) = canvasShow3(:,L:(L+(N(2)-1))) + I3_cur;
        final_show(:,:,1)=canvasShow1;
                final_show(:,:,2)=canvasShow2;
        final_show(:,:,3)=canvasShow3;
        
  
        imagesc(canvasShow1);  axis equal tight; colormap gray;
        set(gca,'ytick',[],'yticklabel',[])
set(gca,'xtick',[],'xticklabel',[])
box off
 title([ 'n = ' num2str(n) ' to '  num2str(n+nWaves-1)])

                 F=getframe(gcf);
%  
     writeVideo(out, F);
    end
    
    for L = N(2) + [(min(max(1, round((1 + sin(linspace(-pi/2, pi/2, 100/min(20, n))))/2*N(2))), N(2)+1))   (N(2)+1)]
        canvasShow1 = canvas1;
                canvasShow2 = canvas2;
        canvasShow3 = canvas3;

        canvasShow1(:,L:(L+(N(2)-1))) = canvasShow1(:,L:(L+(N(2)-1))) + I1_cur;
                canvasShow2(:,L:(L+(N(2)-1))) = canvasShow2(:,L:(L+(N(2)-1))) + I2_cur;
        canvasShow3(:,L:(L+(N(2)-1))) = canvasShow3(:,L:(L+(N(2)-1))) + I3_cur;
       final_show(:,:,1)=canvasShow1;
                final_show(:,:,2)=canvasShow2;
        final_show(:,:,3)=canvasShow3;

        imagesc(canvasShow1);  axis equal tight; colormap gray;
set(gca,'ytick',[],'yticklabel',[])
set(gca,'xtick',[],'xticklabel',[])
box off
 title([ 'n = ' num2str(n) ' to '  num2str(n+nWaves-1)])
                 F=getframe(gcf);
%  
     writeVideo(out, F);
    end
    newIm1 = newIm1 + I1_cur;
        newIm2 = newIm2 + I2_cur;
    newIm3 = newIm3 + I3_cur;
n=n+nWaves;
end
    
    
         close(out)

    
%I=I(:,:,1);