function [value, isterminal, direction] = Stop(t,s)
global theta
value = (theta > -10*pi/180);
isterminal = 1;  % Halt integration 
direction = 0;   % The zero can be approached from either direction
end

