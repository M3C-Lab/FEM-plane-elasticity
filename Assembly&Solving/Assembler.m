function [K_stif, F_load] = Assembler(msh, data, info)
% To construct the stiffness matrix K and the load vector F.

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

K_stif = sparse(n_eq, n_eq); F_load = zeros(n_eq, 1);

if data.Elem_degree == 1
    nElem = msh.nbTriangles;
elseif data.Elem_degree == 2
    nElem = msh.nbTriangles6;
end
% Generate local k_ele and f_ele.
progress = 10;
for ee = 1 : nElem
    [k_ele, f_ele, phys2rst] = Local_Ass(msh, data, info, ee);
    
    % Modify the load vector by Neumann BC.
    if data.nbNeu ~= 0
        f_ele = Add_Neu(msh, data, info, ee, f_ele, phys2rst);
    end
    
    % Assemble K and F.
    for aa = 1 : (6 * data.Elem_degree)
        LM_a = info.LM(aa, ee);
        if LM_a > 0
            F_load(LM_a) = F_load(LM_a) + f_ele(aa);
            for bb = 1 : (6 * data.Elem_degree)
                LM_b = info.LM(bb, ee);
                if LM_b > 0
                    K_stif(LM_a,LM_b) = K_stif(LM_a,LM_b) + k_ele(aa, bb);
                else
                    % Add Dirichlet BC.
                    % But the value of our Dirichlet BC would be zero,
                    % therefore nothing would be changed in fact.
                    F_load(LM_a) = F_load(LM_a) - k_ele(aa, bb) * 0;
                end
            end
        end
    end
    
    if ee >= 0.01 * progress * nElem
        if progress == 10
            fprintf('%d%%', progress);
        elseif progress == 100
            fprintf('  %d%%\n', progress);
        else
            fprintf('  %d%%', progress);
        end
        progress = progress + 10;
    end
end

return;
end

% EOF