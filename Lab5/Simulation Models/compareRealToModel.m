close all;
hold on

% Motor constants
J = 0.0023;
L = 0.0047;
R_electronic = 4.73;
k_e = 0.274;
k_m = k_e;
M_oth = 0;

% Controler
R = 0.025;
B = 0.15;
K_str = 100;
K_rot = 400;
U_max = 8.35;

grid on

%starting position of robot
start_x = 0;
start_y = 0;
start_angel = 0;

x = data(:,1);
y = data(:,2);
plot(x,y, 'g',  'Linewidth',2 );


X = [0.5, 0, 0, 0, -1.2, 0, 0, 0]
Y = [0, 0, 0.8, 0, 0, 0, -1, 0]



for i = 1: length(X)
    goal_x = X(i);
    goal_y = Y(i);
    simm = sim("model2.slx");

    plot(simm.X.data, simm.Y.data , 'red', 'Linewidth',1);

    start_angel = simm.angel.Data(end);
    start_x = goal_x;
    start_y = goal_y;
end

file_name_linear = "Data/Task 2/second_task_data_ks=600_kr=400.txt";
data = readmatrix(file_name_linear);

% data = readmatrix('fixdata/data_square.txt');


legend('Experiment', 'Model');
title('Non-Linear model, Ks=600, Kr=400')
xlabel('x (m)');
ylabel('y (m)');