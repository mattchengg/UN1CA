SKIPUNZIP=1

SET_PROP()
{
    local PROP="$1"
    local VALUE="$2"
    local FILE="$3"

    if [ ! -f "$FILE" ]; then
        echo "File not found: $FILE"
        return 1
    fi

    if [[ "$2" == "-d" ]] || [[ "$2" == "--delete" ]]; then
        PROP="$(echo -n "$PROP" | sed 's/=//g')"
        if grep -Fq "$PROP" "$FILE"; then
            echo "Deleting \"$PROP\" prop in $FILE" | sed "s.$WORK_DIR..g"
            sed -i "/^$PROP/d" "$FILE"
        fi
    else
        if grep -Fq "$PROP" "$FILE"; then
            echo "Replacing \"$PROP\" prop with \"$VALUE\" in $FILE" | sed "s.$WORK_DIR..g"
            sed -i "$(sed -n "/^${PROP}\b/=" "$FILE") c${PROP}=${VALUE}" "$FILE"
        else
            echo "Adding \"$PROP\" prop with \"$VALUE\" in $FILE" | sed "s.$WORK_DIR..g"
            if ! grep -q "Added by unica" "$FILE"; then
                echo "# Added by unica/patches/apply_props/customize.sh" >> "$FILE"
            fi
            echo "$PROP=$VALUE" >> "$FILE"
        fi
    fi
}

READ_AND_APPLY_PROPS()
{
    for patch in "$1"/*.prop
    do
        PARTITION=$(basename "$patch" | sed 's/.prop//g')
        case "$PARTITION" in
            "odm")
                FILE="$WORK_DIR/odm/etc/build.prop"
                ;;
            "product")
                FILE="$WORK_DIR/product/etc/build.prop"
                ;;
            "system")
                FILE="$WORK_DIR/system/system/build.prop"
                ;;
            "system_ext")
                $TARGET_HAS_SYSTEM_EXT \
                    && FILE="$WORK_DIR/system_ext/etc/build.prop" \
                    || FILE="$WORK_DIR/system/system/system_ext/etc/build.prop"
                ;;
            "vendor")
                FILE="$WORK_DIR/vendor/build.prop"
                ;;
            *)
                continue
                ;;
        esac

        while read -r i; do
            [[ "$i" = "#"* ]] && continue
            [[ -z "$i" ]] && continue

            if [[ "$i" == *"delete" ]] || [[ -z "$(echo -n "$i" | cut -d "=" -f 2)" ]]; then
                SET_PROP "$(echo -n "$i" | cut -d " " -f 1)" --delete \
                    "$FILE"
            elif echo -n "$i" | grep -q "="; then
                SET_PROP "$(echo -n "$i" | cut -d "=" -f 1)" "$(echo -n "$i" | cut -d "=" -f 2)" \
                    "$FILE"
            else
                echo "Malformed string in $patch: \"$i\""
                return 1
            fi
        done < "$patch"
    done
}

READ_AND_APPLY_PROPS "$SRC_DIR/unica/patches/props"

[[ -d "$SRC_DIR/target/$TARGET_CODENAME/patches/props" ]] \
    && READ_AND_APPLY_PROPS "$SRC_DIR/target/$TARGET_CODENAME/patches/props"