#!/bin/sh

VCPKG_ROOT=$1
NINJA_ROOT=$2
CMAKE_ROOT=$3

# Get version numbers
. $(dirname $0)/version_vcpkg.env

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    CMAKE_ARCH="Linux-x86_64"
elif [ "$ARCH" = "aarch64" ]; then
    CMAKE_ARCH="Linux-aarch64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Define download links
NINJA_URI=https://github.com/ninja-build/ninja/archive/refs/tags/${NINJA_VERSION}.tar.gz
VCPKG_URI=https://github.com/microsoft/vcpkg.git
CMAKE_URI=https://github.com/Kitware/CMake/releases/download/${CMAKE_VERSION}/cmake-${CMAKE_VERSION##v}-${CMAKE_ARCH}.sh

download () { 
    uri=$1
    tmp_file=$(basename $uri)

    if [ -z "$uri" ]; then
        echo "install_vcpkg.sh: download(): error: no uri provided"
        exit 1
    fi

    curl -SL $uri --output $tmp_file
    if [ $? -ne 0 ]; then
        echo "install_vcpkg.sh: download(): error: download failed ($uri)"
        exit 1
    fi

    uri_extension="${tmp_file##*.}"
    if [ "$uri_extension" = "gz" ]; then
        tar -xf $tmp_file
        if [ $? -ne 0 ]; then 
            echo "install_vcpkg.sh: download(): error: failed to unpack ($uri)"
            exit 1
        fi

        rm $tmp_file
    fi
}

# Download and build cmake
# For alpine linux, the cmake provided by the system (built for MUSL) is used instead, so the install steps here will be skipped.
if [ "${CMAKE_ROOT}" != "" ]; then
    download ${CMAKE_URI}
    mv cmake*.sh cmake-install.sh
    chmod u+x cmake-install.sh
    mkdir ${CMAKE_ROOT}
    ./cmake-install.sh --skip-license --prefix=${CMAKE_ROOT}
fi

# Download and build ninja
download ${NINJA_URI}
mv ninja* ninja-source
cmake -Hninja-source -Bninja-source/build
cmake --build ninja-source/build
mkdir ${NINJA_ROOT}
mv ninja-source/build/ninja ${NINJA_ROOT}

# Download and build vcpkg
PREVIOUS_DIRECTORY=${PWD}
mkdir -p ${VCPKG_ROOT}
cd ${VCPKG_ROOT}
git clone ${VCPKG_URI} . --branch=${VCPKG_VERSION} --filter=tree:0
cd ${PREVIOUS_DIRECTORY}
${VCPKG_ROOT}/bootstrap-vcpkg.sh -disableMetrics

# Clean up
rm -Rf ninja-source
if [ "${CMAKE_ROOT}" != "" ]; then
    rm -Rf cmake-install.sh
fi
