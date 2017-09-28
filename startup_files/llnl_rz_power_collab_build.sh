#!/bin/bash 
#
# Build on: rzmanta at LLNL:

use .adept
#use gcc-4.9.3p

BASE_IDIR=/collab/usr/global/tools/openspeedshop/oss-dev/power
TOOL_VERS="_v2.3.1"
ROOT_VERS="_v2.3.1"
FLEX_VERS="-2.5.35"
KROOT_IDIR=${BASE_IDIR}/krellroot${ROOT_VERS}
CBTF_IDIR=${BASE_IDIR}/cbtf${TOOL_VERS}
OSSCBTF_IDIR=${BASE_IDIR}/osscbtf${TOOL_VERS}
OSSOFF_IDIR=${BASE_IDIR}/ossoff${TOOL_VERS}
LTDL_IDIR=${BASE_IDIR}/autotools${TOOL_VERS}
FLEX_IDIR=${BASE_IDIR}/flex${FLEX_VERS}
#MVAPICH2_IDIR=/usr/local/tools/mvapich2-gnu-1.9 
#MVAPICH2_IDIR=/usr/local/tools/mvapich2-gnu-2.2 
MVAPICH2_IDIR=$HOME
#MVAPICH_IDIR=/usr/local/tools/mvapich-gnu 
MVAPICH_IDIR=$HOME
PYTHON_IDIR=${BASE_IDIR}/python-2.7.3 
PYTHON_VERS=2.7
OPENMPI_IDIR=/usr/tcetmp/packages/openmpi/openmpi-2.0.1-gcc-4.8.5-xl.13-15.1.5.0.b1_160911-gcc-4.8.5
#OPENMPI_IDIR=/usr/local/tools/openmpi-gnu-1.4.3


# Build python
#./install-tool --build-python --krell-root-prefix ${PTHYON_IDIR}
#./install-tool --build-autotools --krell-root-prefix ${LTDL_IDIR}
#./install-tool --build-flex --krell-root-prefix ${FLEX_IDIR}
./install-tool --build-flex --krell-root-prefix ${KROOT_IDIR}

# Build krellroot:
#
# Force binutils because make OSS usable across similar platforms w/o problem
# of different bfd and opcode installations.  Force papi to have the latest
# papi version available
#
./install-tool --build-krell-root --krell-root-prefix ${KROOT_IDIR} --force-papi-build --force-libunwind-build --with-mvapich2 ${MVAPICH2_IDIR} --with-mvapich ${MVAPICH_IDIR} --with-python ${PYTHON_IDIR} --with-python-vers ${PYTHON_VERS} --with-openmpi ${OPENMPI_IDIR}

#Build cbtf using the krellroot:
./install-tool --build-cbtf-all --cbtf-install-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR}  --with-mvapich2 ${MVAPICH2_IDIR} --with-mvapich ${MVAPICH_IDIR} --with-python ${PYTHON_IDIR}  --with-python-vers ${PYTHON_VERS} --with-openmpi ${OPENMPI_IDIR} --with-ltdl ${LTDL_IDIR}

#Build the cbtf instrumentor version of OpenSpeedShop using cbtf and the krellroot:
./install-tool --build-oss --openss-install-prefix ${OSSCBTF_IDIR} --cbtf-install-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR}  --with-mvapich2 ${MVAPICH2_IDIR} --with-mvapich ${MVAPICH_IDIR} --with-python ${PYTHON_IDIR} --with-python-vers ${PYTHON_VERS} --with-openmpi ${OPENMPI_IDIR} --with-ltdl ${LTDL_IDIR}

# Build offline with krellroot
#./install-tool --build-offline --openss-prefix ${OSSOFF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-mvapich2 ${MVAPICH2_IDIR} --with-mvapich ${MVAPICH_IDIR} --with-python ${PYTHON_IDIR} --with-python-vers ${PYTHON_VERS} --with-openmpi ${OPENMPI_IDIR}
