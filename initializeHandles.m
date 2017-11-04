%This function initializes handles and sets velocity and acceleration
%values
function [h_stage_X, h_stage_Y, h_stage_Z] = initializeHandles()
%% constant values for the accl and speed values
ax = 3;
vx = 10; 
ay = ax;
vy = vx; 
az = ax;
vz = vx; 


%% Figure setup for the GUI
figure_pos    = get(0,'DefaultFigurePosition');
figure_pos(1) = 20; %left x location of window
figure_pos(2) = 50;  %bottom y location of window
figure_pos(3) = 1100; % window size width
figure_pos(4) = 775; % height
f = figure('Position', figure_pos,...
           'Menu','None',...
           'Name','GPri Control',...
           'Color','blue');

%% Initialize handles for each stage
%Channel serial numbers
xChannel = 90872005;
yChannel = 90872006;
zChannel = 90872007;
% ALGORITHM TO INITIALIZE: 
    % actxcontrol function returns a handle
    % StartCtrl each handle
    % assign serial number
    % identify
    % turn off event dialog box

h_stage_X = actxcontrol('MGMOTOR.MGMotorCtrl.1', [10 510 350 250], f); %[startX startY w h]
h_stage_X.StartCtrl;
set(h_stage_X, 'HWSerialNum', xChannel); pause(0.1);
h_stage_X.Identify;
a = h_stage_X.EnableEventDlg(0); 

h_stage_Y = actxcontrol('MGMOTOR.MGMotorCtrl.1', [10 260 350 250], f); %[startX startY w h]
h_stage_Y.StartCtrl;
set(h_stage_Y, 'HWSerialNum', yChannel); pause(0.1);
h_stage_Y.Identify;
b = h_stage_Y.EnableEventDlg(0); 

h_stage_Z = actxcontrol('MGMOTOR.MGMotorCtrl.1', [10 10 350 250], f); %[startX startY w h]
h_stage_Z.StartCtrl;
set(h_stage_Z, 'HWSerialNum', zChannel); pause(0.1);
h_stage_Z.Identify;
c = h_stage_Z.EnableEventDlg(0); 


%% Set Velocity / Accl values
timer = 130;  
setVelx= h_stage_X.SetVelParams(0,0,ax,vx); %inputs: (chanID,minVel,Acc,maxVel)
setVely= h_stage_Y.SetVelParams(0,0,ay,vy); %inputs: (chanID,minVel,Acc,maxVel)
setVelz= h_stage_Z.SetVelParams(0,0,az,vz); %inputs: (chanID,minVel,Acc,maxVel)

disp ('stages initialized'); 

%% Hoarding: code that could be used later

% if 0 will comment out everything below
%not sure what this user_data is for
if 0
user_data.h_stage_X = h_stage_X;
user_data.h_stage_Y = h_stage_Y;
set(f, 'UserData', user_data);

%start control
h_control = actxcontrol('MG17SYSTEM.MG17SystemCtrl.1',[20 20 600 650], f);
h_control.StartCtrl;
user_data.h_control = h_control;
set(f, 'UserData', user_data);

%get stages
[~, num_stage] = h_control.GetNumHWUnits(6, 0);
if num_stage ~= 3
    fprintf(['Check the number of connected stages (Found' num2str(num_stage) ')!\n']);
    %return
end
disp('0');
%set stages
SN_stage = cell(1,3);
for count = 1 : num_stage
    [~, SN_stage{count}] = h_control.GetHWSerialNum(6, count - 1, 0); %Get the serial number of the devices
end
disp(SN_stage{1});
disp(SN_stage{2});
disp(SN_stage{3});
disp(SN_stage{count});

h_control.StopCtrl;
end %end if 0
