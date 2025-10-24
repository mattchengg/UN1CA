SET_PROP "system" "ro.unica.version" "$ROM_VERSION"
SET_PROP "system" "ro.unica.codename" "$ROM_CODENAME"

DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"

# Always show One UI minor version
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes4/com/samsung/android/settings/deviceinfo/softwareinfo/OneUIVersionPreferenceController.smali" "replace" \
    'isDeviceWithMicroVersion()Z' \
    'move-result p0' \
    'const/4 p0, 0x1'

# Show real device model number
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes4/com/samsung/android/settings/deviceinfo/aboutphone/ModelNameGetter.smali" "replace" \
    'getModelName()Ljava/lang/String;' \
    'ro.product.model' \
    'ro.boot.em.model'

# Enable Outdoor mode support
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes4/com/samsung/android/settings/display/controller/SecOutDoorModePreferenceController.smali" "return" \
    'isAvailable()Z' \
    'true'

# Set auto confirm PIN min digits to 4
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/locksettings/LockSettingsService.smali" "replace" \
    'refreshStoredPinLength(I)Z' \
    'const/4 v0, 0x6' \
    'const/4 v0, 0x4'
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/locksettings/SyntheticPasswordManager.smali" "replace" \
    'createLskfBasedProtector(Landroid/service/gatekeeper/IGateKeeperService;Lcom/android/internal/widget/LockscreenCredential;JLcom/android/internal/widget/LockscreenCredential;Lcom/android/server/locksettings/SyntheticPasswordManager$SyntheticPassword;I)J' \
    'const/4 v12, 0x6' \
    'const/4 v12, 0x4'
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali/com/android/settings/password/ChooseLockPassword\$ChooseLockPasswordFragment.smali" "replace" \
    'handleNext$2()V' \
    'const/4 v4, 0x6' \
    'const/4 v4, 0x4'
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali/com/android/settings/password/ChooseLockPassword\$ChooseLockPasswordFragment.smali" "replace" \
    'setAutoPinConfirmOption(IZ)V' \
    'const/4 p2, 0x6' \
    'const/4 p2, 0x4'

# Allow custom Monotype fonts
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes4/com/samsung/android/settings/display/SecDisplayUtils.smali" "return" \
    'isInvalidFont(Landroid/content/Context;Ljava/lang/String;)Z' \
    'false'

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
        EVAL "cp -a \"$MODPATH/SecSettings.apk/${f//\$/\\$}\" \"$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk/${f//\$/\\$}\""
    else
        LOG "- Patching \"$f\" in /system/system/priv-app/SecSettings.apk"
        if [[ "$f" == *"res/values"* ]]; then
            PATCH_INST="/<\/resources>/i"
            CONTENT="$(sed -e "/?xml/d" -e "/resources>/d" "$MODPATH/SecSettings.apk/$f")"
        else
            PATCH_INST="$(head -n 1 "$MODPATH/SecSettings.apk/$f")"
            CONTENT="$(tail -n +2 "$MODPATH/SecSettings.apk/$f")"
        fi
        CONTENT="$(sed -e "s/\"/\\\\\"/g" -e "s/\\$/\\\\$/g" -e "s/ /\\\ /g" <<< "$CONTENT")"
        CONTENT="$(sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' <<< "$CONTENT")"
        EVAL "sed -i \"$PATCH_INST $CONTENT\" \"$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk/$f\""
    fi
done < <(find "$MODPATH/SecSettings.apk" -type f)

# Mark UN1CA Settings fragments as "valid"
LOG "- Patching \"smali_classes2/com/android/settings/core/gateway/SettingsGateway.smali\" in /system/system/priv-app/SecSettings.apk"
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes2/com/android/settings/core/gateway/SettingsGateway.smali" "replace" \
    '<clinit>()V' \
    'filled-new-array/range {v1 .. v159}, [Ljava/lang/String;' \
    '    const-string v160, "io.mesalabs.unica.settings.UnicaSettingsFragment"\n\n    filled-new-array/range {v1 .. v160}, [Ljava/lang/String;' \
    > /dev/null
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes2/com/android/settings/core/gateway/SettingsGateway.smali" "replace" \
    '<clinit>()V' \
    'filled-new-array/range {v1 .. v160}, [Ljava/lang/String;' \
    '    const-string v161, "io.mesalabs.unica.settings.spoof.SpoofSettingsFragment"\n\n    filled-new-array/range {v1 .. v161}, [Ljava/lang/String;' \
    > /dev/null
LOG "- Patching \"smali_classes2/com/android/settings/SettingsActivity.smali\" in /system/system/priv-app/SecSettings.apk"
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes2/com/android/settings/SettingsActivity.smali" "replace" \
    'isValidFragment(Ljava/lang/String;)Z' \
    'const/16 v2, 0x9f' \
    'const/16 v2, 0xa1' \
    > /dev/null

