# Make your own Vigibot.com raspberry PI robot

## Minus Raspberry PI robot CAD files 

### All pieces assembled for the standard Vigibot

![Standard Minus](https://github.com/vigibot/vigicad/blob/master/images/Minus%20render-2.png)

### Parts list

#### Core assembly

- Raspberry PI 2 / Raspberry PI 3 / Raspberry PI 3 A+ / Raspberry PI 3 B+ / Raspberry PI 4

- An aftermarket *wide-angle lens* camera module v1 clone is highly recommended
  - The "genuine" camera module v1 or v2 use pinhole lens and are bad for first person view piloting
  - There is only one camera module v1 clone that combines a *wide-angle lens* and a motorized IR-cut filter at time of writing
    - https://www.robot-maker.com/shop/capteurs/311-camera-raspberry-pi.html  (fast delivery)
    - https://www.aliexpress.com/item/32957419294.html
  - It is better to have the *wide-angle lens* than the motorized IR-cut filter without the wide-angle lens
  
- 30cm Raspberry PI camera cable
  - https://www.robot-maker.com/shop/composants/329-nappe-raspberry-pi.html#/92-longueur-30cm

- A reliable Raspberry PI UPS hat board, there is only one at time of writing
  - The Geekworm / U-geek UPS Hat V3
    - https://www.amazon.fr/gp/product/B089NF1NHS
    - https://fr.aliexpress.com/item/4001113371912.html

- 1S Batterie with BMS included
   - 

- 3D printed parts, screws, nuts and standoffs 
  - Full kit : https://www.robot-maker.com/shop/kits-robots/425-kit-chassis-4wd-minus-425.html
  - List :
    - 3D printed parts : 4  ( Top, middle, bottom and rear plate )
    - 12mm length M2.5 male standoffs between the Raspberry PI and UPS hat board : 4
    - 25mm length M2.5 male standoffs between the UPS hat board and middle plate : 4
    - 10mm length M2.5 female standoffs between the middle plate and bottom plate : 4
    - 5mm length M2.5 male standoffs between the Raspberry PI board and top plate : 4
    - 6 mm M2.5 screw : 10 ( 4 top plate / 4 bottom plate / 2 middle plate)
    - 8 or 10 mm M2.5 screw to fix motor board : 2 
    - M2.5 nut : 6 ( 4 for the motor board / 2 middle plate)
    - 8mm length M2 screw to fix the back plate on the middle plate : 3 
    - M2 nut : 3

#### Motorization 

- Four Pololu 100:1 micro metal gearmotor HP 6V
  - https://www.robot-maker.com/shop/moteurs-et-actionneurs/384-moteur-pololu-300-rpm.html (provided with cable you need to solder, but can be provided soldered)
  - https://www.pololu.com/product/1101
- Four Pololu micro metal gearmotor extended bracket ( provided with screws and nuts)
  - https://www.robot-maker.com/shop/elements-mecaniques/385-support-moteur-pololu-long.html
  - https://www.pololu.com/product/1089
- Four Pololu wheel 40×7mm
  - https://www.robot-maker.com/shop/elements-mecaniques/346-roue-pololu-40mm.html  
  - https://www.pololu.com/product/1454
- Feetech 2ch motor controller (provided with cables) 
  - https://www.robot-maker.com/shop/drivers-d-actionneurs/280-driver-convertisseur-moteur-cc-servomoteur.html

#### Head assembly

- Two "SG90" type micro servo
  - 270° servo is highly recommended for the pan axis : 1
    - https://www.robot-maker.com/shop/moteurs-et-actionneurs/370-servomoteur-9g-270-370.html

  - 180° servo is good for the tilt axis : 1
    - https://www.robot-maker.com/shop/moteurs-et-actionneurs/18-servomoteur-9g-18.html

- 3D printed parts, screws, nuts and standoffs
  - Full kit : https://www.robot-maker.com/shop/kits-robots/88-kit-tourelle-pan-tilt-88.html
  - List :
    - 3D printed parts : 3 or 4 (Smiling head, pan plate, tilt bracket, and 4th is an optional protection to protect camera lens)
    - 10mm or 12mm length M2.5 screw  : 2 ( to fix pan plate to the rest of the robot)
    - M2.5 nut : 2
    - 5 or 6 mm M2 screw : 1 
    - 8 mm M2 screw : 2  (to fix 270° servo on the pan plate)
    - 14 or 16 mm M2 screw : 2 ( to fix 180° servo in the head)
    - 20 mm M2 screw : 4 (for camera assembly on the head)
    - M2 nut : 10 (8 for the camera, 2 to fix the servo on the pan plate)

#### Clamp assembly

- 180° servo SG90 servo : 2
  - https://www.robot-maker.com/shop/moteurs-et-actionneurs/18-servomoteur-9g-18.html

- 3D printed parts, screws and nuts
  - Full kit : https://www.robot-maker.com/shop/kits-robots/423-kit-pince-minus-423.html
  - List :
    - 3D printed parts : 4
    - 5 or 6 mm M2 screw : 1
    - 8 mm M2 screw : 3
    - 10 mm M2 screw : 1
    - 14 mm M2 screw : 5
    - M2 nut : 2

#### Lateral arms

- 180° servo SG90 servo : 2
  - https://www.robot-maker.com/shop/moteurs-et-actionneurs/18-servomoteur-9g-18.html

- 3D printed parts, screws and nuts
  - Full kit : https://www.robot-maker.com/shop/kits-robots/424-kit-bras-lateraux-minus-424.html
  - List :
    - 3D printed parts : 4 (left and right servo holder, and left and right lateral arms)
    - 8 mm M2 screw : 2 (to fix lateral arms on the servo)
    - 14 mm M2.5 screw : 2 (to fix servo holders on the rest of the robot it replaces 8mm M2.5 screws)
    - M2.5 nut : 2 (to fix servo holders on the rest of the robot, use 8mm M2.5 screws previously removed, wich was already on your robot) 
    - Note : use the long screws provided with servomotors to fix the servomotors on the servo holder

#### Charge station assembly

- A USB magnetic cable with magnetic plug
  - https://www.robot-maker.com/shop/alimentation/335-cable-usb-magnetique.html
  - https://www.robot-maker.com/shop/alimentation/336-embout-magnetique-micro-usb-336.html
- 3D printed part :
  - https://www.robot-maker.com/forum/topic/13134-station-de-charge-pour-robot-de-type-minus

#### Optionnal add ons
- 40mm fan for the top plate  https://www.amazon.fr/gp/product/B07D5QBFLK/ref=ppx_yo_dt_b_asin_title_o01_s00 ( use top plate with fan hole in this case)
- Leds to show if someone is using the robot or not
- Cables to manually control the IR led state on the camera

### Notes

- All stl files are provided, you will need 3D printer to print them. ( But if you don't have one you can buy the parts you need on Robot Maker)
- All sources files are provided. They are made on openscad. You will need The OpenSCAD open source software available at https://www.openscad.org to open or customize SCAD files
- Step files are also provided to be use as raw file material for other software if you want make modification with your own prefered software.
- This French video can help to better understand how to assemble the robot : https://youtu.be/9Eja0gG4bhI
