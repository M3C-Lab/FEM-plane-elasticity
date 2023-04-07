clc; clear all; close all;
addpath('Postprocess');

tic;
disp('(1) Input data and preprocess.');
[msh, data, info] = Preprocessor('./Input/Square.msh', './Input/Square.txt');
toc;
fprintf('\n');

tic;
disp('(2) Construct stiffness K and load F.');
[K, F] = Assembly(msh, data, info);
toc;
fprintf('\n');

tic;
disp('(3) Solve the matrix equation.');
uh = Solver(msh, info, K, F);
toc;
fprintf('\n');

tic;
disp('(4) Postprocess.')
sp_points = 30; % The number of sampling points in each element.
frame = 'Car'; % 'Car'-- Cartesian, 'Cyl'-- cylindrical.

sp_result = Post_sampler(msh, data.Elem_degree, info, uh, sp_points, frame);
PlotSampling(sp_result, 1, '考_x_x', 1);
PlotSampling(sp_result, 2, '考_y_y', 2);
PlotSampling(sp_result, 3, '而_x_y', 3);
% The second parameter:
% 1 -- 考xx, 2 -- 考yy, 3 -- 而xy in Cartesian frame.
% 1 -- 考rr, 2 -- 考牟牟, 3 -- 而r牟 in cylindrical frame.
% The third parameter: The title of figure.
% The last parameter: The number of figure.

PlotMesh(msh, info.IEN_v, sp_result, 4);
% The last parameter: The number of figure.

toc;
disp('Done!');
