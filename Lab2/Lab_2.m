%define some constants
offset = 2;
radius_of_rotor = 1.1/100; % radius of rotor = 1.1(cm) = 1.1/100(m)
weight_of_rotor = 0.017; % weight of rotor = 17g = 0.017kg
gear_ratio = 48; %gear ratio of EV3 motor = 48
L = 0.0047; % do tu cam cua cuon day
type_of_export_graph = '.png';
simulation_model_1_coordinate_stop_time = "3";
simulation_model_1_current_stop_time = "0.5";
% read file
results = readmatrix("Data/current_measure.txt");

% get negative pwm, voltage, current
PWM_N = results(1:10,1);
voltages_N = results(1+offset:11,2);
currents_N = results(1+offset:11,3);
% get positve pwm, voltage, current
PWM_P = results(11:end,1);
voltages_P = results(11:end-offset,2);
currents_P = results(11:end-offset,3);
% Get voltages 
voltages = results(1:end,2);
PWM = results(1:end, 1);

function_to_cal_voltage = @(resistance, current) (current*resistance);

% create predict value
predict_resistance = 50;

% Calculate resistance by using approximation
resistance_P = lsqcurvefit(function_to_cal_voltage, predict_resistance, currents_P, voltages_P);
resistance_N = lsqcurvefit(function_to_cal_voltage, predict_resistance, currents_N, voltages_N);

% Draw graph of U(I) using resistance_N

    figure("Name", "Negative");
    hold on;
    grid on;
    grid minor;
    plot(currents_N, voltages_N, 'red');
    plot(currents_N, function_to_cal_voltage(currents_N, resistance_N), 'blue');
    legend({'Experiment', 'Approximation', 'Model'}, 'Location','northwest');
    xlabel('Current, [A]');
    ylabel('Voltage, [V]');
    %text(currents_N(end), voltages_N(end), num2str(resistance_N));
    hold off
% Draw graph of U(I) using resistance_P

    figure("Name", "Positive");
    hold on;
    grid on;
    grid minor;
    plot(currents_P, voltages_P, 'red');
    plot(currents_P, function_to_cal_voltage(currents_P, resistance_P), 'blue');
    legend({'Experiment', 'Approximation', 'Model'}, 'Location','northwest');
    xlabel('Current, [A]');
    ylabel('Voltage, [V]');

% 1.9 Calculate final resistance value
    resistance = (resistance_P+resistance_N)/2;
    R = resistance;

% 2.1 Calculate moment of inertia and moment of inertia after gearbox
    moment_of_inertia = weight_of_rotor*radius_of_rotor*radius_of_rotor/2
    moment_of_inertia_after_gear_box = moment_of_inertia*gear_ratio*gear_ratio
    J = moment_of_inertia_after_gear_box;
% 2.5 Create 2x 2d array of Wnls which depend on PWM
    % For Negative PWM
        funAngle = @(x,time) x(1)*(time-x(2)*(1-exp(-time/x(2))));
        array_Wnls_cordinateN=[];
    
        for i = (-100+offset*10):10:0
            results = readmatrix("Data/clear_data_"+num2str(i)+".txt");
            time = results(:,1);
            angles = results(:,2)*pi/180;
            
            %create predict value
            predict_Wnls = 50;
            predict_Tm = 50;
            
            % Get Wnls and Tm using angle data
            fit_result_cordinate = lsqcurvefit(funAngle, ...
                                             [predict_Wnls, predict_Tm], ...
                                             time, ...
                                             angles);
            array_Wnls_cordinateN = [array_Wnls_cordinateN fit_result_cordinate(1)]
        end
    
    % For Positive PWM
        funAngle = @(x,time) x(1)*(time-x(2)*(1-exp(-time/x(2))));
        array_Wnls_cordinateP=[];
    
        for i = 0:10:(100-offset*10)
            results = readmatrix("Data/clear_data_"+num2str(i)+".txt");
            time = results(:,1);
            angles = results(:,2)*pi/180;
            
            %create predict value
            predict_Wnls = 50;
            predict_Tm = 50;
            
            % Get Wnls and Tm using angle data
            fit_result_cordinate = lsqcurvefit(funAngle, ...
                                             [predict_Wnls, predict_Tm], ...
                                             time, ...
                                             angles);
            array_Wnls_cordinateP = [array_Wnls_cordinateP fit_result_cordinate(1)]
        end

