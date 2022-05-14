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

% Analysis of P-control:
% "small" kp:
kp = 0.002;
ki = 0;
kd = 0;
name_of_file = "Data/MotorData/data_kp="+num2str(kp)+"_ki="+num2str(ki)+"_kd="+num2str(kd)+".txt";
results = readmatrix(name_of_file);
time = results(1:end, 1);
position = results(1:end, 2);
% Simulation P-control
model = sim("PcontrolModel.slx");
hold on
grid on
plot(time, position, 'blue');
plot(model.coordinate.Time, model.coordinate.Data, 'red');
legend("Experiment", "Model", 'Location', 'northeast');
xlabel('Time, [sec]');
ylabel('Angle, [deg]');
hold off

% "big" kp:
kp = 10;
ki = 0;
kd = 0;
name_of_file = "Data/MotorData/data_kp="+num2str(kp)+"_ki="+num2str(ki)+"_kd="+num2str(kd)+".txt";
results = readmatrix(name_of_file);
time = results(1:end, 1);
position = results(1:end, 2);
% Simulation P-control
model = sim("PcontrolModel.slx");
hold on
grid on
plot(time, position, 'blue');
plot(model.coordinate.Time, model.coordinate.Data, 'red');
legend("Experiment", "Model", 'Location', 'northeast');
xlabel('Time, [sec]');
ylabel('Angle, [deg]');
hold off

% "good" kp:
kp = 10;
ki = 0;
kd = 0;
name_of_file = "Data/MotorData/data_kp="+num2str(kp)+"_ki="+num2str(ki)+"_kd="+num2str(kd)+".txt";
results = readmatrix(name_of_file);
time = results(1:end, 1);
position = results(1:end, 2);
% Simulation P-control
model = sim("PcontrolModel.slx");
hold on
grid on
plot(time, position, 'blue');
plot(model.coordinate.Time, model.coordinate.Data, 'red');
legend("Experiment", "Model", 'Location', 'northeast');
xlabel('Time, [sec]');
ylabel('Angle, [deg]');
hold off

% Analysis of PID-control:
kp = 10;
ki = 0;
kd = 0;
name_of_file = "Data/MotorData/data_kp="+num2str(kp)+"_ki="+num2str(ki)+"_kd="+num2str(kd)+".txt";