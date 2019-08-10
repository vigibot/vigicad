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

THIS_TOOL_PLATE_SY = 44 ;

// Larger tool plate
module headToolServoBracket() {
    difference() {
        toolPlate( servoBoxSizeZ(), THIS_TOOL_PLATE_SY );
        headToolServoBracketExtrude();
    }
}

// ----------------------------------------
//            Implementation
// ----------------------------------------

module headToolServoBracketExtrude() {
    // Servo extruding
    translate( [
        getToolBaseX()+servoBoxSizeZ()/2,
        -servoAxisPosY(),
        -servoStandPosX()-servoStandSizeX()/2-getHeadPanBaseSZ()/2] )
        rotate( [0,0,180] )
        rotate( [0,90,0] ) {
            servo(-60);
            servoScrewHoles();
        }
}

module headToolServoBracketShow() {
%    toolBaseExtrude();
%    headToolServoBracketExtrude();
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
headToolServoBracket($fn=100);
headToolServoBracketShow($fn=100);
