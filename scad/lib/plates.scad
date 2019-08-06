/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD design for Vigibot plates
 * Design:      Quillès Jonathan / Pascal Piazzalungua
 * Author:      Gilles Bouissac
 */

HOLEMARGIN = 0.5;
M2DIAMETER = 2 + HOLEMARGIN;
M25DIAMETER = 2.5 + HOLEMARGIN;
M3DIAMETER = 3 + HOLEMARGIN;

// ----------------------------------------
//                  API
// ----------------------------------------

// Build plate with given holes lists
// - fourHoles:   Drill given holes 4 times (double mirroring)
// - singleHoles: Drill given holes once
// - dxf:         Generates .dxf file
module plate( fourHoles=[], singleHoles=[], dxf=false ) {
    if( dxf )
        projection(cut = true)
            plateImpl( fourHoles, singleHoles );
    else
        plateImpl( fourHoles, singleHoles);

    translate([PLATEX - 5, PLATEY - 5, 0])
        %cube([10, 10, PLATEZ], center = true);
}

// Get Vigibot motors holes
function getMotorsFourHoles() = [
    [M2DIAMETER, 38, 16.5],    // Motors A
    [M2DIAMETER, 20, 16.5],    // Motors B
];

// Get Vigibot raspberry PI holes
function getRaspberryFourHoles() = [
    [M25DIAMETER, 39.5, 24.5], // PI A
    [M25DIAMETER, 18.5, 24.5], // PI B
];

// Get Vigibot motor PCB holes
function getMotorPcbFourHoles() = [
    [M25DIAMETER, 0, 10],      // Motors PCB
];

// Get Vigibot oblong holes
function getOblongFourHoles() = [
    [5, 0.5, 24.5],            // Oblong A
    [5, 1.5, 24.5],            // Oblong B
    [5, 2.5, 24.5],            // Oblong C
];

// Get Vigibot tool holes
function getToolFourHoles() = [
    [M2DIAMETER, 38, 0],       // Tools A
    [M2DIAMETER, 44.5, 12]     // Tools B
];

// Get Vigibot FAN fixing holes
function getFanFourHoles() = [
    [M25DIAMETER, 12, 12]
];

// Get Vigibot FAN main holes
function getFanSimpleHoles() = [
    [5, 18, -8],
    [28.5, 0, 0]
];

// ----------------------------------------
//            Implementation
// ----------------------------------------

P_MOTORS = 0;
P_OBLONG = 1;
P_MOTORPCB = 2;
P_PI = 3;
P_TOOL = 4;
P_FAN = 5;
P_DXF = 6;

MIRRORX = 1;
MIRRORY = 1;
PLATEX = 95 / (MIRRORX ? 2 : 1);
PLATEY = 60 / (MIRRORY ? 2 : 1);
PLATEZ = 3;

RADIUSCORNERS = 5;
RADIUSBEVEL = 0.5;

BEVELTYPENONE = 0;
BEVELTYPESPHERE = 1;
BEVELTYPECONE = 2;
BEVELTYPE = BEVELTYPECONE;

module quadPlate() {
    intersection() {
        translate([PLATEX / 2, PLATEY / 2, 0]) {
            cube([PLATEX, PLATEY, PLATEZ], center = true);
        }

        minkowski() {
            translate([
                (PLATEX - RADIUSCORNERS) / 2,
                (PLATEY - RADIUSCORNERS) / 2,
                0
            ]) {
                cube([PLATEX - RADIUSCORNERS,
                PLATEY - RADIUSCORNERS,
                PLATEZ - RADIUSBEVEL * 2], center = true);
            }

            minkowski() {
                cylinder(r = RADIUSCORNERS - RADIUSBEVEL, h = 0.0001, center = true);
                if(BEVELTYPE == BEVELTYPESPHERE)
                    sphere(r = RADIUSBEVEL);
                else if(BEVELTYPE == BEVELTYPECONE)
                    union() {
                        cylinder(r1 = RADIUSBEVEL, r2 = 0, h = RADIUSBEVEL, center = false);
                        translate([0, 0, -RADIUSBEVEL])
                            cylinder(r1 = 0, r2 = RADIUSBEVEL, h = RADIUSBEVEL, center = false);
                    }
                else
                    cylinder(r1 = RADIUSBEVEL, r2 = RADIUSBEVEL, h = RADIUSBEVEL * 2, center = true);
            }
        }
    }
}

module holeShape(diameter, distx, disty) {
    translate([distx, disty, 0]) {
        cylinder(r = diameter / 2, h = PLATEZ * 2, center = true);
    }
}

module holesArray( fourHoles ) {
    union() {
        for(holeParams = fourHoles)
            holeShape(holeParams[0], holeParams[1], holeParams[2]);
    }
}

module quadPlateHoles( fourHoles ) {
    difference() {
        quadPlate();
        holesArray( fourHoles );
    }
}

module halfPlate( fourHoles ) {
    mirror([MIRRORX, 0, 0])
        quadPlateHoles( fourHoles );
    mirror([0, 0, 0])
        quadPlateHoles( fourHoles );
}

// flatten([[0,1],[2,3]]) => [0,1,2,3]
function flatten(list) = [ for (i = list, v = i) v ];

// main module
module plateImpl( fourHoles, singleHoles ) {
    difference() {
        union() {
            mirror([0, MIRRORY, 0])
                halfPlate( flatten(fourHoles) );
            mirror([0, 0, 0])
                halfPlate( flatten(fourHoles) );
        }
        for(holeParams = flatten(singleHoles) )
            holeShape(holeParams[0], holeParams[1], holeParams[2]);
    }
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
plate(
    [
        getMotorsFourHoles(),
        getRaspberryFourHoles(),
        getMotorPcbFourHoles(),
        getOblongFourHoles(),
        getToolFourHoles(),
    ],
    $fn = 50
);

