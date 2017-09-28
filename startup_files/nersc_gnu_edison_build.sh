#!/bin/bash

. /opt/modules/default/init/bash

module unload PrgEnv-intel
module load PrgEnv-gnu
module load craype-ivybridge
module load cmake
module load gcc

export cc=gcc
export CC=gcc
export CXX=g++

BASE_DIR=/project/projectdirs/m888/jgalaro/edison/openss
TOOL_VERS="_v2.2.4_gnu_try2"

MPICH_DIR=/opt/cray/mpt/7.4.1/gni/mpich-gnu/5.1
BOOST_DIR=${BASE_DIR}/krellroot${TOOL_VERS}/compute

##./install-tool --use-cti --build-compiler gnu --build-mrnet --target-shared --target-arch cray --runtime-only --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS}/compute 

##./install-tool --build-compiler gnu --build-boost --target-shared --target-arch cray --runtime-only --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS}/compute 

./install-tool --use-cti --build-compiler gnu --build-krell-root --target-shared --target-arch cray --runtime-only --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-mpich ${MPICH_DIR} --force-boost-build

./install-tool --build-compiler gnu --build-cbtf-all --runtime-only --target-arch cray --target-shared --cbtf-prefix ${BASE_DIR}/cbtf${TOOL_VERS}/compute --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-boost ${BOOST_DIR} --with-mpich ${MPICH_DIR}


#./install-tool --build-compiler gnu --build-offline --target-shared --target-arch cray --runtime-only --openss-prefix ${BASE_DIR}/ossoff${TOOL_VERS}/compute --krell-root-install-prefix ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-boost ${BOOST_DIR} --with-mpich ${MPICH_DIR} 

# ----------------------------------
# For LOGIN NODE builds
# ----------------------------------


module unload craype-ivybridge 
#module load /global/homes/j/jgalaro/privatemodules/cori-cmake-3.2.2
#module load cudatoolkit
module unload cray-mpich/7.4.1 cray-shmem/7.4.1
module unload craype-network-aries
module load craype-network-none
module unload intel/15.0.1.133
module load gcc

MPICH_DIR=/opt/cray/mpt/7.4.1/gni/mpich-gnu/5.1
BOOST_DIR=${BASE_DIR}/krellroot${TOOL_VERS}

export cc=gcc
export CC=gcc
export CXX=g++

./install-tool --build-compiler gnu --build-expat --krell-root-install-prefix ${BASE_DIR}/expat-2.1.0

./install-tool --use-cti --build-compiler gnu --build-krell-root --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-expat ${BASE_DIR}/expat-2.1.0 --with-mpich ${MPICH_DIR} --force-boost-build


#./install-tool --build-compiler gnu --build-offline --openss-prefix ${BASE_DIR}/ossoff${TOOL_VERS} --krell-root-install-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-boost ${BOOST_DIR} --with-runtime-dir ${BASE_DIR}/ossoff${TOOL_VERS}/compute --with-mpich ${MPICH_DIR} 

./install-tool --build-compiler gnu --runtime-target-arch cray --build-cbtf-all --cbtf-prefix ${BASE_DIR}/cbtf${TOOL_VERS} --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-cn-boost ${BOOST_DIR} --with-cn-mrnet ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-xercesc ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-libmonitor ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-libunwind ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-dyninst ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-papi ${BASE_DIR}/krellroot${TOOL_VERS}/compute --with-cn-cbtf-krell ${BASE_DIR}/cbtf${TOOL_VERS}/compute --with-cn-cbtf ${BASE_DIR}/cbtf${TOOL_VERS}/compute --with-binutils ${BASE_DIR}/krellroot${TOOL_VERS} --with-boost ${BOOST_DIR} --with-mrnet ${BASE_DIR}/krellroot${TOOL_VERS} --with-xercesc ${BASE_DIR}/krellroot${TOOL_VERS} --with-libmonitor ${BASE_DIR}/krellroot${TOOL_VERS} --with-libunwind ${BASE_DIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_DIR}/krellroot${TOOL_VERS} --with-papi ${BASE_DIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_DIR}

./install-tool --build-compiler gnu --target-arch cray --build-onlyosscbtf --openss-prefix ${BASE_DIR}/osscbtf${TOOL_VERS} --with-cn-cbtf-krell ${BASE_DIR}/cbtf${TOOL_VERS}/compute --krell-root-prefix ${BASE_DIR}/krellroot${TOOL_VERS} --with-papi ${BASE_DIR}/krellroot${TOOL_VERS} --with-boost ${BOOST_DIR} --with-mrnet ${BASE_DIR}/krellroot${TOOL_VERS} --with-xercesc ${BASE_DIR}/krellroot${TOOL_VERS} --with-libmonitor ${BASE_DIR}/krellroot${TOOL_VERS} --with-libunwind ${BASE_DIR}/krellroot${TOOL_VERS} --with-dyninst ${BASE_DIR}/krellroot${TOOL_VERS} --with-libelf ${BASE_DIR}/krellroot${TOOL_VERS} --with-libdwarf ${BASE_DIR}/krellroot${TOOL_VERS} --with-binutils ${BASE_DIR}/krellroot${TOOL_VERS} --cbtf-prefix ${BASE_DIR}/cbtf${TOOL_VERS} --with-mpich ${MPICH_DIR}

cp /opt/gcc/6.1.0//snos/lib64/libstdc++.so.6 ${BASE_DIR}/krellroot${TOOL_VERS}/lib64/.
cp /opt/gcc/6.1.0//snos/lib64/libstdc++.so.6 ${BASE_DIR}/krellroot${TOOL_VERS}/compute/lib64/.

