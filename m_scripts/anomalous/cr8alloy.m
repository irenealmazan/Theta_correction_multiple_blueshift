function cr8alloy(command) %  widget for defining zed and fract for cr8cryst and cr8matl%  density also defined for cr8matl% Copyright 1999 Sean Brennan.% Stanford Synchrotron Radiation Laboratory% Stanford Linear Accelerator Center, Stanford CA 94309% bren@slac.stanford.eduif nargin == 0 	command = 'Alloy';end if isstr(command) 	if strcmp(command,'expt')		z= get(findobj(gcf,'tag','zed1'),'String');        nogo=strcmp(z,'');		if nogo,			break;		else			z=element(z);			comps(1,1)=z;			comps(1,2)=str2num(get(findobj(gcf,'tag','fra1'),'string'));			for j=2:5				ztag=['zed' num2str(j)];				ftag=['fra' num2str(j)];	            nogo=strcmp(get(findobj(gcf,'tag',ztag),'String'),'');							if ~nogo, 					z=get(findobj(gcf,'tag',ztag),'string');					z=element(z);					comps(j,1)=z;					comps(j,2)=str2num(get(findobj(gcf,'tag',ftag),'string'));				end			end			title=get(gcf,'name');			if strcmp(title(1:4),'Basi')				cr8cryst(title,comps);			else				str= get(findobj(gcf,'tag','dens'),'String');				if isempty(str) str= '0.0'; end				density= str2num(str);				data.dens= density;				data.comp= comps;				cr8matl('Alloy',data);			end		end	elseif strcmp(command(1:3),'fra')		frac_nr=str2num(command(4));		frac=str2num(get(gco,'string'));		if ~isempty(frac),			for j=1:str2num(command(4)) 				dfrac(j)=str2num(get(findobj(gcf,'tag',['fra' num2str(j)]),'string'));			end			frac_sum=1-sum(dfrac); 			if frac_sum==0,				for j=1:5-frac_nr					set(findobj(gcf,'tag',['fra' num2str(frac_nr+j)]),...					           'string','');						set(findobj(gcf,'tag',['zed' num2str(frac_nr+j)]),...					           'string','');				end				else				set(findobj(gcf,'tag',['fra' num2str(frac_nr+1)]),...				           'string',num2str(frac_sum));			end		end	else		alloy_i(command);	endend