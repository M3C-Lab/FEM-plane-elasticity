function PlotMesh(msh, sp_result, nb)
% To plot the mesh

max_x = max(msh.POS(:, 1)); min_x = min(msh.POS(:, 1));
max_y = max(msh.POS(:, 2)); min_y = min(msh.POS(:, 2));
MESH = alphaShape(msh.POS(:, 1), msh.POS(:, 2), 0.75 * sp_result.h, 'HoleThreshold', 1e-6);

figure(nb)
plot(MESH);
title('MESH', 'fontsize', 16);
xlabel('X - axis(m)', 'fontsize', 13); ylabel('Y - axis(m)', 'fontsize', 13);
axis([min_x max_x min_y max_y]);
set(gcf, 'unit', 'centimeters', 'position', [24 20 20 17.5]);

end

