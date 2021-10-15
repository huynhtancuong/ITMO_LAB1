names = ["data-100.txt", "data-79.txt", "data-55.txt", "data-39.txt", "data-27.txt", "data42.txt", "data60.txt", "data80.txt", "data93.txt","data100.txt"];
voltage = [-100, -79, -55, -39, -27, 42, 60, 80, 93, 100];
TmforAngle = [];
WnlsforAngle = [];
TmforSpeed = [];
WnlsforSpeed = [];
MstforAngle = [];
MstforSpeed = [];
% for i = 1:10
%     results = dlmread("data"+string(voltage(i))+".txt");
%     time = results(:, 1);
%     %angle=results(:,2)*pi/180;
%     speed=results(:, 3)*pi/180;
%     funSpeed = @(x,time)x(1)*(1-exp(-time/x(2)));
%     funAngle = @(x,time)x(1)*(time-x(2)*(1-exp(-time/x(2))));
%     x0 = [50, 50];
%     x=lsqcurvefit(funSpeed,x0,time,speed);
%     Wnls = x(1);
%     Tm = x(2);
%     J = 0.0023;
%     Mst = J*Wnls/Tm;
%     TmforSpeed(i) = Tm;
%     WnlsforSpeed(i) = Wnls;
%     MstforSpeed(i) = Mst;
%     simout = sim('SpeedModel');
%     figure('Name', names(i), 'NumberTitle','off')
%     hold on
%     grid on
%     grid minor
%     %set(gcf, 'Position', get(0,'Screensize'));
%     %plot(time, speed, 'r-');
%     %plot(simout.simout.Time, simout.simout.Data, 'g');
%     %plot(time, Wnls*(1-exp(-time/Tm)), 'k-.');  
%     if (voltage(i) > 0)
%         legend({'Experiment', 'Approximation', 'Model'}, 'Location','northwest')
%     else
%         legend({'Experiment', 'Approximation', 'Model'}, 'Location','northeast')
%     end
%         xlabel('Time, [sec]')
%         ylabel('Speed, [rad/sec]')
%         ax = gca; %get the current axes 
%         %exportgraphics(ax, 'SpeedVoltage_'+string(voltage(i))+'.jpg', 'Resolution', 300);
%         %exportgraphics(ax, 'SpeedAllNegativeVoltage.jpg', 'Resolution', 300);
%         hold off
%     %end
% end

for i = 1:1
    results = dlmread("data"+string(voltage(i))+".txt");
    xdata = results(:, 1); %time = xdata
    angle=results(:,2)*pi/180;
    fun = @(x,xdata)x(1)*(xdata-x(2)*(1-exp(-xdata/x(2))));
    x0 = [angle(end), xdata(end)];
    %tai sao no lai cho initial value cua Wnls va Tm bang voi angle(end)
    %va xdata(end)???
    x = lsqcurvefit(fun,x0,xdata,angle);
    Wnls = x(1);
    Tm = x(2);
    J = 0.0023;
    Mst = J*Wnls/Tm;
    TmforAngle(i) = Tm;
    WnlsforAngle(i) = Wnls;
    MstforAngle(i) = Mst;
    simout = sim('AngleModel');
    figure
    hold on
    grid on
    grid minor

    %this is experiment
    plot(xdata, angle, 'r-'); 

    %this is approximation that get from the simulator 
    plot(simout.simout.Time, simout.simout.Data, 'g'); 

    %this is Model
    plot(xdata, Wnls*(xdata-Tm*(1-exp(-xdata/Tm))), 'k-.');
    
    if (voltage(i) > 0)
        legend({'Experiment', 'Approximation', 'Model'}, 'Location','northwest')
    else
        legend({'Experiment', 'Approximation', 'Model'}, 'Location','northeast')
    end
    xlabel('Time, [sec]')
    ylabel('Angle, [rad]')
    hold off
end
% figure('Name','TmforAngle')
% hold on
% grid on
% grid minor
% plot(voltage, TmforAngle,'r');
% xlabel('Voltage, %')
% ylabel('Tm, [sec]')
% hold off
% 
% figure("Name","TmforSpeed")
% hold on
% grid on
% grid minor
% plot(voltage, TmforSpeed,'b');
% xlabel('Voltage, %')
% ylabel('Tm, [sec]')
% hold off

