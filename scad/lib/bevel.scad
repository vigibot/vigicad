/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD API for beveling
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <extensions.scad>

RADIUSBEVEL        = 0.5; // Default radius bevel
CUTTER_W           = 1;

function getRadiusBevel() = RADIUSBEVEL;

// ----------------------------------------
//                  API
// ----------------------------------------

// Line beveling of a plate
module bevelCutLinear ( length, width, b=RADIUSBEVEL ) {
    // Cutter
    translate ( [-width/2, -CUTTER_W, 0] )
        cube( [width,CUTTER_W,length] );
    // Bevel
    if ( bevelActive() ) {
        mirrorY()
        translate ( [-width/2, 0, 0] )
        linear_extrude( height=length )
            bevelDiagonalSection ( b );
    }
}

// Concave corner angle of a plate
//    Actually we can achive this goal with 2 bevelCutLinear rotated by 90°
//    module bevelCutCorner ( radius, width, angle=90, b=RADIUSBEVEL ) {
//    }

// Concave corner angle of a plate
module bevelCutCornerConcave ( radius, width, angle=90, b=RADIUSBEVEL ) {

    diagonal = (radius + b)/cos( angle/2 );
    longSide = (radius + b)*tan( angle/2 );
    cutterDiag = radius/cos( angle/2 );
    cutterSide = radius*tan( angle/2 );

    // Cutter
    rotate( [0,0,angle/2] )
        mirrorZ()
        mirrorX()
        translate ( [+cutterDiag, 0, 0] )
        rotate( [0,0,90-angle/2] )
        translate ( [-cutterSide, 0, 0] )
        linear_extrude( height=width/2 )
            polygon([
                [0,        0],
                [cutterSide, 0],
                [0,        radius],
            ]);
    // Bevel
    if ( bevelActive() ) {
        rotate( [0,0,angle/2] )
        mirrorZ()
            mirrorX()
            translate ( [diagonal, 0, 0] )
            difference() {
                rotate( [0,0,90-angle/2] )
                translate ( [-longSide, 0, 0] )
                linear_extrude( height=width/2 )
                    polygon([
                        [0,        0],
                        [longSide, 0],
                        [0,        radius + b],
                    ]);
                translate ( [0, 0, width/2-b] )
                rotate( [0,0,90-angle/2] )
                rotate( [0,-90,0] )
                linear_extrude( height=longSide )
                    bevelDiagonalSection ( b );
                rotate( [0,0,180-angle/2] )
                    cube( [b,longSide,width/2-b] );
        }
    }
}

// Convex circular beveling of a plate
module bevelCutArc ( radius, width, angle=90, b=RADIUSBEVEL ) {
    // tan(+-90) = infinite
    distance = mod(angle,180)==0 ? 0 : radius-radius*tan(angle/2);
    // 1/cos(90) = infinite
    cutter = mod(angle,180)==0 ? radius+b : radius/cos(angle/2);

    translate ( [0, distance, 0] )
    mirrorZ()
    translate ( [-radius, -radius, 0] ) {
        // Cutter
        rotate( [0,0,-mfg()] )
        rotate_extrude( angle=angle+2*mfg() )
            bevelCutterSection ( radius, cutter, width/2 );
        // Bevel
        if ( bevelActive() ) {
            rotate( [0,0,-mfg()] )
            rotate_extrude( angle=angle+2*mfg() )
                translate ( [radius, width/2, 0] )
                rotate( [0,0,180] )
                bevelDiagonalSection ( b );
        }
    }
}

// Concave circular beveling of a plate
module bevelCutArcConcave ( radius, width, angle=90, b=RADIUSBEVEL ) {
    mirrorZ() {
        // Cutter
        rotate( [0,0,-mfg()] )
        rotate_extrude( angle=angle+2*mfg() )
            bevelCutterSection ( 0, radius, width/2 );
        // Bevel
        if ( bevelActive() ) {
            rotate( [0,0,-mfg()] )
            rotate_extrude( angle=angle+2*mfg() )
                translate ( [radius, width/2, 0] )
                rotate( [0,0,-90] )
                bevelDiagonalSection ( b );
        }
    }
}


