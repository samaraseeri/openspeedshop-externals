#!/bin/bash
#wget http://downloads.sourceforge.net/project/openss/openss/openspeedshop-1.9.3/openspeedshop-release-1.9.3.tar.gz

#set useful variables
export APP_VERSION=1.9.3
export APP_NAME=openspeedshop
export BASE=/software/SOURCES/$APP_NAME/$APP_VERSION
export SRC_DIR=$BASE/${APP_NAME}-release-1.9.3
export PREFIX=/software/applications/$APP_NAME/$APP_VERSION/gnu-4.2.4

#load environment
module load gnu/compilers/4.2.4
module load lang/python/2.5.2
module load libs/qt/3.3.8
module load intel/compilers/10.1.015
module load bull/mpi/2-1.7-2.t
#module load libs/openmpi/1.3

#openspeedshop environment variables
export OPENSS_PREFIX=${PREFIX}
export OPENSS_MPI_MPICH2=/opt/mpi/mpibull2-1.3.7-2.t
export OPENSS_MPI_MPICH_DRIVER=ibmr_gen2
export OPENSS_MPI_PATH=/opt/mpi/mpibull2-1.3.7-2.t
export OPENSS_MPI_LIB_LINE=lmpich
#export OPENSS_MPI_OPENMPI=${MPI_HOME}
#export OPENSS_MPI_PATH=${MPI_HOME}
#export OPENSS_MPI_LIB_LINE=-lmpi
export OPENSS_PYTHON=${PYTHON_HOME}
export LD_LIBRARY_PATH=${OPENSS_PREFIX}/lib64:${LD_LIBRARY_PATH}
export OPENSS_INSTRUMENTOR=mrnet
CC=gcc
CXX=g++
FC=gfortran
F77=gfortran
F90=gfortran


#set up build dir
rm -rf $SRC_DIR
rm -rf $OPENSS_PREFIX
tar xfz ${APP_NAME}-release-1.9.3.tar.gz
mkdir -p $OPENSS_PREFIX


#set up .rpmmacros
mv ~/.rpmmacros ~/.rpmmacros.$$
cat << EOF > ~/.rpmmacros
%_topdir     $SRC_DIR
%_tmppath    %{_topdir}/INSTALL/%(uname -n)
%_builddir   %{_topdir}/BUILD/%(uname -n)
%_rpmdir     %{_topdir}/RPMS/%(uname -n)
EOF


#configure
cd $SRC_DIR
mkdir -p BUILD/`uname -n`


#libdwarf
libdwarf () {
rpmbuild -bi $SRC_DIR/SPECS/libdwarf-20081231_a.spec
(
cd $SRC_DIR/INSTALL/`uname -n`/libdwarf-20081231-1-root/opt/OSS/
find . -depth -print | cpio -pdmv $OPENSS_PREFIX
)
}


#libunwind
libunwind () {
rpmbuild -bi $SRC_DIR/SPECS/libunwind-20090508_a.spec
(
cd $SRC_DIR/INSTALL/`uname -n`/libunwind-20090508-1-root${OPENSS_PREFIX}
find . -depth -print | cpio -pdmv $OPENSS_PREFIX
)
}


#libmonitor
libmonitor () {
rpmbuild -bi $SRC_DIR/SPECS/libmonitor-20090602_a.spec
(
cd $SRC_DIR/INSTALL/`uname -n`/libmonitor-20090602-1-root${OPENSS_PREFIX}
find . -depth -print | cpio -pdmv $OPENSS_PREFIX
)
}


#vampirtrace
vampirtrace () {
(
export CXX=icpc
export CC=icc
export FC=ifort
export F77=ifort
export F90=ifort
echo "CC is" $CC
rpmbuild -bi --define "depend_prefix $OPENSS_PREFIX" --define "prefix $OPENSS_PREFIX" $SRC_DIR/SPECS/vampirtrace-5.3.2_a.spec
cd $SRC_DIR/INSTALL/`uname -n`/vampirtrace-5.3.2-1-root/opt/OSS
find . -depth -print | cpio -pdmv $OPENSS_PREFIX
)
}


#dyninst
dyninst () {
rpmbuild -bi --define "depend_prefix $OPENSS_PREFIX" $SRC_DIR/SPECS/dyninst-5.2r_a.spec
(
cd $SRC_DIR/INSTALL/`uname -n`/dyninst-6.0-1-root/opt/OSS
find . -depth -print | cpio -pdmv $OPENSS_PREFIX
)
}


#mrnet
mrnet () {
rpmbuild -bi $SRC_DIR/SPECS/mrnet-2.0.1_a.spec
(
cd $SRC_DIR/INSTALL/`uname -n`/mrnet-2.0.1-1-root/opt/OSS
find . -depth -print | cpio -pdmv $OPENSS_PREFIX
)
}


#openspeedshop
openspeedshop () {
rpmbuild -bi --define "openss_instrumentor mrnet" --define "depend_prefix $OPENSS_PREFIX" $SRC_DIR/SPECS/openspeedshop-1.9.3_a.spec
(
cd $SRC_DIR/INSTALL/`uname -n`/openspeedshop-1.9.3-1-root${OPENSS_PREFIX}
find . -depth -print | cpio -pdmv $OPENSS_PREFIX
)
}


#install
#make install
echo "CC is" $CC

#main section
libdwarf
libunwind
libmonitor
vampirtrace
dyninst
mrnet
openspeedshop


#cleanup
#mv ~/.rpmmacros.$$ ~/.rpmmacros
