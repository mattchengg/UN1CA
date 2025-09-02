# UN1CA floating_feature patch
# - Add deprecated features in the $DEPRECATED variable
# - Use target/$TARGET_CODENAME/sff.sh file to provide custom entries

DEPRECATED="
SEC_FLOATING_FEATURE_AUDIO_CONFIG_FMRADIO_EXTERNAL_DEVICE
SEC_FLOATING_FEATURE_AUDIO_CONFIG_VOLUMEMONITOR_PHASE
SEC_FLOATING_FEATURE_BATTERY_SUPPORT_WIRELESS_TX_5V_TA
SEC_FLOATING_FEATURE_BIXBY_SUPPORT_USERKWD_WAKEUP
SEC_FLOATING_FEATURE_COMMON_CONFIG_DEX_MODE
SEC_FLOATING_FEATURE_COMMON_CONFIG_DUAL_IMS
SEC_FLOATING_FEATURE_COMMON_SUPPORT_CONVENTIONAL_MODE
SEC_FLOATING_FEATURE_COMMON_SUPPORT_D2D_NUMBER_TRANSFER_SEND_ONLY
SEC_FLOATING_FEATURE_COMMON_SUPPORT_DEX_ON_PC
SEC_FLOATING_FEATURE_COMMON_SUPPORT_EMBEDDED_SIM
SEC_FLOATING_FEATURE_COMMON_SUPPORT_EPDG_CROSS_SIM
SEC_FLOATING_FEATURE_COMMON_SUPPORT_KNOX_DESKTOP
SEC_FLOATING_FEATURE_COMMON_SUPPORT_SAFETYCARE
SEC_FLOATING_FEATURE_FMRADIO_CONFIG_COMMON_SUPPORT_HYBRIDSEARCH
SEC_FLOATING_FEATURE_FMRADIO_REMOVE_AF_MENU
SEC_FLOATING_FEATURE_FRAMEWORK_CONFIG_EDGE_QUICKTOOLS_SCREEN_HEIGHT
SEC_FLOATING_FEATURE_FRAMEWORK_SUPPORT_AUTO_ROTATION_OF_SMARTWIDGET
SEC_FLOATING_FEATURE_FRAMEWORK_SUPPORT_EAGLE_EYE
SEC_FLOATING_FEATURE_GALLERY_CONFIG_COLOR_ENGINE_VERSION
SEC_FLOATING_FEATURE_LOCKSCREEN_SUPPORT_VIDEO_PLAY_RANDOM_POSITION
SEC_FLOATING_FEATURE_MMFW_CONFIG_SMART_MIRRORING_PACKAGE_NAME
SEC_FLOATING_FEATURE_MMFW_SUPPORT_AI_UPSCALER
SEC_FLOATING_FEATURE_MMFW_SUPPORT_MTK_SSM_SM_VIDEO
SEC_FLOATING_FEATURE_MMFW_SUPPORT_MUSIC_AUTO_RECOMMENDATION
SEC_FLOATING_FEATURE_SAIV_CONFIG_BEAUTY_FACE
SEC_FLOATING_FEATURE_SECURITY_SUPPORT_STRONGBOX_API
SEC_FLOATING_FEATURE_SETUPWIZARD_CONFIG_VALUES
SEC_FLOATING_FEATURE_SIP_CONFIG_STICKER_CONTENTS
SEC_FLOATING_FEATURE_WEATHER_SUPPORT_DETAIL_CITY_VIEW
SEC_FLOATING_FEATURE_WIFI_SUPPORT_ADPS
SEC_FLOATING_FEATURE_WLAN_SUPPORT_SECURE_WIFI
"

