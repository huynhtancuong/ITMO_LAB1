file_name_linear = "Data/Heading Angle and Distance/data_a_p_linear_k1=200_k2=200.txt";
results_linear = readmatrix(file_name_linear);
file_name_nonlinear = "Data/Heading Angle and Distance/data_a_p_nonlinear_k1=200_k2=200.txt";
results_nonlinear = readmatrix(file_name_nonlinear);

t_l = results_linear(1:end, 1);
a_l = results_linear(1:end, 2);
p_l = results_linear(1:end, 3);

t_n = results_nonlinear(1:end, 1);
a_n = results_nonlinear(1:end, 2);
p_n = results_nonlinear(1:end, 3);

hold on
grid on
grid minor 
plot(t_l, a_l.*a_l+p_l.*p_l);
plot(t_n, a_n.*a_n+p_n.*p_n);
hold off
legend('Linear', 'Nonlinear')
xlabel('Time, [sec]');
ylabel('V(t) = a^2+p^2');