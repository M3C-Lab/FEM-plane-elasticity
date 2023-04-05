function LM = get_LM(Elem_degree, ID, IEN)
% To get the LM array.

nbEle = size(IEN, 2);
LM = zeros(6 * Elem_degree, nbEle);
for ii = 1 : nbEle
    for jj = 1 : 3 * Elem_degree
        for kk = 1 : 2
            LM(2*(jj-1)+kk , ii) = ID(kk, IEN(jj, ii));
        end
    end
end

end

