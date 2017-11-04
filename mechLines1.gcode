(Scribbled version of /var/folders/y1/dbtx23s93fz7y60myffwzjmw0000gn/T/ink_ext_XXXXXX.svgZTGD8Y @ 3500.00)
( unicorn.py --tab="homing" --pen-up-angle=45 --pen-down-angle=50 --start-delay=150 --stop-delay=150 --xy-feedrate=3500 --z-feedrate=150 --z-height=0 --finished-height=0 --register-pen=true --x-home=0 --y-home=0 --num-copies=1 --continuous=false --pause-on-layer-change=false /var/folders/y1/dbtx23s93fz7y60myffwzjmw0000gn/T/ink_ext_XXXXXX.svgZTGD8Y )
G21 (metric ftw)
G90 (absolute mode)
G92 X0.00 Y0.00 Z0.00 (you are here)

M300 S50 (pen down)
G4 P150 (wait 150ms)
M300 S45 (pen up)
G4 P150 (wait 150ms)
M18 (disengage drives)
M01 (Was registration test successful?)
M17 (engage drives if YES, and continue)

(Polyline consisting of 1 segments.)
G1 X100.05 Y-49.95 F3500.00
M300 S50.00 (pen down)
G4 P150 (wait 150ms)
G1 X100.05 Y-40.05 F3500.00
G1 X199.95 Y-40.05 F3500.00
G1 X199.95 Y-49.95 F3500.00
G1 X100.05 Y-49.95 F3500.00
M300 S45.00 (pen up)
G4 P150 (wait 150ms)

(Polyline consisting of 1 segments.)
G1 X100.10 Y4.90 F3500.00
M300 S50.00 (pen down)
G4 P150 (wait 150ms)
G1 X199.90 Y4.90 F3500.00
G1 X199.90 Y-4.90 F3500.00
G1 X100.10 Y-4.90 F3500.00
G1 X100.10 Y4.90 F3500.00
M300 S45.00 (pen up)
G4 P150 (wait 150ms)


(end of print job)
M300 S45.00 (pen up)
G4 P150 (wait 150ms)
M300 S255 (turn off servo)
G1 X0 Y0 F3500.00
G1 Z0.00 F150.00 (go up to finished level)
G1 X0.00 Y0.00 F3500.00 (go home)
M18 (drives off)
