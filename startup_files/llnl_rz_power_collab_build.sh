#!/bin/bash 
#
# Build on: rzmanta at LLNL:

#. /usr/share/lmod/lmod/init/bash

BASE_IDIR=/collab/usr/global/tools/openspeedshop/oss-dev/power
TOOL_VERS="_v2.4.0.dyn1030"
ROOT_VERS="_v2.4.0.dyn1030"
GRAPHVIZ_VERS="-2.40.1"
QTGRAPH_VERS="-1.0.0"

#FLEX_VERS="-2.5.35"
KROOT_IDIR=${BASE_IDIR}/krellroot${ROOT_VERS}
CBTF_IDIR=${BASE_IDIR}/cbtf${TOOL_VERS}
OSSCBTF_IDIR=${BASE_IDIR}/osscbtf${TOOL_VERS}
OSSOFF_IDIR=${BASE_IDIR}/ossoff${TOOL_VERS}
LTDL_IDIR=${BASE_IDIR}/autotools${ROOT_VERS}
FLEX_IDIR=${BASE_IDIR}/flex${FLEX_VERS}
OPENMPI_IDIR=/usr/tce/packages/spectrum-mpi/ibm/spectrum-mpi-2018.07.12
CUDA_IDIR=/usr/tce/packages/cuda/cuda-9.2.88 
CUPTI_IDIR=/usr/tce/packages/cuda/cuda-9.2.88/extras/CUPTI
GRAPHVIZ_IDIR=${BASE_IDIR}/graphviz${GRAPHVIZ_VERS}
QTGRAPH_IDIR=${BASE_IDIR}/QtGraph${QTGRAPH_VERS}


# Build krellroot:
#

#./install-tool --build-autotools --krell-root-prefix ${LTDL_IDIR}  2>&1 | tee install_tool_build_autotools_${ROOT_VERS}.log

./install-tool --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-papi	/collab/usr/global/tools/papi/blueos_3_ppc64le_ib/papi-pcp 2>&1 | tee install_tool_build_krell_root_${ROOT_VERS}.log

./install-tool --build-cbtf-all --cbtf-install-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR}  --with-openmpi ${OPENMPI_IDIR} --with-ltdl ${LTDL_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR} --with-papi  /collab/usr/global/tools/papi/blueos_3_ppc64le_ib/papi-pcp 2>&1 | tee install_tool_build_cbtf_${TOOL_VERS}.log

./install-tool --build-oss --openss-install-prefix ${OSSCBTF_IDIR} --cbtf-install-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-ltdl ${LTDL_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR} --with-papi  /collab/usr/global/tools/papi/blueos_3_ppc64le_ib/papi-pcp 2>&1 | tee install_tool_build_oss_${TOOL_VERS}.log

cp /usr/tce/packages/gcc/gcc-4.9.3/gnu//lib64/libstdc++.so.6 ${KROOT_IDIR}/lib/.


#./install-tool --build-graphviz --krell-root-prefix ${GRAPHVIZ_IDIR} 2>&1 | tee install_tool_build_graphviz.log
#./install-tool --build-QtGraph --krell-root-prefix ${QTGRAPH_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-qt /usr/lib64/qt4 2>&1 | tee install_tool_build_graphlib.log
#./install-tool --build-cbtfargonavisgui --with-openss ${OSSCBTF_IDIR} --with-cbtf ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-QtGraph ${QTGRAPH_IDIR} --with-qt /usr/lib64/qt4 --with-boost  ${KROOT_IDIR} 2>&1 | tee install_tool_build_cbtf_argonavis_gui.log
