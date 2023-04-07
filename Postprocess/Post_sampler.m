function sp_result = Post_sampler(msh, Elem_degree, info, uh, sp_points, frame)
% To sample some random points in each element, and get the result data of them.
% frame = 'Car'--Cartesian , 'Cyl'--cylindrical
addpath('Assembly')

rng('shuffle');
total_sp = msh.nbTriangles * sp_points;

if strcmp(frame, 'Car')
    sp_result.Location = zeros(total_sp, 3);
elseif strcmp(frame, 'Cyl')
    sp_result.Location = zeros(total_sp, 5);
else
    disp("Post_sampler: Wrong frame! Input 'Car' or 'Cyl' as the last parameter.");
    return;
end

sp_result.Stress = zeros(total_sp, 3);

sp_result.h = 0;
% The max mesh size.
if Elem_degree == 1
    nElem = msh.nbTriangles;
elseif Elem_degree == 2
    nElem = msh.nbTriangles6;
end
for ee = 1 : nElem
    p1 = [msh.POS(info.IEN_v(1, ee), 1), msh.POS(info.IEN_v(1, ee), 2)]';
    p2 = [msh.POS(info.IEN_v(2, ee), 1), msh.POS(info.IEN_v(2, ee), 2)]';
    p3 = [msh.POS(info.IEN_v(3, ee), 1), msh.POS(info.IEN_v(3, ee), 2)]';
    
    h_ele = 2 * circumcircle([p1, p2, p3], 0);
    if h_ele > sp_result.h
        sp_result.h = h_ele;
    end
    
    phys2rst = Mapping_p2rst(p1, p2, p3);
    
    uh_ele = zeros(6 * Elem_degree, 1);
    for aa = 1 : 3 * Elem_degree
        uh_ele(2 * aa - 1) = uh(2 * info.IEN_v(aa, ee) - 1);
        uh_ele(2 * aa) = uh(2 * info.IEN_v(aa, ee));
    end
    
    for ss = 1 : sp_points
        sp = Random_tricoor();
        sp_x = sp(1) * p1(1) + sp(2) * p2(1) + sp(3) * p3(1);
        sp_y = sp(1) * p1(2) + sp(2) * p2(2) + sp(3) * p3(2);
        
        sp_result.Location(sp_points * (ee - 1) + ss, 1) = sp_x;
        sp_result.Location(sp_points * (ee - 1) + ss, 2) = sp_y;
        sp_result.Location(sp_points * (ee - 1) + ss, 3) = ee;
        if strcmp(frame, 'Cyl')
            cyl_coor = cylindrical_coor([sp_x; sp_y]);
            sp_result.Location(sp_points * (ee - 1) + ss, 4) = cyl_coor(1);
            sp_result.Location(sp_points * (ee - 1) + ss, 5) = cyl_coor(2);
        end
        
        B_sp = zeros(3, 6 * Elem_degree);
        for aa = 1 : 3 * Elem_degree
            dNa_dx = TriBasis(Elem_degree, aa, 1, 0, sp_x, sp_y, phys2rst);
            dNa_dy = TriBasis(Elem_degree, aa, 0, 1, sp_x, sp_y, phys2rst);
            B_N = [dNa_dx,      0;
                        0, dNa_dy;
                   dNa_dy, dNa_dx];
            B_sp(1 : 3, 2*aa - 1 : 2*aa) = B_N;
        end
        
        % The strain at sampling points.
        eps_sp = B_sp * uh_ele;
        
        % The stress at sampling points.
        sgm_sp = info.D * eps_sp;
        if strcmp(frame, 'Car')
            sp_result.Stress(sp_points * (ee - 1) + ss, 1) = sgm_sp(1);
            sp_result.Stress(sp_points * (ee - 1) + ss, 2) = sgm_sp(2);
            sp_result.Stress(sp_points * (ee - 1) + ss, 3) = sgm_sp(3);
        elseif strcmp(frame, 'Cyl')
            sgm_cyl = cylindrical_stress(sgm_sp, cyl_coor(2));
            sp_result.Stress(sp_points * (ee - 1) + ss, 1) = sgm_cyl(1);
            sp_result.Stress(sp_points * (ee - 1) + ss, 2) = sgm_cyl(2);
            sp_result.Stress(sp_points * (ee - 1) + ss, 3) = sgm_cyl(3);
        end
    end
end

return;
end

