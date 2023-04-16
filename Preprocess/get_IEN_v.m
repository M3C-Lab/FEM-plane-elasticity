function IEN_v = get_IEN_v(msh, Elem_degree)
% To get the IEN array of volumetric elements

if Elem_degree == 1
    IEN_v = zeros(3 * Elem_degree, msh.nbTriangles);
    temp = 1;
    for jj = msh.nbLines + 1 : msh.nbElm
        for kk = 1 : 3 * Elem_degree
            IEN_v(kk, temp) = msh.ELE_NODES(jj, kk);
        end
        temp = temp + 1;
    end
elseif Elem_degree == 2
    IEN_v = zeros(3 * Elem_degree, msh.nbTriangles6);
    temp = 1;
    for jj = msh.nbLines3 + 1 : msh.nbElm
        for kk = 1 : 3 * Elem_degree
            IEN_v(kk, temp) = msh.ELE_NODES(jj, kk);
        end
        temp = temp + 1;
    end
end

end

% EOF