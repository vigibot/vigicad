/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for Vigibot clamp
 * Design:      Quillès Jonathan / Pascal Piazzalungua
 * Author:      Gilles Bouissac
 */

include <../../../PressureAngleGear/StraightGearLib.scad>

PRECISION=200;

// ============
//  PARAMETERS
// ============

// Pitch diameter (PD):
//   Pitch diameters of 2 connected gears MUST be tangent
//   PITCHDIAMETER = MODULE * NBTOOTH

PRINTER_NOZE=0.4;
PRINTER_LAYER=0.2;

PITCHDIAMETER = 10.8;
NBTOOTH=12;
ALPHA=25; // Pressure angle
MODULE=(PITCHDIAMETER)/NBTOOTH;
GEAR_RADIUS=4.14;

THICKNESS=3;
PINCE_A_HOLE=1.8;
PINCE_B_HOLE=2.2;
PINCE_A_COLOR="DeepSkyBlue";
PINCE_B_COLOR="Cyan";

ARM_W=7.5;   // Width: largeur du bras
ARM_T=5;     // Thickness: epaisseur du bras
ARM_B=0.5;   // Bevel: Chamfrein du bras
ARM_L=17.0;  // Longueur de la partie droite du bras
ARM_R=12.5;  // Rayon interieur de l'arrondi du bras
ARM_I=-25.3; // Inclinaison: rotation de tout le bras sur son axe

// Palonnier de la servo
// HORN_D=5.75;     // Grand diametre palonnier
HORN_D=7.15;     // Grand diametre palonnier
HORN_d=4.2;      // Petit diametre palonnier
HORNHOLE_d=7.15; // Diametre trou palonnier
HORN_L=14.13;    // Distance inter-axiale palonnier
HORN_R=HORN_D/2;
HORN_r=HORN_d/2;
HORNHOLE_r=HORNHOLE_d/2;

// Grande largeur base du bras
// Base renforcée du bras
//   Pour assurer 3 passes de filamment de chaque côté
STAND_W=HORN_D+6*PRINTER_NOZE;
// Petite largeur base du bras
STAND_w=ARM_W;
// Longueur de la base du bras
STAND_L=HORN_L;

// Wedge B dimensions
WB_B = 1;   // Bevel
WB_H = 6.5; // Height

// Wedge A dimensions
WA_B = 1;   // Bevel
WA_H = 7.5; // Height

$fn=PRECISION;

GEAR_PRM = gearPrm2D (
    NBTOOTH,
    MODULE,
    ALPHA,
    0.2
);
module gearShape ( thickness=THICKNESS ) {
    rotate([0,0,0])
        linear_extrude(height=thickness, convexity = 10)
        gear2D (GEAR_PRM);
}

module gearB() {
    difference() {
        gearShape();
        difference() {
            translate([0,9,0])
                cylinder(r=8.7,h=30,center=true);   
            cylinder(r=GEAR_RADIUS,h=31,center=true);
        }
    }
}

module gearA() {
    difference() {
        rotate([0,0,15])
            gearShape();
        difference() {
            translate([0,9,0])
                cylinder(r=8,h=30,center=true);   
            cylinder(r=GEAR_RADIUS,h=31,center=true);
        }

    }
}

module wedgeA() {
    // diam 1:  STAND_W  / STAND_W/2
    // diam 2:  11.0     / 5.5
    // diam 3:  8.4      / 4.2
    // h section 1: 3.25 / 3.25
    // h section 2: 1.3  / 4.55
    // h section 3: 1.65 / 6.2
    // h section 4: 1.3  / 7.5
    rotate_extrude($fn=PRECISION)
    polygon( points=[
        [0,THICKNESS],
        // Elargissement de la base pour masquer
        //   le bas du bras renforcé
        [GEAR_RADIUS,THICKNESS],
        [GEAR_RADIUS + WA_B,THICKNESS + WA_B],
        [GEAR_RADIUS + WA_B,WA_H - WA_B],
        [GEAR_RADIUS,WA_H],
        [0,WA_H]
    ]);
}

module wedgeB() {
    rotate_extrude($fn=PRECISION)
    polygon( points=[
        [0,0],
        [GEAR_RADIUS,0],
        [GEAR_RADIUS,WB_H-WB_B],
        [GEAR_RADIUS -WB_B,WB_H],
        [0,WB_H]
    ]);
}

