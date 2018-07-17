jitterlevel = [0 5]% 10 20 40];

for jjj = 1:numel(jitterlevel)
    
    percent = jitterlevel(jjj);
      
     mncntrate = 1e3;
     
     noiseflag = 0;
     if(noiseflag)
         display('ADDING NOISE')
     else
         display('NO NOISE')
     end
     
    savefolder = ['jitter_' num2str(jitterlevel) '_noiselevel_0'];
    mkdir(savefolder);     
    
    NW_masterscript_BCDI;
    
    save([savefolder '/results.mat']);
    
end
