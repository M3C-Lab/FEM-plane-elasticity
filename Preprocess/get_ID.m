function [ID, Dir_Nod] = get_ID(msh, data)
% To get the ID array where the Dirichlet BC are already confirmed.

ID = zeros(2, msh.nbNod);

% Initialize the ID array.
for ii = 1 : msh.nbNod
    ID(1, ii) = 2 * ii - 1;
    ID(2, ii) = 2 * ii;
end

if data.nbDir ~= 0
    % Find the nodes on the Dirichlet boundaries.
    Dir_Nod = cell(1, data.nbDir);

    for I = 1 : data.nbDir
        for J = 1 : (data.nbDir + data.nbNeu)
            if strcmp(data.DirBC{I, 1}, msh.PhyGrp{J, 3})
                ii = msh.PhyGrp{J, 2};

                nbLineEle = 0;
                % Search for elements on a Dirichlet boundary.
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
                
                LineEle = zeros(nbLineEle, 1);
                temp = 1;
                if data.Elem_degree == 1
                    for jj = 1 : msh.nbLines
                        if msh.LINES(jj, 3) == ii
                            LineEle(temp) = jj;
                            temp = temp + 1;
                        end      
                    end
                elseif data.Elem_degree == 2
                    for jj = 1 : msh.nbLines3
                        if msh.LINES3(jj, 4) == ii
                            LineEle(temp) = jj;
                            temp = temp + 1;
                        end      
                    end
                end
                

                % Search for node info.
                temp = 1;
                LineNod = zeros(1, 2 * nbLineEle);
                for kk = 1 : nbLineEle
                    for jj = 1 : (data.Elem_degree + 1)
                        if data.Elem_degree == 1
                            LineNod(temp) = msh.LINES(LineEle(kk), jj);
                        elseif data.Elem_degree == 2
                            LineNod(temp) = msh.LINES3(LineEle(kk), jj);
                        end
                        temp = temp + 1;
                    end
                end
                LineNod = unique(LineNod);

                % Put it in to the cell.
                Dir_Nod{I} = LineNod;

                % Rearrange ID array with Dirichlet BC.
                for jj = 2 : 3
                    if isempty(data.DirBC{I, jj}) ~= 1
                        if data.DirBC{I, jj} == 'x'
                            for mm = 1 : length(LineNod)
                                if ID(1, LineNod(mm)) ~= 0
                                    ID(1, LineNod(mm)) = 0;
                                    if ID(2, LineNod(mm)) ~= 0
                                        ID(2, LineNod(mm)) = ...
                                            ID(2, LineNod(mm)) - 1;
                                    end
                                    for nn = LineNod(mm) + 1 : msh.nbNod
                                        for kk = 1 : 2
                                            if ID(kk, nn) ~= 0
                                                ID(kk, nn) = ID(kk, nn) - 1;
                                            end
                                        end
                                    end
                                end
                            end
                        elseif data.DirBC{I, jj} == 'y'
                            for mm = 1 : length(LineNod)
                                if ID(2, LineNod(mm)) ~= 0
                                    ID(2, LineNod(mm)) = 0;
                                    for nn = LineNod(mm) + 1 : msh.nbNod
                                        for kk = 1 : 2
                                            if ID(kk, nn) ~= 0
                                                ID(kk, nn) = ID(kk, nn) - 1;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                break;
            end
        end

    end
else
    Dir_Nod = [ ];
end

end

