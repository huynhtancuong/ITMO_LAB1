syms theta0
syms theta1
syms theta2
syms theta3
syms alpha1 % = pi/2
syms a2 % = 0.1625
syms a3 % = 0.15
syms d0 % = 0.04
syms d1 % = 0.1675

[T01] = transform_create(theta0,        0,      0,      d0)
[T12] = transform_create(theta1,        alpha1,   0,      d1)
[T23] = transform_create(theta2+pi/2,   0,      a2, 0)
[T34] = transform_create(theta3,        0,      a3,   0)
T04=T01*T12*T23*T34
pretty(T01)
pretty(T12);
pretty(T23);
pretty(T34);
pretty(T04);