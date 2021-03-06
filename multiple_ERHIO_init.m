addpath(genpath('../m_scripts/'));
addpath(genpath('../calc_functions'));



jitterlevel_2 = [5 10];%[0 5 10 20 40];%0 10 20 40];
mncrate_array_2 = [1e3];%[2e2 2e2 1e3];
noiseflag_array_2 = [1];%[0 1 1];
noiselevel_array_2 = [1];%[1 2 3]
%%%% no noise



for mm = 1:numel(mncrate_array_2)
    
    noiseflag = noiseflag_array_2(mm);
    if(noiseflag)
        display('ADDING NOISE')
    else
        display('NO NOISE')
    end
    
    mncntrate = mncrate_array_2(mm);
    
    noiselevel_str = num2str(noiselevel_array_2(mm));
    
    for jjj = 1:numel(jitterlevel_2)
        
        percent = jitterlevel_2(jjj);
       
        load(['jitter_' num2str(percent) '_noiselevel_' noiselevel_str '/ER_HIO_initial_guess']);

        
        min_chi = 1;
        for kk = 1:5
            display(num2str(kk))
            ER_HIO;
           struct_ER_HIO(kk).chi = newobj.chi;     
           struct_ER_HIO(kk).dp = newobj.dp;
            struct_ER_HIO(kk).support_new = support_new;
            
           if min_chi >newobj.chi(end)
               min_kk = kk;
               min_chi = newobj.chi(end);
           end
           
        end
        
        struct_best_ERHIO = struct_ER_HIO(min_kk);
        
        save(['data_ERHIO/struct_ERHIO_ini' noiselevel_str '_jitter_' num2str(percent)],'struct_best_ERHIO','struct_ER_HIO');
        
        
    end
    
end