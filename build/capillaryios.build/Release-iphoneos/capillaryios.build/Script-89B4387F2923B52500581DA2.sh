#!/bin/sh
# Copy Bridging Header to include directory.\n# This should be done automatically, but there is a bug in Xcode:\n# https://developer.apple.com/forums/thread/89209

targetDir=${BUILT_PRODUCTS_DIR}/include/${PRODUCT_MODULE_NAME}/
mkdir -p $targetDir
cp ${DERIVED_SOURCES_DIR}/*-Swift.h ${targetDir}


