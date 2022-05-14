theta0 = pi/2;

theta1 = pi/2;
theta2 = pi/4;
theta3 = -pi/4;

%syms theta0
%syms theta1
%syms theta2
%syms theta3

[T01] = transform_create(theta0,        0,      0,      0.04)
[T12] = transform_create(theta1,        pi/2,   0,  0.1675)
[T23] = transform_create(theta2+pi/2,   0,      0.1625,   0)
[T34] = transform_create(theta3,        0,      0.15,   0)
T=T01*T12*T23*T34;

P4=[0;0;0;1];
P0=T*P4;
P0'
