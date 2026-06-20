/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for the smiling pan & tilt smiling head, part of the Vigibot robot "Minus"
 * Design:      Quillès Jonathan / Pascal Piazzalungua
 * Author:      Quillès Jonathan
 */

use <../lib/servo_sg90.scad>
use <../lib/servo_sg90_container.scad>

PRECISION = 100;

$fn = PRECISION;

BOTTOM_THICKNESS = 1.2;
HEAD_Z = servoContainerZ() + BOTTOM_THICKNESS ;
HEAD_TOP_X = 32;
HEAD_BOT_X = servoContainerX(); 
HEAD_BOT_Y = 19.75;
HEAD_TOP_Y = 16.25;
HEAD_CHAMFER = (HEAD_TOP_X - HEAD_BOT_X) / 2;
SERVO_CENTER_Z = 6.25;

module box() {
    servoContainer( counterAxis=true );
}

module chamfer() {
    translate ([0, 0, HEAD_Z])
    rotate([0, 90, 0])
    linear_extrude(height = HEAD_BOT_X)
        polygon([
            [BOTTOM_THICKNESS,0], 
            [0,BOTTOM_THICKNESS], 
            [0,0]
        ]);
}

module topHead() {
    difference() {
        linear_extrude (height = HEAD_Z)
            polygon([
                [0,0], 
                [HEAD_BOT_X,0], 
                [HEAD_BOT_X, HEAD_BOT_Y],
                [HEAD_BOT_X + HEAD_CHAMFER,     HEAD_BOT_Y + HEAD_CHAMFER], 
                [HEAD_BOT_X + HEAD_CHAMFER,     HEAD_BOT_Y + HEAD_CHAMFER + HEAD_TOP_Y],
                [HEAD_BOT_X + HEAD_CHAMFER, HEAD_BOT_Y + HEAD_CHAMFER + HEAD_TOP_Y],
                [HEAD_BOT_X, HEAD_BOT_Y + 2 * HEAD_CHAMFER + HEAD_TOP_Y ],
                [0, HEAD_BOT_Y + 2 * HEAD_CHAMFER + HEAD_TOP_Y ],
                [-HEAD_CHAMFER,  HEAD_BOT_Y + HEAD_CHAMFER + HEAD_TOP_Y],
                [-HEAD_CHAMFER,  HEAD_BOT_Y + HEAD_CHAMFER],
                [0,  HEAD_BOT_Y]            
        ]);
        chamfer();
        cube([servoContainerX(), servoContainerY(), servoContainerZ()]);
    }
}

module head() {
    box();
    topHead(); 
}

module cameraHoles() {
    ENTRAXEA = 27.5;
    ENTRAXEB = 13.5;
    translate([ENTRAXEA/2, ENTRAXEB/2, 0])
        cylinder(r = 1.2, 20, center = true);
    translate([-ENTRAXEA/2, ENTRAXEB/2, 0])
        cylinder(r = 1.2, 20, center = true);
    translate([ENTRAXEA/2, -ENTRAXEB/2, 0])
        cylinder(r = 1.2, 20, center = true);
    translate([-ENTRAXEA/2, -ENTRAXEB/2, 0])
        cylinder(r = 1.2, 20, center = true);
}

module smile() {
    difference() {
        cylinder(r = 10, 8, center = true); 
        translate([0, 6, 0])
            cube([20, 20, 10], center = true);
        
    } 
}

module smilingHead() {
    difference() {
        head();
        servoContainerTransform()
            servoScrewHoles();
        translate([HEAD_BOT_X/2, 28.75, SERVO_CENTER_Z])
           cameraHoles();
        translate([HEAD_BOT_X/2, 15, 12])
        smile();
    }
}

difference () {
    rotate([180, 0, 0])
        smilingHead();

    if ( 0 ) {
        import( "../../stl/head_servo_camera_bracket_smile.stl" );
    }
}

if ( 0 ) {
    rotate([180, 0, 0])
    %servoContainerTransform() {
        servo();
        servoScrewHoles();
    }
    %import( "../../stl/head_servo_camera_bracket_smile.stl" );
}


