function ofpp= justfpp(energy,referg,zed)% ofpp= justfpp(energy,referg,ized)% function used by quad8 routine in kramkron.m% energy is where the function is evaluated% referg is the energy where fp is being calculated% SMB 27-Jun-00 bren@slac.stanford.edu[fp,fpp]=anomal(zed,energy);ofpp= energy.*fpp./(referg^2-energy.^2);