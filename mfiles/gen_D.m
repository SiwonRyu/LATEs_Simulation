function [D_pot, D_obs, P_D_fun] = gen_D(Z,T,W,design)
    G = size(Z,1);
    phi = gen_phi(design);
    case_num = @(s,t) (s==1&t==1) + 2*(s==1&t==0) + 3*(s==0&t==1) + 4*(s==0&t==0);
    phi_pot = @(i,s,t) phi(case_num(s,t),:,i)';
    X_pot_d = @(i,W,T) [ones(G,1), W(:,1,i), W(:,1,3-i), T(:,:,i), T(:,:,3-i)];
    
    nu      = randn(G,1,2);
    D_pot = zeros(G,4,2);
    for i = [1,2]
        D_pot(:,1,i) = nu(:,1,i) <= X_pot_d(i,W,T)*phi_pot(i,1,1);
        D_pot(:,2,i) = nu(:,1,i) <= X_pot_d(i,W,T)*phi_pot(i,1,0);
        D_pot(:,3,i) = nu(:,1,i) <= X_pot_d(i,W,T)*phi_pot(i,0,1);
        D_pot(:,4,i) = nu(:,1,i) <= X_pot_d(i,W,T)*phi_pot(i,0,0);
    end
    
    D_obs = zeros(G,1,2);
    for i =[1,2]
    D_obs(:,1,i) = ...
           Z(:,:,i) .*   Z(:,:,3-i) .*D_pot(:,1,i)+ ...
           Z(:,:,i) .*(1-Z(:,:,3-i)).*D_pot(:,2,i)+ ...
        (1-Z(:,:,i)).*   Z(:,:,3-i) .*D_pot(:,3,i)+ ...
        (1-Z(:,:,i)).*(1-Z(:,:,3-i)).*D_pot(:,4,i);
    end
    P_D_fun = @(i,W,T,phi) normcdf( X_pot_d(i,W,T)*phi );
end