% In this script the figures for the paper are generated:

%%%%% Figure 1 %%%%%%%%%%%%%%


fig_num = 1;
slice_array = [1:floor(round(numel(angles_list)/4)):numel(angles_list)];
[Psi_mod_matrix] = FiguresForPaper.display_slice_dp(NW,probe,delta_thscanvals,slice_array,ki_o,kf_o,d2_bragg,th,X,Y,Z,fig_num);

figure(2);
clf;

for jj = 1:numel(slice_array)
    %subplot(1,numel(slice_array),jj);
    figure;
    imagesc(Psi_mod_matrix(:,:,slice_array(jj)));
    axis image;
    colorbar;
    title(num2str(slice_array(jj)));
end

fig_num = 3;
DisplayFunctions.display_diff_geom(NW,ki,kf,qbragg,fig_num,X,Y,Z);




%%%%%%%%%%%% Figure 1: low panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%% Figure 2: error metric and example of one single calculation:

h2 = figure(7);
clf;
subplot(121);
plot(log10([newobj.chi' errlist]),'LineWidth',3.0);
hold on;
plot(log10(newobj.chi),'LineWidth',3.0);
%title('error metric recip. space');
xlabel('Iterations');
ylabel('log(\epsilon)');

ax = gca;
set(ax,'FontSize',20);

subplot(122);
plot(log10([err_ERHIO errlist_direct]),'LineWidth',3.0);
hold on;
plot(log10(err_ERHIO),'LineWidth',3.0);
title('error metric in direct space');
xlabel('Iterations')

ax = gca;
set(ax,'FontSize',20);

%%%%%%%% Figure 2: second part

%results of algorithm object/angle

% flip is required for jitter_0_noiselevel_0, jitter_5_noiselevel_0, 
flipflag = 0;

if flipflag 
    rho_plot = ifftn(conj(fftn(rho)));
    support_plot = abs(ifftn(conj(fftn(support_iter))));
else
    rho_plot = rho;
    support_plot = support_iter;
end


rho_shift = DiffractionPatterns.shift_object(NW*sqrt(mncntrate/mn),rho_plot,delta_thscanvals,ki_o,kf_o,kf_o-ki_o,d2_bragg,X,Y,Z);


support_shift = DiffractionPatterns.shift_object(abs(NW*sqrt(mncntrate/mn)),support_plot,delta_thscanvals,ki_o,kf_o,kf_o-ki_o,d2_bragg,X,Y,Z); 
support_shift_abs = abs(support_shift);
support_shift_fin = (support_shift_abs>0.1*max(support_shift_abs(:)));


phase_rho_shift = angle(rho_shift(65,65,65));
phase_NW = angle(NW(65,65,65));


%results of ER/HIO


if flipflag 
    rho_3DFT_toplot= (ifftn(conj(newobj.dp)));
else
    rho_3DFT_toplot= (ifftn(newobj.dp));
end

rho_2DFT = DiffractionPatterns.From3DFT_to_2DFT(rho_3DFT_toplot,angles_list,probe,ki_o,kf_o,X,Y,Z);
[rho_2DFT_shift,rho_2DFT_shift_vector] = DiffractionPatterns.shift_object(NW*sqrt(mncntrate/mn),rho_2DFT,delta_thscanvals,ki_o,kf_o,kf_o-ki_o,d2_bragg,X,Y,Z);


[support_new_shift_final,support_new_shift_vector] = FiguresForPaper.figure2_flipsupport(flipflag,NW*sqrt(mncntrate/mn),support_new,angles_list,probe,ki_o,kf_o,X,Y,Z,d2_bragg);

phase_rho_2DFT_shift = angle(rho_2DFT_shift(65,65,65));

% test phase ofset:
DisplayResults.compare_two_objects(NW*sqrt(mncntrate/mn).*conj(NW),rho_shift.*support_shift_fin.*conj(NW)*exp(-1i*phase_rho_shift)*exp(-1i*1.6),'','',[40 90],[65 65],'23',31);
DisplayResults.compare_two_objects(NW*sqrt(mncntrate/mn).*conj(NW),rho_2DFT_shift*exp(-1i*phase_rho_2DFT_shift).*support_new_shift_final.*conj(NW)*exp(-1i*1.5),'','',[40 90],[65 65],'23',32);

DisplayResults.compare_two_objects(NW*sqrt(mncntrate/mn),rho_shift,'','',[40 90],[65 65],'23',41);
DisplayResults.compare_two_objects(NW*sqrt(mncntrate/mn),rho_2DFT_shift,'','',[40 90],[65 65],'23',42);


% figures:

phase_color = [0 2.1];
FiguresForPaper.figure2_rightpanel(NW*sqrt(mncntrate/mn)*exp(-1i*phase_NW),rho_2DFT_shift*exp(-1i*phase_rho_2DFT_shift).*support_new_shift_final,rho_shift.*exp(-1i*phase_rho_shift).*support_shift_fin,'','','',phase_color,[40 90 40 90],[65],'3',26);

phase_color = [-0.5 0.5];
FiguresForPaper.figure2_rightpanel(NW*sqrt(mncntrate/mn).*conj(NW),rho_2DFT_shift*exp(-1i*phase_rho_2DFT_shift).*conj(NW).*support_new_shift_final*exp(-1i*1.5),rho_shift.*conj(NW)*exp(-1i*phase_rho_shift)*exp(-1i*1.6).*support_shift_fin ,'','','',phase_color,[40 90 40 90],[65],'3',27);



%%%%%%%%%%%%%% Figure 4: angle correction:
[theta_iter] = DisplayResults.read_angles_iterations(data_exp,delta_thscanvals,delta_thscanvals);
DisplayResults.display_all_angles_oneiterations_errorrel(theta_iter,data_exp,dth_disp,[1 cnt_ntheta],'absolute',1025);

%%%%%%%%%%%% Saving figures:

jitter_str = num2str(jitterlevel(jjj));
noiselevel_str = '1';
folder_str = ['jitter_' jitter_str '_noiselevel_' noiselevel_str '_freqsw500/'];

figure(7);
savefig([folder_str 'error_metric_real_direct.fig']);


figure(26);
savefig([folder_str 'figure3_objects_phase.fig']);

figure(27);
savefig([folder_str 'figure3_objects_nophase.fig']);

figure(1025);
savefig([folder_str 'figure4_anglecorrection.fig']);




%%%%%%%% Figure 5: comparison of the quality of the reconstruction for
%%%%%%%% different jittering and different levels of noise

jitterlevel_summary = [0 5 10 20 40];

for kk = 1:numel(jitterlevel_summary)
    
    savefolder = ['jitter_' num2str(jitterlevel_summary(kk)) '_noiselevel_0_freqsw500'];
    load([savefolder '/results.mat']);
    struct_err(kk).chi = [newobj.chi' errlist];
    struct_err(kk).chid_direct = [err_ERHIO errlist_direct];
    struct_err(kk).rho = rho;
    struct_err(kk).support_iter = support_iter;
   
end

save('results_sim_blueshift/struct_err_level0.mat','struct_err');



for kk = 1:numel(struct_err)
   
    chi_final(kk) = struct_err(kk).chi(end);
    chi_direct_final(kk) = struct_err(kk).chid_direct(end);
end



figure;
%subplot(121);
plot(jitterlevel_summary,log10(chi_final));
%title('recip');
xlabel('% of angular jitter');ylabel('log(\epsilon)');
ax = gca;
set(ax,'FontSize',20);

figure(3);
savefig('results_sim_blueshift/chi_vs_jitter.fig');


subplot(122);
plot(jitterlevel_summary,log10(chi_direct_final));
title('direct');

flipflag_list = [1 1 0 0 1];
phaseoffset = [1.55 1.58 1.43 1.545 1.01];

for kk = 1:numel(struct_err)
    
    flipflag = flipflag_list(kk);
    
    if flipflag
        rho_plot = ifftn(conj(fftn(struct_err(kk).rho)));
        support_plot = abs(ifftn(conj(fftn(struct_err(kk).support_iter))));
    else
        rho_plot = struct_err(kk).rho;
        support_plot = struct_err(kk).support_iter;
    end
    
    
    rho_shift = DiffractionPatterns.shift_object(NW*sqrt(mncntrate/mn),rho_plot,delta_thscanvals,ki_o,kf_o,kf_o-ki_o,d2_bragg,X,Y,Z);
    
    
    support_shift = DiffractionPatterns.shift_object(abs(NW*sqrt(mncntrate/mn)),support_plot,delta_thscanvals,ki_o,kf_o,kf_o-ki_o,d2_bragg,X,Y,Z);
    support_shift_abs = abs(support_shift);
    support_shift_fin = (support_shift_abs>0.1*max(support_shift_abs(:)));
    
    
    phase_rho_shift = angle(rho_shift(65,65,65));
    phase_NW = angle(NW(65,65,65));
    
    
    struct_toplot(kk).rho_shift = rho_shift*exp(-1i*phase_rho_shift).*support_shift_fin;
    struct_toplot(kk).support_shift_fin = support_shift_fin;
    struct_toplot(kk).rho_nophase = rho_shift.*conj(NW)*exp(-1i*phase_rho_shift).*support_shift_fin*exp(-1i*phaseoffset(kk));
    
    
    
end

fig_num = 30;
phase_color = [0 2.1];
phase_color_2 = [-0.1 0.1];
FiguresForPaper.figure5_bottompanel(struct_toplot,phase_color,phase_color_2,[40 90 40 90],[65],'3',fig_num);

% check phase offset

DisplayResults.compare_two_objects(NW*sqrt(mncntrate/mn).*conj(NW),struct_toplot(1).rho_nophase,'','',[40 90],[65 65],'23',42);
DisplayResults.compare_two_objects(NW*sqrt(mncntrate/mn).*conj(NW),struct_toplot(2).rho_nophase,'','',[40 90],[65 65],'23',42);
DisplayResults.compare_two_objects(NW*sqrt(mncntrate/mn).*conj(NW),struct_toplot(3).rho_nophase,'','',[40 90],[65 65],'23',42);
DisplayResults.compare_two_objects(NW*sqrt(mncntrate/mn).*conj(NW),struct_toplot(4).rho_nophase,'','',[40 90],[65 65],'23',42);
DisplayResults.compare_two_objects(NW*sqrt(mncntrate/mn).*conj(NW),struct_toplot(5).rho_nophase,'','',[40 90],[65 65],'23',42);


figure(fig_num);
savefig('results_sim_blueshift/rho_alljitter_noiselevel0.fig');

save('results_sim_blueshift/rhostructtoplot_level0.mat','struct_toplot','flipflag_list','phaseoffset');

