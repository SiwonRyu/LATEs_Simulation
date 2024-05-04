function print_table(data_name, diary_name)
%%%%%%%%%%%% Print results from simulations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------- Input arguments ----------------------------------------------
% - data_name  : Simulation data source
% - diary_name : File name of table (tab-separated text)


load("data\"+data_name+".mat");

for des = 1:4
eval("beta_true_d"+des+" = mean(beta_0_d"+des+",3:4);")
eval("[sum_par_0_lin_d"+des+", sum_tot_0_lin_d"+des+"]  = res_sum(res_0_lin_d"+des+", beta_true_d"+des+");")
eval("[sum_par_0_nl_d" +des+", sum_tot_0_nl_d" +des+"]  = res_sum(res_0_nl_d" +des+", beta_true_d"+des+");")
eval("[sum_par_1_lin_d"+des+", sum_tot_1_lin_d"+des+"]  = res_sum(res_1_lin_d"+des+", beta_true_d"+des+");")
eval("[sum_par_1_nl_d" +des+", sum_tot_1_nl_d" +des+"]  = res_sum(res_1_nl_d" +des+", beta_true_d"+des+");")
eval("[sum_par_VB_d"   +des+", sum_tot_VB_d"   +des+"]  = res_sum(res_VB_d"   +des+", beta_true_d1([1,4]));")
end

print_stat_tot = zeros(length(Glist),4,5,4);
for des = 1:4
    true_lin = eval("sum_tot_0_lin_d"+des);
    true_nl  = eval("sum_tot_0_nl_d" +des);
    est_lin  = eval("sum_tot_1_lin_d"+des);
    est_nl   = eval("sum_tot_1_nl_d" +des);    
    for stat = 1:5
        print_stat_tot(:,:,stat,des) = [true_lin(:,stat), true_nl(:,stat), est_lin(:,stat), est_nl(:,stat)];
    end
end

data_par = "sum_par_1_lin"; % Most efficient estimation
for des = 1:4
    eval("print_stat_par_d"+des+" = "+ data_par +"_d"+des+"(:,:,[1,2,3,7])")
end


clc
diary(diary_name)
% Table: Simulation for each estimate
fprintf('\n\n====================================================== %s \n',datestr(now) );
head = 'Group \tLinear_t \tProbit_t \tLinear_est \tProbit_est\n';
fprintf('\t Simulation: Design 1\n\n');
table_tot(Glist,print_stat_tot(:,:,:,1),head)

fprintf('\n\n\t Simulation: Design 2\n\n');
table_tot(Glist,print_stat_tot(:,:,:,2),head)

fprintf('\n\n\t Simulation: Design 3\n\n');
table_tot(Glist,print_stat_tot(:,:,:,3),head)

fprintf('\n\n\t Simulation: Design 4\n\n');
table_tot(Glist,print_stat_tot(:,:,:,4),head)

% Table: Simulation for each parameter
fprintf('\n\n======================================================\n');
head = 'Group \tDir1 \tInd1 \tDir2 \tInd2\n';
fprintf('\t Simulation for each parameter: Design 1\n\n');
table_par(Glist, print_stat_par_d1,head)

fprintf('\n\n\t Simulation for each parameter: Design 4\n\n');
table_par(Glist, print_stat_par_d4,head)

head = 'Group \tDir1(des2) \tInd2(des2) \tDir1(des3) \tInd2(des3)\n';
fprintf('\n\n\t Simulation for each parameter: Design 2,3\n\n');
table_par(Glist, cat(2, print_stat_par_d2, print_stat_par_d3),head)

% Table for all
fprintf('\n\n======================================================\n');
head = 'Group \tDesign1 \tDesign2 \tDesign3 \tDesign4\n';
table_tot(Glist,permute(print_stat_tot(:,3,:,:),[1,4,3,2]),head)


% Table comparing R, VB
fprintf('\n\n======================================================\n');
R1 = abs(print_stat_par_d1(:,[1,4],1) - beta_true_d2');
R2 = abs(print_stat_par_d4(:,[1,4],1) - beta_true_d2');
R3 = abs(print_stat_par_d2(:,:,1) - beta_true_d2');
R4 = abs(print_stat_par_d3(:,:,1) - beta_true_d2');

V1 = abs(sum_par_VB_d1(:,:,1) - beta_true_d2');
V2 = abs(sum_par_VB_d4(:,:,1) - beta_true_d2');
V3 = abs(sum_par_VB_d2(:,:,1) - beta_true_d2');
V4 = abs(sum_par_VB_d3(:,:,1) - beta_true_d2');

head = 'Group \tDesign1 \tDesign2 \tDesign3 \tDesign4 \tDesign1 \tDesign2 \tDesign3 \tDesign4 \n';
table_compare(Glist, cat(2,R1,R2,R3,R4), cat(2,V1,V2,V3,V4), head)

diary("off")
end

function table_compare(Glist, data_R, data_V, head)
    disp('R')
    fprintf(head)
    print_matrix(Glist,data_R) 
    disp('VB')
    print_matrix(Glist,data_V) 
end

function table_par(Glist, data, head)
    disp('Mean')
    fprintf(head)
    print_matrix(Glist,data(:,:,1)) 
    
    disp('Med')
    print_matrix(Glist,data(:,:,2)) 
    
    disp('MSE')
    print_matrix(Glist,data(:,:,3)) 

    disp('Coverage')
    print_matrix(Glist,data(:,:,4)) 
end

function table_tot(Glist,data,head)
    disp('MSE')
    fprintf(head)
    print_matrix(Glist,data(:,:,1))    
    
    disp('MAE')
    print_matrix(Glist,data(:,:,2))
    
    disp('Coverage')
    print_matrix(Glist,data(:,:,5))
end

function print_matrix(Glist,data)
    format = "%5d";
    for i = 1:size(data,2)
        format = format + "\t%7.2f ";
    end
    format = format + "\n";
    
    for gn = 1:length(Glist)
        fprintf(format, Glist(gn), data(gn,:));
    end
end