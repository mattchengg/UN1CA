---
layout: default
title: Build flags
parent: Developer guides
nav_order: 4
---

# Build flags
{: .pb-2 }
This section covers all of the available UN1CA build flags.

Source build flags must be set inside `unica/config.sh` and are related to the firmware which is used as the ROM base, while target build flags must be set in the `config.sh` file of the desidered target device.

## Source build flags

### - **SOURCE_FIRMWARE** (string, required)
{: .pb-2 }
Defines the source device firmware to use with the format of **"Model number/CSC"**. Currently, UN1CA uses Galaxy S23 (`SM-S911B/INS`) as base for Qualcomm devices and Galaxy S22 (`SM-S901B/BTE`) for Exynos devices.

### - **SOURCE_EXTRA_FIRMWARES** (array, optional)
{: .pb-2 }
When defined, this set of extra devices firmwares will be downloaded/extracted when running `download_fw`/`extract_fw` along with the one set in `SOURCE_FIRMWARE`.
This flag is passed as a string array in bash syntax, with each string element having the format of **"Model number/CSC"** (eg. `SOURCE_EXTRA_FIRMWARES=("SM-A528B/BTU" "SM-A528N/KOO")`).

### - **SOURCE_API_LEVEL** (int, required)
{: .pb-2 }
Defines the source firmware [Android API level](https://developer.android.com/tools/releases/platforms), this must match the `ro.build.version.sdk` value in `/system/build.prop`.

### - **SOURCE_VNDK_VERSION** (int, required)
{: .pb-2 }
Defines the source firmware [VNDK](https://source.android.com/docs/core/architecture/vndk) version, this must match the `ro.vndk.version` value in `/vendor/build.prop` or `/vendor/default.prop`.

### - **SOURCE_HAS_SYSTEM_EXT** (boolean, required)
{: .pb-2 }
Set this flag to true if the source device has a separate system_ext partition. You can check this by extracting the `super.img` partition or in the fstab config file.

### - **SOURCE_HAS_KNOX_DUALDAR** (boolean, required)
{: .pb-2 }
Set this to true if the source device has [Knox DualDAR](https://docs.samsungknox.com/admin/fundamentals/whitepaper/app-and-data-protection/dualdar-encryption/).
This must match the `KNOX_SUPPORT_DAR_DUAL` value in the `com.samsung.android.rune.CoreRune` class inside `framework.jar`.

### - **SOURCE_HAS_KNOX_SDP** (boolean, required)
{: .pb-2 }
Set this to true if the source device has [Knox SDP](https://docs.samsungknox.com/admin/fundamentals/whitepaper/core-platform-security/sensitive-data-protection/).
This must match the `KNOX_SUPPORT_DAR_SDP` value in the `com.samsung.android.rune.CoreRune` class inside `framework.jar`.

### - **SOURCE_HAS_MASS_CAMERA_APP** (boolean, required)
{: .pb-2 }
Set this to true if the source device has the low-end version of the stock Samsung Camera app. You can check this in the app manifest under the `SPDE.build.signature` entry (app variant must match `hal3_mass-phone-release`).

### - **SOURCE_HAS_OPTICAL_FP_SENSOR** (boolean, required)
{: .pb-2 }
Set this to true if the source device has an optical in-display fingerprint sensor.

### - **SOURCE_IS_ESIM_SUPPORTED** (boolean, required)
{: .pb-2 }
Set this to true if the source device supports eSIM.

## Target build flags

### - **TARGET_NAME** (string, required)
{: .pb-2 }
Defines the target device market name.

### - **TARGET_CODENAME** (string, required)
{: .pb-2 }
Defines the target device codename, this must match the `ro.product.vendor.device` value in `/vendor/build.prop`.

### - **TARGET_FIRMWARE** (string, required)
{: .pb-2 }
Defines the target device firmware to use with the format of **"Model number/CSC"**.

### - **TARGET_EXTRA_FIRMWARES** (array, optional)
{: .pb-2 }
When defined, this set of extra devices firmwares will be downloaded/extracted when running `download_fw`/`extract_fw` along with the one set in `TARGET_FIRMWARE`.
This flag is passed as a string array in bash syntax, with each string element having the format of **"Model number/CSC"** (eg. `TARGET_EXTRA_FIRMWARES=("SM-A528B/BTU" "SM-A528N/KOO")`).

### - **TARGET_API_LEVEL** (int, required)
{: .pb-2 }
Defines the target firmware [Android API level](https://developer.android.com/tools/releases/platforms), this must match the `ro.build.version.sdk` value in `/system/build.prop`.

### - **TARGET_VNDK_VERSION** (int, required)
{: .pb-2 }
Defines the target firmware [VNDK](https://source.android.com/docs/core/architecture/vndk) version, this must match the `ro.vndk.version` value in `/vendor/build.prop` or `/vendor/default.prop`.

### - **TARGET_SINGLE_SYSTEM_IMAGE** (string, required)
{: .pb-2 }
Defines the target device [SSI](https://source.android.com/docs/core/architecture/partitions/shared-system-image) type. Use `qssi` if the target device has a Qualcomm SoC, or `essi` if the target device has an Exynos SoC.

### - **TARGET_OS_FILE_SYSTEM** (string, required)
{: .pb-2 }
Defines the target firmware file system, accepted values are `ext4`, `f2fs` or `erofs`. This can be checked in the target device fstab config file.

### - **TARGET_INSTALL_METHOD** (string, optional)
{: .pb-2 }
Defines whether to generate a flashable zip or a Odin tar package when building the ROM, accepted values are `zip` or `odin`. Defaults to `zip` when unset.

### - **TARGET_BOOT_DEVICE_PATH** (string, optional)
{: .pb-2 }
Defines the target device boot device path. Defaults to `/dev/block/bootdevice/by-name` when unset.

### - **TARGET_SUPER_PARTITION_SIZE** (int, required)
{: .pb-2 }
Defines the target device super partition size, which can be checked via the `lpdump` tool. Notice this is always **bigger** than `TARGET_SUPER_GROUP_SIZE`.

### - **TARGET_SUPER_GROUP_SIZE** (int, required)
{: .pb-2 }
Defines the target device super partition group size, which can be checked via the `lpdump` tool. Notice this is always **smaller** than `TARGET_SUPER_PARTITION_SIZE`.

### - **TARGET_POST_INSTALL_ZIP** (string, optional)
{: .pb-2 }
Allows the flashing an optional zip file along with the generated ROM flashable zip, the zip file must be passed with this flag as a remote URL address.
To use this flag, `TARGET_INSTALL_METHOD` must either be unset or set to `zip` and the target custom recovery must support OpenRecoveryScript.

### - **TARGET_HAS_SYSTEM_EXT** (boolean, required)
{: .pb-2 }
Set this to true if the target device has a separate system_ext partition. You can check this by extracting the `super.img` partition or in the fstab config file.

### - **TARGET_HAS_KNOX_DUALDAR** (boolean, required)
{: .pb-2 }
Set this to true if the target device has [Knox DualDAR](https://docs.samsungknox.com/admin/fundamentals/whitepaper/app-and-data-protection/dualdar-encryption/).
This must match the `KNOX_SUPPORT_DAR_DUAL` value in the `com.samsung.android.rune.CoreRune` class inside `framework.jar`.

### - **TARGET_HAS_KNOX_SDP** (boolean, required)
{: .pb-2 }
Set this to true if the target device has [Knox SDP](https://docs.samsungknox.com/admin/fundamentals/whitepaper/core-platform-security/sensitive-data-protection/).
This must match the `KNOX_SUPPORT_DAR_SDP` value in the `com.samsung.android.rune.CoreRune` class inside `framework.jar`.

### - **TARGET_HAS_MASS_CAMERA_APP** (boolean, required)
{: .pb-2 }
Set this to true if the target device has the low-end version of the stock Samsung Camera app. You can check this in the app manifest under the `SPDE.build.signature` entry (app variant must match `hal3_mass-phone-release`).

### - **TARGET_HAS_OPTICAL_FP_SENSOR** (boolean, required)
{: .pb-2 }
Set this to true if the target device has an optical in-display fingerprint sensor.

### - **TARGET_IS_ESIM_SUPPORTED** (boolean, required)
{: .pb-2 }
Set this to true if the target device supports eSIM.
