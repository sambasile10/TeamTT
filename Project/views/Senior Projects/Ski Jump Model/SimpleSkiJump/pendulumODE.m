function [dsdt] = pendulumODE(t, s, const)
global theta

Px = s(1);
Py = s(2);
Vx = s(3);
Vy = s(4);

g = const(1);
r = const(2);

theta = atan(Py/Px)-pi;
V = sqrt(Vx^2 + Vy^2);
N = V^2/r;

Ax = -N*cos(theta);
Ay = -g - N*sin(theta);

dsdt(1) = Vx;
dsdt(2) = Vy;
dsdt(3) = Ax;
dsdt(4) = Ay;
dsdt = dsdt';
end