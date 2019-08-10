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

MFG = 0.01; // 2 Manifold Guard
RADIUSBEVEL = 0.5; // Default radius bevel
CUTTER_W    = 1;

function getRadiusBevel() = RADIUSBEVEL;

// ----------------------------------------
//                  API
// ----------------------------------------

// Double diagonal bevels distant from width extruded in line
module bevelCutLinear( length, width, b=RADIUSBEVEL ) {
    // Cutter
    translate ( [-width/2-MFG, -CUTTER_W, 0] )
        cube( [width+2*MFG,CUTTER_W,length+2*MFG] );
    // Bevel
    mirrorY()
    translate ( [-width/2, 0, -MFG] )
    linear_extrude( height=length+2*MFG )
        bevelDiagonalSection ( b );
}

// Double diagonal bevels distant from width extruded in quater of circle
module bevelCutArc( radius, width, b=RADIUSBEVEL ) {
    // Cutter
    cutterCubeW = radius+CUTTER_W;
    translate ( [-radius, -radius, 0] )
        difference() {
            translate ( [cutterCubeW/2, cutterCubeW/2, 0] )
                cube( [cutterCubeW,cutterCubeW,width+2*MFG], center=true );
            cylinder( r=radius, h=width+4*MFG, center=true );
        }
    // Bevel
    mirrorZ()
    translate ( [-radius, -radius, 0] )
    rotate_extrude( angle=90 )
        translate ( [radius, width/2, 0] )
        rotate( [0,0,180] )
        bevelDiagonalSection ( b );
}
//
// ----------------------------------------
//            Implementation
// ----------------------------------------

// Section of a diagonal (linear 45 deg) bevel
module bevelDiagonalSection ( radius ) {
    polygon([
        [-MFG,       -MFG],
        [radius,     -MFG],
        [-MFG,       radius],
    ]);
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
translate ( [5, 0, 0] )
rotate( [90,0,0] )
rotate( [0,0,90] )
bevelCutLinear( 20, 2 );

translate ( [5, 5, 0] )
bevelCutArc( 5, 2, $fn=100 );
