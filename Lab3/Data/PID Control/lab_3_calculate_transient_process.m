clear

exp_results = readmatrix('PID control/data - kp=10 - ki=5 - kd=0.5.txt');
exp_times = exp_results(:, 1);
exp_angles = exp_results(:, 2);


size_of_matrix = size(exp_angles);
size_of_collum = size_of_matrix(1);

%cal 
for i = 2:(size_of_collum)
    exp_deriv(i) = (exp_angles(i) - exp_angles(i-1))/(exp_times(i) - exp_times(i-1));
end

for i = 2:(size_of_collum-1)
    sum = 0;
    for j = -1:1
        sum = sum + exp_deriv(i+j);
    end
    exp_deriv_filter(i) = sum/3;
end

exp_deriv_filter(size_of_collum) = exp_deriv_filter(size_of_collum-1);


hold on;
plot(exp_times, exp_angles, 'r.');
%plot(exp_times, exp_deriv, 'green');
plot(exp_times, exp_deriv_filter, 'black')

transient_process = 0;
i = length(exp_deriv_filter);
while(i>0)
    if (abs(exp_deriv_filter(i)) > 100)
        transient_process = exp_times(i);
        break;
    end
    i=i-1;
end
transient_process

%draw setpoint line
setpoint_x = [transient_process transient_process];
setpoint_y = [0 1200];
line(setpoint_x,setpoint_y, 'Color', 'blue');
hold off;












