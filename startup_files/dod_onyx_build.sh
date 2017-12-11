#!/bin/bash 

# -----------------------------
# First Build the compute node version (root and oss versions if you use the recommended krell externals root build):
# For COMPUTE NODE builds:
# ----------------------------------

. /opt/modules/default/init/bash

module unload PrgEnv-cray PrgEnv-pgi PrgEnv-gnu PrgEnv-intel
module unload gcc
module unload gcc/5.3.0
module unload gcc/4.8.2
module load PrgEnv-gnu
module load craype-broadwell
module load gcc

export CC=gcc
export CXX=g++
#BASE_IDIR=/p/home/galarowi/openss
BASE_IDIR=/p/app/unsupported/PETtools/CE/pkgs/openss

export TOOL_VERS="_v2.3.1.release"
export ROOT_VERS="_v2.3.1.release"
export GRAPHVIZ_VERS="-2.40.1"
export QTGRAPH_VERS="-1.0.0"

export MPICH_IDIR=/opt/cray/pe/mpt/7.5.2/gni/mpich-gnu/5.1
export KROOT_IDIR=${BASE_IDIR}/krellroot${ROOT_VERS}
export CBTF_IDIR=${BASE_IDIR}/cbtf${TOOL_VERS}
export OSSCBTF_IDIR=${BASE_IDIR}/osscbtf${TOOL_VERS}
export OSSOFF_IDIR=${BASE_IDIR}/ossoff${TOOL_VERS}
export ALPS_IDIR=/opt/cray/alps/6.3.4-2.21
export CUDA_IDIR=/opt/nvidia/cudatoolkit8.0/8.0.54_2.3.12_g180d272-2.2
export CUPTI_IDIR=/opt/nvidia/cudatoolkit8.0/8.0.54_2.3.12_g180d272-2.2/extras/CUPTI

export GRAPHVIZ_IDIR=${BASE_IDIR}/graphviz${GRAPHVIZ_VERS}
export QTGRAPH_IDIR=${BASE_IDIR}/QtGraph${QTGRAPH_VERS}


##./install-tool --use-cti --runtime-only --target-arch cray --target-shared --build-krell-root --krell-root-prefix ${KROOT_IDIR}/compute --with-mpich ${MPICH_IDIR} --with-cti /opt/cray/pe/cti/1.0.4 

./install-tool --runtime-only --target-arch cray --target-shared --build-krell-root --krell-root-prefix ${KROOT_IDIR}/compute --with-mpich ${MPICH_IDIR} --with-alps ${ALPS_IDIR}

##./install-tool --build-cbtf-all --runtime-only --target-arch cray --target-shared --cbtf-prefix ${CBTF_IDIR}/compute --krell-root-prefix  ${KROOT_IDIR}/compute --with-mpich ${MPICH_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR} --with-cti /opt/cray/pe/cti/1.0.4

./install-tool --build-cbtf-all --runtime-only --target-arch cray --target-shared --cbtf-prefix ${CBTF_IDIR}/compute --krell-root-prefix  ${KROOT_IDIR}/compute --with-mpich ${MPICH_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR} --with-alps ${ALPS_IDIR}

##./install-tool --runtime-only --target-arch cray --target-shared --build-offline --openss-prefix ${OSSOFF_IDIR}/compute --krell-root-prefix ${KROOT_IDIR}/compute --with-mpich ${MPICH_IDIR} 

# -----------------------------
# Next build the login node version (root and oss versions if you use the recommended krell externals root build):
# For LOGIN NODE builds:
# ----------------------------------

module unload PrgEnv-cray PrgEnv-gnu craype-broadwell
module unload gcc
module unload gcc/5.3.0
module unload gcc/4.8.2
module load gcc

export cc=gcc
export CC=gcc
export CXX=g++

##./install-tool --use-cti --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-cti /opt/cray/pe/cti/1.0.4 

./install-tool --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-alps ${ALPS_IDIR}

