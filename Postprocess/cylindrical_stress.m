function  sigma_cyl = cylindrical_stress(sigma_Car, theta)
% To obtain the cylindrical stress from Cartesian stress for example4.2.
% Input:
%   sigma_Car: [考_xx, 考_yy, 而_xy]' from the trial solution.
%   theta: The angle given by cylindrical_coor.m .
% Output:
%   sigma_cyl: [考_rr, 考_牟牟, 而_r牟]' from the trial solution.

sx = sigma_Car(1);
sy = sigma_Car(2);
txy = sigma_Car(3);

sigma_rr = 0.5 * (sx + sy) + 0.5 * (sx - sy) * cos(2 * theta) + txy * sin(2 * theta);
sigma_tt = 0.5 * (sx + sy) - 0.5 * (sx - sy) * cos(2 * theta) - txy * sin(2 * theta);
tao_rt = 0.5 * (sy - sx) * sin(2 * theta) + txy * cos(2 * theta);

sigma_cyl = [sigma_rr; sigma_tt; tao_rt]';

end

