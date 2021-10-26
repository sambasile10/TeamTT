function [dsdt] = slopeAccel(t, s, const)
global theta

Px = s(1);
Py = s(2);
Vx = s(3);
Vy = s(4);

g = const(1);
rho = const(2);
Cd = const(3);
A = const(4);
m = const(5);
mu_k = const(6);
r = const(7);
printy = const(8);

theta = atan(Px/Py);
magV = sqrt(Vx^2+Vy^2);
% r = sqrt(Px^2 + Py^2);

ax_b = g*sin(theta) - rho*Cd*A*magV^2/(2*m)- mu_k*(g*cos(theta)+magV^2/r);
%For just simulating takeoff phase
% ay_b = magV^2/r; 

%For simulating in-line and takeoff phase
if Px >= -r*cosd(90-37)
    ay_b = magV^2/r;
else
    ay_b = 0;
end


ax_i = ax_b*cos(theta)+ay_b*sin(theta);
ay_i = ay_b*cos(theta)-ax_b*sin(theta);

vxb = Vx*sin(theta) + Vy*cos(theta);
vyb = Vy*cos(theta) + Vx*cos(theta);
if printy == 1
    fprintf("V mag: %.5f",sqrt(Vx^2+Vy^2));
    fprintf("  r: %f",sqrt(Px^2+Py^2));
    fprintf("  Theta: %f",rad2deg(theta));
    fprintf("  axb: %f",ax_b);
    fprintf("  ayb: %f",ay_b);
    fprintf("  F_N: %f", g*cos(theta)+magV^2/r);
    %fprintf("  Vxb: %f",vxb);
    %fprintf("  Vyb: %f",vyb);
    fprintf(" Time: %f\n", t(1)); 
end

dsdt(1) = Vx;
dsdt(2) = Vy;
dsdt(3) = ax_i;
dsdt(4) = ay_i;
dsdt = dsdt';
end