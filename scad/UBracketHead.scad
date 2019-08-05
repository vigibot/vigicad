/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for vigibot head U bracket
 * Author:      Gilles Bouissac
 */

use <lib/servoSg90.scad>

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
module armHalfShape() {
    translate( [0,0,0] )
    linear_extrude( height=AXIS_POS_Z ) {
        armHalfProfile();
    }
    translate( [0,0,AXIS_POS_Z] )
    rotate( [-90,0,0] )
    rotate_extrude( angle=-90 ) {
        armHalfProfile();
    }
}
module armShape() {
    armHalfShape();
    mirror([1,0,0])
        armHalfShape();
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

module makeShapes() {

// Main part
    mainShape();

// Arms
    translate( [0,U_INSIDE_L/2,0] )
        armShape();
    translate( [0,-U_INSIDE_L/2,0] )
        mirror([0,1,0])
        armShape();

// Servo stands
    translate( [0,-U_INSIDE_L/2,AXIS_POS_Z] )
        rotate( [-90,0,0] )
        servoStand();
    translate( [0,U_INSIDE_L/2,AXIS_POS_Z] )
        rotate( [90,0,0] )
        servoStand();

}

module uBracketHead() {
    difference() {

    // Render all positive shapes before removing negative ones
        makeShapes();

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
                bevelBar(AXIS_POS_Z);
            translate( [-MAIN_W/2,U_OUTSIDE_L/2,0] )
                mirror( [1,0,0] )
                bevelBar(AXIS_POS_Z);
            translate( [MAIN_W/2,-U_OUTSIDE_L/2,0] )
                mirror( [0,1,0] )
                bevelBar(AXIS_POS_Z);
            translate( [-MAIN_W/2,-U_OUTSIDE_L/2,0] )
                mirror( [0,1,0] )
                mirror( [1,0,0] )
                bevelBar(AXIS_POS_Z);
        }

    // Negative shape: Horizontal servo placeholder
        translate( [
            0,
            U_INSIDE_L/2-BEVEL-HEAD_BORDER_W,
            AXIS_POS_Z+servoAxisPosY()
        ])
        rotate( [0,0,90] )
        rotate( [90,0,0] ) {
            servo(180);
            servoCounterAxisHole(3,3,2+MFG);
        }

    // Negative shape: Vertical servo placeholder
        translate( [
            0,
            servoAxisPosY(),
            -servoSizeX()
        ])
        rotate( [0,90,0] ) {
            servo(0,2);
            servoCounterAxisHole(3,3,2+MFG);
        }
    }
}

uBracketHead();

// ------------------------------
//
//   Debut section
//
// ------------------------------

%
translate( [
    0,
    U_INSIDE_L/2-BEVEL-HEAD_BORDER_W,
    AXIS_POS_Z+servoAxisPosY()
])
rotate( [0,0,90] )
rotate( [90,0,0] ) {
    servo(180);
    servoCounterAxisHole(3,3,2);
}
%
translate( [
    0,
    servoAxisPosY(),
    -servoSizeX()
])
rotate( [0,90,0] ) {
    servo(0,2);
    servoCounterAxisHole(3,3,2);
}


