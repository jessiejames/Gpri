clc; close all; clear; 
%We get each serial number in a structure wich fields are MFCS and MFCS-EZ.
SerialNumbers = mfcs_detect;
%
% We get the number of connected MFCS and MFCS.EZ devices.
NumberOfMFCSEZ = length(SerialNumbers.MFCSEZ);
%
HandleNumbers = SerialNumbers;
% Then we get the MFCS EZ connection handles in the field MFCS_EZ of the
% structure HandleNumbers.
for i=1:NumberOfMFCSEZ
    %Initialization of each MFCS EZ connexion, based on theirs serial
    %numbers.
    %HandleNumbers.MFCSEZ(i) = mfcs_init(SerialNumbers.MFCSEZ(i),'MFCS_EZ');
    HandleNumbers.MFCSEZ(i) = mfcs_init(SerialNumbers.MFCSEZ(i));
end
%
for i=1:NumberOfMFCSEZ
    % We set the desired channel to 1,
    ChanNumber = 1;
    %
    %then we measure the pressure value on this channel.
    %[PressureValue MeasureTime]=mfcs_read_chan(HandleNumbers.MFCSEZ(i),ChanNumber);
    %
    %Displaying of results in the Command Window.
    %str = sprintf('pressure on channel %d is : %d mBars',PressureValue, ChanNumber);
    str = "skipped mfcs_read_chan";
    disp(str);
end
%

%
%if 0
%for i=1:NumberOfMFCSEZ
%    mfcs_close(HandleNumbers.MFCSEZ(1));
%end
%end
%close all; 
%
% We end by getting the library unloaded when closing the last MFCS
% connection.
%mfcs_close(HandleNumbers(NumberOfMFCSEZ),'CloseLib');



%% HOARDING
if 0
SN = 46;% we choose one specific handle number.
% we look for the index of this MFCS in the SerialNumbers table.
for j=1:NumberOfMFCSEZ
    Index = find(SerialNumbers.MFCSEZ(i)==SN);
end
%
% We call the function mfcs_get_status which give us the state of the MFCS
% in MFCSStatus.
MFCSStatus = mfcs_get_status(HandleNumbers(Index));

end %end if 0 from HOARDING