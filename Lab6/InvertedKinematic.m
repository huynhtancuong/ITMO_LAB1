% x, y, z is in the 1st system coordinate
function [theta1, theta2, theta3] = InvertedKinematic(x, y, z)
        % Define constants
        d1 = 0.1675;
        a1 = 0;
        a2 = 0.1625;
        a3 = 0.15;
        % Calculate theta1
        %theta1  = atan2(y, x);
        theta1  = atan(y/x);
        
        % Calculate theta2
        %r1      = sqrt(x^2+y^2);
        r1 = sqrt((x - a1*cos(theta1))^2 + (y - a1*sin(theta1))^2 );
        r2      = z-d1;
        % phi2    = atan2(r2, r1);
        phi2    = atan(r2/r1);
        r3      = sqrt(r1^2 + r2^2);
        phi1    = acos((a2^2 + r3^2 - a3^2) / (2*a2*r3));
        theta2  = pi/2 - (phi1+phi2);
        
        % Calculate theta3
        phi3    = acos((a2^2 + a3^2 - r3^2) / (2*a2*a3));
        theta3  = pi - phi3;
end