% this scripts shows the results achieved by Sid with the ER/HIO results

cnt_array = [1 2 3];
jitter = [0 10 20 40];

counter = 1;

for cc = cnt_array
   for jj = jitter
       load(['results_for_Irene/result_cnt_' num2str(cc) '_jitter_' num2str(jj) '.mat']);
       DisplayResults.compare_two_objects(image,support,'','',[1 128 1 128],[35],'3',counter);
       set(gcf,'Name',['result_cnt_' num2str(cc) '_jitter_' num2str(jj)]);
       counter = counter + 1;
   end
    
    
end