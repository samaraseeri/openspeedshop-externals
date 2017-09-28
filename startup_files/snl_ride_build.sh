#!/bin/bash 

#set -x

export MODULESHOME=/home/projects/pwr8-rhel72/modules/3.2.10/Modules/3.2.10
. $MODULESHOME/init/sh

module purge
module load gcc/5.4.0
module load git

export cc=gcc
export CC=gcc
export CXX=g++

BASE_DIR=/home/jgalaro/openss
TOOL_VERS="_v2.3.1"
PYTHON_IDIR=${BASE_DIR}/python-2.7.3
PYTHON_VERS="2.7"
KROOT_IDIR=${BASE_DIR}/krellroot${TOOL_VERS}
CBTF_IDIR=${BASE_DIR}/cbtf${TOOL_VERS}
OSSCBTF_IDIR=${BASE_DIR}/osscbtf${TOOL_VERS}
OSSOFF_IDIR=${BASE_DIR}/ossoff${TOOL_VERS}
LTDL_IDIR=/home/projects/power8/libtool/2.4.6
CUDA_IDIR=/home/projects/pwr8/cuda/7.5.7
CUPTI_IDIR=/home/projects/pwr8/cuda/7.5.7/extras/CUPTI
OPENMPI_IDIR=/home/projects/power8/openmpi/1.10.0/gnu/4.9.2/cuda/7.5.7
PAPI_IDIR=/home/projects/power8/papi/5.4.1


./install-tool --target-arch power8 --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-papi ${PAPI_IDIR} --with-openmpi ${OPENMPI_IDIR} --force-sqlite-build

./install-tool --build-python --krell-root-prefix ${PYTHON_IDIR}

##./install-tool --build-offline --openss-prefix ${OSSOFF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-papi ${PAPI_IDIR} --with-python ${PYTHON_IDIR} --with-ltdl ${LTDL_IDIR} --with-openmpi ${OPENMPI_IDIR} 

./install-tool --target-arch power8 --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-papi ${PAPI_IDIR} --with-python ${PYTHON_IDIR} --with-ltdl ${LTDL_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR} --with-openmpi ${OPENMPI_IDIR}

./install-tool --target-arch power8 --build-onlyosscbtf --openss-prefix ${OSSCBTF_IDIR} --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-papi ${PAPI_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-python ${PYTHON_IDIR} --with-python-vers ${PYTHON_VERS} --with-ltdl ${LTDL_IDIR}

# On ride the libc and libstdc++ dso files are different on the FE and compute nodes
# need to copy in the one that the tool was built with
cp /home/projects/pwr8-rhel73-lsf/gcc/5.4.0/lib64/libstdc++.so.6 ${KROOT_IDIR}/lib64/.


