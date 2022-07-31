#!/bin/sh

VCPKG_ROOT=$1
NINJA_ROOT=$2
CMAKE_ROOT=$3

. $(dirname $0)/version_vcpkg.env
NINJA_URI=https://github.com/ninja-build/ninja/archive/refs/tags/${NINJA_VERSION}.tar.gz
VCPKG_URI=https://github.com/microsoft/vcpkg/archive/refs/tags/${VCPKG_VERSION}.tar.gz
CMAKE_URI=https://github.com/Kitware/CMake/releases/download/${CMAKE_VERSION}/cmake-${CMAKE_VERSION:1}-Linux-x86_64.sh

checked_download () { 
    sha256=$1
    uri=$2
    tmp_file=$(basename $uri)

    if [ -z "$sha256" ]; then
        echo "install_vcpkg.sh: checked_download(): error: no checksum provided for $uri"
        exit 1
    fi

    if [ -z "$uri" ]; then
        echo "install_vcpkg.sh: checked_download(): error: no uri provided"
        exit 1
    fi

    curl -SL $uri --output $tmp_file
    if [ $? -ne 0 ]; then
        echo "install_vcpkg.sh: checked_download(): error: download failed ($uri)"
        exit 1
    fi

    echo "$sha256  $tmp_file" | sha256sum -c
    if [ $? -ne 0 ]; then
        echo "install_vcpkg.sh: checked_download(): error: checksum mismatch ($uri)"
        echo "install_vcpkg.sh: checked_download(): found `sha256sum $tmp_file | cut -d' ' -f1`, expected $sha256"
        exit 1
    fi

    uri_extension="${tmp_file##*.}"
    if [ "$uri_extension" = "gz" ]; then
        tar -xf $tmp_file
        if [ $? -ne 0 ]; then 
            echo "install_vcpkg.sh: checked_download(): error: failed to unpack ($uri)"
            exit 1
        fi

        rm $tmp_file
    fi
}

# Download and build cmake
# For alpine linux, the cmake provided by the system (built for MUSL) is used instead, so the install steps here will be skipped.
if [ "${CMAKE_ROOT}" != "" ]; then
    checked_download ${CMAKE_DIGEST} ${CMAKE_URI}
    mv cmake*.sh cmake-install.sh
    chmod u+x cmake-install.sh
    mkdir ${CMAKE_ROOT}
    ./cmake-install.sh --skip-license --prefix=${CMAKE_ROOT}
fi

# Download and build ninja
checked_download ${NINJA_DIGEST} ${NINJA_URI}
mv ninja* ninja-source
cmake -Hninja-source -Bninja-source/build
cmake --build ninja-source/build
mkdir ${NINJA_ROOT}
mv ninja-source/build/ninja ${NINJA_ROOT}

# Download and build vcpkg
checked_download ${VCPKG_DIGEST} ${VCPKG_URI}
mv vcpkg* ${VCPKG_ROOT}
${VCPKG_ROOT}/bootstrap-vcpkg.sh -disableMetrics

# Clean up
rm -Rf ninja-source
if [ "${CMAKE_ROOT}" != "" ]; then
    rm -Rf cmake-install.sh
fi
