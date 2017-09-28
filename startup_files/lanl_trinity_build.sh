#!/bin/bash

. /opt/modules/3.2.6.7/init/bash
module unload PrgEnv-pgi PrgEnv-cray PrgEnv-intel
module load PrgEnv-gnu
module unload gcc; module load gcc
export SYSROOT_DIR=/opt/cray/xc-sysroot/default

module load /users/jegsgi/privatemodules/cmake-3.2.2
module list

which cmake

export CC=gcc
export CXX=g++

export BASE_INSTALL_DIR=/users/jegsgi/OSS
export TOOL_VERS="_v2.2.2"
#export TOOL_VERS="_v2.2.2.test"
export MPICH_PATH=/opt/cray/pe/mpt/7.3.1/gni/mpich-gnu/5.1
export ALPS_PATH=/opt/cray/alps/default
export PAPI_PATH=/opt/cray/pe/papi/default


echo "Special Build expat Step ./install-tool --build-expat --krell-root-install-prefix ${BASE_INSTALL_DIR}/compute/expat-2.1.0"
./install-tool --build-expat --krell-root-install-prefix ${BASE_INSTALL_DIR}/compute/expat-2.1.0

# Build root components runtime only
echo "Build root components runtime only"

echo "Step 1 ./install-tool --runtime-only --target-arch cray --target-shared --build-krell-root --krell-root-install-prefix ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-mpich ${MPICH_PATH} --with-papi ${PAPI_PATH} --with-alps ${ALPS_PATH} --with-expat ${BASE_INSTALL_DIR}/compute/expat-2.1.0"

./install-tool --runtime-only --target-arch cray --target-shared --build-krell-root --krell-root-install-prefix ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-mpich ${MPICH_PATH} --with-papi ${PAPI_PATH} --with-alps ${ALPS_PATH} --with-expat ${BASE_INSTALL_DIR}/compute/expat-2.1.0

echo "Step 2 ./install-tool --build-offline --target-shared --target-arch cray --runtime-only --openss-prefix ${BASE_INSTALL_DIR}/ossoffline${TOOL_VERS}/compute --krell-root-install-prefix  ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute  --with-mpich ${MPICH_PATH} --with-papi ${PAPI_PATH}"

./install-tool --build-offline --target-shared --target-arch cray --runtime-only --openss-prefix ${BASE_INSTALL_DIR}/ossoffline${TOOL_VERS}/compute --krell-root-install-prefix  ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute  --with-mpich ${MPICH_PATH} --with-papi ${PAPI_PATH}

echo "Step 3 ./install-tool --build-cbtf-all --runtime-only --target-arch cray --target-shared --cbtf-prefix ${BASE_INSTALL_DIR}/cbtf_all${TOOL_VERS}/compute --krell-root-prefix  ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-mpich ${MPICH_PATH} --with-papi ${PAPI_PATH}"

./install-tool --build-cbtf-all --runtime-only --target-arch cray --target-shared --cbtf-prefix ${BASE_INSTALL_DIR}/cbtf_all${TOOL_VERS}/compute --krell-root-prefix  ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-mpich ${MPICH_PATH} --with-papi ${PAPI_PATH}


# ----------------------------------
# For LOGIN NODE builds
# ----------------------------------

. /opt/modules/3.2.6.7/init/bash
#module unload PrgEnv-pgi craype-interlagos PrgEnv-gnu
#module unload PrgEnv-pgi PrgEnv-cray PrgEnv-intel craype-ivybridge PrgEnv-gnu
module unload PrgEnv-pgi PrgEnv-cray PrgEnv-intel PrgEnv-gnu
module load craype-target-native
module unload gcc
module load gcc
module load /users/jegsgi/privatemodules/cmake-3.2.2

#export SYSROOT_DIR=/opt/cray/xe-sysroot/default
export SYSROOT_DIR=/opt/cray/xc-sysroot/default

echo "Special Build expat Step ./install-tool --build-expat --krell-root-install-prefix ~galarowi/OSS/expat-2.1.0"
./install-tool --build-expat --krell-root-install-prefix ${BASE_INSTALL_DIR}/expat-2.1.0


