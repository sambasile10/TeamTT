function [value, isterminal, direction] = StoppingConditions(T,s)
global theta
if 10 - rad2deg(theta) > 0
    value = 1;
else
    value = 0;
end
%value = 10-rad2deg(theta);
isterminal = 1;  % Halt integration 
direction = 0;   % The zero can be approached from either direction
end

