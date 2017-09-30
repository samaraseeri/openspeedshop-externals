#!/bin/bash 

#----------------
#FROM: falcon at INL:

#module load CMake/3.2.3-GCC-4.9.3 
module load GCC/4.9.3
#module load GCC/6.3.0-2.27

#module load gcc/4.7.3 boost/1.50.0 cmake cuda/6.0 python/2.7.6

BASE_IDIR=/home/galajame/OSS
TOOL_VERS="_v2.3.1.rc5"
ROOT_VERS="_v2.3.1.rc5"
GRAPHVIZ_VERS="-2.41.0"
QTGRAPH_VERS="-1.0.0"

#MVAPICH2_INSTALL=/apps/local/easybuild/software/MVAPICH2/2.1-GCC-4.9.3
MVAPICH2_INSTALL=/apps/local/easybuild/software/MVAPICH2/2.2-GCC-4.9.3
OPENMPI_INSTALL=/apps/local/easybuild/software/OpenMPI/1.8.7-GCC-4.9.3
MPICH_INSTALL=/apps/local/easybuild/software/impi/5.1.3.181-iccifort-2016.3.067-GCC-4.9.3-2.25
PYTHON_INSTALL=/apps/local/easybuild/software/Python/2.7.8-gmvolf-5.5.4
GRAPHVIZ_IDIR=${BASE_IDIR}/graphviz${GRAPHVIZ_VERS}
QTGRAPH_IDIR=${BASE_IDIR}/QtGraph${QTGRAPH_VERS}
CBTF_IDIR=${BASE_IDIR}/cbtf${TOOL_VERS}
OSSCBTF_IDIR=${BASE_IDIR}/osscbtf${TOOL_VERS}
OSSOFF_IDIR=${BASE_IDIR}/ossoff${TOOL_VERS}
KROOT_IDIR=${BASE_IDIR}/krellroot${ROOT_VERS}


./install-tool --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-mvapich2 ${MVAPICH2_INSTALL} --with-openmpi ${OPENMPI_INSTALL} --with-mpich ${MPICH_INSTALL} --with-python ${PYTHON_INSTALL} --with-mvapich2 ${MVAPICH2_INSTALL} 2>&1 | tee install-tool_build-krell-root.log

./install-tool --build-cbtf-all --cbtf-install-prefix  ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR}  --with-mvapich2 ${MVAPICH2_INSTALL} --with-openmpi ${OPENMPI_INSTALL} --with-mpich ${MPICH_INSTALL} --with-python ${PYTHON_INSTALL} --with-mvapich2 ${MVAPICH2_INSTALL}  2>&1     | tee install-tool_build-cbtf-all.log

./install-tool --build-oss --openss-prefix ${OSSCBTF_IDIR} --cbtf-install-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR}  --with-mvapich2 ${MVAPICH2_INSTALL} --with-openmpi ${OPENMPI_INSTALL} --with-mpich ${MPICH_INSTALL} --with-python ${PYTHON_INSTALL} --with-mvapich2 ${MVAPICH2_INSTALL} 2>&1 | tee install-tool_build-osscbtf.log

rm -rf  BUILD/falcon1/openspeedshop-2.3-cbtf
mv BUILD/falcon1/openspeedshop-2.3 BUILD/falcon1/openspeedshop-2.3-cbtf

./install-tool --build-offline --openss-prefix ${OSSOFF_IDIR} --krell-root-prefix ${KROOT_IDIR}  --with-mvapich2 ${MVAPICH2_INSTALL} --with-openmpi ${OPENMPI_INSTALL} --with-mpich ${MPICH_INSTALL} --with-python ${PYTHON_INSTALL}  2>&1 | tee install-tool_build-ossoff.log

rm -rf BUILD/falcon1/openspeedshop-2.3-offline
mv BUILD/falcon1/openspeedshop-2.3 BUILD/falcon1/openspeedshop-2.3-offline

# Build graphviz for support of building the new cbtf-argonavis-gui
#./install-tool --build-graphviz --krell-root-prefix ${GRAPHVIZ_IDIR} 2>&1 | tee install-tool_build-graphviz.log

# Build QtGraph for support of building the new cbtf-argonavis-gui, uses graphviz
#./install-tool --build-QtGraph --krell-root-prefix ${QTGRAPH_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-qt /usr/lib64/qt4 --with-boost ${KROOT_IDIR}  2>&1 | tee install-tool_build-QtGraph.log

# Build new cbtf-argonavis-gui, uses graphviz and QtGraph
#./install-tool --build-cbtfargonavisgui --with-openss ${OSSCBTF_IDIR} --with-cbtf ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-QtGraph ${QTGRAPH_IDIR} --with-boost ${KROOT_IDIR} --with-qt /usr/lib64/qt4 2>&1 | tee install-tool_build-cbtfargogui.log


cp /apps/local/easybuild/software/GCCcore/4.9.3//lib64/libstdc++.so.6 ${BASE_IDIR}/krellroot${TOOL_VERS}/lib64/.
#cp /apps/local/easybuild/software/GCCcore/6.3.0/lib64/libstdc++.so.6 ${BASE_IDIR}/krellroot${TOOL_VERS}/lib64/.
