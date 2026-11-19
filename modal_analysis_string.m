function modal_string()
    
    mode_num = 3;


    num_masses = 6;
    total_mass = 1;
    tension_force = 1;
    string_length = 10;
    damping_coeff = 0.1;
    dx = string_length/(num_masses+1);
    

    %generate the struct
    string_params = struct();
    string_params.n = num_masses;
    string_params.M = total_mass;
    
    string_params.Tf = tension_force;
    string_params.L = string_length;
    string_params.c = damping_coeff;
    string_params.dx = dx;

    [M_mat, K_mat] = construct_2nd_order_matrices(string_params);
    [Ur_mat,lambda_mat] = eig(K_mat,M_mat);

    freqs = sqrt(lambda_mat);

    amplitude_Uf = 1;
    omega_Uf = freqs(mode_num, mode_num);

    %list of x points (including the two endpoints)
    xlist = linspace(0,string_length,num_masses+2);
    Uf_func = @(t_in) amplitude_Uf*cos(omega_Uf*t_in);
    dUfdt_func = @(t_in) -omega_Uf*amplitude_Uf*sin(omega_Uf*t_in);

    string_params.Uf_func = Uf_func;
    string_params.dUfdt_func = dUfdt_func;

    %load string_params into rate function
    my_rate_func = @(t_in,V_in) string_rate_func01(t_in,V_in,string_params);

    %initial conditions
    U0 = zeros(num_masses, 1);
    dUdt0 = zeros(num_masses,1);
    V0 = [U0;dUdt0];

    tau = 2*pi/omega_Uf;
    % tspan = [0 20];
    tspan = linspace(0,30*tau,1001);

    %run the integration
    [tlist,Vlist] = ode45(my_rate_func,tspan,V0);
    
    t_length = length(tlist);

    for i = 1:num_masses
        x_pos(:,i) = ones(t_length,1) * i*dx;
    end
    x_pos = [zeros(t_length,1), x_pos];
    x_pos = [x_pos, ones(t_length,1) * (num_masses+1)*dx];

    y_pos = [zeros(t_length,1), Vlist(:,1:num_masses)];
    y_pos = [y_pos, Uf_func(tlist)];


    Ur_mat_mode = [0, Ur_mat(:, mode_num)'];
    Ur_mat_mode = [Ur_mat_mode, 0];

    
    path = 'C:\Users\mgazit\OneDrive - Olin College of Engineering\MechE Math\mechemath-module6\plots\';
    fname = 'vibrating_string__mode3_ani.avi';
    input = [path, fname];
    
    writerObj = VideoWriter(input);
    open(writerObj);

    fig1=figure(1);
    tcl = tiledlayout(2, 1);
 

    set(fig1, 'units', 'pixels','position',[0,0,1440,1080]);
    nexttile(tcl);
    hold on;

    string_plot = plot(0,0,'k-', LineWidth=3);
    mass_plot = scatter(0, 0, 200, 'r', 'filled');
    % axis([0 5 -3 3]);


    ymax = max(max(abs(y_pos)));

    xlim([0,string_length]);
    ylim(1.1*[-ymax,ymax]);

    ax = gca;
    ax.FontSize = 16;
    ax.XAxis.TickLabelInterpreter = 'Latex';
    ax.YAxis.TickLabelInterpreter = 'Latex';

    xlabel("x (-)", Interpreter="latex", FontSize=16)
    ylabel("y (-)", Interpreter="latex", FontSize=16)
    title("Vibrating String Mode Shape 3 Animation", Interpreter="latex", FontSize=18)

    hold off;

    nexttile(tcl);
    hold on;

    mode_plot_string = plot(0,0,'k-', LineWidth=3);
    mode_plot_mass = scatter(0, 0, 200, 'r', 'filled');
    axis([0 string_length -3 3]);


    ax = gca;
    ax.FontSize = 16;
    ax.XAxis.TickLabelInterpreter = 'Latex';
    ax.YAxis.TickLabelInterpreter = 'Latex';

    xlabel("x (-)", Interpreter="latex", FontSize=16)
    ylabel("y (-)", Interpreter="latex", FontSize=16)
    title("Vibrating String Predicted Mode Shape 3", Interpreter="latex", FontSize=18)
    hold off;

   

    for i = 1:length(tlist)
        % dist = norm([x_pos(i,3), y_pos(i,3)] - [x_pos(i,4), y_pos(i,4)])
        set(string_plot, 'xdata', x_pos(i,:), 'ydata', y_pos(i,:))
        set(mass_plot, 'xdata', x_pos(i,2:(num_masses+1)), 'ydata', y_pos(i,2:(num_masses+1)))


        set(mode_plot_string, 'xdata', x_pos(i,:), 'ydata', Ur_mat_mode);
        set(mode_plot_mass, 'xdata', x_pos(i,2:(num_masses+1)), 'ydata', Ur_mat_mode(2:(num_masses+1)));
        drawnow
        current_frame = getframe(fig1);
        writeVideo(writerObj, current_frame);
    end
    close(writerObj);
    






end