use <../lib/extensions.scad>
use <../lib/bevel.scad>
use <../lib/plates.scad>

PRECISION = 100;

$fn = PRECISION;

HEIGHT = 10;
LENGTH = 11;
STANDWIDTH = 8;
ARMWIDTH = 3;
JOINTWIDTH = 6;
SPACE = 2; 
AXISOFFSET = 5;
ARMRADIUSHOLE = 2.6;
STANDRADIUSHOLE = 0.9;

STANDSPACE = STANDWIDTH / 2 + SPACE / 2;

RADIUS = 5;

module plate() {
    // Stand
    
    translate([-LENGTH / 2 - JOINTWIDTH / 2, 0, 0])
    rotate([90,0,0])
        beveledRoundedPlate([LENGTH + JOINTWIDTH , HEIGHT,STANDWIDTH], RADIUS);

    // Joint
    translate([-JOINTWIDTH / 2, 0, 0])
        beveledRoundedPlate([JOINTWIDTH, 2 * ARMWIDTH + STANDWIDTH + SPACE, HEIGHT], 0);

    // Arm
    translate([LENGTH / 2 -  JOINTWIDTH / 2, ARMWIDTH / 2 + STANDSPACE, 0])
    rotate([90,0,0])
        beveledRoundedPlate([LENGTH +  JOINTWIDTH, HEIGHT,ARMWIDTH], RADIUS);
}

module holes() {
    // Stand
    translate([-LENGTH - JOINTWIDTH + AXISOFFSET, 0, 0])
        rotate([90, 0, 0])
            cylinder(r = STANDRADIUSHOLE, h = STANDWIDTH, center = true);

    // Arms
    translate([LENGTH - AXISOFFSET, ARMWIDTH / 2 + STANDSPACE, 0])
        rotate([90, 0, 0])
            cylinder(r = ARMRADIUSHOLE, h = 2 * ARMWIDTH, center = true);
}

mirrorX() {
    difference() {
        plate();
        holes();
    }
}
