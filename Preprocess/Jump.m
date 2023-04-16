function txt = Jump(txt, fl)
% Jump over the empty line, the line with only blank mark and annotations.
while true
    if isempty(txt)
        txt = fgetl(fl);
    elseif txt(1) == ' '
        txt(1) = [ ];
        continue;
    elseif txt(1) == '#'
        txt = fgetl(fl);
    elseif txt(end) == ' '
        txt(end) = [ ];
        continue;
    else
        break;
    end
end
end

% EOF