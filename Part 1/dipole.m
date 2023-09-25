%% INPUT DATA
N = 4;                  %Number of wires

f0 = 1000000000;        %frequency
c0 = 299792458;         %speed of light
lambda0 = c0 / f0;      %wavelenght

r = 0.3*lambda0;       %lenght of Ν wires  
d = lambda0/20;         %lenght of connecting wire 

theta0 = pi/3;          %angle between wires
theta = theta0/2;       %angle from x axis

diameter = lambda0/500;

segments = 9;


%% CALCULATE CARTESIAN COORDINATES
antenna_coord = zeros(5,6);

antenna_coord(1,1) = -d/2;
antenna_coord(1,2) = d/2;

antenna_coord(2,1) = d/2;
antenna_coord(2,2) = d/2 + r*cos(theta);
antenna_coord(2,4) = r*sin(theta);

antenna_coord(3,1) = d/2;
antenna_coord(3,2) = d/2 + r*cos(-theta);
antenna_coord(3,4) = -r*sin(theta);

antenna_coord(4,1) = -d/2;
antenna_coord(4,2) = -d/2 - r*cos(theta);
antenna_coord(4,4) = r*sin(theta);

antenna_coord(5,1) = -d/2;
antenna_coord(5,2) = -d/2 - r*cos(-theta);
antenna_coord(5,4) = -r*sin(theta);

%% PLOT
figure;

%Plot connecting wire
plot3([antenna_coord(1,1) antenna_coord(1,2)],[antenna_coord(1,3) antenna_coord(1,4)],[antenna_coord(1,5) antenna_coord(1,6)],'g-');
hold on

%Plot horizontal wires
for k=2:1:5
    plot3([antenna_coord(k,1) antenna_coord(k,2)],[antenna_coord(k,3) antenna_coord(k,4)],[antenna_coord(k,5) antenna_coord(k,6)],'b-');
    hold on
end

grid on
axis equal
zlim([-lambda0/8 lambda0/8])
xlabel('X axis'), ylabel('Y axis'), zlabel('Z axis')
title('3D Model of Broadband Dipole')

%% MAKE NEC FILE
necFile = fopen('Dipole.nec','w');         %Dipole.nec or Dipole.txt
fprintf(necFile,'CM NEC Input File of Custom Broadband Dipole \n');
fprintf(necFile, 'GW 1 \t 1 \t %5f \t %5f \t %5f \t %5f \t %5f \t %5f \t %5f \n' , antenna_coord(1,1) , antenna_coord(1,3) , antenna_coord(1,5), antenna_coord(1,2), antenna_coord(1,4), antenna_coord(1,6), diameter);
for k=2:1:5
    fprintf(necFile, 'GW %3i \t %2i \t %5f \t %5f \t %5f \t %5f \t %5f \t %5f \t %5f \n' , k , segments, antenna_coord(k,1) , antenna_coord(k,3) , antenna_coord(k,5), antenna_coord(k,2), antenna_coord(k,4), antenna_coord(k,6), diameter);
end
fclose(necFile);