module cutFingers() {
    translate( [-PITCHDIAMETER/2,0,0] )
    translate( [0,25,0] )
    rotate([-90,0,0])
    linear_extrude(height=100)
    polygon( points=[
        [ARM_B,0],
        [-10,0],
        [-10,-ARM_T],
        [ARM_B,-ARM_T],
        [0,-ARM_T+ARM_B],
        [0,-ARM_B]
    ]);
}

module armSection( w=ARM_W, t=ARM_T, b=ARM_B ) {
    polygon( points=[
        [0,b],     [b,0],
        [w-b,0],   [w,b],
        [w,t-b],   [w-b,t],
        [b,t],     [0,t-b]
    ]);
}

module armStandShape() {
    translate( [0,0,1.9] ) {
    hull() {
        translate( [0,0,STAND_L] )
        linear_extrude(height=0.01)
        armSection ( w=ARM_W );

        linear_extrude(height=0.01)
        translate( [-(STAND_W-ARM_W)/2,0,STAND_L] )
        armSection ( w=STAND_W );
    }
    hull() {
        translate( [0,0,-(STAND_W-ARM_W)/2] )
        linear_extrude(height=0.01)
        armSection ( w=ARM_W );

        linear_extrude(height=0.01)
        translate( [-(STAND_W-ARM_W)/2,0,STAND_L] )
        armSection ( w=STAND_W );
    }
    }
}

module armShape( arm_l, arm_r, with_stand=false ) {
    rotate([-90,0,0])
    translate( [-ARM_W/2,-ARM_T,0] ) {
        if ( with_stand )
            armStandShape();
        linear_extrude(height=arm_l)
            armSection();
    }
    translate( [-arm_r-ARM_W/2,arm_l,0] )
    rotate_extrude(angle=110,$fn=PRECISION)
        translate( [arm_r,0,0] )
        armSection();
}

module arm( arm_l, arm_r, with_stand=false ) {
    rotate( [0,0,-ARM_I] )
    difference() {
        rotate( [0,0,+ARM_I] )
            armShape( arm_l, arm_r, with_stand );
        cutFingers();
    }
}

module servoHornHole() {
    translate([0,0,8])
    union() {
        cylinder(r=HORNHOLE_r,h=10,center=true);
        hull() {
            translate([0,HORN_L,0])
                cylinder(r=HORN_r,h=10,center=true);
            cylinder(r=HORN_R,h=10,center=true);
        }
    }
}

module pinceB(arm_l,arm_r) {
    rotate( [0,0,ARM_I] )
    difference() {
        union() {
            gearB();
            wedgeB();
            arm( arm_l, arm_r, with_stand=false );
        }
        cylinder(r=PINCE_B_HOLE/2,h=30,center=true);
    }
}

module pinceA(arm_l,arm_r) {
    rotate( [0,0,-ARM_I] )
    difference() {
        union() {
            gearA();
            wedgeA();
            mirror( [1,0,0] )
                arm( arm_l, arm_r, with_stand=true );
        }
        cylinder(r=PINCE_A_HOLE/2,h=30,center=true);
        servoHornHole();
    }
}

module clamp ( ratio=1 ) {
    color(PINCE_A_COLOR)
        translate( [-PITCHDIAMETER/2,0,0] )
        pinceA( ratio*ARM_L, ratio*ARM_R );
    color(PINCE_B_COLOR)
        translate( [+PITCHDIAMETER/2,0,0] )
        pinceB( ratio*ARM_L, ratio*ARM_R );
}

translate( [0,0,0] )
    clamp ( ratio=1 );

// import du module STL Catia pour comparaison
*#
color(PINCE_A_COLOR)
translate( [-PITCHDIAMETER/2,0,0] )
rotate( [0,0,25.3] )
translate([-0.25,2.6,-1.7])
rotate( [0,0,-50.4] )
    import( "../stl/old/PinceA.stl" );

*#
color(PINCE_B_COLOR)
translate( [+PITCHDIAMETER/2,0,0] )
rotate( [0,0,-25.3] )
translate([0.26,4.19,5.3])
rotate( [0,180,0] )
rotate( [0,0,-36] )
    import( "../stl/old/PinceB.stl" );
