#!/bin/bash

# -----------------------------
# First Build the compute node version (root and oss versions if you use the recommended krell externals root build):
# For COMPUTE NODE builds:
# ----------------------------------

. /opt/modules/default/init/bash

module swap PrgEnv-pgi PrgEnv-gnu
export cc=gcc
export CC=gcc
export CXX=g++

# Template values for the install-tool references below
BASE_DIR=/usr/local/usp/PETtools/CE/pkgs/openss
#BASE_DIR=/u/galarowi/OSS
TOOL_VERS="_v2.3.1.beta1"
KROOT_DIR=${BASE_DIR}/krellroot${TOOL_VERS}
OSSOFF_DIR=${BASE_DIR}/ossoff${TOOL_VERS}
OSSCBTF_DIR=${BASE_DIR}/osscbtf${TOOL_VERS}
CBTFALL_DIR=${BASE_DIR}/cbtf${TOOL_VERS}
MPICH2_ROOT=/opt/cray/mpt/7.3.0/gni/mpich-gnu/5.1
PAPI_ROOT=/opt/cray/papi/default
ALPS_ROOT=/opt/cray/alps/default


# Build root components runtime only
echo "./install-tool --runtime-only --target-arch cray --target-shared --build-krell-root --krell-root--prefix ${KROOT_DIR}/compute --with-mpich2 ${MPICH2_ROOT} --with-papi ${PAPI_ROOT} --with-alps ${ALPS_ROOT}"

./install-tool --runtime-only --target-arch cray --target-shared --build-krell-root --krell-root-install-prefix ${KROOT_DIR}/compute --with-mpich2 ${MPICH2_ROOT} --with-papi ${PAPI_ROOT} --with-alps ${ALPS_ROOT} --skip-binutils-build --skip-libdwarf-build --skip-libunwind-build --skip-papi-build --skip-vampirtrace-build --skip-sqlite-build --skip-libmonitor-build --skip-boost-build

# Build offline runtime only
#echo "./install-tool --build-offline --target-shared --target-arch cray --runtime-only --openss-prefix ${OSSOFF_DIR}/compute --krell-root-install-prefix ${KROOT_DIR}/compute --with-mpich2 ${MPICH2_ROOT} --with-papi ${PAPI_ROOT}"

#./install-tool --build-offline --target-shared --target-arch cray --runtime-only --openss-prefix ${OSSOFF_DIR}/compute --krell-root-install-prefix ${KROOT_DIR}/compute --with-mpich2 ${MPICH2_ROOT} --with-papi ${PAPI_ROOT} 

# Build cbtf runtime only
echo "./install-tool --build-cbtf-all --target-shared --target-arch cray --runtime-only --cbtf-prefix ${CBTFALL_DIR}/compute --krell-root-install-prefix ${KROOT_DIR}/compute --with-mpich2 ${MPICH2_ROOT} --with-papi ${PAPI_ROOT}"

./install-tool --build-cbtf-all --target-shared --target-arch cray --runtime-only --cbtf-prefix ${CBTFALL_DIR}/compute --krell-root-install-prefix ${KROOT_DIR}/compute --with-mpich2 ${MPICH2_ROOT} --with-papi ${PAPI_ROOT} 

# -----------------------------
# Next build the login node version (root and oss versions if you use the recommended krell externals root build):
# -----------------------------
# ----------------------------------
# For LOGIN NODE builds
# ----------------------------------

. /opt/modules/default/init/bash
module unload PrgEnv-pgi craype-interlagos PrgEnv-gnu craype-interlagos
module load craype-target-native
module load gcc
export SYSROOT_DIR=/opt/cray/xe-sysroot/default

# Build root components for login nodes
echo "./install-tool --build-krell-root --krell-root-install-prefix ${KROOT_DIR} --with-mpich2 ${MPICH2_ROOT} --with-papi ${PAPI_ROOT} --with-alps ${ALPS_ROOT}"

./install-tool --build-krell-root --krell-root-install-prefix ${KROOT_DIR} --with-mpich2 ${MPICH2_ROOT} --with-papi ${PAPI_ROOT} --with-alps ${ALPS_ROOT} 


# Build offline for login nodes
#echo "./install-tool --build-offline --openss-prefix ${OSSOFF_DIR} --with-runtime-dir ${OSSOFF_DIR}/compute --krell-root-install-prefix ${KROOT_DIR} --with-mpich2 ${MPICH2_ROOT} --with-papi ${PAPI_ROOT}"

