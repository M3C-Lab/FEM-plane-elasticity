function IEN_s = get_IEN_s(msh, data, IEN_v)
% To get the IEN array of surface elements
% Output:
%   IEN_s: The IEN matrix of the line elements on Neumann boundaries
%           (as a cell).
%       IEN_s{i}: The IEN matrix of the 'i'th Neumann boundary
%       IEN_s{i}(*, e): The 'e'th element.
%       IEN_s{i}(1, e), IEN_s{i}(2, e): The nodes of the 'e'th element.
%       IEN_s{i}(3, e): Which triangular element the 'e'th line element 
%                          is located at.
%       IEN_s{i}(4, e): The other node of the triangular element.

IEN_s = cell(1, data.nbNeu);

% Search for Neumann boundaries.
for I = 1 : data.nbNeu
    for J = 1 : (data.nbDir + data.nbNeu)
        if strcmp(data.NeuBC{I, 1}, msh.PhyGrp{J, 3})
            ii = msh.PhyGrp{J, 2};
            
            nbLineEle = 0;
            % Search for element number on a Dirichlet boundary.
            for jj = 1 : msh.nbLines
                if msh.LINES(jj, 3) == ii
                    nbLineEle = nbLineEle + 1;
                end      
            end
            
            % Construct IEN.
            N_IEN = zeros(4, nbLineEle);
            temp = 1;
            for jj = 1 : msh.nbLines
                if msh.LINES(jj, 3) == ii
                    % The nodes of the line element.
                    N_IEN(1, temp) = msh.LINES(jj, 1);
                    N_IEN(2, temp) = msh.LINES(jj, 2);
            
                    % Search the location of each line element.
                    node_sum = N_IEN(1, temp) + N_IEN(2, temp);
                    node_diff = abs(N_IEN(1, temp) - N_IEN(2, temp));
                    % Compare 'node1 + node2' and '|node1 - node2|' respectively.
                    for kk = 1 : msh.nbTriangles       
                        for ll = 1 : 3
                            choices = [1, 2, 3];
                            choices(ll) = [ ];
                            sum_test = IEN_v(choices(1), kk) + IEN_v(choices(2), kk);
                            if sum_test == node_sum
                                diff_test = abs(IEN_v(choices(1), kk) - IEN_v(choices(2), kk));
                                if diff_test == node_diff
                                    N_IEN(3, temp) = kk;
                                    % The 'temp'th line element is the boundary of
                                    % the 'kk'th triangular element.
                                    N_IEN(4, temp) = IEN_v(ll, kk);
                                    % 'IEN_v(ll, kk)' is the other node.
                                    break;
                                end
                            end
                        end
                
                        if N_IEN(3, temp) ~= 0
                            break;
                        end
                    end
                    temp = temp + 1;
                end       
            end
            % Put it into the cell 
            IEN_s{I} = N_IEN;
            break;
        end
    end
end

end

