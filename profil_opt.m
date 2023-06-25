
function [profil, opt] = profil_opt(daten1, daten2, daten3)
profil = {daten1, daten2, daten3};
opt = [];

for i= (1:3)
    [cl_A, alpha_A] = alpha_cl(profil{i});    % alpha_0 = daten(:,1);   % alpha aus den Datenbank vom User     Spalte 1
    opt(i,1) = cl_A;
    opt(i,2) = alpha_A;
end
     
       
    function [alpha_A cl_A] = alpha_cl(daten)
        c_a = daten(:,2)';           % Auftriebsbeiwertvektor               Spalte 2
        c_w = daten(:,3)';           % Widerstandsbeiwertvektor             Spalte 3
        
        [numRows,numCols] = size(daten);        
        numCols = numCols + 1;
        
        daten(:, numCols) = c_a ./ c_w;         % neue Spalte für Gleitzahl
        [M, I] = max(daten(:,numCols));         % Index für max. Gleitzahl
        alpha_A = daten(I,1);                    % Alpha(max(Gleitzahl))
        cl_A = daten(I, 2);
    end
profil
opt
end