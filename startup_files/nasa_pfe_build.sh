#!/bin/bash

. /usr/share/modules/init/bash
module load gcc/4.9.3 cmake cuda/7.5 python/2.7.9

BASE_DIR=/nobackupnfs2/jgalarow/OSS
TOOL_VERS="_v2.2.4"
QT_DIR=/usr/lib64/qt3
CUDA_DIR=/nasa/cuda/7.5
CUPTI_DIR=/nasa/cuda/7.5/extras/CUPTI
PYTHON_DIR=/nasa/python/2.7.9
MPICH_DIR=/nasa/intel/impi/5.0.3.048/intel64
MPT_DIR=/nasa/sgi/mpt/2.12r26
MVAPICH2_DIR=/nasa/mvapich2/2.0/intel
OPENMPI_DIR=/nasa/openmpi/1.6.5/gcc
KRELLROOT_DIR=${BASE_DIR}/krellroot${TOOL_VERS}
CBTF_DIR=${BASE_DIR}/cbtf${TOOL_VERS}
OSSCBTF_DIR=${BASE_DIR}/osscbtf${TOOL_VERS}
OSSOFF_DIR=${BASE_DIR}/ossoff${TOOL_VERS}


#
# BUILD krellroot components used by cbtf and OSS
#
./install-tool --build-krell-root --krell-root-prefix ${KRELLROOT_DIR} --with-mpt ${MPT_DIR} --with-openmpi ${OPENMPI_DIR} --with-mpich ${MPICH_DIR} --with-mvapich2 ${MVAPICH2_DIR} --with-python ${PYTHON_DIR} --with-cupti ${CUPTI_DIR} --with-cuda ${CUDA_DIR} --force-boost-build

#
# BUILD offline using the krellroot components
#
./install-tool --build-offline --openss-prefix ${OSSOFF_DIR} --krell-root-prefix ${KRELLROOT_DIR} --with-mpt ${MPT_DIR} --with-openmpi ${OPENMPI_DIR} --with-mpich ${MPICH_DIR} --with-mvapich2 ${MVAPICH2_DIR} --with-python ${PYTHON_DIR} --with-qt3 ${QT_DIR}

#
# BUILD cbtf using the krellroot components
#
./install-tool --build-cbtf-all --cbtf-install-prefix  ${CBTF_DIR} --krell-root-prefix ${KRELLROOT_DIR} --with-mpt ${MPT_DIR} --with-openmpi ${OPENMPI_DIR} --with-mpich ${MPICH_DIR} --with-mvapich2 ${MVAPICH2_DIR} --with-cupti ${CUPTI_DIR} --with-cuda ${CUDA_DIR} --with-python ${PYTHON_DIR}

#
# BUILD oss/cbtf using the krellroot and cbtf components
#
./install-tool --build-onlyosscbtf --openss-prefix ${OSSCBTF_DIR} --cbtf-install-prefix ${CBTF_DIR} --krell-root-prefix ${KRELLROOT_DIR} --with-mpt ${MPT_DIR} --with-openmpi ${OPENMPI_DIR} --with-mpich ${MPICH_DIR} --with-mvapich2 ${MVAPICH2_DIR}  --with-cupti ${CUPTI_DIR} --with-cuda ${CUDA_DIR} --with-python ${PYTHON_DIR} --with-qt3 ${QT_DIR}

#
# Since building with a compiler installed in a non-standard location, OSS needs to find libstdc++ when executing.
# Copy the library into the root directory where it will be seen.
cp /nasa/pkgsrc/2015Q4/gcc49/lib64/libstdc++.so.6 ${BASE_DIR}/krellroot${TOOL_VERS}/lib64/libstdc++.so.6

