
%% Berrechnung des optimalen Anstellwinkels %%
%%%%%%%%%%%%% Quelle: Kap. 6. Seite 50. Aerodynamics of wind turbines. Hansen. 2013. %%%%%%%%%
%%%%%%%%%%%%% Bsp. Profil NACA 4415 , RE= 1'000.000 %%%%%%%%%%%%%%%%%

%% 1. vom User gegeben: messdaten_wea_user.txt%% als Bsp.

daten = csvread('S801re10h6.csv',11);

 R = 80 ;                     % Radius des Blattes
 z = 3 ;                      % Blattanzahl
 lam_A = 9 ;                  % Schnelllaufzahl_ Design
 rho = 1.204 ;                  % Dichte
 v_1a = 10;                   % Luftgeschwindigkeit (Auslegung)
 cl1_A = 1;                   % Auftriebsbeiwert Blattwurzel (1. Profil)
 cl2_A = 0.7;                 % Auftriebsbeiwert Mitte (2. Profil)
 cl3_A = 1.1;                 % Auftriebsbeiwert Blattspitze (3. Profil)
 N = size (daten,1);          % Anzahl Laufschritte über Blatt
 alpha_0 = 5.15;              %alpha_0 = daten(:,1);   % alpha aus den Datenbank vom User     Spalte 1
 alpha_po = daten(:,1);       % alpha aus den Datenbank vom User     Spalte 1
 c_a = daten(:,2)';           % Auftriebsbeiwertvektor               Spalte 2
 c_w = daten(:,3)';           % Widerstandsbeiwertvektor             Spalte 3
 aufl= R/size(daten,1);
 r = (aufl:aufl:R)' ;                   % Vektor r (delta r)
 
 
 

%% Blattgeometrie nach Schmitz %%
[t,Theta]= auslegung_schmitz(z, R, lam_A, cl1_A, cl2_A, cl3_A, N);
t = t';

%% 2. Iterationen 
%% a_0 und a_1 sind jeweils a und a'. Siehe Gl. 6.7
% alpha ist der Antellwinkel

u   = lam_A.*v_1a;
w   = u./R;


for j = 1:size(r,1)
    %disp(j)
    % Anfangswerte von a und a'
    a_0 = 0;    
    a_1 = 0;   
    
    a_02 = 0.5;
    a_12 = 0.5;
    
    conv = 1e-4;    % Konvergenzkriterium
    
    i = 1;          % laufvariabel
    i_max = 40;     % Abbruchvariabel Zyklus
    
    while (abs(a_02-a_0)>conv || abs(a_0-a_12)>conv) && i <i_max
    
    sigma = (t(j) .* z) / (2*pi*r(j));                              % c_r local chord (Profilzehne?) 
    phi   = atand(((1-a_0).*v_1a/(1+a_1)*w*r(j)));                  % Anstroemungswinkel
    
    alpha = phi - Theta(j);                                         % Anstellwinkel

    if alpha > alpha_po (N)
        alpha = alpha_po (N);
    end
    if alpha < alpha_po (1)
        alpha = alpha_po (1);
    end
    c_ai = interp1(alpha_po,c_a,alpha);                        % findet den Auftriebbeiwert fuer den berechneten Wert von alpha
    c_wi = interp1(alpha_po,c_w,alpha);                        % findet den Widerstandsbeiwert fuer den berechneten Wert von alpha
    c_n = c_ai*cosd(phi) + c_wi*sind(phi);                     % Step 5 - c_n Wert aus Gl. 6.12
    c_t = c_ai*sind(phi) - c_wi*cosd(phi);                     % Step 5 - c_t Wert aus Gl. 6.13
    % Auswertung von a und a'
    a_0 = 1 / (((4*sind(phi)^2) / (sigma*c_n))+1);            % Step 6 - Werte von a und a'
    a_1 = 1 / ((4*sind(phi)*cosd(phi)) / (sigma*c_t)-1);
    
    %a_0(i) = a_0;
    %a_1(i) = a_1;
    
    i = i + 1;
    
    end

    d_T (j,1)= ((rho * z * v_1a^2 * (1 - a_0)^2) * c_n * t(j) * aufl) / (2 * (sind(phi)^2));
    
    d_M (j,1)= (rho * z * v_1a*(1 - a_0) * w * r(j) * (1 + a_1) * c_t * r(j) * t(j) * aufl )/ (2 * (sind(phi) * cosd(phi)));

end
