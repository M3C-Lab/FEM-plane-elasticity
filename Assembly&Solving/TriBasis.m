function poly = TriBasis(degree, i, der_x, der_y, x, y, phys2rst)
% To get the basis function or the derivative over a triangular element.
% phys2rst provides the AREA COORDINATES, which are crucial for the basis functions.
% This formulation is on the pages of 167 ~ 168 of Hughes' book.
% Input:
%   degree: the degree of triangular element, 1 ~ 2
%   i: the number of the basis function, 1 ~ 3.
%   der: the derivative required.
%       0 --- the value of basis function.
%       1 --- the 1st partial derivative of the basis function.
%       2 --- the 2nd partial derivative of the basis function.
%   x, y: The points position in the triangular element.
%   phys2rst: The mapping matrix given by Mapping_p2rst.m .
% Output:
%   poly: The value of basis function or derivative.

r = phys2rst(1, 1) * x + phys2rst(1, 2) * y + phys2rst(1, 3);
s = phys2rst(2, 1) * x + phys2rst(2, 2) * y + phys2rst(2, 3);
t = phys2rst(3, 1) * x + phys2rst(3, 2) * y + phys2rst(3, 3);

if degree == 1
    if i == 1
        if der_x == 0 && der_y == 0
            poly = r;
        elseif der_x == 1 && der_y == 0
            poly = phys2rst(1, 1);
        elseif der_x == 0 && der_y == 1
            poly = phys2rst(1, 2);
        else
            poly = 0;
        end

    elseif i == 2
        if der_x == 0 && der_y == 0
            poly = s;
        elseif der_x == 1 && der_y == 0
            poly = phys2rst(2, 1);
        elseif der_x == 0 && der_y == 1
            poly = phys2rst(2, 2);
        else
            poly = 0;
        end

    elseif i == 3
        if der_x == 0 && der_y == 0
            poly = t;
        elseif der_x == 1 && der_y == 0
            poly = phys2rst(3, 1);
        elseif der_x == 0 && der_y == 1
            poly = phys2rst(3, 2);
        else
            poly = 0;
        end

    else
        disp("TriBasis: Please input appropriate node number.")
    end
    
elseif degree == 2
    if i == 1
        if der_x == 0 && der_y == 0
            poly = r * (2 * r - 1);
        elseif der_x == 1 && der_y == 0
            poly = (4 * r - 1) * phys2rst(1, 1);
        elseif der_x == 0 && der_y == 1
            poly = (4 * r - 1) * phys2rst(1, 2);
        elseif der_x == 2 && der_y == 0
            poly = 4 * phys2rst(1, 1) * phys2rst(1, 1);
        elseif der_x == 0 && der_y == 2
            poly = 4 * phys2rst(1, 2) * phys2rst(1, 2);
        elseif der_x == 1 && der_y == 1
            poly = 4 * phys2rst(1, 1) * phys2rst(1, 2);
        else
            poly = 0;
        end

    elseif i == 2
        if der_x == 0 && der_y == 0
            poly = s * (2 * s - 1);
        elseif der_x == 1 && der_y == 0
            poly = (4 * s - 1) * phys2rst(2, 1);
        elseif der_x == 0 && der_y == 1
            poly = (4 * s - 1) * phys2rst(2, 2);
        elseif der_x == 2 && der_y == 0
            poly = 4 * phys2rst(2, 1) * phys2rst(2, 1);
        elseif der_x == 0 && der_y == 2
            poly = 4 * phys2rst(2, 2) * phys2rst(2, 2);
        elseif der_x == 1 && der_y == 1
            poly = 4 * phys2rst(2, 1) * phys2rst(2, 2);
        else
            poly = 0;
        end

    elseif i == 3
        if der_x == 0 && der_y == 0
            poly = t * (2 * t - 1);
        elseif der_x == 1 && der_y == 0
            poly = (4 * t - 1) * phys2rst(3, 1);
        elseif der_x == 0 && der_y == 1
            poly = (4 * t - 1) * phys2rst(3, 2);
        elseif der_x == 2 && der_y == 0
            poly = 4 * phys2rst(3, 1) * phys2rst(3, 1);
        elseif der_x == 0 && der_y == 2
            poly = 4 * phys2rst(3, 2) * phys2rst(3, 2);
        elseif der_x == 1 && der_y == 1
            poly = 4 * phys2rst(3, 1) * phys2rst(3, 2);
        else
            poly = 0;
        end
        
    elseif i == 4
        if der_x == 0 && der_y == 0
            poly = 4 * r * s;
        elseif der_x == 1 && der_y == 0
            poly = 4 * s * phys2rst(1, 1) + 4 * r * phys2rst(2, 1);
        elseif der_x == 0 && der_y == 1
            poly = 4 * s * phys2rst(1, 2) + 4 * r * phys2rst(2, 2);
        elseif der_x == 2 && der_y == 0
            poly = 8 * phys2rst(1, 1) * phys2rst(2, 1);
        elseif der_x == 0 && der_y == 2
            poly = 8 * phys2rst(1, 2) * phys2rst(2, 2);
        elseif der_x == 1 && der_y == 1
            poly = 4 * (phys2rst(2, 2) * phys2rst(1, 1) + phys2rst(1, 2) * phys2rst(2, 1));
        else
            poly = 0;
        end
        
    elseif i == 5
        if der_x == 0 && der_y == 0
            poly = 4 * s * t;
        elseif der_x == 1 && der_y == 0
            poly = 4 * t * phys2rst(2, 1) + 4 * s * phys2rst(3, 1);
        elseif der_x == 0 && der_y == 1
            poly = 4 * t * phys2rst(2, 2) + 4 * s * phys2rst(3, 2);
        elseif der_x == 2 && der_y == 0
            poly = 8 * phys2rst(3, 1) * phys2rst(2, 1);
        elseif der_x == 0 && der_y == 2
            poly = 8 * phys2rst(3, 2) * phys2rst(2, 2);
        elseif der_x == 1 && der_y == 1
            poly = 4 * (phys2rst(3, 2) * phys2rst(2, 1) + phys2rst(2, 2) * phys2rst(3, 1));
        else
            poly = 0;
        end
        
    elseif i == 6
        if der_x == 0 && der_y == 0
            poly = 4 * r * t;
        elseif der_x == 1 && der_y == 0
            poly = 4 * t * phys2rst(1, 1) + 4 * r * phys2rst(3, 1);
        elseif der_x == 0 && der_y == 1
            poly = 4 * t * phys2rst(1, 2) + 4 * r * phys2rst(3, 2);
       elseif der_x == 2 && der_y == 0
            poly = 8 * phys2rst(3, 1) * phys2rst(1, 1);
        elseif der_x == 0 && der_y == 2
            poly = 8 * phys2rst(3, 2) * phys2rst(1, 2);
        elseif der_x == 1 && der_y == 1
            poly = 4 * (phys2rst(3, 2) * phys2rst(1, 1) + phys2rst(1, 2) * phys2rst(3, 1));
        else
            poly = 0;
        end

    else
        disp("TriBasis: Please input appropriate node number.")
    end
end

end

% EOF
