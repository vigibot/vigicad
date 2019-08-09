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

SYMETRIC = 0; // bool
OFFSET = 0;   //distance in mm
RADIUSBEVEL = getRadiusBevel();

module headPanServoBracket() {
    if(SYMETRIC) {
        difference() {
            union() {
                headPanPlate(1.5); // To do replace with headPanPlate() when lib will be corrected
                translate( [
                    getHeadPanPlateX()+ OFFSET/2 -RADIUSBEVEL + getHeadPanPlateSX() - servoBoxSizeZ()/2,
                    0,
                    0] )
                    cube([servoBoxSizeZ() + RADIUSBEVEL + OFFSET , servoSizeY() + 2*servoAxisPosY(), getMainPlateSZ()], center = true);
            }
            headPanServoBracketExtrude();
        }
        
    }
    else {
        difference() {
            union() {
                headPanPlate(1.5); // To  do replace with headPanPlate() when lib will be corrected
                translate( [
                    getHeadPanPlateX()+ OFFSET/2 -RADIUSBEVEL + getHeadPanPlateSX() - servoBoxSizeZ()/2,
                    -servoAxisPosY(),
                    0] )
                    cube([servoBoxSizeZ() + RADIUSBEVEL + OFFSET , servoSizeY(), getMainPlateSZ()], center = true);
            }
            headPanServoBracketExtrude();
        }
    }
}

// ----------------------------------------
//            Implementation
// ----------------------------------------

module headPanServoBracketExtrude() {
    // Servo extruding
    translate( [
        getHeadPanPlateX()+getHeadPanPlateSX()-servoBoxSizeZ()/2 + OFFSET,
        -servoAxisPosY(),
        -servoStandPosX()-servoStandSizeX()/2-getHeadPanPlateSZ()/2] )
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
