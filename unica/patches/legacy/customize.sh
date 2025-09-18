if [[ "$SOURCE_API_LEVEL" == "$TARGET_API_LEVEL" ]]; then
    LOG "\033[0;33m! Nothing to do\033[0m"
    return 0
fi

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
