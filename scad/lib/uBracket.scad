/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for vigibot generic U bracket for servo
 * Author:      Gilles Bouissac
 */

use <servoSg90.scad>

PRECISION=50;
MFG = 0.01; // 2 Manifold Guard

$fn = PRECISION;

BEVEL = 1.5;
AXIS_POS_Z = 22;
MAIN_W = 12;
MAIN_T = 5; // Thickness
ARM_W = 12;
ARM_T = 3.5; // Thickness
U_INSIDE_L = 34;
U_OUTSIDE_L = U_INSIDE_L+2*ARM_T;

// We need this for correct servo placement
HEAD_BORDER_W = 3;

function getUBracketBevel()    = BEVEL;
function getUBracketMainW()    = MAIN_W;
function getUBracketMainT()    = MAIN_T;
function getUBracketArmW()     = ARM_W;
function getUBracketArmT()     = ARM_T;
function getUBracketInsideL()  = U_INSIDE_L;
function getUBracketOutsideL() = U_OUTSIDE_L;

module armHalfProfile() {
    polygon([
        [0,0],
        [ARM_W/2,0],
        [ARM_W/2,ARM_T-BEVEL],
        [ARM_W/2-BEVEL,ARM_T],
        [0,ARM_T],
        [0,0]
    ]);
}
module armHalfShape(axisZ) {
    translate( [0,0,0] )
    linear_extrude( height=axisZ ) {
        armHalfProfile();
    }
    translate( [0,0,axisZ] )
    rotate( [-90,0,0] )
    rotate_extrude( angle=-90 ) {
        armHalfProfile();
    }
}
module armShape(axisZ) {
    armHalfShape(axisZ);
    mirror([1,0,0])
        armHalfShape(axisZ);
}

module mainQuaterProfile() {
    polygon([
        [0,0],
        [MAIN_W/2-BEVEL,0],
        [MAIN_W/2,BEVEL],
        [MAIN_W/2,MAIN_T-BEVEL],
        [MAIN_W/2-BEVEL,MAIN_T],
        [0,MAIN_T],
        [0,0],
    ]);
}
module mainQuaterShape() {
    rotate( [90,0,0] )
    linear_extrude( height=U_INSIDE_L/2+ARM_T ) {
        mainQuaterProfile();
    }
}
module mainHalfShape() {
    mainQuaterShape();
    mirror([0,1,0])
        mainQuaterShape();
}
module mainShape() {
    mainHalfShape();
    mirror([1,0,0])
        mainHalfShape();
}


module servoStand () {
    rotate_extrude()
    polygon ( [
        [0,0], [6,0], [4.5,1.5], [0,1.5]
    ]);
}

module bevelBar ( h ) {
    // bevel parts that overlap
    linear_extrude( height=h ) {
        polygon ( [
            [MFG,MFG], [MFG,-BEVEL], [-BEVEL,MFG], [MFG,MFG]
        ]);
    }
}

module uBracketServoShapes(axisZ) {

// Main part
    mainShape();

// Arms
    translate( [0,U_INSIDE_L/2,0] )
        armShape(axisZ);
    translate( [0,-U_INSIDE_L/2,0] )
        mirror([0,1,0])
        armShape(axisZ);

// Servo stands
    translate( [0,-U_INSIDE_L/2,axisZ] )
        rotate( [-90,0,0] )
        servoStand();
    translate( [0,U_INSIDE_L/2,axisZ] )
        rotate( [90,0,0] )
        servoStand();

}

module uBracketServo( axisZ=AXIS_POS_Z, bodyRotation=0 ) {
    translate( [
        0,
        U_INSIDE_L/2-BEVEL-HEAD_BORDER_W,
        axisZ+servoAxisPosY()
    ])
    rotate( [0,0,90] )
    rotate( [90,0,0] ) {
        difference() {
            servo(180,bodyRotation=bodyRotation);
            servoScrewHoles( bodyRotation=bodyRotation );
        }
        servoCounterAxisHole(3,3,2);
    }
}

module uBracket( axisZ=AXIS_POS_Z ) {
    difference() {

    // Render all positive shapes before removing negative ones
        uBracketServoShapes(axisZ);

    // Negative shape: Final beveling
        union() {
            // Bevels aligned on X
            translate( [-MAIN_W/2,U_OUTSIDE_L/2,0] )
                rotate( [0,90,0] )
                bevelBar(MAIN_W);
            translate( [-MAIN_W/2,-U_OUTSIDE_L/2,0] )
                rotate( [0,90,0] )
                mirror( [0,1,0] )
                bevelBar(MAIN_W);

            // Bevels aligned on Y
            translate( [MAIN_W/2,-U_OUTSIDE_L/2,0] )
                rotate( [-90,0,0] )
                bevelBar(U_OUTSIDE_L);
            translate( [-MAIN_W/2,-U_OUTSIDE_L/2,0] )
                rotate( [-90,0,0] )
                mirror( [1,0,0] )
                bevelBar(U_OUTSIDE_L);

            // Bevels aligned on Z
            translate( [MAIN_W/2,U_OUTSIDE_L/2,0] )
                bevelBar(axisZ);
            translate( [-MAIN_W/2,U_OUTSIDE_L/2,0] )
                mirror( [1,0,0] )
                bevelBar(axisZ);
            translate( [MAIN_W/2,-U_OUTSIDE_L/2,0] )
                mirror( [0,1,0] )
                bevelBar(axisZ);
            translate( [-MAIN_W/2,-U_OUTSIDE_L/2,0] )
                mirror( [0,1,0] )
                mirror( [1,0,0] )
                bevelBar(axisZ);
        }

    // Negative shape: Horizontal servo placeholder
        uBracketServo( axisZ );
    }
}

// ------------------------------
//
//   Debug section
//
// ------------------------------

 uBracket( 22 );
%uBracketServo( 22, 40 );


