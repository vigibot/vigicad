/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for Vigibot usb bracket
 * Design:      Quillès Jonathan / Pascal Piazzalungua
 * Author:      Gilles Bouissac
 */

use <../lib/extensions.scad>
use <../lib/bevel.scad>
use <../lib/plates.scad>
use <../lib/servo_sg90.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

OFFSET       = 0;
HEAD_TOOL_SX = servoBoxSizeZ()+OFFSET ;
HEAD_TOOL_SY = 44 ;
HEAD_TOOL_SZ = getToolBaseSZ() ;

// Larger tool plate
module headToolServoBracket() {
    toolPlate( HEAD_TOOL_SY );
    difference() {
        union() {
            mirrorX()
                plateShape(HEAD_TOOL_SX,HEAD_TOOL_SY/2,HEAD_TOOL_SZ);
        }
        headToolServoBracketBevel();
        headToolServoBracketExtrude();
    }
}

// ----------------------------------------
//            Implementation
// ----------------------------------------

module headToolServoBracketBevel() {
    mirrorX()
    translate( [ 0, -HEAD_TOOL_SY/2, 0] ) {
        rotate( [0,90,0] )
            bevelCutLinear( HEAD_TOOL_SX, HEAD_TOOL_SZ );

        translate( [ HEAD_TOOL_SX, 0, 0] )
        rotate( [-90,0,0] )
        rotate( [0,0,90] )
            bevelCutLinear( HEAD_TOOL_SY/2, HEAD_TOOL_SZ );

        translate( [ HEAD_TOOL_SX, 0, 0] )
        rotate( [0,0,-90] )
            bevelCutArc( getRadiusBevel(), HEAD_TOOL_SZ );
    }
}

module headToolServoBracketExtrude() {
    // Servo extruding
    translate( [
        HEAD_TOOL_SX-servoBoxSizeZ()/2,
        -servoAxisPosY(),
        -servoStandPosX()-servoStandSizeX()/2-getHeadPanBaseSZ()/2] )
        rotate( [0,0,180] )
        rotate( [0,90,0] ) {
            servo(-60);
            servoScrewHoles();
        }
}

module headToolServoBracketShow() {
%    toolPlateExtrude();
%    headToolServoBracketExtrude();
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
MODE_3DPRINT = true;

toolPlateTargetLocation() {
    headToolServoBracket( $fn=100, $bevel=MODE_3DPRINT );
    headToolServoBracketShow( $fn=100 );
}
