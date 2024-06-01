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

# UN1CA configuration file
ROM_VERSION="1.1.6"
ROM_VERSION+="-$(git rev-parse --short HEAD)"
ROM_CODENAME="Diamond"

# Source ROM firmware
case "$TARGET_SINGLE_SYSTEM_IMAGE" in
    # Qualcomm
    "qssi")
        # Galaxy S23, S24 Ultra (One UI 6.1)
        SOURCE_FIRMWARE="SM-S911B/EUX/352404911234563"
        SOURCE_EXTRA_FIRMWARES=("SM-S928B/EUX/352623851234560")
        SOURCE_API_LEVEL=34
        SOURCE_VNDK_VERSION=33
        SOURCE_HAS_SYSTEM_EXT=true
        # SEC Product Feature
        SOURCE_FP_SENSOR_CONFIG="google_touch_display_ultrasonic"
        SOURCE_HAS_HW_MDNIE=true
        SOURCE_HAS_MASS_CAMERA_APP=false
        SOURCE_IS_ESIM_SUPPORTED=true
        SOURCE_MDNIE_SUPPORTED_MODES="65303"
        SOURCE_MDNIE_WEAKNESS_SOLUTION_FUNCTION="3"
        SOURCE_MULTI_MIC_MANAGER_VERSION="08020"
        SOURCE_SSRM_CONFIG_NAME="siop_dm1q_sm8550"
        SOURCE_SUPPORT_CUTOUT_PROTECTION="false"
        ;;
    *)
        echo "\"$TARGET_SINGLE_SYSTEM_IMAGE\" is not a valid system image."
        return 1
        ;;
esac

return 0
