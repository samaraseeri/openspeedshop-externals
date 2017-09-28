#!/bin/bash

. /opt/modules/3.2.10.3/init/bash

module unload PrgEnv-pgi PrgEnv-cray PrgEnv-intel
module load PrgEnv-gnu
module unload gcc; module load gcc/4.9.3
export SYSROOT_DIR=/opt/cray/xc-sysroot/default

export CC=gcc
export CXX=g++

BASE_DIR=/p/app/pet/pkgs/openss
TOOL_VERS="_v2.2.3"
ALPS_ROOT=/opt/cray/alps/5.2.4-2.0502.9774.31.11.ari
MPICH_ROOT=/opt/cray/mpt/7.3.2/gni/mpich-gnu/5.1
PAPI_ROOT=/opt/cray/papi/default
PYTHON_IROOT=${BASE_DIR}/python-2.7.3
PYTHON_VERS=2.7

# Build root components runtime only
echo  "Build root components runtime only"

echo "Step 1 ./install-tool --runtime-only --target-arch cray --target-shared --build-krell-root --krell-root-install-prefix ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-mpich ${MPICH_ROOT} --with-papi ${PAPI_ROOT} --with-alps ${ALPS_ROOT}"

./install-tool --runtime-only --target-arch cray --target-shared --build-krell-root --krell-root-install-prefix ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-mpich ${MPICH_ROOT} --with-papi ${PAPI_ROOT} --with-alps ${ALPS_ROOT}

echo "Step 2 ./install-tool --build-offline --target-shared --target-arch cray --runtime-only --openss-prefix ${BASE_DIR}/ossoff2.2/compute --krell-root-install-prefix  ${BASE_DIR}/krellroot${TOOL_VERS}/compute  --with-mpich ${MPICH_ROOT} --with-papi ${PAPI_ROOT}"

./install-tool --build-offline --target-shared --target-arch cray --runtime-only --openss-prefix ${BASE_DIR}/ossoff${TOOL_VERS}/compute --krell-root-install-prefix  ${BASE_DIR}/krellroot${TOOL_VERS}/compute  --with-mpich ${MPICH_ROOT} --with-papi ${PAPI_ROOT}

echo "Step 3 ./install-tool --build-cbtf-all --runtime-only --target-arch cray --target-shared --cbtf-prefix ${BASE_DIR}/cbtf_all${TOOL_VERS}/compute --krell-root-prefix  ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-mpich ${MPICH_ROOT} --with-papi ${PAPI_ROOT}"

./install-tool --build-cbtf-all --runtime-only --target-arch cray --target-shared --cbtf-prefix ${BASE_DIR}/cbtf_all${TOOL_VERS}/compute --krell-root-prefix  ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-mpich ${MPICH_ROOT} --with-papi ${PAPI_ROOT}


# ----------------------------------
# For LOGIN NODE builds
# ----------------------------------

module unload PrgEnv-pgi PrgEnv-cray PrgEnv-intel PrgEnv-gnu craype-haswell
module load craype-target-native
module unload gcc
module load gcc/4.9.3
export SYSROOT_DIR=/opt/cray/xc-sysroot/default

echo "Special Build expat Step ./install-tool --build-expat --krell-root-install-prefix ${BASE_DIR}/expat-2.1.0"
./install-tool --build-expat --krell-root-install-prefix ${BASE_DIR}/expat-2.1.0 
echo "Special Build python Step ./install-tool --build-expat --krell-root-install-prefix ${BASE_DIR}/expat-2.1.0"
./install-tool --build-python --krell-root-install-prefix ${PYTHON_IROOT}

# Build root components for login nodes
echo "Step 4 ./install-tool --build-krell-root --krell-root-install-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_ROOT} --with-papi ${PAPI_ROOT} --with-alps ${ALPS_ROOT} --with-expat ${BASE_DIR}/expat-2.1.0"
./install-tool --build-krell-root --krell-root-install-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_ROOT} --with-papi ${PAPI_ROOT} --with-alps ${ALPS_ROOT} --with-expat ${BASE_DIR}/expat-2.1.0

# Build offline for login nodes
echo "Step 5 ./install-tool --build-offline --openss-prefix ${BASE_DIR}/ossoff${TOOL_VERS} --with-runtime-dir ${BASE_DIR}/ossoff${TOOL_VERS}/compute --krell-root-install-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_ROOT} --with-papi ${PAPI_ROOT} --with-python ${PYTHON_IROOT} --with-python-vers ${PYTHON_VERS}"
./install-tool --build-offline --openss-prefix ${BASE_DIR}/ossoff${TOOL_VERS} --with-runtime-dir ${BASE_DIR}/ossoff${TOOL_VERS}/compute --krell-root-install-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_ROOT} --with-papi ${PAPI_ROOT} --with-python ${PYTHON_IROOT} --with-python-vers ${PYTHON_VERS}

