if [[ "$SOURCE_API_LEVEL" == "$TARGET_API_LEVEL" ]]; then
    LOG "\033[0;33m! Nothing to do\033[0m"
    return 0
fi

# [
BACKPORT_SF_PROPS()
{
    local FILE="$WORK_DIR/vendor/build.prop"
    [ -f "$WORK_DIR/vendor/default.prop" ] && local FILE="$WORK_DIR/vendor/default.prop"

    if [ ! -f "$FILE" ]; then
        ABORT "File not found: ${FILE//$SRC_DIR\//}"
    fi

    local PROP
    local VALUE

    if [ "$TARGET_API_LEVEL" -lt "34" ]; then
        PROP="ro.surface_flinger.enable_frame_rate_override"
        VALUE="$(test "$TARGET_HFR_MODE" -gt "1" && echo "true" || echo "false")"

        if [ ! "$(GET_PROP "vendor" "$PROP")" ]; then
            LOG "- Adding \"$PROP\" prop with \"$VALUE\" in ${FILE//$WORK_DIR/}"
            EVAL "sed -i \"/persist.sys.usb.config/i $PROP=$VALUE\" \"$FILE\""
        fi
    fi

    if [ "$TARGET_API_LEVEL" -lt "35" ]; then
        PROP="ro.surface_flinger.set_display_power_timer_ms"

        if [ "$(GET_PROP "vendor" "$PROP")" ]; then
            SET_PROP "vendor" "$PROP" --delete
        fi

        PROP="ro.surface_flinger.enable_frame_rate_override"
        [ "$(GET_PROP "vendor" "ro.surface_flinger.set_idle_timer_ms")" ] && \
            PROP="ro.surface_flinger.set_idle_timer_ms"
        VALUE="$(GET_PROP "vendor" "ro.surface_flinger.use_content_detection_for_refresh_rate")"
        [ ! "$VALUE" ] && \
            VALUE="$(test "$TARGET_HFR_MODE" -gt "1" && echo "true" || echo "false")"

        if [[ "$(sed -n "/$PROP/{x;p;d;}; x" "$FILE")" != *"use_content_detection_for_refresh_rate"* ]]; then
            if [ ! "$(GET_PROP "vendor" "ro.surface_flinger.use_content_detection_for_refresh_rate")" ]; then
                LOG "- Adding \"ro.surface_flinger.use_content_detection_for_refresh_rate\" prop with \"$VALUE\" in ${FILE//$WORK_DIR/}"
            else
                EVAL "sed -i \"/use_content_detection_for_refresh_rate/d\" \"$FILE\""
            fi
            EVAL "sed -i \"/$PROP/i ro.surface_flinger.use_content_detection_for_refresh_rate=$VALUE\" \"$FILE\""
        fi

        PROP="debug.sf.show_refresh_rate_overlay_render_rate"
        VALUE="true"
        if [ ! "$(GET_PROP "vendor" "$PROP")" ]; then
            LOG "- Adding \"$PROP\" prop with \"$VALUE\" in ${FILE//$WORK_DIR/}"
            EVAL "sed -i \"/ro.surface_flinger.use_content_detection_for_refresh_rate/i $PROP=$VALUE\" \"$FILE\""
        fi

        PROP="ro.surface_flinger.game_default_frame_rate_override"
        VALUE="60"
        if [ ! "$(GET_PROP "vendor" "$PROP")" ]; then
            LOG "- Adding \"$PROP\" prop with \"$VALUE\" in ${FILE//$WORK_DIR/}"
            EVAL "sed -i \"/debug.sf.show_refresh_rate_overlay_render_rate/a $PROP=$VALUE\" \"$FILE\""
        fi
    fi
}
# ]

# Pre-API 34
# - Add ro.surface_flinger.enable_frame_rate_override if missing
#
# Pre-API 35
# - Place ro.surface_flinger.use_content_detection_for_refresh_rate correctly
# - Add debug.sf.show_refresh_rate_overlay_render_rate if missing
# - Add ro.surface_flinger.game_default_frame_rate_override if missing
BACKPORT_SF_PROPS

# Ensure config_num_physical_slots is configured (pre-API 36)
# https://android.googlesource.com/platform/frameworks/opt/telephony/+/42e37234cee15c9f3fcfac0532110abfc8843b99%5E%21/#F0
if [ "$TARGET_API_LEVEL" -lt "36" ]; then
    if ! grep -q "ro.telephony.sim_slots.count" "$WORK_DIR/vendor/bin/secril_config_svc" && \
            ! grep -q -r "config_num_physical_slots" "$WORK_DIR/vendor/overlay"; then
        {
            echo ""
            echo "on property:ro.vendor.multisim.simslotcount=*"
            echo "    setprop ro.telephony.sim_slots.count \${ro.vendor.multisim.simslotcount}"
        } >> "$WORK_DIR/system/system/etc/init/hw/init.rc"
    fi
fi

# Ensure IMAGE_CODEC_SAMSUNG support (pre-API 35)
if [ "$TARGET_API_LEVEL" -lt "35" ]; then
    if [ "$(GET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_CAMERA_CONFIG_VENDOR_LIB_INFO")" ] && \
            [[ "$(GET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_CAMERA_CONFIG_VENDOR_LIB_INFO")" != *"image_codec.samsung"* ]]; then
        SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_CAMERA_CONFIG_VENDOR_LIB_INFO" \
            "$(GET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_CAMERA_CONFIG_VENDOR_LIB_INFO"),image_codec.samsung.v1"
    fi
fi

unset -f BACKPORT_SF_PROPS
