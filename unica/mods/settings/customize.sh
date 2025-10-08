SET_PROP "system" "ro.unica.version" "$ROM_VERSION"
SET_PROP "system" "ro.unica.codename" "$ROM_CODENAME"

DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"

LOG_STEP_IN "- Adding UN1CA Settings"

# Dynamically patch SecSettings
# - Add missing files in place
# - Patch existing files
#   - Use the first line of the file to tell sed how to apply the rest of the content
#   - Exception made for files under *res/values* where the "resources" tag gets nuked
while IFS= read -r f; do
    f="${f/$SRC_DIR\/unica\/mods\/settings\/SecSettings.apk\//}"

    if [ ! -f "$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk/$f" ]; then
        LOG "- Adding \"$f\" to /system/system/priv-app/SecSettings.apk"
        EVAL "mkdir -p \"$(dirname "$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk/$f")\""
        EVAL "cp -a \"$SRC_DIR/unica/mods/settings/SecSettings.apk/${f//\$/\\$}\" \"$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk/${f//\$/\\$}\""
    else
        LOG "- Patching \"$f\" in /system/system/priv-app/SecSettings.apk"
        if [[ "$f" == *"res/values"* ]]; then
            PATCH_INST="/<\/resources>/i"
            CONTENT="$(sed -e "/?xml/d" -e "/resources>/d" "$SRC_DIR/unica/mods/settings/SecSettings.apk/$f")"
        else
            PATCH_INST="$(head -n 1 "$SRC_DIR/unica/mods/settings/SecSettings.apk/$f")"
            CONTENT="$(tail -n +2 "$SRC_DIR/unica/mods/settings/SecSettings.apk/$f")"
        fi
        CONTENT="$(sed "s/\"/\\\\\"/g" <<< "$CONTENT")"
        CONTENT="$(sed "s/ /\\\ /g" <<< "$CONTENT")"
        CONTENT="$(sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' <<< "$CONTENT")"
        EVAL "sed -i \"$PATCH_INST $CONTENT\" \"$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk/$f\""
    fi
done < <(find "$SRC_DIR/unica/mods/settings/SecSettings.apk" -type f)

# Mark UnicaSettingsFragment as "valid"
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes2/com/android/settings/core/gateway/SettingsGateway.smali" "replace" \
    '<clinit>()V' \
    'filled-new-array/range {v1 .. v159}, [Ljava/lang/String;' \
    '    const-string v160, "io.mesalabs.unica.settings.UnicaSettingsFragment"\n\n    filled-new-array/range {v1 .. v160}, [Ljava/lang/String;' \
    > /dev/null
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes2/com/android/settings/SettingsActivity.smali" "replace" \
    'isValidFragment(Ljava/lang/String;)Z' \
    'const/16 v2, 0x9f' \
    'const/16 v2, 0xa0' \
    > /dev/null

unset PATCH_INST CONTENT

LOG_STEP_OUT
