function PlotMesh(msh, IEN_v, sp_result, nb)
% To plot the mesh

max_x = max(msh.POS(:, 1)); min_x = min(msh.POS(:, 1));
max_y = max(msh.POS(:, 2)); min_y = min(msh.POS(:, 2));

nodes = [IEN_v(1, :), IEN_v(2, :), IEN_v(3, :)];
nodes = unique(nodes);
X = zeros(length(nodes), 1); Y = zeros(length(nodes), 1);
temp = 1;
for ii = 1 : msh.nbNod
    for jj = 1 : length(nodes)
        if ii == nodes(jj)
            X(temp) = msh.POS(ii, 1);
            Y(temp) = msh.POS(ii, 2);
            temp = temp + 1;
        end
    end
end

MESH = alphaShape(X, Y, 0.75 * sp_result.h, 'HoleThreshold', 1e-6);

figure(nb)
plot(MESH);
title('MESH', 'fontsize', 16);
xlabel('X - axis(m)', 'fontsize', 13); ylabel('Y - axis(m)', 'fontsize', 13);
axis([min_x max_x min_y max_y]);
set(gcf, 'unit', 'centimeters', 'position', [24 20 20 17.5]);

end

