function Cylindrical = cylindrical_coor(Cartesian)
% To obtain the cylindrical coordinates in example4.2.
% Input:
%   Cartesian: [x; y] coordinates.
% Output:
%   Cylindrical: [r; theta] coordinates.

r = sqrt(Cartesian(1)^2 + Cartesian(2)^2);

if Cartesian(1) == 0
    if Cartesian(2) > 0
        theta = 0.5 * pi;
    else
        theta = 0.5 * pi;
    end
else
    theta = atan(Cartesian(2)/ Cartesian(1));
    if Cartesian(1) < 0
        theta = theta + pi;
    end
end

Cylindrical = [r; theta];

end

% EOF
