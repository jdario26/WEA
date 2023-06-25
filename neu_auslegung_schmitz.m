function [t,Theta] = neu_auslegung_schmitz(z,R,lam_A, profile, N, opt)
    
    ubp = size(profile,2);        % Anzahl der Umbruchspunkte
    n1 = round(N / ubp);          % Umbruchspunkt des Profils für jetzt, aber das sollte von User beliebig gegeben werden.
    ub = zeros(1, ubp) ;          % erster Wert 1 -  Blattwurzel
    % ub(1,1) = 5 ;
    for j = 1 : ubp
        %ub(1,j+1) = n1*j + ub(1,1); % Umbruchspunkte von Profilen
        ub(1,j) = n1*j;            % Umbruchspunkte von Profilen
    end
    
    % dcl(1) = 0;         % fuer die Wurzel
    for j = 1 : ubp - 1
        dcl (j)= (opt(j+1,2) - opt(j,2)) / (ub(j+1) - ub(j));  % Zwischenprofile
    end
    % dcl (j+2) = 0;          % letztes Profil
    dcl (j+1) = 0;
    
    cl_A = zeros(1, N);
    alpha_A = zeros(1, N);
    %position1 = [1: ub(1)];
    %position2 = [ub(1)+1 : ub(2)];
    %position3 = [ub(2)+1: ub(3)]
    for j = 1:ubp
            for k = 1:n1
                cl_A(ub(j)-(n1-k)) = opt(j, 2) + dcl(j) * (k-1);
                alpha_A(ub(j)-(n1-k)) = opt(j,1);
            end
    end
    
    r = linspace(1, R, N);     % laufender Radius    
    
    % Blattiefe nach Schmitz
    t = (16*pi) ./(z * cl_A) .* r .* sind(1/3 *(atand(R./(lam_A * r)))).^2;
    
    % Bauwinkel nach Schmitz
    Theta = atand(2/3 * R ./(lam_A * r)) - alpha_A;
    
    figure (2)
    plot(r, t)
    hold on
    plot(r, Theta)
    grid("on")
    hold on
    legend('Blatttiefe', 'Bauwinkel')
    xlabel('Rotorradius [m]')
    title('Blatttiefe & Bauwinkel over Radius')
end



