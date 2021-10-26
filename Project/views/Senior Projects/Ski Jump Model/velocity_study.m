%Velocity Study 
g = 9.81; %m/s^2
theta0 = pi/8; %rad
pos_x = cos(theta0); %m
pos_y = sin(theta0); %m
vel_x = 0; %m/s
vel_y = 0; %m/s

tag = 2; %number of actuators
in = load('info.mat');
in = in.s;
in = [in(:,1),in(:,7)];
t_span = [0 1];
s0 = [pos_x;pos_y;vel_x;vel_y];
[t,s] = ode45(@(t,s) cross_lift(t,s,in,tag), t_span, s0);

figure
subplot(2,1,1)
plot(t,s(:,2),'LineWidth',3)
ylabel('Platform Height [m]')
subplot(2,1,2)
plot(t,s(:,1),'LineWidth',3)
ylabel('Actuator Extension [m]')
xlabel('Time [s]')
sgtitle('Position Study')

figure
subplot(2,1,1)
plot(t,s(:,4),'LineWidth',3)
ylabel('Platform Velocity [m/s]')
subplot(2,1,2)
plot(t,s(:,3),'LineWidth',3)
ylabel('Actuator Velocity [m/s]')
xlabel('Time [s]')
sgtitle('Velocity Study')

figure
use_acc = (diff(s(:,4))./diff(t));
act_acc = (diff(s(:,3))./diff(t));
subplot(2,1,1)
plot(t(1:end-1),(use_acc./g),'LineWidth',3)
ylabel('Gs of User')
subplot(2,1,2)
plot(t(1:end-1),(act_acc./g),'LineWidth',3)
ylabel('Gs of Actuator')
xlabel('Time [s]')
sgtitle('Acceleration Study')


