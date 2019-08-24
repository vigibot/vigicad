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
use <../lib/bevel.scad>

BOTTOM_THICKNESS   = 1.2;
SERVO_SYMETRY      = 1;
SERVO_COUNTER_AXIS = 1;
SERVO_BACK_WIRE    = 1;

module cover() {
    translate ( [ 0, 0, -BOTTOM_THICKNESS])
        difference() {
            cube([
                servoContainerX(), 
                servoContainerY(), 
                BOTTOM_THICKNESS]);
            translate ([0, servoContainerY()/2, 0])
                rotate([90, 0, 90])
                    bevelCutLinear(
                        servoContainerX(), 
                        servoContainerY(), 
                        $bevel = BOTTOM_THICKNESS);

    }
}

module genericServoBracket () {
    servoContainer(
        symetry = SERVO_SYMETRY,
        counterAxis = SERVO_COUNTER_AXIS,
        backWire = SERVO_BACK_WIRE);
    cover();
}

genericServoBracket ($fn=100);

