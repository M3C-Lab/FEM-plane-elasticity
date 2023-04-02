function IEN_v = get_IEN_v(msh)
% To get the IEN array of volumetric elements

IEN_v = zeros(3, msh.nbTriangles);
temp = 1;
for jj = msh.nbLines + 1 : msh.nbElm
    IEN_v(1, temp) = msh.ELE_NODES(jj, 1);
    IEN_v(2, temp) = msh.ELE_NODES(jj, 2);
    IEN_v(3, temp) = msh.ELE_NODES(jj, 3);
    temp = temp + 1;
end

end

