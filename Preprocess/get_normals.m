function normals = get_normals(msh, Elem_degree, IEN_v, IEN_s)
% To get the outside normals of the elements on the Neumann boundaries.
% Output:
%   normals: The external normal vectors with respect to IEN_s (as a cell).
%       normals{i}: The normal vectors of the 'i'th Neumann boundary
%       normals{i}(*, e): The 'e'th element.
%       normals{i}(1, e): The x-direction component of the vector
%       normals{i}(2, e): The y-direction component of the vector
%       normals{i}(3, e): Which triangular element the 'e'th line element 
%                          is located at.

normals = cell(1, length(IEN_s));
Rotation_matrix = [0, -1;
                   1,  0];

for ii = 1 : length(IEN_s)
    nLineEle = size(IEN_s{ii}, 2);
    nvs = zeros(3, nLineEle);
    for jj = 1 : nLineEle
        node1 = IEN_s{ii}(1, jj);
        node2 = IEN_s{ii}(2, jj);
        x_comp = msh.POS(node1, 1) - msh.POS(node2, 1);
        y_comp = msh.POS(node1, 2) - msh.POS(node2, 2);
        arc = sqrt(x_comp ^2 + y_comp ^2);
        tv = [x_comp/arc, y_comp/arc]';
        nv = Rotation_matrix * tv;
        
        if Elem_degree == 1
            nvs(3, jj) = IEN_s{ii}(3, jj); % ee
            nodes = [1, 2, 3];
        elseif Elem_degree == 2
            nvs(3, jj) = IEN_s{ii}(4, jj); % ee
            nodes = [1, 2, 3, 4, 5, 6];
        end
        
        for kk = 1 : (Elem_degree + 1)
            for mm = 1 : length(nodes)
                if IEN_v(nodes(mm), nvs(3, jj)) == IEN_s{ii}(kk, jj)
                    nodes(mm) = [ ];
                    % Exclude the nodes on Neumann boundary in order to
                    % find a node inside the domain.
                    break;
                end
            end
        end
        
        node3 = IEN_v(nodes(1), nvs(3, jj));

        test_v_x = msh.POS(node1, 1) - msh.POS(node3, 1);
        test_v_y = msh.POS(node1, 2) - msh.POS(node3, 2);
        if test_v_x * nv(1) + test_v_y * nv(2) < 0
            nv = -nv;
        end
        
        nvs(1, jj) = nv(1);
        nvs(2, jj) = nv(2);
    end
    
    normals{ii} = nvs;
    
end

end

