use <../lib/extensions.scad>
use <../lib/bevel.scad>
use <../lib/plates.scad>

PRECISION = 100;

$fn = PRECISION;

HEIGHT = 8;
LENGTH = 12;
STANDWIDTH = 6;
ARMWIDTH = 3;
JOINTWIDTH = 3;
SPACE = 1.8; 
AXISOFFSET = 4;
ARMRADIUSHOLE = 2.6;
STANDRADIUSHOLE = 0.9;

STANDSPACE = STANDWIDTH / 2 + SPACE / 2;

RADIUS = 0;
function getGlueMargin() = (RADIUS > getRadiusBevel()) ?  2 * RADIUS : 2 * getRadiusBevel() ;

GLUEMARGIN = getGlueMargin();

module plate() {
    // Stand
    translate([-LENGTH / 2 - JOINTWIDTH + GLUEMARGIN, 0, 0])
        beveledRoundedPlate([LENGTH + GLUEMARGIN, STANDWIDTH, HEIGHT], RADIUS);

    // Joint
    translate([-JOINTWIDTH / 2, 0, 0])
        beveledRoundedPlate([JOINTWIDTH, 2 * ARMWIDTH + STANDWIDTH + SPACE, HEIGHT], RADIUS);

    // Arm
    translate([LENGTH / 2 -  GLUEMARGIN, ARMWIDTH / 2 + STANDSPACE, 0])
        beveledRoundedPlate([LENGTH + GLUEMARGIN, ARMWIDTH, HEIGHT], RADIUS);
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
