tic
% input user
z = 3;                       % Blattanzahl
R = 80;                      % Außenradius
lam_A = 9;                   % Auslegungsschnelllaufzahl
%v1_A = 10;                  % Auslegungswindgeschw.
cl1_A = 1;                   % Auftriebsbeiwert Blattwurzel (1. Profil)
cl2_A = 0.7;                 % Auftriebsbeiwert Mitte (2. Profil)
cl3_A = 1.1;                 % Auftriebsbeiwert Blattspitze (3. Profil)
N = 100;                     % Anzahl Laufschritte über Blatt
n1 = round(N/3);             % Umbruchspunkt des Profils

% 
dcl1_2 = (cl2_A - cl1_A) / (n1 - 1); 
dcl2_3 = (cl3_A - cl2_A) / (N - n1);



cl_A = zeros(1, N);
position1 = [1: n1];
position2 = [n1+1: N];
for i = 1:n1
    cl_A(i) = cl1_A + dcl1_2 * (i-1);
end
for i = n1 + 1: N
    cl_A(i) = cl2_A + dcl2_3 * (i - n1);
end
alpha_A = ones(1, N) * 5;                 % optimaler Anstellwinkel bei Auslegung

r = linspace(1, R, N);     % laufender Radius    

% Blattiefe nach Schmitz
t = (16*pi)./(z * cl_A) .* r .* sind(1/3 *(atand(R./(lam_A * r)))).^2;

% Bauwinkel nach Schmitz
Theta = 2/3 * atand(R ./(lam_A * r)) - alpha_A; 

plot(r, Theta)
%plot(r, t)
grid("on")
hold on
plot(r, t)
hold off
toc