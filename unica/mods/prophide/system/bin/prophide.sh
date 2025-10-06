#!/system/bin/sh

rezetprop -n ro.boot.flash.locked "1"
rezetprop -n ro.boot.vbmeta.device_state "locked"
rezetprop -n ro.boot.warranty_bit "0"
rezetprop -n ro.boot.verifiedbootstate "green"
rezetprop -n ro.boot.veritymode "enforcing"
[ "$(getprop ro.product.first_api_level)" -ge "33" ] && rezetprop -n ro.product.first_api_level "32"
rezetprop -n ro.vendor.boot.warranty_bit "0"
rezetprop -n sys.oem_unlock_allowed "0"
