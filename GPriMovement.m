% this will move the stages based on the values coming in 
function [status] = GPriMovement(stage_X, stage_Y, stage_Z, posX, posY, posE, GcodeCount, MoveCount);  
% inputs are the handles for X, Y, & Z stages as well as the position
% coordinates for X & Y and the Extruder
% also the GcodeCount / line count & MoveCount / motion count
status(4) = GcodeCount; %store the line count
status(5) = MoveCount;  %store the motion count
Zstatus = 0;            %start Zstatus to 0 / false

    
%% Z Motion: only moves when X & Y are done moving

%%%% Check if extruder (posE) is on (>0.5) and X & Y are past the origin
if posE > 45 && posX > 0 && posY > 0    
    stage_Z.SetAbsMovePos(0,4);            % preset locaiton to down on plate (won't move until "MoveAbsolute" is called)
    bX = stage_X.GetStatusBits_Bits(0);     % check to see if the stages are still moving
    bY = stage_Y.GetStatusBits_Bits(0);
    bZ = stage_Z.GetStatusBits_Bits(0);
    % Check if stages are done with last move
    while (IsMoving(bX) ~= 0 || IsMoving(bY) ~=0|| IsMoving(bZ) ~=0 ) 
        % if the handles bits aren't zero (still moving) check again & wait 1sec.
        bX = stage_X.GetStatusBits_Bits(0); 
        bY = stage_Y.GetStatusBits_Bits(0);
        bZ = stage_Z.GetStatusBits_Bits(0);
        pause (1); 
        %disp('waiting to lower Z -- X,Y, or Z is moving');         % debugger
        if Zstatus %if extruder is true / on, update stage locations - this is more for plotting
                status(1) = stage_X.GetPosition_Position(0);
                status(2) = stage_Y.GetPosition_Position(0);
                status(4) = GcodeCount; 
        end
    end
    %once stages have reached their destined location, update Z to move down using "MoveAbsolute" function 
    % Fire Position:  Lower Z / extruder
    stage_Z.MoveAbsolute(0,1==0); %(0,1==0) = (channel 0, true) ... no idea why they use 1==0... 
    Zstatus = 1; 
    status(:,3) = stage_Z.GetPosition_Position(0);  %update output record for Z 
    fprintf('Z movement lowered on count: %d\n', GcodeCount); %print to notify user that move was fired

%%%% Else: extruder is off or stages are at origin
else 
    stage_Z.SetAbsMovePos(0,0.5);            %preset location to 5 mm above plate / 0.5 mm down (won't move until "MoveAbsolute" is called)
    bX = stage_X.GetStatusBits_Bits(0);     % check to see if the stages are still moving
    bY = stage_Y.GetStatusBits_Bits(0);
    bZ = stage_Z.GetStatusBits_Bits(0);
    % Check if stages are done with last move
    while (IsMoving(bX) ~= 0 || IsMoving(bY) ~=0 || IsMoving(bZ) ~=0 )
        % if the handles bits aren't zero (still moving) check again & wait 1sec.
        bX = stage_X.GetStatusBits_Bits(0);
        bY = stage_Y.GetStatusBits_Bits(0);
        bZ = stage_Z.GetStatusBits_Bits(0);
        pause (1); 
        %disp('waiting to raise Z -- X,Y, or Z is moving');          % debugger
    end
    %once stages have reached their destined location, update Z to move up using "MoveAbsolute" function 
    % Fire Position: Raise Z / extruder
    stage_Z.MoveAbsolute(0,1==0); %(0,1==0) = (channel 0, true) ... no idea why they use 1==0... 
    Zstatus = 0; 
    status(:,3) = stage_Z.GetPosition_Position(0);  %update output record for Z 
    fprintf('Z movement raised on count: %d\n', GcodeCount); %print to notify user  that move was fired
end
%end of Z motion


%% X & Y Motion

stage_X.SetAbsMovePos(0,posX);  % preset the next position to the incoming position (won't move until "MoveAbsolute" is called)
stage_Y.SetAbsMovePos(0,posY);

% only fire next command if the previous command is finished. 
bX = stage_X.GetStatusBits_Bits(0);
bY = stage_Y.GetStatusBits_Bits(0);
bZ = stage_Z.GetStatusBits_Bits(0);
% Check if stages are done with last move
while (IsMoving(bX) ~= 0 || IsMoving(bY) ~=0 || IsMoving(bZ) ~=0 )
    % if the handles bits aren't zero (still moving) check again & wait 1sec.
    bX = stage_X.GetStatusBits_Bits(0);
    bY = stage_Y.GetStatusBits_Bits(0);
    bZ = stage_Z.GetStatusBits_Bits(0);
    pause (1); 
    disp('waiting to move X & Y -- X,Y, or Z is moving');
end
%once X & Y have reached their last command, engage next motion using "MoveAbsolute" function 
stage_X.MoveAbsolute(0,1==0);  
stage_Y.MoveAbsolute(0,1==0);
fprintf('X to %f & Y to %f on count: %d\n', posX, posY, GcodeCount); %print to notify user that move was fired


%% Hoarding : Code that I'm not using now but could be useful in the future
% won't run because of the {if 0 -> end} part
if 0 %debugger start 
status(1) = stage_X.GetPosition_Position(0);
status(2) = stage_Y.GetPosition_Position(0);
status(4) = count; 
end %debugger finish 



end %ends function

