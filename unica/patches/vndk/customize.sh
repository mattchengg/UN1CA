# [
ADD_TARGET_VNDK_APEX() {
    case "$TARGET_BOARD_API_LEVEL" in
        "30")
            ADD_TO_WORK_DIR "a73xqxx" "system_ext" "apex/com.android.vndk.v30.apex" 0 0 644 "u:object_r:system_file:s0"
            ;;
        "31")
            ADD_TO_WORK_DIR "r0qxxx" "system_ext" "apex/com.android.vndk.v31.apex" 0 0 644 "u:object_r:system_file:s0"
            ;;
        "32")
            ADD_TO_WORK_DIR "b4qxxx" "system_ext" "apex/com.android.vndk.v32.apex" 0 0 644 "u:object_r:system_file:s0"
            ;;
        "33")
            ADD_TO_WORK_DIR "dm3qxxx" "system_ext" "apex/com.android.vndk.v33.apex" 0 0 644 "u:object_r:system_file:s0"
            ;;
        *)
            ABORT "No APEX blob available for VNDK $TARGET_BOARD_API_LEVEL"
            ;;
    esac
}
# ]

if [[ "$SOURCE_BOARD_API_LEVEL" != "$TARGET_BOARD_API_LEVEL" ]]; then
    if $TARGET_OS_BUILD_SYSTEM_EXT_PARTITION; then
        SYS_EXT_DIR="$WORK_DIR/system_ext"
    else
        SYS_EXT_DIR="$WORK_DIR/system/system/system_ext"
    fi

    if [ "$SOURCE_BOARD_API_LEVEL" -gt "34" ] && [ "$TARGET_BOARD_API_LEVEL" -gt "34" ]; then
        :
    elif [ "$SOURCE_BOARD_API_LEVEL" -gt "34" ] && [ "$TARGET_BOARD_API_LEVEL" -le "34" ]; then
        ADD_TARGET_VNDK_APEX
        sed -i '$d' "$SYS_EXT_DIR/etc/vintf/manifest.xml"
        echo "    <vendor-ndk>" >> "$SYS_EXT_DIR/etc/vintf/manifest.xml"
        echo "        <version>$TARGET_BOARD_API_LEVEL</version>" >> "$SYS_EXT_DIR/etc/vintf/manifest.xml"
        echo "    </vendor-ndk>" >> "$SYS_EXT_DIR/etc/vintf/manifest.xml"
        echo "</manifest>" >> "$SYS_EXT_DIR/etc/vintf/manifest.xml"
    elif [ "$SOURCE_BOARD_API_LEVEL" -le "34" ] && [ "$TARGET_BOARD_API_LEVEL" -gt "34" ]; then
        DELETE_FROM_WORK_DIR "system_ext" "apex/com.android.vndk.v$SOURCE_BOARD_API_LEVEL.apex"
        sed -i -e "/vendor-ndk/d" -e "/version>/d" "$SYS_EXT_DIR/etc/vintf/manifest.xml"
    elif [ ! -f "$SYS_EXT_DIR/apex/com.android.vndk.v$TARGET_BOARD_API_LEVEL.apex" ]; then
        DELETE_FROM_WORK_DIR "system_ext" "apex/com.android.vndk.v$SOURCE_BOARD_API_LEVEL.apex"
        ADD_TARGET_VNDK_APEX
        sed -i "s/version>$SOURCE_BOARD_API_LEVEL/version>$TARGET_BOARD_API_LEVEL/g" "$SYS_EXT_DIR/etc/vintf/manifest.xml"
    fi
fi
