# [
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
