if ! $SOURCE_CAMERA_SUPPORT_MASS_APP_FLAVOR; then
    if $TARGET_CAMERA_SUPPORT_MASS_APP_FLAVOR; then
        DELETE_FROM_WORK_DIR "system" "system/priv-app/SamsungCamera/oat"
        DELETE_FROM_WORK_DIR "system" "system/priv-app/SamsungCamera/SamsungCamera.apk.prof"
        ADD_TO_WORK_DIR "a73xqxx" "system" "system/app/FunModeSDK/FunModeSDK.apk" 0 0 644 "u:object_r:system_file:s0"
        ADD_TO_WORK_DIR "r11sxxx" "system" "system/priv-app/SamsungCamera/SamsungCamera.apk" 0 0 644 "u:object_r:system_file:s0"
    else
        echo "TARGET_CAMERA_SUPPORT_MASS_APP_FLAVOR is not set. Ignoring"
    fi
else
    echo "SOURCE_CAMERA_SUPPORT_MASS_APP_FLAVOR is set. Ignoring"
fi
