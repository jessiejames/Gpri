%%
%Script reads a text file containing GCode and converts it into XYZ
%coordinates. This data is output into a textfile.
%% INITIALIZATION

%%%% Clear Variables and Initialize Handles
clc; close All; clearvars; clear; 
dbstop if error; 
[hx, hy, hz] = initializeHandles(); %seperate handle initialization function

%%%% Set File Input & Output Names
%This will take Gcode but for now we'll input as txt so we can preview it
input = 'mechLines1.gcode';  
%input = 'TwoLittleLines6.txt';  %input can read txt or gcode files
%input = 'FourLittleLines.gcode';
%input = 'hndLogoSimpleLetters.gcode';
%input = 'sscpac.gcode'; 
output1 = 'RawData6.txt';        %data parsed from the gcode lines (command)
output2 = 'trashCommands6.txt';  %lines that are skipped are printed here

%%%% Initialize Variables and Arrays
commandCount = 0;       %counts all the gcode lines
errorCount = 0;         %counts the gcode lines that are skipped
offset = 25;            %offset due to the build plane
scaleFactor = 10;       %scaling used in Beta
pathRaw = [];           %array for raw data
trash = [];             %array for skipped commands
pathFinal = [];         %initialize final array path
CurrentStatus = [];     %an array to show each movement step by step
output = [];            %output movement commands sent to the GPri

%% MAIN

%%%% Parse Gcode Line by Line
%read in gcode from text file using textread function
gcode = textread(input,'%s','delimiter','\n'); 
numCommands = numel(gcode); %counts the number of lines in the gcode input file
%for loop scrolls through each line of gcode 
for j = 1:numCommands 
    commandCount = commandCount + 1; %increase command count
    %convert string into array of a single commands values
    command = readGCode(char(gcode(j)), commandCount); 

    if command(1) == 0 %command was not a movement or extrusion command
        errorCount = errorCount + 1; %increase the number of skipped lines
        trash = [trash; string(gcode{commandCount})]; %send skipped line to trash array
        %fprintf('GXYZ- Line %d is not G1-G3 or G92: %s\n',count,C); %debug
    else %add command to the path of movement
        command(2) = command(2)/scaleFactor + offset; %move home plate by offset
        command(3) = command(3)/scaleFactor + offset; %move home plate by offset
        pathRaw = [pathRaw; command]; %raw data
    end
end

