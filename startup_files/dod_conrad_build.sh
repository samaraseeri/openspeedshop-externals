#!/bin/bash 

# -----------------------------
# First Build the compute node version (root and oss versions if you use the recommended krell externals root build):
# For COMPUTE NODE builds:
# ----------------------------------

. /opt/modules/default/init/bash

module unload PrgEnv-cray PrgEnv-gnu craype-haswell
module load craype-target-native
#module load gcc/4.9.3
module unload gcc/4.8.2
module unload gcc/5.3.0
module load gcc/4.9.3

export BASE_IDIR=/p/home/app/PET/pkgs/openss
export CMAKE_IDIR=${BASE_IDIR}/cmake-3.2.2

#./install-tool --build-cmake --krell-root-prefix ${CMAKE_IDIR}
export PATH={CMAKE_IDIR}/bin:$PATH

module unload PrgEnv-cray PrgEnv-pgi PrgEnv-gnu PrgEnv-intel
#module load PrgEnv-gnu gcc/4.9.3
module unload gcc
module unload gcc/5.3.0
module unload gcc/4.8.2
module load gcc/4.9.3
module load PrgEnv-gnu
module unload craype-target-native
module load craype-haswell

export CC=gcc
export CXX=g++
export TOOL_VERS="_v2.3.1.rc6"
export ROOT_VERS="_v2.3.1.rc6"
export CMAKE_IDIR=${BASE_IDIR}/cmake-3.2.2
export PATH=${CMAKE_IDIR}/bin:$PATH
export MPICH_IDIR=/opt/cray/mpt/7.3.2/gni/mpich-gnu/5.1  
export PAPI_IDIR=/opt/cray/papi/5.5.1.1
export BINUTILS_IDIR=/opt/cray/xc-sysroot/default/usr
export KROOT_IDIR=${BASE_IDIR}/krellroot${ROOT_VERS}
export CBTF_IDIR=${BASE_IDIR}/cbtf${TOOL_VERS}
export OSSCBTF_IDIR=${BASE_IDIR}/osscbtf${TOOL_VERS}
export OSSOFF_IDIR=${BASE_IDIR}/ossoff${TOOL_VERS}
export ALPS_IDIR=/opt/cray/alps/5.2.1-2.0502.9041.11.6.ari
export CUDA_IDIR=/opt/nvidia/cudatoolkit6.5/6.5.14-1.0502.9613.6.1
export CUPTI_IDIR=/opt/nvidia/cudatoolkit6.5/6.5.14-1.0502.9613.6.1/extras/CUPTI


./install-tool --runtime-only --target-arch cray --target-shared --build-krell-root --krell-root-prefix ${KROOT_IDIR}/compute --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR} --with-binutils ${BINUTILS_IDIR} --with-alps ${ALPS_IDIR}

#./install-tool --runtime-only --target-arch cray --target-shared --build-offline --openss-prefix ${OSSOFF_IDIR}/compute --krell-root-prefix ${KROOT_IDIR}/compute --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR} --with-binutils ${BINUTILS_IDIR}

./install-tool --build-cbtf-all --runtime-only --target-arch cray --target-shared --cbtf-prefix ${CBTF_IDIR}/compute --krell-root-prefix  ${KROOT_IDIR}/compute --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR} --with-alps ${ALPS_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR}

# -----------------------------
# Next build the login node version (root and oss versions if you use the recommended krell externals root build):
# For LOGIN NODE builds:
# ----------------------------------

module unload PrgEnv-cray PrgEnv-gnu craype-haswell
module load craype-target-native
#module load gcc/4.9.3
module unload gcc
module unload gcc/5.3.0
module unload gcc/4.8.2
module load gcc/4.9.3
#export PATH={CMAKE_IDIR}/bin:$PATH
export CC=gcc
export CXX=g++

./install-tool --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR} --force-binutils-build --with-alps ${ALPS_IDIR}

./install-tool --runtime-target-arch cray --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-cn-boost ${KROOT_IDIR}/compute --with-cn-mrnet ${KROOT_IDIR}/compute --with-cn-xercesc ${KROOT_IDIR}/compute --with-cn-libmonitor ${KROOT_IDIR}/compute --with-cn-libunwind ${KROOT_IDIR}/compute --with-cn-dyninst ${KROOT_IDIR}/compute --with-cn-papi ${PAPI_IDIR} --with-cn-cbtf-krell ${CBTF_IDIR}/compute --with-cn-cbtf ${CBTF_IDIR}/compute --with-binutils ${KROOT_IDIR} --with-boost ${KROOT_IDIR} --with-mrnet ${KROOT_IDIR} --with-xercesc ${KROOT_IDIR} --with-libmonitor ${KROOT_IDIR} --with-libunwind ${KROOT_IDIR} --with-dyninst ${KROOT_IDIR} --with-papi ${PAPI_IDIR} --with-alps ${ALPS_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR}

./install-tool --target-arch cray --build-onlyosscbtf --openss-prefix ${OSSCBTF_IDIR} --with-cn-cbtf-krell ${CBTF_IDIR}/compute --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-boost ${KROOT_IDIR} --with-mrnet ${KROOT_IDIR} --with-xercesc ${KROOT_IDIR} --with-libmonitor ${KROOT_IDIR} --with-libunwind ${KROOT_IDIR} --with-dyninst ${KROOT_IDIR} --with-libelf ${KROOT_IDIR} --with-libdwarf ${KROOT_IDIR} --with-binutils ${KROOT_IDIR} --cbtf-prefix ${CBTF_IDIR} --with-papi ${PAPI_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR}


#./install-tool --build-offline --openss-prefix ${OSSOFF_IDIR} --with-runtime-dir ${OSSOFF_IDIR}/compute --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR} 

cp /opt/gcc/4.9.3/snos/lib64/libstdc++.so.6 ${KROOT_IDIR}/lib64/libstdc++.so.6
#cp /opt/gcc/5.3.0/snos/lib64/libstdc++.so.6 ${KROOT_IDIR}/lib64/libstdc++.so.6
#chmod 755 ${KROOT_IDIR}/lib64/libstdc++.so.6
cp /opt/gcc/4.9.3/snos/lib64/libstdc++.so.6 ${KROOT_IDIR}/compute/lib64/libstdc++.so.6
#cp /opt/gcc/5.3.0/snos/lib64/libstdc++.so.6 ${KROOT_IDIR}/compute/lib64/libstdc++.so.6
#chmod 755 ${KROOT_IDIR}/compute/lib64/libstdc++.so.6

