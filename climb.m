function [V_y, V_x, PR_alt, PA_alt] = climb(W)
%% Variables
p = 101325; %pressure in pascals
d_start = 1.225; % density at sea level kg/m^3
d_end = 0.548946; % kg/m^3 density at 25000 ft
k = 0.039789;
A = 31.25; %wing area in m^2
Cl_max = 1.5; %cl max according to airfoil tools, around 20 AoA AoA
Cd = 0.015; %Cd from initial sizing sheet
MTOW = 15580; %Max take off weightMW_landing = 15570; %use 15158 for 28 seat, for 35 seat use 15570, in kg
g = 9.81; %acceleration due to gravity
S = 18.5; %wing span
Eng_Power = 1625000; %Watts at sea lvl per engine
T_0 = 18450; % static thrust per engine sea lvl
T_tot = T_0*2;


%% Weight defaulting, defaults to MLW if 0 is given as an input
if W == 0
   fprintf("no weight value assinged, using MLW");
   W = MTOW * g;
else 
    W = W * g;
end

%% Vy = Velocity for max ROC
% Assuming T/W = 2.368
% therefore W = MTOW and T=T_tot

Cl = 1.241;
V_y = sqrt(W/(0.5*d_start*S*Cl)); % m/s (?)

%% Vx = Velocity for max climb angle

 V_x = nthroot((4*k*(W^2))/((d_start^2)*(S^2)*Cd),4); % m/s (?)

% D_angle = (0.5*d_start*(V_x^2)*S*Cd); % drag for max angle
 
% gamma_angle = (T_tot/W)-(D_angle/W)-((k*W)/(0.5*d_start*(V_x^2)*S)); % max climb angle
 
 %% Absolute and service ceiling
 
 sigma = d_end/d_start;
 q = W/(S*Cl);
 PA_alt = (sigma)*Eng_Power; % Power available at altitude
 V_alt = V_y/(sqrt(sigma)); % Velocity at altitude
 D = q*S*(Cd+k*(Cl^2)); % Drag at altitude
 
 PR_alt = D/V_alt; % Power required at altitude
 
 ROC_service = 0.5; % m/s
 ROC_absolute = 0; % m/s
 
% V_absolute = V_start/sigma; % Velocity at absolute ceiling ROC = 0

 %% Time to cruise altitude
% % 25000 ft = 7620 m
% % 24950 ft = 7604.76 m
% 
% h = 7604.76; % height for climb in m
% 
%% ROC calculation
% D_start = 0.5*d_start*((V_start)^2)*S*(Cd+k*(Cl^2));
% 
% ROC = ((T_tot - D_start)/W)*V_start; % rate of climb


 end