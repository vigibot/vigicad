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


MFG = 0.01; // 2 Manifold Guard
RADIUSBEVEL = 0.5; // Default radius bevel

BEVELTYPENONE = 0;
BEVELTYPESPHERE = 1;
BEVELTYPEDIAGONAL = 2;
BEVELTYPE = BEVELTYPEDIAGONAL;

// ----------------------------------------
//                  API
// ----------------------------------------

// Double diagonal bevels distant from width extruded in line
module bevelCutLinear( length, width, b=RADIUSBEVEL ) {
    translate ( [-width/2, 0, -MFG] )
    linear_extrude( height=length+2*MFG )
        bevelDiagonalSection ( b );
    mirror ( [1,0,0] )
    translate ( [-width/2, 0, -MFG] )
    linear_extrude( height=length+2*MFG )
        bevelDiagonalSection ( b );
}

// Double diagonal bevels distant from width extruded in quater of circle
module bevelCutArc( radius, width, b=RADIUSBEVEL ) {
    translate ( [-radius, -radius, 0] )
    rotate_extrude( angle=90 )
        translate ( [radius, width/2, 0] )
        rotate( [0,0,180] )
        bevelDiagonalSection ( b );
    mirror ( [0,0,1] )
    translate ( [-radius, -radius, 0] )
    rotate_extrude( angle=90 )
        translate ( [radius, width/2, 0] )
        rotate( [0,0,180] )
        bevelDiagonalSection ( b );
}

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