echo "Step 6 ./install-tool --runtime-target-arch cray --build-cbtf-all --cbtf-prefix ${BASE_DIR}/cbtf_all${TOOL_VERS} --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_ROOT} --with-cn-boost ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-mrnet ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-xercesc ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-libmonitor ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-libunwind ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-dyninst ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-papi ${PAPI_ROOT} --with-cn-cbtf-krell ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-cbtf ${BASE_DIR}/cbtf_all${TOOL_VERS}/compute --with-binutils ${BASE_DIR}/krellroot${TOOL_VERS} --with-boost ${BASE_DIR}/krellroot${TOOL_VERS} --with-mrnet ${BASE_DIR}/krellroot${TOOL_VERS} --with-xercesc ${BASE_DIR}/krellroot${TOOL_VERS} --with-libmonitor ${BASE_DIR}/krellroot${TOOL_VERS} --with-libunwind ${BASE_DIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_DIR}/krellroot${TOOL_VERS} --with-papi ${PAPI_ROOT} --with-alps ${ALPS_ROOT}"

./install-tool --runtime-target-arch cray --build-cbtf-all --cbtf-prefix ${BASE_DIR}/cbtf_all${TOOL_VERS} --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_ROOT} --with-cn-boost ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-mrnet ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-xercesc ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-libmonitor ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-libunwind ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-dyninst ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-papi ${PAPI_ROOT} --with-cn-cbtf-krell ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-cbtf ${BASE_DIR}/cbtf_all${TOOL_VERS}/compute --with-binutils ${BASE_DIR}/krellroot${TOOL_VERS} --with-boost ${BASE_DIR}/krellroot${TOOL_VERS} --with-mrnet ${BASE_DIR}/krellroot${TOOL_VERS} --with-xercesc ${BASE_DIR}/krellroot${TOOL_VERS} --with-libmonitor ${BASE_DIR}/krellroot${TOOL_VERS} --with-libunwind ${BASE_DIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_DIR}/krellroot${TOOL_VERS} --with-papi ${PAPI_ROOT} --with-alps ${ALPS_ROOT}


echo "Step 7 ./install-tool --target-arch cray --build-onlyosscbtf --openss-prefix ${BASE_DIR}/osscbtf${TOOL_VERS} --with-cn-cbtf-krell ${BASE_DIR}/cbtf_all${TOOL_VERS}/compute --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_ROOT} --with-boost ${BASE_DIR}/krellroot${TOOL_VERS} --with-mrnet ${BASE_DIR}/krellroot${TOOL_VERS} --with-xercesc ${BASE_DIR}/krellroot${TOOL_VERS} --with-libmonitor ${BASE_DIR}/krellroot${TOOL_VERS} --with-libunwind ${BASE_DIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_DIR}/krellroot${TOOL_VERS} --with-libelf ${BASE_DIR}/krellroot${TOOL_VERS} --with-libdwarf ${BASE_DIR}/krellroot${TOOL_VERS} --with-binutils ${BASE_DIR}/krellroot${TOOL_VERS} --cbtf-prefix ${BASE_DIR}/cbtf_all${TOOL_VERS} --with-papi ${PAPI_ROOT} --with-python ${PYTHON_IROOT} --with-python-vers ${PYTHON_VERS}"

./install-tool --target-arch cray --build-onlyosscbtf --openss-prefix ${BASE_DIR}/osscbtf${TOOL_VERS} --with-cn-cbtf-krell ${BASE_DIR}/cbtf_all${TOOL_VERS}/compute --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_ROOT} --with-boost ${BASE_DIR}/krellroot${TOOL_VERS} --with-mrnet ${BASE_DIR}/krellroot${TOOL_VERS} --with-xercesc ${BASE_DIR}/krellroot${TOOL_VERS} --with-libmonitor ${BASE_DIR}/krellroot${TOOL_VERS} --with-libunwind ${BASE_DIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_DIR}/krellroot${TOOL_VERS} --with-libelf ${BASE_DIR}/krellroot${TOOL_VERS} --with-libdwarf ${BASE_DIR}/krellroot${TOOL_VERS} --with-binutils ${BASE_DIR}/krellroot${TOOL_VERS} --cbtf-prefix ${BASE_DIR}/cbtf_all${TOOL_VERS} --with-papi ${PAPI_ROOT} --with-python ${PYTHON_IROOT} --with-python-vers ${PYTHON_VERS}

# Compiling with a module loaded non-default installed compiler requires that the libstc++ library be made available on the compute nodes
echo "Special cp libstdc++  Step cp /opt/gcc/4.9.3/snos/lib64/libstdc++.so.6 ${BASE_DIR}/krellroot${TOOL_VERS}/compute/lib64/libstdc++.so.6"
cp /opt/gcc/4.9.3/snos/lib64/libstdc++.so.6 ${BASE_DIR}/krellroot${TOOL_VERS}/compute/lib64/libstdc++.so.6
echo "Special cp libstdc++  Step cp /opt/gcc/4.9.3/snos/lib64/libstdc++.so.6 ${BASE_DIR}/krellroot${TOOL_VERS}/lib64/libstdc++.so.6"
cp /opt/gcc/4.9.3/snos/lib64/libstdc++.so.6 ${BASE_DIR}/krellroot${TOOL_VERS}/lib64/libstdc++.so.6
