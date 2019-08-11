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
 * Author:      Gilles Bouissac / Quillès Jonathan
 */

use <../lib/extensions.scad>
use <../lib/hardware_shop.scad>
use <../lib/plates.scad>
use <../lib/servo_sg90.scad>
use <../lib/bevel.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

// Head pan plate with given holes lists
SYMETRIC     = false;
OFFSET       = 0;   //distance of servo in mm
RADIUSBEVEL  = getRadiusBevel();
RADIUSCORNER = 0;

module headPanServoBracket() {
    difference() {
        headPanServoBracketShape();
        headPanServoBracketExtrude();
    }
}

// ----------------------------------------
//            Implementation
// ----------------------------------------

module headPanServoBracketShape() {
    headPanPlate();
    translate( [getHeadPanPlateX(),0,0] )
        mirrorX(SYMETRIC)
            translate( [-RADIUSBEVEL, -servoAxisPosY(), 0] )
                mirrorX()
                    plateShape(
                        servoBoxSizeZ()+RADIUSBEVEL/2+OFFSET,
                        servoSizeY()/2,
                        getMainPlateSZ(),
                        RADIUSCORNER);
}

module headPanServoBracketExtrude() {
    // Servo extruding conveyed by headPanPlate
    translate( [
        getHeadPanPlateX()+servoBoxSizeZ()/2+OFFSET,
        -servoAxisPosY(),
        -servoStandTopPosX()-getHeadPanBaseSZ()/2
    ])
        rotate( [0,90,180] ) {
            servo(180);
            servoScrewHoles();
        }
}

module headPanServoBracketShow() {
%    headPanPlateExtrude();
%    headPanServoBracketExtrude();
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
headPanServoBracket($fn=100);
headPanServoBracketShow($fn=100);

//%import( "../../stl/head_pan_servo_bracket.stl" );

