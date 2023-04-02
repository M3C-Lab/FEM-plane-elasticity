function D = get_D(data)
% To generate the D matrix.

lamda = data.nu * data.E / ((1 + data.nu) * (1 - 2 * data.nu));
mu = 0.5 * data.E / (1 + data.nu);
if data.ProType == 1
    lamda = 2 * lamda * mu / (lamda + 2 * mu);
end

D = [lamda + 2 * mu, lamda, 0;
    lamda, lamda + 2 * mu, 0;
    0, 0, mu];

end

