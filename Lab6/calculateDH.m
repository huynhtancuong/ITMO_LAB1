clc;
clear;

% P4 is point locates (0,0,0) in 4th system coordinate
P4=[0;0;0;1]; 

% For input theta angles
theta1 = 0;
theta2 = 0;
theta3 = 0;

counter = 0;
looped = 0;

for theta1 = -pi:(pi+pi)/50:pi
    for theta2 = -pi:(pi+pi)/50:pi
        for theta3 = -pi:(pi+pi)/50:pi

% Calculate transform matrix

% [T10] = transform_create(pi/2,        0,      0,      0.04)
[T21] = transform_create(theta1,        pi/2,   0,  0.1675);
[T32] = transform_create(theta2+pi/2,   0,      0.1625,   0);
[T43] = transform_create(theta3,        0,      0.15,   0);
T41 = T21*T32*T43;

theta_input = [theta1; theta2; theta3];

% Calculate P1, which is a point in 1st system coordinate
P1=(T41*P4)';

% We take the location of P1 as a input for Inverted Kinematic Solver
% Which will return a set of Theta angles
[a, b, c] = InvertedKinematic(P1(1), P1(2), P1(3));
theta = [a, b, c]';

% We reuse the Theta angles to draw a point, to check if it right or not

[T21_] = transform_create(theta(1),        pi/2,   0,  0.1675);
[T32_] = transform_create(theta(2)+pi/2,   0,      0.1625,   0);
[T43_] = transform_create(theta(3),        0,      0.15,   0);
T41_ = T21_*T32_*T43_;

P1_tocheck = (T41_*P4)';
sum_diff_pos = 0;
for i=1:3
    sum_diff_pos= sum_diff_pos + (round(P1(i),3) - round(P1_tocheck(i),3));
end
if (sum_diff_pos > 0.1)
    counter = counter + 1;
end
looped = looped +1;

        end
    end
end
looped
counter