use <../lib/extensions.scad>
use <../lib/bevel.scad>

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

module plate() {
    // Stand
    translate([-LENGTH / 2 - JOINTWIDTH, 0, 0])
        cube([LENGTH, STANDWIDTH, HEIGHT], center = true);

    // Joint
    translate([-JOINTWIDTH / 2, 0, 0])
        cube([JOINTWIDTH, 2 * ARMWIDTH + STANDWIDTH + SPACE, HEIGHT], center = true);

    // Arm
    translate([LENGTH / 2, ARMWIDTH / 2 + STANDWIDTH / 2 + SPACE / 2, 0])
        cube([LENGTH, ARMWIDTH, HEIGHT], center = true);
}

module holes() {
    // Stand
    translate([-LENGTH - JOINTWIDTH + AXISOFFSET, 0, 0])
        rotate([90, 0, 0])
            cylinder(r = STANDRADIUSHOLE, h = STANDWIDTH, center = true);

    // Arms
    translate([LENGTH - AXISOFFSET, ARMWIDTH / 2 + STANDWIDTH / 2 + SPACE / 2, 0])
        rotate([90, 0, 0])
            cylinder(r = ARMRADIUSHOLE, h = ARMWIDTH, center = true);
}

module bevels() {
    // Arms outer
    translate([-JOINTWIDTH, (ARMWIDTH + STANDWIDTH / 2 + SPACE / 2), 0])
        rotate([180, 270, 0])
            bevelCutLinear(LENGTH + JOINTWIDTH, HEIGHT);

    // Arms inner
    translate([LENGTH, (STANDWIDTH / 2 + SPACE / 2), 0])
        rotate([0, 270, 0])
            bevelCutLinear(LENGTH, HEIGHT);

    // Arms top
    translate([LENGTH, (STANDWIDTH / 2 + SPACE / 2), 0])
        rotate([0, 90, 90])
            bevelCutLinear(ARMWIDTH, HEIGHT);

    // Joint outer
    translate([-JOINTWIDTH, (ARMWIDTH + STANDWIDTH / 2 + SPACE / 2), 0])
        rotate([0, 90, -90])
            bevelCutLinear(ARMWIDTH + SPACE / 2, HEIGHT);

    // Joint inner
    translate([0, STANDWIDTH / 2 + SPACE / 2, 0])
        rotate([0, 270, 90])
            bevelCutLinear(STANDWIDTH / 2 + SPACE / 2, HEIGHT);

    // Stand sides
    translate([-JOINTWIDTH, STANDWIDTH / 2, 0])
        rotate([180, 90, 0])
            bevelCutLinear(LENGTH, HEIGHT);

    // Stand bottom
    translate([-LENGTH - JOINTWIDTH, STANDWIDTH / 2, 0])
        rotate([0, 90, -90])
            bevelCutLinear(STANDWIDTH, HEIGHT);
}

difference() {
    mirrorX()
        plate();

    mirrorX()
        union() {
            holes();
            bevels();
        }
}
