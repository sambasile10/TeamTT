function [value, isterminal, direction] = Stop(t,s)
value = (abs(s(6))<0.01)&(s(7)~=0);
isterminal = 1;  % Halt integration 
direction = 0;   % The zero can be approached from either direction
end

