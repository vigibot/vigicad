/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for Vigibot servo finger
 * Design:      Quillès Jonathan / Pascal Piazzalungua
 * Author:      Gilles Bouissac
 */

use <../lib/clamp.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

module servoFingerB(ratio=1) {
    servoFinger(arm_l=ratio*getClampArmBaseLength(), elbow_r=ratio*getClampArmBaseRadius());
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
difference() {
    servoFingerB( $fn=100 );
    if (0) {
        translate( [+getClampPitchDiameter(),0,0] )
        import( "../../stl/servo_finger_b.stl" );
    }
}

if (0) {
    %translate( [+getClampPitchDiameter(),0,0] )
    import( "../../stl/servo_finger_b.stl" );
}
