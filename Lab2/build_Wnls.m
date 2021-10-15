funSpeed = @(x,time) x(1)*(1-exp(-time/x(2)));
funAngle = @(x,time) x(1)*(time-x(2)*(1-exp(-time/x(2))));

array_Wnls_speed=[]
array_Wnls_cordinate=[]
array_of_PWM = -90:10:100;
for i = -90:10:100
    results = readmatrix("clear_data_"+num2str(i)+".txt");
    time = results(:,1);
    angles = results(:,2)*pi/180;
    speeds = results(:, 3)*pi/180;
    
    %create predict value
    predict_Wnls = 50;
    predict_Tm = 50;
    
    % get Wnls and Tm using speed data 
    fit_result_speed = lsqcurvefit(funSpeed, ...
                                 [predict_Wnls, predict_Tm], ...
                                 time, ...
                                 speeds);
    array_Wnls_speed = [array_Wnls_speed fit_result_speed(1)];
    % Get Wnls and Tm using angle data
    fit_result_cordinate = lsqcurvefit(funAngle, ...
                                     [predict_Wnls, predict_Tm], ...
                                     time, ...
                                     angles);
    array_Wnls_cordinate = [array_Wnls_cordinate fit_result_cordinate(1)];
end

array_PWM_Wnls_speed = [array_of_PWM' array_Wnls_speed']
array_PWM_Wnls_cordinate = [array_of_PWM' array_Wnls_cordinate']