//
// ----------------------------------------
//            Implementation
// ----------------------------------------

function bevelActive() = is_undef($bevel) ? true : $bevel;

// This is a simple rectangle
module bevelCutterSection ( x1, x2, sizey ) {
    polygon([
        [x1, 0],
        [x2, 0],
        [x2, sizey],
        [x1, sizey]
    ]);
}

// Section of a diagonal (linear 45 deg) bevel
module bevelDiagonalSection ( radius ) {
    polygon([
        [0,       0],
        [radius,  0],
        [0,       radius],
    ]);
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------

module bevelShow() {
    difference() {
        translate( [0,0,-1] )
        linear_extrude( height=2 )
        polygon([
            [5,5],
            [5,-10],
            [0,-15],
            [0,-11],
            [-3,-11],
            [-3,-10],
            [0,-10],
            [0,-5],
            [-1,-4],
            [-2,-4],
            [-2,0],
            [-5,0],
            [0,5]
        ]);

        union() {
            color("blue") {
                translate ( [5, 0, 0] )
                    rotate( [90,0,0] )
                    rotate( [0,0,90] )
                    bevelCutLinear( 10, 2 );
                translate ( [5, 5, 0] )
                    bevelCutArc( 5, 2 );
            }

            color("green") {
                translate ( [0, -15, 0] )
                    rotate( [0,0,45] )
                    rotate( [0,90,0] )
                    bevelCutLinear( 5/cos(45), 2 );
                translate ( [5, -10, 0] )
                    bevelCutArc( 5, 2, -45 );
            }

            color("red") {
                translate ( [0, -11, 0] )
                    rotate( [90,0,0] )
                    rotate( [0,0,-90] )
                    bevelCutLinear( 4-1.5*tan(135/2), 2 );
                translate ( [0, -15, 0] )
                    rotate( [0,0,180] )
                    bevelCutArc( 1.5, 2, 135 );
                translate ( [0, -11, 0] )
                    bevelCutArcConcave( 0, 2 );
                translate ( [-3, -11, 0] )
                    rotate( [0,90,0] )
                    bevelCutLinear( 3, 2 );
            }

            color("orange") {
                translate ( [-3, -10, 0] )
                    rotate( [0,0,90] )
                    bevelCutArc( 0.50, 2, 180 );
                translate ( [-3, -10, 0] )
                    rotate( [0,90,0] )
                    rotate( [0,0,-180] )
                    bevelCutLinear( 3, 2 );
                translate ( [0, -10, 0] )
                    rotate( [0,0,-90] )
                    bevelCutArcConcave( 0, 2 );
                translate ( [0, -5, 0] )
                    rotate( [90,0,0] )
                    rotate( [0,0,-90] )
                    bevelCutLinear( 5, 2 );
            }

            color("yellow") {
                translate ( [0, -5, 0] )
                    bevelCutArcConcave( 0, 2, 45 );

                translate ( [-1, -4, 0] )
                    rotate( [0,0,-45] )
                    rotate( [0,90,0] )
                    bevelCutLinear( 1/cos(45), 2 );

                translate ( [-1, -4, 0] )
                    rotate( [0,0,45] )
                    bevelCutCornerConcave( 0, 2, 45 );

                translate ( [-2, -4, 0] )
                    rotate( [0,0,0] )
                    rotate( [0,90,0] )
                    bevelCutLinear( 1, 2 );
            }

            color("cyan") {
                translate ( [-2, 0, 0] )
                    rotate( [90,0,0] )
                    rotate( [0,0,-90] )
                    bevelCutLinear( 4, 2 );

                translate ( [-2, 0, 0] )
                    bevelCutCornerConcave( 0, 2, 90 );

                translate ( [-5, 0, 0] )
                    rotate( [0,90,0] )
                    bevelCutLinear( 3, 2 );

                translate ( [-5, 0, 0] )
                    rotate( [0,0,-135] )
                    rotate( [0,-90,0] )
                    bevelCutLinear( 5/cos(45), 2 );

            }
        }
    }
}
bevelShow($fn=100);

