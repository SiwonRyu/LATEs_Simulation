function [Y_obs, Y_pot, beta_true] = gen_Y3(bar_Y,W,D_pot,D_obs,za,zb)
G = size(W,1);

za2 = 3*(za==2) + 2*(za==3) + za*(za==1 | za==4);
K_1 = D_pot(:,za,1)-D_pot(:,zb,1);
K_2 = D_pot(:,za2,2)-D_pot(:,zb,2);
K = cat(3, K_1, K_2);

Y_pot = zeros(G,4,2);
Y_obs = zeros(G,1,2);

for i = [1,2]
%     Y_pot(:,1,i) = K(:,:,i).*bar_Y(1,1,i) + K(:,:,3-i).*bar_Y(1,2,i) + randn(G,1) + W(:,1,i) + 0.5*W(:,1,3-i);
%     Y_pot(:,2,i) = K(:,:,i).*bar_Y(1,1,i) + K(:,:,3-i).*bar_Y(2,2,i) + randn(G,1) + W(:,1,i) + 0.5*W(:,1,3-i);
%     Y_pot(:,3,i) = K(:,:,i).*bar_Y(2,1,i) + K(:,:,3-i).*bar_Y(1,2,i) + randn(G,1) + W(:,1,i) + 0.5*W(:,1,3-i);
%     Y_pot(:,4,i) = K(:,:,i).*bar_Y(2,1,i) + K(:,:,3-i).*bar_Y(2,2,i) + randn(G,1) + W(:,1,i) + 0.5*W(:,1,3-i);
    
    e_Y = randn(G,1);
    Y_pot(:,1,i) = K(:,:,i).*bar_Y(1,1,i) + K(:,:,3-i).*bar_Y(1,2,i) + e_Y + W(:,1,i) + 0.5*W(:,1,3-i);
    Y_pot(:,2,i) = K(:,:,i).*bar_Y(1,1,i) + K(:,:,3-i).*bar_Y(2,2,i) + e_Y + W(:,1,i) + 0.5*W(:,1,3-i);
    Y_pot(:,3,i) = K(:,:,i).*bar_Y(2,1,i) + K(:,:,3-i).*bar_Y(1,2,i) + e_Y + W(:,1,i) + 0.5*W(:,1,3-i);
    Y_pot(:,4,i) = K(:,:,i).*bar_Y(2,1,i) + K(:,:,3-i).*bar_Y(2,2,i) + e_Y + W(:,1,i) + 0.5*W(:,1,3-i); 
    
    Y_obs(:,1,i) = ...
       D_obs(:,:,i) .*   D_obs(:,:,3-i) .*Y_pot(:,1,i)+ ...
       D_obs(:,:,i) .*(1-D_obs(:,:,3-i)).*Y_pot(:,2,i)+ ...
    (1-D_obs(:,:,i)).*   D_obs(:,:,3-i) .*Y_pot(:,3,i)+ ...
    (1-D_obs(:,:,i)).*(1-D_obs(:,:,3-i)).*Y_pot(:,4,i);
end


dir1 = bar_Y(1,1,1)-bar_Y(2,1,1);
ind1 = bar_Y(1,2,1)-bar_Y(2,2,1);
dir2 = bar_Y(1,1,2)-bar_Y(2,1,2);
ind2 = bar_Y(1,2,2)-bar_Y(2,2,2);
beta_true = [dir1; ind1; 0; dir2; ind2; 0];
end
