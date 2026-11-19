function Q = generate_q(n)

%construct the nxn discrete laplacian matrix

    I_n = eye(n); % build the nxn identity matrix
    my_Laplacian_1 = circshift(I_n, 1);
    my_Laplacian_2 = circshift(I_n, -1);
    
    my_Laplacian_1(1,end) = my_Laplacian_1(1,end)-1; %delete unwanted 1 in top right corner
    my_Laplacian_2(end,1) = my_Laplacian_2(end,1)-1;
    
    my_Laplacian_3 = I_n * -2;
    
    Q = my_Laplacian_1 + my_Laplacian_2 + my_Laplacian_3;

end