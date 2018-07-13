global d2_bragg X Y Z ki_o kf_o

warning off;


%addpath(genpath('/Users/ialmazn/Box Sync/Nanowire_ptychography/NSLS II/NSLS II March 2017/Analysis_end_of_beamtime'));
addpath(genpath('./m_scripts/'));
addpath(genpath('./calc_functions'));
%addpath(genpath('./display_functions'));

%% Flags:
NW_flags;

if flagContinue == 0
    display('STARTING A NEW PHASE RETRIEVAL OPERATION');
    
    
     [Niter_rho, Niter_pos,...
                Niter_theta,freq_pos,freq_store,freq_restart,tau_backtrack_rho,beta_ini_rho,...
                counter_max_rho,tau_backtrack_theta,beta_ini_theta,counter_max_theta] = ...
        InitializeFunctions.NW_experimental_phretrieval_parameters();
    
    
    %% Scattering condition:
    scatgeo = 2110; %for strain image
    %scatgeo = 1010; %for stacking-fault image
    switch scatgeo
        case 1010 %SF
            [pixsize,lam,Npix,detdist,d2_bragg,depth,defocus,th,del,gam,...
                thscanvals,alphavals,phivals,...
                delta_thscanvals] = InitializeFunctions.NW_scatgeo_1010();          
        case 2110 %strain
            [pixsize,lam,Npix,detdist,d2_bragg,depth,defocus,th,del,gam,...
                thscanvals,alphavals,phivals,...
                delta_thscanvals] = InitializeFunctions.NW_scatgeo_2110();          
    end
    
    
    %% Create sample
    NW_diff_vectors_BCDI; % does both the vectors ki and kf and creates the object
    
    if newSample
        switch whichSample
            case 'Random'
                MakeSample;
            case 'Hexagone'
                NW_make_InGaAs_nocoreshell_BCDI;
        end
        
        
        NW = img;
        
    else
        
        load('../results_files/Original_Sample');
    end
    
    if(addNWstrain)
        NW  = img;
    else
        NW  = abs(img);
    end
    
    if plotResults
        NW_plot_diff_vectors_sample_BCDI;
    end
    
    probe = ones(size(X));
    
    %% Calculate diffraction patterns
    NW_calc_dp_BCDI;
    NW_add_dp_noise;
    
    %%
    if initialGuess == 1
        ER_HIO;
    elseif initialGuess == 3
        load('../results_files/ER_HIO_initial_guess');            
    end
    
    if smoothSupportFlag == 3
        load('../results_files/ER_HIO_initial_guess');            
    end
    
else
    display('CONTINUING A PHASE RETRIEVAL OPERATION');
end


%% Phase retrieval algorithm
NW_ph_retrieval_BCDI;
