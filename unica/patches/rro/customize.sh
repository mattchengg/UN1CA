SOURCE_PRODUCT_NAME="$(GET_PROP "system" "ro.product.system.name")"
TARGET_PRODUCT_NAME="$(GET_PROP "vendor" "ro.product.vendor.name")"

if [ ! -d "$SRC_DIR/target/$TARGET_CODENAME/overlay" ]; then
    if [[ "$SOURCE_PRODUCT_NAME" == "$TARGET_PRODUCT_NAME" ]] || $DEBUG; then
        LOG "\033[0;33m! Nothing to do\033[0m"
        return 0
    else
        LOGE "Folder not found: target/$TARGET_CODENAME/overlay"
        unset SOURCE_PRODUCT_NAME TARGET_PRODUCT_NAME
        ABORT
    fi
fi

_LOG() { if $DEBUG; then LOGW "$1"; else ABORT "$1"; fi }

DECODE_APK "product" "overlay/framework-res__${SOURCE_PRODUCT_NAME}__auto_generated_rro_product.apk"

DELETE_FROM_WORK_DIR "product" "overlay/framework-res__${SOURCE_PRODUCT_NAME}__auto_generated_rro_product.apk"

EVAL "mv -f \"$APKTOOL_DIR/product/overlay/framework-res__${SOURCE_PRODUCT_NAME}__auto_generated_rro_product.apk\" \"$APKTOOL_DIR/product/overlay/framework-res__${TARGET_PRODUCT_NAME}__auto_generated_rro_product.apk\""
EVAL "sed -i \"s/${SOURCE_PRODUCT_NAME}/${TARGET_PRODUCT_NAME}/g\" \"$APKTOOL_DIR/product/overlay/framework-res__${TARGET_PRODUCT_NAME}__auto_generated_rro_product.apk/apktool.yml\""

LOG_STEP_IN "- Applying target product overlay"

EVAL "rm -rf \"$APKTOOL_DIR/product/overlay/framework-res__${TARGET_PRODUCT_NAME}__auto_generated_rro_product.apk/res\""
EVAL "cp -a \"$SRC_DIR/target/$TARGET_CODENAME/overlay\" \"$APKTOOL_DIR/product/overlay/framework-res__${TARGET_PRODUCT_NAME}__auto_generated_rro_product.apk/res\""

if [ "$(GET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_LCD_SUPPORT_EXTRA_BRIGHTNESS")" ] && \
        ! grep -q -w "config_Extra_Brightness_Display_Solution_Brightness_Value" "$SRC_DIR/target/$TARGET_CODENAME/overlay/values/arrays.xml" 2> /dev/null; then
    _LOG "SEC_FLOATING_FEATURE_LCD_SUPPORT_EXTRA_BRIGHTNESS is set but \"config_Extra_Brightness_Display_Solution_Brightness_Value\" is missing in arrays.xml"
fi

if [[ "$(GET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FRAMEWORK_CONFIG_AOD_ITEM")" =~ "activeclock|clocktransition" ]] && \
        ! grep -q -w "physical_power_button_center_screen_location_y" "$SRC_DIR/target/$TARGET_CODENAME/overlay/values/dimens.xml" 2> /dev/null; then
    _LOG "AOD Clock Transition is enabled but \"physical_power_button_center_screen_location_y\" is missing in dimens.xml"
fi

LOG_STEP_OUT

SET_METADATA "product" "overlay/framework-res__${TARGET_PRODUCT_NAME}__auto_generated_rro_product.apk" 0 0 644 "u:object_r:system_file:s0"

unset SOURCE_PRODUCT_NAME TARGET_PRODUCT_NAME
unset -f _LOG
