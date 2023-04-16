function PlotSampling(sp_result, obj, figure_title, nb)
% To plot the sampling data.

X = sp_result.Location(:, 1);
Y = sp_result.Location(:, 2);
object = sp_result.Stress(:, obj);

SHP = alphaShape (X, Y, 0.75 * sp_result.h_meshsize, 'HoleThreshold', 1e-6);
TRI = alphaTriangulation(SHP);

figure(nb)
patch('Faces', TRI, 'Vertices', [X, Y], 'facevertexCdata', object, ...
    'edgecolor', 'none', 'facecolor', 'interp');
title(figure_title, 'fontsize', 16);
xlabel('X - axis(m)', 'fontsize', 13); ylabel('Y - axis(m)', 'fontsize', 13);
colormap('jet');
col = colorbar;
set(get(col, 'title'), 'string', '(pa)', 'fontsize', 12);
set(col, 'Fontsize', 12);
set(gcf, 'unit', 'centimeters', 'position', [3 20 20 17.5]);

end

% EOF
