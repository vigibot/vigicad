/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for vigibot U bracket for robot head
 * Author:      Gilles Bouissac
 */

use <lib/servoSg90.scad>
use <lib/uBracket.scad>

module uBracketHeadServo() {
    translate( [
        0,
        servoAxisPosY(),
        -servoSizeX()
    ])
    rotate( [0,90,0] ) {
        servo(0,2);
        servoCounterAxisHole(3,3,2);
    }
}

module uBracketHead() {
    difference() {
        uBracket();
        uBracketHeadServo();
    }
}

// ------------------------------
//
//   Debug section
//
// ------------------------------

 uBracketHead();
%uBracketServo();
%uBracketHeadServo();


