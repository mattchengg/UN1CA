# Nuke WSM
DELETE_FROM_WORK_DIR "system" "system/etc/public.libraries-wsm.samsung.txt"
DELETE_FROM_WORK_DIR "system" "system/lib/libhal.wsm.samsung.so"
DELETE_FROM_WORK_DIR "system" "system/lib/vendor.samsung.hardware.security.wsm.service-V1-ndk.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libhal.wsm.samsung.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.security.wsm.service-V1-ndk.so"

# Bypass ICD verification
SMALI_PATCH "system" "system/framework/samsungkeystoreutils.jar" \
    "smali/com/samsung/android/security/keystore/AttestParameterSpec.smali" "return" \
    'isVerifiableIntegrity()Z' 'false'
APPLY_PATCH "system" "system/framework/services.jar" \
    "$SRC_DIR/unica/mods/knoxpatch/services.jar/0001-Bypass-ICD-verification.patch"

# Disable SAK in DarManagerService
APPLY_PATCH "system" "system/framework/services.jar" \
    "$SRC_DIR/unica/mods/knoxpatch/services.jar/0002-Disable-SAK-in-DarManagerService.patch"
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/knox/dar/AttestedCertParser.smali" 'remove'
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/knox/dar/IntegrityStatus.smali" 'remove'
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/knox/dar/Asn1Utils.smali" 'remove'
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/knox/dar/AuthResult.smali" 'remove'

# Spoof ROT/IntegrityStatus in Knox Matrix
if [ -f "$WORK_DIR/system/system/priv-app/KmxService/KmxService.apk" ]; then
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali/com/samsung/android/kmxservice/common/util/RootOfTrust.smali" "return" \
        'getVerifiedBootState()I' '0'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali/com/samsung/android/kmxservice/common/util/RootOfTrust.smali" "return" \
        'isDeviceLocked()Z' 'true'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali/com/samsung/android/kmxservice/fabrickeystore/keystore/cert/RootOfTrust.smali" "return" \
        'getVerifiedBootState()I' '0'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali/com/samsung/android/kmxservice/fabrickeystore/keystore/cert/RootOfTrust.smali" "return" \
        'isDeviceLocked()Z' 'true'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali/com/samsung/android/kmxservice/sdk/trustchain/util/RootOfTrust.smali" "return" \
        'getVerifiedBootState()I' '0'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali/com/samsung/android/kmxservice/sdk/trustchain/util/RootOfTrust.smali" "return" \
        'isDeviceLocked()Z' 'true'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali/com/samsung/android/kmxservice/common/util/IntegrityStatus.smali" "return" \
        'getStatus()I' '0'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali/com/samsung/android/kmxservice/fabrickeystore/keystore/cert/IntegrityStatus.smali" "return" \
        'isNormal()Z' 'true'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali/com/samsung/android/kmxservice/sdk/trustchain/util/IntegrityStatus.smali" "return" \
        'getStatus()I' '0'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali/com/samsung/android/kmxservice/sdk/trustchain/util/IntegrityStatus.smali" "return" \
        'isNormal()Z' 'true'
fi
