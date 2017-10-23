#!/bin/bash

use .adept

. /usr/share/Modules/init/bash
module load gnu/4.9.2

export cc=gcc
export CC=gcc
export CXX=g++


export BASE_IDIR=/usr/global/tools/openspeedshop/oss-dev/x8664/surface
export TOOL_VERS="_v2.3.1.rc6"
export ROOT_VERS="_v2.3.1.rc6"
export MPICH_PATH=/opt/intel-mpi-5.1
export MVAPICH2_PATH=/usr/local/tools/mvapich2-gnu-1.9
export MVAPICH_PATH=/usr/local/tools/mvapich-gnu-1.2
export OPENMPI_PATH=/opt/openmpi-1.8-gnu
export CUDATOOLKIT_PATH=/opt/cudatoolkit-8.0
export CUDATOOLKIT_CUPTI_PATH=/opt/cudatoolkit-8.0/extras/CUPTI
export PYTHON_PATH=/usr/local/tools/python-2.7.7
export PYTHON_VERS="2.7"

# -----------------------------------------------------
# Build krellroot_latest
# -----------------------------------------------------

./install-tool --build-krell-root --krell-root-prefix ${BASE_IDIR}/krellroot${ROOT_VERS} --with-openmpi ${OPENMPI_PATH} --with-mvapich2 ${MVAPICH2_PATH} --with-mpich ${MPICH_PATH} --with-mvapich ${MVAPICH_PATH}  --with-cuda $CUDATOOLKIT_PATH --with-cupti $CUDATOOLKIT_CUPTI_PATH --with-python ${PYTHON_PATH} --with-python-vers ${PYTHON_VERS}


# -----------------------------------------------------
# Build cbtf,cbtf-krell, cbtf-argonavis, cbtf-lanl using krellroot_latest from above build
# -----------------------------------------------------

./install-tool --build-cbtf-all --cbtf-prefix ${BASE_IDIR}/cbtf${TOOL_VERS} --krell-root-prefix ${BASE_IDIR}/krellroot${ROOT_VERS} --with-openmpi ${OPENMPI_PATH} --with-mvapich2 ${MVAPICH2_PATH} --with-mvapich ${MVAPICH_PATH} --with-mpich ${MPICH_PATH} --with-ompt ${BASE_IDIR}/krellroot${ROOT_VERS} --with-cuda $CUDATOOLKIT_PATH --with-cupti $CUDATOOLKIT_CUPTI_PATH --with-python ${PYTHON_PATH} --with-python-vers ${PYTHON_VERS}


# -----------------------------------------------------
# Build OpenSpeedShop for cbtf instrumentor using cbtf_latest and krellroot_latest from above builds
# -----------------------------------------------------

./install-tool --build-oss --openss-prefix ${BASE_IDIR}/osscbtf${TOOL_VERS} --cbtf-prefix ${BASE_IDIR}/cbtf${TOOL_VERS} --krell-root-prefix ${BASE_IDIR}/krellroot${ROOT_VERS} --with-openmpi ${OPENMPI_PATH} --with-mvapich ${MVAPICH_PATH} --with-mvapich2 ${MVAPICH2_PATH} --with-mpich ${MPICH_PATH} --with-ompt ${BASE_IDIR}/krellroot${ROOT_VERS} --with-cuda $CUDATOOLKIT_PATH --with-cupti $CUDATOOLKIT_CUPTI_PATH --with-python ${PYTHON_PATH} --with-python-vers ${PYTHON_VERS}


# -----------------------------------------------------
# Build offline using krellroot_latest from above build
# -----------------------------------------------------

#./install-tool --build-offline --openss-prefix ${BASE_IDIR}/ossoff${TOOL_VERS} --krell-root-prefix ${BASE_IDIR}/krellroot${ROOT_VERS} --with-openmpi ${OPENMPI_PATH} --with-mvapich2 ${MVAPICH2_PATH} --with-mpich ${MPICH_PATH} --with-mvapich ${MVAPICH_PATH} --with-python ${PYTHON_PATH} --with-python-vers ${PYTHON_VERS}



