clc; clear all; close all;
addpath('Postprocess');

tic;
disp('(1) Input data and preprocess.');
[msh, data, info] = Preprocessor('Tunnel.msh', 'DataInput.txt');
toc;

tic;
disp('(2) Construct stiffness K and load F.');
[K, F] = Constructor(msh, data, info);
toc;

tic;
disp('(3) Solve the matrix equation.');
uh = Solver(msh, info, K, F);
toc;

tic;
disp('(4) Postprocess.')
sp_points = 10; % The number of sampling points in each element.
frame = 'Cyl'; % 'Car'-- Cartesian, 'Cyl'-- cylindrical.

sp_result = Post_sampler(msh, info, uh, sp_points, frame);
PlotSampling(sp_result, 1, '考_r_r', 1);
PlotSampling(sp_result, 2, '考_牟_牟', 2);
% The second parameter:
% 1 -- 考xx, 2 -- 考yy, 3 -- 而xy in Cartesian frame.
% 1 -- 考rr, 2 -- 考牟牟, 3 -- 而r牟 in cylindrical frame.
% The third parameter: The title of figure.
% The last parameter: The number of figure.

PlotMesh(msh, sp_result, 3);
% The last parameter: The number of figure.

toc;
disp('Done!');