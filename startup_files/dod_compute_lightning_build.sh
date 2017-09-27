#!/bin/bash 

# -----------------------------
# First Build the compute node version (root and oss versions if you use the recommended krell externals root build):
# For COMPUTE NODE builds:
# ----------------------------------

. /opt/modules/default/init/bash

module unload PrgEnv-cray PrgEnv-pgi PrgEnv-gnu PrgEnv-intel
module load PrgEnv-gnu gcc/5.1.0
module load cmake
export CC=gcc
export CXX=g++
export BASE_IDIR=/p/home/galarowi/OSS2
export TOOL_VERS="_v2.2.3"
#export CMAKE_IDIR=${CMAKE_IDIR}/cmake-3.2.2
export PATH=${CMAKE_IDIR}/bin:$PATH
export MPICH_IDIR=/opt/cray/mpt/7.2.6/gni/mpich-gnu/5.1  
export PAPI_IDIR=/opt/cray/papi/5.4.1.2
export BINUTILS_IDIR=/opt/cray/xc-sysroot/default/usr
export KROOT_IDIR=${BASE_IDIR}/krellroot${TOOL_VERS}
export CBTF_IDIR=${BASE_IDIR}/cbtf${TOOL_VERS}
export OSSCBTF_IDIR=${BASE_IDIR}/osscbtf${TOOL_VERS}
export OSSOFF_IDIR=${BASE_IDIR}/ossoff${TOOL_VERS}
# USING PYTHON FROM module load python/2.7.9-gnu
export PYTHON_IDIR=${BASE_IDIR}/python-2.7.3
export PYTHON_VERS="2.7"
export ALPS_IDIR=/opt/cray/alps/5.2.4-2.0502.9774.31.11.ari

# BUILD IN LUSTRE

#./install-tool --runtime-only --target-arch cray --target-shared --build-krell-root --krell-root-prefix ${KROOT_IDIR}/compute --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR} --with-binutils ${BINUTILS_IDIR} --with-alps ${ALPS_IDIR}

#./install-tool --runtime-only --target-arch cray --target-shared --build-offline --openss-prefix ${OSSOFF_IDIR}/compute --krell-root-prefix ${KROOT_IDIR}/compute --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR} --with-binutils ${BINUTILS_IDIR} --with-alps ${ALPS_IDIR}

./install-tool --build-cbtf-all --runtime-only --target-arch cray --target-shared --cbtf-prefix ${CBTF_IDIR}/compute --krell-root-prefix  ${KROOT_IDIR}/compute --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR} --with-alps ${ALPS_IDIR}


