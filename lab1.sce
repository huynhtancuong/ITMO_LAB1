results = read("C:\Users\huynh\OneDrive - ITMO UNIVERSITY\.Study\Nam 1\Chuyen Nganh\Lab1\data.txt", -1, 2)
angle = results(:,2)*%pi/180
time = results(:,1)
time = (time-time(1))/1000
qlines = size(results, 1)
for i=1:qlines-1
    omega(i,1)=(angle(i+1)-angle(i))/(time(i+1)-time(i))
end
omega(qlines) = omega(qlines-1)
