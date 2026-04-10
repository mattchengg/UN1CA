# https://github.com/TBM13/Samsung-Camera-Experiments/blob/master/patch_s5e.py

HEX_PATCH "$WORK_DIR/vendor/lib64/hw/camera.s5e8835.so" \
    "940000000028008052291c007201" "940000000013000014291c007201"

HEX_PATCH "$WORK_DIR/vendor/lib64/hw/camera.s5e8835.so" \
    "d600000000ff8301d1fd7b02a9fd830091f85f03a9f65704a9f44f05a957d03bd5d6" "d6000000001f7d00a91f0900f9c0035fd66100805228008052ecffff1757d03bd5d6"
