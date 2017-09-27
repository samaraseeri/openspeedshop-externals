#!/bin/bash 

export MODULESHOME=/usr/share/Modules
. $MODULESHOME/init/bash

#export BASE_IDIR=/work1/home/galarowi/OSS2
export BASE_IDIR=/work1/app/comenv/pkgs/openss
export TOOL_VERS="_v2.2.3"
export KROOT_IDIR=${BASE_IDIR}/krellroot${TOOL_VERS}
export CBTF_IDIR=${BASE_IDIR}/cbtf${TOOL_VERS}
export OSSCBTF_IDIR=${BASE_IDIR}/osscbtf${TOOL_VERS}
export OSSOFF_IDIR=${BASE_IDIR}/ossoff${TOOL_VERS}
export MPT_IDIR=/app/sgi/mpt/mpt-2.12

module unload compiler/intel
module load /work1/home/galarowi/privatemodules/cmake-3.2.2
module load gcc-compilers/4.8.4

export CC=gcc
export cc=gcc
export CXX=g++

./install-tool --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-mpt ${MPT_IDIR} --force-sqlite-build

./install-tool --build-offline --openss-prefix ${OSSOFF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-mpt ${MPT_IDIR} 

./install-tool --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-mpt ${MPT_IDIR} 

./install-tool --build-onlyosscbtf --openss-prefix ${OSSCBTF_IDIR} --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-mpt ${MPT_IDIR}

# Need this when executing OSS on compute nodes.   Non-standard installation compiler usage requires 
# the module be loaded at run time or having the libstdc++ library available 
cp /app/gmpapp/gcc/platform/gcc-4.8.4/lib64/libstdc++.so.6 ${KROOT_IDIR}/lib64/libstdc++.so.6
