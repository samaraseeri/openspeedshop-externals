#!/bin/bash

. /usr/share/Modules/init/bash

export CC=gcc
export CXX=g++

export BASE_INSTALL_DIR=/usr/projects/packages/openspeedshop/jegsgi/installs/mustang
export TOOL_VERS="_v2.2.2"
export MPICH_PATH=/usr/projects/hpcsoft/toss2/common/intel-clusterstudio/2015.0.3.032/impi_5.0.3/intel64
export MPICH2_PATH=/usr/projects/hpcsoft/toss2/common/intel-clusterstudio/2015.0.3.032/impi_5.0.3/intel64
export MVAPICH2_PATH=/usr/projects/hpcsoft/toss2.1/mustang/mvapich2/1.9-gcc-4.9
export OPENMPI_PATH=/usr/projects/hpcsoft/toss2.1/mustang/openmpi/1.6.5-gcc-4.4

# -----------------------------------------------------
# Load cmake module 
# -----------------------------------------------------
module load cmake 

# -----------------------------------------------------
# Build ompt
# -----------------------------------------------------

./install-tool --build-ompt --krell-root-install-prefix ${BASE_INSTALL_DIR}/ompt${TOOL_VERS}

# -----------------------------------------------------
# Build krellroot_latest
# -----------------------------------------------------

./install-tool --build-krell-root --krell-root-install-prefix ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-openmpi ${OPENMPI_PATH} --with-mvapich2 ${MVAPICH2_PATH} --with-mpich ${MPICH_PATH}  --with-mpich2 ${MPICH2_PATH}


# -----------------------------------------------------
# Build cbtf,cbtf-krell, cbtf-argonavis, cbtf-lanl using krellroot_latest from above build
# -----------------------------------------------------

./install-tool --build-cbtf-all --cbtf-prefix ${BASE_INSTALL_DIR}/cbtf${TOOL_VERS} --krell-root-prefix ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-openmpi ${OPENMPI_PATH} --with-mvapich2 ${MVAPICH2_PATH} --with-mpich ${MPICH_PATH}  --with-mpich2 ${MPICH2_PATH} --with-ompt ${BASE_INSTALL_DIR}/ompt${TOOL_VERS}


# -----------------------------------------------------
# Build OpenSpeedShop for cbtf instrumentor using cbtf_latest and krellroot_latest from above builds
# -----------------------------------------------------

./install-tool --build-onlyosscbtf --openss-prefix ${BASE_INSTALL_DIR}/osscbtf${TOOL_VERS} --cbtf-install-prefix ${BASE_INSTALL_DIR}/cbtf${TOOL_VERS} --krell-root-prefix ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-openmpi ${OPENMPI_PATH} --with-mvapich2 ${MVAPICH2_PATH} --with-mpich ${MPICH_PATH}  --with-mpich2 ${MPICH2_PATH} --with-ompt ${BASE_INSTALL_DIR}/ompt${TOOL_VERS}


# -----------------------------------------------------
# Build offline using krellroot_latest from above build
# -----------------------------------------------------

./install-tool --build-offline --openss-prefix ${BASE_INSTALL_DIR}/ossoff${TOOL_VERS} --krell-root-install-prefix ${BASE_INSTALL_DIR}/krellroot${TOOL_VERS} --with-openmpi ${OPENMPI_PATH} --with-mvapich2 ${MVAPICH2_PATH} --with-mpich ${MPICH_PATH}  --with-mpich2 ${MPICH2_PATH}


