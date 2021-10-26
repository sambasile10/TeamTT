clear; clc; close all;
%% Acceleration Profile
g = 9.81; %m/s^2
maxG1 = .1;
maxG2 = 1.1;
meanG1 = .33*.1;
meanG2 = .33*1.1;
maxt = 2.5;

t = linspace(0,2.5,1000);

b = maxt/2; %middle of plot
c1 = sqrt(sum((t-meanG1).^2)/length(t)) - 1.16; %hardcoded value from testing to create needed avg
c2 = sqrt(sum((t-meanG2).^2)/length(t)) - 1.40;
x = t;

a1 = maxG1*exp(-(x-b).^2/(2*c1^2));
a2 = maxG2*exp(-(x-b).^2/(2*c2^2))-1;
a1 = a1.*g;
a2 = a2.*g;
impulse1 = diff(a1)./diff(t);
impulse2 = diff(a2)./diff(t);

figure
sgtitle('Acceleration Profile')
% subplot(2,1,1)
plot(t,a1./g,'LineWidth',3)
ylabel('Gs added to User')
% ylabel('Accel after peak Gs')
% subplot(2,1,2)
% plot(t,a2./g)
% ylabel('Accel b4 peak Gs')
xlabel('Time [s]')
a1_avg = mean(a1); %m/s^2
a2_avg = mean(a2); %m/s^2
imp1_max = max(impulse1)*200; %N/s assuming 100kg or 220lb
imp2_max = max(impulse2)*200; %N/s assuming 100kg or 220lb
fprintf('Mean acceleration after peak: %.2f Gs \n',a1_avg/g)
fprintf('Maximum predicted impulse throughout simulation: %.2f N/s \n',max([imp1_max,imp2_max]))

%% Simulation Analysis
t_span = [0 10];
s0 = [0,0,0,0,0,0,0]; %pos (xyz), vel (xyz), time of freefall
consts = [t;a1;a2];

opts = odeset('Events', @Stop);
[t,s] = ode45(@(t,s) actuator(t,s,consts), t_span, s0, opts);

figure
sgtitle('User Experience State')
subplot(2,1,1)
plot(t,s(:,3),'LineWidth',3)
ylabel('Z Position [m]')
subplot(2,1,2)
plot(t,s(:,6),'LineWidth',3)
ylabel('Z Velocity [m/s]')
xlabel('Time [s]')

figure
mod_az = (diff(s(:,6))./diff(t))+g;
plot(t(1:end-1),(mod_az./g),'LineWidth',3)
xlabel('Time [s]')
ylabel('Gs')
sgtitle('User Vertical Acceleration Profile')

mod_iz = max(diff(mod_az)./diff(t(1:end-1)));
fprintf('Modeled max impulse throughout simulation: %.2f N/s \n',mod_iz)
fprintf('Maximum force necessary: %.2f N \n',max(mod_az)*100)
fprintf('Maximum Gs achieved: %.2f Gs \n',max(mod_az)/9.81)
fprintf('Maximum velocity reached: %.2f m/s \n',max(abs(s(:,6))))
fprintf('Necessary extension length of platform: %.2f m \n',max(abs(s(:,3))))

s = [t,s];    
% The end