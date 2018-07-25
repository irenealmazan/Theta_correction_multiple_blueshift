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