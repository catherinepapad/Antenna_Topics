%% INPUT DATA
N1 = 2;                 %Number of horizontal wires
N2 = 4;                 %Number of vertical wires 

f0 = 1000000000;        %frequency
c0 = 299792458;         %speed of light
lambda0 = c0 / f0;      %wavelenght

r = 0.25*lambda0;       %lenght of horizontal wires
l = 0.3*lambda0;        %lenght of vertical wires  
d = lambda0/20;         %lenght of connecting wire 

phi1 = 2*pi/N1;         %angle between horizontal wires 
theta0 = pi/6;          %angle of circular sector
phi2 = 2*theta0/(N2-1); %angle between vertical wires 

diameter = lambda0/1000;

segments = 9;

%% CALCULATE ANGLES
%Calculate the angles of all horizontal wires 
horizontal = zeros(N1,1);
for k=1:1:N1
    horizontal(k) = (k-1)*phi1;
end

%Calculate the angles of all vertical wires
offset = (pi - 2*theta0)/2;
vertical = zeros(N2,1);
for k=1:1:N2
    vertical(k) = offset + (k-1)*phi2;
end

%% CALCULATE CARTESIAN COORDINATES
antenna_coord = zeros(N1+N2+1,6);

antenna_coord(1,6) = -d;
for k=2:1:N1+1
    antenna_coord(k,1) = r*cos(horizontal(k-1));
    antenna_coord(k,3) = r*sin(horizontal(k-1));
end 
for k=N1+2:1:N2+N1+1
    antenna_coord(k,2) = l*cos(vertical(k-N1-1));
    antenna_coord(k,5) = -d;
    antenna_coord(k,6) = -d-l*sin(vertical(k-N1-1));
end

%% PLOT
figure;

%Plot connecting wire
plot3([antenna_coord(1,1) antenna_coord(1,2)],[antenna_coord(1,3) antenna_coord(1,4)],[antenna_coord(1,5) antenna_coord(1,6)],'g-');
hold on

%Plot horizontal wires
for k=2:1:N1+1
    plot3([antenna_coord(k,1) antenna_coord(k,2)],[antenna_coord(k,3) antenna_coord(k,4)],[antenna_coord(k,5) antenna_coord(k,6)],'b-');
    hold on
end

%Plot vertical wires
for k=N1+2:1:N2+N1+1
    plot3([antenna_coord(k,1) antenna_coord(k,2)],[antenna_coord(k,3) antenna_coord(k,4)],[antenna_coord(k,5) antenna_coord(k,6)],'r-');
    hold on
end

grid on
axis equal
ylim([-lambda0/4 lambda0/4])
xlabel('X axis'), ylabel('Y axis'), zlabel('Z axis')
title('3D Model of Modified Discone Antenna')

%% MAKE NEC FILE
necFile = fopen('Modified_Discone.nec','w');         %Modified_Discone.nec or Modified_Discone.txt
fprintf(necFile,'CM NEC Input File of Custom Modified Discone Antenna \n');
fprintf(necFile, 'GW 1 \t 1 \t %5f \t %5f \t %5f \t %5f \t %5f \t %5f \t %5f \n' , antenna_coord(1,1) , antenna_coord(1,3) , antenna_coord(1,5), antenna_coord(1,2), antenna_coord(1,4), antenna_coord(1,6), diameter);
for k=2:1:N1+N2+1
    fprintf(necFile, 'GW %3i \t %2i \t %5f \t %5f \t %5f \t %5f \t %5f \t %5f \t %5f \n' , k , segments, antenna_coord(k,1) , antenna_coord(k,3) , antenna_coord(k,5), antenna_coord(k,2), antenna_coord(k,4), antenna_coord(k,6), diameter);
end
fclose(necFile);