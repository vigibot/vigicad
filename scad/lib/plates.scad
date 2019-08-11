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

HP_BASE_SX   = 13.5 ;
HP_BASE_SY   = MAINPLATE_SY ;
HP_BASE_SZ   = MAINPLATE_SZ ;
HP_BASE_X    = getMainPlateSX()/2 - HP_BASE_SX ;
HP_PLATE_X   = getMainPlateSX()/2;

TOOL_BASE_SY    = 38 ;
TOOL_BASE_SX    = 12.5 ;
TOOL_BASE_SZ    = MAINPLATE_SZ ;
TOOL_PLATE_X    = getMainPlateSX()/2;
TOOL_STRAIT_DX  = 0.5+0.5*sin(22.5) ; // The strait part length
TOOL_DIAG_DX    = TOOL_BASE_SX-TOOL_STRAIT_DX ;

RADIUSCORNERS = 5;

// ----------------------------------------
//                  API
// ----------------------------------------

function getMainPlateSX()   = MAINPLATE_SX;
function getMainPlateSY()   = MAINPLATE_SY;
function getMainPlateSZ()   = MAINPLATE_SZ;

function getHeadPanBaseSX()    = HP_BASE_SX;
function getHeadPanBaseSY()    = HP_BASE_SY;
function getHeadPanBaseSZ()    = HP_BASE_SZ;
function getHeadPanBaseX()     = HP_BASE_X;
function getHeadPanPlateX()    = HP_PLATE_X;

function getToolBaseSX()   = TOOL_BASE_SX;
function getToolBaseSY()   = TOOL_BASE_SY;
function getToolBaseSZ()   = TOOL_BASE_SZ;
function getToolBaseX()    = TOOL_PLATE_X;

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

module toolPlate ( plate_sy=TOOL_BASE_SY ) {
    difference() {
        toolPlateShape( plate_sy );
        toolPlateBevel( plate_sy );
        toolPlateExtrude();
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
    [5, 18, 8],
    [28.5, 0, 0]
];

// ----------------------------------------
//      Implementation: base elements
// ----------------------------------------

// Quater plate shape
module plateShape( platex, platey, platez, radius=getRadiusCorners() ) {
    translate( [ platex/2, platey/2, 0 ] ) {
        cube([platex, platey, platez], center = true );
    }
}
// Quater plate bevels on external borders
module plateBevel ( platex, platey, platez, radius=getRadiusCorners() ) {
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

// ----------------------------------------
//             HEAD PAN PLATE
// ----------------------------------------

module headPanTargetLocation() {
    translate( [getHeadPanBaseX()+getHeadPanBaseSX(),0,getHeadPanBaseSZ()] )
        children();
}
module headPanPlateShape( radius=getRadiusCorners() ) {
    translate( [getHeadPanBaseX(),0,0] )
    mirrorX()
        plateShape( getHeadPanBaseSX(), getHeadPanBaseSY()/2, getHeadPanBaseSZ(), radius );
}
module headPanPlateBevel( radius=getRadiusCorners() ) {
    // Bevel extruding
    translate( [getHeadPanBaseX(),0,0] )
    mirrorX() {
        plateBevel( getHeadPanBaseSX(), getHeadPanBaseSY()/2, getHeadPanBaseSZ(), radius );
        plateBevelInternalY( getHeadPanBaseSY()/2, getHeadPanBaseSZ() );
    }
}
module headPanPlateExtrude() {
    // Fixation extruding from PI fixation
    mirrorX()
        screwArray ( getRaspberryFourHoles() );
}

// ----------------------------------------
//              TOOL PLATE
// ----------------------------------------

module toolPlateTargetLocation() {
    translate( [getToolBaseX(),0,getToolBaseSZ()] )
        children();
}
module toolPlateShape ( plate_sy=TOOL_BASE_SY, radius=getRadiusCorners() ) {
    translate( [-TOOL_STRAIT_DX,0,-TOOL_BASE_SZ/2] )
    linear_extrude( height=TOOL_BASE_SZ ) {
        polygon([
            [0,plate_sy/2],
            [-TOOL_DIAG_DX,+(plate_sy-2*TOOL_DIAG_DX)/2],
            [-TOOL_DIAG_DX,-(plate_sy-2*TOOL_DIAG_DX)/2],
            [0,-plate_sy/2]
        ]);
    }
    translate( [-TOOL_STRAIT_DX/2,0,] )
        cube([TOOL_STRAIT_DX, plate_sy, TOOL_BASE_SZ], center = true );
}
module toolPlateBevel(plate_sy=TOOL_BASE_SY, radius=getRadiusCorners()) {
    // Bevel extruding
    mirrorX() {
        translate( [-TOOL_BASE_SX,0,0] ) {
            plateBevelInternalY( plate_sy/2-TOOL_DIAG_DX, TOOL_BASE_SZ );
            translate( [0,+plate_sy/2-TOOL_DIAG_DX,0] ) {
                rotate( [0,0,-135] )
                rotate( [0,-90,0] )
                    bevelCutLinear( TOOL_DIAG_DX/cos(45), TOOL_BASE_SZ );
                rotate( [0,180,0] )
                    bevelCutArc( getRadiusBevel(), TOOL_BASE_SZ, 45 );
            }
        }
        translate( [-TOOL_STRAIT_DX,+plate_sy/2,0] )
            rotate( [0,0,90] )
                bevelCutArc( getRadiusBevel(), TOOL_BASE_SZ, 45 );
        translate( [0,+plate_sy/2,0] )
            rotate( [0,0,180] )
            rotate( [0,90,0] )
                bevelCutLinear( TOOL_STRAIT_DX, TOOL_BASE_SZ );
    }
}
module toolPlateExtrude() {
    // Fixation extruding from Tools fixation
    translate( [-TOOL_PLATE_X,0,0] )
    mirrorX() {
        screwArray ( getToolFourHoles() );
    }
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------

module platesShow() {

    plate(
        mirrorXYHoles = [
            getMotorsFourHoles(),
            getRaspberryFourHoles(),
            getMotorPcbFourHoles(),
            getOblongFourHoles(),
            getToolFourHoles(),
        ]
    );

    toolPlateTargetLocation() {
        toolPlate ();
        mirrorX()
            plateShape(10,TOOL_BASE_SY/2,2,2);
    }

    translate( [0,0,getToolBaseSZ()] )
    rotate( [0,0,180] ){
        headPanPlate();
        translate( [getHeadPanPlateX(),0,0] )
            mirrorX()
            plateShape(20,20,2,2);
    }
}

// 3D printer mode
platesShow( $fn=50, $bevel=true );

// Laser cut mode
translate( [0,0,-30] )
color( "silver" )
platesShow( $fn=50, $bevel=false );


//%import( "../../stl/plate_middle.stl" );

