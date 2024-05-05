clc; clear all; close all;
%format compact
format short g;
addpath('mfiles');

%%%%%%%%%%%% Run Monte Carlo simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set coefficients for generating Z (coef / my W / other's W / my T / other's T)
b_z     = [0,  0.1, 0,  0.1, 0,  0.1,  0.1]';

% Set parameters for generating potential outcomes
bar_Y1_i    = [40;20];
bar_Y1_j    = [20;10];
bar_Y2_i    = [60;30];
bar_Y2_j    = [30;15];
bar_Y       = cat(3,[bar_Y1_i, bar_Y1_j],[bar_Y2_i, bar_Y2_j]);

% Number of replications
B           = 10000;

% List of group sizes
%Glist       = [2500, 5000, 10000, 20000]
Glist       = [200,400,500,800,1000,2000,5000,10000]

% Monotone pair
z_a = 2;   
z_b = 4;

% Run
tic()
[res_0_lin_d1,res_0_nl_d1,res_1_lin_d1,res_1_nl_d1,beta_0_d1,res_VB_d1] = sim(1, Glist, B, b_z, bar_Y, z_a, z_b, 2024);
[res_0_lin_d2,res_0_nl_d2,res_1_lin_d2,res_1_nl_d2,beta_0_d2,res_VB_d2] = sim(2, Glist, B, b_z, bar_Y, z_a, z_b, 2024);
[res_0_lin_d3,res_0_nl_d3,res_1_lin_d3,res_1_nl_d3,beta_0_d3,res_VB_d3] = sim(3, Glist, B, b_z, bar_Y, z_a, z_b, 2024);
[res_0_lin_d4,res_0_nl_d4,res_1_lin_d4,res_1_nl_d4,beta_0_d4,res_VB_d4] = sim(4, Glist, B, b_z, bar_Y, z_a, z_b, 2024);
toc()

% Save simulation info.
save('data\res_0505.mat')

% Print Simulation Result
print_table("res_0505", "Tables_0505.txt")

% Tables_0504_rev: modify A as IF*IF'/G
% Tables_0505: B=10000, Glist=[200,400,800,1000,2000,5000,10000]
%% Print Figure
print_figure_types