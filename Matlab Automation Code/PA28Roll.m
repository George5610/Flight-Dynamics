function [zeta, omega] = PA28Roll()
% Roll of a PA-28-161 Warrior II
close all;
figure(1);
grid on;
t = readtable('OUTPUT.DAT');
hold on;
ylabel("Roll Rate (rad/s)");
plot(t.Var2, t.Var4);
title("Roll");
xlabel("Time");
hold off;
ylim auto;

%help from https://uk.mathworks.com/matlabcentral/answers/514288-damping-and-frequency-from-simulation-data
[val, locs] = findpeaks(t.Var4);
tnt = t(locs(2:end), :);
tn = table2array(tnt);
omegadiff = diff(tn(:,2));
omega = mean(omegadiff);
xt0 = val(1);
xtn = val(2:end);
delta = mean(abs(log(xtn./xt0)./(1:numel(xtn))'));
zeta = delta/sqrt(pi^2 - delta^2);
end