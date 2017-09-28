#!/bin/bash

BASE_DIR=/home/jgalaro/OSS_ARM
TOOL_VERS="_v2.2.4"
KROOT_IDIR=${BASE_DIR}/krellroot${TOOL_VERS}
CBTF_IDIR=${BASE_DIR}/cbtf${TOOL_VERS}
OSSCBTF_IDIR=${BASE_DIR}/osscbtf${TOOL_VERS}
OSSOFF_IDIR=${BASE_DIR}/ossoff${TOOL_VERS}
OPENMPI_IDIR=/home/projects/arm64/openmpi/1.8.2/gnu/4.9.1
QTDIR_IDIR=/home/jgalaro/qt3/qt3

# Latest version

module load cmake

./install-tool --target-arch arm --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-qt3 ${QTDIR_IDIR}
./install-tool --target-arch arm --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix  ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} 
./install-tool --target-arch arm --build-onlyosscbtf --openss-prefix ${OSSCBTF_IDIR} --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-qt3 ${QTDIR_IDIR}

#As a fallback option: the older offline version (writes files shared file system)
#./install-tool --target-arch arm --build-offline --openss-prefix ${OSSOFF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR}

