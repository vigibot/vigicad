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


// 3D printer mode
$bevel=true;
// Laser cut mode
// $bevel=false;


use <../printable/plate_bottom.scad>
use <../printable/plate_middle.scad>
use <../printable/plate_top_fan.scad>
use <../printable/head_u_bracket.scad>
use <../printable/head_pan_servo_bracket.scad>
use <../printable/head_servo_camera_bracket.scad>
use <../printable/clamp_u_bracket.scad>
use <../printable/clamp_servo_bracket.scad>
use <../printable/clamp_finger_a.scad>
use <../printable/clamp_finger_b.scad>
use <../printable/usb_bracket.scad>

use <../lib/u_bracket.scad>
use <../lib/servo_sg90.scad>
use <../lib/plates.scad>

$fn=100;

PLATE_MID_Z   = -50;
PLATE_BOT_Z   = -65;
HEAD_OFFSET_Z = 15;

translate( [0,0,0] ) {
    plateTopFan();
    translate( [0,0,getMainPlateSZ()] )
        headPanServoBracket();
}

translate( [0,0,PLATE_MID_Z] ) {
    plateMiddle();
}

translate( [0,0,PLATE_BOT_Z] )
    plateBottom();

rotate( [0,0,180] )
toolPlateTargetLocation() {
    usbBracket();
}

headPanTargetLocation()
translate( [servoBoxSizeZ()/2,0,servoSizeX()-servoStandTopPosX()-getHeadPanBaseSZ()/2] )
{
    uBracketHead();
    color("#58F", 0.8)
    uBracketServo(bodyRotation=0);
    color("#7aF", 0.8)
    uBracketHeadServo(180);
}

translate( [47.75,-28/2,HEAD_OFFSET_Z+6.5] ) {
    rotate( [0,0,90] )
    rotate( [90,0,0] )
    smilingHead();
}

translate( [47.5,0,PLATE_MID_Z+1.5] ) {
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
translate( [83.75,0,PLATE_MID_Z-3] )
rotate( [0,0,-90] ) {
    clampFingerA();
    clampFingerB();
}
