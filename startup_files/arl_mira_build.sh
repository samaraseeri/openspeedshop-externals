#!/bin/bash

# Use new build method that follows the --runtime-only compute node build
# followed by the front-end build referencing the runtime by --with-runtime-dir

./install-tool --build-cmake --krell-root-prefix /projects/BGQtools_esp/oss/cmake-3.2.2
export PATH=/projects/BGQtools_esp/oss/cmake-3.2.2/bin:$PATH

# ----- First build cetus/mira compute node:
#
# Build compute node krellroot only
./install-tool --runtime-only --target-shared --target-arch bgq --build-krell-root --krell-root-prefix /projects/BGQtools_esp/oss/krellroot_v2.3.1.beta1/compute --with-mpich2 /bgsys/drivers/ppcfloor/comm/gcc --force-binutils-build

# Build compute node offline version with krellroot
./install-tool --runtime-only --target-shared --target-arch bgq --build-offline --openss-prefix /projects/BGQtools_esp/oss/ossoff_v2.3.1.beta1/compute --with-mpich2 /bgsys/drivers/ppcfloor/comm/gcc --krell-root-prefix /projects/BGQtools_esp/oss/krellroot_v2.3.1.beta1/compute

# ----- Next build cetus/mira FE node:
#
# Build krellroot only
./install-tool --build-krell-root --krell-root-prefix /projects/BGQtools_esp/oss/krellroot_v2.3.1.beta1 --with-mpich2 /bgsys/drivers/ppcfloor/comm/gcc

# Build offline version of OSS with krellroot
./install-tool --build-offline --openss-prefix /projects/BGQtools_esp/oss/ossoff_v2.3.1.beta1 --krell-root-prefix /projects/BGQtools_esp/oss/krellroot_v2.3.1.beta1 --with-mpich2 /bgsys/drivers/ppcfloor/comm/gcc --with-runtime-dir /projects/BGQtools_esp/oss/ossoff_v2.3.1.beta1/compute



