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

use <../../../PressureAngleGear/StraightGearLib.scad>
use <extensions.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

module servoFinger(arm_l=ARM_L,arm_a=ARM_A,arm_i=ARM_I,elbow_r=ARM_R,elbow_a=ELBOW_A) {
    data = armData ( arm_l, arm_a, arm_i, elbow_r, elbow_a, with_stand=true );
    translate( [arm_i/2,0,0] )
    rotate( [0,0,-arm_a] )
    difference() {
        union() {
            wedgeC();
            arm(data);
        }
        cylinder(r=PINCE_B_HOLE/2,h=30,center=true);
        servoHornHole();
    }
}

module clampFingerAImpl(arm_l=ARM_L,arm_a=ARM_A,arm_i=ARM_I,elbow_r=ARM_R,elbow_a=ELBOW_A) {
    data = armData ( arm_l, arm_a, arm_i, elbow_r, elbow_a, with_stand=true );
    rotate( [0,0,+ARM_A] )
    difference() {
        union() {
            gearA();
            wedgeA();
            mirror( [1,0,0] )
                arm(data);
        }
        cylinder(r=PINCE_A_HOLE/2,h=30,center=true);
        servoHornHole();
    }
}

module clampFingerBImpl(arm_l=ARM_L,arm_a=ARM_A,arm_i=ARM_I,elbow_r=ARM_R,elbow_a=ELBOW_A) {
    data = armData ( arm_l, arm_a, arm_i, elbow_r, elbow_a, with_stand=false );
    rotate( [0,0,-ARM_A] )
    difference() {
        union() {
            gearB();
            wedgeB();
            arm(data);
        }
        cylinder(r=PINCE_B_HOLE/2,h=30,center=true);
    }
}

// ----------------------------------------
//            Implementation
// ----------------------------------------

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

ARM_W=7.5;   // Width: largeur du bras
ARM_T=5;     // Thickness: epaisseur du bras
ARM_B=0.5;   // Bevel: Chamfrein du bras
ARM_L=17.0;  // Longueur de la partie droite du bras
ARM_R=12.5;  // Rayon interieur de l'arrondi du bras
ARM_A=25.3;  // Inclinaison angle: rotation de tout le bras sur son axe
ELBOW_A=110; // Elbow arc default angle

// Special for no gear version
ARM_I=PITCHDIAMETER;  // Default clamp Inter-axis


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

GEAR_PRM = gearPrm2D (
    NBTOOTH,
    MODULE,
    ALPHA,
    0.2
);

function getClampPitchDiameter()    = PITCHDIAMETER;
function getClampArmBaseLength()    = ARM_L;
function getClampArmBaseRadius()    = ARM_R;

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
    rotate_extrude()
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
    rotate_extrude()
    polygon( points=[
        [0,0],
        [GEAR_RADIUS,0],
        [GEAR_RADIUS,WB_H-WB_B],
        [GEAR_RADIUS -WB_B,WB_H],
        [0,WB_H]
    ]);
}

module wedgeC() {
    // diam 1:  STAND_W  / STAND_W/2
    // diam 2:  11.0     / 5.5
    // diam 3:  8.4      / 4.2
    // h section 1: 3.25 / 3.25
    // h section 2: 1.3  / 4.55
    // h section 3: 1.65 / 6.2
    // h section 4: 1.3  / 7.5
    rotate_extrude()
    polygon( points=[
        [0,0],
        // Elargissement de la base pour masquer
        //   le bas du bras renforcé
        [GEAR_RADIUS + WA_B-ARM_B,0],
        [GEAR_RADIUS + WA_B,0 + ARM_B],
        [GEAR_RADIUS + WA_B,WA_H - WA_B],
        [GEAR_RADIUS,WA_H],
        [0,WA_H]
    ]);
}

