#!/bin/bash

. /usr/share/Modules/init/sh
#module load intel2017
source /opt/intel/bin/compilervars.sh intel64

BASE_DIR=/opt/OSS
TOOL_VERS="_v2.3.1.intel"
ROOT_VERS="_v2.3.1.intel"
OPENMPI_IDIR=/opt/openmpi-1.8.2
KROOT_IDIR=${BASE_DIR}/krellroot${ROOT_VERS}
CBTF_IDIR=${BASE_DIR}/cbtf${TOOL_VERS}
OSSCBTF_IDIR=${BASE_DIR}/osscbtf${TOOL_VERS}
OSSOFF_IDIR=${BASE_DIR}/ossoff${TOOL_VERS}
CUDA_IDIR=/usr/local/cuda-6.0
CUPTI_IDIR=/usr/local/cuda-6.0/extras/CUPTI


#./install-tool --build_compiler intel --build-dyninst --krell-root-prefix /opt/dyninst930 --with-openmpi ${OPENMPI_IDIR} --with-libelf ${KROOT_IDIR} --with-libdwarf ${KROOT_IDIR} --with-binutils ${KROOT_IDIR}

./install-tool --build_compiler intel --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} 

./install-tool --build_compiler intel --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR}

./install-tool --build_compiler intel --build-oss --openss-prefix ${OSSCBTF_IDIR} --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR}

./install-tool --build_compiler intel --build-cbtfargonavisgui --with-openss ${OSSCBTF_IDIR} --with-cbtf ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR}

#./install-tool --build_compiler intel --build-offline --openss-prefix ${OSSOFF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR}
