/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for Vigibot usb bracket
 * Design:      Quillès Jonathan 
 * Author:      Gilles Bouissac / Quillès Jonathan
 */

use <../lib/hardware_shop.scad>
use <../lib/servo_sg90.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

module headPanBracket() {
    difference() {
        minkowski() {
           bracketShape();
           bracketBevel();
        }
        rotate( [180,90,0] ) {
            translate( [20.3,5.5,-6.5] ) {
                servo(180,bodyRotation=0);
                servoScrewHoles( bodyRotation=0 );
            }
        } 
        bracketHoles();
       %bracketHoles();
    }
}

module bracketHoles() {
    rotate( [180,0,0] ) {
        translate( [HOLE1_X,+HOLE1_Y,6.5] ) screwM2(0,8);
        translate( [HOLE1_X,-HOLE1_Y,6.5] ) screwM2(0,8);
        translate( [HOLE2_X,+HOLE2_Y,6.5] ) screwM2(0,8);
    }
}

// ----------------------------------------
//            Implementation
// ----------------------------------------

MFG = 0.01; // 2 Manifold Guard
BEVEL = 0.5;

PLATE_SX  = 12.6 ;
PLATE_SY  = 44 ;
PLATE_SZ  = 3 ;

HOLLOW_SX = 11;
HOLLOW_SY = 19;
HOLLOW_X  = 12;
HOLLOW_Y  = -10.5;

HOLE1_X   = -2.5;
HOLE1_Y   = 12;

HOLE2_X   = -9;
HOLE2_Y   = 0;

CORNER_R  = 0;

TOOL_BASE_SX = 12;
TOOL_BASE_SY = 20; // Small side, large side is automatic

module bracketShape() {
    difference() {
        union() {
            difference() {
                translate( [PLATE_SX/2-BEVEL/2,0,0] )
                    cube ( [PLATE_SX-BEVEL, PLATE_SY-2*BEVEL, PLATE_SZ-2*BEVEL], center=true);
                translate( [PLATE_SX-BEVEL-CORNER_R/2,+PLATE_SY/2-BEVEL-CORNER_R/2,0] )
                    cube ( [CORNER_R+MFG, CORNER_R+MFG, PLATE_SZ*2], center=true);
                translate( [PLATE_SX-BEVEL-CORNER_R/2,-PLATE_SY/2+BEVEL+CORNER_R/2,0] )
                    cube ( [CORNER_R+MFG, CORNER_R+MFG, PLATE_SZ*2], center=true);
            }
            translate( [PLATE_SX-CORNER_R,+PLATE_SY/2-CORNER_R,0] )
                cylinder(r=CORNER_R-BEVEL, h=PLATE_SZ-2*BEVEL, center=true);
            translate( [PLATE_SX-CORNER_R,-PLATE_SY/2+CORNER_R,0] )
                cylinder(r=CORNER_R-BEVEL, h=PLATE_SZ-2*BEVEL, center=true);
        }      
    }
    toolBase();
}

module bracketHoles() {
    rotate( [180,0,0] ) {
        translate( [HOLE1_X,+HOLE1_Y,6.5] ) screwM2(0,8);
        translate( [HOLE1_X,-HOLE1_Y,6.5] ) screwM2(0,8);
        translate( [HOLE2_X,+HOLE2_Y,6.5] ) screwM2(0,8);
    }
}

module toolBase() {
    height = PLATE_SZ-2*BEVEL;
    translate( [0,0,-height/2] )
    linear_extrude( height=height ) {
        polygon([
            [0,PLATE_SY/2-BEVEL],
            [-TOOL_BASE_SX+BEVEL,+TOOL_BASE_SY/2-BEVEL*sin(22.5)],
            [-TOOL_BASE_SX+BEVEL,-TOOL_BASE_SY/2+BEVEL*sin(22.5)],
            [0,-PLATE_SY/2+BEVEL]
        ]);
    }
}

module bracketBevel() {
    union() {
        cylinder(r1 = BEVEL, r2 = 0, h = BEVEL, center = false);
        translate([0, 0, -BEVEL])
            cylinder(r1 = 0, r2 = BEVEL, h = BEVEL, center = false);
    }
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
headPanBracket($fn=50);
% rotate( [180,90,0] ) {
    translate( [20.3,5.5,-6.5] ) {
            servo(180,bodyRotation=0);
            servoScrewHoles( bodyRotation=0 );
        }
    }
