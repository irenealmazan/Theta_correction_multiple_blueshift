% This script combines ER and HIO perforemd with the 3DFT in order to solve
% thve bcdi problem 

% prvepare data (matrix 3D):

original_object = NW*sqrt(mncntrate/mn);

[~,sup_ini,dp] = Phretrieval_functions.prepare_data_ER_HIO(NW,data_exp);
err_ERHIO = [];

er_iter = 1;

[retrphase,newobj,err_ERHIO] = Phretrieval_functions.do_ER(err_ERHIO,dp,sup_ini,[],er_iter,original_object,delta_thscanvals,ki_o,kf_o,probe,d2_bragg,X,Y,Z);



er_iter = 5;

[retrphase,newobj,err_ERHIO] = Phretrieval_functions.do_ER(err_ERHIO,dp,sup_ini,newobj,er_iter,original_object,delta_thscanvals,ki_o,kf_o,probe,d2_bragg,X,Y,Z);

mod_object = abs(newobj.object);
support_new = Phretrieval_functions.shrink_wrap_support(mod_object,0.1,[1 1 1]*1e6,X,Y,Z);

er_iter = 120;
[retrphase,newobj,err_ERHIO] = Phretrieval_functions.do_ER(err_ERHIO,dp,support_new,newobj,er_iter,original_object,delta_thscanvals,ki_o,kf_o,probe,d2_bragg,X,Y,Z);


mod_object = abs(newobj.object);
support_new = Phretrieval_functions.shrink_wrap_support(mod_object,0.1,[1 1 1]*1e6,X,Y,Z);

er_iter = 60;
[retrphase,newobj,err_ERHIO] = Phretrieval_functions.do_ER(err_ERHIO,dp,support_new,newobj,er_iter,original_object,delta_thscanvals,ki_o,kf_o,probe,d2_bragg,X,Y,Z);


hio_iter = 100;
[retrphase,newobj,err_ERHIO] = Phretrieval_functions.do_HIO(err_ERHIO,dp,support_new,newobj,er_iter,original_object,delta_thscanvals,ki_o,kf_o,probe,d2_bragg,X,Y,Z);

er_iter = 120;
[retrphase,newobj,err_ERHIO] = Phretrieval_functions.do_ER(err_ERHIO,dp,support_new,newobj,er_iter,original_object,delta_thscanvals,ki_o,kf_o,probe,d2_bragg,X,Y,Z);

mod_object = abs(newobj.object);
support_new = Phretrieval_functions.shrink_wrap_support(mod_object,0.1,[1 1 1]*1e6,X,Y,Z);

er_iter = 60;
[retrphase,newobj,err_ERHIO] = Phretrieval_functions.do_ER(err_ERHIO,dp,support_new,newobj,er_iter,original_object,delta_thscanvals,ki_o,kf_o,probe,d2_bragg,X,Y,Z);

hio_iter = 100;
[retrphase,newobj,err_ERHIO] = Phretrieval_functions.do_HIO(err_ERHIO,dp,support_new,newobj,er_iter,original_object,delta_thscanvals,ki_o,kf_o,probe,d2_bragg,X,Y,Z);

er_iter = 120;
[retrphase,newobj,err_ERHIO] = Phretrieval_functions.do_ER(err_ERHIO,dp,support_new,newobj,er_iter,original_object,delta_thscanvals,ki_o,kf_o,probe,d2_bragg,X,Y,Z);

mod_object = abs(newobj.object);
support_new = Phretrieval_functions.shrink_wrap_support(mod_object,0.1,[1 1 1]*1e6,X,Y,Z);

er_iter = 60;
[retrphase,newobj,err_ERHIO] = Phretrieval_functions.do_ER(err_ERHIO,dp,support_new,newobj,er_iter,original_object,delta_thscanvals,ki_o,kf_o,probe,d2_bragg,X,Y,Z);

hio_iter = 50;
[retrphase,newobj,err_ERHIO] = Phretrieval_functions.do_HIO(err_ERHIO,dp,support_new,newobj,er_iter,original_object,delta_thscanvals,ki_o,kf_o,probe,d2_bragg,X,Y,Z);

er_iter = 180;
[retrphase,newobj,err_ERHIO] = Phretrieval_functions.do_ER(err_ERHIO,dp,support_new,newobj,er_iter,original_object,delta_thscanvals,ki_o,kf_o,probe,d2_bragg,X,Y,Z);



finalobj = (ifftn(newobj.dp));


if plotResults
    original_object = NW*sqrt(mncntrate/mn);
    finalobj = ((ifftn((newobj.dp))));%fliplr(flipud((ifftn(newobj.dp))));
    %finalobj = (ifftn(newobj.dp)*exp(-1i*(0.26+1.56+2.7)));
    
    DisplayResults.compare_two_objects(original_object,finalobj,'Original object','retrieved object',[50 80],[64 64],'12',11);
    
    DisplayResults.compare_two_objects(original_object,finalobj,'Original object','retrieved object',[40 90 40 90],[64],'2',12);
    DisplayResults.compare_two_objects(original_object,finalobj,'Original object','retrieved object',[50 80],[64 64],'13',13);
    
    DisplayResults.compare_two_objects(original_object,finalobj,'Original object','retrieved object',[40 90 40 90],[64],'3',14);
    DisplayResults.compare_two_objects(original_object,finalobj,'Original object','retrieved object',[50 80],[64 64],'23',15);
    
end