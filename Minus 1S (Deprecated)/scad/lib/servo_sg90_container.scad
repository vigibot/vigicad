/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for servo container
 * Design:      Quillès Jonathan / Pascal Piazzalungua
 * Author:      Quillès Jonathan / Gilles Bouissac
 */


use <servo_sg90.scad>
use <extensions.scad>

// ----------------------------------------
//                  API
// ----------------------------------------
module servoContainer( symetry=false, counterAxis=false, backWire=false ) {
    difference() {
        servoContainerShape();
        servoContainerTransform() {
            mirrorX( symetry ) {
                servo(backWireHole=backWire);
                if ( counterAxis ) {
                    servoCounterAxisHole();
                }
            }
            servoScrewHoles();
        }
    }
}

function servoContainerX() = BOX_X;
function servoContainerY() = BOX_Y;
function servoContainerZ() = servoBoxSizeZ();

// ----------------------------------------
//             Implementation
// ----------------------------------------
BOX_X   = 30;
BOX_Y   = 33;

// Move an object to servo position inside container
module servoContainerTransform() {
    posx = (servoBoxSizeX() + servoContainerX() ) /2;
    posy = servoContainerY()/2;
    posz = servoBoxSizeZ()/2;
    translate( [posx,posy,posz] )
        children();
}

module servoContainerShape() {
    cube([
        servoContainerX(),
        servoContainerY(),
        servoContainerZ()
    ]);
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
if ( 0 ) {
    for ( symetry=[0:1] )
    for ( counterAxis=[0:1] )
    for ( backWire=[0:1] )
        translate( [
            -20+40*symetry,
            -20+40*counterAxis,
            -20+40*backWire] )
            servoContainer(
                symetry=symetry,
                counterAxis=counterAxis,
                backWire=backWire);
}
