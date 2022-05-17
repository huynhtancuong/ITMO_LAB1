function P0 = ForwardKinematic(theta1, theta2, theta3)
    P4=[0;0;0;1];

    [T10] = transform_create(pi/2,        0,      0,      0.04);
    [T21] = transform_create(theta1,        pi/2,   0,  0.1675);
    [T32] = transform_create(theta2+pi/2,   0,      0.1625,   0);
    [T43] = transform_create(theta3,        0,      0.15,   0);
    T40 = T10*T21*T32*T43;

    P0=(T40*P4);
end