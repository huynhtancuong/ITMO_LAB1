name_of_file = "Data/third_task_data_ks=300_kr=300_a=0_b=1_c=1.txt";

results = readmatrix(name_of_file);
x = results(1:end, 1);
y = results(1:end, 2);

plot(x, y);