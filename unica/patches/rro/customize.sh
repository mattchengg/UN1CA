if [ ! -d "$SRC_DIR/target/$TARGET_CODENAME/overlay" ]; then
    LOG "\033[0;33m! Nothing to do\033[0m"
    return 0
fi

SOURCE_PRODUCT_NAME="$(GET_PROP "system" "ro.product.system.name")"
TARGET_PRODUCT_NAME="$(GET_PROP "vendor" "ro.product.vendor.name")"

DECODE_APK "product" "overlay/framework-res__${SOURCE_PRODUCT_NAME}__auto_generated_rro_product.apk"

DELETE_FROM_WORK_DIR "product" "overlay/framework-res__${SOURCE_PRODUCT_NAME}__auto_generated_rro_product.apk"

EVAL "mv -f \"$APKTOOL_DIR/product/overlay/framework-res__${SOURCE_PRODUCT_NAME}__auto_generated_rro_product.apk\" \"$APKTOOL_DIR/product/overlay/framework-res__${TARGET_PRODUCT_NAME}__auto_generated_rro_product.apk\""
EVAL "sed -i \"s/${SOURCE_PRODUCT_NAME}/${TARGET_PRODUCT_NAME}/g\" \"$APKTOOL_DIR/product/overlay/framework-res__${TARGET_PRODUCT_NAME}__auto_generated_rro_product.apk/apktool.yml\""

LOG "- Applying target product overlay"
EVAL "rm -rf \"$APKTOOL_DIR/product/overlay/framework-res__${TARGET_PRODUCT_NAME}__auto_generated_rro_product.apk/res\""
EVAL "cp -a \"$SRC_DIR/target/$TARGET_CODENAME/overlay\" \"$APKTOOL_DIR/product/overlay/framework-res__${TARGET_PRODUCT_NAME}__auto_generated_rro_product.apk/res\""

SET_METADATA "product" "overlay/framework-res__${TARGET_PRODUCT_NAME}__auto_generated_rro_product.apk" 0 0 644 "u:object_r:system_file:s0"

unset SOURCE_PRODUCT_NAME TARGET_PRODUCT_NAME
