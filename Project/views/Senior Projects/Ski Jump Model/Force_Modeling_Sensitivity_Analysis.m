%% Force Modeling
clear all; close all; clc;

%% Constants
g = 9.81; % m/s^2
m = 81.6; % kg, this is equivalent to 180 lbs (avg Nordic Ski jumper w/ equipment)
[~, ~, ~, rho] = atmosisa(2049); % Air density at altitude of Steamboat Springs
Cd = 0.3; % lowered from estimate from lecture 6
A = 0.2; % m^2, lowered from estimate from lecture 6
mu_k = 0.03; % estimate from lecture 6

%% Assumptions
% For now, we'll assume a circular ramp
%theta = linspace(37,10);
global theta
r = 30; % m, this is just a wild guess

printy = 0; %toggles print statements within slopeAccel ODE

 %% ODE 45 Analysis in For loop
t_span = [0, 50]; % s
p0x = -r*cosd(90-37); p0y = -r*sind(90-37); % m
p0x = p0x - 30*cosd(37); p0y = p0y + 30*sind(37); %30m of in-line
numSensitivityAnalyses = 1;
m = 1;%input('m: ');
n = 1;%input('n: ');

%v0tot = linspace(0,60/2.237, numSensitivityAnalyses); %m/s, this is 0-60 mph
v0tot = 56/2.237; 

for i = 1:length(v0tot)
    v0x = v0tot(i)*cosd(37); v0y = -v0tot(i)*sind(37); % m/s, b/c v0y in body coordinates is 0
    s0 = [p0x p0y v0x v0y ];
    % Constants: g, rho, Cd, A, m, mu_k, r

    const = [g, rho, Cd, A, m, mu_k, r, printy];
    opts = odeset('Events', @(t,s) StoppingConditions(t,s),'RelTol',1e-14);

    [t, s,te,se,ie] = ode45(@(t,s) slopeAccel(t,s,const), t_span, s0, opts);
    ax = diff(s(1:end,3))./diff(t);
    ay = diff(s(1:end,4))./diff(t);
    gx = ax/g;
    gy = ay/g;
    gtot = sqrt(gx.^2 + gy.^2);

    %% Plots
    figure(1); colormap(copper);
    subplot(m,n,i)
    patch([s(:,1); nan],[s(:,2); nan],[t; nan],'FaceColor','none','EdgeColor','interp','LineWidth',2);
    xlabel("P_x, [m]"); ylabel("P_y, [m]");
    c = colorbar;
    c.Label.String = 'Time [s]';
    axis equal;
    titleString = "Position, V_0 = " + num2str(v0tot(i)*2.237)+ " mph";
    title(titleString);
    
    figure(2); colormap(copper)
    subplot(m,n,i)
    patch([s(:,3); nan],[s(:,4); nan],[t; nan],'FaceColor','none','EdgeColor','interp','LineWidth',2);
    xlabel("V_x, [m/s]"); ylabel("V_y, [m/s]");
    axis equal;
    c = colorbar;
    c.Label.String = 'Time [s]';
    titleString = "Velocity, V_0 = " + num2str(v0tot(i)*2.237)+ " mph";
    title(titleString);
    
    figure(3); colormap(copper);
    subplot(m,n,i)
    patch([ax; nan],[ay; nan],[t(1:end-1); nan],'FaceColor','none','EdgeColor','interp','LineWidth',2);
    xlabel("a_x, [m/s^2]"); ylabel('a_y [m/s^2]');
    axis equal;
    %xlim([-0.22,0.3]); ylim([-0.25,0.7]);
    c = colorbar;
    c.Label.String = 'Time [s]';
    titleString = "Acceleration, V_0 = " + num2str(v0tot(i)* 2.237)+ " mph";
    title(titleString);
    
    figure(4); 
    subplot(m,n,i)
    scatter(ax,ay);
    xlabel("a_x, [m/s^2]"); ylabel('a_y [m/s^2]');
    xlim([-15,15]); ylim([0,36]);
    axis equal;
    %xlim([-0.22,0.3]); ylim([-0.25,0.7]);
    titleString = "Acceleration, V_0 = " + num2str(v0tot(i)* 2.237)+ " mph";
    title(titleString);
    
    figure(5);
    subplot(m,n,i)
    plot(t(1:end-1),gy);
    xlabel("t, [s]"); ylabel("G's ");
    axis equal;
    %xlim([-0.22,0.3]); ylim([-0.25,0.7]);
    titleString = "G's vs Time, V_0 = " + num2str(v0tot(i)* 2.237)+ " mph";
    title(titleString);
    
    figure(6); colormap(copper);
    subplot(m,n,i)
    patch([s(1:end-1,1); nan],[s(1:end-1,2); nan],[gtot; nan],'FaceColor','none','EdgeColor','interp','LineWidth',2);
    xlabel("P_x, [m]"); ylabel("P_y, [m]");
    c = colorbar;
    c.Label.String = "G's ";
    axis equal;
    titleString = "G's at each Position, V_0 = " + num2str(v0tot(i)*2.237)+ " mph";
    title(titleString);
    
    figure(7);
    subplot(m,n,i)
    scatter(t(1:end-1),abs(ay./ax));
    xlabel("t, [s]"); ylabel("a_y/a_x ");
    axis equal;
    %xlim([-0.22,0.3]); ylim([-0.25,0.7]);
    titleString = "Accelration ratio vs Time, V_0 = " + num2str(v0tot(i)* 2.237)+ " mph";
    title(titleString);
     
    
end