% figure
% hold on
% grid on
% grid minor
% plot(voltage, WnlsforAngle,'r');
% xlabel('Voltage, %')
% ylabel('Wnls, [rad/sec]')
% hold off
% figure
% hold on
% grid on
% grid minor
% plot(voltage, WnlsforSpeed,'b');
% xlabel('Voltage, %')
% ylabel('Wnls, [rad/sec]')
% hold off
% figure
% for i = 1:10
%     if (voltage(i) > 0)
%         results = dlmread("data"+string(voltage(i))+".txt");
%         time = results(:, 1);
%         speed=results(:, 3)*pi/180;
%         funSpeed = @(x,time)x(1)*(1-exp(-time/x(2)));
%         x0 = [50, 50];
%         x=lsqcurvefit(funSpeed,x0,time,speed);
%         Wnls = x(1);
%         Tm = x(2);
%         J = 0.0023;
%         Mst = J*Wnls/Tm;
%         TmforSpeed(i) = Tm;
%         WnlsforSpeed(i) = Wnls;
%         simout = sim('SpeedModel');
%         hold on
%         grid on
%         grid minor
%         plot(time, speed, 'r-');
%         plot(simout.simout.Time, simout.simout.Data, 'g');
%         plot(time, Wnls*(1-exp(-time/Tm)), 'k-.');  
%         legend({'Experiment', 'Approximation', 'Model'}, 'Location','northwest')
%         xlabel('Time, [sec]')
%         ylabel('Speed, [rad/sec]')
%         hold off
%     end
% end
% figure
% for i = 1:10
%     if (voltage(i) < 0)
%         results = dlmread("data"+string(voltage(i))+".txt");
%         time = results(:, 1);
%         speed=results(:, 3)*pi/180;
%         funSpeed = @(x,time)x(1)*(1-exp(-time/x(2)));
%         x0 = [50, 50];
%         x=lsqcurvefit(funSpeed,x0,time,speed);
%         Wnls = x(1);
%         Tm = x(2);
%         J = 0.0023;
%         Mst = J*Wnls/Tm;
%         simout = sim('SpeedModel');
%         hold on
%         grid on
%         grid minor
%         plot(time, speed, 'r-');
%         plot(simout.simout.Time, simout.simout.Data, 'g');
%         plot(time, Wnls*(1-exp(-time/Tm)), 'k-.');  
%         legend({'Experiment', 'Approximation', 'Model'}, 'Location','northeast')
%         xlabel('Time, [sec]')
%         ylabel('Speed, [rad/sec]')
%         hold off
%     end
% end
% figure
% for i = 1:10
%     if (voltage(i) > 0)
%         results = dlmread("data"+string(voltage(i))+".txt");
%         xdata = results(:, 1);
%         angle=results(:,2)*pi/180;
%         funAngle = @(x,xdata)x(1)*(xdata-x(2)*(1-exp(-xdata/x(2))));
%         x0 = [angle(end), xdata(end)];
%         x = lsqcurvefit(funAngle,x0,xdata,angle);
%         Wnls = x(1);
%         Tm = x(2);
%         J = 0.0023;
%         Mst = J*Wnls/Tm;
%         simout = sim('AngleModel');
%         hold on
%         grid on
%         grid minor
%         plot(xdata, angle, 'r-');
%         plot(simout.simout.Time, simout.simout.Data, 'g');
%         plot(xdata, Wnls*(xdata-Tm*(1-exp(-xdata/Tm))), 'k-.');  
%         legend({'Experiment', 'Approximation', 'Model'}, 'Location','northwest')
%         xlabel('Time, [sec]')
%         ylabel('Angle, [rad]')
%         hold off
%     end
% end
% figure
% for i = 1:10
%     if (voltage(i) < 0)
%         results = dlmread("data"+string(voltage(i))+".txt");
%         xdata = results(:, 1);
%         angle=results(:,2)*pi/180;
%         funAngle = @(x,xdata)x(1)*(xdata-x(2)*(1-exp(-xdata/x(2))));
%         x0 = [angle(end), xdata(end)];
%         x = lsqcurvefit(funAngle,x0,xdata,angle);
%         Wnls = x(1);
%         Tm = x(2);
%         J = 0.0023;
%         Mst = J*Wnls/Tm;
%         simout = sim('AngleModel');
%         hold on
%         grid on
%         grid minor
%         plot(xdata, angle, 'r-');
%         plot(simout.simout.Time, simout.simout.Data, 'g');
%         plot(xdata, Wnls*(xdata-Tm*(1-exp(-xdata/Tm))), 'k-.');  
%         legend({'Experiment', 'Approximation', 'Model'}, 'Location','northeast')
%         xlabel('Time, [sec]')
%         ylabel('Angle, [rad]')
%         hold off
%     end
% end