# Add UN1CA Settings SearchIndexDataProvider(s)
LOG "- Patching \"smali/com/android/settingslib/search/SearchIndexableResourcesBase.smali\" in /system/system/priv-app/SecSettings.apk"
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali/com/android/settingslib/search/SearchIndexableResourcesBase.smali" "replace" \
    '<init>()V' \
    'return-void' \
    '    new-instance v0, Lcom/android/settingslib/search/SearchIndexableData;\n\n    return-void' \
    > /dev/null
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali/com/android/settingslib/search/SearchIndexableResourcesBase.smali" "replace" \
    '<init>()V' \
    'return-void' \
    '    const-class v1, Lio/mesalabs/unica/settings/UnicaSettingsFragment;\n\n    return-void' \
    > /dev/null
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali/com/android/settingslib/search/SearchIndexableResourcesBase.smali" "replace" \
    '<init>()V' \
    'return-void' \
    '    sget-object v2, Lio/mesalabs/unica/settings/UnicaSettingsFragment;->SEARCH_INDEX_DATA_PROVIDER:Lcom/android/settings/search/BaseSearchIndexProvider;\n\n    return-void' \
    > /dev/null
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali/com/android/settingslib/search/SearchIndexableResourcesBase.smali" "replace" \
    '<init>()V' \
    'return-void' \
    '    invoke-direct {v0, v1, v2}, Lcom/android/settingslib/search/SearchIndexableData;-><init>(Ljava/lang/Class;Lcom/android/settingslib/search/Indexable$SearchIndexProvider;)V\n\n    return-void' \
    > /dev/null
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali/com/android/settingslib/search/SearchIndexableResourcesBase.smali" "replace" \
    '<init>()V' \
    'return-void' \
    '    invoke-virtual {p0, v0}, Lcom/android/settingslib/search/SearchIndexableResourcesBase;->addIndex(Lcom/android/settingslib/search/SearchIndexableData;)V\n\n    return-void' \
    > /dev/null
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali/com/android/settingslib/search/SearchIndexableResourcesBase.smali" "replace" \
    '<init>()V' \
    'return-void' \
    '    new-instance v0, Lcom/android/settingslib/search/SearchIndexableData;\n\n    return-void' \
    > /dev/null
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali/com/android/settingslib/search/SearchIndexableResourcesBase.smali" "replace" \
    '<init>()V' \
    'return-void' \
    '    const-class v1, Lio/mesalabs/unica/settings/spoof/SpoofSettingsFragment;\n\n    return-void' \
    > /dev/null
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali/com/android/settingslib/search/SearchIndexableResourcesBase.smali" "replace" \
    '<init>()V' \
    'return-void' \
    '    sget-object v2, Lio/mesalabs/unica/settings/spoof/SpoofSettingsFragment;->SEARCH_INDEX_DATA_PROVIDER:Lcom/android/settings/search/BaseSearchIndexProvider;\n\n    return-void' \
    > /dev/null
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali/com/android/settingslib/search/SearchIndexableResourcesBase.smali" "replace" \
    '<init>()V' \
    'return-void' \
    '    invoke-direct {v0, v1, v2}, Lcom/android/settingslib/search/SearchIndexableData;-><init>(Ljava/lang/Class;Lcom/android/settingslib/search/Indexable$SearchIndexProvider;)V\n\n    return-void' \
    > /dev/null
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali/com/android/settingslib/search/SearchIndexableResourcesBase.smali" "replace" \
    '<init>()V' \
    'return-void' \
    '    invoke-virtual {p0, v0}, Lcom/android/settingslib/search/SearchIndexableResourcesBase;->addIndex(Lcom/android/settingslib/search/SearchIndexableData;)V\n\n    return-void' \
    > /dev/null
DECODE_APK "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk"
LOG "- Patching \"smali_classes2/com/samsung/android/settings/intelligence/search/categorizing/TopLevelKeysCollector.smali\" in /system/system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk"
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    "smali_classes2/com/samsung/android/settings/intelligence/search/categorizing/TopLevelKeysCollector.smali" "replace" \
    '<init>(Landroid/content/Context;)V' \
    '.locals 36' \
    '.locals 37' \
    > /dev/null
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    "smali_classes2/com/samsung/android/settings/intelligence/search/categorizing/TopLevelKeysCollector.smali" "replace" \
    '<init>(Landroid/content/Context;)V' \
    'filled-new-array/range {v1 .. v35}, [Ljava/lang/String;' \
    '    const-string v36, "top_level_unica"\n\n    filled-new-array/range {v1 .. v36}, [Ljava/lang/String;' \
    > /dev/null

unset PATCH_INST CONTENT

LOG_STEP_OUT
