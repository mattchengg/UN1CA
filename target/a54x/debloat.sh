# Copyright (c) 2023 Salvo Giangreco
# SPDX-License-Identifier: GPL-3.0-or-later

# Debloat list for Galaxy A54 5G (a54x)
# - Add entries inside the specific partition containing that file (<PARTITION>_DEBLOAT+="")
# - DO NOT add the partition name at the start of any entry (eg. "/system/dpolicy_system")
# - DO NOT add a slash at the start of any entry (eg. "/dpolicy_system")

# GameDriver
SYSTEM_DEBLOAT+="
system/priv-app/DevGPUDriver-EX2200
system/priv-app/GameDriver-EX2200
"

# mAFPC
SYSTEM_DEBLOAT+="
system/bin/mafpc_write
"

# Overlays
SYSTEM_DEBLOAT+="
system/app/WifiRROverlayAppLls
system/app/WifiRROverlayAppWifiLock
"
PRODUCT_DEBLOAT+="
overlay/SoftapOverlayQC
"
