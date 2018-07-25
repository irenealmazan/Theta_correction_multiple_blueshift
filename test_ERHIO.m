% this scripts tests the reproducibilisty of the ERHIO results.


figure(90);
clf;
plot(log10(newobj.chi),'LineWidth',3.0);
hold on;

for kk = 1:5
   ER_HIO;
   ER_HIOstruct(kk).chi = newobj.chi ;
   ER_HIOstruct(kk).dp = newobj.dp;
   
   plot(log10(newobj.chi),'LineWidth',3.0);
end


figure(4);

numtot = kk-1;


subplot(2,numtot+1,1);
imagesc(abs(rho_3DFT(:,:,65)));
axis image;
colorbar;

subplot(2,numtot+1,numtot+1+1);
imagesc(angle(rho_3DFT(:,:,65)));
axis image;
colorbar;


for jj = 2:numtot+1
    object_loop = ifftn(ER_HIOstruct(jj-1).dp);
   subplot(2,numtot+1,jj);
   imagesc(abs(object_loop(:,:,65)));
   axis image;
   colorbar;
   
    subplot(2,numtot+1,numtot+1+jj);
   imagesc(angle(object_loop(:,:,65)));
   axis image;
   colorbar;
   
end