TARGET_FIRMWARE_PATH="$(cut -d "/" -f 1 -s <<< "$TARGET_FIRMWARE")_$(cut -d "/" -f 2 -s <<< "$TARGET_FIRMWARE")"

DELETE_FROM_WORK_DIR "system" "system/cameradata"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/cameradata" 0 0 755 "u:object_r:system_file:s0"

if [ -d "$FW_DIR/$TARGET_FIRMWARE_PATH/system/system/etc/saiv" ]; then
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" \
        "system/etc/saiv/image_understanding/db/aic_classifier/aic_classifier_cnn.info" 0 0 644 "u:object_r:system_file:s0"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" \
        "system/etc/saiv/image_understanding/db/aic_detector/aic_detector_cnn.info" 0 0 644 "u:object_r:system_file:s0"
else
    if [ -d "$WORK_DIR/system/system/etc/saiv" ]; then
        DELETE_FROM_WORK_DIR "system" "system/etc/saiv"
    fi
fi

ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/media/bootsamsung.qmg" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/media/bootsamsungloop.qmg" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/media/shutdown.qmg" 0 0 644 "u:object_r:system_file:s0"

DELETE_FROM_WORK_DIR "system" "system/saiv"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/saiv" 0 0 755 "u:object_r:system_file:s0"
DELETE_FROM_WORK_DIR "system" "system/saiv/textrecognition"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "system" "system/saiv/textrecognition" 0 0 755 "u:object_r:system_file:s0"

if [ -f "$FW_DIR/$TARGET_FIRMWARE_PATH/system/system/usr/share/alsa/alsa.conf" ]; then
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/usr/share/alsa/alsa.conf" 0 0 644 "u:object_r:system_file:s0"
else
    if [ -d "$WORK_DIR/system/system/usr/share/alsa" ]; then
        DELETE_FROM_WORK_DIR "system" "system/usr/share/alsa"
    fi
fi

unset TARGET_FIRMWARE_PATH
