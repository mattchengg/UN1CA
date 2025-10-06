VBIMG="$FW_DIR/$(cut -d "/" -f 1 -s <<< "$TARGET_FIRMWARE")_$(cut -d "/" -f 2 -s <<< "$TARGET_FIRMWARE")/avb/vbmeta.img"
AVBINFO="$(avbtool info_image --image "$VBIMG")"
AVBSIZE="$(awk '/Block:/ {sum+=$3} END {print sum}' <<< "$AVBINFO")"

sed -i "s|VB_SIZE|$AVBSIZE|g" "$WORK_DIR/system/system/bin/prophide.sh"

LINES="$(sed -n "/^(allow init init_exec\b/=" "$WORK_DIR/system/system/etc/selinux/plat_sepolicy.cil")"
for l in $LINES; do
    sed -i "${l} s/)))/ execute_no_trans)))/" "$WORK_DIR/system/system/etc/selinux/plat_sepolicy.cil"
done
