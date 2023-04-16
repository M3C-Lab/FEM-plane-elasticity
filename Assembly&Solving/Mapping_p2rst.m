function phys2rst = Mapping_p2rst(p1, p2, p3)
% To get mapping matrice between the physical space and (r,s,t) space.
% Input:
%   p1, p2, p3: The points in the physical space.
%       Each of them should be a array: [x, y]
%       If three points are on a line (cannot create a triangle) in a space,
%       this formulation would fail.
% Output:
%   phys2rs: The mapping matrix from physical space to (r,s,t) space.
%       r = phys2rs(1,1) * x + phys2rs(1,2) * y + phys2rs(1,3)
%       s = phys2rs(2,1) * x + phys2rs(2,2) * y + phys2rs(2,3)
%       t = phys2rs(3,1) * x + phys2rs(3,2) * y + phys2rs(3,3)

% If we require the inverse mapping in the linear element:
%   x = x1 * r + x2 * s + x3 * t
%   y = y1 * r + y2 * s + y3 * t
%  where N1 = r, N2 = s, N3 = t.
% But in the quadratic element:
%   x = x1 * r + x2 * s + x3
%     = x1 * N1 + x2 * N2 + x3 * N3 + x4 * N4 + x5 * N5 + x6 * N6
% The basis functions should be derived carefully.

a1 = p2(1) * p3(2) - p3(1) * p2(2);
b1 = p2(2) - p3(2);
c1 = -p2(1) + p3(1);
a2 = p3(1) * p1(2) - p1(1) * p3(2);
b2 = p3(2) - p1(2);
c2 = -p3(1) + p1(1);
a3 = p1(1) * p2(2) - p2(1) * p1(2);
b3 = p1(2) - p2(2);
c3 = -p1(1) + p2(1);

coeffient_matrix = [1, p1(1), p1(2); 1, p2(1), p2(2); 1, p3(1), p3(2)];
A = 0.5 * det(coeffient_matrix);

phys2rst = zeros(3, 3);

phys2rst(1, 1) = 0.5 * b1 / A;
phys2rst(1, 2) = 0.5 * c1 / A;
phys2rst(1, 3) = 0.5 * a1 / A;

phys2rst(2, 1) = 0.5 * b2 / A;
phys2rst(2, 2) = 0.5 * c2 / A;
phys2rst(2, 3) = 0.5 * a2 / A;

phys2rst(3, 1) = 0.5 * b3 / A;
phys2rst(3, 2) = 0.5 * c3 / A;
phys2rst(3, 3) = 0.5 * a3 / A;

end

% EOF
