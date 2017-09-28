#!/bin/bash

#. /usr/share/lmod//6.5/init/bash


BASE_IDIR=/usr/projects/packages/openspeedshop/jegsgi/installs/woodchuck

# So we don't have to continually build the root
# separate the TOOL_VERS from the ROOT_VERS
#
TOOL_VERS="_v2.3.1.rc2"
CBTF_IDIR=${BASE_IDIR}/cbtf${TOOL_VERS}
OSSCBTF_IDIR=${BASE_IDIR}/osscbtf${TOOL_VERS}
OSSOFF_IDIR=${BASE_IDIR}/ossoff${TOOL_VERS}

# So we don't have to continually build the root
# separate the TOOL_VERS from the ROOT_VERS
#
ROOT_VERS="_v2.3.1.rc2"
ROOT_IDIR=${BASE_IDIR}/krellroot${ROOT_VERS}

QT_IDIR=/usr/lib64/qt3
CUDA_IDIR=/opt/cudatoolkit/8.0
CUPTI_IDIR=/opt/cudatoolkit/8.0/extras/CUPTI
MPICH_IDIR=/usr/projects/hpcsoft/toss3/common/intel-clusterstudio/2017.1.024/impi/2017.1.132
MPICH2_IDIR=/usr/projects/hpcsoft/toss3/common/intel-clusterstudio/2017.1.024/impi/2017.1.132
OPENMPI_IDIR=/usr/projects/hpcsoft/toss3/woodchuck/openmpi/1.10.5-gcc-4.8.5
PAPI_IDIR=/usr/projects/hpcsoft/toss3/common/papi/5.4.3


# -----------------------------------------------------
# Load cmake module and cudattoolkit module
# -----------------------------------------------------
#module load gcc/5.3.0 cmake cudatoolkit/7.5
module load cudatoolkit/8.0

cmake --version
gcc --version

# -----------------------------------------------------
# Build krellroot_${ROOT_VERS}
# -----------------------------------------------------

./install-tool --build-krell-root --krell-root-prefix ${ROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-cupti ${CUPTI_IDIR} --with-cuda ${CUDA_IDIR} --with-mpich ${MPICH_IDIR} --with-mpich2 ${MPICH2_IDIR} 
# -----------------------------------------------------
# Build cbtf,cbtf-krell, cbtf-argonavis, cbtf-lanl using krellroot_v${ROOT_VERS} from above build
# -----------------------------------------------------

./install-tool --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${ROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-cupti ${CUPTI_IDIR} --with-cuda ${CUDA_IDIR} --with-mpich ${MPICH_IDIR} --with-mpich2 ${MPICH2_IDIR}

# -----------------------------------------------------
# Build OpenSpeedShop for cbtf instrumentor using cbtf_${TOOL_VERS} and krellroot_${ROOT_VERS} from above builds
# -----------------------------------------------------

./install-tool --build-oss --openss-prefix ${OSSCBTF_IDIR} --cbtf-install-prefix ${CBTF_IDIR} --krell-root-prefix ${ROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-cupti ${CUPTI_IDIR} --with-cuda ${CUDA_IDIR} --with-mpich ${MPICH_IDIR} --with-mpich2 ${MPICH2_IDIR}

# -----------------------------------------------------
# Build offline using krellroot_${ROOT_VERS} from above build
# -----------------------------------------------------

#./install-tool --build-offline --openss-prefix ${OSSOFF_IDIR} --krell-root-prefix ${ROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-cupti ${CUPTI_IDIR} --with-cuda ${CUDA_IDIR} --with-mpich ${MPICH_IDIR} --with-mpich2 ${MPICH2_IDIR}



