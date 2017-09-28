#!/bin/bash

#. /usr/share/Modules/init/bash
#module use /ascldap/users/jgalaro/privatemodules

#module purge
#module load cmake/3.4.3 cudatoolkit/7.5

export BASE_IDIR=/projects/OSS/cts1
export TOOL_VERS="_v2.3.1.latest.openmpi20"
export ROOT_VERS="_v2.3.1.latest"
export ROOT_VERS="_v2.3.1.latest"
export GRAPHVIZ_VERS="-2.41.0"
export QTGRAPH_VERS="-1.0.0"

#export MVAPICH_IDIR=/opt/mvapich-gnu-shmem-1.2
#export OPENMPI_IDIR=/opt/openmpi/1.10/gnu
export OPENMPI_IDIR=/opt/openmpi/2.0/gnu
#export MVAPICH2_IDIR=/opt/mvapich2-gnu-shmem-1.7
export CUDA_IDIR=/opt/cudatoolkit-8.0
export CUPTI_IDIR=/opt/cudatoolkit-8.0/extras/CUPTI
export KROOT_IDIR=${BASE_IDIR}/krellroot${ROOT_VERS}
export CBTF_IDIR=${BASE_IDIR}/cbtf${TOOL_VERS}
export OSSCBTF_IDIR=${BASE_IDIR}/osscbtf${TOOL_VERS}
export GRAPHVIZ_IDIR=${BASE_IDIR}/graphviz${GRAPHVIZ_VERS}
export QTGRAPH_IDIR=${BASE_IDIR}/QtGraph${QTGRAPH_VERS}


./install-tool --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} 

./install-tool --build-cbtf-all --cbtf-install-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} 

./install-tool --build-oss --openss-prefix ${OSSCBTF_IDIR} --cbtf-install-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} 

#./install-tool --build-offline --openss-prefix ${BASE_IDIR}/ossoff${TOOL_VERS} --krell-root-prefix ${BASE_IDIR}/krellroot${TOOL_VERS} --with-openmpi ${OPENMPI_IDIR} --with-mvapich2 ${MVAPICH2_IDIR} --with-mvapich ${MVAPICH_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR}

# Build graphviz for support of building the new cbtf-argonavis-gui
./install-tool --build-graphviz --krell-root-prefix ${GRAPHVIZ_IDIR}

# Build QtGraph for support of building the new cbtf-argonavis-gui, uses graphviz
./install-tool --build-QtGraph --krell-root-prefix ${QTGRAPH_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-qt /usr/lib64/qt5

# Build new cbtf-argonavis-gui, uses graphviz and QtGraph
./install-tool --build-cbtfargonavisgui --with-openss ${OSSCBTF_IDIR} --with-cbtf ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-QtGraph ${QTGRAPH_IDIR} --with-boost ${KROOT_IDIR} --with-qt /usr/lib64/qt5


