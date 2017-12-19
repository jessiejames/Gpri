%Controls one stage
function TwoDrivers(stage1, location1, a1, v1, stage2, location2, a2, v2); 
% change newLocation to the position to move
% change SN to the serial number of the chosen stage
    % x = 90872005;
    % y = 90872006;
    % z = 90872007;

switch (stage1)
    case 'x' 
        SN1 = 90872005;
    case 'y'
        SN1 = 90872006;
    case 'z'
        SN1 = 90872007;
    otherwise
        SN1 = 0;
end

switch (stage2)
    case 'x' 
        SN2 = 90872005;
    case 'y'
        SN2 = 90872006;
    case 'z'
        SN2 = 90872007;
    otherwise
        SN2 = 0;
end


newLocation1 = location1; %change this to set the new location to move to
newLocation2 = location2; %change this to set the new location to move to

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
set(stage,'HWSerialNum', SN1);
stage.Identify;

setVel1 = stage.SetVelParams(0,0,a1,v1); %inputs: (chanID,minVel,Acc,maxVel)

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
stage.SetAbsMovePos(0,newLocation1);
stage.MoveAbsolute(0,1==0);
disp('stage moving to ');
disp(newLocation); 

%Confirm Location / Position Again
stageNext = stage.GetPosition_Position(0);
disp('stageNext = '); 
disp(stageNext); 
stage1next= stage.GetAbsMovePos_AbsPos(0);
disp('stage1next = ');
disp(stage1next);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Repeat for the second stage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(stage,'HWSerialNum', SN2);
stage.Identify;

setVel2 = stage.SetVelParams(0,0,a2,v2); %inputs: (chanID,minVel,Acc,maxVel)

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
stage.SetAbsMovePos(0,newLocation2);
stage.MoveAbsolute(0,1==0);
disp('stage moving to ');
disp(newLocation); 

%Confirm Location / Position Again
stageNext = stage.GetPosition_Position(0);
disp('stageNext = '); 
disp(stageNext); 
stage1next= stage.GetAbsMovePos_AbsPos(0);
disp('stage1next = ');
disp(stage1next);


%% Memory clean up
%end control of handle for memory clean up
stage.StopCtrl;