# Build root components for login nodes
echo "Step 4 ./install-tool --build-krell-root --krell-root-install-prefix ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_PATH} --with-papi ${PAPI_PATH} --with-alps ${ALPS_PATH} --with-expat ${BASE_INSTALL_DIR}/expat-2.1.0 --force-boost-build"

./install-tool --build-krell-root --krell-root-install-prefix ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_PATH} --with-papi ${PAPI_PATH} --with-alps ${ALPS_PATH} --with-expat ${BASE_INSTALL_DIR}/expat-2.1.0 --force-boost-build

# Build offline for login nodes
echo "Step 5 ./install-tool --build-offline --openss-prefix ${BASE_INSTALL_DIR}/ossoffline${TOOL_VERS} --with-runtime-dir ${BASE_INSTALL_DIR}/ossoffline${TOOL_VERS}/compute --krell-root-install-prefix ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_PATH} --with-papi ${PAPI_PATH}"

./install-tool --build-offline --openss-prefix ${BASE_INSTALL_DIR}/ossoffline${TOOL_VERS} --with-runtime-dir ${BASE_INSTALL_DIR}/ossoffline${TOOL_VERS}/compute --krell-root-install-prefix ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_PATH} --with-papi ${PAPI_PATH}


echo "Step 6 ./install-tool --runtime-target-arch cray --build-cbtf-all --cbtf-prefix ${BASE_INSTALL_DIR}/cbtf_all${TOOL_VERS} --krell-root-prefix ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_PATH} --with-cn-boost ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-cn-mrnet ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-cn-xercesc ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-cn-libmonitor ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-cn-libunwind ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-cn-dyninst ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-cn-papi ${PAPI_PATH} --with-cn-cbtf-krell ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-cn-cbtf ${BASE_INSTALL_DIR}/cbtf_all${TOOL_VERS}/compute --with-binutils ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-boost ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-mrnet ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-xercesc ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-libmonitor ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-libunwind ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-papi ${PAPI_PATH} --with-alps ${ALPS_PATH}"

./install-tool --runtime-target-arch cray --build-cbtf-all --cbtf-prefix ${BASE_INSTALL_DIR}/cbtf_all${TOOL_VERS} --krell-root-prefix ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_PATH} --with-cn-boost ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-cn-mrnet ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-cn-xercesc ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-cn-libmonitor ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-cn-libunwind ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-cn-dyninst ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-cn-papi ${PAPI_PATH} --with-cn-cbtf-krell ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/compute --with-cn-cbtf ${BASE_INSTALL_DIR}/cbtf_all${TOOL_VERS}/compute --with-binutils ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-boost ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-mrnet ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-xercesc ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-libmonitor ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-libunwind ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-papi ${PAPI_PATH} --with-alps ${ALPS_PATH}

echo "Step 7 ./install-tool --target-arch cray --build-onlyosscbtf --openss-prefix ${BASE_INSTALL_DIR}/osscbtf${TOOL_VERS} --with-cn-cbtf-krell ${BASE_INSTALL_DIR}/cbtf_all${TOOL_VERS}/compute --krell-root-prefix ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_PATH} --with-boost ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-mrnet ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-xercesc ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-libmonitor ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-libunwind ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-libelf ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-libdwarf ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-binutils ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --cbtf-prefix ${BASE_INSTALL_DIR}/cbtf_all${TOOL_VERS} --with-papi ${PAPI_PATH}"

./install-tool --target-arch cray --build-onlyosscbtf --openss-prefix ${BASE_INSTALL_DIR}/osscbtf${TOOL_VERS} --with-cn-cbtf-krell ${BASE_INSTALL_DIR}/cbtf_all${TOOL_VERS}/compute --krell-root-prefix ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_PATH} --with-boost ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-mrnet ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-xercesc ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-libmonitor ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-libunwind ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-libelf ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-libdwarf ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-binutils ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --cbtf-prefix ${BASE_INSTALL_DIR}/cbtf_all${TOOL_VERS} --with-papi ${PAPI_PATH}

echo "Special final step:  cp /opt/gcc/5.2.0/snos/lib64/libstdc++.so.6 ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/lib64/."

cp /opt/gcc/5.2.0/snos/lib64/libstdc++.so.6 ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS}/lib64/.

