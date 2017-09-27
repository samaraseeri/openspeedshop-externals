#!/bin/bash 

#----------------
#FROM: falcon at INL:

#module load MVAPICH2/2.0.1-GCC-4.9.2
module load CMake/3.2.3-GCC-4.9.3

#module load gcc/4.7.3 boost/1.50.0 cmake cuda/6.0 python/2.7.6

BASE_INSTALL=/home/galajame/OSS
TOOL_VERS="_v2.3.1.beta1"
MVAPICH2_INSTALL=/apps/local/easybuild/software/MVAPICH2/2.1-GCC-4.9.3
OPENMPI_INSTALL=/apps/local/easybuild/software/OpenMPI/1.8.7-GCC-4.9.3
MPICH_INSTALL=/apps/local/easybuild/software/impi/5.1.3.181-iccifort-2016.3.067-GCC-4.9.3-2.25
PYTHON_INSTALL=/apps/local/easybuild/software/Python/2.7.8-gmvolf-5.5.4

./install-tool --build-krell-root --krell-root-prefix ${BASE_INSTALL}/krellroot${TOOL_VERS} --with-mvapich2 ${MVAPICH2_INSTALL} --with-openmpi ${OPENMPI_INSTALL} --with-mpich ${MPICH_INSTALL} --with-python ${PYTHON_INSTALL} --with-mvapich2 /apps/local/easybuild/software/MVAPICH2/2.2-GCC-4.9.3

./install-tool --build-cbtf-all --cbtf-install-prefix  ${BASE_INSTALL}/cbtf${TOOL_VERS} --krell-root-prefix ${BASE_INSTALL}/krellroot${TOOL_VERS}  --with-mvapich2 ${MVAPICH2_INSTALL} --with-openmpi ${OPENMPI_INSTALL} --with-mpich ${MPICH_INSTALL} --with-python ${PYTHON_INSTALL} --with-mvapich2 /apps/local/easybuild/software/MVAPICH2/2.2-GCC-4.9.3

./install-tool --build-oss --openss-prefix ${BASE_INSTALL}/osscbtf${TOOL_VERS} --cbtf-install-prefix ${BASE_INSTALL}/cbtf${TOOL_VERS} --krell-root-prefix ${BASE_INSTALL}/krellroot${TOOL_VERS}  --with-mvapich2 ${MVAPICH2_INSTALL} --with-openmpi ${OPENMPI_INSTALL} --with-mpich ${MPICH_INSTALL} --with-python ${PYTHON_INSTALL} --with-mvapich2 /apps/local/easybuild/software/MVAPICH2/2.2-GCC-4.9.3

#./install-tool --build-offline --openss-prefix ${BASE_INSTALL}/oss_offline${TOOL_VERS} --krell-root-prefix ${BASE_INSTALL}/krellroot${TOOL_VERS}  --with-mvapich2 ${MVAPICH2_INSTALL} --with-openmpi ${OPENMPI_INSTALL} --with-mpich ${MPICH_INSTALL} --with-python ${PYTHON_INSTALL} --with-mvapich2 /apps/local/easybuild/software/MVAPICH2/2.2-GCC-4.9.3


