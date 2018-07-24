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

h2 = figure(5);
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

rho_conj = ifftn(conj(fftn(rho))); % correct for the flip
rho_shift = DiffractionPatterns.shift_object(NW*sqrt(mncntrate/mn),rho_conj,delta_thscanvals,ki_o,kf_o,kf_o-ki_o,d2_bragg,X,Y,Z);

support_conj = abs(ifftn(conj(fftn(support_iter))));
support_shift = DiffractionPatterns.shift_object(abs(NW*sqrt(mncntrate/mn)),support_conj,delta_thscanvals,ki_o,kf_o,kf_o-ki_o,d2_bragg,X,Y,Z); 
support_shift_abs = abs(support_shift);
support_shift_fin = (support_shift_abs>0.1*max(support_shift_abs(:)));


phase_rho_shift = angle(rho_shift(65,65,65));
phase_NW = angle(NW(65,65,65));


%results of ER/HIO

rho_3DFT= (ifftn(conj(newobj.dp)));
rho_2DFT = DiffractionPatterns.From3DFT_to_2DFT(rho_3DFT,angles_list,probe,ki_o,kf_o,X,Y,Z);
[rho_2DFT_shift,rho_2DFT_shift_vector] = DiffractionPatterns.shift_object(NW*sqrt(mncntrate/mn),rho_2DFT,delta_thscanvals,ki_o,kf_o,kf_o-ki_o,d2_bragg,X,Y,Z);

[support_new_shift_final,support_new_shift_vector] = FiguresForPaper.figure2_preparesupport('0','0',NW*sqrt(mncntrate/mn),support_new,angles_list,probe,ki_o,kf_o,X,Y,Z,d2_bragg);

phase_rho_2DFT_shift = angle(rho_2DFT_shift(65,65,65));

% figures:

phase_color = [0 2.1];
FiguresForPaper.figure2_rightpanel(NW*sqrt(mncntrate/mn)*exp(-1i*phase_NW),rho_2DFT_shift*exp(-1i*phase_rho_2DFT_shift).*support_new_shift_final,rho_shift.*support_shift_fin*exp(-1i*phase_rho_shift),'','','',phase_color,[40 90 40 90],[65],'3',26);

phase_color = [-0.1 0.1];
FiguresForPaper.figure2_rightpanel(NW*sqrt(mncntrate/mn).*conj(NW),rho_2DFT_shift*exp(-1i*phase_rho_2DFT_shift).*support_new_shift_final.*conj(NW)*exp(-1i*1.55),rho_shift.*support_shift_fin.*conj(NW)*exp(-1i*phase_rho_shift)*exp(-1i*1.55),'','','',phase_color,[40 90 40 90],[65],'3',27);



%%%%%%%%%%%%%% Figure 4: angle correction:

DisplayResults.display_all_angles_oneiterations_errorrel(theta_iter,data_exp,dth_disp,[1 800 2000],'absolute',1025);


