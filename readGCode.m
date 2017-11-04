function [values] = readGCode(gcode, count)
%Function recieves a line of gcode and it extracts the relavent values.
%The output is an array. The output values are in the following order: G#, 
%X# Y#, Z#, and then I#, J#, K# (if IJK values exist). The function only 
%accepts G1, G2, or G3 commands. The IJK format should be used for G2/G3 
%commands (not the R format).

%return if not G1, G2, or G3 command
if ~strncmp(gcode, 'G1 ', 3) && ...
    ~strncmp(gcode, 'G2 ', 3) && ...
        ~strncmp(gcode, 'G3 ', 3) && ...
            ~strncmp(gcode, 'G92 ', 4)&&...
                ~strncmp(gcode, 'M300 ',5)
    values(1) = 0;
    return;
end

%get all the numbers from the string
input = sscanf(gcode, ...
            '%*c %f %*c %f %*c %f %*c %f %*c %f %*c %f %*c %f');

%define the array 'values'  
values = zeros(1,10);
values(1) = input(1);
values(10) = count; 
%for loop that puts the values in the correct order. If Z# or K# is not
%specified it is set to 0;
char = '';
k = 2;
if values(1) == 300
    for i = 4:length(gcode)
        char = gcode(i);
        if strcmp(char, 'S')
            values(8) = input(k); 
            k = k+1;
        else
            fprintf('RG- Line %d Found M300 but not S\n',count); 
        end
    end
else 
    for i = 3:length(gcode)
        char = gcode(i);
        if strcmp(char, 'X')
           values(2) = input(k);
           k = k+1;
        elseif strcmp(char, 'Y')
           values(3) = input(k);
           k = k+1;
       elseif strcmp(char, 'Z')
           values(4) = input(k);
           k = k+1;
       elseif strcmp(char, 'I')
           values(5) = input(k);
           k = k+1;
       elseif strcmp(char, 'J')
           values(6) = input(k);
           k = k+1;
       elseif strcmp(char, 'K')
           values(7) = input(k);
           k = k+1;
       elseif strcmp(char, 'S')
           values(8) = input(k);
           k = k+1;
       elseif strcmp(char, 'F')
           values(9) = input(k);
           k = k+1;
       elseif strcmp(char, 'R')
            error('Use IJK format for arcs')
        else
            fprintf('RG- Item not found in line %d: %s\n',count,gcode(i)); 
       end
    end
end
end %end of function

