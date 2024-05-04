function [res_0_lin,res_0_nl,res_1_lin,res_1_nl,beta_0,res_VB] = ...
    sim(design, Glist, B, b_z, mean_Y, z_a, z_b, nrng)
%%%%%%%%%%%% Monte Carlo Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last updated on May, 04, 2024, by Siwon Ryu
%----------- Input arguments ----------------------------------------------
% Input arguments
% - design: 1,2,3,4
% - Glist: vector of group sizes
% - B: # of replications
% - b_z: coefficient of treatment (Z)
% - mean_Y: E(Y(d))
% - z_a/z_b: two treatment statuses in the monotone pair m = (z_a, z_b, r)
% - nrng: seed for random numger generation

%----------- Output -------------------------------------------------------
% - res_X: containers for the results

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(nrng);

nG      = length(Glist); % # of group sizes
b_z_0   = [b_z,b_z];     % Set coefficients for treatment (Z) of two units

% npar: # of parameters for each design
% cs: case indicator
% - cs = 0: general identification + additional IV with interaction
% - cs = 1: speical case 1 + additional IV (without interaction)
% - cs = 2: special case 2
if design == 2 | design == 3
    npar = 2;
    cs   = 2;
else
    npar = 4;
    cs   = 1;
end

%%%%%%%%%%% Set containers
res_0_lin   = zeros(npar,4,length(Glist),B);
res_0_nl    = zeros(npar,4,length(Glist),B);
res_1_lin   = zeros(npar,4,length(Glist),B);
res_1_nl    = zeros(npar,4,length(Glist),B);
beta_0      = zeros(npar,1,length(Glist),B);
res_VB      = zeros(2,4,length(Glist),B);

% Loop for group sizes
gn      = 0;
for G   = Glist
gn      = gn+1;
regen   = 0;
clear D_pot D_obs;

% Loop for replications
parfor b = 1:B
disp(['Design ',num2str(design),', G =',num2str(G),', iteration: ',num2str(b),' / ',num2str(B), ' start'])

%%%%%%%%%%% Generate exogenous variables X = (T,W) %%%%%%%%%%%%%%%%%%%%%%%%
k           = 2;
W           = randn(G,k,2);
T           = rand(G,1,2);
T(:,:,1)    = rand(G,1);
T(:,:,2)    = rand(G,1);

%%%%%%%%%%% Generate treatment assignments Z %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Z, P_Z_fun, P_Z_obs] = gen_Z(W,T,b_z);

%%%%%%%%%%% Generate treatment-take up D %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Indicators: 1(Z=z)
idx = @(z, Z) ...
     (z==1).*(Z(:,:,1)==1 & Z(:,:,2)==1) ...
    +(z==2).*(Z(:,:,1)==1 & Z(:,:,2)==0) ...
    +(z==3).*(Z(:,:,1)==0 & Z(:,:,2)==1) ...
    +(z==4).*(Z(:,:,1)==0 & Z(:,:,2)==0);

%Exclude cases violate overlapping assumption 
%   For general case, P(K_i|X), P(K_j|X), P(K_ij|X) > 0
%   For special case 1, P(K_i|X), P(K_j|X) > 0
%   For special case 2, P(K_i|X) > 0, P(K_j|X) = 0
check_OVL = 0;
regen = 0;
while check_OVL == 0
    regen = regen + 1;
    [D_pot, D, P_D_fun] = gen_D(Z,T,W,design);
    
    check_OVL1      = sum((idx(z_a,Z)-idx(z_b,Z)).*D(:,:,1));
    check_OVL2      = sum((idx(z_a,Z)-idx(z_b,Z)).*D(:,:,2));
    check_OVLjoint  = sum((idx(z_a,Z)-idx(z_b,Z)).*prod(D,3));    
    
    % Design 2 (TM+OSN) and 3 (PE) use special case 2
    % Design 1 (TM) and 4 (WOSN) can use general case, but actually use
    % special case 1 because the outcome DGP is additively separable in all
    % designs.
    if design == 2 | design == 3
        check_OVL = check_OVL1 > 0 & check_OVL1 > check_OVL2;
        % Even if P(K2=1|X) = 0, because D2(za)=D2(zb), the sample analog
        % estimate of the probability could not be zero. For example,
        % realization of D2(za) = D2(zb) = 1 for the first observation, and 
        % D2(za) = D2(zb) = 0 for the second observation is possible.
        % However, P(K2=1|X) is likely to be close to zero, and hence
        % generate with P(K1=1|X) > P(K2=1|X) for automatic unit selection 
        % in the estimation function.
    elseif design == 1 | design == 4
        check_OVL = (check_OVL1 > 0).*(check_OVL2 > 0).*(check_OVLjoint > 0); 
        % check_OVLjoint > 0 implies other two.
    end    
end
%disp(['Number of regeneration = ', num2str(regen)])

%%%%%%%%%%% Generate outcomes Y %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Y, Y_pot, beta_true]   = gen_Y3(mean_Y,W,D_pot,D,z_a,z_b);

% True parameter values
if      design == 2 | design == 3
    beta_0(:,:,gn,b)  = beta_true([1,5]);    
elseif  design == 1 | design == 4
    beta_0(:,:,gn,b)  = beta_true([1,2,4,5]);
end    

%%%%%%%%%%% Estimation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
res_1_lin(:,:,gn,b) = estim(Y,D,Z,W,T,[],[],z_a,z_b,"true","lin",cs,"off");
res_1_nl(:,:,gn,b)  = estim(Y,D,Z,W,T,[],[],z_a,z_b,"true","nl",cs,"off");
res_0_lin(:,:,gn,b) = estim(Y,D,Z,W,T,[],[],z_a,z_b,b_z_0,"lin",cs,"off");
res_0_nl(:,:,gn,b)  = estim(Y,D,Z,W,T,[],[],z_a,z_b,b_z_0,"nl",cs,"off");
res_VB(:,:,gn,b)    = estim_VB(Y,D,Z,W,T,[],"true",z_a,z_b);

end % end for replication
end % end for group size
end