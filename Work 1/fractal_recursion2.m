function antenna_coord=fractal_recursion2(x1,y1,x2,y2,it,angle)

x3 = x1 + (x2-x1)/3;        %x coordivate of first intermediate point
y3 = y1 + (y2-y1)/3;        %y coordivate of first intermediate point

x4 = x1 + 2*(x2-x1)/3;      %x coordivate of second intermediate point
y4 = y1 + 2*(y2-y1)/3;      %y coordivate of second intermediate point

length = sqrt((x3-x1)^2 + (y3-y1)^2);       %length of horizontal segments
hor = length*cos(angle)/2;                  %horizontal overlapping length (is this right??) 
height = length*sin(angle)/2;               %vertical distance of horizontal segments

a = [x1 x3 y1 y3];                          %coordinates of left horizontal segment
b = [x3 x3-hor  y3  y3+height];             %coordinates of left diagonal segment
c = [b(2) b(2)+length/2+2*hor  b(4) b(4)];  %coordinates of center-left horizontal segment
f = [x4+hor x4  y4-height  y4];             %coordinates of center diagonal segment


e = [f(1)-length/2-2*hor f(1) f(3) f(3)];           %coordinates of center-right horizontal segment
d = [c(2) e(1) c(4) e(3)];                  %coordinates of right diagonal segment


g = [x4 x2 y4 y2];                          %coordinates of right horizontal segment


antenna_coord = [a(1) a(2) a(3) a(4)];                  %create and fill a matrix with the coordinates of all segments
antenna_coord = [antenna_coord;b(1) b(2) b(3) b(4)];
antenna_coord = [antenna_coord;c(1) c(2) c(3) c(4)];
antenna_coord = [antenna_coord;d(1) d(2) d(3) d(4)];
antenna_coord = [antenna_coord;e(1) e(2) e(3) e(4)];
antenna_coord = [antenna_coord;f(1) f(2) f(3) f(4)];
antenna_coord = [antenna_coord;g(1) g(2) g(3) g(4)];

if(it-1>0)                          %check for recursion
    antenna_coord(7,:) = [];        %delete segments that are to be replaced
    antenna_coord(5,:) = [];
    antenna_coord(3,:) = [];
    antenna_coord(1,:) = [];
    antenna_coord = [antenna_coord;fractal_recursion2(a(1),a(3),a(2),a(4),it-1,angle)];      %create the new segments  
    antenna_coord = [antenna_coord;fractal_recursion2(c(1),c(3),c(2),c(4),it-1,angle)];
    antenna_coord = [antenna_coord;fractal_recursion2(e(1),e(3),e(2),e(4),it-1,angle)];
    antenna_coord = [antenna_coord;fractal_recursion2(g(1),g(3),g(2),g(4),it-1,angle)];
end

end