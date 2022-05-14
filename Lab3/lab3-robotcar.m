% Define some constants from second lab
    Ke = 0.4870;
    Km = Ke;
    R = 8.8696;
    J = 0.0024;
    Target = 30;
    Tm = 0.0886;
    Ta = 0.0005299 * Tm;
    L = Ta * R;
    PI = 3.14159265359;
    Umax = 8.05;
    Umin = -8.05;
    Drag = 0.05;
    Mot = -0.01;
    sigma = 5;
% Analysis of PID-control:
kp = 4;
ki = 0.01;
kd = 0.3;
name_of_file = "Data/RobotData_3/data_kp="+num2str(kp)+"_ki="+num2str(ki)+"_kd="+num2str(kd)+".txt";
results = readmatrix(name_of_file);
time = results(1:end, 1);
position = results(1:end, 2);
MinDist = min(position);
Overshoot = Target - MinDist
EstError = abs(Target - position(end - 1))
Size = int16(length(position));
Size = Size - 2;
TimeProccess = time(end - 1);
for i = Size: -1: 0
    if (abs(position(i) - position(end - 1)) >= sigma)
        TimeProccess = time(i);
        break
    end
end
TimeProccess

hold on
grid on
plot(time, position, 'blue');

setpoint_x = [0 time(end - 1)];
setpoint_y = [Target Target];
line(setpoint_x,setpoint_y, 'Color', 'red');
legend("PID-control", "Target", 'Location', 'northeast');
xlabel('Time, [sec]');
ylabel('Distance, [cm]');

hold off