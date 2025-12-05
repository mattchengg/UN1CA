# Replacing Hotword
LOG_STEP_IN "- Replacing Hotword"
blobs=(
priv-app/HotwordEnrollmentXGoogleEx4CORTEXM55
priv-app/HotwordEnrollmentOKGoogleEx4CORTEXM55
)
for blob in ${blobs[@]}; do
    DELETE_FROM_WORK_DIR "product" "$blob"
done
blobs=(
priv-app/HotwordEnrollmentOKGoogleEx4CORTEXM4/HotwordEnrollmentOKGoogleEx4CORTEXM4.apk
priv-app/HotwordEnrollmentXGoogleEx4CORTEXM4/HotwordEnrollmentXGoogleEx4CORTEXM4.apk
)
for blob in ${blobs[@]}; do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "product" "$blob" 0 0 644 "u:object_r:system_file:s0"
done
LOG_STEP_OUT

# Adding stock WFD blobs
LOG_STEP_IN "- Adding stock WFD blobs"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/bin/insthk" 0 2000 755 "u:object_r:insthk_exec:s0"
blobs=(
system/lib64/libhdcp2.so
system/lib64/libhdcp_client_aidl.so
system/lib64/libstagefright_hdcp.so
system/lib64/vendor.samsung.hardware.security.hdcp.wifidisplay-V2-ndk.so
system/lib64/libremotedisplay_wfd.so
system/lib64/libwfds.so
system/lib64/wfd_log.so
)
for blob in ${blobs[@]}; do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done
LOG_STEP_OUT

# Adding stock libhwui
LOG_STEP_IN "- Adding stock libhwui"
blobs=(
system/lib/libhwui.so
system/lib64/libhwui.so
)
for blob in ${blobs[@]}; do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done
LOG_STEP_OUT

# Adding HIDL face biometrics libs
LOG_STEP_IN "- Adding HIDL face biometrics libs"
blobs=(
system/lib64/android.hardware.biometrics.common-V4-ndk.so
system/lib64/android.hardware.biometrics.face@1.0.so
system/lib64/android.hardware.biometrics.face-V4-ndk.so
system/lib64/android.hardware.biometrics.fingerprint@2.1.so
system/lib64/vendor.samsung.hardware.biometrics.face@2.0.so
system/lib64/vendor.samsung.hardware.biometrics.face@3.0.so
system/lib64/vendor.samsung.hardware.biometrics.face-V3-ndk.so
system/lib/android.hardware.biometrics.fingerprint@2.1.so

)
for blob in ${blobs[@]}; do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done
LOG_STEP_OUT

# Adding keymint 4.0 libs
LOG_STEP_IN "- Adding keymint 4.0 libs"
blobs=(
system/lib64/android.hardware.keymaster@3.0.so
system/lib64/android.hardware.keymaster@4.0.so
system/lib64/android.hardware.keymaster@4.1.so
system/lib64/android.hardware.keymaster-V4-ndk.so
system/lib/lib_nativeJni.dk.samsung.so
system/lib64/lib_nativeJni.dk.samsung.so
system/lib64/libkeymaster4_1support.so
system/lib64/libkeymaster4support.so
system/lib64/android.hardware.security.keymint-V2-ndk.so
system/lib64/android.hardware.security.keymint-V4-ndk.so
system/lib64/lib_android_keymaster_keymint_utils.so
system/lib64/libdk_native_keymint.so
system/lib64/libkeymint.so
system/lib64/libkeymint_support.so
system/lib64/vendor.samsung.hardware.keymint-V2-ndk.so
system/lib64/vendor.samsung.hardware.keymint-V4-ndk.so
system/lib/android.hardware.security.keymint-V2-ndk.so
system/lib/libdk_native_keymint.so
system/lib/vendor.samsung.hardware.keymint-V2-ndk.so
)
for blob in ${blobs[@]}; do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done
LOG_STEP_OUT

LOG_STEP_IN "- Adding libs"
blobs=(
system/lib64/android.frameworks.schedulerservice@1.0.so
system/lib64/android.frameworks.sensorservice@1.0.so
system/lib64/android.frameworks.sensorservice-V1-ndk.so
system/lib64/android.frameworks.stats@1.0.so
system/lib64/android.frameworks.stats-V2-ndk.so
system/lib/android.frameworks.schedulerservice@1.0.so
system/lib/android.frameworks.sensorservice@1.0.so
system/lib/android.frameworks.sensorservice-V1-ndk.so
system/lib/android.frameworks.stats@1.0.so
system/lib/android.frameworks.stats-V2-ndk.so
)
for blob in ${blobs[@]}; do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done
LOG_STEP_OUT
# Fixing sound quality
LOG_STEP_IN "- Fixing sound quality"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "vendor" "lib64/soundfx"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "vendor" "lib/soundfx"
blobs=(
system/etc/stage_policy.conf
system/lib/lib_SoundAlive_play_plus_ver800.so
system/lib64/lib_SoundAlive_play_plus_ver800.so
)
for item in ${blobs[@]}; do
    DELETE_FROM_WORK_DIR "system" "$item"
done

ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/stage_policy.conf" 0 0 644 "u:object_r:system_lib_file:s0"
blobs=(
system/lib64/libsamsungSoundbooster_plus_legacy.so
system/lib64/lib_SoundAlive_AlbumArt_ver105.so
system/lib64/lib_SoundAlive_play_plus_ver500.so
system/lib64/lib_SoundAlive_SRC192_ver205a.so
system/lib64/lib_SoundAlive_SRC384_ver320.so
system/lib64/libSoundAlive_VSP_ver316c_ARMCpp.so
system/lib64/lib_SoundBooster_ver1100.so
system/lib/libsamsungSoundbooster_plus_legacy.so
system/lib/lib_SoundAlive_AlbumArt_ver105.so
system/lib/lib_SoundAlive_play_plus_ver500.so
system/lib/lib_SoundAlive_SRC192_ver205a.so
system/lib/lib_SoundAlive_SRC384_ver320.so
system/lib/libSoundAlive_VSP_ver316c_ARMCpp.so
system/lib/lib_SoundBooster_ver1100.so
)
for blob in ${blobs[@]}; do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done
LOG_STEP_OUT
