results = read("C:\Users\huynh\OneDrive - ITMO UNIVERSITY\.Study\Nam 1\Chuyen Nganh\Lab1\data_100.txt", -1, 2)
angle = results(:,3)*%pi/180
time = results(:,1)
time = (time-time(1))/1000
qlines = size(results, 1)

