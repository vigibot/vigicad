# Build Your Own Vigibot Raspberry Pi Robot

## Description

[Vigibot](https://www.vigibot.com/) is a platform that enables remote control of Raspberry Pi-based robots over the Internet, with live video streaming and real-time interaction.

This repository contains the CAD files, PCB files, and documentation required to build the reference robot platform used within the Vigibot ecosystem.

## Robot Versions

### Minus 2S (Current Version)

The **Minus 2S** is the latest generation of our 4WD robot platform, featuring a gripper and a pan-tilt camera head. It has been redesigned around custom PCBs to simplify assembly, improve reliability, and provide a cleaner overall build.

Compared to the previous version, the Minus 2S uses a **2-cell (2S) Li-ion/LiPo battery architecture** and the new **Vigi UPS V3** power management board.

Key advantages of the 2S architecture include:

- Higher available power for motors and peripherals

- Lower current for the same power output, reducing voltage drops and cable losses

- Improved stability during motor acceleration and under heavy load

- Better support for power-demanding accessories such as LiDARs, USB devices, and 4G modems

- Increased efficiency of the overall power system

The integration of the **Vigi UPS V3** further enhances the platform by providing robust power management for the Raspberry Pi and onboard electronics, improving overall system stability and reliability.

### Minus 1S (Legacy / Deprecated)

The **Minus 1S** is the previous generation of the robot platform and is now considered legacy hardware.

It uses a single-cell (1S) battery architecture and an earlier power management design. While still functional, it offers lower available power and more limited expansion capabilities compared to the Minus 2S platform.

## Repository Contents

Each repository includes the resources required to build the corresponding robot platform:

- CAD files for 3D-printed parts

- PCB design files

- Assembly documentation

- Hardware resources related to the robot platform

## Notes

- This project is actively evolving.

- Additional documentation, assembly guides, and build instructions will be added over time.
