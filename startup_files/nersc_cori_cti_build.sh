#!/bin/bash

. /opt/modules/default/init/bash

module unload PrgEnv-intel/6.0.4
module unload /opt/cray/pe/modulefiles/PrgEnv-intel/6.0.4
module load /opt/cray/pe/modulefiles/PrgEnv-gnu/6.0.4
#module load /opt/cray/ari/modulefiles/alps/6.1.3-17.12
#module load /opt/cray/ari/modulefiles/alps/5.2.4-2.0502.9774.31.11.ari
#module load /global/homes/j/jgalaro/privatemodules/cori-cmake-3.2.2
#module load cudatoolkit
#module load /opt/modulefiles/gcc/6.2.0
module load papi/5.5.1.2

export cc=gcc
export CC=gcc
export CXX=g++

export BASE_IDIR=/project/projectdirs/m888/jgalaro/openss/cori
export TOOL_VERS="_v2.3.1.u1"
export GRAPHVIZ_VERS="-2.40.1"
export QTGRAPH_VERS="-1.0.0"


#MPICH_DIR=/opt/cray/mpt/default/gni//mpich-gnu/5.1
#MPICH_DIR=/opt/cray/pe/mpt/7.5.3/gni/mpich-gnu/5.1
export MPICH_DIR=/opt/cray/pe/mpt/7.6.2/gni/mpich-gnu/5.1
#ALPS_DIR=/opt/cray/alps/5.2.4-2.0502.9774.31.11.ari
#ALPS_DIR=/opt/cray/alps/6.1.3-17.12
#ALPS_DIR=/opt/cray/alps/6.4.1-6.0.4.0_7.2__g86d0f3d.ari
#BOOST_DIR=/usr/common/software/boost/1.59/hsw/gnu
export PAPI_IDIR=/opt/cray/pe/papi/5.5.1.3
export KROOT_IDIR=${BASE_IDIR}/krellroot${TOOL_VERS}
export CBTF_IDIR=${BASE_IDIR}/cbtf${TOOL_VERS}
export OSSCBTF_IDIR=${BASE_IDIR}/osscbtf${TOOL_VERS}
export GRAPHVIZ_IDIR=${BASE_IDIR}/graphviz${GRAPHVIZ_VERS}
export QTGRAPH_IDIR=${BASE_IDIR}/QtGraph${QTGRAPH_VERS}
export CTI_IDIR=/opt/cray/pe/cti/1.0.6


./install-tool --build-krell-root --target-shared --target-arch cray --runtime-only --krell-root-prefix ${KROOT_IDIR}/compute --with-mpich ${MPICH_DIR} --force-boost-build --with-cti ${CTI_IDIR} --with-papi ${PAPI_IDIR} 2>&1 | tee install_tool_build_compute_root${TOOLVERS}.log

./install-tool --build-cbtf-all --runtime-only --target-arch cray --target-shared --cbtf-prefix ${CBTF_IDIR}/compute --krell-root-prefix ${KROOT_IDIR}/compute --with-mpich ${MPICH_DIR} --with-papi ${PAPI_IDIR} 2>&1 | tee install_tool_build_compute_cbtf${TOOLVERS}.log

# ALTERNATIVE BUILDS
#./install-tool --use-cti --build-llvm-openmp --target-shared --target-arch cray --runtime-only --krell-root-prefix ${KROOT_IDIR}/compute  2>&1 | tee install_tool_build_compute_ompt.log

#./install-tool --use-cti --build-dyninst --target-shared --target-arch cray --runtime-only --krell-root-prefix ${BASE_IDIR}/krellroot${TOOL_VERS}/compute  --with-cti /opt/cray/pe/cti/1.0.6 --with-libdwarf ${KROOT_IDIR}/compute --with-libelf ${KROOT_IDIR}/compute --with-binutils ${KROOT_IDIR}/compute --with-boost ${KROOT_IDIR}/compute

#./install-tool --build-offline --target-shared --target-arch cray --runtime-only --openss-prefix ${BASE_IDIR}/ossoff${TOOL_VERS}/compute --krell-root-install-prefix ${BASE_IDIR}/krellroot${TOOL_VERS}/compute --with-mpich ${MPICH_DIR} --with-papi ${PAPI_IDIR}

# ----------------------------------
# For LOGIN NODE builds
# ----------------------------------


module unload /opt/cray/pe/modulefiles/PrgEnv-gnu/6.0.4
module unload /opt/cray/pe/craype/2.5.5/modulefiles/craype-haswell 
#module load cudatoolkit
module unload /opt/cray/pe/modulefiles/cray-mpich/7.6.0 /opt/cray/pe/modulefiles/cray-shmem/7.6.0
module unload /opt/cray/pe/modulefiles/cray-mpich/7.6.2 /opt/cray/pe/modulefiles/cray-shmem/7.6.2
module unload /opt/cray/pe/modulefiles/cray-mpich/7.4.4 /opt/cray/pe/modulefiles/cray-shmem/7.4.4
module unload /opt/cray/pe/craype/2.5.5/modulefiles/craype-network-aries
#module load /opt/cray/pe/craype/2.5.5/modulefiles/craype-network-none
module load papi/5.5.1.3
#module load /opt/cray/ari/modulefiles/alps/6.1.3-17.12
#module load /opt/cray/ari/modulefiles/alps/6.1.3-17.12
#module load /opt/modulefiles/gcc/6.2.0

