function [dsdt] = actuator(t, s, consts)
g = 9.81;
ts = consts(1,:);
a1 = consts(2,:);
a2 = consts(3,:);

x = s(1);
y = s(2);
z = s(3);
xd = s(4);
yd = s(5);
zd = s(6);
t0 = s(7);

if t0==0
    xdd = 0;
    ydd = 0;
    zdd = -g;
    if zd<(-.65)
        t0 = t;
    end
else
    t_new = t-t0;
    [~,i] = min(abs(ts-t_new));
    xdd = 0;
    ydd = 0;
    zdd = a1(i);
%     if t_new<(max(ts)/2)
%         zdd = a2(i);
%     else
%         zdd = a1(i);
%     end
end

dsdt = [xd;yd;zd;xdd;ydd;zdd;t0];
end