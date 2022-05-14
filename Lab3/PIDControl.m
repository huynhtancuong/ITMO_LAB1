% Define some constants from second lab
    Ke = 0.4870;
    Km = Ke;
    R = 8.8696;
    J = 0.0024;
    Angle = 580;
    Tm = 0.0886;
    Ta = 0.0005299 * Tm;
    L = Ta * R;
    PI = 3.14159265359;
    Umax = 8.05;
    Umin = -8.05;
    Drag = 0.05;
    Mot = -0.01;
    sigma = 3;
% Analysis of PID-control:
kp = 10;
ki = 10;
kd = 0.5;
name_of_file = "Data/MotorPID/data_kp="+num2str(kp)+"_ki="+num2str(ki)+"_kd="+num2str(kd)+".txt";
results = readmatrix(name_of_file);
time = results(1:end, 1);
position = results(1:end, 2);
MaxAngle = max(position);
Overshoot = MaxAngle - Angle
EstError = abs(Angle - position(end - 1))
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
model = sim("PIDcontrolModel.slx");
hold on
grid on
plot(time, position, 'blue');
plot(model.coordinate.Time, model.coordinate.Data, 'red');
setpoint_x = [0 10];
setpoint_y = [Angle Angle];
line(setpoint_x,setpoint_y, 'Color', 'black');
legend("Experiment", "Model", "Target", 'Location', 'northeast');
xlabel('Time, [sec]');
ylabel('Angle, [deg]');

hold off