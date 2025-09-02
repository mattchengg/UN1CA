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

        if ! grep -q -w "$FEATURE" "$SOURCE_FILE"; then
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
