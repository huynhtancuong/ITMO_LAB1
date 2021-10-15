%define some constant
offset = 2;
radius_of_rotor = 1.1/100; % radius of rotor = 1.1(cm) = 1.1/100(m)
weight_of_rotor = 0.017; % weight of rotor = 17g = 0.017kg
gear_ratio = 48; %gear ratio of EV3 motor = 48
% read file
results = readmatrix("current_measure.txt");
% get negative pwm, voltage, current
PWM_N = results(1:11,1);
voltages_N = results(1+offset:11,2);
currents_N = results(1+offset:11,3);
% get positve pwm, voltage, current
PWM_P = results(11:end,1);
voltages_P = results(11:end-offset,2);
currents_P = results(11:end-offset,3);

function_to_cal_voltage = @(resistance, current) (current*resistance)

% create predict value
predict_resistance = 50;

% Calculate resistance by using approximation
resistance_P = lsqcurvefit(function_to_cal_voltage, predict_resistance, currents_P, voltages_P);
resistance_N = lsqcurvefit(function_to_cal_voltage, predict_resistance, currents_N, voltages_N);

% Draw graph of U(I) using resistance_N
figure("Name", "Negative");
hold on
plot(currents_N, voltages_N, 'red')
plot(currents_N, currents_N*resistance_N, 'k')
text(currents_N(end), voltages_N(end), num2str(resistance_N));
hold off
% Draw graph of U(I) using resistance_P
figure("Name", "Positive");
hold on
plot(currents_P, voltages_P, 'red')
plot(currents_P, currents_P*resistance_P, 'k')
text(currents_P(end), voltages_P(end), num2str(resistance_P));
hold off

% 1.9 Calculate final resistance value
resistance = (resistance_P+resistance_N)/2;

% 2.1 Calculate moment of inertia and moment of inertia after gearbox
moment_of_inertia = weight_of_rotor*radius_of_rotor*radius_of_rotor/2;
moment_of_inertia_after_gear_box = moment_of_inertia*gear_ratio*gear_ratio;


% Cal resistance by using formula
% R = 0;
% sumUI = 0;
% sumII = 0;
% for i = 1:length(voltages_N)
%     sumUI = sumUI + voltages_N(i)*currents_N(i);
%     sumII = sumII + currents_N(i)*currents_N(i);
% end
% for i = 1:length(voltages_P)
%     sumUI = sumUI + voltages_P(i)*currents_P(i);
%     sumII = sumII + currents_P(i)*currents_P(i);
% end
% resistance_cal_by_formula = sumUI / sumII