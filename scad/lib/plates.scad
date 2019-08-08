/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for Vigibot plates
 * Design:      Quillès Jonathan / Pascal Piazzalungua
 * Author:      Gilles Bouissac
 */

use <extensions.scad>
use <bevel.scad>
use <hardware_shop.scad>

HOLEMARGIN  = 0.5;
M2DIAMETER  = 2 + HOLEMARGIN;
M25DIAMETER = 2.5 + HOLEMARGIN;
M3DIAMETER  = 3 + HOLEMARGIN;

MAINPLATE_SX  = 95;
MAINPLATE_SY  = 60;
MAINPLATE_SZ  = 3;

HP_PLATE_SX  = 26 ;
HP_PLATE_SY  = 60 ;
HP_PLATE_SZ  = 3 ;
HP_PLATE_DX  = 12.5; // offset of this plate from main plate
HP_PLATE_X   = getMainPlateSX()/2 - HP_PLATE_SX + HP_PLATE_DX;

RADIUSCORNERS = 5;

// ----------------------------------------
//                  API
// ----------------------------------------

function getMainPlateSX()   = MAINPLATE_SX;
function getMainPlateSY()   = MAINPLATE_SY;
function getMainPlateSZ()   = MAINPLATE_SZ;

function getHeadPanPlateSX()   = HP_PLATE_SX;
function getHeadPanPlateSY()   = HP_PLATE_SY;
function getHeadPanPlateSZ()   = HP_PLATE_SZ;
function getHeadPanPlateX()    = HP_PLATE_X;

function getRadiusCorners() = RADIUSCORNERS;


// Main plate with given holes lists
// - mirrorXYHoles:   Drill given holes 4 times (double mirroring)
// - noMirrorHoles:   Drill given holes once
module plate ( mirrorXYHoles=[], noMirrorHoles=[] ) {
    difference () {
        // Row shape
        mirrorXY()
            plateShape( MAINPLATE_SX/2, MAINPLATE_SY/2, MAINPLATE_SZ, RADIUSCORNERS );

        // Bevels
        mirrorXY()
            plateBevel( MAINPLATE_SX/2, MAINPLATE_SY/2, MAINPLATE_SZ, RADIUSCORNERS );

        // Holes with no mirroring
        screwArray ( flatten(noMirrorHoles) );

        // Holes with double mirroring
        mirrorXY()
            screwArray( flatten(mirrorXYHoles) );
    }
}

module headPanPlate ( mirrorXHoles=[], noMirrorHoles=[] ) {
    difference() {
        headPanPlateShape();
        headPanPlateBevel();
        headPanPlateExtrude();

        // Holes with no mirroring
        screwArray ( flatten(noMirrorHoles) );

        // Holes with X mirroring
        mirrorX()
            screwArray( flatten(mirrorXHoles) );
    }
}


// Get Vigibot motors holes
function getMotorsFourHoles() = [
    [M2DIAMETER, 38, 16.5],    // Motors A
    [M2DIAMETER, 20, 16.5],    // Motors B
];

// Get Vigibot raspberry PI holes
function getRaspberryFourHoles() = [
    [M25DIAMETER, 39.5, 24.5], // PI A
    [M25DIAMETER, 18.5, 24.5], // PI B
];

// Get Vigibot motor PCB holes
function getMotorPcbFourHoles() = [
    [M25DIAMETER, 0, 10],      // Motors PCB
];

// Get Vigibot oblong holes
function getOblongFourHoles() = [
    [5, 0.5, 24.5],            // Oblong A
    [5, 1.5, 24.5],            // Oblong B
    [5, 2.5, 24.5],            // Oblong C
];

// Get Vigibot tool holes
function getToolFourHoles() = [
    [M2DIAMETER, 38, 0],       // Tools A
    [M2DIAMETER, 44.5, 12]     // Tools B
];

// Get Vigibot FAN fixing holes
function getFanFourHoles() = [
    [M25DIAMETER, 12, 12]
];

// Get Vigibot FAN main holes
function getFanSimpleHoles() = [
    [5, 18, -8],
    [28.5, 0, 0]
];

// ----------------------------------------
//            Implementation
// ----------------------------------------

// Quater plate shape
module plateShape( platex, platey, platez, radius ) {
    sx = platex - radius;
    sy = platey - radius;
    sz = platez;
    translate( [ sx/2, sy/2, 0 ] ) {
        cube([sx, sy, sz], center = true );
    }
    translate( [ sx+radius/2, sy/2, 0 ] ) {
        cube([radius, sy, sz], center = true );
    }
    translate( [ sx/2, sy+radius/2, 0 ] ) {
        cube([sx, radius, sz], center = true );
    }
    translate( [ sx, sy, 0 ] ) {
        cylinder( r=radius, h=sz, center = true );
    }
}

// Quater plate bevels on external borders
module plateBevel ( platex, platey, platez, radius ) {
    sx = platex - radius;
    sy = platey - radius;
    sz = platez;

    translate ( [0, platey, 0 ] ) {
        rotate( [0,90,0] )
        rotate( [0,0,180] )
            bevelCutLinear( sx, sz );
    }
    translate ( [platex, 0, 0 ] ) {
        rotate( [-90,0,0] )
        rotate( [0,0,90] )
            bevelCutLinear( sy, sz );
    }
    translate ( [platex, platey, 0 ] ) {
        bevelCutArc( radius, sz );
    }
}

// Quater plate bevels on internal border along X
module plateBevelInternalX ( platex, platez ) {
    rotate( [0,90,0] )
        bevelCutLinear( platex, platez );
}

// Quater plate bevels on internal border along X
module plateBevelInternalY ( platey, platez ) {
    rotate( [-90,0,0] )
    rotate( [0,0,-90] )
        bevelCutLinear( platey, platez );
}


module headPanPlateShape() {
    translate( [HP_PLATE_X,0,0] )
    mirrorX()
        plateShape( HP_PLATE_SX, HP_PLATE_SY/2, HP_PLATE_SZ, getRadiusCorners() );
}
module headPanPlateBevel() {
    // Bevel extruding
    translate( [HP_PLATE_X,0,0] )
    mirrorX() {
        plateBevel( HP_PLATE_SX, HP_PLATE_SY/2, HP_PLATE_SZ, getRadiusCorners() );
        plateBevelInternalY( HP_PLATE_SY/2, HP_PLATE_SZ );
    }
}
module headPanPlateExtrude() {
    // Fixation extuding from PI fixation
    mirrorX()
        screwArray ( getRaspberryFourHoles() );
}


// ----------------------------------------
//                 Showcase
// ----------------------------------------
plate(
    mirrorXYHoles = [
        getMotorsFourHoles(),
        getRaspberryFourHoles(),
        getMotorPcbFourHoles(),
        getOblongFourHoles(),
        getToolFourHoles(),
    ],
    $fn = 50
);

%
translate( [0,0,0] )
rotate( [0,0,0] )
    import( "../../stl/plate_middle.stl" );

