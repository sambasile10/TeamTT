function [dsdt] = cross_lift(t,s,in,tag)
pos_x = s(1);
pos_y = s(2);
vel_x = s(3);
vel_y = s(4);
theta = atan(pos_y/pos_x);

% V_p = 2*V_a*cos(theta)*sin(theta);
[~,i] = min(abs(in(:,1)-t));
V_p = in(i,2);

if tag==1
    V_a = V_p/(2*cos(theta)*sin(theta)); %single actuator
elseif tag==2
    V_a = V_p/(4*cos(theta)*sin(theta)); %double actuator
end

acc_x = V_a-vel_x;
acc_y = V_p-vel_y;

dsdt = [vel_x;vel_y;acc_x;acc_y];
end
