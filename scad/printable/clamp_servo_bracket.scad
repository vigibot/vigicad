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

PRECISION=50;

$fn = PRECISION;

MAIN_X = 33;
MAIN_Y = 33;
MAIN_Z = 25;

GEAR_BOX_X = 23;
GEAR_BOX_Y = 10.5;
GEAR_BOX_Z = 16.5;


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

module mainBoxHoles () {
// Full-Traversal on Y
    // Left cut
    translate ( [ -0.5, MAIN_Y/2-(MAIN_Y+10)/2, MAIN_Z-12.5])
        cube( [2.0, MAIN_Y+10, 13] );
    // Right cut
    translate ( [ MAIN_X-1.5, MAIN_Y/2-(MAIN_Y+10)/2, MAIN_Z-12.5])
        cube( [2.0, MAIN_Y+10, 13] );
    // Middle cut
    translate ( [ 9.2, MAIN_Y/2-(MAIN_Y+10)/2, MAIN_Z-12.5])
        cube( [2.8, MAIN_Y+10, 13] );

// Full-Traversal on Z
    // Middle cut
    translate ( [ 5, 5, MAIN_Z/2-(MAIN_Z+10)/2])
        cube( [23, 23, MAIN_Z+10] );

// Full-Traversal on X
    // Middle cut (clamp servo handles)
    translate ( [ MAIN_X/2-(MAIN_X+10)/2, MAIN_Y-12, -0.5 ])
        cube( [MAIN_X+10, 2.8, 13] );
    // Bevel
    translate ( [ -5, 0, 0 ])
    rotate( [0,90,0] )
    linear_extrude ( height=MAIN_X+10 )
        polygon ( [
            [0,0], [0,4.5], [-4.5,0]
        ]);

// Semi-Traversal on Y
    // Servo horn hole
    translate ( [ MAIN_X-5, MAIN_Y/2, 0 ])
    rotate( [-90,0,0] )
    linear_extrude ( height=MAIN_Y )
        polygon ( [
            [0,0], [-14.75,0], [-14.75,-8.25],
            [-10.5,-12.5], [0,-12.5]
        ]);

    // Little triangle at the top of servo
    translate ( [ MAIN_X-9, 2.5, 3.5])
    rotate( [-90,0,0] )
    linear_extrude ( height=10 )
        polygon ( [
            [0,0], [0,-4], [-4,-4]
        ]);

    // Little triangle at the bottom of servo
    translate ( [ MAIN_X-15.5, MAIN_Y-2.5-2.5, 12.5])
    rotate( [-90,0,0] )
    linear_extrude ( height=2.5 )
        polygon ( [
            [0,0], [2.5,0], [2.5,-2.5]
        ]);

// Semi-Traversal on Z
    // Left cut
    translate ( [ 0, 5, 12.5])
        cube( [10, 23, 13] );
    // Right cut
    translate ( [ MAIN_X-5-8, 2.5, 7.5])
        cube( [8, 28, MAIN_Z] );

// Semi-Traversal on X
    // Right hollow
    translate ( [ MAIN_X-7.5, 5, 0])
        cube( [5, 8, 12.5] );

    // Right cut
    translate ( [ MAIN_X-9, 2.5, 3.5])
        cube( [10, 5, 9] );

}

module mainBox() {
    difference () {
        // main cube
        cube( [MAIN_X, MAIN_Y, MAIN_Z] );
        mainBoxHoles ();
    }
}

module gearBoxHoles () {

// Full-Traversal on X

    // Middle cut
    translate ( [ GEAR_BOX_X/2-(GEAR_BOX_X+10)/2, 0, 0 ])
    rotate( [0,90,0] )
    linear_extrude ( height=GEAR_BOX_X+10 )
        polygon ( [
            // -0.001 to avoid manifold problems
            [0,0], [0,8], [-12.5,8], [-14,6.5], [-14,1.5], [-12.5-0.001,0]
        ]);

    // Bevel
    translate ( [ GEAR_BOX_X/2-(GEAR_BOX_X+10)/2, GEAR_BOX_Y, GEAR_BOX_Z-3 ])
    rotate( [0,90,0] )
    linear_extrude ( height=GEAR_BOX_X+10 )
        polygon ( [
            [0,0], [-3,0], [-3,-3]
        ]);


}

module clampStand () {
    rotate( [90,0,0] )
    rotate_extrude()
    polygon ( [
        [0,0], [5,0], [2.5,1.4], [0,1.4]
    ]);
}

module gearBox() {
    translate ( [ (MAIN_X-GEAR_BOX_X)/2, MAIN_Y, 0]) {
        difference () {
            // main cube
            cube( [GEAR_BOX_X, GEAR_BOX_Y, GEAR_BOX_Z] );
            gearBoxHoles ();
        }
        translate ( [ 6.1, GEAR_BOX_Y-2.5, 6.25])
            clampStand();
        translate ( [ GEAR_BOX_X-6.1, GEAR_BOX_Y-2.5, 6.25])
            clampStand();
    }
}

module makeBoxes() {
    mainBox();
    gearBox();
}

module clampHolder() {
    difference() {
        makeBoxes();

    // Screws on Y
        // Clamp screws
        translate ( [ (MAIN_X-GEAR_BOX_X)/2+6.1, MAIN_Y+GEAR_BOX_Y, 6.25]) {
            rotate( [90,0,0] )
                drillScrew ( 10, 40 );
        }
        translate ( [ (MAIN_X+GEAR_BOX_X)/2-6.1, MAIN_Y+GEAR_BOX_Y, 6.25]) {
            rotate( [90,0,0] )
                drillScrew ( 10, 40 );
        }

        // Servo handle screws
        translate ( [ 2.5, MAIN_Y, 6.25]) {
            rotate( [90,0,0] )
                drillScrew ( 20, 36 );
        }
        translate ( [ MAIN_X-2.5, MAIN_Y, 6.25]) {
            rotate( [90,0,0] )
                drillScrew ( 20, 36 );
        }

    // Screws on X
        translate ( [ 0, 2.5, MAIN_Z-6.25]) {
            rotate( [0,90,0] )
                drillScrew ( 20, 36 );
        }
        translate ( [ 0, MAIN_Y-2.5, MAIN_Z-6.25]) {
            rotate( [0,90,0] )
                drillScrew ( 20, 36 );
        }

        translate ( [ MAIN_X, 11.1, MAIN_Z-6.25]) {
            rotate( [0,90,0] )
                drillScrew ( 0, 20 );
        }
        translate ( [ MAIN_X, MAIN_Y-11.1, MAIN_Z-6.25]) {
            rotate( [0,90,0] )
                drillScrew ( 0, 20 );
        }
    }
}


// ------------------------------
//
//   Debug section
//
// ------------------------------
clampHolder();




