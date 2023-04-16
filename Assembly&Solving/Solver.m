function uh = Solver(msh, info, K_stif, F_load)
% To get the displacement vector involved by Dirichlet BC

d = K_stif \ F_load;
uh = zeros(msh.nbNod, 1);

for nn = 1 : msh.nbNod
    for mm = 1 : 2
        if info.ID(mm, nn) ~= 0
            uh(2 * (nn - 1) + mm, 1) = d(info.ID(mm, nn), 1);
        end
    end
end

end

%EOF