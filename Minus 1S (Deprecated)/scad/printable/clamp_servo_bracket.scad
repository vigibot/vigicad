/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for clamp holder part of Vigibot
 * Design:      Quillès Jonathan / Pascal Piazzalungua
 * Author:      Gilles Bouissac
 */

use <../lib/servo_sg90.scad>
use <../lib/servo_sg90_container.scad>
use <../lib/extensions.scad>
use <../lib/bevel.scad>
use <../lib/hardware_shop.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

module clampHolder() {
    difference() {
        makeBoxes();
        mainBoxExtrude ();
        clampHolderHoles();
    }
}

// ----------------------------------------
//             Implementation
// ----------------------------------------

MAIN_SX      = servoContainerY();
MAIN_SY      = servoContainerY();
MAIN_T       = 5;   // T = Wall Thickness
MAIN_B       = 4.5; // B = Bevel

GEARBOX_SX   = 23;
GEARBOX_SY   = 10.5;
GEARBOX_SZ   = 16.5;
GEARBOX_T    = 2.5; // T = Wall Thickness
GEARBOX_BO   = 3;   // Outer Bevel
GEARBOX_BI   = 1.5; // Inner Bevel

// Centering of clamp servo container to get a square shape
CENTERING    = (servoContainerY()-servoContainerX())/2;

// ----------------------------------------
//        Implementation: main box
// ----------------------------------------

// Move the handle servo Container to its position
module handleServoTransform() {
    translate ( [ CENTERING, 0, servoContainerZ() ] )
        children();
}

// Move the clamp servo Container to its position
module clampServoTransform() {
    translate ( [
        servoContainerY(),
        servoContainerY()-CENTERING,
        servoContainerZ() ] )
        rotate ( [0,0,-90] )
        rotate ( [180,0,0] )
    children();
}

// Parts to remove from main box
module mainBoxExtrude () {

// Bevel
    translate ( [ 0, 0, MAIN_SX ])
    rotate( [0,90,0] )
    bevelCutLinear( MAIN_SX, 2*MAIN_SX, $bevel=MAIN_B );

// Cut clamp servo hole for printability
    servoHoleB = 4.25;
    translate ( [ MAIN_SX-5, MAIN_SY-MAIN_T, 0 ])
    rotate( [-90,0,0] )
    linear_extrude ( height=MAIN_T )
        polygon ( [
            [0,0],
            [-servoHeadSizeY(),0],
            [-servoHeadSizeY(),-(servoHeadSizeZ()-servoHoleB)],
            [-(servoHeadSizeY()-servoHoleB),-servoHeadSizeZ()],
            [0,-servoHeadSizeZ()]
        ]);

// Cut handle container above bottom servo for printability
    translate ( [ MAIN_SX-15.5, MAIN_SY-2.5-2.5, 12.5])
    rotate( [-90,0,0] )
    linear_extrude ( height=2.5 )
        polygon ( [
            [0,0], [2.5,0], [2.5,-2.5]
        ]);

// Wire output
    translate ( [ MAIN_SX-9, 2.5, 3.5])
    rotate( [-90,0,0] )
    linear_extrude ( height=5 )
        polygon ( [
            [0,0],
            [-4,-4],
            [-4,-9],
            [10,-9],
            [10,0],
            [0,0]
        ]);
}

// 2 stacked servo containers plus some completion on clamp servo
module mainBox() {
    // Handle servo container
    handleServoTransform()
        servoContainer( symetry=true, counterAxis=true );

    // Clamp servo container
    clampServoTransform() {
        servoContainer();

        complT = 5;
        // Complete clamp servo top for better look
        translate([-CENTERING,0,0])
            cube( [complT, servoContainerY(), servoContainerZ()] );
        // Complete clamp servo top for better look
        translate ( [ servoContainerY()-complT-CENTERING, 0, 0 ] )
            cube( [complT, servoContainerY(), servoContainerZ()] );
    }
}

// ----------------------------------------
//        Implementation: gear box
// ----------------------------------------

// Move the gear box to its position
module gearBoxTransform() {
    translate ( [ (MAIN_SX-GEARBOX_SX)/2, MAIN_SY, 0])
        children();
}

// Parts to remove from gear box
module gearBoxExtrude () {

// Middle cut
    x2 = GEARBOX_SZ-GEARBOX_T;
    x1 = x2-GEARBOX_BI;
    y3 = GEARBOX_SY-GEARBOX_T;
    y2 = y3-GEARBOX_BI;
    y1 = GEARBOX_BI;
    translate ( [ GEARBOX_SX/2-GEARBOX_SX/2, 0, 0 ])
    rotate( [0,90,0] )
    linear_extrude ( height=GEARBOX_SX )
        polygon ( [
            [0,0],
            [0,y3],
            [-x1,y3],
            [-x2,y2],
            [-x2,y1],
            [-x1-mfg(),0] // This mfg is manatory Pascal remember
        ]);

// Bevel
    translate ( [ GEARBOX_SX, GEARBOX_SY, 0 ])
    rotate( [0,0,180] )
    rotate( [0,90,0] )
    bevelCutLinear( GEARBOX_SX, 2*GEARBOX_SZ, $bevel=GEARBOX_BO );
}

// One gear stand in gear box
module clampStand () {
    rotate( [90,0,0] )
    rotate_extrude()
    polygon ( [
        [0,0], [5,0], [2.5,1.4], [0,1.4]
    ]);
}

// The box that hold the gears from clamps
module gearBox() {
     gearBoxTransform() {
        difference () {
            // main cube
            cube( [GEARBOX_SX, GEARBOX_SY, GEARBOX_SZ] );
            gearBoxExtrude ();
        }
        translate ( [ GEARBOX_SX/2, GEARBOX_SY-GEARBOX_T, servoContainerZ()/2])
            mirrorY()
            translate ( [ -servoAxisPosY(), 0, 0])
            clampStand();
    }
}

// ----------------------------------------
//        Implementation: assembly
// ----------------------------------------

// Screw holes not already made by libraries
module clampHolderHoles() {

// Clamp screws for gearBox
    translate ( [ MAIN_SX/2, servoContainerY(), servoContainerZ()/2])
        mirrorY()
        translate ( [ -servoAxisPosY(), 0, 0])
        rotate( [90,0,0] )
        screwM2Tight(MAIN_T,GEARBOX_SY);

// Servo handle screws
    // We need them again to drill added parts from mainBox()
    clampServoTransform()
        servoContainerTransform()
        servoScrewHoles();
}

// Merges boxes
module makeBoxes() {
    mainBox();
    gearBox();
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
difference() {
    clampHolder($fn=100);
    if ( 0 ) {
        %import( "../../stl/clamp_servo_bracket.stl" );
    }
}

if ( 0 ) {
    %clampHolderHoles($fn=100);
    %handleServoTransform()
        servoContainerTransform() {
            servo(30);
            servoScrewHoles();
            mirrorX()
            servoCounterAxisHole();
        }
    %clampServoTransform()
        servoContainerTransform() {
            servo(135);
        }
    %import( "../../stl/clamp_servo_bracket.stl" );
}


