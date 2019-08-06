/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design to show all parts assembled together on standard bot
 * Author:      Gilles Bouissac
 */

use <../printable/plate_middle.scad>
use <../printable/plate_top_fan.scad>
use <../printable/head_u_bracket.scad>
use <../printable/head_servo_camera_bracket.scad>
use <../printable/clamp_u_bracket.scad>
use <../printable/clamp_servo_bracket.scad>
use <../printable/clamp_finger_a_b.scad>
use <../lib/u_bracket.scad>
use <../lib/servo_sg90.scad>

$fn=100;

PLATE_DIST    = 50;
HEAD_OFFSET_Z = 15;

translate( [0,0,0] )
    plateTopFan();

translate( [0,0,-PLATE_DIST] )
    plateMiddle();

translate( [54,0,HEAD_OFFSET_Z] ) {
    uBracketHead();
    color("#58F", 0.8)
    uBracketServo(bodyRotation=0);
    color("#7aF", 0.8)
    uBracketHeadServo();
}

translate( [47.75,-32/2,HEAD_OFFSET_Z+10.85] ) {
    rotate( [0,0,90] )
    rotate( [90,0,0] )
    smilingHead();
}

translate( [47.5,0,-PLATE_DIST+1.5] ) {
    uBracketClamp();
    color("#9cF", 0.8)
    uBracketClampServo(-45);
    color("Silver", 1)
    uBracketClampHoles();
}

translate( [90,-33/2,-13.75] ) {
    rotate( [0,0,90] )
    rotate( [-90,0,0] )
        clampHolder();
}

color("#46F", 0.8)
translate( [83.75,0,-18.75] ) {
    rotate( [0,0,180] )
    rotate( [0,-90,0] )
        servo(115);
}

color("white")
translate( [83.75,0,-PLATE_DIST-3] )
rotate( [0,0,-90] )
    clamp();
