%Controls one stage
clear; close all; clc;

% change newLocation to the position to move
% change axisOfChoice to the serial number of the chosen stage
    x = 90872005;
    y = 90872006;
    z = 90872007;

newLocation = 10; %change this to set the new location to move to
axisOfChoice = z; % change this serial number to change the stage you want to control

%% GUI: Set up figure container / window         
fpos    = get(0,'DefaultFigurePosition'); % figure default position
fpos(3) = 650; % figure window size;Width
fpos(4) = 450; % Height
f = figure('Position', fpos,...
           'Menu','None',...
           'Name','Z GUI');

%% Initialize       
% Create ActiveX Controller
% ALGORITHM TO INITIALIZE: 
    % actxcontrol function returns a handle
    % StartCtrl each handle
    % assign serial number
    % identify

stage = actxcontrol('MGMOTOR.MGMotorCtrl.1',[20 20 600 400 ], f);
stage.StartCtrl;
set(stage,'HWSerialNum', axisOfChoice);
stage.Identify;

pause(5); % waiting for the GUI to load up;

%% Movement
%Confirm Location / Position
stage0 = stage.GetPosition_Position(0);
disp('stage0 = '); 
disp(stage0); 
stage0next= stage.GetAbsMovePos_AbsPos(0);
disp('stage0next= ');
disp(stage0next); 

%Move to a Specified Location
stage.SetAbsMovePos(0,newLocation);
stage.MoveAbsolute(0,1==0);
disp('stage moving to ');
disp(newLocation); 

%Confirm Location / Position Again
stage1 = stage.GetPosition_Position(0);
disp('stage1 = '); 
disp(stage1); 
stage1next= stage.GetAbsMovePos_AbsPos(0);
disp('stage1next = ');
disp(stage1next);

%% Memory clean up
%end control of handle for memory clean up
stage.StopCtrl;
