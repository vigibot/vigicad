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
use <../lib/hardware_shop.scad>
use <../lib/plates.scad>
use <../lib/servo_sg90.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

// Main plate with given holes lists
module headPanServoBracket() {
    difference() {
        headPanPlate();
        headPanServoBracketExtrude();
    }
}

// ----------------------------------------
//            Implementation
// ----------------------------------------

module headPanServoBracketExtrude() {
    // Servo extruding
    translate( [
        getHeadPanPlateX()+getHeadPanPlateSX()-servoBoxSizeZ()/2,
        servoAxisPosY(),
        -servoStandPosX()-servoStandSizeX()/2-getHeadPanPlateSZ()/2] )
        rotate( [0,90,0] ) {
            servo(60);
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

%
translate( [getHeadPanPlateX(),0,0] )
rotate( [0,0,-90] )
translate( [0,5.5,-1.5] )
rotate( [0,0,0] )
    import( "../../stl/head_pan_servo_braket.stl" );



