%% INPUT DATA
N1 = 8;              %Number of disc wires
N2 = 8;              %Number of cone wires 

f0 = 1000000000;     %frequency
c0 = 299792458;      %speed of light
lambda0 = c0 / f0;   %wavelenght

r = 0.25*lambda0;    %radius of disc
l = 0.3*lambda0;     %lenght of cone wires  
d = lambda0/20;      %lenght of connecting wire 

phi1 = 2*pi/N1;      %angle between disc wires 
phi2 = 2*pi/N2;      %angle between cone wires at xy plane (azimouthian angle)
theta0 = pi/6;       %angle between cone wires and z axis (polar angle)

diameter = lambda0/500;

segments = 9;

%% CALCULATE ANGLES
%Calculate the angles of all disc wires 
disc = zeros(N1,1);
for k=1:1:N1
    disc(k) = (k-1)*phi1;
end

%Calculate the angles of all cone wires 
cone = zeros(N2,1);
for k=1:1:N2
    cone(k) = (k-1)*phi2;
end


%% CALCULATE CARTESIAN COORDINATES
antenna_coord = zeros(N1+N2+1,6);

antenna_coord(1,6) = -d;
for k=2:1:N1+1
    antenna_coord(k,1) = r*cos(disc(k-1));
    antenna_coord(k,3) = r*sin(disc(k-1));
end 
for k=N1+2:1:N2+N1+1
    antenna_coord(k,2) = l*sin(theta0)*cos(cone(k-N1-1));
    antenna_coord(k,4) = l*sin(theta0)*sin(cone(k-N1-1));
    antenna_coord(k,5) = -d;
    antenna_coord(k,6) = -d-l*cos(theta0);
end
%% PLOT
figure;

%Plot connecting wire
plot3([antenna_coord(1,1) antenna_coord(1,2)],[antenna_coord(1,3) antenna_coord(1,4)],[antenna_coord(1,5) antenna_coord(1,6)],'g-');
hold on

%Plot disk wires
for k=2:1:N1+1
    plot3([antenna_coord(k,1) antenna_coord(k,2)],[antenna_coord(k,3) antenna_coord(k,4)],[antenna_coord(k,5) antenna_coord(k,6)],'b-');
    hold on
end

%Plot cone wires
for k=N1+2:1:N2+N1+1
    plot3([antenna_coord(k,1) antenna_coord(k,2)],[antenna_coord(k,3) antenna_coord(k,4)],[antenna_coord(k,5) antenna_coord(k,6)],'r-');
    hold on
end

grid on
axis equal
xlabel('X axis'), ylabel('Y axis'), zlabel('Z axis')
title('3D Model of Discone Antenna')


%% MAKE NEC FILE
necFile = fopen('Discone.nec','w');   %Discone.nec or Discone.txt
fprintf(necFile,'CM NEC Input File of Custom Discone Antenna \n');
fprintf(necFile, 'GW 1 \t 1 \t %5f \t %5f \t %5f \t %5f \t %5f \t %5f \t %5f \n' , antenna_coord(1,1) , antenna_coord(1,3) , antenna_coord(1,5), antenna_coord(1,2), antenna_coord(1,4), antenna_coord(1,6), diameter);
for k=2:1:N1+N2+1
    fprintf(necFile, 'GW %3i \t %2i \t %5f \t %5f \t %5f \t %5f \t %5f \t %5f \t %5f \n' , k , segments, antenna_coord(k,1) , antenna_coord(k,3) , antenna_coord(k,5), antenna_coord(k,2), antenna_coord(k,4), antenna_coord(k,6), diameter);
end
fclose(necFile);