#./install-tool --build-boost  --krell-root-prefix ${KROOT_IDIR}  2>&1 | tee install_tool_build_login_boost${TOOLVERS}.log

./install-tool --build-krell-root  --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_DIR} --with-boost ${KROOT_IDIR} --with-cti ${CTI_IDIR} --with-papi ${PAPI_IDIR} 2>&1 | tee install_tool_build_login_kroot${TOOLVERS}.log

./install-tool --runtime-target-arch cray --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_DIR} --with-cn-boost ${KROOT_IDIR}/compute --with-cn-mrnet ${KROOT_IDIR}/compute --with-cn-xercesc ${KROOT_IDIR}/compute --with-cn-libmonitor ${KROOT_IDIR}/compute --with-cn-libunwind ${KROOT_IDIR}/compute --with-cn-dyninst ${KROOT_IDIR}/compute --with-cn-papi ${PAPI_IDIR} --with-cn-cbtf-krell ${CBTF_IDIR}/compute --with-cn-cbtf ${CBTF_IDIR}/compute --with-binutils ${KROOT_IDIR} --with-boost ${KROOT_IDIR} --with-mrnet ${KROOT_IDIR} --with-xercesc ${KROOT_IDIR} --with-libmonitor ${KROOT_IDIR} --with-libunwind ${KROOT_IDIR} --with-dyninst ${KROOT_IDIR}  --with-papi ${PAPI_IDIR} 2>&1 | tee install_tool_build_login_cbtf${TOOLVERS}.log

./install-tool --target-arch cray --build-oss --openss-prefix ${OSSCBTF_IDIR} --with-cn-cbtf-krell ${CBTF_IDIR}/compute --krell-root-prefix ${KROOT_IDIR} --with-mpich ${MPICH_DIR} --with-boost ${KROOT_IDIR} --with-mrnet ${KROOT_IDIR} --with-xercesc ${KROOT_IDIR} --with-libmonitor ${KROOT_IDIR} --with-libunwind ${KROOT_IDIR} --with-dyninst ${KROOT_IDIR} --with-libelf ${KROOT_IDIR} --with-libdwarf ${KROOT_IDIR} --with-binutils ${KROOT_IDIR} --cbtf-prefix ${CBTF_IDIR} --with-papi ${PAPI_IDIR} 2>&1 | tee install_tool_build_login_osscbtf${TOOLVERS}.log

# Build graphviz for support of building the new cbtf-argonavis-gui
#./install-tool --build-graphviz --krell-root-prefix ${GRAPHVIZ_IDIR} 2>&1 | tee install_tool_build_graphviz${TOOLVERS}.log

# Build QtGraph for support of building the new cbtf-argonavis-gui, uses graphviz
#./install-tool --build-QtGraph --krell-root-prefix ${QTGRAPH_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-qt /usr/lib64/qt4 2>&1 | tee install_tool_build_QtGraph${TOOLVERS}.log

# Build new cbtf-argonavis-gui, uses graphviz and QtGraph 
#./install-tool --build-cbtfargonavisgui --with-openss ${OSSCBTF_IDIR} --with-cbtf ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-graphviz ${GRAPHVIZ_IDIR} --with-QtGraph ${QTGRAPH_IDIR} --with-boost ${KROOT_IDIR} --with-qt /usr/lib64/qt4 2>&1 | tee install_tool_build_cbtf_gui${TOOLVERS}.log



# ALTERNATIVE BUILDS
#./install-tool --use-cti --build-mrnet  --krell-root-prefix ${BASE_IDIR}/krellroot${TOOL_VERS} --with-boost ${BASE_IDIR}/krellroot${TOOL_VERS} --with-cti /opt/cray/pe/cti/1.0.6 
#./install-tool --build-offline --openss-prefix ${BASE_IDIR}/oss_offline${TOOL_VERS} --krell-root-install-prefix ${BASE_IDIR}/krellroot${TOOL_VERS} --with-boost ${BASE_IDIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_DIR} --with-runtime-dir ${BASE_IDIR}/oss_offline${TOOL_VERS}/compute --with-papi ${PAPI_IDIR}

#mv BUILD/cori12/openspeedshop-2.3 BUILD/cori12/openspeedshop-2.3-offline
#./install-tool --build-cbtfargonavisgui --openss-prefix ${BASE_IDIR}/osscbtf${TOOL_VERS} --krell-root-prefix ${BASE_IDIR}/krellroot${TOOL_VERS} --with-boost ${BASE_IDIR}/krellroot${TOOL_VERS} --with-mrnet ${BASE_IDIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_IDIR}/krellroot${TOOL_VERS} --cbtf-prefix ${BASE_IDIR}/cbtf${TOOL_VERS} --with-qt /usr/lib64/qt4
