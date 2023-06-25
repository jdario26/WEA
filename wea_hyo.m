
%% Berrechnung des optimalen Anstellwinkels %%
% Quelle: Kap. 6. Seite 50. Aerodynamics of wind turbines. Hansen. 2013.
% ausgewählte Profile mit RE = 1'000.000
%% Wurzel
% Parameter

h = 5;
r_w = 3;
zen = [0,0];
punkte = 60;

[BW] = wurzel(h,r_w,zen,punkte);


%% 1. vom User gegeben: messdaten_wea_user.txt%% als Bsp.

daten1 = csvread('S801re10h6.csv',11);
daten2 = csvread('S802re10h6.csv',11);
daten3 = csvread('S803re10h6.csv',11);

[profile, opt] = profil_opt(daten1, daten2, daten3);

R = 60 ;                     % Radius des Blattes
z = 3 ;                      % Blattanzahl
lam_A = 7;                   % Schnelllaufzahl_ Design
rho = 1.204 ;                % Dichte
v_1a = 10;                   % Luftgeschwindigkeit (Auslegung)

n = 20;                      % Anzahl der Blattabschnitte pro Profil
N = size(profile,2) * n;     % Anzahl Blattabschnitte pro Rotorblatt

%% Blattgeometrie nach Schmitz %%
[t,Theta]= neu_auslegung_schmitz(z, R, lam_A, profile, N, opt);
t = t';

%% 2. BEM Iterationen 
% a_0 und a_1 sind jeweils a und a'. Siehe Gl. 6.7
% alpha ist der Anstellwinkel

u   = lam_A * v_1a;             % Umfangsgeschwindigkeit am Spitze
w   = u/R;                      % Omega = Winkelgeschwindigkeit

r = R/N;
r_loc = 1:r:N;

for i = 1 :size(profile,2)
    for j = 1:n                              % Anzahl der Blattabschnitte pro Profil 
        pos = n*(i-1)+j;                     % lokaler Radius der Blattabschnitte
        sigma = (t(pos) * z) / (2 * pi * r_loc(pos));                           % Sigma: Solidität , t(pos): lokale Blatttiefe 
    
            % Anfangswerte von a und a'
        a_0 = 0;                    % axial induktionsfaktor
        a_1 = 0;                    % tangential induktionsfaktor
        
        conv = 1e-4;                % Konvergenzkriterium
        k = 1;                      % laufvariabel
        k_max = 40;                 % Abbruchvariabel Zyklus
        a_02 = 0.5;                 % initialisierung um die Konvergenzkriterium zu beipassen
        a_12 = 0.5;                 % initialisierung um die Konvergenzkriterium zu beipassen
    
        while (abs(a_02 - a_0) > conv || abs(a_12 - a_1) > conv) && k < k_max          % Konvergenz Prüfung
            phi   = atand(((1 - a_0)*v_1a) / ((1 + a_1)* w * r_loc(pos)));             % Anstroemungswinkel
            alpha = phi - Theta(pos);                                                  % Anstellwinkel
                  
            % Maximal- & Minimalwerte für alpha zu bestimmen
            if alpha > profile{i}(end,1) 
                alpha = profile{i}(end,1);
            end
            if alpha < profile{i}(1,1)
                alpha = profile{i}(1,1);
            end
    
            %Interpolierte c_a und c_w
            c_ai = interp1(profile{i}(:,1),profile{i}(:,2),alpha);     % Interpolierte c_a (2. Spalte von Profildaten)
            c_wi = interp1(profile{i}(:,1),profile{i}(:,3),alpha);     % Interpolierte c_w (3. Spalte von Profildaten)
            c_n = c_ai*cosd(phi) + c_wi*sind(phi);                     % Step 5 - c_n Wert aus Gl. 6.12
            c_t = c_ai*sind(phi) - c_wi*cosd(phi);                     % Step 5 - c_t Wert aus Gl. 6.13
            
            % Schieben die Werte a und a' als Konvergenzkriterium
            a_02 = a_0;
            a_12 = a_1;
    
            % Neue Werte von a und a'
            a_0 = 1 / (((4*sind(phi)^2) / (sigma*c_n))+1);            % Step 6 - Werte von a und a'
            a_1 = 1 / ((4*sind(phi)*cosd(phi)) / (sigma*c_t)-1);
    
            k = k + 1;
        end
       
    % Werte speichern
    values(pos,1) = phi;
    values(pos,2) = alpha;
    values(pos,3) = a_0;
    values(pos,4) = a_1;

    %% Schubkraft & Moment für jede Blattabschnitt zu   ***** Hier fehlt noch den Korrekturfaktor
    d_T(pos,1) = (rho * z * v_1a^2 * (1 - a_0)^2 * c_n * t(pos) * r) / (2 * (sind(phi)^2));
    d_M(pos,1) = (rho * z * v_1a * (1 - a_0) * w * r_loc(pos) * (1 + a_1) * c_t * r_loc(pos) * t(pos) * r)/ (2 * (sind(phi) * cosd(phi)));
    
    F_st(pos,1) = rho / 2 * v_1a^2 * pi * r_loc(pos)^2;
    c_T(pos,1) = d_T(pos) / F_st(pos);
    c_M(pos,1) = d_M(pos) / F_st(pos);
    end
end

%% Plot 

figure
subplot(2,2,1)
plot(r_loc, d_T);
grid on
title('Schubkraft')
xlabel('Position [m]') 
ylabel('Kraft [N]')

subplot(2,2,2)
plot(r_loc, d_M)
grid on
title('Moment')
xlabel('Position [m]') 
ylabel('Moment [Nm]')

subplot(2,2,3)
plot(r_loc, c_T);
grid on
title('Schubbeiwert')
xlabel('Position [m]') 
ylabel('C_T')
 
subplot(2,2,4)
plot(r_loc, c_M)
grid on
%ylim([-1 1] )
title('Momentbeiwert')
xlabel('Position [m]') 
ylabel('C_M')