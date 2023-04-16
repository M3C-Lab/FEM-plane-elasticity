function PrintData(msh, data)
fprintf('\n');

if data.ProType == 1
    pt = 'stress';
elseif data.ProType == 0
    pt = 'strain';
end
fprintf('This is a plain %s problem.\n\n', pt);

fprintf('The degree of the elements: %d\n', data.Elem_degree);

if data.Elem_degree == 1
    nElem = msh.nbTriangles;
elseif data.Elem_degree == 2
    nElem = msh.nbTriangles6;
end
fprintf('The number of the triangular elements: %d\n', nElem);
fprintf('The number of the nodes: %d\n\n', msh.nbNod);

fprintf("The Young's modulus: %f\n", data.E_Youngs);
fprintf("The Poisson's ratio: %f\n\n", data.nu);

if data.nbDir ~= 0
    fprintf('The Dirichlet boundaries:');
    for ii = 1 : data.nbDir
        fprintf('\n%s', data.DirBC{ii, 1});
        for jj = 2 : 3
            if isempty(data.DirBC{ii,jj}) ~= 1
                fprintf('  %s', data.DirBC{ii, jj});
            end
        end
    end
    fprintf('\n\n');
end

if data.nbNeu ~= 0
    fprintf('The Neumann boundaries:\n');
    for ii = 1 : data.nbNeu
        fprintf('%s\n',data.NeuBC{ii, 1})
    end
    fprintf('\n');
end

end

% EOF