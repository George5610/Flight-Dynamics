function [omega_DR, zeta_DR, omega_Phugoid, zeta_Phugoid, omega_Roll, zeta_Roll, omega_SPPD, zeta_SPPD] = dynamicsR3()
% Dynamics of a PA-28-161 Warrior II
close all;
A_csa = 5.05; % cross sectional area of the aircraft (m^2)
e = 0.76; % oswalds efficency factor, taken from estimating oswalds efficieny factor in supplementary material on blackboard
Cl_max = 1.3; % from https://www.osti.gov/etdeweb/servlets/purl/20131935
Cl5 = 0.85; %Cl at 5 AoA, taken from same source as max Cl
AR = 10.668^2 / 15.8; %b^2 / Ae = 0.76; % oswalds efficency factor, taken from estimating oswalds efficieny factor in supplementary material on blackboard

Cd_i = e^2 / (pi * AR * e); % induced drag coefficient

%%notes
% P = x angular rate of roll
% Q = angular rate for pitch
% R =  angular rate from yaw

figure(1);
grid on;
t1 = readtable('Data R3 Dutch Roll.txt', 'Delimiter',{'|'});
t1.Var38_1 = [];
toDeleteup = t1.x_real__time < 2318;
t1(toDeleteup,:) = [];
hold on;

yyaxis left;
ylabel("Roll (Deg)");
plot(t1.x_real__time, t1.x_roll___deg, "linewidth", 2);
yyaxis right;
plot(t1.x_real__time, t1.ruddr_stick);
title("Dutch Roll");
xlabel("Time");
ylabel("Rudder Position");
hold off;
ylim auto;

[val1, locs1] = findpeaks(t1.x_roll___deg);
tnt1 = t1(locs1(2:end), :);
tn1 = table2array(tnt1);
omegadiff1 = diff(tn1(:,2));
omega_DR = mean(omegadiff1);
xt01 = val1(1);
xtn1 = val1(2:end);
delta1 = mean(abs(log(xtn1./xt01)./(1:numel(xtn1))'));
zeta_DR = delta1/sqrt(pi^2 - delta1^2);


%roll and yaw rate on same graph

figure(2);
grid on;
hold on;
t2 = readtable('Data R3 Phugoid.txt','Delimiter',{'|'});
t2.Var38_1 = [];
toDeleteup = t2.x_real__time < 3709;
t2(toDeleteup,:) = [];
yyaxis left;
plot(t2.x_real__time, t2.pitch___deg);
ylabel("Pitch (Deg)");
yyaxis right;
plot(t2.x_real__time, t2.Vtrue__ktas);
title("Phugoid");
xlabel("Time");
ylabel("TAS knots");
hold off;
%pitch

[val2, locs2] = findpeaks(t2.x_roll___deg);
tnt2 = t2(locs2(2:end), :);
tn2 = table2array(tnt2);
omegadiff2 = diff(tn2(:,2));
omega_Phugoid = mean(omegadiff2);
xt02 = val2(1);
xtn2 = val2(2:end);
delta2 = mean(abs(log(xtn2./xt02)./(1:numel(xtn2))'));
zeta_Phugoid = delta2/sqrt(pi^2 - delta2^2);


figure(3);
grid on;
hold on;
t3 = readtable('Data R3 Roll.txt','Delimiter',{'|'});
t3.Var38_1 = [];
toDeleteup = t3.x_real__time < 0;
t3(toDeleteup,:) = [];
yyaxis left;
ylabel("Roll (Deg)");
plot(t3.x_real__time, t3.x_roll___deg);
title("Roll");
yyaxis right;
plot(t3.x_real__time, t3.ailrn_stick);
xlabel("Time");
ylabel("Elevator Position");
hold off;

%roll
[val3, locs3] = findpeaks(t3.x_roll___deg);
tnt3 = t3(locs3(2:end), :);
tn3 = table2array(tnt3);
omegadiff3 = diff(tn3(:,2));
omega_Roll = mean(omegadiff3);
xt03 = val3(1);
xtn3 = val3(2:end);
delta3 = mean(abs(log(xtn3./xt03)./(1:numel(xtn3))'));
zeta_Roll = delta3/sqrt(pi^2 - delta3^2);

figure(4);
grid on;
hold on;
t4 = readtable('Data R3 Spiral.txt','Delimiter',{'|'});
t4.Var38_1 = [];
toDeleteup = t4.x_real__time < 2813;
t4(toDeleteup,:) = [];
yyaxis left;
ylabel("Roll (Deg)");
plot(t4.x_real__time, t4.x_roll___deg);
title("Spiral");
yyaxis right;
plot(t4.x_real__time, t4.ailrn_stick);
xlabel("Time");
ylabel("Elevator Position");
hold off;
%roll angle

[val4, locs4] = findpeaks(t4.x_roll___deg);
tnt4 = t4(locs4(2:end), :);
tn4 = table2array(tnt4);
omegadiff4 = diff(tn4(:,2));
omega_Spiral = mean(omegadiff4);
xt04 = val4(1);
xtn4 = val4(2:end);
delta4 = mean(abs(log(xtn4./xt04)./(1:numel(xtn4))'));
zeta_Spiral = delta4/sqrt(pi^2 - delta4^2);

figure(5);
grid on;
t5 = readtable('Data R3 SPPD.txt','Delimiter',{'|'});
t5.Var38_1 = [];
toDeleteup = t5.x_real__time < 1904;
t5(toDeleteup,:) = [];
hold on;
yyaxis left;
ylabel("AoA");
plot(t5.x_real__time, t5.alpha___deg, "linewidth", 2);
yyaxis right;
plot(t5.x_real__time, t5.x_elev_stick);
ylim auto;
title("Short Period Pitch Dampening");
xlabel("Time");
ylabel("Elevator Input");
hold off;
%AoA & aileron input

[val5, locs5] = findpeaks(t5.x_roll___deg);
tnt5 = t5(locs5(2:end), :);
tn5 = table2array(tnt5);
omegadiff5 = diff(tn5(:,2));
omega_SPPD = mean(omegadiff5);
xt05 = val5(1);
xtn5 = val5(2:end);
delta5 = mean(abs(log(xtn5./xt05)./(1:numel(xtn5))'));
zeta_SPPD = delta5/sqrt(pi^2 - delta5^2);
end