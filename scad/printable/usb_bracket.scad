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

module usbBracket() {
    toolPlate();
    difference() {
        usbBracketShape();
        usbBracketBevel();
        usbBracketExtrude();
    }
}

// ----------------------------------------
//            Implementation
// ----------------------------------------

PLATE_SX  = 27.5 ;
PLATE_SY  = getToolBaseSY() ;
PLATE_SZ  = getToolBaseSZ() ;

HOLLOW_SX = 11;
HOLLOW_SY = 19;
HOLLOW_X  = 11.5;
HOLLOW_Y  = -10.5;

module usbBracketShape() {
    mirrorX()
        difference() {
            plateShape(PLATE_SX, PLATE_SY/2, PLATE_SZ);
            plateBevel(PLATE_SX, PLATE_SY/2, PLATE_SZ);
        }
}

module usbBracketBevel() {
    translate( [ HOLLOW_X+HOLLOW_SX/2, HOLLOW_Y+HOLLOW_SY/2, 0] ) {
        mirrorXY() {
            translate( [ -HOLLOW_SX/2, -HOLLOW_SY/2, 0] )
                rotate( [0,0,90] )
                rotate( [0,90,0] )
                    bevelCutLinear( HOLLOW_SY/2, PLATE_SZ );
            translate( [ -HOLLOW_SX/2, +HOLLOW_SY/2, 0] )
                rotate( [0,90,0] )
                bevelCutLinear( HOLLOW_SX/2, PLATE_SZ );

            translate( [ +HOLLOW_SX/2, +HOLLOW_SY/2, 0] )
                bevelCutCornerConcave( 0, PLATE_SZ );
        }
    }
}

module usbBracketExtrude() {
    translate( [HOLLOW_X+HOLLOW_SX/2,HOLLOW_Y+HOLLOW_SY/2,0] )
        cube ( [HOLLOW_SX, HOLLOW_SY, 5*PLATE_SZ], center=true);
}

module usbBracketShow() {
%    toolPlateExtrude();
%    usbBracketExtrude();
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
MODE_3DPRINT = true;

toolPlateTargetLocation() {
    usbBracket     ( $fn=100, $bevel=MODE_3DPRINT );
    usbBracketShow ( $fn=100 );
}

/*
%toolPlateTargetLocation() {
    translate( [-0.5,0,0] )
    import( "../../stl/usb_bracket.stl" );
}
*/
