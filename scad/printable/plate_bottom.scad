/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for Vigibot bottom plate
 * Design:      Quillès Jonathan / Pascal Piazzalungua
 * Author:      Gilles Bouissac
 */

use <../lib/hardware_shop.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

PLATE_SX = 66 ;
PLATE_SY = 58 ;
PLATE_SZ = 1.20 ;

MOTOR_X = 12.0;
MOTOR_Y = 17.5;

HOLE_X = 18.5;
HOLE_Y = 24.5;

module plateBottom() {
    difference() {
        plateBottomShape();
        translate( [+HOLE_X,+HOLE_Y,5] ) screwM25(0,10);
        translate( [+HOLE_X,-HOLE_Y,5] ) screwM25(0,10);
        translate( [-HOLE_X,+HOLE_Y,5] ) screwM25(0,10);
        translate( [-HOLE_X,-HOLE_Y,5] ) screwM25(0,10);
    }
}

// ----------------------------------------
//            Implementation
// ----------------------------------------

module plateBottomShape() {
    cube ( [PLATE_SX-2*MOTOR_X, PLATE_SY, PLATE_SZ], center=true);
    cube ( [PLATE_SX, PLATE_SY-2*MOTOR_Y, PLATE_SZ], center=true);
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
plateBottom($fn=100);

%
rotate( [0,0,0] )
translate( [0,0,0] )
    import( "../../stl/plate_bottom.stl" );

