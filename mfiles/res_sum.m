function [sum_par, sum_tot] = res_sum(res, par_true)
%%%%%%%%%%%% Summarize simulation results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------- Input arguments ----------------------------------------------
%- res: container from simulation, M (# of parameters) x 4 (est/se/t/p) x G (# of G) x B(rep)
%- par_true: true parameter vector, M (# of parameters) x 1
%----------- Output -------------------------------------------------------
%- sum_par : mean/median/MSE/MAE/bias/variance/coverage
%- sum_tot : (agg.) MSE/MAE/Sum of squared bias/Sum of variance/coverage

Eb = @(res) permute(mean(res,4),[3,1,2]);
Mb = @(res) permute(median(res,4),[3,1,2]);

crit    = abs(icdf('Normal',0.975,0,1));
mean_b  = permute(mean(res(:,1,:,:),4),[3,1,2]);   % (Mx1xG) -> (GxM)
med_b   = permute(median(res(:,1,:,:),4),[3,1,2]); % (Mx1xG) -> (GxM)

mean_b  = Eb(res(:,1,:,:));
med_b   = Mb(res(:,1,:,:));

error_b = res(:,1,:,:) - par_true; % Mx1xGxB
bias_b  = permute(mean(error_b,4),[3,1,2]); 
MAE_b   = permute(mean(abs(error_b),4),[3,1,2]);
MSE_b   = permute(mean(error_b.^2,4),[3,1,2]);
dev_b   = res(:,1,:,:) - mean(res(:,1,:,:),4);
var_b   = permute(mean(dev_b.^2,4),[3,1,2]);

UB      = res(:,1,:,:) + crit*res(:,2,:,:);
LB      = res(:,1,:,:) - crit*res(:,2,:,:);
covr_b  = permute(mean((LB <= par_true).*(par_true <= UB), 4),[3,1,2]);

SS_bias_b  = sum(bias_b.^2,2);
MAE_b_tot  = sum(MAE_b,2);
MSE_b_tot  = permute(sum(mean(error_b.^2,4),1),[3,1,2]);
var_b_tot  = sum(var_b,2);
covr_b_min = min(covr_b,[],2);

sum_par = cat(3,mean_b,med_b,MSE_b, MAE_b, bias_b, var_b, covr_b);
sum_tot = [MSE_b_tot, MAE_b_tot, SS_bias_b, var_b_tot, covr_b_min];
end