#!/bin/bash

BASE_DIR=/opt/OSS
TOOL_VERS="_v2.3.1.latest"
ROOT_VERS="_v2.3.1.latest"
GRAPHVIZ_VERS="-2.41.0"
QTGRAPH_VERS="-1.0.0"
OPENMPI_IDIR=/opt/openmpi-1.8.2
KROOT_IDIR=${BASE_DIR}/krellroot${ROOT_VERS}
CBTF_IDIR=${BASE_DIR}/cbtf${TOOL_VERS}
OSSCBTF_IDIR=${BASE_DIR}/osscbtf${TOOL_VERS}
OSSOFF_IDIR=${BASE_DIR}/ossoff${TOOL_VERS}
GRAPHVIZ_IDIR=${BASE_DIR}/graphviz${GRAPHVIZ_VERS}
QTGRAPH_IDIR=${BASE_DIR}/QtGraph${QTGRAPH_VERS}
BINUTILS_IDIR=${KROOT_IDIR}/binutils
MRNET_IDIR=${BASE_DIR}/mrnet_20170810

# Build the root components
./install-tool --verbose --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR}  

# Build the cbtf components
./install-tool --verbose --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} 

# Build openspeedshop
./install-tool --verbose --build-oss --openss-prefix ${OSSCBTF_IDIR} --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR}

# Build graphviz for support of building the new cbtf-argonavis-gui
./install-tool --build-graphviz --krell-root-prefix ${GRAPHVIZ_IDIR}

# Build QtGraph for support of building the new cbtf-argonavis-gui, uses graphviz
# Point the --with-qt to the qt4 or qt5 version location on your system
./install-tool --build-QtGraph --krell-root-prefix ${QTGRAPH_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-qt /usr/lib64/qt5

# Build new cbtf-argonavis-gui, uses graphviz and QtGraph 
# Point the --with-qt to the qt4 or qt5 version location on your system
./install-tool --build-cbtfargonavisgui --with-openss ${OSSCBTF_IDIR} --with-cbtf ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-QtGraph ${QTGRAPH_IDIR} --with-boost ${KROOT_IDIR} --with-qt /usr/lib64/qt5

