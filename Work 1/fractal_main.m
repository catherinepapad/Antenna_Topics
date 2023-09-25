%% INPUT DATA
x_in = 0;           %x coordinate of initial point
y_in = 0;           %y coordinate of initial point
x_fin = 0.016;      %x coordinate of final point
y_fin = 0;          %y coordinate of final point
angle = pi/4;       %indentation angle
it = 2;             %number of iterations

segments = 9;       %number of segments for each wire (for NEC)
diameter = 0.000125;%diameter of each wire (for NEC)

%% CALL RECURSIVE FUNCTION
antenna_coord = fractal_recursion2(x_in,y_in,x_fin,y_fin,it,angle);      

num_wires = size(antenna_coord);
num_wires = num_wires(1);

%% PLOT
figure
for i=1:1:num_wires
    plot([antenna_coord(i,1) antenna_coord(i,2)],[antenna_coord(i,3) antenna_coord(i,4)],'b-')
    drawnow
    %pause(1);
    hold on
end
hold off
title('2D Model of Fractal Antenna')
xlabel('X axis'), ylabel('Y axis')
axis equal

%% MAKE NEC FILE
necFile = fopen('CustomFractal2.nec','w');   %CustomFractal.nec or CustomFractal.txt
fprintf(necFile,'CM NEC Input File of Custom Fractal Antenna \n');
for k=1:1:num_wires
    fprintf(necFile, 'GW %3i \t %2i \t %5f \t %5f \t %5f \t %5f \t %5f \t %5f \t %5f \n' , k , segments, 0, antenna_coord(k,3), antenna_coord(k,1), 0, antenna_coord(k,4), antenna_coord(k,2), diameter);
end
fclose(necFile);