DELETE_FROM_WORK_DIR "system" "system/media/audio/notifications"
DELETE_FROM_WORK_DIR "system" "system/media/audio/ringtones"
DELETE_FROM_WORK_DIR "system" "system/media/audio/ui"
ADD_TO_WORK_DIR "pa1qxxx" "system" \
    "system/etc/permissions/privapp-permissions-com.samsung.android.sead.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "pa1qxxx" "system" "system/etc/ringtones_count_list.txt" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "pa1qxxx" "system" \
    "system/hidden/INTERNAL_SDCARD/Music/Samsung/Over_the_Horizon.m4a" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "pa1qxxx" "system" "system/media" 0 0 755 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "pa1qxxx" "system" \
    "system/priv-app/EnvironmentAdaptiveDisplay/EnvironmentAdaptiveDisplay.apk" 0 0 644 "u:object_r:system_file:s0"
