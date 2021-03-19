function [X,y,drag,thrust,weight,lift] = cruise(W,p,c,f,v,aoa)
%% Variables 
mtow = 15580; %kg
oew= 8812;%kg
maxcargo= 3990;%kg
maxthrust = 1625000;%w per engine
maxthrust1 = 1625;%kw
length = 23.4; % meters
wingspan = 16 ;% meters
wingarea = 31.25 ;% meters squared
horistabarea= 6.92;
fuselagediameter = 2.5 ; % meters
bodyarea = 193.6 ;
maxfuel = 3600; % kg
airdensity = 0.08891; % kg/m3 @cruise
v1 = 170.32 ; %ms 
bodycd= 0.049;%obtained from a parabolic shape
efficiencyfactor =0.7;
vertstabcd=0.02670;

wingcl=[-0.7913 -0.7091 -0.5177 -0.1667 0.2231 0.5148 0.7527 0.9147 1.0543 1.0971 1.0222];%data fro extrapolating
xcl = [-10.0 -7.5 -5 -2.5 0 2.250 5 7.5 10 12.5 15];%data fro extrapolating
wingcd= [0.05025 0.03499 0.02807 0.02472 0.02420 0.02365 0.02617 0.03008 0.03860 0.05742 0.10009];%data fro extrapolating
xcd = [-10.0 -7.5 -5 -2.5 0 2.250 5 7.5 10 12.5 15];%data fro extrapolating

horistabcl=[-0.7108 -0.6070 0.0000 0.6068 0.6866 0.4511];
ycl=[-10 -5 0 5 10 11.5];
horistabcd=[0.08833 0.02495 0.02334 0.02495 0.09223 0.12857];
ycd=[-10 -5 0 5 10 11.5];
Enginespecificfuelconsumption= 0.2950144 ;% kg/kw/hr
reynoldsnum = (airdensity*v*wingspan)/16.54;


%% default weight
if v==0 
v= v1;% setting speed as cruise
end

%% aoa calcs

AoAcl = interp1(xcl,wingcl,[aoa],'linear','extrap');% to use most aoas
AoAcd = interp1(xcd,wingcd,[aoa],'linear','extrap');% to use most aoas

AoAclhori = interp1(ycl,horistabcl,[aoa],'linear','extrap');% to use most aoas
AoAcdhori = interp1(ycd,horistabcd,[aoa],'linear','extrap');% to use most aoas
%% lift-Weight calculations

lift1 = AoAcl*wingarea*0.5*airdensity*v^2 ;%in newtons
lift2 =AoAclhori*horistabarea*0.5*airdensity*v^2 ;%in newtons
lift= lift1 + lift2;
weight= (oew+ (maxcargo*(c/100)) + (maxfuel*(f/100))*9.81);%in newtons
%add comp of thrust into lift
if W == 0
   fprintf("no weight value assinged, using half fuel");
   weight = mtow-(maxfuel/2);
end
y = lift-weight ; % will show if forces are balanced 

%% Thrust-Drag Calculations
thrust= ((maxthrust*(p/100))*2);% input thrust w
induceddragcoeff= (AoAcl^2)/(pi*(wingspan^2/wingarea)*efficiencyfactor);
%drag
Wingdrag=  0.5*airdensity*v^2*AoAcd*wingarea; 
horidrag= 0.5*airdensity*v^2*AoAcdhori*horistabarea; 
Bodydrag = 0.5*airdensity*v^2*bodycd*bodyarea;
induceddrag=0.5*airdensity*v^2*induceddragcoeff*bodyarea;
vertstabdrag=0.5*airdensity*v^2*vertstabcd*bodyarea;
drag= Wingdrag  + Bodydrag +horidrag + induceddrag + vertstabdrag;
X = thrust - drag;

%% Fuel consumption
thrust1= ((maxthrust1*(p/100))*2);% input thrust kw
fuelconsumption= (Enginespecificfuelconsumption*thrust1)*2;

rangehrs= (maxfuel*(f/100)) /fuelconsumption;

rangekms= v*rangehrs; 

%% readouts
if X<0
fprintf("loosing velocity adding thrust");

elseif X==0 
fprintf("stable");

elseif X>0
fprintf("gaining velocity dropping thrust");

end
if y<0
fprintf("loosing altitude");
elseif y==0 
fprintf("stable");
elseif y>0
fprintf("gaining altitude");
end


