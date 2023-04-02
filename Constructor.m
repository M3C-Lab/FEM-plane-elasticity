function [K, F] = Constructor(msh, data, info)
% To construct the stiffness matrix K and the load vector F.
addpath('Construct_K_F');

% Confirm the number of equations.
mm = 2; nn = msh.nbNod;
while info.ID(mm, nn) == 0
    if mm == 2
        mm = 1;
    else
        mm = 2;
        nn = nn - 1;
    end
end
n_eq = info.ID(mm, nn);

K = sparse(n_eq, n_eq); F = zeros(n_eq, 1);
% Generate local k_ele and f_ele.
for ee = 1 : msh.nbTriangles
    [k_ele, f_ele, phys2rst] = Local_kf(msh, data, info, ee);
    
    % Modify the load vector by Neumann BC.
    if data.nbNeu ~= 0
        f_ele = Add_Neu(msh, data, info, ee, f_ele, phys2rst);
    end
    
    % Assemble K and F.
    for aa = 1 : 6
        LM_a = info.LM(aa, ee);
        if LM_a > 0
            F(LM_a) = F(LM_a) + f_ele(aa);
            for bb = 1 : 6
                LM_b = info.LM(bb, ee);
                if LM_b > 0
                    K(LM_a,LM_b) = K(LM_a,LM_b) + k_ele(aa, bb);
                else
                    % Add Dirichlet BC.
                    % But the value of our Dirichlet BC would be zero,
                    % therefore nothing would be changed in fact.
                    F(LM_a) = F(LM_a) - k_ele(aa, bb) * 0;
                end
            end
        end
    end
end

return;

end

