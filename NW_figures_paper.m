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





%%%%%%%%% calculation of the errors in the real space:

rho_conj = ifftn(conj(fftn(rho))); % correct for the flip

rho_ini_conj = ifftn(conj(fftn(rho_ini))); % correct for the flip

rho_shift = DiffractionPatterns.shift_object(NW*sqrt(mncntrate/mn),rho_conj,delta_thscanvals,ki_o,kf_o,kf_o-ki_o,d2_bragg,X,Y,Z);
rho_ini_shift = DiffractionPatterns.shift_object(NW*sqrt(mncntrate/mn),rho_ini_conj ,delta_thscanvals,ki_o,kf_o,kf_o-ki_o,d2_bragg,X,Y,Z);
rho_3DFT_shift = DiffractionPatterns.shift_object(NW*sqrt(mncntrate/mn),ifftn(conj(fftn(rho_3DFT))) ,delta_thscanvals,ki_o,kf_o,kf_o-ki_o,d2_bragg,X,Y,Z);

err = DiffractionPatterns.calculate_error_realspace(abs(NW*sqrt(mncntrate/mn)),abs(rho_shift))
err_ini = DiffractionPatterns.calculate_error_realspace(abs(NW*sqrt(mncntrate/mn)),abs(rho_ini_shift))
err_3DFT = DiffractionPatterns.calculate_error_realspace(NW*sqrt(mncntrate/mn),abs(rho_3DFT_shift))


DisplayResults.compare_two_objects(NW*sqrt(mncntrate/mn),rho_shift,'','',[40 90 40 90],[65],'3',16);
