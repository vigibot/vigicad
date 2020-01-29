# Make your own Vigibot.com raspberry PI robot

## Raspberry PI robot CAD files

### Prerequisites

- A 3D printer to print the robot STL files
- The OpenSCAD software available at https://www.openscad.org to open or customize SCAD files

### All pieces assembled for the standard Vigibot

![Standard Vigibot](https://github.com/vigibot/vigicad/blob/master/images/minus.png)

### Parts list

#### Core assembly

- Raspberry PI 2 / Raspberry PI 3 / Raspberry PI 3 A+ / Raspberry PI 3 B+ / Raspberry PI 4
- An aftermarket *wide-angle lens* camera module v1 clone is highly recommended
  - The "genuine" camera module v1 or v2 use pinhole lens and are bad for first person view piloting
  - There is only one camera module v1 clone that combines a *wide-angle lens* and a motorized IR-cut filter at time of writing
    - https://www.robot-maker.com/shop/capteurs/311-camera-raspberry-pi.html
    - https://www.aliexpress.com/item/32957419294.html
  - It is better to have the *wide-angle lens* than the motorized IR-cut filter without the wide-angle lens
- 30cm Raspberry PI camera cable
  - https://www.robot-maker.com/shop/composants/329-nappe-raspberry-pi.html#/92-longueur-30cm
- A reliable Raspberry PI UPS hat board, it's hard to find at time of writing
  - The Geekworm Power Pack Pro V1.1 (red PCB) need a small hack to get reliable especially with a magnetic cable
    - Our modification solve the power shutdown when there is a short power cut
      - Remove the comparator U3
      - You can remove the capacitor C12 and resistors R23 to R27 wich are useless without U3
      - Don't remove R4 and R5
  - The Geekworm Power Pack V1.0 (blue PCB) need a larger hack to get usable
    - This modification solve the charger that does not start after a power cut
      - https://brousant.nl/jm3/elektronica/105-geekworm-ups-for-raspberry-pi-simple-modification-detailed
- Hex standoffs
  - Four 12mm length standoffs between the Raspberry PI and UPS hat board
  - Four 25mm length standoffs between the UPS hat board and middle plate
  - Four 10mm length standoffs between the middle plate and bottom plate
- 40mm fan for the top plate
  - https://www.amazon.fr/gp/product/B07D5QBFLK/ref=ppx_yo_dt_b_asin_title_o01_s00
- Cables
  - TODO
- Screws
  - TODO

#### Motorization assembly

- Four Pololu 100:1 micro metal gearmotor HP 6V
  - https://www.robot-maker.com/shop/moteurs-et-actionneurs/384-moteur-pololu-300-rpm.html
  - https://www.pololu.com/product/1101
- Four Pololu micro metal gearmotor extended bracket
  - https://www.robot-maker.com/shop/elements-mecaniques/385-support-moteur-pololu-long.html
  - https://www.pololu.com/product/1089
- Four Pololu wheel 40×7mm
  - https://www.robot-maker.com/shop/elements-mecaniques/346-roue-pololu-40mm.html
  - https://www.pololu.com/product/1454
- Feetech 2ch motor controller
  - https://www.robot-maker.com/shop/drivers-d-actionneurs/280-driver-convertisseur-moteur-cc-servomoteur.html
- Cables
  - TODO
- Screws
  - TODO

#### Head assembly

- Two "SG90" type micro servo
  - A 270° servo is highly recommended for the pan axis
  - A 180° servo is good for the tilt axis
- Cables
  - TODO
- Screws
  - TODO

#### Clamp assembly

- Two 180° "SG90" type micro servo
- Cables
  - TODO
- Screws
  - TODO

#### Charge station assembly

- A micro USB magnetic cable
  - https://www.robot-maker.com/shop/alimentation/335-cable-usb-magnetique.html
- Screws
  - TODO
