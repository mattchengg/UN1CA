DELETE_FROM_WORK_DIR "vendor" "tee"
mkdir -p "$WORK_DIR/vendor/tee"

if ! grep -q "init_33_0 tee_file" "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"; then
    {
        echo "(allow init_33_0 tee_file (dir (mounton)))"
        echo "(allow priv_app_33_0 tee_file (dir (getattr)))"
        echo "(allow init_33_0 vendor_fw_file (file (mounton)))"
        echo "(allow priv_app_33_0 vendor_fw_file (file (getattr)))"
    } >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
fi
