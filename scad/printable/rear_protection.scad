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
use <../lib/bevel.scad>
use <../lib/hardware_shop.scad>
use <../lib/plates.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

module rearProtection() {
    toolPlate();
    difference() {
        rearProtectionShape();
    }
}

// ----------------------------------------
//            Implementation
// ----------------------------------------

PLATE_SX  = 15;
PLATE_SY  = getToolBaseSY() ;
PLATE_SZ  = getToolBaseSZ() ;

module rearProtectionShape() {
    mirrorX()
        difference() {
            plateShape(PLATE_SX, PLATE_SY/2, PLATE_SZ);
            plateBevel(PLATE_SX, PLATE_SY/2, PLATE_SZ, PLATE_SX);
        }
}

module rearProtectionShow() {
%    toolPlateExtrude();
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
MODE_3DPRINT = true;

toolPlateTargetLocation() {
    rearProtection     ( $fn=100, $bevel=MODE_3DPRINT );
    rearProtectionShow ( $fn=100 );
}

/*
%toolPlateTargetLocation() {
    translate( [-0.5,0,0] )
    import( "../../stl/rear_protection.stl" );
}
*/
