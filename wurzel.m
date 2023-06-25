function [BW] = wurzel(h,r_w,zen,punkte)
    %% Wurzelparameter
    % Eingabeparameter
           % h - Hoehe der Wurzel in m
           % r_w - Radius der Wurzel
           % zen - Zentrum / oder Auffaedelungspunkt (muss Vektor [x,y] sein)
           % punkte - Punktenanzahl / aufloesung
    
    z = ones(1,punkte);                  % Inizialisierung der z-Achse
    
    u = linspace(0,2*pi,punkte);         % Position
    
    %% X und Y Koordinaten
    x = zen(1) + r_w * sin(u);       
    y = zen(2) + r_w * cos(u);
    
    % Koordinaten werden gespeichert
    koor (:,1) = x;
    koor (:,2) = y;
    
    BW= cell(1,h);                     	 % Preallocation Blatwurzel
    %% Z-Koordinaten
    for i = 1 : h
        z = (i-1) * z;
        koor(:,3) = z;              % z-Koordinaten werden zur entsprechenden Matrix beigefuegt
        BW(1,i) = {koor};           % die Matrizen für jede Höhe werden gespeichert
        z = ones(1,punkte);
    end
    
    %% Darstellung
    figure (1)
    for i = 1 : h
        plot3(x,y,BW{i}(:,3))       % Darstellung der Blattwurzel entlang eines Auffaedelungsachse (Zentrum)
        hold on
    end
    plot3 (zen(1),zen(2),0,'-*')
    grid on
    zlabel('Wurzelhöhe')
    title('Skellet-Darstellung Rotorwurzel')
    hold off

end
%axis equal