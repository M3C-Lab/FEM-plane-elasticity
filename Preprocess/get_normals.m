function normals = get_normals(msh, IEN_s)
% To get the outside normals of the elements on the Neumann boundaries.
% Output:
%   normals: The external normal vectors with respect to IEN_s (as a cell).
%       normals{i}: The normal vectors of the 'i'th Neumann boundary
%       normals{i}(*, e): The 'e'th element.
%       normals{i}(1, e): The x-direction component of the vector
%       normals{i}(2, e): The y-direction component of the vector
%       normals{i}(3, e): Which triangular element the 'e'th line element 
%                          is located at, checked with IEN_s{i}(3, e)

normals = cell(1, length(IEN_s));
Rotation_matrix = [0, -1;
                   1,  0];

for ii = 1 : length(IEN_s)
    nLineEle = size(IEN_s{ii}, 2);
    nvs = zeros(3, nLineEle);
    for kk = 1 : nLineEle
        nvs(3, kk) = IEN_s{ii}(3, kk);
        node1 = IEN_s{ii}(1, kk);
        node2 = IEN_s{ii}(2, kk);
        x_comp = msh.POS(node1, 1) - msh.POS(node2, 1);
        y_comp = msh.POS(node1, 2) - msh.POS(node2, 2);
        arc = sqrt(x_comp ^2 + y_comp ^2);
        tv = [x_comp/arc, y_comp/arc]';
        nv = Rotation_matrix * tv;
        
        node3 = IEN_s{ii}(4, kk);
        test_v_x = msh.POS(node1, 1) - msh.POS(node3, 1);
        test_v_y = msh.POS(node1, 2) - msh.POS(node3, 2);
        if test_v_x * nv(1) + test_v_y * nv(2) < 0
            nv = -nv;
        end
        
        nvs(1, kk) = nv(1);
        nvs(2, kk) = nv(2);
    end
    
    normals{ii} = nvs;
    
end

end

