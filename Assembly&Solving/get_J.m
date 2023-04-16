function J = get_J(msh, info, Elem_degree, ee, area_coor)
% To get the Jacobian of a point in an element with isoparametric mapping.

p1 = [msh.POS(info.IEN_v(1, ee), 1), msh.POS(info.IEN_v(1, ee), 2)]';
p2 = [msh.POS(info.IEN_v(2, ee), 1), msh.POS(info.IEN_v(2, ee), 2)]';
p3 = [msh.POS(info.IEN_v(3, ee), 1), msh.POS(info.IEN_v(3, ee), 2)]';

r = area_coor(1);
s = area_coor(2);
t = area_coor(3);

if Elem_degree == 1 % In linear element the J is uniform.
    point_matrix = [1, p1(1), p1(2);
                    1, p2(1), p2(2);
                    1, p3(1), p3(2)];
                
    derivative_matrix = [1, 0, 0;   % [dN1_dr, dN1_ds, dN1_dt;
                         0, 1, 0;   %  dN2_dr, dN2_ds, dN2_dt;
                         0, 0, 1];  %  dN3_dr, dN3_ds, dN3_dt];
                     
elseif Elem_degree == 2 % In quadratic element the J depends on the coordinates.
    p4 = [msh.POS(info.IEN_v(4, ee), 1), msh.POS(info.IEN_v(4, ee), 2)]';
    p5 = [msh.POS(info.IEN_v(5, ee), 1), msh.POS(info.IEN_v(5, ee), 2)]';
    p6 = [msh.POS(info.IEN_v(6, ee), 1), msh.POS(info.IEN_v(6, ee), 2)]';
    
    point_matrix = [1/3, p1(1), p1(2);
                    1/3, p2(1), p2(2);
                    1/3, p3(1), p3(2);
                    1/3, p4(1), p4(2);
                    1/3, p5(1), p5(2);
                    1/3, p6(1), p6(2)];
                
    derivative_matrix = [4*r - 1,       0,       0; % [dN1_dr, dN1_ds, dN1_dt;
                               0, 4*s - 1,       0; %  dN2_dr, dN2_ds, dN2_dt;
                               0,       0, 4*t - 1; %  dN3_dr, dN3_ds, dN3_dt;
                             4*s,     4*r,       0; %  dN4_dr, dN4_ds, dN4_dt;
                               0,     4*t,     4*s; %  dN5_dr, dN5_ds, dN5_dt;
                             4*t,       0,     4*r];%  dN6_dr, dN6_ds, dN6_dt];
end

Jacobian_matrix = derivative_matrix' * point_matrix;
J = det(Jacobian_matrix);

return;
end

% EOF
