PRECISION = 100;

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

HOLEMARGIN = 0.5;
M2DIAMETER = 2 + HOLEMARGIN;
M25DIAMETER = 2.5 + HOLEMARGIN;
M3DIAMETER = 3 + HOLEMARGIN;

FOURHOLES = [
 [M25DIAMETER, 39.5, 24.5], // PI A
 [M25DIAMETER, 18.5, 24.5], // PI B
 [M25DIAMETER, 0,    10  ], // Motors PCB
 [5,           0.5,  24.5], // Oblong A
 [5,           1.5,  24.5], // Oblong B
 [5,           2.5,  24.5], // Oblong C
 [M2DIAMETER,  38,   16.5], // Motors A
 [M2DIAMETER,  20,   16.5], // Motors B
 //[M25DIAMETER, 12,   12  ], // Fan
 [M2DIAMETER,  38,   0   ], // Tools A
 [M2DIAMETER,  44.5, 12  ]  // Tools B
];

ONEHOLES = [
 //[5,    18, -8], // Fan
 //[28.5, 0,  0]   // Fan
];

$fn = PRECISION;

module quadPlate() {
 intersection() {
  translate([PLATEX / 2, PLATEY / 2, 0]) {
   cube([PLATEX, PLATEY, PLATEZ], center = true);
  }

  minkowski() {
   translate([(PLATEX - RADIUSCORNERS) / 2,
              (PLATEY - RADIUSCORNERS) / 2, 0]) {
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

module holesArray() {
 union() {
  for(holeParams = FOURHOLES)
   holeShape(holeParams[0], holeParams[1], holeParams[2]);
 }
}

module quadPlateHoles() {
 difference() {
  quadPlate();
  holesArray();
 }
}

module halfPlate() {
 mirror([MIRRORX, 0, 0])
  quadPlateHoles();
 mirror([0, 0, 0])
  quadPlateHoles();
}

difference() {
 union() {
  mirror([0, MIRRORY, 0])
   halfPlate();
  mirror([0, 0, 0])
   halfPlate();
 }

 for(holeParams = ONEHOLES)
  holeShape(holeParams[0], holeParams[1], holeParams[2]);
}

translate([PLATEX - 5, PLATEY - 5, 0])
 %cube([10, 10, PLATEZ], center = true);
