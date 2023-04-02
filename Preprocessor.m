function [msh, data, info] = Preprocessor(msh_file,data_file)
addpath('Preprocess');

% Mesh configuration.
msh = load_gmsh2(msh_file);

% Data input.
data = Input(data_file);

% ID array and Dirichlet nodes.
[info.ID, info.Dir_Nod] = get_ID(msh, data);

% IEN array of volumetric elements (plane elements).
info.IEN_v = get_IEN_v(msh);

% IEN array of surface elements (line elements) on the Neumann boundaries.
info.IEN_s = get_IEN_s(msh, data, info.IEN_v);

% LM array.
info.LM = get_LM(info.ID, info.IEN_v);

% Outside normals of the elements on the Neumann boundaries.
info.normals = get_normals(msh, info.IEN_s);

% The D matrix.
info.D = get_D(data);

% Quadrature points, weights and the number of points for parent triangular element.
[info.tqp, info.twq, info.ntqp] = TriQuad(data.Quad_degree);

% Quadreture points and weights for parent line element.
[info.lqp, info.lwq] = Gauss(data.Quad_degree, -1, 1);

return;

end

