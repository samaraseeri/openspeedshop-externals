#!/bin/bash

. /opt/modules/default/init/bash

module unload PrgEnv-pgi PrgEnv-cray PrgEnv-intel
module load PrgEnv-gnu
module unload gcc; module load gcc/4.9.3
export SYSROOT_DIR=/opt/cray/xc-sysroot/default

#BASE_IDIR=/p/home/galarowi/OSS
BASE_IDIR=/p/home/app/PET/pkgs/openss
TOOL_VERS="_v2.3.1.beta1"
KROOT_IDIR=${BASE_IDIR}/krellroot${TOOL_VERS}
CBTF_IDIR=${BASE_IDIR}/cbtf${TOOL_VERS}
OSSCBTF_IDIR=${BASE_IDIR}/osscbtf${TOOL_VERS}
OSSOFF_IDIR=${BASE_IDIR}/ossoff${TOOL_VERS}
PAPI_IDIR=/opt/cray/papi/default
MPICH_IDIR=/opt/cray/mpt/7.3.2/gni/mpich-gnu/5.1
ALPS_IDIR=/opt/cray/alps/default

module load /p/home/galarowi/privatemodules/cmake-3.2.2

export cc=gcc
export CC=gcc
export CXX=g++

# Build root components runtime only
echo  Build root components runtime only

echo Step 1 ./install-tool --runtime-only --target-arch cray --target-shared --build-krell-root --krell-root-prefix ${KROOT_IDIR}/compute --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR} --with-alps ${ALPS_IDIR}
./install-tool --runtime-only --target-arch cray --target-shared --build-krell-root --krell-root-prefix ${KROOT_IDIR}/compute --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR} --with-alps ${ALPS_IDIR}

##echo Step 2 ./install-tool --build-offline --target-shared --target-arch cray --runtime-only --openss-prefix ${OSSOFF_IDIR}/compute --krell-root-prefix  ${KROOT_IDIR}/compute  --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR}
##./install-tool --build-offline --target-shared --target-arch cray --runtime-only --openss-prefix ${OSSOFF_IDIR}/compute --krell-root-prefix  ${KROOT_IDIR}/compute  --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR}

./install-tool --build-cbtf-all --runtime-only --target-arch cray --target-shared --cbtf-prefix ${CBTF_IDIR}/compute --krell-root-prefix  ${KROOT_IDIR}/compute --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR}


# ----------------------------------
# For LOGIN NODE builds
# ----------------------------------

module unload PrgEnv-pgi PrgEnv-cray PrgEnv-intel PrgEnv-gnu craype-haswell
module load craype-target-native
module unload gcc
module load gcc/4.9.3
module load /p/home/galarowi/privatemodules/cmake-3.2.2

export SYSROOT_DIR=/opt/cray/xc-sysroot/default

# Build root components for login nodes
echo Step 3 ./install-tool --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR} --with-alps ${ALPS_IDIR}
./install-tool --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR} --with-alps ${ALPS_IDIR}

# Build offline for login nodes
#echo Step 4 ./install-tool --build-offline --openss-prefix ${OSSOFF_IDIR} --with-runtime-dir ${OSSOFF_IDIR}/compute --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR}
#./install-tool --build-offline --openss-prefix ${OSSOFF_IDIR} --with-runtime-dir ${OSSOFF_IDIR}/compute --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR}

./install-tool --runtime-target-arch cray --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-cn-boost ${KROOT_IDIR}/compute --with-cn-mrnet ${KROOT_IDIR}/compute --with-cn-xercesc ${KROOT_IDIR}/compute --with-cn-libmonitor ${KROOT_IDIR}/compute --with-cn-libunwind ${KROOT_IDIR}/compute --with-cn-dyninst ${KROOT_IDIR}/compute --with-cn-papi ${PAPI_IDIR} --with-cn-cbtf-krell ${CBTF_IDIR}/compute --with-cn-cbtf ${CBTF_IDIR}/compute --with-binutils ${KROOT_IDIR} --with-boost ${KROOT_IDIR} --with-mrnet ${KROOT_IDIR} --with-xercesc ${KROOT_IDIR} --with-libmonitor ${KROOT_IDIR} --with-libunwind ${KROOT_IDIR} --with-dyninst ${KROOT_IDIR} --with-papi ${PAPI_IDIR} --with-alps ${ALPS_IDIR}

./install-tool --target-arch cray --build-onlyosscbtf --openss-prefix ${OSSCBTF_IDIR} --with-cn-cbtf-krell ${CBTF_IDIR}/compute --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-boost ${KROOT_IDIR} --with-mrnet ${KROOT_IDIR} --with-xercesc ${KROOT_IDIR} --with-libmonitor ${KROOT_IDIR} --with-libunwind ${KROOT_IDIR} --with-dyninst ${KROOT_IDIR} --with-libelf ${KROOT_IDIR} --with-libdwarf ${KROOT_IDIR} --with-binutils ${KROOT_IDIR} --cbtf-prefix ${CBTF_IDIR} --with-papi ${PAPI_IDIR}

# Compiling with a module loaded non-default installed compiler requires that the libstc++ library be made available on the compute nodes
cp /opt/gcc/4.9.3/snos/lib64/libstdc++.so.6 ${KROOT_IDIR}/lib64/libstdc++.so.6
chmod 755 ${KROOT_IDIR}/lib64/libstdc++.so.6
cp /opt/gcc/4.9.3/snos/lib64/libstdc++.so.6 ${KROOT_IDIR}/compute/lib64/libstdc++.so.6
chmod 755 ${KROOT_IDIR}/compute/lib64/libstdc++.so.6
