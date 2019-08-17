/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for the smiling pan & tilt smiling head part of the Vigibot robot "Minus"
 * Design:      Quillès Jonathan / Pascal Piazzalungua
 * Author:      Quillès Jonathan
 */
use <../lib/extensions.scad>
use <../lib/bevel.scad>
use <../lib/plates.scad>

PRECISION = 100;

$fn = PRECISION;


HEAD_TOP_X = 32;
HEAD_BOT_X = 30; 
HEAD_BOT_Y = 19.75;
HEAD_TOP_Y = 16.25;
HEAD_CHAMFER = (HEAD_TOP_X - HEAD_BOT_X) / 2;

SERVO_BOX_X = 23;
SERVO_BOX_Z = 12.5;
SERVO_STAND_THICKNESS = 2.8;
SERVO_STAND_LENGTH = 33;
SERVO_STAND_OFFSET = 5.9;
SERVO_HEAD_WIDTH = 23;
SERVO_HEAD_HEIGHT = 5;
SERVO_CENTER_Z = 6.25;

PLATE_WIDTH = 3;
INTER_AXIS = 21;
OFFSET_AXIS = 9;
RADIUS = 1.5;
AXIS_HEIGHT = 17.5;
PLATE_HEIGHT = 9;


module box () {
    translate ( [10, 0, 0])
    cube([20, SERVO_STAND_LENGTH, SERVO_BOX_Z]);
    translate ( [INTER_AXIS/2 + OFFSET_AXIS, -PLATE_WIDTH/2, SERVO_BOX_Z/2]) 
    cube([INTER_AXIS, PLATE_WIDTH, SERVO_BOX_Z], center = true);
   difference() {
       translate ( [INTER_AXIS/2 + OFFSET_AXIS, -PLATE_WIDTH/2, SERVO_BOX_Z + PLATE_HEIGHT/2]) 
       rotate( [90,-90,0] )
       cube([PLATE_HEIGHT, 29, PLATE_WIDTH], center = true);
    translate ( [OFFSET_AXIS, 0, AXIS_HEIGHT])
    rotate( [90,0,0] )
    cylinder ( r=RADIUS, h=25, center=true );
    translate ( [OFFSET_AXIS + INTER_AXIS, 0, AXIS_HEIGHT])
    rotate( [90,0,0] )
    cylinder ( r=RADIUS, h=25, center=true );
    translate ( [5, 0, SERVO_BOX_Z])
    rotate( [90,0,0] )  
     linear_extrude ( height=HEAD_TOP_X+10 )
       
        polygon ( [
            [4,0], [0,4], [0,0]
        ]);
    translate ( [5 + 29, 0, SERVO_BOX_Z])
    rotate( [90,-90,0] )  
     linear_extrude ( height=HEAD_TOP_X+10 )
       
        polygon ( [
            [4,0], [0,4], [0,0]
        ]);
   }
}

module chamfer() {
    translate ( [ -5, -0.5, SERVO_BOX_Z ])
    rotate( [0,90,0] )
    linear_extrude ( height=HEAD_TOP_X+10 )
        polygon ( [
            [2.2,0], [0,2.2], [0,0]
        ]);
}

module servoInServoBracket () {
    //Servo Box
    cube([SERVO_BOX_X, SERVO_BOX_X, SERVO_BOX_Z], center = true);
    
    //Servo Stand
    translate ( [-SERVO_STAND_OFFSET, 0, 0 ])
        cube([SERVO_STAND_THICKNESS, SERVO_STAND_LENGTH, SERVO_BOX_Z], center = true);
    
    //Servo Head 
    translate ( [-SERVO_BOX_X /2 - SERVO_HEAD_HEIGHT/2 + 0.1, SERVO_HEAD_WIDTH/2 - SERVO_BOX_X /2, 0 ])
        cube([SERVO_HEAD_HEIGHT, SERVO_HEAD_WIDTH, SERVO_BOX_Z], center = true);
    
    //Space for wires
    translate ( [SERVO_BOX_X /2 - 4, +SERVO_BOX_X /2, 0 ])
        cube([8, 6, SERVO_BOX_Z], center = true);
        
}

module drillThread ( t=5 ) {
    cylinder ( r=0.9, h=t, center=true );
}

module drillHead ( h=5 ) {
    cylinder ( r=1.1, h=h, center=true );
}

module drillScrew ( h=5, t=10 ) {
    drillHead ( h=h );
    drillThread ( t=t );
}


module servoScrewHoles() {

    // Stand holes
    translate ( [ 0, 2.5, SERVO_CENTER_Z]) {
        rotate( [0,90,0] )
            drillScrew ( 20, 33 );
    }
    translate ( [ 0, 33-2.5, SERVO_CENTER_Z]) {
        rotate( [0,90,0] )
            drillScrew ( 20, 33 );
    }
}

module servoBracket() {
    difference () {
        box();
        translate ( [HEAD_BOT_X/2, SERVO_STAND_LENGTH/2, SERVO_CENTER_Z])
            servoInServoBracket ();
        servoScrewHoles();
    }
}

rotate( [180,0,0])
    servoBracket();
