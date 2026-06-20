/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for Vigibot photoresistor cap
 * Design:      Quillès Jonathan / Pascal Piazzalungua
 * Author:      Gilles Bouissac
 */

use <../lib/extensions.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

module photoResistorCap() {
    difference() {
        photoResistorCapShape();
        photoResistorCapHoles();
    }
}

// ----------------------------------------
//            Implementation
// ----------------------------------------

BEVEL  = 0.5 ;

CAP_SZ = 6.6 ;
CAP_D  = 8.2 ;

CAP_HOLE_D  = 6.6 ;
CAP_HOLE_SZ = 6.0;

module photoResistorCapShape() {
    rotate_extrude() {
        polygon([
            [0,0],
            [CAP_D/2-BEVEL,0],
            [CAP_D/2,BEVEL],
            [CAP_D/2,CAP_SZ],
            [0,CAP_SZ],
            [0,0]
        ]);
    }
}

module photoResistorCapHoles() {
    translate( [0,0,CAP_SZ-CAP_HOLE_SZ] )
        cylinder( r=CAP_HOLE_D/2, h=CAP_HOLE_SZ+1 );
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
photoResistorCap ($fn=100);

//%import( "../../stl/photoresistor_cap.stl" );
