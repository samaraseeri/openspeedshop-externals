#!/bin/bash

. /opt/modules/default/init/bash

#module load PrgEnv-intel/6.0.3
#module load /opt/cray/ari/modulefiles/alps/6.1.3-17.12
module load /global/homes/j/jgalaro/privatemodules/cori-cmake-3.2.2
#module load intel/16.0.3.210.nersc
module load boost/1.61
module list
module list  > build_compute.txt

export cc=icc
export CC=icc
export CXX=icpc

BASE_DIR=/project/projectdirs/m888/jgalaro/openss
TOOL_VERS="_v2.2.4"

MPICH_DIR=/opt/cray/pe/mpt/7.4.0/gni/mpich-gnu/5.1
ALPS_DIR=/opt/cray/alps/6.1.3-17.12
BOOST_DIR=/usr/common/software/boost/1.61/hsw/intel

./install-tool --build-compiler intel --build-krell-root --target-shared --target-arch cray --runtime-only --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-alps ${ALPS_DIR} --with-boost ${BOOST_DIR} --with-mpich ${MPICH_DIR}

./install-tool --build-compiler intel --build-offline --target-shared --target-arch cray --runtime-only --openss-prefix ${BASE_DIR}/ossoff${TOOL_VERS}/compute --krell-root-install-prefix ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-boost ${BOOST_DIR} --with-mpich ${MPICH_DIR} 

./install-tool --build-compiler intel --build-cbtf-all --runtime-only --target-arch cray --target-shared --cbtf-prefix ${BASE_DIR}/cbtf${TOOL_VERS}/compute --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-boost ${BOOST_DIR} --with-mpich ${MPICH_DIR}



# ----------------------------------
# For LOGIN NODE builds
# ----------------------------------


module unload craype-haswell 
#module load /global/homes/j/jgalaro/privatemodules/cori-cmake-3.2.2
#module load cudatoolkit
module unload cray-mpich/7.4.0 cray-shmem/7.4.0
module unload craype-network-aries
module load craype-network-none
#module load /opt/cray/ari/modulefiles/alps/6.1.3-17.12
#module load intel/16.0.3.210.nersc
#module load boost/1.61

module list
module list  > build_login.txt

MPICH_DIR=/opt/cray/pe/mpt/7.4.0/gni/mpich-gnu/5.1

export cc=icc
export CC=icc
export CXX=icpc

./install-tool --build-compiler intel --build-expat --krell-root-install-prefix ${BASE_DIR}/expat-2.1.0

./install-tool --build-compiler intel --build-krell-root --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-alps ${ALPS_DIR} --with-boost ${BOOST_DIR} --with-expat ${BASE_DIR}/expat-2.1.0 --with-mpich ${MPICH_DIR}

./install-tool --build-compiler intel --build-offline --openss-prefix ${BASE_DIR}/ossoff${TOOL_VERS} --krell-root-install-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-boost ${BOOST_DIR} --with-runtime-dir ${BASE_DIR}/ossoff${TOOL_VERS}/compute --with-mpich ${MPICH_DIR} 

./install-tool --build-compiler intel --runtime-target-arch cray --build-cbtf-all --cbtf-prefix ${BASE_DIR}/cbtf${TOOL_VERS} --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-cn-boost ${BOOST_DIR} --with-cn-mrnet ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-xercesc ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-libmonitor ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-libunwind ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-dyninst ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-papi ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-cbtf-krell ${BASE_DIR}/cbtf${TOOL_VERS}/compute --with-cn-cbtf ${BASE_DIR}/cbtf${TOOL_VERS}/compute --with-binutils ${BASE_DIR}/krellroot${TOOL_VERS} --with-boost ${BOOST_DIR} --with-mrnet ${BASE_DIR}/krellroot${TOOL_VERS} --with-xercesc ${BASE_DIR}/krellroot${TOOL_VERS} --with-libmonitor ${BASE_DIR}/krellroot${TOOL_VERS} --with-libunwind ${BASE_DIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_DIR}/krellroot${TOOL_VERS} --with-papi ${BASE_DIR}/krellroot${TOOL_VERS} --with-alps ${ALPS_DIR} --with-mpich ${MPICH_DIR}

./install-tool --build-compiler intel --target-arch cray --build-onlyosscbtf --openss-prefix ${BASE_DIR}/osscbtf${TOOL_VERS} --with-cn-cbtf-krell ${BASE_DIR}/cbtf${TOOL_VERS}/compute --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-papi ${BASE_DIR}/krellroot${TOOL_VERS} --with-boost ${BOOST_DIR} --with-mrnet ${BASE_DIR}/krellroot${TOOL_VERS} --with-xercesc ${BASE_DIR}/krellroot${TOOL_VERS} --with-libmonitor ${BASE_DIR}/krellroot${TOOL_VERS} --with-libunwind ${BASE_DIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_DIR}/krellroot${TOOL_VERS} --with-libelf ${BASE_DIR}/krellroot${TOOL_VERS} --with-libdwarf ${BASE_DIR}/krellroot${TOOL_VERS} --with-binutils ${BASE_DIR}/krellroot${TOOL_VERS} --cbtf-prefix ${BASE_DIR}/cbtf${TOOL_VERS} --with-mpich ${MPICH_DIR}