#./install-tool --build-offline --openss-prefix ${OSSOFF_DIR} --with-runtime-dir ${OSSOFF_DIR}/compute --krell-root-install-prefix ${KROOT_DIR} --with-mpich2 ${MPICH2_ROOT} --with-papi ${PAPI_ROOT}

# Build cbtf and openss for login nodes
echo "./install-tool --runtime-target-arch cray --build-cbtf-all --cbtf-prefix ${CBTFALL_DIR} --krell-root-prefix ${KROOT_DIR} --with-mpich2 ${MPICH2_ROOT} --with-cn-boost ${KROOT_DIR}/compute --with-cn-mrnet ${KROOT_DIR}/compute --with-cn-xercesc ${KROOT_DIR}/compute --with-cn-libmonitor ${KROOT_DIR}/compute --with-cn-libunwind ${KROOT_DIR}/compute --with-cn-dyninst ${KROOT_DIR}/compute --with-cn-papi ${PAPI_ROOT} --with-cn-cbtf-krell ${CBTFALL_DIR}/compute --with-cn-cbtf ${CBTFALL_DIR}/compute --with-binutils ${KROOT_DIR} --with-boost ${KROOT_DIR} --with-mrnet ${KROOT_DIR} --with-xercesc ${KROOT_DIR} --with-libmonitor ${KROOT_DIR} --with-libunwind ${KROOT_DIR} --with-dyninst ${KROOT_DIR} --with-papi ${PAPI_ROOT} --with-alps ${ALPS_ROOT}"

./install-tool --runtime-target-arch cray --build-cbtf-all --cbtf-prefix ${CBTFALL_DIR} --krell-root-prefix ${KROOT_DIR} --with-mpich2 ${MPICH2_ROOT} --with-cn-boost ${KROOT_DIR}/compute --with-cn-mrnet ${KROOT_DIR}/compute --with-cn-xercesc ${KROOT_DIR}/compute --with-cn-libmonitor ${KROOT_DIR}/compute --with-cn-libunwind ${KROOT_DIR}/compute --with-cn-dyninst ${KROOT_DIR}/compute --with-cn-papi ${PAPI_ROOT} --with-cn-cbtf-krell ${CBTFALL_DIR}/compute --with-cn-cbtf ${CBTFALL_DIR}/compute --with-binutils ${KROOT_DIR} --with-boost ${KROOT_DIR} --with-mrnet ${KROOT_DIR} --with-xercesc ${KROOT_DIR} --with-libmonitor ${KROOT_DIR} --with-libunwind ${KROOT_DIR} --with-dyninst ${KROOT_DIR} --with-papi ${PAPI_ROOT} --with-alps ${ALPS_ROOT}

echo "./install-tool --target-arch cray --build-onlyosscbtf --openss-prefix ${OSSCBTF_DIR} --with-cn-cbtf-krell ${CBTFALL_DIR}/compute --krell-root-prefix ${KROOT_DIR} --with-mpich2 ${MPICH2_ROOT} --with-papi ${PAPI_ROOT} --with-boost ${KROOT_DIR} --with-mrnet ${KROOT_DIR} --with-xercesc ${KROOT_DIR} --with-libmonitor ${KROOT_DIR} --with-libunwind ${KROOT_DIR} --with-dyninst ${KROOT_DIR} --with-libelf ${KROOT_DIR} --with-libdwarf ${KROOT_DIR} --with-binutils ${KROOT_DIR} --cbtf-prefix ${CBTFALL_DIR}"

./install-tool --target-arch cray --build-onlyosscbtf --openss-prefix ${OSSCBTF_DIR} --with-cn-cbtf-krell ${CBTFALL_DIR}/compute --krell-root-prefix ${KROOT_DIR} --with-mpich2 ${MPICH2_ROOT} --with-papi ${PAPI_ROOT} --with-boost ${KROOT_DIR} --with-mrnet ${KROOT_DIR} --with-xercesc ${KROOT_DIR} --with-libmonitor ${KROOT_DIR} --with-libunwind ${KROOT_DIR} --with-dyninst ${KROOT_DIR} --with-libelf ${KROOT_DIR} --with-libdwarf ${KROOT_DIR} --with-binutils ${KROOT_DIR} --cbtf-prefix ${CBTFALL_DIR} 


cp /opt/gcc/4.9.2/snos/lib64/libstdc++.so.6 ${KROOT_DIR}/compute/lib64/libstdc++.so.6
chmod 755 ${KROOT_DIR}/compute/lib64/libstdc++.so.6
cp /opt/gcc/4.9.2/snos/lib64/libstdc++.so.6 ${KROOT_DIR}/lib64/libstdc++.so.6
chmod 755 ${KROOT_DIR}/lib64/libstdc++.so.6

