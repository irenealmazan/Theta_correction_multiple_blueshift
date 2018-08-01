%%%%%%%%% Figure 2: error metric and example of one single calculation:

DisplayResults.show_rho_theta_update(6,errlist,rho.*support_iter,midsl,angles_list,delta_thscanvals'+dth_disp,norm_grad_rho(1:nrho),beta_rho(1:nrho),norm_grad_theta(1:cnt_ntheta-1),beta_theta(1:cnt_ntheta-1),'theta');

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
flipflag = 1;

if flipflag 
    rho_ini_plot = ifftn(conj(fftn(rho_ini)));
    rho_plot = ifftn(conj(fftn(rho)));
    support_plot = abs(ifftn(conj(fftn(support_iter))));
else
    rho_ini_plot = rho_ini;
    rho_plot = rho;
    support_plot = support_iter;
end


rho_shift = DiffractionPatterns.shift_object(NW*sqrt(mncntrate/mn),rho_plot,delta_thscanvals,ki_o,kf_o,kf_o-ki_o,d2_bragg,X,Y,Z);
rho_ini_shift = DiffractionPatterns.shift_object(NW*sqrt(mncntrate/mn),rho_ini_plot,delta_thscanvals,ki_o,kf_o,kf_o-ki_o,d2_bragg,X,Y,Z);


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
phaseoffset_rho = 1.5;
phaseoffset_rho_ERHIO = 1.7;

DisplayResults.compare_two_objects(NW*sqrt(mncntrate/mn).*conj(NW),rho_shift.*support_shift_fin.*conj(NW)*exp(-1i*phase_rho_shift)*exp(-1i*phaseoffset_rho),'','',[40 90],[65 65],'23',31);
DisplayResults.compare_two_objects(NW*sqrt(mncntrate/mn).*conj(NW),rho_2DFT_shift*exp(-1i*phase_rho_2DFT_shift).*support_new_shift_final.*conj(NW)*exp(-1i*phaseoffset_rho_ERHIO),'','',[40 90],[65 65],'23',32);

DisplayResults.compare_two_objects(NW*sqrt(mncntrate/mn),rho_shift,'','',[40 90],[65 65],'23',41);
DisplayResults.compare_two_objects(NW*sqrt(mncntrate/mn),rho_2DFT_shift,'','',[40 90],[65 65],'23',42);


% figures:

intenscolor = [0 0.03];
phase_color = [0 2.1];
FiguresForPaper.figure2_rightpanel(NW*sqrt(mncntrate/mn)*exp(-1i*phase_NW),rho_2DFT_shift*exp(-1i*phase_rho_2DFT_shift).*support_new_shift_final,rho_shift.*exp(-1i*phase_rho_shift).*support_shift_fin,'','','',intenscolor,phase_color,[40 90 40 90],[65],'3',26);

intenscolor = [0 0.03];
phase_color = [-0.1 0.1];
FiguresForPaper.figure2_rightpanel(NW*sqrt(mncntrate/mn).*conj(NW),rho_2DFT_shift*exp(-1i*phase_rho_2DFT_shift).*conj(NW).*support_new_shift_final*exp(-1i*phaseoffset_rho_ERHIO),rho_shift.*conj(NW)*exp(-1i*phase_rho_shift)*exp(-1i*phaseoffset_rho).*support_shift_fin ,'','','',intenscolor,phase_color,[40 90 40 90],[65],'3',27);



%%%%%%%%%%%%%% Figure 4: angle correction:
[theta_iter] = DisplayResults.read_angles_iterations(data_exp,delta_thscanvals,delta_thscanvals);
DisplayResults.display_all_angles_oneiterations_errorrel(theta_iter,data_exp,dth_disp,[1 cnt_ntheta],'absolute',1025);


return;
%%%%%%%%%%%% Saving figures:

jitter_str = num2str(jitterlevel(jjj));
noiselevel_str = '3';
folder_str = ['jitter_' jitter_str '_noiselevel_' noiselevel_str '_freqsw500/'];


figure(6);
savefig([folder_str 'error_metric_grad.fig']);

figure(7);
savefig([folder_str 'error_metric_real_direct.fig']);



figure(26);
savefig([folder_str 'figure3_objects_phase.fig']);

figure(27);
savefig([folder_str 'figure3_objects_nophase.fig']);

figure(31);
savefig([folder_str 'ERHIO_profile.fig']);

figure(32);
savefig([folder_str 'DFT2D_profile.fig']);

figure(1025);
savefig([folder_str 'figure4_anglecorrection.fig']);


