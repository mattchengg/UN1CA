#!/bin/bash
#
# Copyright (C) 2023 BlackMesa123
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# shellcheck disable=SC1091

set -e

# [
SRC_DIR="$(git rev-parse --show-toplevel)"
PATCH_DIR="$SRC_DIR/unica/patches"
OUT_DIR="$SRC_DIR/out"
WORK_DIR="$OUT_DIR/work_dir"

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
            sed -i "/$PROP/d" "$FILE"
        fi
    else
        if grep -Fq "$PROP" "$FILE"; then
            echo "Replacing \"$PROP\" prop with \"$VALUE\" in $FILE" | sed "s.$WORK_DIR..g"
            sed -i "$(sed -n "/${PROP}/=" "$FILE") c${PROP}=${VALUE}" "$FILE"
        else
            echo "Adding \"$PROP\" prop with \"$VALUE\" in $FILE" | sed "s.$WORK_DIR..g"
            echo "$PROP=$VALUE" >> "$FILE"
        fi
    fi
}

READ_AND_APPLY_PROP_PATCHES()
{
    for patch in "$PATCH_DIR/props/"*.prop
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
            *)
                return 1
                ;;
        esac

        while read -r i; do
            [[ "$i" = "#"* ]] && continue

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

source "$OUT_DIR/config.sh"
# ]

READ_AND_APPLY_PROP_PATCHES

exit 0