clear; clc; close all;
g = 9.81;
r = 30;
v0 = 0;
global theta
theta = -pi;

t_span = [0 5];
const = [g,r];
s0 = [-r,0,v0*sin(theta),v0*sin(theta)];
opts = odeset('Events', @Stop);

[t, s] = ode45(@(t,s) pendulumODE(t,s,const), t_span, s0, opts);

figure(); colormap(copper);
patch([s(:,1); nan],[s(:,2); nan],[t; nan],'FaceColor','none','EdgeColor','interp','LineWidth',2);
xlabel("P_x, [m]"); ylabel("P_y, [m]");
c = colorbar;
c.Label.String = 'Time [s]';
axis equal;
title("Position");