%%%% Save Parsed Lines to Output Text Files for Debugging
%write data from path to output text file
fileID2 = fopen(output1,'w'); %RawData#.txt
fprintf(fileID2,'%f %f %f %f %f %f %f %f %f %f\n', pathRaw');
fclose(fileID2);
fileID3 = fopen(output2,'w'); 
fprintf(fileID3, '%s\n', trash'); %trashCommands#.t
fclose(fileID3); 

%%%% Seperate Parsed Lines into Arrays for Clarity
% This isn't necessary but for clarity, seperate values into seperate arrays
X = pathRaw (:,2);          %raw X values
Y = pathRaw (:,3);          %raw Y values
%Z = pathRaw (:,4);         %not used for now, could be used in 3D structures
E = pathRaw (:,8);          % extrusion
gcodeLine = pathRaw(:,10);  % an array to parallel the gcode file command lines
Xupdated = X;               % updated values will be updated due to Gcode analysis
Yupdated = Y;               % ^^^^
Eupdated = E;               % ^^^^
%Emin = min(E);             % ^^^^
motionCount =0;             % counts how many motion commands are sent


%%%% Analyze & Update the parsed directions based on extruder
% currently, this will analyze if the extruder is on or off and will offset
% the X & Y coordinates back by 1, to make sure it doesn't extrude after
% the movement has started
% TODO: this method is admittingly unneccesary and could be simplified in
% the movement function
k = 45;                                     % height of Z
for i = 1:length(pathRaw)                   % for the entire lenght of all the parsed movements
    if E(i) == 50                           % if the extruder is on
        k = 50;                             % set Z stage down to platform location
        Xupdated(i,:) = Xupdated(i-1,:);    % offset X to the previous X coordinate
        Yupdated(i,:) = Yupdated(i-1,:);    % offset Y to the previous Y coordinate
    elseif pathRaw(i,8) == 45               % if the extruder is off
        k = 45;                             % set Z stage above the platform location
        Xupdated(i,:) = Xupdated(i-1,:);    % offset X to the previous X coordinate
        Yupdated(i,:) = Yupdated(i-1,:);    % offset Y to the previous Y coordinate
    else 
        k = k;                              % otherwise keep Z where it is
    end
    Eupdated(i,:) = k;                      % update the Z location to Eupdated array
end

%%%% Send Movements to Printer and Plot Points
for i = 1:length(pathRaw)
            %if E(i) > Emin && X(i) > 0 && Y(i) > 0 %%if part is used for STL file conversion
            
            %Send moves to the printer
                %GPriMovement = printer motion function
                CurrentStatus = GPriMovement(hx,hy,hz,Xupdated(i),Yupdated(i),Eupdated(i),gcodeLine(i),motionCount); 
                %pathFinal is the array of points
                pathFinal = [pathFinal; Xupdated(i),Yupdated(i),Eupdated(i),motionCount,pathRaw(i,10)];
                motionCount = motionCount+1; 
                output = [output; CurrentStatus]; %debug to make sure the output of the motion function corresponds to pathFinal

            %Plot
                subplot(2,2,2);
                plot(pathFinal(:,1),pathFinal(:,2)); 
                % ^^ pathFinal 1 & 2 are X & Y values that were read while extrusion
                % was on
                grid on;  
                axis([0 50 0 50]);
                rotate3d on; 
               
end %end of for loop

 
%% CLOSE / MEMORY CLEAN UP

%%%% Move All Stages Home
%Move all actuators home first
hz.SetAbsMovePos(0,0);
hz.MoveAbsolute(0,1==0);
hy.SetAbsMovePos(0,50);
hy.MoveAbsolute(0,1==0);
hx.SetAbsMovePos(0,50);
hx.MoveAbsolute(0,1==0);

%%%% Close All Handles for Memory Clean Up
hx.StopCtrl;
hy.StopCtrl;
hz.StopCtrl; 
disp('Finished with GCode'); 

%% HOARDER STUFF

% commands I'm saving for reference or in case I need them
% the {if 0 -> end} statement will prevent it from running

%plot stuff
%plot3(path(:,1),path(:,2),path(:,3)); %3d plot format
%plot3(X,Y,E,'-'); %another way to write it
%figure; plot(pathRaw(:,2),pathRaw(:,3)); %compare all the read vals vs the
%movement 

%%%% start commenting out
if 0 
    % initialize Loop Logic
    initialPstring = '100'; 
    %initialPstring = input('input initial Pressure <default is 100>: ', 's');
    initialPressure = str2num(initialPstring);
    cont = 1; 
    k = 1; m = 5; 
    decreasePressure = 2; 
    currentPressure = initialPressure;
    printPause = 1; 

    while currentPressure > 1 && cont == 1 
        k = k + 1; 

        while printPause == 0 
            %start printing for statement 
            for i = 1:length(pathRaw)
                %if E(i) > Emin && X(i) > 0 && Y(i) > 0 %%if part is used for STL file conversion
                    CurrentStatus = GPriMovement(hx,hy,hz,Xupdated(i),Yupdated(i),Eupdated(i),gcodeLine(i),motionCount);
                    pathFinal = [pathFinal; Xupdated(i),Yupdated(i),Eupdated(i),motionCount,pathRaw(i,10)];
                    motionCount = motionCount+1; 
                    output = [output; CurrentStatus]; 

                    %plot
                    subplot(2,2,2);
                    plot(pathFinal(:,1),pathFinal(:,2)); 
                    % ^^ pathFinal 1 & 2 are X & Y values that were read while extrusion
                    % was on
                    grid on;  
                    axis([0 50 0 50]);
                    rotate3d on; 

                    disp('----- moving');
                    % Check to Pause
                    checkPause = input('-- PAUSE PRINT? y or n: ', 's');
                    if checkPause == 'y'
                        printPause = 1; 
                        disp('----- pause confirmed'); 
                    else
                        disp('----- pause not confirmed'); 
                    end
            end %end of for loop
        end %end of while print is not paused


        while printPause == 1

            % Check to SlowDown
            slowDown = input('SLOW DOWN PRESSURE? y or n: ', 's'); 
            if slowDown == 'y'
                disp('slowDown confirmed a yes'); 
                currentPressure = currentPressure / decreasePressure;
                fprintf('decreased pressure to %d\n', currentPressure);
            else 
                disp('slowDown was not confirmed');
            end

            % Check to speedUp
            speedUp = input('SPEED UP PRESSURE? y or n: ', 's'); 
            if speedUp == 'y'
                disp('speedUp confirmed a yes'); 
                increasePrString = input('input amount to increase: ', 's');
                increasePressure = str2num(increasePrString); 
                currentPressure = currentPressure + increasePressure;
                fprintf('increased pressure to %d\n', currentPressure);
            else 
                disp('speedUp was not confirmed');
            end


            % Check to un Pause
            checkPause = input('PLAY / CONTINUE WITH PRINT? y or n: ', 's');
            while checkPause ~= 'y'
                printPause = 1; 
                disp('Still Pause');

                %check to quit / continue
                checkContinue = input('STOP PRESSURE? y or n: ', 's');
                if checkContinue == 'y'
                    cont = 0;
                    disp('yes -> pressure set to zero= 0');
                    break; 
                else
                    disp('stop was not confirmed'); 
                end

                %check to return to pressure settings
                pressureSettings = input('TWEAK PRESSURE AGAIN? y or n: ', 's');
                if pressureSettings == 'y'
                    printPause = 1;
                    checkPause = 'y';
                    disp('returning to pressure settings confirmed');
                else
                    checkPause = input('PLAY / CONTINUE WITH PRINT? y or n: ', 's');
                end 
            end

            printPause = 0; 
            disp('Play continued');
        end
        fprintf('End of loop, pressure = %d\n',initialPressure); 

    end


    %plot final
    figure; plot(pathFinal(:,1),pathFinal(:,2)); 
    % ^^ pathFinal 1 & 2 are X & Y values that were read while extrusion
    % was on
    grid on;  
    axis equal;
    rotate3d on; 

end %end if 0
%%%% end of hoarder stuff

