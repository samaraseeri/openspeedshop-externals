#!/bin/bash

. /opt/modules/default/init/bash

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

BASE_DIR=/project/projectdirs/m888/jgalaro/openss/cori
TOOL_VERS="_v2.3.1.rc6.cti"

#MPICH_DIR=/opt/cray/mpt/default/gni//mpich-gnu/5.1
#MPICH_DIR=/opt/cray/pe/mpt/7.5.3/gni/mpich-gnu/5.1
MPICH_DIR=/opt/cray/pe/mpt/7.6.0/gni/mpich-gnu/5.1
#ALPS_DIR=/opt/cray/alps/5.2.4-2.0502.9774.31.11.ari
#ALPS_DIR=/opt/cray/alps/6.1.3-17.12
#BOOST_DIR=/usr/common/software/boost/1.59/hsw/gnu
PAPI_IDIR=/opt/cray/pe/papi/5.5.1.2
KROOT_IDIR=${BASE_DIR}/krellroot${TOOL_VERS}

./install-tool --use-cti --build-krell-root --target-shared --target-arch cray --runtime-only --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-mpich ${MPICH_DIR} --force-boost-build --with-cti /opt/cray/pe/cti/1.0.6 --with-papi ${PAPI_IDIR}

#./install-tool --use-cti --build-dyninst --target-shared --target-arch cray --runtime-only --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS}/compute  --with-cti /opt/cray/pe/cti/1.0.6 --with-libdwarf ${KROOT_IDIR}/compute --with-libelf ${KROOT_IDIR}/compute --with-binutils ${KROOT_IDIR}/compute --with-boost ${KROOT_IDIR}/compute

#./install-tool --build-offline --target-shared --target-arch cray --runtime-only --openss-prefix ${BASE_DIR}/ossoff${TOOL_VERS}/compute --krell-root-install-prefix ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-mpich ${MPICH_DIR} --with-papi ${PAPI_IDIR}


./install-tool --build-cbtf-all --runtime-only --target-arch cray --target-shared --cbtf-prefix ${BASE_DIR}/cbtf${TOOL_VERS}/compute --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-mpich ${MPICH_DIR} --with-papi ${PAPI_IDIR}


# ----------------------------------
# For LOGIN NODE builds
# ----------------------------------


module unload /opt/cray/pe/modulefiles/PrgEnv-gnu/6.0.4
module unload /opt/cray/pe/craype/2.5.5/modulefiles/craype-haswell 
#module load cudatoolkit
module unload /opt/cray/pe/modulefiles/cray-mpich/7.6.0 /opt/cray/pe/modulefiles/cray-shmem/7.6.0
module unload /opt/cray/pe/modulefiles/cray-mpich/7.4.4 /opt/cray/pe/modulefiles/cray-shmem/7.4.4
module unload /opt/cray/pe/craype/2.5.5/modulefiles/craype-network-aries
#module load /opt/cray/pe/craype/2.5.5/modulefiles/craype-network-none
module load papi/5.5.1.2
#module load /opt/cray/ari/modulefiles/alps/6.1.3-17.12
#module load /opt/cray/ari/modulefiles/alps/6.1.3-17.12
#module load /opt/modulefiles/gcc/6.2.0

#./install-tool --use-cti --build-mrnet  --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-boost ${BASE_DIR}/krellroot${TOOL_VERS} --with-cti /opt/cray/pe/cti/1.0.6 

./install-tool --use-cti --build-krell-root  --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_DIR} --force-boost-build --with-cti /opt/cray/pe/cti/1.0.6 --with-papi ${PAPI_IDIR}

#./install-tool --build-offline --openss-prefix ${BASE_DIR}/oss_offline${TOOL_VERS} --krell-root-install-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-boost ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_DIR} --with-runtime-dir ${BASE_DIR}/oss_offline${TOOL_VERS}/compute --with-papi ${PAPI_IDIR}

#mv BUILD/cori12/openspeedshop-2.3 BUILD/cori12/openspeedshop-2.3-offline

./install-tool --runtime-target-arch cray --build-cbtf-all --cbtf-prefix ${BASE_DIR}/cbtf${TOOL_VERS} --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_DIR} --with-cn-boost ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-mrnet ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-xercesc ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-libmonitor ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-libunwind ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-dyninst ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-papi ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-cbtf-krell ${BASE_DIR}/cbtf${TOOL_VERS}/compute --with-cn-cbtf ${BASE_DIR}/cbtf${TOOL_VERS}/compute --with-binutils ${BASE_DIR}/krellroot${TOOL_VERS} --with-boost ${BASE_DIR}/krellroot${TOOL_VERS} --with-mrnet ${BASE_DIR}/krellroot${TOOL_VERS} --with-xercesc ${BASE_DIR}/krellroot${TOOL_VERS} --with-libmonitor ${BASE_DIR}/krellroot${TOOL_VERS} --with-libunwind ${BASE_DIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_DIR}/krellroot${TOOL_VERS}  --with-papi ${PAPI_IDIR}

./install-tool --target-arch cray --build-oss --openss-prefix ${BASE_DIR}/osscbtf${TOOL_VERS} --with-cn-cbtf-krell ${BASE_DIR}/cbtf${TOOL_VERS}/compute --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_DIR} --with-boost ${BASE_DIR}/krellroot${TOOL_VERS} --with-mrnet ${BASE_DIR}/krellroot${TOOL_VERS} --with-xercesc ${BASE_DIR}/krellroot${TOOL_VERS} --with-libmonitor ${BASE_DIR}/krellroot${TOOL_VERS} --with-libunwind ${BASE_DIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_DIR}/krellroot${TOOL_VERS} --with-libelf ${BASE_DIR}/krellroot${TOOL_VERS} --with-libdwarf ${BASE_DIR}/krellroot${TOOL_VERS} --with-binutils ${BASE_DIR}/krellroot${TOOL_VERS} --cbtf-prefix ${BASE_DIR}/cbtf${TOOL_VERS} --with-papi ${PAPI_IDIR}

./install-tool --build-cbtfargonavisgui --openss-prefix ${BASE_DIR}/osscbtf${TOOL_VERS} --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-boost ${BASE_DIR}/krellroot${TOOL_VERS} --with-mrnet ${BASE_DIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_DIR}/krellroot${TOOL_VERS} --cbtf-prefix ${BASE_DIR}/cbtf${TOOL_VERS} --with-qt /usr/lib64/qt4
