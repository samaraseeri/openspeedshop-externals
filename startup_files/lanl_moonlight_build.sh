#!/bin/bash

. /usr/share/Modules/init/bash


BASE_IDIR=/usr/projects/packages/openspeedshop/jegsgi/installs/moonlight

# So we don't have to continually build the root
# separate the TOOL_VERS from the ROOT_VERS
#
TOOL_VERS="_v2.3.1.rc5"
ROOT_VERS="_v2.3.1.rc5"
GRAPHVIZ_VERS="-2.41.0"
QTGRAPH_VERS="-1.0.0"

CBTF_IDIR=${BASE_IDIR}/cbtf${TOOL_VERS}
OSSCBTF_IDIR=${BASE_IDIR}/osscbtf${TOOL_VERS}
OSSOFF_IDIR=${BASE_IDIR}/ossoff${TOOL_VERS}

# So we don't have to continually build the root
# separate the TOOL_VERS from the ROOT_VERS
#
ROOT_IDIR=${BASE_IDIR}/krellroot${ROOT_VERS}

QT_IDIR=/usr/lib64/qt3
CUDA_IDIR=/opt/cudatoolkit-8.0
CUPTI_IDIR=/opt/cudatoolkit-8.0/extras/CUPTI
PYTHON_IDIR=/nasa/python/2.7.9
MPICH_IDIR=/usr/projects/hpcsoft/toss2/common/intel-clusterstudio/2016.3.067/impi/5.1.3.210
MPICH2_IDIR=/usr/projects/hpcsoft/toss2/common/intel-clusterstudio/2016.3.067/impi/5.1.3.210
MVAPICH2_IDIR=/usr/projects/hpcsoft/toss2/moonlight/mvapich2/2.0_gcc-4.4.7
OPENMPI_IDIR=/usr/projects/hpcsoft/toss2/moonlight/openmpi/1.10.5-gcc-4.4.7
GRAPHVIZ_IDIR=${BASE_IDIR}/graphviz${GRAPHVIZ_VERS}
QTGRAPH_IDIR=${BASE_IDIR}/QtGraph${QTGRAPH_VERS}


# -----------------------------------------------------
# Load cmake module and cudattoolkit module
# -----------------------------------------------------
module load gcc/5.3.0 cmake cudatoolkit/7.5

cmake --version
gcc --version

# -----------------------------------------------------
# Build krellroot_${ROOT_VERS}
# -----------------------------------------------------

##./install-tool --build-mrnet --krell-root-prefix ${ROOT_IDIR} --with-boost ${ROOT_IDIR} 

./install-tool --build-krell-root --krell-root-prefix ${ROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-mvapich2 ${MVAPICH2_IDIR} --with-cupti ${CUPTI_IDIR} --with-cuda ${CUDA_IDIR} --with-mpich ${MPICH_IDIR} --with-mpich2 ${MPICH2_IDIR} 

# -----------------------------------------------------
# Build cbtf,cbtf-krell, cbtf-argonavis, cbtf-lanl using krellroot_v${ROOT_VERS} from above build
# -----------------------------------------------------

./install-tool --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${ROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-mvapich2 ${MVAPICH2_IDIR} --with-cupti ${CUPTI_IDIR} --with-cuda ${CUDA_IDIR} --with-mpich ${MPICH_IDIR} --with-mpich2 ${MPICH2_IDIR}

# -----------------------------------------------------
# Build OpenSpeedShop for cbtf instrumentor using cbtf_${TOOL_VERS} and krellroot_${ROOT_VERS} from above builds
# -----------------------------------------------------

./install-tool --build-oss --openss-prefix ${OSSCBTF_IDIR} --cbtf-install-prefix ${CBTF_IDIR} --krell-root-prefix ${ROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-mvapich2 ${MVAPICH2_IDIR} --with-cupti ${CUPTI_IDIR} --with-cuda ${CUDA_IDIR} --with-mpich ${MPICH_IDIR} --with-mpich2 ${MPICH2_IDIR}

# -----------------------------------------------------
# Build offline using krellroot_${ROOT_VERS} from above build
# -----------------------------------------------------

##./install-tool --build-offline --openss-prefix ${OSSOFF_IDIR} --krell-root-prefix ${ROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-mvapich2 ${MVAPICH2_IDIR} --with-cupti ${CUPTI_IDIR} --with-cuda ${CUDA_IDIR} --with-mpich ${MPICH_IDIR} --with-mpich2 ${MPICH2_IDIR}

# -----------------------------------------------------
# Build graphviz, QtGraph, and cbtf-argonavis-gui 
# -----------------------------------------------------

# Build graphviz for support of building the new cbtf-argonavis-gui
./install-tool --build-graphviz --krell-root-prefix ${GRAPHVIZ_IDIR}

# Build QtGraph for support of building the new cbtf-argonavis-gui, uses graphviz
./install-tool --build-QtGraph --krell-root-prefix ${QTGRAPH_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-qt /usr/lib64/qt4  --with-boost ${ROOT_IDIR}

# Build new cbtf-argonavis-gui, uses graphviz and QtGraph
./install-tool --build-cbtfargonavisgui --with-openss ${OSSCBTF_IDIR} --with-cbtf ${CBTF_IDIR} --krell-root-prefix ${ROOT_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-QtGraph ${QTGRAPH_IDIR} --with-boost ${ROOT_IDIR} --with-qt /usr/lib64/qt4

# copy over the libstdc++ that was used in the build, so it is available to mrnet when
# it executes on the compute nodes
cp /usr/projects/hpcsoft/toss2/common/gcc/5.3.0/lib64/libstdc++.so.6 ${ROOT_IDIR}/lib64/.


