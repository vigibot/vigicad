/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for hardware shop things like screws
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

M2_DS  = 1.8;  // Thread diameter
M2_DPT = 2.2;  // Passing diameter tight
M2_DPL = 2.5;  // Passing diameter loose
M2_DH  = 4.0;  // Head diameter

M25_DS  = 2.1;  // Thread diameter
M25_DPL = 3.0;  // Passing diameter loose
M25_DH  = 4.5;  // Head diameter

// ----------------------------------------
//                  API
// ----------------------------------------

// screws with tight passage
module screwM2Tight ( lt=10, lp=5, lh=2 ) {
    screwMx( M2_DS, M2_DPT, M2_DH, lt, lp, lh );
}

// screws with loose passage
module screwM2 ( lt=10, lp=5, lh=2 ) {
    screwMx( M2_DS, M2_DPL, M2_DH, lt, lp, lh );
}
module screwM25 ( lt=10, lp=5, lh=2 ) {
    screwMx( M25_DS, M25_DPL, M25_DH, lt, lp, lh );
}

module screwShape(diameter, distx, disty) {
    translate([distx, disty, 0]) {
        cylinder(r = diameter / 2, h=100, center = true);
    }
}

// Render an array of vertical screws without mirroring
//   Each screw is rendered once
// Params:
//   holes = [
//     [ <diam>, <pos_x>, <pos_y> ],
//     ...
//     [ <diam>, <pos_x>, <pos_y> ]
//   ]
module screwArray( screws ) {
    for(screwParams = screws)
        screwShape(screwParams[0], screwParams[1], screwParams[2]);
}

// ----------------------------------------
//            Implementation
// ----------------------------------------

// drill any Mx screw:
//   dt: Thread diameter
//   dp: Passing diameter
//   dh: Thread diameter
//   lt: Thread length (from z=0 to z+)
//   lp: Passing length (from z=0 to z-)
//   lh: Head length (from z=-lp to z-)
module screwMx ( ds, dp, dh, lt=10, lp=5, lh=2 ) {
    translate( [0,0,lt/2] )
        cylinder (r = ds/2, h = lt, center = true);
    translate( [0,0,-lp/2] )
        cylinder (r = dp/2, h = lp, center = true);
    translate( [0,0,-lp-lh/2] )
        cylinder (r = dh/2, h = lh, center = true);
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------

color( "cyan" )
translate( [ -3, -3, 0 ] )
screwM2Tight( $fn=100 );

color( "cyan" )
translate( [  3, -3, 0 ] )
screwM2( $fn=100 );

color( "orange" )
translate( [  -3, 3, 0 ] )
screwM25( $fn=100 );
