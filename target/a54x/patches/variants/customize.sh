DELETE_FROM_WORK_DIR "vendor" "tee"
mkdir -p "$WORK_DIR/vendor/tee"

POLICY_FILE="$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"

read -r -d '' RULES <<'EOF'
(allow init_33_0 tee_file (dir (mounton)))
(allow priv_app_33_0 tee_file (dir (getattr)))
(allow init_33_0 vendor_fw_file (file (mounton)))
(allow priv_app_33_0 vendor_fw_file (file (getattr)))
EOF

if ! grep -q "(allow init_33_0 tee_file (dir (mounton)))" "$POLICY_FILE"; then
    printf "%s\n" "$RULES" >> "$POLICY_FILE"
fi
