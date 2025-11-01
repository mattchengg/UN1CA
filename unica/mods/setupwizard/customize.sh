DECODE_APK "system" "system/priv-app/SecSetupWizard_Global/SecSetupWizard_Global.apk"

LOG "- Enable navigation bar type settings step"
SMALI_PATCH "system" "system/priv-app/SecSetupWizard_Global/SecSetupWizard_Global.apk" \
    "smali/S2/f.smali" "replace" \
    "d(Landroid/content/Context;Z)Ljava/util/ArrayList;" \
    "navigationbar_setting" \
    "this_string_does_not_exist" \
    > /dev/null
SMALI_PATCH "system" "system/priv-app/SecSetupWizard_Global/SecSetupWizard_Global.apk" \
    "smali/com/sec/android/app/SecSetupWizard/SecSetupWizardActivity.smali" "replace" \
    "f(Ljava/lang/String;)Z" \
    "navigationbar_setting" \
    "this_string_does_not_exist" \
    > /dev/null

LOG "- Disable Recommended apps step"
EVAL "sed -i \"/omcagent/d\" \"$APKTOOL_DIR/system/priv-app/SecSetupWizard_Global/SecSetupWizard_Global.apk/res/values/arrays.xml\""
