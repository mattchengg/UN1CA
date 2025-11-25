LOG_STEP_IN "- Replacing Hotword"
DELETE_FROM_WORK_DIR "product" "priv-app/HotwordEnrollmentXGoogleEx4CORTEXM55"
DELETE_FROM_WORK_DIR "product" "priv-app/HotwordEnrollmentOKGoogleEx4CORTEXM55"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "product" "priv-app/HotwordEnrollmentOKGoogleEx4CORTEXM4/HotwordEnrollmentOKGoogleEx4CORTEXM4.apk" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "product" "priv-app/HotwordEnrollmentXGoogleEx4CORTEXM4/HotwordEnrollmentXGoogleEx4CORTEXM4.apk" 0 0 644 "u:object_r:system_file:s0"

LOG_STEP_IN "- Fixing sound quality"

DELETE_FROM_WORK_DIR "system" "system/etc/stage_policy.conf"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/stage_policy.conf" 0 0 644 "u:object_r:system_file:s0"

DELETE_FROM_WORK_DIR "system" "system/lib/lib_SoundAlive_play_plus_ver800.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/lib_SoundAlive_play_plus_ver800.so"

ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/lib_SoundAlive_AlbumArt_ver105.so" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/lib_SoundAlive_AlbumArt_ver105.so" 0 0 644 "u:object_r:system_file:s0"

ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/lib_SoundAlive_SRC192_ver205a.so" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/lib_SoundAlive_SRC192_ver205a.so" 0 0 644 "u:object_r:system_file:s0"

ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/lib_SoundAlive_SRC384_ver320.so" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/lib_SoundAlive_SRC384_ver320.so" 0 0 644 "u:object_r:system_file:s0"

ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/lib_SoundAlive_play_plus_ver500.so" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/lib_SoundAlive_play_plus_ver500.so" 0 0 644 "u:object_r:system_file:s0"

ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/lib_SoundBooster_ver1100.so" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/lib_SoundBooster_ver1100.so" 0 0 644 "u:object_r:system_file:s0"

ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/lib_soundaliveresampler.so" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/lib_soundaliveresampler.so" 0 0 644 "u:object_r:system_file:s0"

LOG_STEP_OUT