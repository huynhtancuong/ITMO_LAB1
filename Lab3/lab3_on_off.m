%define some constants
Ke = 0.4870;
Km = 0.4870;
R = 8.8696;
J = 0.0024;
L = 0.0047;
VOLTAGE = 8.05;
DRAG = 0;
TARGET_ANGLE = 580;

%run the model
model = sim("Data/On-Off Control/model_lab_3_on_off_control.slx");


%put measured time and angle -> matrix
exp_results = readmatrix('Data/On-Off Control/data_relay.txt');
exp_times = results(1:500, 1);
exp_angles = results(1:500, 2);

model_times = model.coordinate.Time;
model_angles = model.coordinate.Data;

figure("Name", "On-off control", "WindowState", "maximized");
hold on;
%draw experiment line
plot(exp_times, exp_angles);
%draw model line
plot(model_times, model_angles);
%draw setpoint line
setpoint_x = [0 4.5];
setpoint_y = [580 580];
line(setpoint_x,setpoint_y, 'Color', 'blue');
%make it more beautiful
legend({'Experiment', 'Model', 'Setpoint'}, 'Location','southeast');
xlabel('Time, [sec]');
ylabel('Angle, [deg]');