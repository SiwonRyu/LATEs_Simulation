clc
clear all
format compact
format short g

addpath('mfiles')
z_a = 2;
z_b = 4;

load('data\test_design1.mat')
[res_design1,omega_design1,PK_design1,~] = estim(Y,D,Z,W,T,[],[],z_a,z_b,"true","lin",1,"on");
save_for_figure(1,size(Y,1),PK_design1,T,W,P_D_fun);

load('data\test_design2.mat')
[res_design2,omega_design2,PK_design2,~] = estim(Y,D,Z,W,T,[],[],z_a,z_b,"true","lin",2,"on");
save_for_figure(2,size(Y,1),PK_design2,T,W,P_D_fun);

load('data\test_design3.mat')
[res_design3,omega_design3,PK_design3,~] = estim(Y,D,Z,W,T,[],[],z_a,z_b,"true","lin",2,"on");
save_for_figure(3,size(Y,1),PK_design3,T,W,P_D_fun);

load('data\test_design4.mat')
[res_design4,omega_design4,PK_design4,~] = estim(Y,D,Z,W,T,[],[],z_a,z_b,"true","lin",1,"on");
save_for_figure(4,size(Y,1),PK_design4,T,W,P_D_fun);




function save_for_figure(design,G,PK_all,T,W,P_D_fun)
phi_0 = gen_phi(design);
P1_true_fun =@(T) P_D_fun(1,W,T,phi_0(2,:,1)')-P_D_fun(1,W,T,phi_0(4,:,1)');
P2_true_fun =@(T) P_D_fun(2,W,T,phi_0(3,:,2)')-P_D_fun(2,W,T,phi_0(4,:,2)');

P1_true = zeros(G,1);
P2_true = zeros(G,1);
parfor g = 1:G
    P1_true(g) = mean(P1_true_fun(repmat(T(g,:,:),G,1)),1); % P_K(T)
    P2_true(g) = mean(P2_true_fun(repmat(T(g,:,:),G,1)),1);
end
P1_true_r = P1_true_fun(T); % P_K(X)
P2_true_r = P2_true_fun(T);
P1_est = PK_all(:,:,1,2); % Estimated P_K(T)
P2_est = PK_all(:,:,2,2);

grp1tmp = [T(:,:,1), P1_est, P1_true, P1_true_r];
grp2tmp = [T(:,:,2), P2_est, P2_true, P2_true_r];
grp1tmp = sort(grp1tmp,1);
grp2tmp = sort(grp2tmp,1);

figure(design)
hold on
    plot(grp1tmp(:,1), grp1tmp(:,2),'.r')
    plot(grp2tmp(:,1), grp2tmp(:,2),'.b')
    plot(grp1tmp(:,1), grp1tmp(:,3),'--r')
    plot(grp2tmp(:,1), grp2tmp(:,3),'--b')
    plot(grp1tmp(:,1), grp1tmp(:,4),'-r')
    plot(grp2tmp(:,1), grp2tmp(:,4),'-b')
hold off

eval("Xmat_des"+design+" = [grp1tmp(:,1), grp2tmp(:,1)];");
eval("Ymat_des"+design+" = [grp1tmp(:,3), grp2tmp(:,3)];");
eval("clearvars -except design Xmat_des"+design+" Ymat_des"+design);
save("data\fig"+design+".mat")
end