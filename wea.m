
%% Berrechnung des optimalen Anstellwinkels %%
%%%%%%%%%%%%% Quelle: Kap. 6. Seite 50. Aerodynamics of wind turbines. Hansen. 2013. %%%%%%%%%

%% 1. vom User gegeben: messdaten_wea_user.txt%% als Bsp.

load messdaten_wea_user.txt

 R = messdaten_wea_user(:,1);         % Radius des Blattes               Spalte 1
 r = messdaten_wea_user(:,2);         % Vektor r (delta r)               Spalte 2
 z = messdaten_wea_user(:,3);         % Blattanzahl                      Spalte 3
 lamda_D = messdaten_wea_user(:,4);   % Schnelllaufzahl_ Design          Spalte 4
 p = messdaten_wea_user(:,5);         % Dichte                           Spalte 5
 v_1a = messdaten_wea_user(:,6);      % Luftgeschwindigkeit (Auslegung)  Spalte 6
 c_a = messdaten_wea_user(:,7);       % Auftriebsvektor                  Spalte 7
 c_w = messdaten_wea_user(:,8);       % Widerstandsvektor                Spalte 8
 alpha_0 = messdaten_wea_user(:,9);   % alpha aus den Datenbank vom User Spalte 9



%% 2. Iterationen um alpha zu berechnen %%
%% a_0 und a_1 sind jeweils a und a'. Siehe Gl. 6.7
% alpha der Antellwinkel
j   =size (messdaten_wea_user,1);
u   =lamda_D.*v_1a;
w   =u./R;
a_0 =linspace(0,1,j)';              % ich habe die Werte von a un a' als 
a_1 =linspace(0,1,j)';              % Vektor definiert / muessen aber nicht. war nur als Bsp
                                    % ansonsten einfach loeschen und beides
                                    % als 0 definieren

%% Hier sollte die for-Schleife starten %%
sigma = (c_r * z) / (2*pi*r);                              % c_r local chord (Profilzehne?) 
phi   = atand(((1-a_0).*v_1a/(1+a_1)*w.*r));               % Anstroemungswinkel
bauw  = ((2/3)*(atand(R./(lamda_D.*r))*(pi/180)))-phi;     % Bauwinkel (Thetha)
alpha = phi - bauw;                                        % Anstellwinkel 
c_ai = interp1(alpha_0,c_a,alpha);                         % findet den Auftriebbeiwert fuer den berechneten Wert von alpha
c_wi = interp1(alpha_0,c_w,alpha);                         % findet den Widerstandsbeiwert fuer den berechneten Wert von alpha
c_n = c_ai*cosd(phi) + c_wi*sind(phi);                     % Step 5 - c_n Wert aus Gl. 6.12
c_t = c_ai*sind(phi) - c_wi*cosd(phi);                     % Step 5 - c_t Wert aus Gl. 6.13
% Auswertung von a und a'
a_0i = 1 / (((4*sind(phi)^2) / (sigma*c_n))+1);            % Step 6 - Werte von a und a'
a_1i = 1 / ((4*sind(phi)*cosd(phi)) / (sigma*c_t))-1;


