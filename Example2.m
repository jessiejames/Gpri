
% Two drivers format:
%   TwoDrivers(stage1, location1, a1, v1, stage2, location2, a2, v2);
%   OneDriver(stage, location, a, v);
% solve for time where...
%   positionFinal = a(t^2) + vt + positionInitial
%   reset pause time below

t = 30;   % pause time 

TwoDrivers('x',25,1,1,'y',25,1,1); % move to 25
pause (t); 
TwoDrivers('x',0,1,1,'y',0,1,1);  % move to zero
