#!/bin/bash

./install-tool --build-cmake --krell-root-prefix /opt/OSS/cmake-3.2.2
export PATH=/opt/OSS/cmake-3.2.2/bin:$PATH

./install-tool --build-krell-root --krell-root-prefix /opt/OSS/krellroot_v2.2.4 --with-mvapich2 /opt/mvapich2/cc-2.2b_gdr-mlnx_ofed_3.2-cuda_7.5 --force-boost-build --with-openmpi /opt/OSS/openmpi-1.8.2

./install-tool --build-cbtf-all --cbtf-prefix /opt/OSS/cbtf_v2.2.4 --krell-root-prefix /opt/OSS/krellroot_v2.2.4 --with-mvapich2 /opt/mvapich2/cc-2.2b_gdr-mlnx_ofed_3.2-cuda_7.5 --with-cuda /usr/local/cuda-7.5 --with-cupti /usr/local/cuda-7.5/extras/CUPTI --with-openmpi /opt/OSS/openmpi-1.8.2

./install-tool --build-onlyosscbtf --openss-prefix /opt/OSS/osscbtf_v2.2.4 --cbtf-prefix /opt/OSS/cbtf_v2.2.4 --krell-root-prefix /opt/OSS/krellroot_v2.2.4 --with-mvapich2 /opt/mvapich2/cc-2.2b_gdr-mlnx_ofed_3.2-cuda_7.5  --with-openmpi /opt/OSS/openmpi-1.8.2

#mv BUILD/localhost/openspeedshop BUILD/localhost/openspeedshop-cbtf
##./install-tool --build-offline --openss-prefix /opt/OSS/ossoff_v2.2.4 --krell-root-prefix /opt/OSS/krellroot_v2.2.4 --with-openmpi /opt/openmpi-1.8.2


