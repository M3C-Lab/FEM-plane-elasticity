function [msh, data, info] = Preprocessor(msh_file, data_file)
addpath('Preprocess');

% Mesh configuration.
msh = load_gmsh2(msh_file);

% Data input.
data = Input(data_file);

disp('Mesh and condition imported.');

% ID array and Dirichlet nodes.
[info.ID, info.Dir_Nod] = get_ID(msh, data);

% IEN array of volumetric elements (plane elements).
info.IEN_v = get_IEN_v(msh, data.Elem_degree);

% LM array.
info.LM = get_LM(data.Elem_degree, info.ID, info.IEN_v);

disp('ID, IEN, LM arrays constructed.');


% IEN array of surface elements (line elements) on the Neumann boundaries.
info.IEN_s = get_IEN_s(msh, data, info.IEN_v);

% Outside normals of the elements on the Neumann boundaries.
info.normals = get_normals(msh, data.Elem_degree, info.IEN_v, info.IEN_s);

disp('Outside normals prepared.');

% The D matrix.
info.D = get_D(data);

% Quadrature points, weights and the number of points for parent triangular element.
[info.tqp, info.twq, info.ntqp] = TriQuad(data.Quad_degree);

% Quadreture points and weights for parent line element.
[info.lqp, info.lwq] = Gauss(data.Quad_degree, -1, 1);

return;

end

