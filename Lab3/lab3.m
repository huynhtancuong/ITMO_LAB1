kp = 10
ki = 0.05
kd = 0.5


name_of_file = "Data/data - kp="+num2str(kp)+" - ki="+num2str(ki)+" - kd="+num2str(kd)+".txt"
results = readmatrix(name_of_file);
time = results(1:end, 1);
position = results(1:end, 2);

hold on
plot(time, position, 'black');
%line([0 580],[10 580],'color','b') % Blue line from (4,0) to (4,10)


