function [fp, fpp] = cromer( zed, energy )% This routine reads data for f' and f" according to an% to an algorithm by Cromer and Liberman%% Usage: [fp, fpp] = cromer( zed, energy )% Fortran version written by Sean Brennan at SSRL, described in% S. Brennan and P.L. Cowan, Rev. Sci. Instrum., 63, 850 (1992).% V3.0 ported to MATLAB, Alex Lessmann (1.0)% Modified to matrix 17-Nov-94 AM,SMB% calls to:% mcm.m lgndr.m indexm.m x_nrg.mat x_sect.mat rel_cor.mat bnd_nrg.mat % Copyright 1998 Anneli Munkholm & Sean Brennan.% Stanford Synchrotron Radiation Laboratory% Stanford Linear Accelerator Center, Stanford CA 94309% Bren@slac.stanford.edu; munkholm@anl.govglobal DISK_PATH DISK_DELIM DISK_END ANOMAL_FILES CL_N_ORB CL_BIND_NRG ...		CL_RELCOR CL_FUNTYPE CL_NRG CL_NPARMS CL_KPCOR CL_XSCAU = 2.80022e+7;KEV_PER_RYD = 0.02721;FINE_PI = 6.942325;INV_FINE_STRUCT = 1.37036e2;if isempty( CL_N_ORB)    %load([DISK_PATH,ANOMAL_FILES,DISK_DELIM,'crom_dir',DISK_END,'bnd_nrg']);    load('~/m_scripts/anomalous/data_dir/crom_dir/bnd_nrg');end% CL_RELCOR is the relativistic correction termif isempty( CL_RELCOR)	%load([DISK_PATH,ANOMAL_FILES,DISK_DELIM,'crom_dir',DISK_END,'rel_cor']);    load('~/m_scripts/anomalous/data_dir/crom_dir/rel_cor');endif isempty( CL_NRG)    %load([DISK_PATH,ANOMAL_FILES,DISK_DELIM,'crom_dir',DISK_END,'x_nrg']);    load('~/m_scripts/anomalous/data_dir/crom_dir/x_nrg');endif isempty( CL_XSC)    %load([DISK_PATH,ANOMAL_FILES,DISK_DELIM,'crom_dir',DISK_END,'x_sect']);    load('~/m_scripts/anomalous/data_dir/crom_dir/x_sect');endif( ( zed < 1) | ( zed > 92) )    zed = 0;    error( 'Atomic number out of range' )elseif any(energy) <= 0    zed = 0;    error( 'Energy undefined' )elseif zed < 3    [fp,fpp] = mcm( zed, energy );    returnendenergy=energy(:)';  % turn into a row vectorCL_NPARMS(zed,:);z_xsc=reshape(CL_XSC(zed,:),24,11); z_nrg=reshape(CL_NRG(zed,:),24,11);z_orb=CL_N_ORB(zed);l_energy=length(energy);z_xsc=z_xsc(1:z_orb,:);z_nrg=z_nrg(1:z_orb,:);d_bind_nrg_au = (CL_BIND_NRG(zed,1:z_orb)/ KEV_PER_RYD)';d_xsect_edge_au=zeros([z_orb 1]);index_11=find(CL_NPARMS(zed,1:z_orb)==11);d_xsect_edge_au(index_11)=z_xsc(index_11,11)./AU;    d_xsect_int=z_xsc(:,6:10)./AU;d_nrg_int=z_nrg(:,6:10);d_xsect_barns=zeros([z_orb l_energy]);[d_nrg_s,index]=sort(z_nrg');        % sort rowsd_nrg_s=d_nrg_s';index_nan=find(isnan(d_nrg_s));      % change NaN's to ones for the alphad_nrg_s(index_nan)=ones(size(index_nan)); index=indexm(index',2);			     % convert to matrix indexd_xsect_s=z_xsc(index);[d_nrg_int,index]=sort(d_nrg_int');  d_nrg_int=d_nrg_int';index=indexm(index',2);				d_xsect_int=d_xsect_int(index);% convert to log of energy, xsectd_log_nrg=log(d_nrg_s);log_index=find(d_xsect_s~=0);d_log_xsect=zeros([z_orb 11]);d_log_xsect(log_index)=log(d_xsect_s(log_index));energy_matrix=energy(ones([z_orb 1]),:)/1000;  % change to keVlog_energy = log( energy_matrix );energy_au = energy_matrix/ KEV_PER_RYD;bind_nrg_matrix=CL_BIND_NRG(zed*ones([1 l_energy]),1:z_orb)'; bind_nrg_au=bind_nrg_matrix/ KEV_PER_RYD;index=find((bind_nrg_matrix-energy_matrix) <= 0);% find i_nxsect: the number of xsects in each orbital which is non-zero[a,b]=find(d_log_xsect~=0);fred=sort(a)';adum= [-inf, fred, length(fred)];bdum= diff(adum);cdum= find(bdum);ddum= diff(cdum);i_nxsect=diff(find(diff([-inf, fred, length(fred)])));i_nxsect_matrix=i_nxsect(ones([1 l_energy]),:)';bbcc=lgndr';% determine z_orb by l_energy matrix of index % (ie. the number of in each orbital for which the nrg is less % than energy).fred=d_log_nrg';cmpmatrix=fred(:)*ones([1 l_energy]) - ...		  log_energy(ones([length(fred(:)) 1]),:);cmpmatrix=reshape(cmpmatrix,11,z_orb*l_energy);index_matrix=zeros(size(cmpmatrix));index_matrix(find(cmpmatrix < 0))=ones(size(find(cmpmatrix < 0)));index_aknint=sum(index_matrix)-1;index_aknint=reshape(index_aknint,z_orb,l_energy);xsec_nonzero=CL_NPARMS(zed,1:z_orb)-i_nxsect+1;xsec_nonzero_matrix=xsec_nonzero(ones([1 l_energy]),:)';index_aknint=max(index_aknint,xsec_nonzero_matrix);index_aknint=min(index_aknint,xsec_nonzero_matrix+i_nxsect_matrix-3); log_nrg=d_log_nrg';log_xsect=d_log_xsect';i_aknint=index_aknint+[0:1:z_orb-1]'*ones([1 l_energy]).*11;i_aknint(1);nrg_1=log_nrg(i_aknint);nrg_2=log_nrg(i_aknint+1);nrg_3=log_nrg(i_aknint+2);t_1=log_xsect(i_aknint);t_2=log_xsect(i_aknint+1);t_3=log_xsect(i_aknint+2);t_4=nrg_1-log_energy;t_5=nrg_2-log_energy;t_6=nrg_3-log_energy;d_xsect_barns = ( t_6 .*(t_1.*t_5 - t_2.*t_4) ./ (nrg_2-nrg_1) -...                  t_5 .*(t_1.*t_6 - t_3.*t_4) ./ (nrg_3-nrg_1) ) ./...        	    (nrg_3-nrg_2);index_zero=find(d_xsect_barns);d_xsect_barns(index_zero) = exp( d_xsect_barns(index_zero) )/ AU;				d_var = (energy_matrix - bind_nrg_matrix)/KEV_PER_RYD;index_d_var=find(d_var==0);d_var(index_d_var)=ones(size(index_d_var));d_fpp_orb=zeros([z_orb l_energy]);d_fp_corr=zeros([z_orb l_energy]);d_fpp_orb(index) = INV_FINE_STRUCT* d_xsect_barns(index).* ...				   energy_matrix(index)/ (4*pi*KEV_PER_RYD);d_fp_corr(index) = -0.5 * d_xsect_barns(index).* energy_au(index) .* ...				   log( (energy_au(index) + bind_nrg_au(index) ) ./ ...				   d_var(index) );				   index01=find(CL_FUNTYPE(zed,1:z_orb) == 0);index01_0=find(bind_nrg_matrix(index01,:)-energy_matrix(index01,:) > 0);index01_1=find(bind_nrg_matrix(index01,:)-energy_matrix(index01,:) <= 0);index2=find(CL_FUNTYPE(zed,1:z_orb) == 1);index3=find(CL_FUNTYPE(zed,1:z_orb) == 2);fred=d_bind_nrg_au(:,ones([1 5]))';b_nrg_au_gauss=fred(:)*ones([1 l_energy]);mort=d_xsect_int';xsc_int_gauss=mort(:)*ones([1 l_energy]);xsc_barns_gauss=reshape(ones([5 1])*d_xsect_barns(:)',5*z_orb,l_energy); fred=d_xsect_edge_au(:,ones([1 5]))';xsc_edge_gauss=fred(:)*ones([1 l_energy]);energy_au_gauss=energy_au(ones([z_orb*5 1]),:);b = bbcc(ones([1 z_orb]),:)'; c = bbcc(2*ones([1 z_orb]),:)'; bb = b(:) * ones([1 l_energy]);cc = c(:) * ones([1 l_energy]);if size(index2,2)  					% if index2 exist, it can only be 1 !!!	dd = 0.5 * b_nrg_au_gauss(1:5,:).^3 .* xsc_int_gauss(1:5,:) ./ ...		 ( sqrt(cc(1:5,:)) .*(energy_au_gauss(1:5,:).^2 .* cc(1:5,:).^2 - ...		 b_nrg_au_gauss(1:5,:).^2 .*cc(1:5,:)) );	mort=bb(1:5,:).*dd;	fp_orb(1,:)=sum(reshape(mort,5,l_energy));end% index3 always existsindex3_fred=((index3(:)-1)*ones([1 5])*5+ones([length(index3) 1])*[1:5])';index3_gauss = index3_fred(:)*ones([1 l_energy])+ones(size(index3_fred(:)))* ...			   [0:l_energy-1]*5*z_orb;				   dd=zeros([length(index3)*5 l_energy]);idx_1 = find(abs(xsc_int_gauss(index3_gauss) - xsc_barns_gauss(index3_gauss))<1e-30 ...	       & cc(index3_gauss)>=1e-31);dd(idx_1) = -2*xsc_int_gauss(index3_gauss(idx_1)).* ...	         b_nrg_au_gauss(index3_gauss(idx_1))./ (cc(index3_gauss(idx_1)).^3);idx_2 = find(abs(xsc_int_gauss(index3_gauss) - xsc_barns_gauss(index3_gauss))>=1e-30 ...           & cc(index3_gauss)>=1e-31);denom_gauss = cc(index3_gauss(idx_2)).^3 .* energy_au_gauss(index3_gauss(idx_2)).^2 - ...	   		  b_nrg_au_gauss(index3_gauss(idx_2)).^2 ./ cc(index3_gauss(idx_2));idx_3=idx_2(find(abs(denom_gauss)<1e-31));dd(idx_3)= -2*xsc_int_gauss(index3_gauss(idx_3)).* b_nrg_au_gauss(index3_gauss(idx_3))./ ...		            (cc(index3_gauss(idx_3)).^3);idx_4=find(abs(denom_gauss)>=1e-31);idx_5=idx_2(idx_4);dd(idx_5) = 2*(xsc_int_gauss(index3_gauss(idx_5)).* ((b_nrg_au_gauss(index3_gauss(idx_5))./ ...	 			cc(index3_gauss(idx_5))).^3)./cc(index3_gauss(idx_5)) - ...				b_nrg_au_gauss(index3_gauss(idx_5)).* xsc_barns_gauss(index3_gauss(idx_5)).* ...				(energy_au_gauss(index3_gauss(idx_5)).^2))./ denom_gauss(idx_4);mort=bb(index3_gauss).*dd;mort=sum(reshape(mort,5,length(index3)*l_energy));fp_orb(index3,:)=reshape(mort,length(index3),l_energy);		if size(index01,2)	index01_fred=((index01(:)-1)*ones([1 5])*5+ones([length(index01) 1])*[1:5])';	index01_gauss = index01_fred(:)*ones([1 l_energy])+ones(size(index01_fred(:)))* ...				   [0:l_energy-1]*5*z_orb;% this is gauss3 - ie index0			dd = b_nrg_au_gauss(index01_gauss).^3 .* ...		 ( xsc_int_gauss(index01_gauss)-xsc_edge_gauss(index01_gauss).* ...		 cc(index01_gauss).^2 ) ./ ( cc(index01_gauss).^2 .* ...		 ( cc(index01_gauss).^2 .* energy_au_gauss(index01_gauss).^2 - ...		 b_nrg_au_gauss(index01_gauss).^2 ) );	mort = bb(index01_gauss).*dd;	mort=sum(reshape(mort,5,length(index01)*l_energy));	fp_orb_zero=reshape(mort,length(index01),l_energy);% this is gauss0 - ie index1	d_prod = energy_au_gauss(index01_gauss).^2 .*cc(index01_gauss).^2 - ...	         b_nrg_au_gauss(index01_gauss).^2;	dd = xsc_int_gauss(index01_gauss) .* b_nrg_au_gauss(index01_gauss) ./ ...	     cc(index01_gauss).^2;	idx_01 = find(abs(d_prod)>1e-30);	dd(idx_01) = (xsc_int_gauss(index01_gauss(idx_01)).* b_nrg_au_gauss(index01_gauss(idx_01)).^3 ./ cc(index01_gauss(idx_01)).^2 -...			     b_nrg_au_gauss(index01_gauss(idx_01)).* xsc_barns_gauss(index01_gauss(idx_01)).* ...    		     energy_au_gauss(index01_gauss(idx_01)).^2)./ d_prod(idx_01);	mort = bb(index01_gauss).*dd;	mort=sum(reshape(mort,5,length(index01)*l_energy));	fp_orb_one=reshape(mort,length(index01),l_energy);	fp_orb_one(index01_0)=fp_orb_zero(index01_0);	fp_orb(index01,:)=fp_orb_one;	% this is correction for index0 only	fp_corr_old=d_fp_corr(index01,:);	fp_corr_01 = 0.5 * xsc_edge_gauss(index01*5,:).* b_nrg_au_gauss(index01*5,:).^2 .* ...				log(-abs(-b_nrg_au_gauss(index01*5,:)+energy_au_gauss(index01*5,:)) ./ ...				(-b_nrg_au_gauss(index01*5,:)-energy_au_gauss(index01*5,:)) ) ./ ...				energy_au_gauss(index01*5,:);	fp_corr_01(index01_1) = fp_corr_old(index01_1);	d_fp_corr(index01,:)=fp_corr_01;endfp=sum(fp_orb+d_fp_corr);fp=fp*FINE_PI+CL_KPCOR(zed)-CL_RELCOR(zed); % subtract relcor ala Ludwigfpp=sum(d_fpp_orb);