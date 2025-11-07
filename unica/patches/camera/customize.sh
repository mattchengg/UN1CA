# [
_LOG() { if $DEBUG; then LOGW "$1"; else ABORT "$1"; fi }

LOG_MISSING_PATCHES()
{
    local MESSAGE="Missing SPF patches for condition ($1: [${!1}], $2: [${!2}])"

    if $DEBUG; then
        LOGW "$MESSAGE"
    else
        ABORT "${MESSAGE}. Aborting"
    fi
}
# ]

DELETE_FROM_WORK_DIR "system" "system/cameradata/portrait_data"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/cameradata/portrait_data" 0 0 755 "u:object_r:system_file:s0"
if [ -f "$SRC_DIR/target/$TARGET_CODENAME/camera/singletake/service-feature.xml" ]; then
    LOG "- Adding /system/system/cameradata/singletake/service-feature.xml"
    EVAL "cp -a \"$SRC_DIR/target/$TARGET_CODENAME/camera/singletake/service-feature.xml\" \"$WORK_DIR/system/system/cameradata/singletake/service-feature.xml\""
else
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" \
        "system" "system/cameradata/singletake/service-feature.xml" 0 0 644 "u:object_r:system_file:s0"
fi
if [ -f "$SRC_DIR/target/$TARGET_CODENAME/camera/aremoji-feature.xml" ]; then
    LOG "- Adding /system/system/cameradata/aremoji-feature.xml"
    EVAL "cp -a \"$SRC_DIR/target/$TARGET_CODENAME/camera/aremoji-feature.xml\" \"$WORK_DIR/system/system/cameradata/aremoji-feature.xml\""
else
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" \
        "system" "system/cameradata/aremoji-feature.xml" 0 0 644 "u:object_r:system_file:s0"
fi
if [ -f "$SRC_DIR/target/$TARGET_CODENAME/camera/camera-feature.xml" ]; then
    LOG "- Adding /system/system/cameradata/camera-feature.xml"
    EVAL "cp -a \"$SRC_DIR/target/$TARGET_CODENAME/camera/camera-feature.xml\" \"$WORK_DIR/system/system/cameradata/camera-feature.xml\""
elif [[ "$SOURCE_PLATFORM_SDK_VERSION" == "$TARGET_PLATFORM_SDK_VERSION" ]]; then
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" \
        "system" "system/cameradata/camera-feature.xml" 0 0 644 "u:object_r:system_file:s0"
else
    _LOG "File not found: $SRC_DIR/target/$TARGET_CODENAME/camera/camera-feature.xml"
fi

LOG_STEP_IN
if grep -q "DURING_SMARTVIEW" "$WORK_DIR/system/system/cameradata/camera-feature.xml" 2> /dev/null; then
    LOG "- Removing Smart View limitations flags"
    EVAL "sed -i \"/DURING_SMARTVIEW/d\" \"$WORK_DIR/system/system/cameradata/camera-feature.xml\""
fi
if grep -q "SUPPORT_LIVE_BLUR" "$WORK_DIR/system/system/cameradata/camera-feature.xml" 2> /dev/null; then
    LOG "- Removing native blur disable flag"
    EVAL "sed -i \"/SUPPORT_LIVE_BLUR/d\" \"$WORK_DIR/system/system/cameradata/camera-feature.xml\""
fi
LOG_STEP_OUT

if ! $SOURCE_CAMERA_SUPPORT_MASS_APP_FLAVOR; then
    if $TARGET_CAMERA_SUPPORT_MASS_APP_FLAVOR; then
        ADD_TO_WORK_DIR "r9qxxx" "system" "system/priv-app/SamsungCamera/SamsungCamera.apk" 0 0 644 "u:object_r:system_file:s0"
        ADD_TO_WORK_DIR "r9qxxx" "system" "system/priv-app/SamsungCamera/SamsungCamera.apk.prof" 0 0 644 "u:object_r:system_file:s0"
    fi
else
    if ! $TARGET_CAMERA_SUPPORT_MASS_APP_FLAVOR; then
        # TODO handle this condition
        LOG_MISSING_PATCHES "SOURCE_CAMERA_SUPPORT_MASS_APP_FLAVOR" "TARGET_CAMERA_SUPPORT_MASS_APP_FLAVOR"
    fi
fi

if [ -f "$WORK_DIR/system/system/app/FunModeSDK/FunModeSDK.apk" ]; then
    if ! grep -q "SHOOTING_MODE_FUN" "$WORK_DIR/system/system/cameradata/camera-feature.xml" 2> /dev/null; then
        DELETE_FROM_WORK_DIR "system" "system/app/FunModeSDK"
    fi
else
    if grep -q "SHOOTING_MODE_FUN" "$WORK_DIR/system/system/cameradata/camera-feature.xml" 2> /dev/null; then
        ADD_TO_WORK_DIR "a73xqxx" "system" "system/app/FunModeSDK" 0 0 755 "u:object_r:system_file:s0"
    fi
fi

unset -f _LOG LOG_MISSING_PATCHES
