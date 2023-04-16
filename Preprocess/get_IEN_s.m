function IEN_s = get_IEN_s(msh, data, IEN_v)
% To get the IEN array of surface elements
% Output:
%   IEN_s: The IEN matrix of the line elements on Neumann boundaries
%           (as a cell).
%       IEN_s{i}: The IEN matrix of the 'i'th Neumann boundary
%       IEN_s{i}(*, e): The 'e'th element.
%     If data.Elem_degree = 1:
%       IEN_s{i}(1, e), IEN_s{i}(2, e): The nodes of the 'e'th element.
%       IEN_s{i}(3, e): Which triangular element the 'e'th line element 
%                       is located at.
%     If data.Elem_degree = 2:
%       IEN_s{i}(1, e), IEN_s{i}(2, e), IEN_s{i}(3, e): The nodes of 
%                       the 'e'th element.
%       IEN_s{i}(4, e): Which triangular element the 'e'th line element 
%                       is located at.

IEN_s = cell(1, data.nbNeu);

% Search for Neumann boundaries.
for I = 1 : data.nbNeu
    for J = 1 : (data.nbDir + data.nbNeu)
        if strcmp(data.NeuBC{I, 1}, msh.PhyGrp{J, 3})
            ii = msh.PhyGrp{J, 2};
            
            nbLineEle = 0;
            % Search for element number on a Neumann boundary.
            if data.Elem_degree == 1
                for jj = 1 : msh.nbLines
                    if msh.LINES(jj, 3) == ii
                        nbLineEle = nbLineEle + 1;
                    end      
                end
            elseif data.Elem_degree == 2
                for jj = 1 : msh.nbLines3
                    if msh.LINES3(jj, 4) == ii
                        nbLineEle = nbLineEle + 1;
                    end      
                end
            end
            
            % Construct IEN.
            N_IEN = zeros(data.Elem_degree + 2, nbLineEle);
            temp = 1;
            if data.Elem_degree == 1
                for jj = 1 : msh.nbLines
                    if msh.LINES(jj, 3) == ii
                        % The nodes of the line element.
                        N_IEN(1, temp) = msh.LINES(jj, 1);
                        N_IEN(2, temp) = msh.LINES(jj, 2);
                        % Locate the triangular element.
                        for ee = 1 : msh.nbTriangles
                            for mm = 1 : 3 * data.Elem_degree
                                if IEN_v(mm, ee) == N_IEN(1, temp)
                                    for nn = 1 : 3 * data.Elem_degree
                                        if IEN_v(nn, ee) == N_IEN(2, temp)
                                            N_IEN(3, temp) = ee;
                                            break;
                                        end
                                    end
                                end
                                if N_IEN(3, temp) ~= 0
                                    break;
                                end
                            end
                            if N_IEN(3, temp) ~= 0
                                break;
                            end
                        end
                        temp = temp + 1;
                    end       
                end
            elseif data.Elem_degree == 2
                for jj = 1 : msh.nbLines3
                    if msh.LINES3(jj, 4) == ii
                        % The nodes of the line element.
                        N_IEN(1, temp) = msh.LINES3(jj, 1);
                        N_IEN(2, temp) = msh.LINES3(jj, 2);
                        N_IEN(3, temp) = msh.LINES3(jj, 3);
                        % Locate the triangular element.
                        for ee = 1 : msh.nbTriangles6
                            for kk = 1 : 3 * data.Elem_degree
                                if IEN_v(kk, ee) == N_IEN(1, temp)
                                    for mm = 1 : 3 * data.Elem_degree
                                        if IEN_v(mm, ee) == N_IEN(2, temp)
                                            for nn = 1 : 3 * data.Elem_degree
                                                if IEN_v(nn, ee) == N_IEN(3, temp)
                                                    N_IEN(4, temp) = ee;
                                                    break;
                                                end
                                            end
                                        end
                                        if N_IEN(4, temp) ~= 0
                                            break;
                                        end
                                    end
                                end
                                if N_IEN(4, temp) ~= 0
                                    break;
                                end
                            end
                            if N_IEN(4, temp) ~= 0
                                break;
                            end
                        end
                        temp = temp + 1;
                    end
                end
            end
            % Put it into the cell 
            IEN_s{I} = N_IEN;
            break;
        end
    end
end
end

% EOF