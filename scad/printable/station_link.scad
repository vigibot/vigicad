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
 translate([LENGTH / 2 , ARMWIDTH/2 + STANDWIDTH/2 + SPACE/2, 0]) {  
  cube([LENGTH ,
        ARMWIDTH,
        HEIGHT], center = true);
 }
 translate([LENGTH / 2 , -(ARMWIDTH/2 + STANDWIDTH/2 + SPACE/2), 0]) {  
  cube([LENGTH ,
        ARMWIDTH,
        HEIGHT], center = true);
 }
 translate([-LENGTH / 2 - JOINTWIDTH , 0, 0]) {  
  cube([LENGTH ,
        STANDWIDTH,
        HEIGHT], center = true);
 }
 translate([- JOINTWIDTH /2 , 0, 0]) {  
  cube([JOINTWIDTH ,
        2 * ARMWIDTH + STANDWIDTH + SPACE,
        HEIGHT], center = true);
 }
}

module holes() {
 translate([LENGTH - AXISOFFSET , ARMWIDTH/2 + STANDWIDTH/2 + SPACE/2, 0]) {
  rotate([90,0,0]) {
   cylinder(r = ARMRADIUSHOLE, h = ARMWIDTH, center = true);
  }
 }
 translate([LENGTH - AXISOFFSET , -(ARMWIDTH/2 + STANDWIDTH/2 + SPACE/2), 0]) {
  rotate([90,0,0]) {
   cylinder(r = ARMRADIUSHOLE, h = ARMWIDTH, center = true);
  }
 }
 translate([-LENGTH - JOINTWIDTH + AXISOFFSET ,0, 0]) {
  rotate([90,0,0]) {
   cylinder(r = STANDRADIUSHOLE, h = STANDWIDTH, center = true);
  }
 }
}


difference() {
 plate();
 holes();
}
