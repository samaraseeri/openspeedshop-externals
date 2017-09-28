#!/bin/bash 

export MODULESHOME=/hafs_x86_64/devel/share/Modules
. $MODULESHOME/init/bash

module purge
module load gcc-compilers/4.8.4
module load /p/home/galarowi/privatemodules/cmake-3.2.2

export cc=gcc
export CC=gcc
export CXX=g++

BASE_DIR=/app/comenv/pkgs/openss
TOOL_VERS="_v2.3.1.beta1"
MPT_DIR=/p/home/apps/sgi/mpt-2.14
PTYHON_IROOT=${BASE_DIR}/python-2.7.3
PYTHON_VERS="2.7"
KROOT_IDIR=${BASE_DIR}/krellroot${TOOL_VERS}
CBTF_IDIR=${BASE_DIR}/cbtf${TOOL_VERS}
OSSCBTF_IDIR=${BASE_DIR}/osscbtf${TOOL_VERS}
OSSOFF_IDIR=${BASE_DIR}/ossoff${TOOL_VERS}

# build once before running the rest of the script, also need module file or set PATH to point to installation directory.
# Or if administrator, install cmake 3.0.2 or above for use 
./install-tool --build-cmake --krell-root-prefix ${BASE_DIR}/cmake-3.2.2
export PATH=${BASE_DIR}/cmake-3.2.2/bin:$PATH

./install-tool --build-python --krell-root-prefix ${PTYHON_IROOT}

./install-tool --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-mpt ${MPT_DIR} --with-python ${PTYHON_IROOT} --with-python-vers ${PYTHON_VERS}

#./install-tool --build-offline --openss-prefix ${OSSOFF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-mpt ${MPT_DIR} --with-python ${PTYHON_IROOT} --with-python-vers ${PYTHON_VERS}

./install-tool --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-mpt ${MPT_DIR} --with-python ${PTYHON_IROOT} --with-python-vers ${PYTHON_VERS}

./install-tool --build-oss --openss-prefix ${OSSCBTF_IDIR} --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-mpt ${MPT_DIR} --with-python  ${PTYHON_IROOT} --with-python-vers ${PYTHON_VERS}

# Need this when executing OSS on compute nodes.   Non-standard installation compiler usage requires the module be loaded at run time or having the libstdc++ library available 
cp /app/gmpapp/gcc/platform/gcc-4.8.4/lib64/libstdc++.so.6 ${KROOT_IDIR}/lib64/libstdc++.so.6
