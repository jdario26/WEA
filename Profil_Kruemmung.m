clear
Profil = load('S801.txt');

t = 10;                          % Tiefe der Profilsehne (wird irgendwie über Schmitz gegeben sein) 
Au_P = 1/3;                     % Auffädelungspunkt (wird vom User bestimmt)
N = size(Profil, 1);            % Anzahl Punkte von geometrischen Daten
r_0 = 10;                       % Abstand Profil zu Nabe    


for i = 1:N
    Profil(i,1) = Profil(i,1) - Au_P;           % Verschiebung in der x-Komponente auf den Auffädelungspunkt
    Profil(i,:) = Profil(i,:) * t;              % Skalierung mit der Profilbreite t
    Profil(i,3) = r_0;                          % Das Profil wird auf den richtigen Abstand zur Nabe gesetzt
    alpha = (Profil(i,1)/r_0) * (180/pi);       % Berechnung des Winkels des Kreisabschnittes von dem Punkt
    Profil(i,1) = r_0 * sind(alpha);            % Bestimmen von neuem x und
    Profil(i,3) = r_0 * cosd(alpha);            % z für die Krümmung des Profils
end


plot3(Profil(:,1), Profil(:,2), Profil(:,3))

axis equal
