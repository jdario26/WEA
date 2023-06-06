clear
Profil = load('S801.txt');

t = 4;                          % Tiefe der Profilsehne (wird irgendwie über Schmitz gegeben sein) 
Au_P = 2/3;                     % Auffädelungspunkt (wird vom User bestimmt)
N = size(Profil, 1);            % Anzahl Punkte von geometrischen Daten
r_0 = 5;                       % Abstand Profil zu Nabe    


for i = 1:N
    Profil(i,1) = Profil(i,1) - Au_P;
    Profil(i,:) = Profil(i,:) * t;
    Profil(i,3) = r_0;
    alpha = atand(Profil(i,1)/r_0);
    c = sqrt(r_0^2 + Profil(i,1)^2) - r_0;
    Profil(i,1) = Profil(i,1) - c*sind(alpha);
    Profil(i,3) = r_0 - c*cosd(alpha);
end


plot3(Profil(:,1), Profil(:,2), Profil(:,3))

xlim([-3 3])
ylim([-3 3])
zlim([-3 3])
