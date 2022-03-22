name_of_file = "Data/data_5_ks=200_kr=200";

results = readmatrix(name_of_file);
x = results(1:end, 1);
y = results(1:end, 2);

plot(x, y);

hold on;

a=0;
b=1;
c=1;
t = 0:0.2:7;
idea_x = a + b*sin(2*c*t)
idea_y = b*sin(c*t)
%plot(idea_x, idea_y)

hold off;