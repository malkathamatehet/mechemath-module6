function string_simulation_template01()
    num_masses = 2;
    total_mass = 3;
    tension_force = 1;
    string_length = 10;
    damping_coeff = 0.1;
    dx = string_length/(num_masses+1);
    amplitude_Uf = 1;
    omega_Uf = pi;

    %list of x points (including the two endpoints)
    xlist = linspace(0,string_length,num_masses+2);
    Uf_func = @(t_in) amplitude_Uf*cos(omega_Uf*t_in);
    dUfdt_func = @(t_in) -omega_Uf*amplitude_Uf*sin(omega_Uf*t_in);

    %generate the struct
    string_params = struct();
    string_params.n = num_masses;
    string_params.M = total_mass;
    string_params.Uf_func = Uf_func;
    string_params.dUfdt_func = dUfdt_func;
    string_params.Tf = tension_force;
    string_params.L = string_length;
    string_params.c = damping_coeff;
    string_params.dx = dx;

    %load string_params into rate function
    my_rate_func = @(t_in,V_in) string_rate_func01(t_in,V_in,string_params);

    %initial conditions
    U0 = zeros(num_masses, 1);
    dUdt0 = zeros(num_masses,1);
    V0 = [U0;dUdt0];
    tspan = [0 2];

    %run the integration
    [tlist,Vlist] = ode45(my_rate_func,tspan,V0);

    t_length = length(tlist);
    
    for i = 1:num_masses
        x_pos(:,i) = ones(t_length,1) * i*dx;
    end
    x_pos = [zeros(t_length,1), x_pos];
    x_pos = [x_pos, ones(t_length,1) * (num_masses+1)*dx];
    
    
end