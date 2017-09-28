#!/bin/bash 

export MODULESHOME=/usr/share/modules
. $MODULESHOME/init/bash

module unload compiler/intel
module load compiler/gcc/4.9.3

export cc=gcc
export CC=gcc
export CXX=g++

BASE_DIR=/app/unsupported/PETtools/CE/pkgs/openss
TOOL_VERS="_v2.3.1.beta1"
#MPT_DIR=/p/home/apps/sgi/mpt-2.12-sgi712r26
MPT_DIR=/p/home/apps/sgi/mpt-2.14
CUDA_IDIR=/p/home/apps/cuda/7.5
CUPTI_IDIR=/p/home/apps/cuda/7.5/extras/CUPTI

##./install-tool --build-mrnet --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-boost /app/unsupported/PETtools/CE/pkgs/openss/krellroot_v2.3.0cuda
./install-tool --build-krell-root --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpt ${MPT_DIR} 

##./install-tool --build-offline --openss-prefix ${BASE_DIR}/ossoff${TOOL_VERS} --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpt ${MPT_DIR}

./install-tool --build-cbtf-all --cbtf-prefix ${BASE_DIR}/cbtf${TOOL_VERS} --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpt /${MPT_DIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR} --with-boost ${BASE_DIR}/krellroot${TOOL_VERS}

./install-tool --build-oss --openss-prefix ${BASE_DIR}/osscbtf${TOOL_VERS} --cbtf-prefix ${BASE_DIR}/cbtf${TOOL_VERS} --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpt ${MPT_DIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR} --with-boost ${BASE_DIR}/krellroot${TOOL_VERS}


# Need this when executing OSS on compute nodes.   Non-standard installation compiler usage requires the module be loaded at run time or having the libstdc++ library available 
cp /apps/gnu_compiler/4.9.3/lib64/libstdc++.so.6 ${BASE_DIR}/krellroot${TOOL_VERS}/lib64/libstdc++.so.6

#export KRELL_ROOT_BOOST=/app/unsupported/PETtools/CE/pkgs/openss/krellroot_v2.3.0
#export BOOST_ROOT=/app/unsupported/PETtools/CE/pkgs/openss/krellroot_v2.3.0
#export QTDIR=/usr/lib64/qt4
#./install-tool --build-cbtfargonavisgui --with-openss ${BASE_DIR}/osscbtf${TOOL_VERS} --with-cbtf ${BASE_DIR}/cbtf${TOOL_VERS} --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-boost ${BASE_DIR}/krellroot${TOOL_VERS} 


