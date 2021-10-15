names = ["data-100.txt", "data-79.txt", "data-55.txt", "data-39.txt", "data-27.txt", "data42.txt", "data60.txt", "data80.txt", "data93.txt","data100.txt"];
voltage = [-100, -79, -55, -39, -27, 42, 60, 80, 93, 100];


results = dlmread("data100.txt");
time = results(:,1);
angles = results(:,2)*pi/180;
speeds =results(:, 3)*pi/180;

plot(time, speeds, ".red")
hold on

funSpeed = @(x,time) x(1)*(1-exp(-time/x(2)));
%funAngle = @(x,time) x(1)*(time-x(2)*(1-exp(-time/x(2))));

%create predict value
predict_Wnls = 50;
predict_Tm = 50;

%run curvefit 
final_array_of_Wnls_Tm = lsqcurvefit(funSpeed, ...
                                     [predict_Wnls, predict_Tm], ...
                                     time, ...
                                     speeds);

%get final value of Wnls and Tm
Wnls = final_array_of_Wnls_Tm(1);
Tm = final_array_of_Wnls_Tm(2);

plot(time, funSpeed([Wnls Tm], time), "green");

simout = sim('SpeedModel');

plot(simout.simout.time, simout.simout.Data);
legend({'Experiment', 'Approximation', 'Model'}, 'Location','southeast')

hold off