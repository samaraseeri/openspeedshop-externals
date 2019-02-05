module swap PrgEnv-cray/6.0.4 PrgEnv-gnu
module unload perftools-base/7.0.4 
module load papi
export BASE_IDIR=/lustre/cray/ws8/ws/xhebmuit-profiling/xhebmuit-ProfilingTools-1547863452/openspeedshop/openspeedshop-release-2.4-install2
export TOOL_VERS="_v2.4.0beta1"
export KROOT_IDIR=${BASE_IDIR}/krellroot${TOOL_VERS}
export CBTF_IDIR=${BASE_IDIR}/cbtf${TOOL_VERS}
export OSSCBTF_IDIR=${BASE_IDIR}/ossoff${TOOL_VERS}
export PAPI_IDIR=/opt/cray/pe/papi/5.6.0.4
export MPICH_IDIR=/opt/cray/pe/mpt/7.7.3/gni/mpich-gnu/4.9
export ALPS_IDIR=/opt/cray/alps/6.5.29-6.0.5.1_3.1__gc22dc90.ari
export cc=gcc
export CC=gcc
export CXX=g++
export BOOST_IDIR=${BASE_IDIR}/krellroot${TOOL_VERS}/compute
./install-tool --build-compiler gnu --build-krell-root --runtime-only --target-arch cray --target-shared --krell-root-prefix ${KROOT_IDIR}/compute --with-papi ${PAPI_IDIR} --force-boost-build

echo "Step 1 of 2 steps of compute node installation complete"

./install-tool --build-compiler gnu --build-cbtf-all --runtime-only --target-arch cray --target-shared --cbtf-prefix ${CBTF_IDIR}/compute --krell-root-prefix ${KROOT_IDIR}/compute --with-alps ${ALPS_IDIR} --with-boost ${BOOST_IDIR} --with-mpich ${MPICH_IDIR} --with-papi ${PAPI_IDIR} 

echo "Compute node installation complete"

 module unload craype-haswell
 module unload craype-network-aries
 module unload gcc
 module load gcc
 module unload cray-mpich
 module load craype-network-none
 export cc=gcc
 export CC=gcc
 export CXX=g++

./install-tool --build-compiler gnu --build-expat --krell-root-install-prefix ${BASE_IDIR}/expat-2.1.0 

echo "Step 1 of 4 steps of login node installation complete"

./install-tool --build-compiler gnu --build-krell-root --krell-root-prefix ${KROOT_IDIR} --with-alps ${ALPS_IDIR} --with-expat ${BASE_IDIR}/expat-2.1.0 --with-mpich ${MPICH_IDIR} --force-boost-build 

echo "Step 2 of 4 steps of login node installation complete"

./install-tool --build-compiler gnu --runtime-target-arch cray --build-cbtf-all --cbtf-prefix ${CBTF_IDIR} --krell-root-prefix ${KROOT_IDIR} --with-cn-boost ${BOOST_IDIR} --with-cn-mrnet ${KROOT_IDIR}/compute --with-cn-xercesc ${KROOT_IDIR}/compute --with-cn-libmonitor ${KROOT_IDIR}/compute --with-cn-libunwind ${KROOT_IDIR}/compute --with-cn-dyninst ${KROOT_IDIR}/compute --with-cn-papi ${PAPI_IDIR} --with-cn-cbtf-krell ${CBTF_IDIR}/compute --with-cn-cbtf ${CBTF_IDIR}/compute --with-binutils ${KROOT_IDIR} --with-boost ${BOOST_IDIR} --with-mrnet ${KROOT_IDIR} --with-xercesc ${KROOT_IDIR} --with-libmonitor ${KROOT_IDIR} --with-libunwind ${KROOT_IDIR} --with-dyninst ${KROOT_IDIR} --with-papi ${PAPI_IDIR} --with-mpich ${MPICH_IDIR}

echo "Step 3 of 4 steps of login node installation complete"

nohup ./install-tool --build-compiler gnu --target-arch cray --build-onlyosscbtf --openss-prefix ${OSSCBTF_IDIR} --with-cn-cbtf-krell ${CBTF_IDIR}/compute --krell-root-prefix ${KROOT_IDIR}  --with-papi ${PAPI_IDIR} --with-boost ${BOOST_IDIR} --with-mrnet ${KROOT_IDIR} --with-xercesc ${KROOT_IDIR} --with-libmonitor ${KROOT_IDIR} --with-libunwind ${KROOT_IDIR} --with-dyninst ${KROOT_IDIR} --with-libelf ${KROOT_IDIR} --with-libdwarf ${KROOT_IDIR} --with-binutils ${KROOT_IDIR} --cbtf-prefix ${CBTF_IDIR} --with-mpich ${MPICH_IDIR} 

echo "Login node installation complete"
