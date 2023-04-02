function data = Input(filename)
% Input the data

fl = fopen(filename,'r');

while true
    dline = fgetl(fl);
    dline = Jump(dline, fl);
    
    if strcmp(dline, 'End of File')
        fclose(fl);
        break;
    end
    
    if strcmp(dline,'Problem Type:')
        protype = fgetl(fl);
        protype = Jump(protype, fl);
        data.ProType = str2double(protype);
    end
    
    if strcmp(dline,'Material Property:')
        E = fgetl(fl);
        E = Jump(E, fl);
        data.E = str2double(E);
        nu = fgetl(fl);
        nu = Jump(nu, fl);
        data.nu = str2double(nu);
    end
    
    if strcmp(dline, 'Quadrature Degree:')
        qd = fgetl(fl);
        qd = Jump(qd, fl);
        data.Quad_degree = str2double(qd);
    end
    
    if strcmp(dline,'Dirichlet Boundary:')
        nbDir = fgetl(fl);
        nbDir = Jump(nbDir, fl);
        data.nbDir = str2double(nbDir);
        if data.nbDir == 0
            continue;
        end
        data.DirBC = cell(data.nbDir, 3);
        B = fgetl(fl);
        B = Jump(B, fl);
        temp = 1;
        while strcmp(B,'End of DB') == 0
            data.DirBC{temp, 1} = B;
            BC = fgetl(fl);
            BC = Jump(BC, fl);
            while BC(1) == ' '
                BC(1) = [ ];
            end
            while BC(end) == ' '
                BC(end) = [ ];
            end
            data.DirBC{temp, 2} = BC(1);
            BC(1) = [ ];
            while isempty(BC) == 0
                if BC(1) == ' ' || BC(1) == data.DirBC{temp, 2}
                    BC(1) = [ ];
                else
                    data.DirBC{temp, 3} = BC(1);
                    break;
                end
            end
            B = fgetl(fl);
            B = Jump(B, fl);
            temp = temp + 1;
        end 
    end
    
    if strcmp(dline,'Neumann Boundary:')
        nbNeu = fgetl(fl);
        nbNeu = Jump(nbNeu, fl);
        data.nbNeu = str2double(nbNeu);
        if data.nbNeu == 0
            continue;
        end
        data.NeuBC = cell(data.nbNeu, 2);
        B = fgetl(fl);
        B = Jump(B, fl);
        temp = 1;
        while strcmp(B,'End of NB') == 0
            data.NeuBC{temp, 1} = B;
            BC = fgetl(fl);
            BC = Jump(BC, fl);
            if BC(1) == '@'
                data.NeuBC{temp, 2} = str2func(BC);
            else
                data.NeuBC{temp, 2} = str2double(BC);
            end
            B = fgetl(fl);
            B = Jump(B, fl);
            temp = temp + 1;
        end
    end
    
    if strcmp(dline,'Body force:')
        BF = fgetl(fl);
        BF = Jump(BF, fl);
        data.BodyF = str2func(BF);
    end
        
end

return;
end

