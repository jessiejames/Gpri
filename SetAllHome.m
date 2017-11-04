% SetAllHome will move all the stages to their initial location and
% configure the actuators to their correct location

%clear all matlab variables
clear; close all; clc;
global h; % make h a global variable so it can be used outside the main
          % function. Useful when you do event handling and sequential           move
%% Create Matlab Figure Container / GUI
fpos    = get(0,'DefaultFigurePosition'); % figure default position
fpos(3) = 650; % figure window size;Width
fpos(4) = 450; % Height

 
f = figure('Position', fpos,...
           'Menu','None',...
           'Name','APT GUI');

%%%% Initialize Handles
% ALGORITHM TO INITIALIZE: 
    % actxcontrol function returns a handle
    % StartCtrl each handle
    % assign serial number
    % identify
    % turn off event dialog box
    % end control of the handle for memory clean up
    
%%Start Control    
h = actxcontrol('MGMOTOR.MGMotorCtrl.1',[20 20 600 400 ], f);    

%%%% Z handle / SN3
% changed it to Z first 
h.StartCtrl; 
SN3 = 90872007;
set(h,'HWSerialNum', SN3);
h.Identify;
pause(3);
k = h.GetPosition_Position(0);
h.MoveHome(0,1);
c = h.EnableEventDlg(0);
zC = 0; 
zB = h.GetStatusBits_Bits(0);
while (IsMoving(zB) ~= 0)
    zB = h.GetStatusBits_Bits(0);
    zC = zC + 1; 
    pause (1); 
    fprintf('Time for Z home = %d\n', zC);
end
fprintf('-----\n');
h.StopCtrl;    
    
%%%% X handle / SN1
h.StartCtrl;
SN1 = 90872005;
set(h,'HWSerialNum', SN1);
h.Identify;
pause(3);
k = h.GetPosition_Position(0);
h.MoveHome(0,1);
a = h.EnableEventDlg(0);
xC = 0; 
xB = h.GetStatusBits_Bits(0);
while (IsMoving(xB) ~= 0)
    xB = h.GetStatusBits_Bits(0);
    xC = xC + 1; 
    pause (1); 
    fprintf('Time for X home = %d\n', xC);
end
fprintf('-----\n');
h.StopCtrl; 

%%%% Y handle / SN2
h.StartCtrl; 
SN2 = 90872006;
set(h,'HWSerialNum', SN2);
h.Identify;
pause(3);
k = h.GetPosition_Position(0);
h.MoveHome(0,1);
b = h.EnableEventDlg(0);
yC = 0; 
yB = h.GetStatusBits_Bits(0);
while (IsMoving(yB) ~= 0)
    yB = h.GetStatusBits_Bits(0);
    yC = yC + 1; 
    pause (1); 
    fprintf('Time for Y home = %d\n', yC);
end
fprintf('-----\n');  
h.StopCtrl;



disp('Last command fired');