result = readmatrix("dat4.txt");
time = result(1:end, 1);
xcoor = result(1:end, 2);
ycoor = result(1:end, 3);
xgoal = result(1:end, 4);
ygoal = result(1:end, 5);
heading = result(1:end, 8);
distance = result(1:end, 9);

d_minus90 = result(1:end, 11);
d_plus45 = result(1:end, 13);
d_minus45 = result(1:end, 15);
d_plus90 = result(1:end, 17);

xobs=[];
yobs=[];

for i = 1:length(xcoor)
    if d_minus90(i) < 0.5
        phi = heading(i) + -pi/2;
        deltax = d_minus90(i) * cos(phi);
        deltay = d_minus90(i) * sin(phi);
        xobs = [xobs; xcoor(i) + deltax];
        yobs = [yobs; ycoor(i) + deltay];
    end
end

for i = 1:length(xcoor)
    if d_plus45(i) < 0.5
        phi = heading(i) + pi/4;
        deltax = d_plus45(i) * cos(phi);
        deltay = d_plus45(i) * sin(phi);
        xobs = [xobs; xcoor(i) + deltax];
        yobs = [yobs; ycoor(i) + deltay];
    end
end

for i = 1:length(xcoor)
    if d_minus45(i) < 0.5
        phi = heading(i) + -pi/4;
        deltax = d_minus45(i) * cos(phi);
        deltay = d_minus45(i) * sin(phi);
        xobs = [xobs; xcoor(i) + deltax];
        yobs = [yobs; ycoor(i) + deltay];
    end
end
% 
for i = 1:length(xcoor)
    if d_plus90(i) < 0.5
        phi = heading(i) + pi/2;
        deltax = d_plus90(i) * cos(phi);
        deltay = d_plus90(i) * sin(phi);
        xobs = [xobs; xcoor(i) + deltax];
        yobs = [yobs; ycoor(i) + deltay];
    end
end

obs = [xobs, yobs]

close all

hold on
grid on
plot(xcoor, ycoor)
% plot(xgoal, ygoal, ".")
%plot(time, heading);
%plot(time, distance)
plot(xobs, yobs, '*');

hold off
