# Add ImageTagger blobs
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libImageTagger.camera.samsung.so" 0 0 644 "u:object_r:system_lib_file:s0"

# Add arcsoft blobs
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/public.libraries-arcsoft.txt" 0 0 644 "u:object_r:system_file:s0"
blobs=(
lib64/libarcsoft_photoeditor.arcsoft.so
lib64/libbeautyshot.arcsoft.so
lib64/libface_landmark.arcsoft.so
lib64/libFacialAttributeDetection.arcsoft.so
lib64/libfacialrestoration.arcsoft.so
lib64/libFacialStickerEngine.arcsoft.so
lib64/libGalleryDistortionCorrection.arcsoft.so
lib64/libGalleryDistortionDetector.arcsoft.so
lib64/libhigh_dynamic_range.arcsoft.so
lib64/libhumantracking.arcsoft.so
lib64/libimage_enhancement.arcsoft.so
lib64/liblow_light_hdr.arcsoft.so
lib64/libobjectcapture.arcsoft.so
lib64/libobjectcapture_jni.arcsoft.so
lib64/libPortraitDistortionCorrection.arcsoft.so
lib64/libPortraitDistortionCorrectionCali.arcsoft.so
lib64/libveengine.arcsoft.so
lib/libface_landmark.arcsoft.so
)
for lib in ${blobs[@]}; do
    ADD_TO_WORK_DIR $TARGET_FIRMWARE system system/$lib 0 0 644 u:object_r:system_lib_file:s0
done
