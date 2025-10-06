# [
PUB_KEY_ADDR_EXTRACT() {
    local f="$1"
    [ -r "$f" ] || return 1

    local HEADER=256 AUTH_SZ=12 PK_OFF=64 PK_SIZE=72

    # read 8-byte big-endian integer at offset
    READ_BE64() {
        local OFF=$1
        local HEX
        HEX="$(dd if="$f" bs=1 skip="$OFF" count=8 2> /dev/null | xxd -p -c 8)"
        printf "%d" "0x$HEX"
    }

    local SKP CNT
    SKP="$((HEADER + $(READ_BE64 $AUTH_SZ) + $(READ_BE64 $PK_OFF)))"
    CNT="$(READ_BE64 $PK_SIZE)"

    echo "$SKP $CNT"
}
# ]

VBIMG="$FW_DIR/$(cut -d "/" -f 1 -s <<< "$TARGET_FIRMWARE")_$(cut -d "/" -f 2 -s <<< "$TARGET_FIRMWARE")/avb/vbmeta.img"
AVBINFO="$(avbtool info_image --image "$VBIMG")"
AVBSIZE="$(awk '/Block:/ {sum+=$3} END {print sum}' <<< "$AVBINFO")"
read PK_OFFSET PK_SIZE < <(PUB_KEY_ADDR_EXTRACT "$VBIMG")

sed -i \
    -e "s|VB_SIZE|$AVBSIZE|g" \
    -e "s|PK_OFFSET|$PK_OFFSET|g" \
    -e "s|PK_SIZE|$PK_SIZE|g" \
    "$WORK_DIR/system/system/bin/prophide.sh"

LINES="$(sed -n "/^(allow init init_exec\b/=" "$WORK_DIR/system/system/etc/selinux/plat_sepolicy.cil")"
for l in $LINES; do
    sed -i "${l} s/)))/ execute_no_trans)))/" "$WORK_DIR/system/system/etc/selinux/plat_sepolicy.cil"
done
