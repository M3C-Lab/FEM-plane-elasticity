function f_ele = Add_Neu(msh, data, info, ee, f_ele, phys2rst)
% To add the Neumann BC on local load vectors.

for ii = 1 : data.nbNeu
    for jj = 1 : size(info.IEN_s{ii}, 2)
        % Search for triangular elements adjoining Neumann boundaries.
        if ee == info.IEN_s{ii}(3, jj)
            % Search for nodes of line elements on Neumann boundaries.
            supported_N = [1, 2, 3];
            for kk = 1 : 3
                if info.IEN_v(kk, ee) == info.IEN_s{ii}(4, jj)
                    supported_N(kk) = [ ];
                end
            end
            
            n1 = [msh.POS(info.IEN_s{ii}(1, jj), 1), msh.POS(info.IEN_s{ii}(1, jj), 2)]';
            n2 = [msh.POS(info.IEN_s{ii}(2, jj), 1), msh.POS(info.IEN_s{ii}(2, jj), 2)]';
            
            % The Jacobian and the quadrature points in the physical space
            % of line elements.
            [j, plqp] = Mapping_lineqp(info.lqp, n1, n2);
            
            for node = 1 : 2
                Nah_node = [0, 0]';
                for qua = 1 : size(info.lqp)
                    Na_qua = TriBasis(supported_N(node), 0, 0, plqp(1, qua), plqp(2, qua), phys2rst);
                    
                    if isa(data.NeuBC{ii, 2}, 'function_handle')
                        NeuBC_qua = data.NeuBC{ii, 2}(plqp(1, qua), plqp(2, qua));
                        NeuBC_qua = NeuBC_qua';
                    elseif isa(data.NeuBC{ii, 2}, 'double')
                        normalv = [info.normals{ii}(1, jj), info.normals{ii}(2, jj)]';
                        NeuBC_qua = data.NeuBC{ii, 2} * normalv;
                    else
                        disp('Add_Neu: Wrong Neumann BC! Use a vector function handle or only a scalar.');
                        return;
                    end
                    
                    Nah_node = Nah_node + j * info.lwq(qua) * Na_qua * NeuBC_qua;
                end
                
                % Add Neumann BC.
                f_ele(2 * supported_N(node) - 1) = f_ele(2 * supported_N(node) - 1) + Nah_node(1);
                f_ele(2 * supported_N(node)) = f_ele(2 * supported_N(node)) + Nah_node(2);
            end
        end
    end
end

end

