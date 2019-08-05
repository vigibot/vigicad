/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for vigibot U bracket for robot head
 * Author:      Gilles Bouissac
 */

use <lib/servoSg90.scad>
use <lib/uBracket.scad>

AXIS_POS_Z = 29;
U_ANGLE    = 45;
U_BASE_Z   = 3;
U_BASE_X   = 12.5;
U_BASE_Y  =  14; // Small side, large side is automatic
U_HOLES = [
 [-9.5,  + 0],
 [-3.0,  +12],
 [-3.0,  -12]
];

UBOTTOM_W = getUBracketMainW()-2*getUBracketBevel();
PRISM_L   = getUBracketOutsideL()-2*getUBracketBevel();

// UBracket bottom point after rotation
BOT_POST_ROT_X=
    +UBOTTOM_W/2*cos(U_ANGLE) ;
BOT_POST_ROT_Z=
    -UBOTTOM_W/2*sin(U_ANGLE) ;

// UBracket top point after rotation
TOP_POST_ROT_X=
    -UBOTTOM_W/2*cos(U_ANGLE) ;
TOP_POST_ROT_Z=
    +UBOTTOM_W/2*sin(U_ANGLE) ;

// UBracket bottom point target location
BOT_TARGET_X = BOT_POST_ROT_X-TOP_POST_ROT_X;
BOT_TARGET_Z = 0;

// UBracket top point target location
TOP_TARGET_X = 0;
TOP_TARGET_Z = TOP_POST_ROT_Z-BOT_POST_ROT_Z;


module uBracketClampPrism() {
    translate( [ 0, PRISM_L/2, 0 ])
    rotate( [90,0,0] )
    linear_extrude( height=PRISM_L ) {
        polygon([
            [0,0],
            [BOT_TARGET_X,0],
            [0,TOP_TARGET_Z],
            [0,0]
        ]);
    }
}

module uBracketClampBase() {
    linear_extrude( height=U_BASE_Z ) {
        polygon([
            [0,PRISM_L/2],
            [-0.5,PRISM_L/2],
            [-U_BASE_X,+U_BASE_Y/2],
            [-U_BASE_X,-U_BASE_Y/2],
            [-0.5,-PRISM_L/2],
            [0,-PRISM_L/2]
        ]);
    }
}

module uBracketClampShapes() {
    translate( [ -TOP_POST_ROT_X, 0, -BOT_POST_ROT_Z ])
    rotate([0,U_ANGLE,0])
        uBracket(AXIS_POS_Z);
    uBracketClampPrism();
    uBracketClampBase();
}

module uBracketClampHoles() {
    for ( holeParams=U_HOLES )
        translate ( [holeParams[0], holeParams[1], -7] )
        rotate( [180,0,0] )
        screwM2 ( 0, 10, 2 );
}

module uBracketClampServo(bodyRotation=0) {
    translate( [ -TOP_POST_ROT_X, 0, -BOT_POST_ROT_Z ])
    rotate([0,U_ANGLE,0])
        uBracketServo(AXIS_POS_Z,bodyRotation=bodyRotation+180);
}

module uBracketClamp() {
    difference() {
        uBracketClampShapes();
        uBracketClampHoles();
    }
}

// ------------------------------
//
//   Debug section
//
// ------------------------------

 uBracketClamp();
%uBracketClampServo();
%uBracketClampHoles();


