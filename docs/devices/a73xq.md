---
layout: default
title: Galaxy A73 5G
parent: Supported devices
---

<p align="center">
  <img loading="lazy" src="/assets/images/a73.webp"/>
</p>

# Galaxy A73 5G (a73xq)
{: .pb-4 }
- Maintainer: [@BlackMesa123](https://github.com/BlackMesa123)
- Latest version: ![img](https://img.shields.io/github/v/release/BlackMesa123/UN1CA?filter=a73xq*&style=flat-square)
- Install method: Custom recovery
- Requirements: [**Android 14 bootloader**](https://github.com/Simon1511/samsung-sm7325-fw/releases)

## Support links

- [XDA Forums](https://xdaforums.com/f/samsung-galaxy-a73-5g.12667/)
- [Telegram](https://t.me/A73Dev)

## Device specifications

| Feature                        | Specification                                                                             |
| -----------------------------: | :---------------------------------------------------------------------------------------- |
| Chipset                        | Qualcomm SM7325 Snapdragon 778G 5G                                                        |
| CPU                            | Octa-core (1x2.4 GHz Kryo 670 Prime, 3x2.2 GHz Kryo 670 Gold & 4x1.9 GHz Kryo 670 Silver) |
| GPU                            | Qualcomm Adreno 642L                                                                      |
| Memory                         | 6GB / 8GB RAM (LPDDR4X)                                                                   |
| Shipped OS                     | Android 12 (One UI 4.1)                                                                   |
| Storage                        | 128GB / 256GB (UFS 2.1)                                                                   |
| SIM                            | Hybrid Dual SIM (Nano-SIM, dual stand-by)                                                 |
| MicroSD                        | Up to 1TB                                                                                 |
| Battery                        | 5000mAh Li-Ion (non-removable), 25W fast charge                                           |
| Dimensions                     | 163.7 x 76.1 x 7.6 mm (6.44 x 3.00 x 0.30 in)                                             |
| Display                        | 6.7", 1080 x 2400 pixels, 20:9 ratio, Super AMOLED, 120Hz (~393 ppi density)              |
| Rear Camera 1 (S5KHM6)         | 108 MP, f/1.8, (wide), 1/1.67", 0.64µm, PDAF, OIS                                         |
| Rear Camera 2 (IMX258)         | 12 MP, f/2.2, 123˚ (ultrawide), 1/3.06", 1.12µm                                           |
| Rear Camera 3 (S5KGW2)         | 5 MP, f/2.4, (macro)                                                                      |
| Rear Camera 4 (S5K3J1)         | 5 MP, f/2.4, (depth)                                                                      |
| Front Camera (IMX616)          | 32 MP, f/2.2, 26mm (wide), 1/2.8", 0.8µm                                                  |
| Fingerprint                    | Goodix GW9558 (under display, optical)                                                    |
| Sensors                        | Accelerometer, Gyro, Proximity (virtual), Compass, Hall IC, Grip                          |
| Extras                         | Dual speakers, NFC                                                                        |

## How to build

```bash
git clone --recurse-submodules https://github.com/BlackMesa123/UN1CA.git && cd UN1CA
. ./buildenv.sh a73xq
run_cmd make_rom
```
