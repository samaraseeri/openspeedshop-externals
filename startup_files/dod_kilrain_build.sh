#!/bin/bash

. /site/modules/modules-3.2.9c/Modules/3.2.9/init/bash
module purge
module load gcc/4.8.2

export cc=gcc
export CC=gcc
export CXX=g++

export BASE_IDIR=/site/PET/pkgs/openss
export TOOL_VERS="_v2.2.3"
export OPENMPI_ROOT=/site/openmpi/gnu/1.6.5
export MPICH_ROOT=/site/intel/impi/4.1.3.048/intel64


./install-tool --build-cmake --krell-root-install-prefix ${BASE_IDIR}/cmake-3.2.2
export PATH=${BASE_IDIR}/cmake-3.2.2/bin:$PATH

./install-tool --build-autotools --krell-root-install-prefix ${BASE_IDIR}/autotools_root${TOOL_VERS}

./install-tool --build-python --krell-root-install-prefix ${BASE_IDIR}/python_root${TOOL_VERS}

# Build root components 
./install-tool --build-krell-root --krell-root-install-prefix ${BASE_IDIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_ROOT} --with-ltdl ${BASE_IDIR}/autotools_root${TOOL_VERS} --force-boost-build --with-openmpi ${OPENMPI_ROOT} --with-python ${BASE_IDIR}/python_root${TOOL_VERS}


./install-tool --build-offline --openss-prefix ${BASE_IDIR}/ossoffline${TOOL_VERS} --krell-root-install-prefix  ${BASE_IDIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_ROOT} --with-ltdl ${BASE_IDIR}/autotools_root${TOOL_VERS} --with-openmpi ${OPENMPI_ROOT} --with-python ${BASE_IDIR}/python_root${TOOL_VERS}

./install-tool --build-cbtf-all --cbtf-prefix ${BASE_IDIR}/cbtf${TOOL_VERS} --krell-root-prefix  ${BASE_IDIR}/krellroot${TOOL_VERS} --with-mpich ${MPICH_ROOT} --with-ltdl ${BASE_IDIR}/autotools_root${TOOL_VERS} --with-openmpi ${OPENMPI_ROOT} --with-python ${BASE_IDIR}/python_root${TOOL_VERS}

./install-tool --build-onlyosscbtf --openss-prefix  ${BASE_IDIR}/osscbtf${TOOL_VERS} --krell-root-prefix ${BASE_IDIR}/krellroot${TOOL_VERS} --cbtf-prefix ${BASE_IDIR}/cbtf${TOOL_VERS}  --with-mpich ${MPICH_ROOT} --with-ltdl ${BASE_IDIR}/autotools_root${TOOL_VERS} --with-openmpi ${OPENMPI_ROOT} --with-python ${BASE_IDIR}/python_root${TOOL_VERS}

# Compiling with a module loaded non-default installed compiler requires that the libstc++ library be made available on the compute nodes
cp /site/unsupported/gcc/gcc-4.8.2/lib64/libstdc++.so.6 ${BASE_IDIR}/krellroot${TOOL_VERS}/lib64/libstdc++.so.6
chmod 755 ${BASE_IDIR}/krellroot${TOOL_VERS}/lib64/libstdc++.so.6

