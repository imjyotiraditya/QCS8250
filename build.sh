#!/usr/bin/env bash

BUILD_ROOT="$PWD"
QSSI_ROOT="${BUILD_ROOT}/LA.QSSI.13.0"
VENDOR_ROOT="${BUILD_ROOT}/LA.VENDOR.13.2.2"

function build_qssi {
    cd "$QSSI_ROOT"

    source build/envsetup.sh
    lunch qssi-userdebug
    ./build.sh dist --qssi_only -j "$(nproc --all)"
}

function prepare_vendor {
    cd "$VENDOR_ROOT"

    source build/envsetup.sh
    lunch kona-userdebug
    ./kernel_platform/build/android/prepare_vendor.sh kona gki
}

function build_target {
    prepare_vendor

    cd "$VENDOR_ROOT"

    source build/envsetup.sh
    lunch kona-userdebug
    ./build.sh dist --target_only -j "$(nproc --all)"
}

function build_super {
    cd "$VENDOR_ROOT"

    python vendor/qcom/opensource/core-utils/build/build_image_standalone.py \
        --image super \
        --qssi_build_path "$QSSI_ROOT" \
        --target_build_path "$VENDOR_ROOT" \
        --merged_build_path "$VENDOR_ROOT" \
        --target_lunch kona \
        --skip_qiifa \
        --no_tmp \
        --output_ota
}

build_target
build_qssi
build_super
