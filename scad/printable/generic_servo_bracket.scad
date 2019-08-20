/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for the smiling pan & tilt smiling head part of the Vigibot robot "Minus"
 * Design:      Quillès Jonathan / Pascal Piazzalungua
 * Author:      Quillès Jonathan
 */
 
use <../lib/servo_sg90_container.scad>
use <../lib/extensions.scad>

PRECISION = 100;

$fn = PRECISION;

BOX_X = 30; 
BOX_Y = 33;
CHAMFERSIZE = 2.2;
SERVOSYMETRY = 1;
SERVOCOUNTERAXIS = 1;
SERVOBACKWIRE = 1;

box ();

module chamfer() {
    rotate( [90,0,90] )
    linear_extrude ( height=BOX_X)
        polygon ( [
            [0,CHAMFERSIZE], [0, 0], [CHAMFERSIZE,0]
        ]);
}

module cover() {
    translate ( [ 0, 0, -CHAMFERSIZE])
        difference() {
            cube([BOX_X, BOX_Y, CHAMFERSIZE]);
            chamfer();
            translate ([BOX_X, BOX_Y, 0])
                rotate([0, 0, 180])
                    chamfer();
    }
}

module box () {
    servoContainer(
        symetry = SERVOSYMETRY,
        counterAxis = SERVOCOUNTERAXIS,
        backWire = SERVOBACKWIRE);
    cover();
}
