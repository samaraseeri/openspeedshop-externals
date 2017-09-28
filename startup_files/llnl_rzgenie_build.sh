#!/bin/bash

#use .adept

. /usr/share/lmod/6.5/init/bash
module load gcc/4.9.3

export cc=gcc
export CC=gcc
export CXX=g++


export BASE_IDIR=/collab/usr/global/tools/openspeedshop/oss-dev/x8664/cts1
export ROOT_VERS="_v2.3.1.timer3"
export TOOL_VERS="_v2.3.1.timer3"
export MPICH_IDIR=/usr/tce/packages/impi/impi-5.1.3-gcc-4.9.3
export MVAPICH2_IDIR=/usr/tce/packages/mvapich2/mvapich2-2.2-gcc-4.9.3
export MVAPICH_IDIR=/opt
export OPENMPI_IDIR=/usr/tce/packages/openmpi/openmpi-2.0.0-gcc-4.9.3
export KROOT_IDIR=${BASE_IDIR}/krellroot${ROOT_VERS}
export CBTF_IDIR=${BASE_IDIR}/cbtf${TOOL_VERS}
export OSSCBTF_IDIR=${BASE_IDIR}/osscbtf${TOOL_VERS}
#export CUDATOOLKIT_IDIR=/opt/cudatoolkit-7.5
#export CUDATOOLKIT_CUPTI_IDIR=/opt/cudatoolkit-7.5/extras/CUPTI
#export PYTHON_IDIR=/usr/local/tools/python-2.7.7
#export PYTHON_VERS="2.7"

# -----------------------------------------------------
# Build krellroot_latest
# -----------------------------------------------------

./install-tool --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-mvapich2 ${MVAPICH2_IDIR} --with-mpich ${MPICH_IDIR} 

# -----------------------------------------------------
# Build cbtf,cbtf-krell, cbtf-argonavis, cbtf-lanl using krellroot_latest from above build
# -----------------------------------------------------

./install-tool --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-mvapich2 ${MVAPICH2_IDIR} --with-mpich ${MPICH_IDIR}

# -----------------------------------------------------
# Build offline using krellroot_latest from above build
# -----------------------------------------------------

#./install-tool --build-offline --openss-prefix ${OSSOFF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-mvapich2 ${MVAPICH2_IDIR} --with-mpich ${MPICH_IDIR} 


# -----------------------------------------------------
# Build OpenSpeedShop for cbtf instrumentor using cbtf_latest and krellroot_latest from above builds
# -----------------------------------------------------

./install-tool --build-oss --openss-prefix ${OSSCBTF_IDIR} --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-mvapich2 ${MVAPICH2_IDIR} --with-mpich ${MPICH_IDIR}


cp /usr/tce/packages/gcc/gcc-4.9.3//lib64/libstdc++.so.6 ${KROOT_IDIR}/lib64/libstdc++.so.6


