function [Cf_w, Cf_h, Cf_v, Cf_f, Cd_0] = Cd_zero(W)
%% Variables
M = 0.55; % Design Cruise Speed from specifications
% phim % sweep angle of the %-line of maximum relative thickness
% e_extended = 0.7; % e with extended flaps, slats and landing gear,
% e_retracted = 0.85; % e with retracted flaps, slats and landing gear for simplicity?s sake (can be calculated if one wishes to go further)

% Wings
S_w = 31.25; % m^2, wing area
% xw % position of maximum thickness
toverc_W = 0.15; % t/c, airfoiltools
S_exp = S_w; % Exposed wing area (without the part of the wing area S_w running through the fuselage)
c_t = 0.965; % m, chord wing tip,  Main Wing 
c_r = 2.413; % m, chord wing root,  Main Wing 
lambda = c_t/c_r; % Taper
chord_tip_w = 0.965;
chord_root_w = 2.413;
l_wing = (chord_tip_w+chord_root_w)/2; %(?) MAC, should be 1.689, (could be length instead?)
%l_wing = 18.5; %(?) length

% Horizontal
%xh % position of maximum thickness
toverc_H = 0.12; % t/c, airfoiltools
chord_tip_h = 0.81;
chord_root_h = 1.35;
l_empennage_h = (chord_tip_h+chord_root_h)/2; %(MAC)should be 1.08, In the case of a wing or empennage, the characteristic length l is the mean aerodynamic chord (MAC).
length_H = 6.4;

% Vertical
%xv % position of maximum thickness
toverc_V = 0.15; % t/c, airfoiltools
chord_tip_v = 1.75;
chord_root_v = 23.4-10-10.5; % should be 2.9
l_empennage_v = (chord_tip_v+chord_root_v)/2; %(MAC) should be 2.325, In the case of a wing or empennage, the characteristic length l is the mean aerodynamic chord (MAC).
height_tailV = 3;

% Fuselage
d_f = 2.5; % m, Fuselage diameter, For non-circular fuselages d_f is calculated from the fuselage circumference P with d_f = P/?
l_f = 23.4;
lambda_f = l_f/d_f; % Fuselage fineness ratio, ?_f = l_f/d_f
l_fuselage = 23.4; % total length of the fuselage

%% Useful pdfs:
% Pdf 1:
% https://www.fzt.haw-hamburg.de/pers/Scholz/HOOU/AircraftDesign_13_Drag.pdf

%% Momentary input
% Weight defaulting, defaults to MLW if 0 is given as an input
MLW = 15570 * 9.81; % Max landing weight

if W == 0
   fprintf("no weight value assinged, using MLW");
   W = MLW;
end


%% Calculating individual drag of components

%% Skin friction coefficient
c_sound = 309.6; %(?) m/s, speed of sound
V = M*c_sound; % should be 170.28
v = 10.42*(10^(-6)); % m^2/s, kinematic viscosity, which is a function of aircraft altitude (used online calculator @ temp -34.5 C)

% Re = (V*l)/v; % Reynold's number

Re_w = (V*l_wing)/v;
Re_v = (V*l_empennage_v)/v;
Re_h = (V*l_empennage_h)/v; 
Re_f = (V*l_fuselage)/v;

k = 0.00635; % surface roughness (table 13.3 of pdf 1), smooth paint

Re_cutoff_w = 38.21*((l_wing/k)^1.053);
Re_cutoff_v = 38.21*((l_empennage_v/k)^1.053);
Re_cutoff_h = 38.21*((l_empennage_h/k)^1.053);
Re_cutoff_f = 38.21*((l_fuselage/k)^1.053); 

Cf_laminar_w = 1.328/(sqrt(Re_w));
Cf_laminar_h = 1.328/(sqrt(Re_h));
Cf_laminar_v = 1.328/(sqrt(Re_v));
Cf_laminar_f = 1.328/(sqrt(Re_f));