% 2.6 Calculate Ke
    % Calculate Ke for Negative duty_sp
        function_to_cal_voltage = @(Ke, Wnls) Ke*Wnls;
        predict_Ke = 1;
        KeN = lsqcurvefit(function_to_cal_voltage, predict_Ke, array_Wnls_cordinateN, voltages_N')
        figure("Name", "U(w) (U < 0)");
        hold on
        grid on
        grid minor
        plot(array_Wnls_cordinateN, voltages_N, 'r')
        plot(array_Wnls_cordinateN, KeN*array_Wnls_cordinateN, 'g');
        legend('Experiment', 'Approximation', 'Location','northwest')
        xlabel('Wnls, [rad/sec]')
        ylabel('Voltage, [V]')
        %text(array_Wnls_speed(end)/2, voltages(end)/2, "Ke= "+ num2str(Ke));
        hold off;
    % Calculate Ke for Positive duty_sp
        function_to_cal_voltage = @(Ke, Wnls) Ke*Wnls;
        predict_Ke = 1;
        KeP = lsqcurvefit(function_to_cal_voltage, predict_Ke, array_Wnls_cordinateP, voltages_P')
        figure("Name", "U(w) (U > 0)");
        hold on
        grid on
        grid minor
        plot(array_Wnls_cordinateP, voltages_P, 'r')
        plot(array_Wnls_cordinateP, KeP*array_Wnls_cordinateP, 'g')
        legend('Experiment', 'Approximation', 'Location','northwest')
        xlabel('Wnls, [rad/sec]')
        ylabel('Voltage, [V]')
        %text(array_Wnls_speed(end)/2, voltages(end)/2, "Ke= "+ num2str(Ke));
        hold off;
        Ke = (KeN+KeP) / 2;
% 2.7 Let Km = Ke
    Km = Ke;

% Run simulation of full model 
    % Collect output of current strength
        for i = 1:1:length(voltages)
            U = voltages(i);
            if (U==0) % Bypass the value U = 0
                continue; 
            end 
            set_param("model_lab_2", "StartTime", "0", "StopTime", simulation_model_1_current_stop_time);
            model_1 = sim("model_lab_2.slx");
            figure("Name","Model 1: Voltage = "+num2str(U), "WindowState", "maximized");
            plot(model_1.current.Time, model_1.current.Data, 'blue');
            xlabel("Time, [sec]");
            ylabel("I, [Ampe]");
            grid on;
            grid minor;
            title_of_graph = "I(t) at voltage = " + num2str(U) + "V";
            title(title_of_graph);
            % Set legend for model
            legend("Model");
            path_to_file = "Graphs/Simulation/Currents/U=" + num2str(U) + type_of_export_graph;
            %saveas(gcf, path_to_file);
        end

% Run simulation of full model 
    % Collect output of coordinate
        for i = 1:1:length(voltages)
            U = voltages(i);
            if (U==0) % Bypass the value U = 0
                continue; 
            end 
            figure("Name","Model 1: Voltage = "+num2str(U), "WindowState", "maximized");
            xlabel("Time, [sec]");
            ylabel("θ, [rad]");
            grid on;
            grid minor;
            hold on;
            title_of_graph = " θ(t) at voltage = " + num2str(U) + "V";
            title(title_of_graph);
            set_param("model_lab_2", "StartTime", "0", "StopTime", simulation_model_1_coordinate_stop_time);
            model_1 = sim("model_lab_2.slx"); %run simulation
            % Graph of simulation's data
            plot(model_1.coordinate.Time, model_1.coordinate.Data, "red");
    
            % Graph of real coordinate
            real_life_results = readmatrix("Data/clear_data_"+num2str(PWM(i))+".txt");
            real_life_times = real_life_results(:,1);
            real_life_coordinates = real_life_results(:,2)*pi/180;
            plot(real_life_times, real_life_coordinates, "blue");
            hold off;
            % Set legend for experiments and model
            legend("Model", "Experiment");
            % To save graph as png
            path_to_file = "Graphs/Simulation/Coordinate/U=" + num2str(U) + type_of_export_graph;
            %saveas(gcf, path_to_file);
        end
    
% Run Simulation of full model and simplied model
    %For angle
        for i = 1:21
            results = readmatrix("Data/clear_data_"+num2str(PWM(i))+".txt");
            time = results(1:157,1);
            angles = results(1:157,2)*pi/180;
            figure("Name", "Cr(t) (U = " + num2str(voltages(i)) + ")");
            hold on
            grid on
            grid minor
            U = voltages(i);
            simout1 = sim('Lab2model'); %Full model
            simout2 = sim('SpeedModel'); %Simplified Model
            plot(simout1.Cr.Time, simout1.Cr.Data, 'b')
            plot(simout2.Cr.Time, simout2.Cr.Data, 'r-.')
            plot(time, angles, 'g--')
            legend('FullModel', 'Simplified Model', 'Experiment', 'Location','northeast')
            xlabel('Time, [sec]')
            ylabel('Angle, [rad]')
            hold off
        end

    %For speed
        for i = 1:21
            results = readmatrix("Data/clear_data_"+num2str(PWM(i))+".txt");
            time = results(1:159,1);
            angles = results(1:159,2)*pi/180;
            figure("Name", "W(t) (U = " + num2str(voltages(i)) + ")");
            hold on
            grid on
            grid minor
            U = voltages(i);
            simout1 = sim('Lab2model'); %Full model
            simout2 = sim('SpeedModel'); %Simplified Model
            plot(simout1.W.Time, simout1.W.Data, 'b')
            plot(simout2.W.Time, simout2.W.Data, 'r-.')
            legend('FullModel', 'Simplified Model', 'Location','northeast')
            xlabel('Time, [sec]')
            ylabel('Speed, [rad/sec]')
            hold off
        end
