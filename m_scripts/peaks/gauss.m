function f=gauss(x,lam);% f= gauss(x,lam)% lam(1)= X0% lam(2)= Amplitude% lam(3)= sigma% Calcuate single gaussian peak% 5-3-97 SMB (Bren@SLAC.stanford.edu)f= lam(2)* exp(-0.5*((x-lam(1))/lam(3)).^2);