Cf_turbulent_w = (0.455/(((log(Re_cutoff_w))^2.58)*((1+0.144*(M^2))^0.65)));
Cf_turbulent_h = (0.455/(((log(Re_cutoff_h))^2.58)*((1+0.144*(M^2))^0.65)));
Cf_turbulent_v = (0.455/(((log(Re_cutoff_v))^2.58)*((1+0.144*(M^2))^0.65)));
Cf_turbulent_f = (0.455/(((log(Re_cutoff_f))^2.58)*((1+0.144*(M^2))^0.65)));


k_laminar = 0.2; % estimating 20%

Cf_w = k_laminar*Cf_laminar_w+(1-k_laminar)*Cf_turbulent_w;
Cf_h = k_laminar*Cf_laminar_h+(1-k_laminar)*Cf_turbulent_h;
Cf_v = k_laminar*Cf_laminar_v+(1-k_laminar)*Cf_turbulent_v;
Cf_f = k_laminar*Cf_laminar_f+(1-k_laminar)*Cf_turbulent_f;




%% Form factor

% FFw = (1+(0.6/xw)*(toverc_W)+100*((toverc_W)^4))*(1.34*(M^0.18)*(cos(phim)^0.28)); % form factor of wings
% 
% FFh = (1+(0.6/xh)*(toverc_H)+100*((toverc_H)^4))*(1.34*(M^0.18)*(cos(phim)^0.28)); % form factor of wings
% % form factor of horizontal empennage
% 
% FFv = (1+(0.6/xv)*(toverc_V)+100*((toverc_V)^4))*(1.34*(M^0.18)*(cos(phim)^0.28)); % form factor of wings
% % form factor of vertical empennage
% 
% FFf = 1+(60/(lf/df)^3)+((lf/df)/400); % form factor of fuselage
% 
% % FFn % form factor of nacelles

%% Interference factor Q
% selected according to Table 13.4

Q_w = 1; % interference factor for wing
Q_f = 1; % interference factor for fuselage
Q_e = 1.04; % interference factor for conventional empennage

%% S_wet
S_wet_F = pi()*d_f*l_f*((1-(2/lambda_f))^(2/3))*(1+1/lambda_f^2);% wetted area of fuselage

S_wet_W = 2*S_exp*(1+0.25*(toverc_W)*((1+1*lambda)/(1+lambda))); % wetted area of the wing


lambda_H = chord_tip_h/chord_root_h; 
S_exp_H = length_H * l_empennage_h; % should be 6.9
S_wet_H = S_exp_H*(1+0.25*toverc_H*((1+1*lambda_H)/(1+lambda_H))); % horizontal tailplanes

S_exp_V = height_tailV * l_empennage_v; % area
lambda_V = chord_tip_v/chord_root_v;
S_wet_V = S_exp_V*(1+0.25*toverc_V*((1+1*lambda_V)/(1+lambda_V))); % vertical tailplanes


%% S_ref, areas
S_ref_w = S_w;
S_ref_h = length_H * l_empennage_h;
S_ref_v = height_tailV * l_empennage_v;
S_ref_f = 2*pi()*2.5*23.4+2*pi()*(2.5^2); %fuselage area

% S_wet_F = pi()*d_f*l_f*((1-(2/lambda_f))^(2/3))*(1+1/lambda_f^2);% wetted area of fuselage

%% Calculating the zero-lift drag coefficient Cd_0
% from the individual drag of components

%Cd_0 = sum_Cfc * FFc * Qc * (S_wet_c/S_ref) + Cd_misc + C_dlp; % zero-lift drag coeff

% CORRECT
Cd_0_w = (Cf_laminar_w * Q_w * (S_wet_W/S_ref_w)); %not taking FFc, Cd_misc into account or C_dlp
Cd_0_h = (Cf_laminar_h * Q_e * (S_wet_H/S_ref_h)); %not taking FFc, Cd_misc into account or C_dlp
Cd_0_v = (Cf_laminar_v * Q_e * (S_wet_V/S_ref_v)); %not taking FFc, Cd_misc into account or C_dlp
Cd_0_f = (Cf_laminar_f * Q_f * (S_wet_F/S_ref_f)); %not taking FFc, Cd_misc into account or C_dlp

Cd_0 = Cd_0_w+Cd_0_h+Cd_0_v+Cd_0_f;

end