function [k_ele, f_ele, phys2rst] = Local_Ass(msh, data, info, ee)
% To get the stiffness k and load f of each triangular element.

p1 = [msh.POS(info.IEN_v(1, ee), 1), msh.POS(info.IEN_v(1, ee), 2)]';
p2 = [msh.POS(info.IEN_v(2, ee), 1), msh.POS(info.IEN_v(2, ee), 2)]';
p3 = [msh.POS(info.IEN_v(3, ee), 1), msh.POS(info.IEN_v(3, ee), 2)]';

phys2rst = Mapping_p2rst(p1, p2, p3);

k_ele = zeros(6 * data.Elem_degree, 6 * data.Elem_degree); 
f_ele = zeros(6 * data.Elem_degree, 1);
for qua = 1 : info.ntqp
    qua_x = info.tqp(1,qua) * p1(1) + info.tqp(2,qua) * p2(1) + info.tqp(3,qua) * p3(1);
    qua_y = info.tqp(1,qua) * p1(2) + info.tqp(2,qua) * p2(2) + info.tqp(3,qua) * p3(2);
    
    B_qua = zeros(3, 6 * data.Elem_degree);
    for aa = 1 : 3 * data.Elem_degree
        dNa_dx = TriBasis(data.Elem_degree, aa, 1, 0, qua_x, qua_y, phys2rst);
        dNa_dy = TriBasis(data.Elem_degree, aa, 0, 1, qua_x, qua_y, phys2rst);
        B_N = [dNa_dx,      0;
                    0, dNa_dy;
               dNa_dy, dNa_dx];
        B_qua(1 : 3, 2*aa - 1 : 2*aa) = B_N;
    end
    
    J = get_J(msh, info, data.Elem_degree, ee, info.tqp(:, qua)); 
    % info.tqp(:, qua) contains the area coordinates(r,s,t) of the
    %  quadrature point.
    k_ele = k_ele + J * info.twq(qua) * B_qua' * info.D_elast * B_qua;
    
    qua_f = data.BodyF(qua_x, qua_y);
    for aa = 1 : 6 * data.Elem_degree
        node = ceil(aa / 2);
        if mod(aa, 2) ~= 0
            f_ele(aa) = f_ele(aa) + J * info.twq(qua) * qua_f(1) * ...
                TriBasis(data.Elem_degree, node, 0, 0, qua_x, qua_y, phys2rst);
        else
            f_ele(aa) = f_ele(aa) + J * info.twq(qua) * qua_f(2) * ...
                TriBasis(data.Elem_degree, node, 0, 0, qua_x, qua_y, phys2rst);
        end
    end 
end

end

% EOF