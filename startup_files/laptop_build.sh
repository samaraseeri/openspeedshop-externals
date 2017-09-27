#!/bin/bash

BASE_DIR=/opt/OSS
TOOL_VERS="_v2.3.1.rc1"
ROOT_VERS="_v2.3.1.rc1"
GRAPHVIZ_VERS="-2.41.0"
QTGRAPH_VERS="-1.0.0"
OPENMPI_IDIR=/opt/openmpi-1.8.2
KROOT_IDIR=${BASE_DIR}/krellroot${ROOT_VERS}
CBTF_IDIR=${BASE_DIR}/cbtf${TOOL_VERS}
OSSCBTF_IDIR=${BASE_DIR}/osscbtf${TOOL_VERS}
OSSOFF_IDIR=${BASE_DIR}/ossoff${TOOL_VERS}
CUDA_IDIR=/usr/local/cuda-6.0
CUPTI_IDIR=/usr/local/cuda-6.0/extras/CUPTI
GRAPHVIZ_IDIR=${BASE_DIR}/graphviz${GRAPHVIZ_VERS}
QTGRAPH_IDIR=${BASE_DIR}/QtGraph${QTGRAPH_VERS}


###./install-tool --build-dyninst --krell-root-prefix /opt/dyninst920 --with-openmpi ${OPENMPI_IDIR} --with-libelf ${KROOT_IDIR} --with-libdwarf ${KROOT_IDIR} --with-binutils ${KROOT_IDIR}

./install-tool --verbose --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR}   --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR}

./install-tool --verbose --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR}

./install-tool --verbose --build-oss --openss-prefix ${OSSCBTF_IDIR} --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR}

#./install-tool --verbose --build-all --openss-prefix ${OSSCBTF_IDIR} --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR}

# Build graphviz for support of building the new cbtf-argonavis-gui
./install-tool --build-graphviz --krell-root-prefix ${GRAPHVIZ_IDIR}

# Build QtGraph for support of building the new cbtf-argonavis-gui, uses graphviz
./install-tool --build-QtGraph --krell-root-prefix ${QTGRAPH_IDIR} --with-graphviz ${GRAPHVIZ_IDIR}

# Build new cbtf-argonavis-gui, uses graphviz and QtGraph 
./install-tool --build-cbtfargonavisgui --with-openss ${OSSCBTF_IDIR} --with-cbtf ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-QtGraph ${QTGRAPH_IDIR}

###./install-tool --build-offline --openss-prefix ${OSSOFF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR}
