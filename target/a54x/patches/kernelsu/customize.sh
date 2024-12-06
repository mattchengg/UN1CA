SKIPUNZIP=1

# [
KERNELSU_TAR="https://downloads.mesalabs.io/s/cQ5WrKZwfFa8Ga2/download/KSU-v0.7.6-20240119-a54xnsxx-BWK4.tar.md5"
KERNELSU_MANAGER_APK="https://github.com/tiann/KernelSU/releases/download/v0.7.6/KernelSU_v0.7.6_11458-release.apk"

REPLACE_KERNEL_BINARIES()
{
    [ -d "$TMP_DIR" ] && rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"

    echo "Downloading $(basename "$KERNELSU_TAR")"
    curl -L -s -o "$TMP_DIR/ksu.tar" "$KERNELSU_TAR"

    echo "Extracting boot.img"
    rm -f "$WORK_DIR/kernel/boot.img"
    tar -xf "$TMP_DIR/ksu.tar" -C "$WORK_DIR/kernel" "boot.img.lz4"
    lz4 -d -q --rm "$WORK_DIR/kernel/boot.img.lz4" "$WORK_DIR/kernel/boot.img"

    rm -rf "$TMP_DIR"
}

ADD_MANAGER_APK_TO_PRELOAD()
{
    # https://github.com/tiann/KernelSU/issues/886
    local APK_PATH="system/preload/KernelSU/me.weishu.kernelsu-mesa==/base.apk"

    echo "Adding KernelSU.apk to preload apps"
    mkdir -p "$WORK_DIR/system/$(dirname "$APK_PATH")"
    curl -L -s -o "$WORK_DIR/system/$APK_PATH" -z "$WORK_DIR/system/$APK_PATH" "$KERNELSU_MANAGER_APK"

    sed -i "/system\/preload/d" "$WORK_DIR/configs/fs_config-system" \
        && sed -i "/system\/preload/d" "$WORK_DIR/configs/file_context-system"
    while read -r i; do
        FILE="$(echo -n "$i"| sed "s.$WORK_DIR/system/..")"
        [ -d "$i" ] && echo "$FILE 0 0 755 capabilities=0x0" >> "$WORK_DIR/configs/fs_config-system"
        [ -f "$i" ] && echo "$FILE 0 0 644 capabilities=0x0" >> "$WORK_DIR/configs/fs_config-system"
        FILE="$(echo -n "$FILE" | sed 's/\./\\./g')"
        echo "/$FILE u:object_r:system_file:s0" >> "$WORK_DIR/configs/file_context-system"
    done <<< "$(find "$WORK_DIR/system/system/preload")"

    rm -f "$WORK_DIR/system/system/etc/vpl_apks_count_list.txt"
    while read -r i; do
        FILE="$(echo "$i" | sed "s.$WORK_DIR/system..")"
        echo "$FILE" >> "$WORK_DIR/system/system/etc/vpl_apks_count_list.txt"
    done <<< "$(find "$WORK_DIR/system/system/preload" -name "*.apk" | sort)"
}
# ]

REPLACE_KERNEL_BINARIES
ADD_MANAGER_APK_TO_PRELOAD
