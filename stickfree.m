function [hn_hfree] = stickfree()
clear;
hnwb = 0.25; % stick fixed neutral point for the main wing
eta = 1.1; % propeller efficiency, taken from tutorials
lt = 10.619; % distnace from aerodynamic centre of the tail to the wing
c_bar_tail = 1.1025; % cbar for the tail wing 
S_wing = 31.25; %wing area in m^2
S_tail = 6.912;
Cl_t = 0.2; % from expeirmental data, 2-3 degrees angle of attack???
de = 3; % elevator angle, position tbd?

Cl_at = (2 * pi) / (1 + (2 / 5.926)); % Cl alpha of tail
Cl_aw = (2 * pi) / (1 + (2 / 10.953)); % Cl alpha of main wing

V_h =  (lt / c_bar_tail) * (S_tail / S_wing);

F = 1 - ((Cl_t / de) /Cl_at) * (18.5 / 6.4);

%% downwash
dw = 2 * (Cl_aw / (pi * 10.953));

hn_hfree = hnwb + ((1 - F) *  V_h) * (Cl_at / Cl_aw) * (1 - dw);

end