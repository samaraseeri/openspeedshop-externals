#!/bin/bash

BASE_DIR=/opt/OSS
TOOL_VERS="_v2.3.1"
ROOT_VERS="_v2.3.1"
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
BINUTILS_IDIR=${KROOT_IDIR}/binutils
MRNET_IDIR=${BASE_DIR}/mrnet_20170810


./install-tool --verbose --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR}   --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR} 

./install-tool --verbose --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR}

./install-tool --verbose --build-oss --openss-prefix ${OSSCBTF_IDIR} --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR}


# Build graphviz for support of building the new cbtf-argonavis-gui
#./install-tool --build-graphviz --krell-root-prefix ${GRAPHVIZ_IDIR}

# Build QtGraph for support of building the new cbtf-argonavis-gui, uses graphviz
#./install-tool --build-QtGraph --krell-root-prefix ${QTGRAPH_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-qt /opt/Qt5.6.0/5.6/gcc_64

# Build new cbtf-argonavis-gui, uses graphviz and QtGraph 
#./install-tool --build-cbtfargonavisgui --with-openss ${OSSCBTF_IDIR} --with-cbtf ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-QtGraph ${QTGRAPH_IDIR} --with-boost ${KROOT_IDIR} --with-qt /opt/Qt5.6.0/5.6/gcc_64

