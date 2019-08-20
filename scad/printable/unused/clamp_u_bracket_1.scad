/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for vigibot U bracket for robot head
 * Design:      Quillès Jonathan / Pascal Piazzalungua
 * Author:      Gilles Bouissac
 */

use <../lib/u_bracket.scad>
use <../lib/hardware_shop.scad>
use <../lib/plates.scad>
use <../lib/bevel.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

module uBracketClamp() {
    difference() {
        uBracketClampShapes();
        toolPlateExtrude();
        uBracketClampPrismBevel();
    }
}

// ----------------------------------------
//           Implementation
// ----------------------------------------

AXIS_POS_Z  = 29;
U_ANGLE     = 45;
U_BASE_Z    = 3;
U_BASE_X    = 12.5;
U_BASE_Y    =  14; // Small side, large side is automatic
U_BRACKET_B = 1.5;

UBOTTOM_W = getUBracketMainW()-2*getUBracketBevel();
PRISM_L   = getUBracketOutsideL()-2*getUBracketBevel();

// UBracket bottom point after rotation
BOT_POST_ROT_X=
    +UBOTTOM_W/2*cos(U_ANGLE) ;
BOT_POST_ROT_Z=
    -UBOTTOM_W/2*sin(U_ANGLE) ;

// UBracket top point after rotation
TOP_POST_ROT_X=
    -UBOTTOM_W/2*cos(U_ANGLE) ;
TOP_POST_ROT_Z=
    +UBOTTOM_W/2*sin(U_ANGLE) ;

// UBracket bottom point target location
BOT_TARGET_X = BOT_POST_ROT_X-TOP_POST_ROT_X;
BOT_TARGET_Z = 0;

// UBracket top point target location
TOP_TARGET_X = 0;
TOP_TARGET_Z = TOP_POST_ROT_Z-BOT_POST_ROT_Z;


module uBracketClampPrism() {
    translate( [ 0, PRISM_L/2, -1.5 ])
    rotate( [90,0,0] )
        linear_extrude( height=PRISM_L ) {
            polygon([
                [0,0],
                [BOT_TARGET_X,0],
                [0,TOP_TARGET_Z],
                [0,0]
            ]);
        }
}

module uBracketClampPrismBevel() {
    translate( [ 0, 0, -getToolBaseSZ()/2 ])
    rotate([0,0,90])
    rotate([90,0,0])
        bevelCutLinear(
            BOT_TARGET_X +2*U_BRACKET_B,
            PRISM_L      +2*U_BRACKET_B,
            $bevel=0.5   +  U_BRACKET_B );
}

module uBracketClampShapes() {
    translate( [ -TOP_POST_ROT_X, 0, -BOT_POST_ROT_Z-1.5 ])
    rotate([0,U_ANGLE,0])
        uBracket(AXIS_POS_Z);
    difference() {
        uBracketClampPrism();
    }
    toolPlate();
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
uBracketClamp($fn=100);

module uBracketClampServo(bodyRotation=0) {
    translate( [ -TOP_POST_ROT_X, 0, -BOT_POST_ROT_Z ])
    rotate([0,U_ANGLE,0])
    uBracketServo(AXIS_POS_Z,bodyRotation=bodyRotation+180);
}

if ( 0 ) {
    %toolPlateExtrude($fn=100);
    translate( [0,0,-1.5] ) {
        %uBracketClampServo($fn=100);
        %import( "../../stl/clamp_u_bracket.stl" );
    }
}
