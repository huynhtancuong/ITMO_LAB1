t = linspace(-pi,-pi/2, 30);
X =      t .* sin( pi * .872*sin(t)./t);
Y = -abs(t) .* cos(pi * sin(t)./t);

factor = 15;
Y = Y + pi
X = X/factor;
Y = Y/factor;

plot(X,Y);
fill(X, Y, 'r');
axis square;
set(gcf, 'Position', get(0,'Screensize')); 
title('Happy Valentines Day', 'FontSize', 28);