# [
APPLY_TARGET_FEATURE()
{
    local TARGET_FIRMWARE_PATH="$(cut -d "/" -f 1 -s <<< "$TARGET_FIRMWARE")_$(cut -d "/" -f 2 -s <<< "$TARGET_FIRMWARE")"

    local SOURCE_FILE="$WORK_DIR/system/system/etc/floating_feature.xml"
    local TARGET_FILE="$FW_DIR/$TARGET_FIRMWARE_PATH/system/system/etc/floating_feature.xml"

    local FEATURE
    local SOURCE_VALUE
    local TARGET_VALUE

    # Step 1: iterate through work_dir floating_feature.xml
    while IFS= read -r l; do
        [[ "$l" == *"xml"* ]] && continue
        [[ "$l" == *"SecFloatingFeatureSet"* ]] && continue
        [ ! "$l" ] && continue

        if [[ "$l" != "    <SEC_FLOATING_FEATURE_"*"</SEC_FLOATING_FEATURE_"*">" ]]; then
            ABORT "Malformed string in ${SOURCE_FILE//$SRC_DIR\//}: \"$l\""
        fi

        FEATURE="$(awk -F '<|>' '{print $2}' <<< "$l")"

        if ! grep -q -w "$FEATURE" "$TARGET_FILE"; then
            SET_FLOATING_FEATURE_CONFIG "$FEATURE" --delete
        else
            SOURCE_VALUE="$(GET_FLOATING_FEATURE_CONFIG "$SOURCE_FILE" "$FEATURE")"
            TARGET_VALUE="$(GET_FLOATING_FEATURE_CONFIG "$TARGET_FILE" "$FEATURE")"

            if [[ "$SOURCE_VALUE" != "$TARGET_VALUE" ]]; then
                SET_FLOATING_FEATURE_CONFIG "$FEATURE" "$TARGET_VALUE"
            fi
        fi
    done < "$SOURCE_FILE"

    # Step 2: iterate through target floating_feature.xml
    while IFS= read -r l; do
        [[ "$l" == *"xml"* ]] && continue
        [[ "$l" == *"SecFloatingFeatureSet"* ]] && continue
        [ ! "$l" ] && continue

        if [[ "$l" != "    <SEC_FLOATING_FEATURE_"*"</SEC_FLOATING_FEATURE_"*">" ]]; then
            ABORT "Malformed string in ${TARGET_FILE//$SRC_DIR\//}: \"$l\""
        fi

        FEATURE="$(awk -F '<|>' '{print $2}' <<< "$l")"

        if ! grep -q -w "$FEATURE" "$SOURCE_FILE" && ! grep -q "$FEATURE" <<< "$DEPRECATED"; then
            SET_FLOATING_FEATURE_CONFIG "$FEATURE" "$(GET_FLOATING_FEATURE_CONFIG "$TARGET_FILE" "$FEATURE")"
        fi
    done < "$TARGET_FILE"
}

APPLY_CUSTOM_FEATURE()
{
    local FILE="$SRC_DIR/target/$TARGET_CODENAME/sff.sh"

    if [ -f "$FILE" ]; then
        while IFS= read -r l; do
            [[ "$l" == "#"* ]] && continue
            [ ! "$l" ] && continue

            if [[ "$l" == "SEC_FLOATING_FEATURE_"*"="* ]]; then
                if [ ! "$(cut -d "=" -f 2- <<< "$l")" ]; then
                    SET_FLOATING_FEATURE_CONFIG "$(cut -d "=" -f 1 <<< "$l")" --delete
                else
                    SET_FLOATING_FEATURE_CONFIG "$(cut -d "=" -f 1 <<< "$l")" "$(cut -d "=" -f 2- <<< "$l")"
                fi
            else
                ABORT "Malformed string in target/$TARGET_CODENAME/sff.sh: \"$l\""
            fi
        done < "$FILE"
    fi
}
# ]

APPLY_TARGET_FEATURE
APPLY_CUSTOM_FEATURE

# TODO move this somewhere else
# Smart Tutor
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_COMMON_CONFIG_SMARTTUTOR_PACKAGES_PATH" --delete

# TODO move this somewhere else
# Logging
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_CONTEXTSERVICE_ENABLE_SURVEY_MODE" --delete

# TODO move this somewhere else
# BlockchainTZService
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FRAMEWORK_SUPPORT_BLOCKCHAIN_SERVICE" --delete
