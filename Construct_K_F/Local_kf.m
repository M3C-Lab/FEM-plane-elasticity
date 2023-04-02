function [k_ele, f_ele, phys2rst] = Local_kf(msh, data, info, ee)
% To get the stiffness k and load f of each triangular element.

p1 = [msh.POS(info.IEN_v(1, ee), 1), msh.POS(info.IEN_v(1, ee), 2)]';
p2 = [msh.POS(info.IEN_v(2, ee), 1), msh.POS(info.IEN_v(2, ee), 2)]';
p3 = [msh.POS(info.IEN_v(3, ee), 1), msh.POS(info.IEN_v(3, ee), 2)]';

[J, phys2rst] = Mapping_p2rst(p1, p2, p3);

k_ele = zeros(6, 6); f_ele = zeros(6, 1);
for qua = 1 : info.ntqp
    qua_x = info.tqp(1,qua) * p1(1) + info.tqp(2,qua) * p2(1) + info.tqp(3,qua) * p3(1);
    qua_y = info.tqp(1,qua) * p1(2) + info.tqp(2,qua) * p2(2) + info.tqp(3,qua) * p3(2);
    
    dN1_dx = TriBasis(1, 1, 0, qua_x, qua_y, phys2rst);
    dN2_dx = TriBasis(2, 1, 0, qua_x, qua_y, phys2rst);
    dN3_dx = TriBasis(3, 1, 0, qua_x, qua_y, phys2rst);
    dN1_dy = TriBasis(1, 0, 1, qua_x, qua_y, phys2rst);
    dN2_dy = TriBasis(2, 0, 1, qua_x, qua_y, phys2rst);
    dN3_dy = TriBasis(3, 0, 1, qua_x, qua_y, phys2rst);
    
    B_qua = [dN1_dx,      0, dN2_dx,      0, dN3_dx,      0;
                  0, dN1_dy,      0, dN2_dy,      0, dN3_dy;
             dN1_dy, dN1_dx, dN2_dy, dN2_dx, dN3_dy, dN3_dx];
         
    k_ele = k_ele + J * info.twq(qua) * B_qua' * info.D * B_qua;
    
    qua_f = data.BodyF(qua_x, qua_y);
    for aa = 1 : 6
        node = ceil(aa / 2);
        if mod(aa, 2) ~= 0
            f_ele(aa) = f_ele(aa) + J * info.twq(qua) * qua_f(1) * ...
                TriBasis(node, 0, 0, qua_x, qua_y, phys2rst);
        else
            f_ele(aa) = f_ele(aa) + J * info.twq(qua) * qua_f(2) * ...
                TriBasis(node, 0, 0, qua_x, qua_y, phys2rst);
        end
    end 
end

end

