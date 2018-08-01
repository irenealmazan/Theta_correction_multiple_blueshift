% this script shows the results

addpath(genpath('./m_scripts/'));
addpath(genpath('./calc_functions'));


jitterlevel = [0 5 10];
mncrate_array = [1e3];
noiseflag_array = [1 ];
noiselevel_array = [1];
%%%% no noise


NW_flags;

for mm = 1:numel(mncrate_array)
    
    noiseflag = noiseflag_array(mm);
    
    mncntrate = mncrate_array(mm);
    
    noiselevel_str = num2str(noiselevel_array(mm));
    
    for jjj = 1:numel(jitterlevel)
        
        percent = jitterlevel(jjj);
        
        savefolder = ['jitter_' num2str(jitterlevel(jjj)) '_noiselevel_' noiselevel_str '_70angles'];
        mkdir(savefolder);
        
        load(['jitter_' num2str(percent) '_noiselevel_' noiselevel_str '/ER_HIO_initial_guess']);
        
        load(['data_ERHIO/struct_ERHIO_ini' noiselevel_str '_jitter_' num2str(percent)]);
        
        support_new = struct_best_ERHIO.support_new;
        newobj.dp = struct_best_ERHIO.dp;
        newobj.chi = struct_best_ERHIO.chi;
        
        
        [Niter_rho, Niter_pos,...
            Niter_theta,freq_pos,freq_store,freq_restart,freq_shrink_wrap,tau_backtrack_rho,beta_ini_rho,...
            counter_max_rho,tau_backtrack_theta,beta_ini_theta,counter_max_theta] = ...
            InitializeFunctions.NW_experimental_phretrieval_parameters();
        
        
        %% Scattering condition:
        [pixsize,lam,Npix,detdist,d2_bragg,depth,defocus,th,del,gam,...
                thscanvals,alphavals,phivals,...
                delta_thscanvals] = InitializeFunctions.NW_scatgeo_2110();  
    
       
       
        %{
        figure(1);
        clf;
        for kk = 1:numel(data_exp)
            imagesc(data_exp(kk).I);
            colorbar;
            axis image;
            title([' noiselevel ' noiselevel_str ' noiseflag= ' num2str(noiseflag) 'jitter =' num2str(percent) 'mncnrate = ' num2str(mncntrate) 'kk = ' num2str(kk)]);
            pause(.1);
        end
        %}
        
        NW_ph_retrieval_BCDI;
        
       save([savefolder '/results.mat']);

    end
    
end