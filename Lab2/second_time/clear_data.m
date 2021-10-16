for i = -100:10:100
    matrix = readmatrix("data_"+num2str(i));
    fileID = fopen("clear_data_"+num2str(i)+".txt", "W");
    fprintf(fileID, "0 0 0\n");
    for j = 3:length(matrix)
        matrix(j, 2) = matrix(j,2) - matrix(2,2);
        fprintf(fileID, "%f %d %d\n",matrix(j, 1), matrix(j, 2), matrix(j, 3));
    end
    fclose(fileID);
end