module fingerEndBevel(data) {
    rotate( [0,0,data[I_ARM_A]] )
    translate( [-data[I_ARM_I]/2,0,0] )
    rotate([-90,0,0])
    linear_extrude(height=(data[I_FOREARM_EG].y+data[I_FOREARM_H])*2)
    polygon( points=[
        [2*ARM_B,ARM_B],
        [-100,ARM_B],
        [-100,-ARM_T-ARM_B],
        [2*ARM_B,-ARM_T-ARM_B],
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

// Indexes in data returned by armData
I_ARM_L      =  0; // Arm length
I_ARM_A      =  1; // Arm inclinaison angle
I_ARM_I      =  2; // Arms interaxis
I_ELBOW_R    =  3; // Elbow radius
I_ELBOW_A    =  4; // Elbow angle
I_STAND      =  5; // With or without stand (bool)
I_FOREARM_SL =  6; // Forearm starting point middle [x,y] in local coordinated
I_FOREARM_EG =  7; // Forearm end point bot [x,y] in glocal coordinated
I_FOREARM_L  =  8; // Forearm length of middle line
I_FOREARM_H  =  9; // Forearm height of section at X=0
function armData ( arm_l, arm_a, arm_i, elbow_r, elbow_a, with_stand ) = let (
    fore_top_x  = -elbow_r+(elbow_r+ARM_W)*cos(elbow_a)-ARM_W/2,
    fore_top_y  = +arm_l+(elbow_r+ARM_W)*sin(elbow_a),
    fore_bot_x  = -elbow_r+(elbow_r)*cos(elbow_a)-ARM_W/2,
    fore_bot_y  = +arm_l+(elbow_r)*sin(elbow_a),
    fore_mid_x  = (fore_top_x+fore_bot_x)/2,
    fore_mid_y  = (fore_top_y+fore_bot_y)/2,
    angle       = arm_a+(90-elbow_a),
    coeff_top   = fore_top_x*cos(-arm_a) -fore_top_y*sin(-arm_a) +arm_i/2,
    fore_top_l  = coeff_top/cos(-angle),
    coeff_bot   = fore_bot_x*cos(-arm_a) -fore_bot_y*sin(-arm_a) +arm_i/2,
    fore_bot_l  = coeff_bot/cos(-angle),
    fore_l      = max(fore_top_l,fore_bot_l),
    fore_bot_elx = fore_bot_x - fore_bot_l*cos(90-elbow_a),
    fore_bot_ely = fore_bot_y + fore_bot_l*sin(90-elbow_a),
    fore_bot_egx = fore_bot_elx*cos(-arm_a)-fore_bot_ely*sin(-arm_a)+arm_i/2,
    fore_bot_egy = fore_bot_elx*sin(-arm_a)+fore_bot_ely*cos(-arm_a),
    fore_h      = ARM_W/cos(angle)
) [arm_l,arm_a,arm_i,elbow_r,elbow_a,with_stand,
[fore_mid_x,fore_mid_y],[fore_bot_egx,fore_bot_egy],fore_l,fore_h];

module armShape(data) {
    rotate([-90,0,0])
        translate( [-ARM_W/2,-ARM_T,0] )
        union() {
            if ( data[I_STAND] )
                armStandShape();
            linear_extrude(height=data[I_ARM_L])
                armSection();
        }
    translate( [-data[I_ELBOW_R]-ARM_W/2,data[I_ARM_L],0] )
        rotate_extrude(angle=data[I_ELBOW_A])
        translate( [data[I_ELBOW_R],0,0] )
        armSection();
    translate( [data[I_FOREARM_SL].x,data[I_FOREARM_SL].y,0] )
        rotate([0,0,data[I_ELBOW_A]])
        rotate([-90,0,0])
        translate( [-ARM_W/2,-ARM_T,0] ) {
        linear_extrude(height=data[I_FOREARM_L])
            armSection();
    }
}

module arm(data) {
    difference() {
        armShape(data);
        fingerEndBevel(data);
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

// ----------------------------------------
//                 Showcase
// ----------------------------------------
translate( [0,0,0] ) {
    color("DeepSkyBlue")
        translate( [-getClampPitchDiameter()/2,0,0] )
        clampFingerAImpl( arm_l=2*getClampArmBaseLength(),elbow_r=22, $fn=100 );
    color("Cyan")
        translate( [+getClampPitchDiameter()/2,0,0] )
        clampFingerBImpl( elbow_r=2*getClampArmBaseRadius(), $fn=100 );
}

translate( [50,0,0] ) {
    color("green")
        servoFinger($fn=100);
    color("lime")
        mirror( [1,0,0] )
        servoFinger($fn=100);
}

translate( [150,90,0] ) {
    color("DarkViolet")
        mirrorY()
        servoFinger(arm_l=40,arm_a=30,arm_i=30,elbow_r=20,elbow_a=110,$fn=100);
}

translate( [150,0,0] ) {
    color("MediumOrchid")
        mirrorY()
        servoFinger(arm_l=40,arm_a=0,arm_i=100,elbow_r=20,elbow_a=90,$fn=100);
}

translate( [150,-70,0] ) {
    color("DarkViolet")
        mirrorY()
        servoFinger(arm_l=40,arm_a=-30,arm_i=100,elbow_r=20,elbow_a=90,$fn=100);
}

translate( [150,-120,0] ) {
    color("Plum")
        mirrorY()
        servoFinger(arm_l=20,arm_a=45,arm_i=10,elbow_r=8,elbow_a=170,$fn=100);
}
