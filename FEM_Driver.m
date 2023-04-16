clc; clear all; close all;
addpath('Input','Preprocess', 'Assembly&Solving', 'Postprocess');

tic;
disp('(1) Input data and preprocess.');
[msh, data, info] = Preprocessor('Square.msh', 'Square.txt');
toc;
fprintf('\n');

tic;
disp('(2) Assemble stiffness K and load F.');
[K_stif, F_load] = Assembler(msh, data, info);
toc;
fprintf('\n');

tic;
disp('(3) Solve the matrix equation.');
uh = Solver(msh, info, K_stif, F_load);
toc;
fprintf('\n');

tic;
disp('(4) Postprocess.')

n_sp = 5; 
% The integral n_sp >= 0, 
% which controls the number of sampling points in each triangle.

frame = 'Car'; 
% 'Car'-- Cartesian, 'Cyl'-- cylindrical.

sp_result = Sampler(msh, data.Elem_degree, info, uh, n_sp, frame);
PlotSampling(sp_result, 1, 'sigma_x_x', 1);
PlotSampling(sp_result, 2, 'sigma_y_y', 2);
PlotSampling(sp_result, 3, 'sigma_x_y', 3);
% The second parameter:
% 1 -- sigma_x_x, 2 -- sigma_y_y, 3 -- tao_x_y in Cartesian frame.
% 1 -- sigma_r_r, 2 -- sigma_theta_theta, 3 -- tao_r_theta in cylindrical frame.
% The third parameter: The title of figure.
% The last parameter: The number of figure.

PlotMesh(msh, info.IEN_v, sp_result, 4);
% The last parameter: The number of figure.

toc;
disp('Done!');

% EOF
