#!/bin/bash 

#set -x

export MODULESHOME=/usr/share/Modules
. $MODULESHOME/init/sh

module purge
module load git 
#module load gcc/5.4.0

export cc=gcc
export CC=gcc
export CXX=g++

BASE_DIR=/home/jgalaro/openss
TOOL_VERS="_v2.3.1.485"
PYTHON_IDIR=${BASE_DIR}/python-2.7.3
PYTHON_VERS="2.7"
KROOT_IDIR=${BASE_DIR}/krellroot${TOOL_VERS}
CBTF_IDIR=${BASE_DIR}/cbtf${TOOL_VERS}
OSSCBTF_IDIR=${BASE_DIR}/osscbtf${TOOL_VERS}
OSSOFF_IDIR=${BASE_DIR}/ossoff${TOOL_VERS}
LTDL_IDIR=/home/projects/power8/libtool/2.4.6
CUDA_IDIR=/home/projects/pwr8-rhel73-lsf/cuda/8.0.44
CUPTI_IDIR=/home/projects/pwr8-rhel73-lsf/cuda/8.0.44/extras/CUPTI
OPENMPI_IDIR=/home/projects/pwr8-rhel73-lsf/openmpi/1.10.4/gcc/5.4.0/cuda/8.0.44

./install-tool --build-autotools --krell-root-prefix ${LTDL_IDIR}
./install-tool --build-python --krell-root-prefix ${PYTHON_IDIR}

./install-tool --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-ltdl ${LTDL_IDIR}

./install-tool --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-python ${PYTHON_IDIR} --with-ltdl ${LTDL_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR} --with-openmpi ${OPENMPI_IDIR}

./install-tool --build-oss --openss-prefix ${OSSCBTF_IDIR} --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-openmpi ${OPENMPI_IDIR} --with-python ${PYTHON_IDIR} --with-python-vers ${PYTHON_VERS} --with-ltdl ${LTDL_IDIR}

#./install-tool --build-offline --openss-prefix ${OSSOFF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-python ${PYTHON_IDIR} --with-ltdl ${LTDL_IDIR} --with-openmpi ${OPENMPI_IDIR} 
#cp /home/projects/pwr8-rhel73-lsf/gcc/5.4.0/lib64/libstdc++.so.6 ${KROOT_IDIR}/lib64/.


