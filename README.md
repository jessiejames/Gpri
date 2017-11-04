# Gpri

This is a repo for the Galinstan Printer created Summer 2017

# Important Files and File Paths
*note: Any section titled "Hoarder Stuff" is not active and just to save because it was interesting and could be used eventually

## SetAllHome.m
This file *must* be used when the machine is turned on and the computer recognizes the connections to initialize the actuators. 
- Setup: No setup, just run 
- Run Expectation: All actuators will move home (to zero / fully extended) very slowly. GUI will scroll through default actuator, then Z, Y, X.  
- Other Notes: order is Z, X, Y. The location values are usually wrong on GUI and will go negative. This is only during initialization. Sometimes you have to hit ok on a window too if a timeout occurs. 

## Zdriver.m
This file can be used to move each actuator arm individually.
- Setup: choose which actuator you want to use (x,y,z) & set to *axisOfChoice*. Then set *location* (0=extended to 50=max)
- Run Expectation: actuator of choice will move to location of choice very quickly.
- Other Notes: n/a

## GCodeToXYZgraphStatus.m
This file is the "main" file right now. 
- Setup: write the gcode (or can be text) file to *input*
- Run Expectation: the actuators initialize at (x,y,z):(25,25,0.5). Then the printer does a test for distance to stage. Then the file begins to print. GUI will show all three actuators' interfaces and a graph of the status.
- Other Notes: The file runs as follows: 
- - 1) sends the actuators to *initializeHandles.m* to be initialized. 
---- 2) parses a gcode file into understandable movements via *readGCode* (gcode style= Makerbot, gcode file created via Inkscape, currently *mechLines1.gcode*). 
---- 3) stores the parsed code into various arrays and text files for debugging or analyzing. 
---- 4) sends the movements to the actuators in *GPriMovement.m*
---- 5) closes handles of actuators for memory clean up and file saving.

### File Path for GCodeToXYZgraphStatus.m
GCodeToXYZgraphStatus.m
---initializeHandles.m
---readGCode.m
---GPriMovement.m
-------IsMoving.m
*** all other functions come from the matlab / microsoft COM object
