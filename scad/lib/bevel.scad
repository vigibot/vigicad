/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD API for beveling
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <extensions.scad>

RADIUSBEVEL = 0.5; // Default radius bevel
CUTTER_W    = 1;

function getRadiusBevel() = RADIUSBEVEL;

// ----------------------------------------
//                  API
// ----------------------------------------

// Double diagonal bevels distant from width extruded in line
module bevelCutLinear( length, width, b=RADIUSBEVEL ) {
    // Cutter
    translate ( [-width/2-mfg(), -CUTTER_W, 0] )
        cube( [width+2*mfg(),CUTTER_W,length+2*mfg()] );
    // Bevel
    if ( bevelActive() ) {
        mirrorY()
        translate ( [-width/2, 0, -mfg()] )
        linear_extrude( height=length+mfg(2) )
            bevelDiagonalSection ( b );
    }
}

// Double diagonal bevels distant from width extruded in quater of circle
module bevelCutArc( radius, width, angle=90, b=RADIUSBEVEL ) {
    translate ( [0, radius-radius*tan(angle/2), 0] )
    mirrorZ()
    translate ( [-radius, -radius, 0] ) {
        // Cutter
        rotate_extrude( angle=angle )
            bevelCutterSection ( radius, radius/cos(angle/2), width/2 );
        // Bevel
        if ( bevelActive() ) {
            rotate_extrude( angle=angle )
                translate ( [radius, width/2, 0] )
                rotate( [0,0,180] )
                bevelDiagonalSection ( b );
        }
    }
}

//
// ----------------------------------------
//            Implementation
// ----------------------------------------

function bevelActive() = is_undef($bevel) ? true : $bevel;

// This is a simple rectangle
module bevelCutterSection ( x1, x2, sizey ) {
    polygon([
        [x1,       0],
        [x2+mfg(), 0],
        [x2+mfg(), sizey+mfg()],
        [x1,       sizey+mfg()]
    ]);
}

// Section of a diagonal (linear 45 deg) bevel
module bevelDiagonalSection ( radius ) {
    polygon([
        [-mfg(),       -mfg()],
        [radius,       -mfg()],
        [-mfg(),       radius],
    ]);
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
$fn=100;

difference() {
    translate( [0,0,-1] )
    linear_extrude( height=2 )
    polygon([
        [5,5],
        [5,-10],
        [0,-15],
        [0,5]
    ]);
#
    union() {
        translate ( [5, 0, 0] )
            rotate( [90,0,0] )
            rotate( [0,0,90] )
            bevelCutLinear( 10, 2 );

        translate ( [0, 5, 0] )
            rotate( [90,0,0] )
            rotate( [0,0,-90] )
            bevelCutLinear( 20, 2 );

        translate ( [0, -15, 0] )
            rotate( [0,0,45] )
            rotate( [0,90,0] )
            bevelCutLinear( 5/cos(45), 2 );

        translate ( [5, -10, 0] )
            bevelCutArc( 5, 2, -45 );

        translate ( [0, -15, 0] )
            rotate( [0,0,180] )
            bevelCutArc( 1.5, 2, 135 );

        translate ( [5, 5, 0] )
            bevelCutArc( 5, 2 );
    }
}
