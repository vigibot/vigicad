/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for Vigibot usb bracket
 * Design:      Quillès Jonathan / Pascal Piazzalungua
 * Author:      Quillès Jonathan
 */

use <../lib/servo_sg90.scad>
use <../lib/plates.scad>

PRECISION = 100;

$fn = PRECISION;

SERVO_BOX_Z = 12.5;
SERVO_STAND_LENGTH = 33;
PLATE_WIDTH = 3;
INTER_AXIS = 21;
OFFSET_AXIS = 1;
RADIUS = 1.5;
AXIS_HEIGHT = 17.5;
PLATE_HEIGHT = 9;
CHAMFER = 4; 

plate();
difference(){
    box();
    #servoBracketExtrude();
}

// fixating plate
module plate() {
    difference() {
        translate ([-CHAMFER + OFFSET_AXIS, 
                        PLATE_WIDTH, 
                        SERVO_BOX_Z])
            rotate([90, 0, 0])  
                linear_extrude (PLATE_WIDTH)
                    polygon ( [
                        [CHAMFER, 0], 
                        [0, CHAMFER], 
                        [0, PLATE_HEIGHT],
                        [INTER_AXIS + 2 * CHAMFER, PLATE_HEIGHT], 
                        [INTER_AXIS + 2 * CHAMFER, CHAMFER], 
                        [INTER_AXIS  + CHAMFER, 0]
                    ]);
        
        // fixating holes 
        translate ([OFFSET_AXIS, 0, AXIS_HEIGHT])
            rotate([90, 0, 0])
                cylinder (r = RADIUS, h = 25, center = true);
        translate ([OFFSET_AXIS + INTER_AXIS, 0, AXIS_HEIGHT])
            rotate([90, 0, 0])
                cylinder (r = RADIUS, h = 25, center = true);
    }
}

// main body
module box() {
    translate ([INTER_AXIS/2 + OFFSET_AXIS, 
                (SERVO_STAND_LENGTH + PLATE_WIDTH)/2, 
                OFFSET_AXIS])
        {
            beveledRoundedPlate([INTER_AXIS, SERVO_STAND_LENGTH + PLATE_WIDTH, 2], 0);
            translate ([0, 0, 5.5])
                cube([INTER_AXIS, SERVO_STAND_LENGTH + PLATE_WIDTH, 12], center = true);
        }
}

// servo hole
module servoBracketExtrude() {
    translate( [
        servoBoxSizeX() - 4.25,
        servoAxisPosY() + 14.1, 
        servoBoxSizeZ()/2
    ])
        rotate([180,0,0]) {
            servo(180);
            servoScrewHoles();
        }
}