##./install-tool --runtime-target-arch cray --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-cn-boost ${KROOT_IDIR}/compute --with-cn-mrnet ${KROOT_IDIR}/compute --with-cn-xercesc ${KROOT_IDIR}/compute --with-cn-libmonitor ${KROOT_IDIR}/compute --with-cn-libunwind ${KROOT_IDIR}/compute --with-cn-dyninst ${KROOT_IDIR}/compute --with-cn-papi ${KROOT_IDIR}/compute --with-cn-cbtf-krell ${CBTF_IDIR}/compute --with-cn-cbtf ${CBTF_IDIR}/compute --with-binutils ${KROOT_IDIR} --with-boost ${KROOT_IDIR} --with-mrnet ${KROOT_IDIR} --with-xercesc ${KROOT_IDIR} --with-libmonitor ${KROOT_IDIR} --with-libunwind ${KROOT_IDIR} --with-dyninst ${KROOT_IDIR} --with-papi ${KROOT_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR} --with-cti /opt/cray/pe/cti/1.0.4

./install-tool --runtime-target-arch cray --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-cn-boost ${KROOT_IDIR}/compute --with-cn-mrnet ${KROOT_IDIR}/compute --with-cn-xercesc ${KROOT_IDIR}/compute --with-cn-libmonitor ${KROOT_IDIR}/compute --with-cn-libunwind ${KROOT_IDIR}/compute --with-cn-dyninst ${KROOT_IDIR}/compute --with-cn-papi ${KROOT_IDIR}/compute --with-cn-cbtf-krell ${CBTF_IDIR}/compute --with-cn-cbtf ${CBTF_IDIR}/compute --with-binutils ${KROOT_IDIR} --with-boost ${KROOT_IDIR} --with-mrnet ${KROOT_IDIR} --with-xercesc ${KROOT_IDIR} --with-libmonitor ${KROOT_IDIR} --with-libunwind ${KROOT_IDIR} --with-dyninst ${KROOT_IDIR} --with-papi ${KROOT_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR} --with-alps ${ALPS_IDIR}

./install-tool --target-arch cray --build-oss --openss-prefix ${OSSCBTF_IDIR} --with-cn-cbtf-krell ${CBTF_IDIR}/compute --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-boost ${KROOT_IDIR} --with-mrnet ${KROOT_IDIR} --with-xercesc ${KROOT_IDIR} --with-libmonitor ${KROOT_IDIR} --with-libunwind ${KROOT_IDIR} --with-dyninst ${KROOT_IDIR} --with-libelf ${KROOT_IDIR} --with-libdwarf ${KROOT_IDIR} --with-binutils ${KROOT_IDIR} --cbtf-prefix ${CBTF_IDIR} --with-papi ${KROOT_IDIR} --with-cuda ${CUDA_IDIR} --with-cupti ${CUPTI_IDIR} --with-alps ${ALPS_IDIR}

##rm -rf BUILD/onyx08/openspeedshop-2.3-cbtf
##mv BUILD/onyx08/openspeedshop-2.3 BUILD/onyx01/openspeedshop-2.3-cbtf

##./install-tool --build-offline --openss-prefix ${OSSOFF_IDIR} --with-runtime-dir ${OSSOFF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_IDIR} --with-papi ${KROOT_IDIR} 


# Build graphviz for support of building the new cbtf-argonavis-gui
./install-tool --build-graphviz --krell-root-prefix ${GRAPHVIZ_IDIR}

# Build QtGraph for support of building the new cbtf-argonavis-gui, uses graphviz
./install-tool --build-QtGraph --krell-root-prefix ${QTGRAPH_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-qt /usr/lib64/qt4 --with-boost ${KROOT_IDIR}

# Build new cbtf-argonavis-gui, uses graphviz and QtGraph 
./install-tool --build-cbtfargonavisgui --with-openss ${OSSCBTF_IDIR} --with-cbtf ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-QtGraph ${QTGRAPH_IDIR} --with-qt /usr/lib64/qt4 --with-boost ${KROOT_IDIR}  2>&1 | tee install-tool_build-cbtfargogui.log


