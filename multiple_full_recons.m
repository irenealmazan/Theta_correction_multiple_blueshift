jitterlevel = [0 10 20 40];
noiselevel = [1e3]

for jjj = 1:numel(jitterlevel)
    
    percent_jitter = jitterlevel(jjj);
    
    for nnn = 1:numel(noiselevel)
      
     mncntrate = noiselevel(nnn);
     
    savefolder = ['jitter_' num2str(jitterlevel) '_noiselevel_' num2str(noiselevel)];
    mkdir(savefolder);     
    
    NW_masterscript_BCDI;
    
    end
end
