function [ed,ck,rb,txt,but]=pk_udata();% break out components of handle_list into usable arrays% 5-3-94 SMB (Bren@SLAC.stanford.edu)handle_list = get(gcf,'userdata'); for i=5:22,	ed(i-4) = handle_list(i);endfor i=23:40,	ck(i-22)= handle_list(i);endfor i=41:50	rb(i-40)= handle_list(i);endfor i=58:61	txt(i-57)= handle_list(i);endbut(1:4)= handle_list(1:4);