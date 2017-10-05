#!/bin/bash 

#set -x

# Developers Package Version Numbers
autoconfver=2.68
automakever=1.11.1
m4ver=1.4.13
libtoolver=2.4.2
Pythonver=2.7.3
bisonver=3.0.2
flexver=2.5.35
#boostver=1_61_0
boostver=1_53_0
xercescver=3.1.1
launchmonver=20121010
cmakever=3.2.2
expatver=2.1.0

# Package Version Numbers
#binutilsver=2.24
binutilsver=2.28
libelfver=0.8.13
elfutilsver=0.168
zlibver=1.2.11
GOTCHAver=20170510
#libdwarfver=20161124
libdwarfver=20170416
libunwindver=1.2.1
papiver=5.5.1
sqlitever=3.8.4
libmonitorver=20130218
vampirtracever=5.3.2
#dyninstver=20171003
dyninstver=9.3.2
symtabapiver=8.1.2
#mrnetver=20161003
mrnetver=20170810

# Qt related versions
qtver=3.3.8b
ptgfver=1.1
ptgfossguiver=1.1
qcustomplotver=1.1
serenever=0.4.0
graphvizver=2.40.1
QtGraphver=1.0.0

# OMPT related versions
omptver=20160808
#llvm_openmpver=20170825
llvm_openmpver=20170926

# OSS and CBTF versions
openspeedshopver=2.3
cbtfver=1.8.1
cbtfargoguiver=0.8.1

default_oss_prefix=/opt/OSS

# Variables for the search for prerequisite components.
found_libelf=0
found_libxml2=0
found_libz=0
found_binutils=0
found_qt=0
found_python=0
found_bison_flex=0
found_libtool=0
found_qtdir_set=0
found_patch=0
found_autoconf=0
found_automake=0
found_rpm=0

# switch to versions of components if system is related to the Blue Gene platform to avoid compilation errors
#if [ `uname -m` = "ppc64" -o `uname -m` = "bgq" -o `uname -m` = "bgp"  -o `uname -m` = "bgl" ]; then
#   dyninstver=8.2.1
#   libdwarfver=20131001
#   binutilsver=2.23.2
#fi


# For systems with kernels that are 2.6.31 and greater use papi-4.1.1 which 
# uses/supports the PCL (perf_counter/perf_event) interface
# Commented out for now.  May need it in the future....

#if test "`uname -r | grep "2.6."`"; then
#
#  OSVER=`uname -r `
#  # gives the position in $OSVER of *first* character in substring "2.6."
#  POS1=`expr index "$OSVER" "2.6."`
#  POS2=`expr $POS1 + 4`
#  VERS=`expr substr "$OSVER" "$POS2" 2`
#
##  echo "build debug: OSVER=$OSVER"
##  echo "build debug: POS1=$POS1"
##  echo "build debug: POS2=$POS2"
##  echo "build debug: VERS=$VERS"
#
#  # Version 2.6.31 of the kernel uses perf_counter.h and all subsequent versions use perf_event.h
#  if test "$VERS" -gt 30; then
#    papiver=4.1.0_a
#  fi
#
#fi

function prefixPrereqKRELLROOT() {
	echo "   "
	echo "    Checking to see if OPENSS_PREFIX is set.  This is the installation path for the OpenSpeedShop components."
	echo "    Checking to see if KRELL_ROOT_PREFIX is set.  This is the installation path for the OpenSpeedShop supporting components."
	echo "    Checking to see if CBTF_PREFIX is set.  This is the installation path for the CBTF components."
	echo "   "
	echo "   "
	if [ $KRELL_ROOT_PREFIX ]; then
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
	else
          echo "    PROBLEM: The installation path environment variable: KRELL_ROOT_PREFIX"
          echo "             is not set.  We recommend setting this environment variable to the path where"
          echo "             the Krell Root components are to be installed.  This can be in your home directory or anywhere"
          echo "             on the system where you have write permission.   The Krell Root installation does not"
          echo "             require root permissions for installation.  For example:"
          echo "                                        export KRELL_ROOT_PREFIX=/opt/krellroot"
 	  echo "                                      or "
          echo "                                        export KRELL_ROOT_PREFIX=/home/<user>/krellroot"
          echo "   "
          echo "   "
          echo "             Please contact us via this email alias: oss-questions@openspeedshop.org if you need assistance."
          echo "   "
          echo "             By default, the Krell Root build assumes KRELL_ROOT_PREFIX=/opt/KRELLROOT "
          echo 
          echo "Continue the build process using the default installation path of KRELL_ROOT_PREFIX=/opt/KRELLROOT ? <y/n>"
          echo
       
          read answer
         
          if [ "$answer" = Y -o "$answer" = y ]; then
              echo
              echo "Continuing the Krell Root build process."
              echo 
          else
              echo "   "
              exit
          fi

	fi
}

# Identifies missing prerequisites
function prefixPrereqOSS() {
	echo "   "
	echo "   "
	echo "    Checking to see if OPENSS_PREFIX is set.  This is the installation path for the OpenSpeedShop components."
	echo "    Checking to see if KRELL_ROOT_PREFIX is set.  This is the installation path for the OpenSpeedShop supporting components."
	echo "    Checking to see if CBTF_PREFIX is set.  This is the installation path for the CBTF components."
	echo "   "
	if [ $OPENSS_PREFIX ]; then
 	  echo "         Using OPENSS_PREFIX=$OPENSS_PREFIX"
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variable: OPENSS_PREFIX"
          echo "             is not set.  We recommend setting this environment variable to the path where"
          echo "             OpenSpeedShop is to be installed.  This can be in your home directory or anywhere"
          echo "             on the system where you have write permission.   OpenSpeedShop installation does not"
          echo "             require root permissions for installation.  For example:"
          echo "                                        export OPENSS_PREFIX=/opt/openspeedshop-2.3.0"
 	  echo "                                      or "
          echo "                                        export OPENSS_PREFIX=/home/<user>/openspeedshop-2.3.0"
          echo "   "
          echo "   "
          echo "             Please contact us via this email alias: oss-questions@openspeedshop.org if you need assistance."
          echo "   "
          echo "             By default OpenSpeedShop build assumes OPENSS_PREFIX=/opt/OSS "
          echo 
          echo "Continue the build process using the default installation path of OPENSS_PREFIX=/opt/OSS ? <y/n>"
          echo
       
          read answer
         
          if [ "$answer" = Y -o "$answer" = y ]; then
              echo
              echo "Continuing the OpenSpeedShop build process."
              echo 
          else
              echo "   "
              exit
          fi

	fi       
}

function prereq() {
     echo "   "
     echo "   "
     echo "    Checking for prerequisite components needed to build Open|SpeedShop and/or "
     echo "    the Open|SpeedShop required component packages. If all the prerequisite"
     echo "    packages are present the script will continue, if not all the prerequisites"
     echo "    are found, the script exits because the build will fail without the "
     echo "    prerequisite components installed."
     echo "    We are checking for these components:"
     echo "        a) GNU patch"
     echo "        b) libelf and/or libelf-devel"
     echo "        c) libxml2 and/or libxml2-devel"
     echo "           NOTE: libxml2 and/or libxml2-devel are not needed"
     echo "                 if using OPENSS_BUILD_TASK=offline, however,"
     echo "                 the online (mrnet) version does need libxml2 and libxml2-devel"
     echo "        d) binutils and/or binutils-devel"
     echo "        e) qt and/or qt-devel"
     echo "        f) python and/or python-devel"
     echo "        g) bison or flex"
     echo "        h) libtool"
     echo "        i) The environment variable QTDIR is set"
     echo "        j) rpm"
     echo "        k) libltdl and libltdl-devel"
     echo "   "
     echo "   "
     #dir_autoconf=$(dirname $(which autoconf))
     dir_autoconf=`which autoconf`
#  Check for autoconf
   if [ -f $dir_autoconf/autoconf ]; then
     echo "    NOTE: autoconf was detected in $dir_autoconf"
     found_autoconf=1
   else
     found_autoconf=0
     echo "    CAUTION: autoconf was not detected - please install autoconf or build the OpenSpeedShop"
     echo "             version supplied by using --devel and setting up KRELL_ROOT_AUTOTOOLS_ROOT, it is needed to "
     echo "             in the configuration of components needed in order to build OpenSpeedShop."
   fi
#  Check for automake
     #dir_automake=$(dirname $(which automake))
     dir_automake=`which automake`
   if [ -f $dir_automake/automake ]; then
     echo "    NOTE: automake was detected in $dir_automake"
     found_automake=1
   else
     found_automake=0
     echo "    CAUTION: automake was not detected - please install automakeconf or build the OpenSpeedShop"
     echo "             version supplied by using --devel and setting up KRELL_ROOT_AUTOTOOLS_ROOT, it is needed to "
     echo "             in the configuration of components needed in order to build OpenSpeedShop."
   fi
   #dir_patch=$(dirname $(which patch))
   dir_patch=`which patch`
#  Check for GNU patch
   if [ -f $dir_patch/patch ]; then
     echo "    NOTE: GNU patch was detected in $dir_patch"
     found_patch=1
   else
     found_patch=0
     echo "    PROBLEM: GNU patch was not detected - please install GNU patch, it is needed to apply"
     echo "             patches to some of the components needed in order to build OpenSpeedShop."
   fi
#  Check for libelf-devel
   if [ -f /usr/$LIBDIR/libelf.so ] && [ -f /usr/include/libelf.h -o /usr/include/libelf/libelf.h ]; then
     echo "    NOTE: libelf and libelf-devel detected in /usr/<lib>..."
     found_libelf=1
   else
     found_libelf=0
     echo "    PROBLEM: libelf and/or libelf-devel not detected - please install libelf"
     echo "             and/or libelf-devel versions that match your system."
     echo "    SOLUTION: Script will build libelf and libelf-devel for you."
   fi

   if [ -f $KRELL_ROOT_LIBXML2/$LIBDIR/libxml2.so.2 -o $KRELL_ROOT_LIBXML2/$ALTLIBDIR/libxml2.so.2 ] && [ -f $KRELL_ROOT_LIBXML2/include/libxml2/libxml/xmlwriter.h ]; then
     echo "    NOTE: libxml2 and libxml2-devel detected in $KRELL_ROOT_LIBXML2/<lib>..."
     found_libxml2=1
   elif [ -f /usr/$LIBDIR/libxml2.so.2 -a -f /usr/include/libxml2/libxml/xmlwriter.h ]; then
     echo "    NOTE: libxml2 and libxml2-devel detected in /usr/<lib>..."
     found_libxml2=1
   else
     found_libxml2=0
     if [ "$found_libxml2" = 0 -a "$OPENSS_BUILD_TASK" == "offline" ]; then
        echo "    CAUTION: libxml2 and libxml2-devel were not detected, but OPENSS_BUILD_TASK is offline, so they are not needed."
     else
        echo "    PROBLEM: libxml2 and/or libxml2-devel not detected - please install libxml2"
        echo "              and/or libxml2-devel versions that match your system."
     fi
   fi

#
#  Check for binutils-devel
# 
   #ld_dir=$(dirname $(which ld))
   ld_dir=`which ld`
   if [ ! -z $KRELL_ROOT_FORCE_BINUTILS_BUILD ] ; then
     found_binutils=0
     export build_binutils=1
     echo "    NOTE: KRELL_ROOT_FORCE_BINUTILS_BUILD was detected binutils will be installed."
   elif [ -f $ld_dir/../include/bfd.h -a -f $ld_dir/../include/libiberty.h ] && [ -f $ld_dir/../$LIBDIR/libiberty_pic.a ]; then
     echo "    NOTE: binutils and binutils-devel detected in $ld_dir/../{include,$LIBDIR}"
     found_binutils=1
# note - must do something for lib64
#   elif [ -f $ld_dir/../include/bfd.h -a -f $ld_dir/../include/libiberty.h ] && [ -f $ld_dir/../lib/libiberty.a -o -f $ld_dir/../lib64/libiberty.a ]; then
   elif [ -f $ld_dir/ld -a -f $ld_dir/../include/bfd.h -a -f $ld_dir/../include/libiberty.h ] && [ -f $ld_dir/../$LIBDIR/libiberty.a ]; then
     # Check for fPIC libiberty.a by using objdump --reloc
     dumpname=`which objdump`
     grepname=`which grep`
     tst_file=`$dumpname --reloc $ld_dir/../$LIBDIR/libiberty.a 2>/dev/null | $grepname -n R_X86_64_32S`
     #
     # If file is empty then we have a libiberty.a that was compiled with -fPIC, otherwise not
     #
     if [ -z "$tst_file" ]; then
       #echo "    NOTE: objdump --reloc $ld_dir/../$LIBDIR/libiberty.a 2>/dev/null | grep R_X86_64_32S did not find any text. fPIC was used, so libiberty.a is good to use"
       echo "    NOTE: binutils and binutils-devel detected in $ld_dir/../{include,$LIBDIR}"
       found_binutils=1
     else
       #echo "    NOTE: objdump --reloc $ld_dir/../$LIBDIR/libiberty.a 2>/dev/null | grep R_X86_64_32S found text. fPIC was not used, so libiberty.a is NOT good to use"
       found_binutils=0
      fi
   fi

   if [ $found_binutils == 0 ]; then
     echo "    PROBLEM: binutils and/or binutils-devel not detected - please install binutils"
     echo "              and/or binutils-devel versions that match your system."

     if [ -f  /usr/include/bfd.h ]; then
        echo "    binutils-devel: detected missing file: /usr/include/bfd.h"
        export build_binutils=1
     fi

     if [ -f /usr/include/libiberty.h ]; then
        echo "    binutils-devel: detected missing file: /usr/include/libiberty.h"
        export build_binutils=1
     fi

     if [ $build_binutils == 1 ] ; then
        echo "    SOLUTION: Script will build binutils for you."
     fi
   fi

#  
#  Check for qt-devel
#  

   # DETECT QT3 INSTALLATIONS
   #echo "KRELL_ROOT_QT3=$KRELL_ROOT_QT3"
   #echo "KRELL_ROOT_QT3/LIBDIR=$KRELL_ROOT_QT3/$LIBDIR"

   if [ ! -z $KRELL_ROOT_FORCE_QT3_BUILD ] ; then
     found_qt=0
     echo "    NOTE: KRELL_ROOT_FORCE3_QT3_BUILD was detected qt3 will be installed."
   elif [ -f ${KRELL_ROOT_QT3}/lib/libqui.so.1.0.0 -a -f ${KRELL_ROOT_QT3}/bin/qmake -o \
          -f ${KRELL_ROOT_QT3}/bin/qmake -a -f ${KRELL_ROOT_QT3}/$LIBDIR/libqui.so.1.0.0 -a -f $KRELL_ROOT_QT3/include/qt3/qassistantclient.h -a -f $KRELL_ROOT_QT3/qt3/qt.h ]; 
   then
     found_qt=1
     export QTDIR=${KRELL_ROOT_QT3}
     echo "    NOTE: qt and qt-devel detected in ${KRELL_ROOT_QT3}."
   elif [ -f /usr/$LIBDIR/qt-3.3/lib/libqui.so.1.0.0 -a -f /usr/$LIBDIR/qt-3.3/bin/qmake -o \
        -f /usr/$LIBDIR/qt3/lib/libqui.so.1.0.0 -a -f /usr/$LIBDIR/qt3/bin/qmake -o \
        -f /usr/bin/qmake -a -f /usr/$LIBDIR/libqui.so.1.0.0 -a -f /usr/include/qt3/qassistantclient.h -a -f /usr/include/qt3/qt.h ]; 
   then
     echo "    NOTE: qt and qt-devel detected in /usr/<lib>/qt..."
     found_qt=1
   else
     found_qt=0
     echo "    PROBLEM: qt and/or qt-devel not detected."
     echo "    SOLUTION: Script will build QT-3 for you."
   fi


#  
#  Check for python-devel
# 
   #python_dir=$(dirname $(which python))
   python_dir=`which python`
   if [ -f $python_dir/python -a -f $python_dir/../include/python2.5/Python.h -o \
        -f $python_dir/../include/python2.4/Python.h -o -f $python_dir/../include/python2.6/Python.h -o \
        -f $python_dir/../include/python2.7/Python.h -o -f $python_dir/../include/python2.3/Python.h ]; then
     echo "    NOTE: python and python-devel detected in $python_dir and $python_dir/../include..."
     found_python=1
   else
     if [ $KRELL_ROOT_PYTHON ]; then
       if [ -f $KRELL_ROOT_PYTHON/bin/python -a -f $KRELL_ROOT_PYTHON/include/python2.5/Python.h -o \
            -f $KRELL_ROOT_PYTHON/include/python2.4/Python.h -o -f $KRELL_ROOT_PYTHON/include/python2.6/Python.h -o \
            -f $KRELL_ROOT_PYTHON/include/python2.7/Python.h -o -f $KRELL_ROOT_PYTHON/include/python2.3/Python.h ]; then
            echo "    NOTE: python and python-devel detected in $KRELL_ROOT_PYTHON/bin and $KRELL_ROOT_PYTHON/<lib>..."
            found_python=1
       fi
     else
       found_python=0
       echo "    PROBLEM: python and/or python-devel not detected - please install python"
       echo "             and/or python-devel versions that match your system."
     fi
   fi
#  
#  Check for bison or flex
# 
   #bison_dir=$(dirname $(which bison))
   bison_dir=`which bison`
   #flex_dir=$(dirname $(which flex))
   flex_dir=`which flex`
   if [ -f $flex_dir/flex -o -f $bison_dir/bison ]; then
     echo "    NOTE: flex and/or bison was detected in $flex_dir or $bison_dir"
     found_bison_flex=1
   else
     found_bison_flex=0
     echo "    PROBLEM: flex and/or bison was not detected - please install a flex or bison version that match your system."
     echo "    NOTE: only one, either flex or bison, is needed.."
   fi
#  
#  Check for libtool
# 
   #libtool_dir=$(dirname $(which libtool))
   libtool_dir=`which libtool`
   if [ -f $libtool_dir/libtool -a -f $libtool_dir/libtoolize ]; then
     echo "    NOTE: libtool was detected in $libtool_dir"
     found_libtool=1
   else
     found_libtool=0
     echo "    PROBLEM: libtool was not detected - please install a libtool version that match your system."
   fi

    if [ $QTDIR ]; then
     echo "    NOTE: QTDIR is set."
     found_qtdir_set=1
   else
     echo "    OPTIONAL: The environment variable QTDIR is not set.  You may set QTDIR" 
     echo "              to the location of your qt version 3 installation."
     echo "              You may want to do this if QT is installed in a non-standard location."
     echo "              For example, export QTDIR=/opt/qt-3.3."
     found_qtdir_set=0
   fi
#  Check for rpm
   #rpm_dir=$(dirname $(which rpm))
   rpm_dir=`which rpm`
   if [ -f $rpm_dir/rpm ]; then
     echo "    NOTE: rpm was detected in $rpm_dir"
     found_rpm=1
   else
     found_rpm=0
     echo "    PROBLEM: rpm was not detected - please install rpm, it is needed to "
     echo "             in order to do the installation of the build components"
     echo "             into the KRELL_ROOT_PREFIX location."
   fi
#  
#  Check for libltdl and libltdl-devel
#  
   #if [ -f $libtool_dir/../lib/libltdl.so ] && [ -f $libtool_dir/../include/ltdl.h ]; then
   #  echo "    NOTE: libltdl and libltdl-devel were detected in $libtool_dir/.."
   #  found_ltdl=1
   #else
   #  found_ltdl=0
   #  echo "    PROBLEM: libltdl and/or libltdl-devel were not detected - please install the libltdl and/or libltdl-devel version that match your system."
   #fi


   echo "   "
   echo "   "
   echo "OPENSS_INSTRUMENTOR=$OPENSS_INSTRUMENTOR"
   echo "OPENSS_BUILD_TASK=$OPENSS_BUILD_TASK"
   echo "found_libxml2=$found_libxml2"

#   if [ $report_missing_packages ]; then
#    #if  [ "$found_libxml2" = 0 -a $OPENSS_BUILD_TASK != offline ]  || \
#    if  [  "$found_binutils" = 0 -a $build_binutils == 0 ] || \
#        [ "$found_rpm" = 0 ] || \
#        [ "$found_patch" = 0  ] || \
#        [ "$found_bison_flex" = 0  ] || \
#        [ "$found_python" = 0 ] ; then
#          echo "   "
#          echo "   "
#          echo "    PROBLEM: You have the option to stop the build script because it will "
#          echo "             fail because of missing packages.  The above mentioned packages which"
#          echo "             have been identified as not being present on your system, need to" 
#          echo "             be installed before trying to build and install OpenSpeedShop and"
#          echo "             its components.   Sorry for this inconvenience."
#          echo "   "
#          echo "             Please contact us via this email alias: oss-questions@openspeedshop.org "
#          echo "   "
#          echo 
#          echo "Continue the build process anyway? <y/n>"
#          echo
#         
#          read answer
#         
#          if [ "$answer" = Y -o "$answer" = y ]; then
#              echo
#              echo "Continuing the build process."
#              echo 
#          else
#              echo "   "
#              exit
#          fi
#    fi
#  fi
 
}

# Prints Script Usage
function usage() {
    cat << EOF
    usage:
        .support_for_install.sh [--with-option choiceNum] .support_for_install.sh [-h | --help]

EOF
}

# Prints Script Info
function about() {
    cat << EOF

    ---------------------------------------------------------------------------
    This script builds RPMs and supports installation as non-root through cpio
    
    The default install prefix (OPENSS_PREFIX) is /opt/OSS. If another is preferred, please set
    the OPENSS_PREFIX environment variable to reflect the new target install directory   
     
    Typical build only needs these Krell Root and OpenSpeedShop build variables set:
        export OPENSS_PREFIX to the directory where you want OpenSpeeShop installed
        export KRELL_ROOT_MPI_<mpt type> to install directory of <mpi type> = {MPT, OPENMPI, MPICH2, ...}
    ---------------------------------------------------------------------------

EOF
}

# Prints Script Choices
function choices() {
    cat << EOF
    Choices:
    
    1  - KRELL_ROOT: Build binutils (optional), Check/Build libelf libraries
    1a - KRELL_ROOT: Install binutils (optional), libelf, if built (non-root/cpio)
    2  - KRELL_ROOT: Build base Support libraries: libdwarf
    2a - KRELL_ROOT: Install libdwarf if built (non-root/cpio)
         - Otherwise install RPM manually at this point
    3  - KRELL_ROOT: Build base Support libraries: libunwind, papi, sqlite, monitor
    3a - KRELL_ROOT: Install base Support libraries (non-root/cpio): libunwind, papi,
         sqlite, monitor
         - Otherwise install RPMs manually at this point
    4  - KRELL_ROOT: Build base Support libraries: vampirtrace, dyninst (online) or symtabapi (offline)
    4a - KRELL_ROOT: Install base Support library (non-root/cpio): vampirtrace, dyninst (online) or symtabapi (offline)
         - Otherwise install RPMs manually at this point
    5  - KRELL_ROOT: Build base Support libraries: mrnet
    5a - KRELL_ROOT: Install base Support library: mrnet
         - Otherwise install RPMs manually at this point
    6  - KRELL_ROOT: Check if base GUI support library is installed, build if necessary: qt3/qt3.3
    6a - KRELL_ROOT: Install base GUI support library if built (non-root/cpio): qt3/qt-3.3
         - Otherwise install RPMs manually at this point
    6b - CBTF: Build and Install CBTF
    7  - OPENSS: Build Open|SpeedShop
    7a - OPENSS: Install Open|SpeedShop
         - Otherwise install RPMs manually at this point
    8  - Install status

    9  - Automatic - Run all steps with no questions asked. Assume that the
                     answer to any question which will be asked is yes. Please
                     make certain that all required environment variables are
                     set properly. It may be best for fresh installations
                     to run though the choices one at a time, in ascending
                     order, as this may help discover any missing system
                     dependencies.  Everything will be installed in
                     /opt/OSS (if KRELL_ROOT_PREFIX is not set) via cpio process

    Please feel free to contact us via this email alias: oss-questions@openspeedshop.org

EOF
}

# Print Important Environmental Variables
function envvars() {
    cat << EOF
    
    OPENSS Environment Variables:
        -General
            OPENSS_PREFIX           Set to alternate install prefix.  default is /opt/OSS
            KRELL_ROOT_PREFIX       Set to alternate install prefix.  default is /opt/krellroot
            CBTF_PREFIX             Set to CBTF component infrastructure install prefix.  Default is /opt/CBTF_ONLY
            OPENSS_BUILD_TASK       Set to the task the script was invoked to do:  
                                    options are: krellroot, cbtf, osscbtf, onlyosscbtf, offline, online
                                      krellroot: builds only the ROOT components that CBTF and OpenSpeedShop need to use
                                      cbtf: builds the cbtf framework components using krellroot components
                                      osscbtf: builds the krellroot, cbtf framework components and OSS using those components
                                      onlyosscbtf: builds OpenSpeedShop with the cbtf instrumentor using cbtf and krellroot components
                                      offline: builds OpenSpeedShop for offline instrumentation: LD_PRELOAD 
                                      mrnet: builds OpenSpeedShop for online instrumentation: dyninst/mrnet
            OPENSS_INSTRUMENTOR     Will be set based on build task to the underlying instrumentation type openss will use.  Default is offline (does not include online/mrnet)
                                    Options are: offline, mrnet, krellroot, cbtf
                                    krellroot: builds only the ROOT components that CBTF and OpenSpeedShop need to use
                                    cbtf: builds OpenSpeedShop with the cbtf instrumentor
                                    offline: builds OpenSpeedShop for offline instrumentation: LD_PRELOAD 
                                    mrnet: builds OpenSpeedShop for online instrumentation: dyninst/mrnet
            KRELL_ROOT_TARGET_ARCH      Set to the target architecture to build the Open|SpeedShop runtime environment for.
            KRELL_ROOT_PPC64_BITMODE_64 Set to indicate you want a 64 bit version of ppc64 OSS built.  Set to 1 or leave unset to indicate 32 bit build.
            KRELL_ROOT_IMPLICIT_TLS     When set, this enables Open|SpeedShop to use implicitly created tls storage. default is explicit.
        
        -Open|SpeedShop MPI and Vampirtrace
            KRELL_ROOT_MPI_LAM          Set to MPI LAM installation dir. default is null.
            KRELL_ROOT_MPI_LAMPI        Set to MPI LAMPI installation dir. default is null.
            KRELL_ROOT_MPI_OPENMPI      Set to MPI OPENMPI installation dir. default is null.
            KRELL_ROOT_MPI_MPICH        Set to MPI MPICH installation dir. default is null.
            KRELL_ROOT_MPI_MPICH_DRIVER Set to mpich driver name [ch-p4]. default is null.
            KRELL_ROOT_MPI_MPICH2       Set to MPI MPICH2 installation dir. default is null.
            KRELL_ROOT_MPI_MPICH2_DRIVER  Set to mpich2 driver name [cray]. default is null.
            KRELL_ROOT_MPI_MPT          Set to SGI MPI MPT installation dir. default is null.
            KRELL_ROOT_MPI_MVAPICH      Set to MPI MVAPICH installation dir. default is null.
            KRELL_ROOT_MPI_MVAPICH2     Set to MPI MVAPICH2 installation dir. default is null.
        -Open|SpeedShop Use This Component instead of building it
            KRELL_ROOT_OFED             Set to OPEN FABRICS installation dir. default is /usr.
            KRELL_ROOT_QT3              Use this qt3 package instead of building it.  default is /usr
            KRELL_ROOT_PYTHON           Use this python package instead of building it.  default is /usr
            KRELL_ROOT_BINUTILS         Use this binutils package instead of building it.  default is /usr
            KRELL_ROOT_LIBXML2          Use this libxml2 package instead of building it.  default is /usr
            KRELL_ROOT_LIBELF           Use this libelf package instead of building it.  default is /usr
            KRELL_ROOT_LIBDWARF         Use this libdwarf package instead of building it.  default is /usr
            KRELL_ROOT_PAPI             Use this papi package instead of building it.  default is /usr
            KRELL_ROOT_SQLITE           Use this sqlite package instead of building it.  default is /usr
        -Open|SpeedShop Force the build of this component, even if installed on the system
            KRELL_ROOT_FORCE_LIBELF_BUILD         Force the build of libelf even if one is installed
            KRELL_ROOT_FORCE_LIBDWARF_BUILD       Force the build of libdwarf even if one is installed
            KRELL_ROOT_FORCE_PAPI_BUILD           Force the build of papi even if one is installed
            KRELL_ROOT_FORCE_SQLITE_BUILD         Force the build of sqlite even if one is installed
            KRELL_ROOT_FORCE_QT3_BUILD             Force the build of qt3 even if one is installed
    
EOF

}

# Print General OSS Getting Started Info
function default_envs() {
    cat << EOF
    
    Current Values for OPENSS Environment Variables:
        -General

EOF
	if [ $OPENSS_PREFIX ]; then
		echo "         Using OPENSS_PREFIX=$OPENSS_PREFIX"
	fi       
	if [ $KRELL_ROOT_PREFIX ]; then
		echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
	fi       
	if [ $CBTF_PREFIX ]; then
		echo "         Using CBTF_PREFIX=$CBTF_PREFIX"
	fi       
	if [ $OPENSS_INSTRUMENTOR ]; then
		echo "         Using OPENSS_INSTRUMENTOR=$OPENSS_INSTRUMENTOR"
	fi       
	if [ $OPENSS_BUILD_TASK ]; then
		echo "         Using OPENSS_BUILD_TASK=$OPENSS_BUILD_TASK"
	fi       
	if [ $KRELL_ROOT_TARGET_ARCH ]; then
		echo "         Using target architecture, KRELL_ROOT_TARGET_ARCH=$KRELL_ROOT_TARGET_ARCH"
	fi       
	if [ $KRELL_ROOT_BINUTILS ]; then
		echo "         Using KRELL_ROOT_BINUTILS=$KRELL_ROOT_BINUTILS"
	fi       
	if [ $KRELL_ROOT_MPI_MVAPICH2_OFED ]; then
		echo "         Using KRELL_ROOT_MPI_MVAPICH2_OFED=$KRELL_ROOT_MPI_MVAPICH2_OFED"
	fi       
	if [ $KRELL_ROOT_PYTHON ]; then
		echo "         Using KRELL_ROOT_PYTHON=$KRELL_ROOT_PYTHON"
	fi       
	if [ $KRELL_ROOT_RESOLVE_SYMBOLS ]; then
		echo "         Using KRELL_ROOT_RESOLVE_SYMBOLS=$KRELL_ROOT_RESOLVE_SYMBOLS"
	fi       
	if [ $KRELL_ROOT_SYMTABAPI ]; then
		echo "         Using KRELL_ROOT_SYMTABAPI=$KRELL_ROOT_SYMTABAPI"
	fi       
	if [ $KRELL_ROOT_LIBXML2 ]; then
		echo "         Using KRELL_ROOT_LIBXML2=$KRELL_ROOT_LIBXML2"
	fi       
	if [ $KRELL_ROOT_EXPLICIT_TLS ]; then
		echo "         Using explicitly generated Thread local storage areas within Open|SpeedShop"
	fi       
	if [ $KRELL_ROOT_IMPLICIT_TLS ]; then
		echo "         Using implicitly generated Thread local storage areas within Open|SpeedShop"
	fi       
	if [ $KRELL_ROOT_DYNINST_VERS ]; then
		echo "         Using KRELL_ROOT_DYNINST_VERS=$KRELL_ROOT_DYNINST_VERS"
	fi       
	if [ $KRELL_ROOT_MRNET_VERS ]; then
		echo "         Using KRELL_ROOT_MRNET_VERS=$KRELL_ROOT_MRNET_VERS"
	fi       
	if [ $KRELL_ROOT_SYMTABAPI_VERS ]; then
		echo "         Using KRELL_ROOT_SYMTABAPI_VERS=$KRELL_ROOT_SYMTABAPI_VERS"
	fi       
	if [ $KRELL_ROOT_PPC64_BITMODE_64 ]; then
		echo "         Using KRELL_ROOT_PPC64_BITMODE_64=$KRELL_ROOT_PPC64_BITMODE_64"
	fi       
    cat << EOF
    
        -Open|SpeedShop MPI and Vampirtrace

EOF
	if [ $KRELL_ROOT_MPI_LAM ]; then
		echo "         Using KRELL_ROOT_MPI_LAM=$KRELL_ROOT_MPI_LAM"
	fi       
	if [ $KRELL_ROOT_MPI_LAMPI ]; then
		echo "         Using KRELL_ROOT_MPI_LAMPI=$KRELL_ROOT_MPI_LAMPI"
	fi       
	if [ $KRELL_ROOT_MPI_OPENMPI ]; then
		echo "         Using KRELL_ROOT_MPI_OPENMPI=$KRELL_ROOT_MPI_OPENMPI"
	fi       
	if [ $KRELL_ROOT_MPI_MPICH ]; then
		echo "         Using KRELL_ROOT_MPI_MPICH=$KRELL_ROOT_MPI_MPICH"
	fi       
	if [ $KRELL_ROOT_MPI_MPICH_DRIVER ]; then
		echo "         Using KRELL_ROOT_MPI_MPICH_DRIVER=$KRELL_ROOT_MPI_MPICH_DRIVER"
	fi       
	if [ $KRELL_ROOT_MPI_MPICH2 ]; then
		echo "         Using KRELL_ROOT_MPI_MPICH2=$KRELL_ROOT_MPI_MPICH2"
	fi       
        if [ $KRELL_ROOT_MPI_MPICH2_DRIVER ]; then
                echo "         Using KRELL_ROOT_MPI_MPICH2_DRIVER=$KRELL_ROOT_MPI_MPICH2_DRIVER"
        fi
	if [ $KRELL_ROOT_MPI_MPT ]; then
		echo "         Using KRELL_ROOT_MPI_MPT=$KRELL_ROOT_MPI_MPT"
	fi       
	if [ $KRELL_ROOT_MPI_MVAPICH ]; then
		echo "         Using KRELL_ROOT_MPI_MVAPICH=$KRELL_ROOT_MPI_MVAPICH"
	fi       
	if [ $KRELL_ROOT_MPI_MVAPICH2 ]; then
		echo "         Using KRELL_ROOT_MPI_MVAPICH2=$KRELL_ROOT_MPI_MVAPICH2"
	fi       
    cat << EOF

EOF
}

# Print General OSS Getting Started Info
function getstarted() {
		cat << EOF
        
        In the base case you need to add prefix/bin to your PATH variable
        and prefix/<lib> path to your LD_LIBRARY_PATH environment variable
        
        If you use module files - a base module file is located in 
        OpenSpeedShop/startup_files that you can use - just change the prefix
        to your actual install location
EOF
}

# Print build task information.  If $OPENSS_BUILD_TASK is not defined,
# OPENSS_BUILD_TASK is set to offline.
function buildtask() {
    if [ $OPENSS_BUILD_TASK ]; then
        cat << EOF

    You are building for Open|SpeedShop build task: $OPENSS_BUILD_TASK
    You have manually specified a Open|SpeedShop build task using
    the environment variable OPENSS_BUILD_TASK to override the
    default Open|SpeedShop build task: offline.
        
EOF
    else
        cat << EOF

    You are building for default Open|SpeedShop build task: offline.
    If you wish to change the Open|SpeedShop build task, use
    the OPENSS_BUILD_TASK to specify: mrnet, or offline.

EOF
            export OPENSS_BUILD_TASK="offline"
    fi 
}

 #
 # begin function setup_for_oss_cbtf
 # This function finds where components are located 
 # and sets the environment variables passed to autotools and cmake
 #
function setup_for_oss_cbtf() {

   if [ "$display_summary" = 1 ] ; then 
       echo "BEGIN -- setting-up: for this build."
   fi
   PLATFORM=`uname -i`
   #echo "setting-up: PLATFORM=$PLATFORM"
   
   #echo "setting-up: KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
   #echo "setting-up: prefix=%{prefix}"
   #echo "setting-up: target_shared=%{target_shared}"

   
   if [ -f $KRELL_ROOT_PREFIX/cmake-$cmakever/share/cmake-3.2/Modules/FindPythonLibs.cmake -a -f $KRELL_ROOT_PREFIX/cmake-$cmakever/bin/cmake ]; then
         echo "USING existing CMAKE build due to it is already installed in $KRELL_ROOT_PREFIX/cmake-$cmakever directory, KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
         export PATH=$KRELL_ROOT_PREFIX/cmake-$cmakever/bin:$PATH
         echo "setup_for_oss_cbtf(), PATH=$PATH"
   else
         echo "Didn't find an existing CMAKE installed in KRELL_ROOT_PREFIX/cmake-cmakever directory, KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
   fi
   
   # Setting QTDIR for OpenSpeedShop build
   if test -d $KRELL_ROOT_PREFIX/qt3; then
     export QTDIR=$KRELL_ROOT_PREFIX/qt3
     if [ "$display_summary" = 1 ] ; then 
         echo "setting-up: Setting QTDIR to KRELL_ROOT_PREFIX/qt3, QTDIR=${QTDIR}"
     fi
   fi
   
   # openspeedshop gui uses Qt. Set env up for Qt as needed.
   # (how do we remove the hardcoded qt version?)
   
   if [ $QTDIR ]; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: QTDIR is defined QTDIR=${QTDIR}"
           fi
           export QTDIR_PHRASE="--with-qtlib=$QTDIR"
           export CMAKE_QTDIR_PHRASE="-DQTDIR=${QTDIR}"
           export CMAKE_QT_QMAKE_EXECUTABLE_PHRASE="-DQT_QMAKE_EXECUTABLE=${QTDIR}/bin/qmake"
           export CMAKE_QT_MOC_EXECUTABLE_PHRASE="-DQT_MOC_EXECUTABLE=${QTDIR}/bin/moc"
   else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: QTDIR is undefined, setting to /usr"
           fi
           export QTDIR=/usr
           export QTDIR_PHRASE="--with-qtlib=/usr"
           export CMAKE_QTDIR_PHRASE=""
           export CMAKE_QT_QMAKE_EXECUTABLE_PHRASE="-DQT_QMAKE_EXECUTABLE=${QTDIR}/bin/qmake"
           export CMAKE_QT_MOC_EXECUTABLE_PHRASE="-DQT_MOC_EXECUTABLE=${QTDIR}/bin/moc"
   fi
   
   if [ $OPENSS_INSTRUMENTOR ]; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: OPENSS_INSTRUMENTOR is defined to $OPENSS_INSTRUMENTOR"
           fi
           export OPENSS_INSTRUMENTOR_PHRASE="--with-instrumentor=$OPENSS_INSTRUMENTOR"
           export CMAKE_INSTRUMENTOR_PHRASE="-DINSTRUMENTOR=${OPENSS_INSTRUMENTOR}"
   else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: OPENSS_INSTRUMENTOR is undefined, setting to offline"
           fi
           export OPENSS_INSTRUMENTOR=offline
           export OPENSS_INSTRUMENTOR_PHRASE="--with-instrumentor=offline"
           export CMAKE_INSTRUMENTOR_PHRASE="-DINSTRUMENTOR=offline"
   fi
   
   # Process the compute node --with-runtime-target-arch install-tool argument setting up for cmake build
   # in the build_cbtf_krell_routine
   if [ ${KRELL_ROOT_RUNTIME_TARGET_ARCH} ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_RUNTIME_TARGET_ARCH is defined and it's value is:${KRELL_ROOT_RUNTIME_TARGET_ARCH}"
           #echo "setting-up: KRELL_ROOT_RUNTIME_TARGET_ARCH_PHRASE is defined to ${KRELL_ROOT_RUNTIME_TARGET_ARCH}."
       fi
       export CMAKE_RUNTIME_TARGET_ARCH_PHRASE="-DCN_RUNTIME_PLATFORM=${KRELL_ROOT_RUNTIME_TARGET_ARCH}"
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: CMAKE_RUNTIME_TARGET_ARCH_PHRASE is defined to ${CMAKE_RUNTIME_TARGET_ARCH_PHRASE}."
       fi
   else
       export KRELL_ROOT_RUNTIME_TARGET_ARCH_PHRASE=""
       export CMAKE_RUNTIME_TARGET_ARCH_PHRASE=""
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_RUNTIME_TARGET_ARCH is NOT defined."
           echo "setting-up: CMAKE_RUNTIME_TARGET_ARCH_PHRASE is defined to NULL."
       fi
   fi
   
   if [ $KRELL_ROOT_TARGET_ARCH ]; then
       export KRELL_ROOT_TARGET_ARCH_PHRASE="--with-target-os=$KRELL_ROOT_TARGET_ARCH"
       export CMAKE_TARGET_ARCH_PHRASE="-DRUNTIME_PLATFORM=${KRELL_ROOT_TARGET_ARCH}"
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_TARGET_ARCH is defined and it's value is:$KRELL_ROOT_TARGET_ARCH"
           echo "setting-up: CMAKE_TARGET_ARCH_PHRASE is defined to ${CMAKE_TARGET_ARCH_PHRASE}."
           #echo "setting-up: KRELL_ROOT_TARGET_ARCH_PHRASE is defined to ${KRELL_ROOT_TARGET_ARCH}."
       fi
   else
       export KRELL_ROOT_TARGET_ARCH_PHRASE=""
       export CMAKE_TARGET_ARCH_PHRASE=""
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: CMAKE_TARGET_ARCH_PHRASE is defined to NULL."
           echo "setting-up: KRELL_ROOT_TARGET_ARCH is NOT defined."
           #echo "setting-up: KRELL_ROOT_TARGET_ARCH_PHRASE is defined to NULL."
       fi
   fi
   
   # Process the compute node --with-cn-cbtf install-tool argument setting up for cmake build
   # in the build_cbtf_krell_routine
   if [ $KRELL_ROOT_CN_CBTF ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_CBTF is defined to $KRELL_ROOT_CN_CBTF."
       fi
       export CMAKE_CN_CBTF_PHRASE="-DCBTF_CN_RUNTIME_DIR=${KRELL_ROOT_CN_CBTF}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_CBTF is undefined, setting to blanks"
       fi
       export KRELL_ROOT_CN_CBTF=""
       export CMAKE_CN_CBTF_PHRASE=""
   fi
   
   # Process the compute node --with-cn-cbtf-krell install-tool argument setting up for cmake build
   # in the build_cbtf_krell_routine
   if [ $KRELL_ROOT_CN_CBTF_KRELL ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_CBTF_KRELL is defined to $KRELL_ROOT_CN_CBTF_KRELL."
       fi
       export CMAKE_CN_CBTF_KRELL_PHRASE="-DCBTF_KRELL_CN_RUNTIME_DIR=${KRELL_ROOT_CN_CBTF_KRELL}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_CBTF_KRELL is undefined, setting to blanks"
       fi
       export KRELL_ROOT_CN_CBTF_KRELL=""
       export CMAKE_CN_CBTF_KRELL_PHRASE=""
   fi

   #echo "setting-up: KRELL_ROOT_OMPT_ROOT is defined to $KRELL_ROOT_OMPT_ROOT."
   #echo "setting-up: KRELL_ROOT_PREFIX is defined to $KRELL_ROOT_PREFIX"
   #echo "setting-up: KRELL_ROOT_PREFIX/ompt is defined to $KRELL_ROOT_PREFIX/ompt"

   # Try to detect if we built libiomp5.so ourselves and by default installed it
   # into $KRELL_ROOT_PREFIX/ompt
   # By setting this up, it gets passed to cbtf-krell automatically by this script
   if [ $KRELL_ROOT_OMPT_ROOT ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_OMPT_ROOT is defined to $KRELL_ROOT_OMPT_ROOT."
       fi
       export CMAKE_LIBIOMP_PHRASE="-DLIBIOMP_DIR=${KRELL_ROOT_OMPT_ROOT}"
   else
       # Check to see if libiomp5.so is installed in root/ompt
       if test -f $KRELL_ROOT_PREFIX/ompt/$LIBDIR/libiomp5.so; then
           export CMAKE_LIBIOMP_PHRASE="-DLIBIOMP_DIR=${KRELL_ROOT_PREFIX}/ompt"
           #echo "setting-up: CMAKE_LIBIOMP_PHRASE is defined to $CMAKE_LIBIOMP_PHRASE."
       elif test -f $KRELL_ROOT_PREFIX/ompt/$ALTLIBDIR/libiomp5.so; then
           export CMAKE_LIBIOMP_PHRASE="-DLIBIOMP_DIR=${KRELL_ROOT_PREFIX}/ompt"
           #echo "setting-up: ALT, CMAKE_LIBIOMP_PHRASE is defined to $CMAKE_LIBIOMP_PHRASE."
       else
           if test -f $KRELL_ROOT_PREFIX/$LIBDIR/libiomp5.so; then
               export CMAKE_LIBIOMP_PHRASE="-DLIBIOMP_DIR=${KRELL_ROOT_PREFIX}"
               #echo "setting-up: noompt, CMAKE_LIBIOMP_PHRASE is defined to $CMAKE_LIBIOMP_PHRASE."
           elif test -f $KRELL_ROOT_PREFIX/$ALTLIBDIR/libiomp5.so; then
               export CMAKE_LIBIOMP_PHRASE="-DLIBIOMP_DIR=${KRELL_ROOT_PREFIX}"
               #echo "setting-up: noompt,alt, CMAKE_LIBIOMP_PHRASE is defined to $CMAKE_LIBIOMP_PHRASE."
           else
               echo "setting-up: KRELL_ROOT_OMPT_ROOT is undefined, setting to blanks"
               if [ "$display_summary" = 1 ] ; then 
                   echo "setting-up: KRELL_ROOT_OMPT_ROOT is undefined, setting to blanks"
               fi
               export KRELL_ROOT_OMPT_ROOT=""
               export CMAKE_LIBIOMP_PHRASE=""
           fi
       fi
   fi

   if [ $KRELL_ROOT_EXPAT_ROOT ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_EXPAT_ROOT is defined to $KRELL_ROOT_EXPAT_ROOT."
       fi
   else
       if test -f $KRELL_ROOT_PREFIX/$LIBDIR/libexpat.a; then
           export KRELL_ROOT_EXPAT_ROOT=$KRELL_ROOT_PREFIX
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: setting KRELL_ROOT_EXPAT_ROOT to $KRELL_ROOT_PREFIX."
           fi
       elif test -f $KRELL_ROOT_PREFIX/$ALTLIBDIR/libexpat.a; then
           export KRELL_ROOT_EXPAT_ROOT=$KRELL_ROOT_PREFIX
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: setting KRELL_ROOT_EXPAT_ROOT to $KRELL_ROOT_PREFIX."
           fi
       else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_EXPAT_ROOT is undefined, setting to blanks"
           fi
           export KRELL_ROOT_EXPAT_ROOT=""
       fi
   fi

   if [ $KRELL_ROOT_ALPS ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_ALPS is defined to $KRELL_ROOT_ALPS."
       fi
       export CMAKE_CRAYALPS_PHRASE="-DCRAYALPS_DIR=${KRELL_ROOT_ALPS}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_ALPS is undefined, setting to blanks"
       fi
       export KRELL_ROOT_ALPS=""
       export CMAKE_CRAYALPS_PHRASE=""
   fi
   
   if [ $CBTF_PREFIX ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: CBTF_PREFIX is defined to $CBTF_PREFIX."
           echo "setting-up: CBTF_XML_PHRASE is defined to $CBTF_PREFIX."
           echo "setting-up: CBTF_MRNET_PHRASE is defined to $CBTF_PREFIX."
           echo "setting-up: CBTF_KRELL_PHRASE is defined to $CBTF_PREFIX."
           #echo "setting-up: CBTF_MESSAGES_PHRASE is defined to $CBTF_PREFIX."
           #echo "setting-up: CBTF_SERVICES_PHRASE is defined to $CBTF_PREFIX."
       fi
       export CBTF_PHRASE="--with-cbtf=$CBTF_PREFIX" 
       export CMAKE_CBTF_PHRASE="-DCBTF_DIR=${CBTF_PREFIX}" 
       export CBTF_XML_PHRASE="--with-cbtf-xml=$CBTF_PREFIX" 
       export CBTF_MRNET_PHRASE="--with-cbtf-mrnet=$CBTF_PREFIX" 
       export CBTF_KRELL_PHRASE="--with-cbtf-krell=$CBTF_PREFIX" 
       export CMAKE_CBTF_KRELL_PHRASE="-DCBTF_KRELL_DIR=${CBTF_PREFIX}" 
       export CMAKE_CBTF_ARGONAVIS_PHRASE="-DCBTF_ARGONAVIS_DIR=${CBTF_PREFIX}" 
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: CMAKE_CBTF_PHRASE is defined to -DCBTF_DIR=${CBTF_PREFIX}."
           echo "setting-up: CMAKE_CBTF_KRELL_PHRASE is defined to -DCBTF_KRELL_DIR=${CBTF_PREFIX}."
           echo "setting-up: CMAKE_CBTF_ARGONAVIS_PHRASE is defined to -DCBTF_ARGONAVIS_DIR=${CBTF_PREFIX}."
       fi
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: CBTF_PREFIX is NOT defined."
           echo "setting-up: CBTF_ROOT is defined to NULL."
       fi
       export CBTF_PHRASE="" 
       export CBTF_XML_PHRASE="" 
       export CBTF_MRNET_PHRASE="" 
       export CBTF_KRELL_PHRASE="" 
       export CMAKE_CBTF_KRELL_PHRASE=""
       export CMAKE_CBTF_PHRASE=""
       export CMAKE_CBTF_ARGONAVIS_PHRASE="" 
   fi
   
   if [ $KRELL_ROOT_RUNTIME_ONLY ]; then
       export KRELL_ROOT_RUNTIME_ONLY_PHRASE="--enable-runtime-only"
       export OPENSS_RUNTIME_ONLY_PHRASE="--enable-runtime-only"
       export CMAKE_RUNTIME_ONLY_PHRASE="-DRUNTIME_ONLY=true"
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_RUNTIME_ONLY is defined to $KRELL_ROOT_RUNTIME_ONLY"
           echo "setting-up: KRELL_ROOT_RUNTIME_ONLY_PHRASE is defined to ${KRELL_ROOT_RUNTIME_ONLY_PHRASE}."
       fi
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_RUNTIME_ONLY is NOT defined."
       fi
       export KRELL_ROOT_RUNTIME_ONLY_PHRASE=""
       export OPENSS_RUNTIME_ONLY_PHRASE=""
       export CMAKE_RUNTIME_ONLY_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_RUNTIME_DIR ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_RUNTIME_DIR is defined to $KRELL_ROOT_RUNTIME_DIR"
           echo "setting-up: KRELL_ROOT_RUNTIME_DIR_PHRASE is defined to ${KRELL_ROOT_RUNTIME_DIR_PHRASE}."
       fi
       export CMAKE_RUNTIME_DIR_PHRASE="-DRUNTIME_DIR=${KRELL_ROOT_RUNTIME_DIR}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_RUNTIME_DIR is NOT defined."
           echo "setting-up: KRELL_ROOT_RUNTIME_DIR_PHRASE is defined to NULL."
       fi
       export KRELL_ROOT_RUNTIME_DIR_PHRASE=""
       export CMAKE_RUNTIME_DIR_PHRASE=""
       export CMAKE_RUNTIME_DIR_PHRASE=""
   fi
   
   # Process the compute node --with-cn-dyninst install-tool argument setting up for cmake build
   # in the build_cbtf_krell_routine
   if [ $KRELL_ROOT_CN_DYNINST ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_DYNINST is defined to $KRELL_ROOT_CN_DYNINST."
       fi
       export CMAKE_CN_DYNINST_PHRASE="-DDYNINST_CN_RUNTIME_DIR=${KRELL_ROOT_CN_DYNINST}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_DYNINST is undefined, setting to blanks"
       fi
       export KRELL_ROOT_CN_DYNINST=""
       export CMAKE_CN_DYNINST_PHRASE=""
   fi
   
   
   if [ $KRELL_ROOT_DYNINST ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_DYNINST is defined to $KRELL_ROOT_DYNINST."
       fi
       export KRELL_ROOT_DYNINST_PHRASE="--with-dyninst=$KRELL_ROOT_DYNINST"
       export CMAKE_DYNINST_PHRASE="-DDYNINST_DIR=${KRELL_ROOT_DYNINST}"
   else
       if test -f $KRELL_ROOT_PREFIX/$LIBDIR/libdyninstAPI.so; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_DYNINST is undefined, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_DYNINST=$KRELL_ROOT_PREFIX
           export KRELL_ROOT_DYNINST_PHRASE="--with-dyninst=$KRELL_ROOT_PREFIX"
           export CMAKE_DYNINST_PHRASE="-DDYNINST_DIR=${KRELL_ROOT_PREFIX}"
       else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_DYNINST is undefined, setting to blanks"
           fi
           export KRELL_ROOT_DYNINST=""
           export KRELL_ROOT_DYNINST_PHRASE=""
           export CMAKE_DYNINST_PHRASE=""
       fi
   fi
   
   if [ $KRELL_ROOT_DYNINST_LIB ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_DYNINST_LIB is defined to $KRELL_ROOT_DYNINST_LIB."
       fi
       export KRELL_ROOT_DYNINST_LIB_PHRASE="--with-dyninst-libdir=$KRELL_ROOT_DYNINST/$LIBDIR"
   else
       if [ $KRELL_ROOT_DYNINST ]; then
           if test -f $KRELL_ROOT_DYNINST/$LIBDIR/libdyninstAPI.so; then
               export KRELL_ROOT_DYNINST_LIB_PHRASE="--with-dyninst-libdir=$KRELL_ROOT_DYNINST/$LIBDIR"
           elif test -f $KRELL_ROOT_DYNINST/$ALTLIBDIR/libdyninstAPI.so; then
               export KRELL_ROOT_DYNINST_LIB_PHRASE="--with-dyninst-libdir=$KRELL_ROOT_DYNINST/$ALTLIBDIR"
           else
               export KRELL_ROOT_DYNINST_LIB_PHRASE=""
           fi
       else
           if test -f /usr/lib64/dyninst/libdyninstAPI.so; then
               export KRELL_ROOT_DYNINST_LIB_PHRASE="--with-dyninst-libdir=/usr/lib64/dyninst"
           elif test -f /usr/lib/dyninst/libdyninstAPI.so; then
               export KRELL_ROOT_DYNINST_LIB_PHRASE="--with-dyninst-libdir=/usr/lib/dyninst"
           else
               export KRELL_ROOT_DYNINST_LIB_PHRASE=""
           fi
       fi
   fi
   
   if [ $KRELL_ROOT_DYNINST_VERS ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_DYNINST_VERS is defined, use KRELL_ROOT_DYNINST_VERS=$KRELL_ROOT_DYNINST_VERS"
       fi
       export KRELL_ROOT_DYNINST_VERS_PHRASE="--with-dyninst-version=$KRELL_ROOT_DYNINST_VERS"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_DYNINST_VERS is undefined, use default value of 8.2.0."
       fi
       export KRELL_ROOT_DYNINST_VERS_PHRASE="--with-dyninst-version=8.2.0"
   fi
   
   if [ $KRELL_ROOT_MRNET_VERS ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MRNET_VERS is defined to $KRELL_ROOT_MRNET_VERS"
       fi
       export KRELL_ROOT_MRNET_VERS_PHRASE="--with-mrnet-version=$KRELL_ROOT_MRNET_VERS"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MRNET_VERS is undefined, export default 4.1.0."
       fi
       export KRELL_ROOT_MRNET_VERS_PHRASE="--with-mrnet-version=4.1.0"
   fi
   
   if [ $KRELL_ROOT_SYMTABAPI_VERS ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_SYMTABAPI_VERS is defined to $KRELL_ROOT_SYMTABAPI_VERS"
       fi
       export KRELL_ROOT_SYMTABAPI_VERS_PHRASE="--with-symtabapi-version=$KRELL_ROOT_SYMTABAPI_VERS"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_SYMTABAPI_VERS is undefined, export 8.1.2."
       fi
       export KRELL_ROOT_SYMTABAPI_VERS="--with-symtabapi-version=8.1.2"
   fi
   
   
   if [ $KRELL_ROOT_LIBELF ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_LIBELF is defined to $KRELL_ROOT_LIBELF."
       fi
       export KRELL_ROOT_LIBELF_PHRASE="--with-libelf=$KRELL_ROOT_LIBELF"
       export CMAKE_LIBELF_PHRASE="-DLIBELF_DIR=${KRELL_ROOT_LIBELF}"
   else
       if test -f $KRELL_ROOT_PREFIX/$LIBDIR/libelf.so; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_LIBELF is undefined, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_LIBELF=$KRELL_ROOT_PREFIX
           export KRELL_ROOT_LIBELF_PHRASE="--with-libelf=$KRELL_ROOT_PREFIX"
           export CMAKE_LIBELF_PHRASE="-DLIBELF_DIR=${KRELL_ROOT_PREFIX}"
       else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_LIBELF is undefined, setting to blanks"
           fi
           export KRELL_ROOT_LIBELF=
           export KRELL_ROOT_LIBELF_PHRASE=""
           export CMAKE_LIBELF_PHRASE=""
       fi
   fi
   
   if [ $KRELL_ROOT_LIBDWARF ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_LIBDWARF is defined to $KRELL_ROOT_LIBDWARF."
       fi
       export KRELL_ROOT_LIBDWARF_PHRASE="--with-libdwarf=$KRELL_ROOT_LIBDWARF"
       export CMAKE_LIBDWARF_PHRASE="-DLIBDWARF_DIR=${KRELL_ROOT_LIBDWARF}"
   else
       if test -f $KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.so; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_LIBDWARF is undefined, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_LIBDWARF=$KRELL_ROOT_PREFIX
           export KRELL_ROOT_LIBDWARF_PHRASE="--with-libdwarf=$KRELL_ROOT_PREFIX"
           export CMAKE_LIBDWARF_PHRASE="-DLIBDWARF_DIR=${KRELL_ROOT_PREFIX}"
       else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_LIBDWARF is undefined, setting to blanks"
           fi
           export KRELL_ROOT_LIBDWARF=
           export KRELL_ROOT_LIBDWARF_PHRASE=""
           export CMAKE_LIBDWARF_PHRASE=""
       fi
   fi
   
   # Process the compute node --with-cn-libmonitor install-tool argument setting up for cmake build
   # in the build_cbtf_krell_routine
   if [ $KRELL_ROOT_CN_LIBMONITOR ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_LIBMONITOR is defined to $KRELL_ROOT_CN_LIBMONITOR."
       fi
       export CMAKE_CN_LIBMONITOR_PHRASE="-DLIBMONITOR_CN_RUNTIME_DIR=${KRELL_ROOT_CN_LIBMONITOR}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_LIBMONITOR is undefined, setting to blanks"
       fi
       export KRELL_ROOT_CN_LIBMONITOR=""
       export CMAKE_CN_LIBMONITOR_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_LIBMONITOR ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_LIBMONITOR is defined to $KRELL_ROOT_LIBMONITOR."
       fi
       export KRELL_ROOT_LIBMONITOR_PHRASE="--with-libmonitor=$KRELL_ROOT_LIBMONITOR"
       export CMAKE_LIBMONITOR_PHRASE="-DLIBMONITOR_DIR=${KRELL_ROOT_LIBMONITOR}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_LIBMONITOR is not defined."
           echo "setting-up: KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           echo "setting-up: KRELL_ROOT_PREFIX/LIBDIR=$KRELL_ROOT_PREFIX/$LIBDIR"
       fi
       if test -f $KRELL_ROOT_PREFIX/$LIBDIR/libmonitor_wrap.a -o -f $KRELL_ROOT_PREFIX/$LIBDIR/libmonitor.so; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_LIBMONITOR is undefined, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_LIBMONITOR=$KRELL_ROOT_PREFIX
           export KRELL_ROOT_LIBMONITOR_PHRASE="--with-libmonitor=$KRELL_ROOT_PREFIX"
           export CMAKE_LIBMONITOR_PHRASE="-DLIBMONITOR_DIR=${KRELL_ROOT_PREFIX}"
       else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_LIBMONITOR is undefined, setting to blanks"
           fi
           export KRELL_ROOT_LIBMONITOR=
           export KRELL_ROOT_LIBMONITOR_PHRASE=""
           export CMAKE_LIBMONITOR_PHRASE=""
       fi
   fi


   if [ $KRELL_ROOT_ZLIB ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_ZLIB is defined to $KRELL_ROOT_ZLIB."
       fi
       export KRELL_ROOT_ZLIB_PHRASE="--with-libz=$KRELL_ROOT_ZLIB"
       export CMAKE_ZLIB_PHRASE="-DZLIB_DIR=${KRELL_ROOT_ZLIB}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_ZLIB is not defined."
           echo "setting-up: KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           echo "setting-up: KRELL_ROOT_PREFIX/LIBDIR=$KRELL_ROOT_PREFIX/$LIBDIR"
       fi
       if test -f $KRELL_ROOT_PREFIX/$LIBDIR/libz.so -o -f $KRELL_ROOT_PREFIX/$LIBDIR/libdw.so; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_ZLIB is undefined, but zlib is found in KRELL_ROOT_PREFIX, setting to KRELL_ROOT_ZLIB=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_ZLIB=$KRELL_ROOT_PREFIX
           export KRELL_ROOT_ZLIB_PHRASE="--with-libz=$KRELL_ROOT_PREFIX"
           export CMAKE_ZLIB_PHRASE="-DZLIB_DIR=${KRELL_ROOT_PREFIX}"
       elif [ -f /usr/$LIBDIR/libz.so -o -f /usr/$LIBDIR/libdw.so ]; then
         echo "    NOTE: libz detected in /usr/<lib>..."
         found_libz=1
       else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_ZLIB is undefined and not found in KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX, setting to blanks"
           fi
           export KRELL_ROOT_ZLIB=
           export KRELL_ROOT_ZLIB_PHRASE=""
           export CMAKE_ZLIB_PHRASE=""
       fi
   fi
    
   
   # Process the compute node --with-cn-libunwind install-tool argument setting up for cmake build
   # in the build_cbtf_krell_routine
   if [ $KRELL_ROOT_CN_LIBUNWIND ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_LIBUNWIND is defined to $KRELL_ROOT_CN_LIBUNWIND."
       fi
       export CMAKE_CN_LIBUNWIND_PHRASE="-DLIBUNWIND_CN_RUNTIME_DIR=${KRELL_ROOT_CN_LIBUNWIND}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_LIBUNWIND is undefined, setting to blanks"
       fi
       export KRELL_ROOT_CN_LIBUNWIND=""
       export CMAKE_CN_LIBUNWIND_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_LIBUNWIND ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_LIBUNWIND is defined to $KRELL_ROOT_LIBUNWIND."
       fi
       export KRELL_ROOT_LIBUNWIND_PHRASE="--with-libunwind=$KRELL_ROOT_LIBUNWIND"
       export CMAKE_LIBUNWIND_PHRASE="-DLIBUNWIND_DIR=${KRELL_ROOT_LIBUNWIND}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_LIBUNWIND is not defined."
           echo "setting-up: KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           echo "setting-up: KRELL_ROOT_PREFIX/LIBDIR=$KRELL_ROOT_PREFIX/$LIBDIR"
       fi
       if test -f $KRELL_ROOT_PREFIX/$LIBDIR/libunwind.so -o -f $KRELL_ROOT_PREFIX/$LIBDIR/libunwind.a; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_LIBUNWIND is undefined, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_LIBUNWIND=$KRELL_ROOT_PREFIX
           export KRELL_ROOT_LIBUNWIND_PHRASE="--with-libunwind=$KRELL_ROOT_PREFIX"
           export CMAKE_LIBUNWIND_PHRASE="-DLIBUNWIND_DIR=${KRELL_ROOT_PREFIX}"
       else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_LIBUNWIND is undefined, setting to blanks"
           fi
           export KRELL_ROOT_LIBUNWIND=
           export KRELL_ROOT_LIBUNWIND_PHRASE=""
           export CMAKE_LIBUNWIND_PHRASE=""
       fi
   fi
   
   # Process the compute node --with-cn-mrnet install-tool argument setting up for cmake build
   # in the build_cbtf_krell_routine
   if [ $KRELL_ROOT_CN_MRNET ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_MRNET is defined to $KRELL_ROOT_CN_MRNET."
       fi
       export CMAKE_CN_MRNET_PHRASE="-DMRNET_CN_RUNTIME_DIR=${KRELL_ROOT_CN_MRNET}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_MRNET is undefined, setting to blanks"
       fi
       export KRELL_ROOT_CN_MRNET=""
       export CMAKE_CN_MRNET_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_MRNET ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MRNET is defined to $KRELL_ROOT_MRNET."
       fi
       export KRELL_ROOT_MRNET_PHRASE="--with-mrnet=$KRELL_ROOT_MRNET"
       export CMAKE_MRNET_PHRASE="-DMRNET_DIR=${KRELL_ROOT_MRNET}"
   else
       if test -f $KRELL_ROOT_PREFIX/$LIBDIR/libmrnet.a; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_MRNET is undefined, setting to $KRELL_ROOT_MRNET=${KRELL_ROOT_PREFIX}"
           fi
           export KRELL_ROOT_MRNET=$KRELL_ROOT_PREFIX
           export KRELL_ROOT_MRNET_PHRASE="--with-mrnet=$KRELL_ROOT_PREFIX"
           export CMAKE_MRNET_PHRASE="-DMRNET_DIR=${KRELL_ROOT_PREFIX}"
       else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_MRNET is undefined, setting to blanks"
           fi
           export KRELL_ROOT_MRNET=
           export KRELL_ROOT_MRNET_PHRASE=""
           export CMAKE_MRNET_PHRASE=""
       fi
   fi
   
   if [ $KRELL_ROOT_SQLITE ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_SQLITE is defined to $KRELL_ROOT_SQLITE."
       fi
       export CMAKE_SQLITE3_PHRASE="-DSQLITE3_DIR=${KRELL_ROOT_SQLITE}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_SQLITE is not defined."
           echo "setting-up: KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           echo "setting-up: KRELL_ROOT_PREFIX/LIBDIR=$KRELL_ROOT_PREFIX/$LIBDIR"
       fi
       if test -f $KRELL_ROOT_PREFIX/$LIBDIR/libsqlite3.so; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_SQLITE is undefined, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_SQLITE=$KRELL_ROOT_PREFIX
           export KRELL_ROOT_SQLITE_PHRASE="--with-sqlite=$KRELL_ROOT_PREFIX"
           export CMAKE_SQLITE3_PHRASE="-DSQLITE3_DIR=${KRELL_ROOT_PREFIX}"
       else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_SQLITE is undefined, setting to blanks"
           fi
           export KRELL_ROOT_SQLITE=
           export KRELL_ROOT_SQLITE_PHRASE=""
           export CMAKE_SQLITE3_PHRASE=""
       fi
   fi
   
   
   if [ $KRELL_ROOT_SYMTABAPI ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_SYMTABAPI is defined to ${KRELL_ROOT_SYMTABAPI}."
       fi
       export KRELL_ROOT_SYMTABAPI=$KRELL_ROOT_SYMTABAPI
       export KRELL_ROOT_SYMTABAPI_PHRASE="--with-symtabapi=$KRELL_ROOT_SYMTABAPI"
       export CMAKE_SYMTABAPI_PHRASE="-DSYMTABAPI_DIR=${KRELL_ROOT_SYMTABAPI}"
   else
       if test -f $KRELL_ROOT_PREFIX/$LIBDIR/libsymtabAPI.so -o -f $KRELL_ROOT_PREFIX/$ALTLIBDIR/libsymtabAPI.so; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_SYMTABAPI is undefined, setting to ${KRELL_ROOT_PREFIX}"
           fi
           export KRELL_ROOT_SYMTABAPI=$KRELL_ROOT_PREFIX
           export KRELL_ROOT_SYMTABAPI_PHRASE="--with-symtabapi=$KRELL_ROOT_PREFIX"
           export CMAKE_SYMTABAPI_PHRASE="-DSYMTABAPI_DIR=${KRELL_ROOT_PREFIX}"
       else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_SYMTABAPI is undefined, setting to blanks"
           fi
           export KRELL_ROOT_SYMTABAPI_PHRASE=""
           export CMAKE_SYMTABAPI_PHRASE=""
       fi
   fi
   
   if [ $KRELL_ROOT_SYMTABAPI_LIB ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_SYMTABAPI_LIB is defined to $KRELL_ROOT_SYMTABAPI_LIB."
       fi
       export KRELL_ROOT_SYMTABAPI_LIB_PHRASE="--with-symtabapi-libdir=$KRELL_ROOT_SYMTABAPI/$LIBDIR"
   else
       if [ $KRELL_ROOT_SYMTABAPI ]; then
           if test -f $KRELL_ROOT_SYMTABAPI/$LIBDIR/libsymtabAPI.so; then
               export KRELL_ROOT_SYMTABAPI_LIB_PHRASE="--with-symtabapi-libdir=$KRELL_ROOT_SYMTABAPI/$LIBDIR"
           elif test -f $KRELL_ROOT_SYMTABAPI/$ALTLIBDIR/libsymtabAPI.so; then
               export KRELL_ROOT_SYMTABAPI_LIB_PHRASE="--with-symtabapi-libdir=$KRELL_ROOT_SYMTABAPI/$ALTLIBDIR"
           else
               export KRELL_ROOT_SYMTABAPI_LIB_PHRASE=""
           fi
       else
           export KRELL_ROOT_SYMTABAPI_LIB_PHRASE=""
       fi
   fi
   
   # Process the compute node --with-cn-papi install-tool argument setting up for cmake build
   # in the build_cbtf_krell_routine
   if [ $KRELL_ROOT_CN_PAPI ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_PAPI is defined to $KRELL_ROOT_CN_PAPI."
       fi
       export CMAKE_CN_PAPI_PHRASE="-DPAPI_CN_RUNTIME_DIR=${KRELL_ROOT_CN_PAPI}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_PAPI is undefined, setting to blanks"
       fi
       export KRELL_ROOT_CN_PAPI=""
       export CMAKE_CN_PAPI_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_PAPI ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_PAPI is defined to $KRELL_ROOT_PAPI."
       fi
       export KRELL_ROOT_PAPI_PHRASE="--with-papi=$KRELL_ROOT_PAPI"
       export CMAKE_PAPI_PHRASE="-DPAPI_DIR=$KRELL_ROOT_PAPI"
   else
       if test -f $KRELL_ROOT_PREFIX/$LIBDIR/libpapi.so; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_PAPI is undefined, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_PAPI=$KRELL_ROOT_PREFIX
           export KRELL_ROOT_PAPI_PHRASE="--with-papi=$KRELL_ROOT_PREFIX"
           export CMAKE_PAPI_PHRASE="-DPAPI_DIR=$KRELL_ROOT_PREFIX"
       else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_PAPI is undefined, setting to blanks"
           fi
           export KRELL_ROOT_PAPI=
           export KRELL_ROOT_PAPI_PHRASE=""
           export CMAKE_PAPI_PHRASE=""
       fi
   fi
   
   if [ $KRELL_ROOT_BINUTILS ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_BINUTILS is defined to $KRELL_ROOT_BINUTILS"
       fi
       export KRELL_ROOT_BINUTILS_PHRASE="--with-binutils=$KRELL_ROOT_BINUTILS"
       export CMAKE_BINUTILS_PHRASE="-DBINUTILS_DIR=$KRELL_ROOT_BINUTILS"
   else
       if test -f $KRELL_ROOT_PREFIX/$LIBDIR/libbfd.so; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_BINUTILS is undefined, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_BINUTILS=$KRELL_ROOT_PREFIX
           export KRELL_ROOT_BINUTILS_PHRASE="--with-binutils=$KRELL_ROOT_PREFIX"
           export CMAKE_BINUTILS_PHRASE="-DBINUTILS_DIR=$KRELL_ROOT_PREFIX"
       elif test -d $KRELL_ROOT_PREFIX/binutils -a -f $KRELL_ROOT_PREFIX/binutils/$LIBDIR/libbfd.so; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_BINUTILS is undefined, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_BINUTILS=$KRELL_ROOT_PREFIX/binutils
           export KRELL_ROOT_BINUTILS_PHRASE="--with-binutils=$KRELL_ROOT_BINUTILS"
           export CMAKE_BINUTILS_PHRASE="-DBINUTILS_DIR=$KRELL_ROOT_BINUTILS"
       elif test -d $KRELL_ROOT_PREFIX/binutils -a -f $KRELL_ROOT_PREFIX/binutils/$ALTLIBDIR/libbfd.so; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_BINUTILS is undefined, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_BINUTILS=$KRELL_ROOT_PREFIX/binutils
           export KRELL_ROOT_BINUTILS_PHRASE="--with-binutils=$KRELL_ROOT_BINUTILS"
           export CMAKE_BINUTILS_PHRASE="-DBINUTILS_DIR=$KRELL_ROOT_BINUTILS"
       else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_BINUTILS is undefined, setting to blanks"
           fi
           export KRELL_ROOT_BINUTILS=
           export KRELL_ROOT_BINUTILS_PHRASE=""
           export CMAKE_BINUTILS_PHRASE=""
       fi
   fi
   
   # Process the compute node --with-cn-boost install-tool argument setting up for cmake build
   # in the build_cbtf_krell_routine
   if [ $KRELL_ROOT_CN_BOOST ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_BOOST is defined to $KRELL_ROOT_CN_BOOST."
       fi
       export CMAKE_CN_BOOST_PHRASE="-DBOOST_CN_RUNTIME_DIR=${KRELL_ROOT_CN_BOOST}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_BOOST is undefined, setting to blanks"
       fi
       export KRELL_ROOT_CN_BOOST=""
       export CMAKE_CN_BOOST_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_BOOST ]; then
       export KRELL_ROOT_BOOST_PHRASE="--with-boost=$KRELL_ROOT_BOOST"
       export CMAKE_BOOST_PHRASE1="-DBOOST_ROOT=$KRELL_ROOT_BOOST"
       export CMAKE_BOOST_PHRASE2="-DBoost_DIR=$KRELL_ROOT_BOOST"
       export CMAKE_BOOST_SYSPATH_PHRASE="-DBoost_NO_SYSTEM_PATHS=TRUE"
       export CMAKE_BOOST_CMAKE_PHRASE="-DBoost_NO_BOOST_CMAKE=TRUE"
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_BOOST is defined to $KRELL_ROOT_BOOST"
           #echo "setting-up: KRELL_ROOT_BOOST_PHRASE is set to ${KRELL_ROOT_BOOST_PHRASE}."
           echo "setting-up: CMAKE_BOOST_PHRASE1 is set to ${CMAKE_BOOST_PHRASE1}."
           echo "setting-up: CMAKE_BOOST_PHRASE2 is set to ${CMAKE_BOOST_PHRASE2}."
           echo "setting-up: CMAKE_BOOST_SYSPATH_PHRASE is set to ${CMAKE_BOOST_SYSPATH_PHRASE}."
           echo "setting-up: CMAKE_BOOST_CMAKE_PHRASE is set to ${CMAKE_BOOST_CMAKE_PHRASE}."
       fi

       if test -f $KRELL_ROOT_BOOST/lib64/libboost_system.so; then
           export KRELL_ROOT_BOOST_LIB_PHRASE="--with-boost-libdir=$KRELL_ROOT_BOOST/lib64"
           export CMAKE_BOOST_LIB_PHRASE="-DBOOST_LIBRARYDIR=$KRELL_ROOT_BOOST/lib64"
       elif test -f $KRELL_ROOT_BOOST/lib/libboost_system.so; then
           export KRELL_ROOT_BOOST_LIB_PHRASE="--with-boost-libdir=$KRELL_ROOT_BOOST/lib"
           export CMAKE_BOOST_LIB_PHRASE="-DBOOST_LIBRARYDIR=$KRELL_ROOT_BOOST/lib"
       fi
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: CMAKE_BOOST_LIB_PHRASE is set to ${CMAKE_BOOST_LIB_PHRASE}."
       fi
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_BOOST is NOT defined."
       fi
       if test -f $KRELL_ROOT_PREFIX/lib64/libboost_system.so; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_BOOST is undefined, setting to KRELL_ROOT_BOOST=$KRELL_ROOT_PREFIX"
           fi
           export CMAKE_BOOST_PHRASE1="-DBOOST_ROOT=$KRELL_ROOT_PREFIX"
           export CMAKE_BOOST_PHRASE2="-DBoost_DIR=$KRELL_ROOT_PREFIX"
           export KRELL_ROOT_BOOST_PHRASE="--with-boost=$KRELL_ROOT_PREFIX"
           export KRELL_ROOT_BOOST_LIB_PHRASE="--with-boost-libdir=$KRELL_ROOT_PREFIX/lib64"
           export KRELL_ROOT_BOOST=$KRELL_ROOT_PREFIX
           export CMAKE_BOOST_LIB_PHRASE="-DBOOST_LIBRARYDIR=$KRELL_ROOT_PREFIX/lib64"
           export CMAKE_BOOST_SYSPATH_PHRASE="-DBoost_NO_SYSTEM_PATHS=TRUE"
           export CMAKE_BOOST_CMAKE_PHRASE="-DBoost_NO_BOOST_CMAKE=TRUE"
       elif test -f $KRELL_ROOT_PREFIX/lib/libboost_system.so; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_BOOST is undefined, setting to $KRELL_ROOT_BOOST=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_BOOST_PHRASE="--with-boost=$KRELL_ROOT_PREFIX"
           export KRELL_ROOT_BOOST_LIB_PHRASE="--with-boost-libdir=$KRELL_ROOT_PREFIX/lib"
           export CMAKE_BOOST_PHRASE1="-DBOOST_ROOT=$KRELL_ROOT_PREFIX"
           export CMAKE_BOOST_PHRASE2="-DBoost_DIR=$KRELL_ROOT_PREFIX"
           export KRELL_ROOT_BOOST=${KRELL_ROOT_PREFIX}
           export CMAKE_BOOST_LIB_PHRASE="-DBOOST_LIBRARYDIR=$KRELL_ROOT_PREFIX/lib"
           export CMAKE_BOOST_SYSPATH_PHRASE="-DBoost_NO_SYSTEM_PATHS=TRUE"
           export CMAKE_BOOST_CMAKE_PHRASE="-DBoost_NO_BOOST_CMAKE=TRUE"
       else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_BOOST is undefined, setting to blanks"
           fi
           export KRELL_ROOT_BOOST_PHRASE=""
           export KRELL_ROOT_BOOST_LIB_PHRASE=""
           export CMAKE_BOOST_PHRASE1=""
           export CMAKE_BOOST_PHRASE2=""
           export CMAKE_BOOST_SYSPATH_PHRASE=""
           export CMAKE_BOOST_CMAKE_PHRASE=""
           export CMAKE_BOOST_LIB_PHRASE=""
       fi
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: CMAKE_BOOST_PHRASE1 is set to ${CMAKE_BOOST_PHRASE1}."
           echo "setting-up: CMAKE_BOOST_PHRASE2 is set to ${CMAKE_BOOST_PHRASE2}."
           echo "setting-up: CMAKE_BOOST_LIB_PHRASE is set to ${CMAKE_BOOST_LIB_PHRASE}."
           echo "setting-up: CMAKE_BOOST_SYSPATH_PHRASE is set to ${CMAKE_BOOST_SYSPATH_PHRASE}."
           echo "setting-up: CMAKE_BOOST_CMAKE_PHRASE is set to ${CMAKE_BOOST_CMAKE_PHRASE}."
       fi
   fi
   
   # Process the compute node --with-cn-xercesc install-tool argument setting up for cmake build
   # in the build_cbtf_krell_routine
   if [ $KRELL_ROOT_CN_XERCESC ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_XERCESC is defined to $KRELL_ROOT_CN_XERCESC."
       fi
       export CMAKE_CN_XERCESC_PHRASE="-DXERCESC_CN_RUNTIME_DIR=${KRELL_ROOT_CN_XERCESC}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_CN_XERCESC is undefined, setting to blanks"
       fi
       export KRELL_ROOT_CN_XERCESC=""
       export CMAKE_CN_XERCESC_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_XERCESC ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_XERCESC is defined to $KRELL_ROOT_XERCESC"
       fi
       export KRELL_ROOT_XERCESC_PHRASE="--with-libxerces-c-prefix=$KRELL_ROOT_XERCESC"
       export CMAKE_XERCESC_PHRASE="-DXERCESC_DIR=${KRELL_ROOT_XERCESC}"
       if test -f $KRELL_ROOT_XERCESC/lib64/libxerces-c.so; then
           export KRELL_ROOT_XERCESC_LIB_PHRASE="--with-libxerces-c-libdir=$KRELL_ROOT_XERCESC/lib64"
       elif test -f $KRELL_ROOT_XERCESC/lib/libxerces-c.so; then
           export KRELL_ROOT_XERCESC_LIB_PHRASE="--with-libxerces-c-libdir=$KRELL_ROOT_XERCESC/lib"
       fi
   else
       if test -f $KRELL_ROOT_PREFIX/lib64/libxerces-c.so; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_XERCESC is undefined, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_XERCESC=$KRELL_ROOT_PREFIX
           export KRELL_ROOT_XERCESC_LIB=$KRELL_ROOT_PREFIX/lib64
           export KRELL_ROOT_XERCESC_PHRASE="--with-libxerces-c-prefix=$KRELL_ROOT_PREFIX"
           export CMAKE_XERCESC_PHRASE="-DXERCESC_DIR=${KRELL_ROOT_PREFIX}"
           export KRELL_ROOT_XERCESC_LIB_PHRASE="--with-libxerces-c-libdir=$KRELL_ROOT_PREFIX/lib64"
       elif test -f $KRELL_ROOT_PREFIX/lib/libxerces-c.so; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_XERCESC is undefined, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_XERCESC=$KRELL_ROOT_PREFIX
           export KRELL_ROOT_XERCESC_LIB=$KRELL_ROOT_PREFIX/lib
           export KRELL_ROOT_XERCESC_PHRASE="--with-libxerces-c-prefix=$KRELL_ROOT_PREFIX"
           export KRELL_ROOT_XERCESC_LIB_PHRASE="--with-libxerces-c-libdir=$KRELL_ROOT_PREFIX/lib"
           export CMAKE_XERCESC_PHRASE="-DXERCESC_DIR=${KRELL_ROOT_PREFIX}"
       else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_XERCESC is undefined, setting to blanks"
           fi
           export KRELL_ROOT_XERCESC=
           export KRELL_ROOT_XERCESC_PHRASE=""
           export KRELL_ROOT_XERCESC_LIB_PHRASE=""
           export CMAKE_XERCESC_PHRASE=""
       fi
   fi
   
   if [ $KRELL_ROOT_PYTHON ]; then
       if [ "$display_summary" = 1 ] ; then 
          echo "setting-up: KRELL_ROOT_PYTHON is defined to $KRELL_ROOT_PYTHON"
       fi
       export KRELL_ROOT_PYTHON_PHRASE="--with-python=$KRELL_ROOT_PYTHON"
       export CMAKE_PYTHON_PHRASE1="-DPYTHON_DIR=${KRELL_ROOT_PYTHON}"
       export CMAKE_PYTHON_PHRASE2="-DPYTHON_EXECUTABLE=${KRELL_ROOT_PYTHON}/bin/python"
       if [ $KRELL_ROOT_PYTHON_VERS ]; then
           export CMAKE_PYTHON_PHRASE3="-DPYTHON_INCLUDE_DIR=${KRELL_ROOT_PYTHON}/include/python${KRELL_ROOT_PYTHON_VERS}"
           if test -f $KRELL_ROOT_PYTHON/lib/libpython${KRELL_ROOT_PYTHON_VERS}.so ; then
               export CMAKE_PYTHON_PHRASE4="-DPYTHON_LIBRARY=${KRELL_ROOT_PYTHON}/lib/libpython${KRELL_ROOT_PYTHON_VERS}.so"
           elif test -f $KRELL_ROOT_PYTHON/lib64/libpython${KRELL_ROOT_PYTHON_VERS}.so ; then
               export CMAKE_PYTHON_PHRASE4="-DPYTHON_LIBRARY=${KRELL_ROOT_PYTHON}/lib64/libpython${KRELL_ROOT_PYTHON_VERS}.so"
           fi
       else
           export CMAKE_PYTHON_PHRASE3=""
           export CMAKE_PYTHON_PHRASE4=""
       fi
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_PYTHON is undefined, setting to blanks"
       fi
       #export KRELL_ROOT_PYTHON_PHRASE="--with-python=/usr"
       #export KRELL_ROOT_PYTHON=/usr
       export KRELL_ROOT_PYTHON_PHRASE=""
       export CMAKE_PYTHON_PHRASE1=""
       export CMAKE_PYTHON_PHRASE2=""
       export CMAKE_PYTHON_PHRASE3=""
       export CMAKE_PYTHON_PHRASE4=""
   fi
   if [ "$display_summary" = 1 ] ; then 
       echo "setting-up: CMAKE_PYTHON_PHRASE1 is defined to $CMAKE_PYTHON_PHRASE1."
       echo "setting-up: CMAKE_PYTHON_PHRASE2 is defined to $CMAKE_PYTHON_PHRASE2."
       echo "setting-up: CMAKE_PYTHON_PHRASE3 is defined to $CMAKE_PYTHON_PHRASE3."
       echo "setting-up: CMAKE_PYTHON_PHRASE4 is defined to $CMAKE_PYTHON_PHRASE4."
   fi
   
   if [ $KRELL_ROOT_TLS_TYPE ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_TLS_TYPE is defined, setting KRELL_ROOT_TLS_TYPE to ${KRELL_ROOT_TLS_TYPE}."
       fi
       export KRELL_ROOT_TLS_TYPE_PHRASE="--with-tls=$KRELL_ROOT_TLS_TYPE"
       export CMAKE_TLS_TYPE_PHRASE="-DTLS_MODEL=${KRELL_ROOT_TLS_TYPE}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_TLS_TYPE is undefined, setting KRELL_ROOT_TLS_TYPE to default value of implicit"
       fi
       export KRELL_ROOT_TLS_TYPE_PHRASE="--with-tls=implicit"
       export CMAKE_TLS_TYPE_PHRASE="-DTLS_MODEL=implicit"
   fi
   
   if [ $KRELL_ROOT_RESOLVE_SYMBOLS ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_RESOLVE_SYMBOLS is defined, using KRELL_ROOT_RESOLVE_SYMBOLS=$KRELL_ROOT_RESOLVE_SYMBOLS."
       fi
       export KRELL_ROOT_RESOLVE_SYMBOLS_PHRASE="--enable-resolve-symbols=$KRELL_ROOT_RESOLVE_SYMBOLS"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_RESOLVE_SYMBOLS is undefined, setting KRELL_ROOT_RESOLVE_SYMBOLS to symtabapi"
       fi
       export KRELL_ROOT_RESOLVE_SYMBOLS_PHRASE="--enable-resolve-symbols=symtabapi"
   fi
   
   if [ $KRELL_ROOT_OTF ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_OTF is defined to $KRELL_ROOT_OTF"
       fi
       export KRELL_ROOT_OTF_PHRASE="--with-otf=$KRELL_ROOT_OTF"
       export CMAKE_OTF_PHRASE="-DOTF_DIR=${KRELL_ROOT_OTF}"
   else
       if test -f $KRELL_ROOT_PREFIX/$LIBDIR/libotf.a; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_OTF is undefined, found in $LIBDIR, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_OTF=$KRELL_ROOT_PREFIX
           export KRELL_ROOT_OTF_PHRASE="--with-otf=$KRELL_ROOT_PREFIX"
           export CMAKE_OTF_PHRASE="-DOTF_DIR=${KRELL_ROOT_PREFIX}"
       elif test -f $KRELL_ROOT_PREFIX/$ALTLIBDIR/libotf.a; then
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_OTF is undefined, found in $ALTLIBDIR, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
           fi
           export KRELL_ROOT_OTF=$KRELL_ROOT_PREFIX
           export KRELL_ROOT_OTF_PHRASE="--with-otf=$KRELL_ROOT_PREFIX"
           export CMAKE_OTF_PHRASE="-DOTF_DIR=${KRELL_ROOT_PREFIX}"
       else
           if [ "$display_summary" = 1 ] ; then 
               echo "setting-up: KRELL_ROOT_OTF is undefined, setting to blanks"
           fi
           export KRELL_ROOT_OTF=
           export KRELL_ROOT_OTF_PHRASE=""
           export CMAKE_OTF_PHRASE=""
       fi
   fi
   
   if [ $KRELL_ROOT_PTGF_BUILD_OPTION ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_PTGF_BUILD_OPTION is defined to $KRELL_ROOT_PTGF_BUILD_OPTION."
       fi
       export KRELL_ROOT_PTGF_BUILD_OPTION_PHRASE="--with-ptgf=$KRELL_ROOT_PTGF_BUILD_OPTION"
       export CMAKE_PTGF_BUILD_OPTION_PHRASE="-DBUILD_PTGF=$KRELL_ROOT_PTGF_BUILD_OPTION"
   else
       export KRELL_ROOT_PTGF_BUILD_OPTION_PHRASE=""
       export CMAKE_PTGF_BUILD_OPTION_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_VT ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_VT is defined to $KRELL_ROOT_VT."
       fi
       export KRELL_ROOT_VT_PHRASE="--with-vt=$KRELL_ROOT_VT"
       export CMAKE_VT_PHRASE="-DVT_DIR=${KRELL_ROOT_VT}"
   else
       if test -f $KRELL_ROOT_PREFIX/$LIBDIR/libvt.a; then
          if [ "$display_summary" = 1 ] ; then 
              echo "setting-up: KRELL_ROOT_VT is undefined, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          fi
          export KRELL_ROOT_VT=$KRELL_ROOT_PREFIX
          export KRELL_ROOT_VT_PHRASE="--with-vt=$KRELL_ROOT_PREFIX"
          export CMAKE_VT_PHRASE="-DVT_DIR=${KRELL_ROOT_PREFIX}"
       elif test -f $KRELL_ROOT_PREFIX/$ALTLIBDIR/libvt.a; then
          if [ "$display_summary" = 1 ] ; then 
              echo "setting-up: KRELL_ROOT_VT is undefined, setting to KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          fi
          export KRELL_ROOT_VT=$KRELL_ROOT_PREFIX
          export KRELL_ROOT_VT_PHRASE="--with-vt=$KRELL_ROOT_PREFIX"
          export CMAKE_VT_PHRASE="-DVT_DIR=${KRELL_ROOT_PREFIX}"
       else
          if [ "$display_summary" = 1 ] ; then 
              echo "setting-up: KRELL_ROOT_VT is undefined, setting to blanks"
          fi
          export KRELL_ROOT_VT=
          export KRELL_ROOT_VT_PHRASE=""
          export CMAKE_VT_PHRASE=""
       fi
   fi
   
   if [ $KRELL_ROOT_MPI_MVAPICH ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MVAPICH is defined to $KRELL_ROOT_MPI_MVAPICH"
       fi
       export KRELL_ROOT_MPI_MVAPICH_PHRASE="--with-mvapich=$KRELL_ROOT_MPI_MVAPICH"
       export CMAKE_MVAPICH_PHRASE="-DMVAPICH_DIR=${KRELL_ROOT_MPI_MVAPICH}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MVAPICH is undefined, setting to blanks"
       fi
       export KRELL_ROOT_MPI_MVAPICH_PHRASE=""
       export CMAKE_MVAPICH_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_MPI_MVAPICH2 ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MVAPICH2 is defined to $KRELL_ROOT_MPI_MVAPICH2"
       fi
       export KRELL_ROOT_MPI_MVAPICH2_PHRASE="--with-mvapich2=$KRELL_ROOT_MPI_MVAPICH2"
       export CMAKE_MVAPICH2_PHRASE="-DMVAPICH2_DIR=${KRELL_ROOT_MPI_MVAPICH2}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MVAPICH2 is undefined, setting to blanks"
       fi
       export KRELL_ROOT_MPI_MVAPICH2_PHRASE=""
       export CMAKE_MVAPICH2_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_MPI_MVAPICH2_OFED ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MVAPICH2_OFED is defined to $KRELL_ROOT_MPI_MVAPICH2_OFED"
       fi
       export KRELL_ROOT_MPI_MVAPICH2_OFED_PHRASE="--with-mvapich2-ofed=$KRELL_ROOT_MPI_MVAPICH2_OFED"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MVAPICH2_OFED is undefined, setting to blanks"
       fi
       export KRELL_ROOT_MPI_MVAPICH2_OFED_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_MPI_MPICH ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MPICH is defined to $KRELL_ROOT_MPI_MPICH"
       fi
       export KRELL_ROOT_MPI_MPICH_PHRASE="--with-mpich=$KRELL_ROOT_MPI_MPICH"
       export CMAKE_MPICH_PHRASE="-DMPICH_DIR=${KRELL_ROOT_MPI_MPICH}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MPICH is undefined, setting to blanks"
       fi
       export KRELL_ROOT_MPI_MPICH_PHRASE=""
       export CMAKE_MPICH_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_MPI_MPICH_DRIVER ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MPICH_DRIVER is defined to $KRELL_ROOT_MPI_MPICH_DRIVER"
       fi
       export KRELL_ROOT_MPI_MPICH_DRIVER_PHRASE="--with-mpich-driver=$KRELL_ROOT_MPI_MPICH_DRIVER"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MPICH_DRIVER is undefined, setting to blanks"
       fi
       export KRELL_ROOT_MPI_MPICH_DRIVER_PHRASE=""
   fi
   
   
   if [ $KRELL_ROOT_MPI_MPICH2 ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MPICH2 is defined to $KRELL_ROOT_MPI_MPICH2"
       fi
       export KRELL_ROOT_MPI_MPICH2_PHRASE="--with-mpich2=$KRELL_ROOT_MPI_MPICH2"
       export CMAKE_MPICH2_PHRASE="-DMPICH2_DIR=${KRELL_ROOT_MPI_MPICH2}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MPICH2 is undefined, setting to blanks"
       fi
       export KRELL_ROOT_MPI_MPICH2_PHRASE=""
       export CMAKE_MPICH2_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_MPI_MPICH2_DRIVER ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MPICH2_DRIVER is defined to $KRELL_ROOT_MPI_MPICH2_DRIVER"
       fi
       export KRELL_ROOT_MPI_MPICH2_DRIVER_PHRASE="--with-mpich2-driver=$KRELL_ROOT_MPI_MPICH2_DRIVER"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MPICH2_DRIVER is undefined, setting to blanks"
       fi
       export KRELL_ROOT_MPI_MPICH2_DRIVER_PHRASE=""
   fi
   
   
   if [ $KRELL_ROOT_MPI_MPT ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MPT is defined to $KRELL_ROOT_MPI_MPT"
       fi
       export KRELL_ROOT_MPI_MPT_PHRASE="--with-mpt=$KRELL_ROOT_MPI_MPT"
       export CMAKE_MPT_PHRASE="-DMPT_DIR=${KRELL_ROOT_MPI_MPT}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_MPT is undefined, setting to blanks"
       fi
       export KRELL_ROOT_MPI_MPT_PHRASE=""
       export CMAKE_MPT_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_MPI_OPENMPI ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_OPENMPI is defined to $KRELL_ROOT_MPI_OPENMPI"
       fi
       export KRELL_ROOT_MPI_OPENMPI_PHRASE="--with-openmpi=$KRELL_ROOT_MPI_OPENMPI"
       export CMAKE_OPENMPI_PHRASE="-DOPENMPI_DIR=${KRELL_ROOT_MPI_OPENMPI}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_OPENMPI is undefined, setting to blanks"
       fi
       export KRELL_ROOT_MPI_OPENMPI_PHRASE=""
       export CMAKE_OPENMPI_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_MPI_LAMPI ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_LAMPI is defined to $KRELL_ROOT_MPI_LAMPI"
       fi
       export KRELL_ROOT_MPI_LAMPI_PHRASE="--with-lampi=$KRELL_ROOT_MPI_LAMPI"
       export CMAKE_LAMPI_PHRASE="-DLAMPI_DIR=${KRELL_ROOT_MPI_LAMPI}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_LAMPI is undefined, setting to blanks"
       fi
       export KRELL_ROOT_MPI_LAMPI_PHRASE=""
       export CMAKE_LAMPI_PHRASE=""
   fi
   
   if [ $KRELL_ROOT_MPI_LAM ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_LAM is defined to $KRELL_ROOT_MPI_LAM"
       fi
       export KRELL_ROOT_MPI_LAM_PHRASE="--with-lam=$KRELL_ROOT_MPI_LAM"
       export CMAKE_LAM_PHRASE="-DLAM_DIR=${KRELL_ROOT_MPI_LAM}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_MPI_LAM is undefined, setting to blanks"
       fi
       export KRELL_ROOT_MPI_LAM_PHRASE=""
       export CMAKE_LAM_PHRASE=""
   fi
   
   if [ $CUDA_INSTALL_PATH ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: CUDA_INSTALL_PATH is defined to $CUDA_INSTALL_PATH"
       fi
       export KRELL_ROOT_CUDA_PHRASE="--with-cuda=$CUDA_INSTALL_PATH"
       export CMAKE_CUDA_PHRASE1="-DCUDA_DIR=${CUDA_INSTALL_PATH}"
       export CMAKE_CUDA_PHRASE2="-DCUDA_ROOT=${CUDA_INSTALL_PATH}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: CUDA_INSTALL_PATH is undefined, setting to blanks"
       fi
       export KRELL_ROOT_CUDA_PHRASE=""
       export CMAKE_CUDA_PHRASE1=""
       export CMAKE_CUDA_PHRASE2=""
   fi
   
   if [ $CUPTI_ROOT ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: CUPTI_ROOT is defined to $CUPTI_ROOT"
       fi
       export KRELL_ROOT_CUPTI_PHRASE="--with-cupti=$CUPTI_ROOT"
       export CMAKE_CUPTI_PHRASE1="-DCUPTI_DIR=${CUPTI_ROOT}"
       export CMAKE_CUPTI_PHRASE2="-DCUPTI_ROOT=${CUPTI_ROOT}"
   else
       export KRELL_ROOT_CUPTI_PHRASE=""
       export CMAKE_CUPTI_PHRASE1=""
       export CMAKE_CUPTI_PHRASE2=""
   fi
   
   
   CC_PHRASE=
   CXX_PHRASE=
   CFLAGS_PHRASE=
   CPPFLAGS_PHRASE=
   CXXFLAGS_PHRASE=
   LDFLAGS_PHRASE=
   KRELL_ROOT_CONFIG_HOST_PHRASE=
   KRELL_ROOT_CONFIG_TARGET_PHRASE=
   KRELL_ROOT_ENABLE_TARGET_DLOPEN_PHRASE=
   KRELL_ROOT_ENABLE_TARGET_FORK_PHRASE=
   
   if [ "$KRELL_ROOT_TARGET_ARCH" == "bgl" ]; then
      if [ $KRELL_ROOT_TARGET_SHARED ]; then
        CFLAGS_PHRASE=export CFLAGS="-fPIC -m64 -dynamic -g -O0"
        CXXFLAGS_PHRASE=export CXXFLAGS="-fPIC -m64 -dynamic -g -O0"
        LDFLAGS_PHRASE=export LDFLAGS="-fPIC -m64 -dynamic -g -O0"
        KRELL_ROOT_CONFIG_HOST_PHRASE="--host=ppc64"
        KRELL_ROOT_CONFIG_TARGET_PHRASE="--target=powerpc-bgl-linux"
        KRELL_ROOT_ENABLE_TARGET_DLOPEN_PHRASE="--enable-target-dlopen=no"
        KRELL_ROOT_ENABLE_TARGET_FORK_PHRASE="--enable-target-fork=no"
      fi
   elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgp" ]; then
      if [ $KRELL_ROOT_TARGET_SHARED ]; then
        CFLAGS_PHRASE=export CFLAGS="-fPIC -m64 -dynamic -g -O0"
        CXXFLAGS_PHRASE=export CXXFLAGS="-fPIC -m64 -dynamic -g -O0"
        LDFLAGS_PHRASE=export LDFLAGS="-fPIC -m64 -dynamic -g -O0"
        KRELL_ROOT_CONFIG_HOST_PHRASE="--host=ppc64"
        KRELL_ROOT_CONFIG_TARGET_PHRASE="--target=powerpc-bgp-linux"
        KRELL_ROOT_ENABLE_TARGET_DLOPEN_PHRASE="--enable-target-dlopen=no"
        KRELL_ROOT_ENABLE_TARGET_FORK_PHRASE="--enable-target-fork=no"
      fi
   
   elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
      if [ $KRELL_ROOT_TARGET_SHARED ]; then
        CFLAGS_PHRASE=export CFLAGS="-fPIC -m64 -dynamic -g -O0"
        CXXFLAGS_PHRASE=export CXXFLAGS="-fPIC -m64 -dynamic -g -O0"
        LDFLAGS_PHRASE=export LDFLAGS="-fPIC -m64 -dynamic -g -O0"
        KRELL_ROOT_CONFIG_TARGET_PHRASE="--target=powerpc-bgq-linux"
        KRELL_ROOT_PPC64_BITMODE_PHRASE="-with-ppc64-bitmode=64"
      else
        CFLAGS_PHRASE=export CFLAGS="-fPIC -m64 -g -O0"
        CXXFLAGS_PHRASE=export CXXFLAGS="-fPIC -m64 -g -O0"
        LDFLAGS_PHRASE=export LDFLAGS="-fPIC -m64 -g -O0"
        KRELL_ROOT_CONFIG_TARGET_PHRASE="--target=powerpc-bgq-linux"
        KRELL_ROOT_PPC64_BITMODE_PHRASE="-with-ppc64-bitmode=64"
      fi
   elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgqfe" ]; then
      if [ "$OPENSS_INSTRUMENTOR" == "offline" ]; then
        CFLAGS_PHRASE=export CFLAGS="-m64"
        CPPFLAGS_PHRASE=export CPPFLAGS="-m64"
        CXXFLAGS_PHRASE=export CXXFLAGS="-m64"
        LDFLAGS_PHRASE=export LDFLAGS="-m64"
        KRELL_ROOT_PPC64_BITMODE_PHRASE="-with-ppc64-bitmode=64"
        KRELL_ROOT_CONFIG_TARGET_PHRASE="--target=ppc64"
      fi
   elif [ "$PLATFORM" == "ppc64" ] && [ "$LIBDIR" == "lib64" ]; then

      CFLAGS_PHRASE=export CFLAGS="-m64"
      CPPFLAGS_PHRASE=export CPPFLAGS="-m64"
      CXXFLAGS_PHRASE=export CXXFLAGS="-m64"
      LDFLAGS_PHRASE=export LDFLAGS="-m64"
      KRELL_ROOT_PPC64_BITMODE_PHRASE="-with-ppc64-bitmode=64"
      KRELL_ROOT_CONFIG_TARGET_PHRASE="--target=ppc64"

   elif [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then

      export PATH=/usr/linux-k1om-4.7/bin:$PATH

      KRELL_ROOT_TARGET_ARCH_PHRASE="--with-target-os=mic"
      #KRELL_ROOT_TLS_TYPE_PHRASE="--with-tls=explicit"
      cc_PHRASE="cc=icc"
      CC_PHRASE="CC=icc"
      CXX_PHRASE="CXX=icpc"
      KRELL_ROOT_CONFIG_HOST_PHRASE="--host=x86_64-k1om-linux"
      #CC_PHRASE="CC=/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc"
      #CXX_PHRASE="CXX=/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++"
      #KRELL_ROOT_CONFIG_HOST_PHRASE="--host=--host=x86_64-k1om-linux"

   else

      #KRELL_ROOT_CONFIG_TARGET_PHRASE="--target=$PLATFORM"
      KRELL_ROOT_CONFIG_TARGET_PHRASE=""
      KRELL_ROOT_ENABLE_TARGET_DLOPEN_PHRASE=""
      KRELL_ROOT_ENABLE_TARGET_FORK_PHRASE=""
      if [ "$OPENSS_ENABLE_DEBUG" == "1" ]; then
         OPENSS_ENABLE_DEBUG_PHRASE="--enable-debug"
      else
         OPENSS_ENABLE_DEBUG_PHRASE=""
      fi

   fi
   
   # Process the --with-ltdl install-tool argument setting up for cmake build
   if [ $KRELL_ROOT_LTDL ]; then
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_LTDL is defined to $KRELL_ROOT_LTDL"
       fi
       export CMAKE_LTDL_PHRASE="-DLTDL_DIR=${KRELL_ROOT_LTDL}"
   else
       if [ "$display_summary" = 1 ] ; then 
           echo "setting-up: KRELL_ROOT_LTDL is undefined, setting to blanks"
       fi
       export KRELL_ROOT_LTDL=""
       export CMAKE_LTDL_PHRASE=""
   fi
   

# Target build specific environment variable checks

   if [ $KRELL_ROOT_TARGET_ARCH ]; then

	if [ $KRELL_ROOT_LIBPTHREAD ]; then
            if [ "$display_summary" = 1 ] ; then 
	        echo "setting-up: KRELL_ROOT_LIBPTHREAD is defined to $KRELL_ROOT_TARGET_ARCH"
            fi
	    export KRELL_ROOT_LIBPTHREAD_PHRASE="--with-libpthread=$KRELL_ROOT_LIBPTHREAD"
	    export CMAKE_LIBPTHREAD_PHRASE="-DLIBPTHREAD_DIR=$KRELL_ROOT_LIBPTHREAD"
	else
            if [ "$display_summary" = 1 ] ; then 
	        echo "setting-up: KRELL_ROOT_LIBPTHREAD is undefined, setting to blanks"
            fi
            if [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
                 export KRELL_ROOT_LIBPTHREAD_PHRASE="--with-libpthread=/bgsys/drivers/ppcfloor/gnu-linux/powerpc64-bgq-linux"
	         export CMAKE_LIBPTHREAD_PHRASE="-DLIBPTHREAD_DIR=/bgsys/drivers/ppcfloor/gnu-linux/powerpc64-bgq-linux"
            else
	         export KRELL_ROOT_LIBPTHREAD=
	         export KRELL_ROOT_LIBPTHREAD_PHRASE=""
            fi
	fi

        if [ $KRELL_ROOT_PERSONALITY ]; then
            if [ "$display_summary" = 1 ] ; then 
                echo "setting-up: KRELL_ROOT_PERSONALITY is defined to $KRELL_ROOT_PERSONALITY"
            fi
            export KRELL_ROOT_PERSONALITY_PHRASE="--with-personality=$KRELL_ROOT_PERSONALITY"
            export CMAKE_PERSONALITY_PHRASE="-DPERSONALITY_DIR=$KRELL_ROOT_PERSONALITY"
        else
            if [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
                if [ "$display_summary" = 1 ] ; then 
                    echo "setting-up: KRELL_ROOT_PERSONALITY is undefined, setting to /bgsys/drivers/ppcfloor"
                fi
                export KRELL_ROOT_PERSONALITY=/bgsys/drivers/ppcfloor
                export KRELL_ROOT_PERSONALITY_PHRASE="--with-personality=/bgsys/drivers/ppcfloor"
                export CMAKE_PERSONALITY_PHRASE="-DPERSONALITY_DIR=/bgsys/drivers/ppcfloor"
            elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgp" ]; then
                if [ "$display_summary" = 1 ] ; then 
                    echo "setting-up: KRELL_ROOT_PERSONALITY is undefined, setting to /bgsys/drivers/ppcfloor/arch"
                fi
                export KRELL_ROOT_PERSONALITY=/bgsys/drivers/ppcfloor/arch
                export KRELL_ROOT_PERSONALITY_PHRASE="--with-personality=/bgsys/drivers/ppcfloor/arch"
                export CMAKE_PERSONALITY_PHRASE="-DPERSONALITY_DIR=/bgsys/drivers/ppcfloor/arch"
            else
                if [ "$display_summary" = 1 ] ; then 
                    echo "setting-up: KRELL_ROOT_PERSONALITY is undefined, setting to blanks"
                fi
                export KRELL_ROOT_PERSONALITY=
                export KRELL_ROOT_PERSONALITY_PHRASE=""
                export CMAKE_PERSONALITY_PHRASE=""
            fi
        fi

	if [ $KRELL_ROOT_LIBRT ]; then
            if [ "$display_summary" = 1 ] ; then 
	        echo "setting-up: KRELL_ROOT_LIBRT is defined to $KRELL_ROOT_LIBRT"
            fi
            export KRELL_ROOT_LIBRT_PHRASE="--with-librt=$KRELL_ROOT_LIBRT"
            export CMAKE_LIBRT_PHRASE="-DLIBRT_DIR=$KRELL_ROOT_LIBRT"
	else
            if [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
                export KRELL_ROOT_LIBRT_PHRASE="--with-librt=/bgsys/drivers/ppcfloor/gnu-linux/powerpc64-bgq-linux"
                export CMAKE_LIBRT_PHRASE="-DLIBRT_DIR=/bgsys/drivers/ppcfloor/gnu-linux/powerpc64-bgq-linux"
            else
                if [ "$display_summary" = 1 ] ; then 
                    echo "setting-up: KRELL_ROOT_LIBRT is undefined, setting to blanks"
                fi
	        export KRELL_ROOT_LIBRT=
                export KRELL_ROOT_LIBRT_PHRASE=""
                export CMAKE_LIBRT_PHRASE=""
            fi
	fi

	if [ $KRELL_ROOT_STDC_PLUS_PLUS ]; then
            if [ "$display_summary" = 1 ] ; then 
  	        echo "setting-up: KRELL_ROOT_STDC_PLUS_PLUS is defined to $KRELL_ROOT_STDC_PLUS_PLUS"
            fi
            export KRELL_ROOT_STDC_PLUS_PLUS_PHRASE="--with-stdc-plusplus=$KRELL_ROOT_STDC_PLUS_PLUS"
            export CMAKE_STDC_PLUS_PLUS_PHRASE="-DSTDC_PLUS_PLUS_DIR=$KRELL_ROOT_STDC_PLUS_PLUS"
	else
            if [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
                export KRELL_ROOT_STDC_PLUS_PLUS_PHRASE="--with-stdc-plusplus=/bgsys/drivers/ppcfloor/gnu-linux/powerpc64-bgq-linux"
                export CMAKE_STDC_PLUS_PLUS_PHRASE="-DSTDC_PLUS_PLUS_DIR=/bgsys/drivers/ppcfloor/gnu-linux/powerpc64-bgq-linux"
                if [ "$display_summary" = 1 ] ; then 
  	            echo "setting-up: KRELL_ROOT_STDC_PLUS_PLUS_PHRASE is defined to $KRELL_ROOT_STDC_PLUS_PLUS_PHRASE"
                fi
            else
                if [ "$display_summary" = 1 ] ; then 
	            echo "setting-up: KRELL_ROOT_STDC_PLUS_PLUS is undefined, setting to blanks"
                fi
	        export KRELL_ROOT_STDC_PLUS_PLUS=
                export KRELL_ROOT_STDC_PLUS_PLUS_PHRASE=""
                export CMAKE_STDC_PLUS_PLUS_PHRASE=""
            fi
	fi

	if [ $KRELL_ROOT_OPENMP ]; then
            if [ "$display_summary" = 1 ] ; then 
	        echo "setting-up: KRELL_ROOT_OPENMP is defined to $KRELL_ROOT_OPENMP"
            fi
            export KRELL_ROOT_OPENMP_PHRASE="--with-openmp=$KRELL_ROOT_OPENMP"
            export CMAKE_OPENMP_PHRASE="-DOPENMP_DIR=$KRELL_ROOT_OPENMP"
	else
            if [ "$display_summary" = 1 ] ; then 
	        echo "setting-up: KRELL_ROOT_OPENMP is undefined, setting to blanks"
            fi
	    export KRELL_ROOT_OPENMP=
            export CMAKE_OPENMP_PHRASE=""
	fi

   fi

   if [ "$display_summary" = 1 ] ; then 
       echo "END   -- setting-up: for this build."
   fi

} # end function setup_for_oss_cbtf

# Main Build Functions

function build_cmake_routine() { 
   echo ""
   echo "Building cmake."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX/cmake as installation unless CBTF_CMAKE_ROOT is set."
   echo "If KRELL_ROOT_PREFIX and CBTF_CMAKE_ROOT are both not set then the build script warns and halts."
   echo ""

   if [ -z $CBTF_CMAKE_ROOT ]; then 
        echo "   "
        echo "         CBTF_CMAKE_ROOT is NOT set."
        echo "   "
	if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          #export CBTF_CMAKE_ROOT=$KRELL_ROOT_PREFIX/cmake_root
          export CBTF_CMAKE_ROOT=$KRELL_ROOT_PREFIX
          echo "         Using CBTF_CMAKE_ROOT based on KRELL_ROOT_PREFIX, CBTF_CMAKE_ROOT=$CBTF_CMAKE_ROOT"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: KRELL_ROOT_PREFIX"
          echo "             and CBTF_CMAKE_ROOT are not set.  "
          #echo "             If KRELL_ROOT_PREFIX is set then KRELL_ROOT_PREFIX/cmake_root will be used for"
          echo "             If KRELL_ROOT_PREFIX is set then KRELL_ROOT_PREFIX will be used for"
          echo "             CBTF_CMAKE_ROOT."
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX OR CBTF_CMAKE_ROOT and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         CBTF_CMAKE_ROOT was set."
      echo "         Using CBTF_CMAKE_ROOT=$CBTF_CMAKE_ROOT"
      echo "   "
   fi

   echo 
   echo "Continue the build process for the cmake root? <y/n>"
   echo

   #echo "nanswer inside build_cmake is:$nanswer"
   if [ "$nanswer" = 9 ]; then
       echo
       echo "Continuing the cmake build process."
       echo
   else
      #read answer
      answer=Y
   fi
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the cmake build process."
       echo 
   elif [ "$nanswer" = 9 ]; then
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 

     if [ $CBTF_CMAKE_ROOT ]; then 
         export LD_LIBRARY_PATH=$CBTF_CMAKE_ROOT/lib
     fi
   else
     if [ $CBTF_CMAKE_ROOT ]; then 
         export LD_LIBRARY_PATH=$CBTF_CMAKE_ROOT/lib:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $CBTF_CMAKE_ROOT ]; then 
         export PATH=$CBTF_CMAKE_ROOT/bin:$PATH
     fi
   else
     if [ $CBTF_CMAKE_ROOT ]; then 
         export PATH=$CBTF_CMAKE_ROOT/bin:$PATH
     fi
   fi

   # cmake
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/cmake-$cmakever.tar.gz
   rm -rf BUILD/$sys/cmake-$cmakever
   cp SOURCES/cmake-$cmakever.tar.gz BUILD/$sys/cmake-$cmakever.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   tar -xzf cmake-$cmakever.tar.gz
   #cd cmake-$cmakever
   pushd cmake-$cmakever

   # Is this a special --build-cmake request, if so only use ${KRELL_ROOT_PREFIX}
   # as the CMAKE_INSTALL_PREFIX, otherwise add the ../cmake
   # 1 = special --build-cmake request
   # 0 = part of normal --build-krell-root
   if [ $1 == 1 ] ; then
       export CMAKE_INSTALL_PATH=$CBTF_CMAKE_ROOT
   else
       export CMAKE_INSTALL_PATH=$KRELL_ROOT_PREFIX/cmake-$cmakever
       export KRELL_ROOT_CMAKE_ROOT=$KRELL_ROOT_PREFIX/cmake-$cmakever
   fi

   if [ "$build_with_intel" = 1 ]; then
       cc="gcc" CC="icc" CXX="icpc" ./bootstrap --prefix=$CMAKE_INSTALL_PATH; make; make install
   else
       cc="gcc" CC="gcc" CXX="g++" ./bootstrap --prefix=$CMAKE_INSTALL_PATH; make; make install
   fi

   popd
   popd
}

function build_expat_routine() { 
   echo ""
   echo "Building expat."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX/expat as installation unless CBTF_EXPAT_ROOT is set."
   echo "If KRELL_ROOT_PREFIX and CBTF_EXPAT_ROOT are both not set then the build script warns and halts."
   echo ""

   if [ -z $CBTF_EXPAT_ROOT ]; then 
        echo "   "
        echo "         CBTF_EXPAT_ROOT is NOT set."
        echo "   "
	if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          export CBTF_EXPAT_ROOT=$KRELL_ROOT_PREFIX
          echo "         Using CBTF_EXPAT_ROOT based on KRELL_ROOT_PREFIX, CBTF_EXPAT_ROOT=$CBTF_EXPAT_ROOT"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: KRELL_ROOT_PREFIX"
          echo "             and CBTF_EXPAT_ROOT are not set.  "
          echo "             If KRELL_ROOT_PREFIX is set then KRELL_ROOT_PREFIX will be used for"
          echo "             CBTF_EXPAT_ROOT."
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX OR CBTF_EXPAT_ROOT and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         CBTF_EXPAT_ROOT was set."
      echo "         Using CBTF_EXPAT_ROOT=$CBTF_EXPAT_ROOT"
      echo "   "
   fi

   echo 
   echo "Continue the build process for the expat root? <y/n>"
   echo

   #echo "nanswer inside build_expat is:$nanswer"
   if [ "$nanswer" = 9 ]; then
       echo
       echo "Continuing the expat build process."
       echo
   else
      #read answer
      answer=Y
   fi
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the expat build process."
       echo 
   elif [ "$nanswer" = 9 ]; then
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 

     if [ $CBTF_EXPAT_ROOT ]; then 
         export LD_LIBRARY_PATH=$CBTF_EXPAT_ROOT/lib
     fi
   else
     if [ $CBTF_EXPAT_ROOT ]; then 
         export LD_LIBRARY_PATH=$CBTF_EXPAT_ROOT/lib:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $CBTF_EXPAT_ROOT ]; then 
         export PATH=$CBTF_EXPAT_ROOT/bin:$PATH
     fi
   else
     if [ $CBTF_EXPAT_ROOT ]; then 
         export PATH=$CBTF_EXPAT_ROOT/bin:$PATH
     fi
   fi

   # expat
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/expat-$expatver.tar.gz
   rm -rf BUILD/$sys/expat-$expatver
   cp SOURCES/expat-$expatver.tar.gz BUILD/$sys/expat-$expatver.tar.gz
   pushd BUILD/$sys
   tar -xzf expat-$expatver.tar.gz
   pushd expat-$expatver
   cc="gcc" CC="gcc" CXX="g++" ./configure --prefix=$KRELL_ROOT_PREFIX; make; make install
   popd
   popd
}

function build_zlib_routine() { 
   echo ""
   echo "Building zlib."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX/zlib as installation unless KRELL_ROOT_ZLIB is set."
   echo "If KRELL_ROOT_PREFIX and KRELL_ROOT_ZLIB are both not set then the build script warns and halts."
   echo ""

   if [ -z $KRELL_ROOT_ZLIB ]; then 
        echo "   "
        echo "         KRELL_ROOT_ZLIB is NOT set."
        echo "   "
	if [ $KRELL_ROOT_PREFIX ]; then
         echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          export KRELL_ROOT_ZLIB=$KRELL_ROOT_PREFIX
          echo "         Using KRELL_ROOT_ZLIB based on KRELL_ROOT_PREFIX, KRELL_ROOT_ZLIB=$KRELL_ROOT_ZLIB"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: KRELL_ROOT_PREFIX"
          echo "             and KRELL_ROOT_ZLIB are not set.  "
          echo "             If KRELL_ROOT_PREFIX is set then KRELL_ROOT_PREFIX will be used for"
          echo "             KRELL_ROOT_ZLIB."
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX OR KRELL_ROOT_ZLIB and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         KRELL_ROOT_ZLIB was set."
      echo "         Using KRELL_ROOT_ZLIB=$KRELL_ROOT_ZLIB"
      echo "   "
   fi

   echo 
   echo "Continue the build process for the zlib root? <y/n>"
   echo

   #echo "nanswer inside build_zlib is:$nanswer"
   if [ "$nanswer" = 9 ]; then
       echo
       echo "Continuing the zlib build process."
       echo
   else
      #read answer
      answer=Y
   fi
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the zlib build process."
       echo 
   elif [ "$nanswer" = 9 ]; then
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 

     if [ $KRELL_ROOT_ZLIB ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_ZLIB/lib
     fi
   else
     if [ $KRELL_ROOT_ZLIB ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_ZLIB/lib:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_ZLIB ]; then 
         export PATH=$KRELL_ROOT_ZLIB/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_ZLIB ]; then 
         export PATH=$KRELL_ROOT_ZLIB/bin:$PATH
     fi
   fi

   # zlib
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/zlib-$zlibver.tar.gz
   rm -rf BUILD/$sys/zlib-$zlibver
   cp SOURCES/zlib-$zlibver.tar.gz BUILD/$sys/zlib-$zlibver.tar.gz
   pushd BUILD/$sys
   tar -xzf zlib-$zlibver.tar.gz
   pushd zlib-$zlibver
   cc="gcc" CC="gcc" CXX="g++" ./configure --prefix=$KRELL_ROOT_PREFIX; make; make install
   popd
   popd
   export KRELL_ROOT_ZLIB=$KRELL_ROOT_PREFIX
}

# Main Build Function
function build_autotools() { 
   echo ""
   echo "Building autotools: autoconf, automake, m4, and libtool."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX/autotools_root as installation unless KRELL_ROOT_AUTOTOOLS_ROOT is set."
   echo "If KRELL_ROOT_PREFIX and KRELL_ROOT_AUTOTOOLS_ROOT are both not set then the build script warns and halts."
   echo ""

   if [ -z $KRELL_ROOT_AUTOTOOLS_ROOT ]; then 
        echo "   "
        echo "         KRELL_ROOT_AUTOTOOLS_ROOT is NOT set."
        echo "   "
	if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          export KRELL_ROOT_AUTOTOOLS_ROOT=$KRELL_ROOT_PREFIX
          echo "         Using KRELL_ROOT_AUTOTOOLS_ROOT based on KRELL_ROOT_PREFIX, KRELL_ROOT_AUTOTOOLS_ROOT=$KRELL_ROOT_AUTOTOOLS_ROOT"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: KRELL_ROOT_PREFIX"
          echo "             and KRELL_ROOT_AUTOTOOLS_ROOT are not set.  "
          echo "             If KRELL_ROOT_PREFIX is set then KRELL_ROOT_PREFIX/autotools_root will be used for"
          echo "             KRELL_ROOT_AUTOTOOLS_ROOT."
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX OR KRELL_ROOT_AUTOTOOLS_ROOT and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         KRELL_ROOT_AUTOTOOLS_ROOT was set."
      echo "         Using KRELL_ROOT_AUTOTOOLS_ROOT=$KRELL_ROOT_AUTOTOOLS_ROOT"
      echo "   "
   fi

   echo 
   echo "Continue the build process for the autotools root? <y/n>"
   echo

   #read answer
   answer=Y
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the autotools build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_AUTOTOOLS_ROOT ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_AUTOTOOLS_ROOT/lib
     fi
   else
     if [ $KRELL_ROOT_AUTOTOOLS_ROOT ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_AUTOTOOLS_ROOT/lib:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_AUTOTOOLS_ROOT ]; then 
         export PATH=$KRELL_ROOT_AUTOTOOLS_ROOT/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_AUTOTOOLS_ROOT ]; then 
         export PATH=$KRELL_ROOT_AUTOTOOLS_ROOT/bin:$PATH
     fi
   fi

   # m4
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/m4-$m4ver.tar.gz
   rm -rf BUILD/$sys/m4-$m4ver
   cp SOURCES/m4-$m4ver.tar.gz BUILD/$sys/m4-$m4ver.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   tar -xzf m4-$m4ver.tar.gz
   #cd m4-$m4ver
   pushd m4-$m4ver
   if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
     if [ "$build_with_intel" = 1 ]; then
         export PATH=/usr/linux-k1om-4.7/bin:$PATH
         CC="icc -mmic" CXX="icpc -mmic" LDFLAGS="-mmic" ./configure --prefix=$KRELL_ROOT_AUTOTOOLS_ROOT --host=x86_64-k1om-linux
     else
         CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" ./configure --prefix=$KRELL_ROOT_AUTOTOOLS_ROOT --host=x86_64-k1om-linux
     fi
   else
     ./configure --prefix=$KRELL_ROOT_AUTOTOOLS_ROOT
   fi
   make; make install
   #cd ../../..
   popd 
   popd 

   if [ -z $KRELL_ROOT_AUTOTOOLS_ROOT_ASK ]; then
     echo 
   else
     echo 
     echo "Continue the build process for the autotools root? <y/n>"
     echo
  
     #read answer
     answer=Y
    
     if [ "$answer" = Y -o "$answer" = y ]; then
         echo
         echo "Continuing the autotools build process."
         echo 
     else
         echo "   "
         exit
     fi
   fi

   # autoconf
   rm -rf BUILD/$sys/autoconf-$autoconfver.tar.gz
   rm -rf BUILD/$sys/autoconf-$autoconfver
   cp SOURCES/autoconf-$autoconfver.tar.gz BUILD/$sys/autoconf-$autoconfver.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   tar -xzf autoconf-$autoconfver.tar.gz
   #cd autoconf-$autoconfver
   pushd autoconf-$autoconfver
   patch -p1 < autoconf-$autoconfver.patch
   if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
       if [ "$build_with_intel" = 1 ]; then
           export PATH=/usr/linux-k1om-4.7/bin:$PATH
           CC="icc -mmic" CXX="icpc -mmic" LDFLAGS="-mmic" ./configure --prefix=$KRELL_ROOT_AUTOTOOLS_ROOT --host=x86_64-k1om-linux
       else
           CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" ./configure --prefix=$KRELL_ROOT_AUTOTOOLS_ROOT --host=x86_64-k1om-linux

       fi
   else
       ./configure --prefix=$KRELL_ROOT_AUTOTOOLS_ROOT
   fi
   make; make install
   #cd ../../..
   popd
   popd

   if [ -z $KRELL_ROOT_AUTOTOOLS_ROOT_ASK ]; then
     echo 
   else
     echo 
     echo "Continue the build process for the autotools root? <y/n>"
     echo
  
     #read answer
     answer=Y
    
     if [ "$answer" = Y -o "$answer" = y ]; then
         echo
         echo "Continuing the autotools build process."
         echo 
     else
         echo "   "
         exit
     fi
   fi

   # automake
   rm -rf BUILD/$sys/automake-$automakever.tar.gz
   rm -rf BUILD/$sys/automake-$automakever
   cp SOURCES/automake-$automakever.tar.gz BUILD/$sys/automake-$automakever.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   tar -xzf automake-$automakever.tar.gz
   #cd automake-$automakever
   pushd automake-$automakever
   export PATH=/usr/linux-k1om-4.7/bin:$PATH
   if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
       if [ "$build_with_intel" = 1 ]; then
           CC="icc -mmic" CXX="icpc -mmic" LDFLAGS="-mmic" ./configure --prefix=$KRELL_ROOT_AUTOTOOLS_ROOT --host=x86_64-k1om-linux
       else
           CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" ./configure --prefix=$KRELL_ROOT_AUTOTOOLS_ROOT --host=x86_64-k1om-linux
       fi
   else
       ./configure --prefix=$KRELL_ROOT_AUTOTOOLS_ROOT
   fi
   make; make install
   #cd ../../..
   popd
   popd

   if [ -z $KRELL_ROOT_AUTOTOOLS_ROOT_ASK ]; then
     echo 
   else
     echo 
     echo "Continue the build process for the autotools root? <y/n>"
     echo
  
     #read answer
     answer=Y
    
     if [ "$answer" = Y -o "$answer" = y ]; then
         echo
         echo "Continuing the autotools build process."
         echo 
     else
         echo "   "
         exit
     fi
   fi


   # libtool
   rm -rf BUILD/$sys/libtool-$libtoolver.tar.gz
   rm -rf BUILD/$sys/libtool-$libtoolver
   cp SOURCES/libtool-$libtoolver.tar.gz BUILD/$sys/libtool-$libtoolver.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   tar -xzf libtool-$libtoolver.tar.gz
   #cd libtool-$libtoolver
   pushd libtool-$libtoolver
   if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
       if [ "$build_with_intel" = 1 ]; then
           export PATH=/usr/linux-k1om-4.7/bin:$PATH
           CC="icc -mmic" CXX="icpc -mmic" LDFLAGS="-mmic" ./configure --prefix=$KRELL_ROOT_AUTOTOOLS_ROOT --host=x86_64-k1om-linux
       else
           CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" ./configure --prefix=$KRELL_ROOT_AUTOTOOLS_ROOT --host=x86_64-k1om-linux
       fi
   else
       ./configure --prefix=$KRELL_ROOT_AUTOTOOLS_ROOT
   fi
   make; make install
   #cd ../../..
   popd
   popd
}


# Main Build Function
function build_python_routine() { 
   echo ""
   echo "Building python."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation unless KRELL_ROOT_PYTHON_ROOT is set."
   echo "If KRELL_ROOT_PREFIX and KRELL_ROOT_PYTHON_ROOT are both not set then the build script warns and halts."
   echo ""

   if [ -z $KRELL_ROOT_PYTHON_ROOT ]; then 
        echo "   "
        echo "         KRELL_ROOT_PYTHON_ROOT is NOT set."
        echo "   "
	if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          export KRELL_ROOT_PYTHON_ROOT=$KRELL_ROOT_PREFIX
          echo "         Using KRELL_ROOT_PYTHON_ROOT based on KRELL_ROOT_PREFIX, KRELL_ROOT_PYTHON_ROOT=$KRELL_ROOT_PYTHON_ROOT"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: KRELL_ROOT_PREFIX"
          echo "             and KRELL_ROOT_PYTHON_ROOT are not set.  "
          echo "             If KRELL_ROOT_PREFIX is set then KRELL_ROOT_PREFIX will be used for"
          echo "             KRELL_ROOT_PYTHON_ROOT."
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX OR KRELL_ROOT_PYTHON_ROOT and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         KRELL_ROOT_PYTHON_ROOT was set."
      echo "         Using KRELL_ROOT_PYTHON_ROOT=$KRELL_ROOT_PYTHON_ROOT"
      echo "   "
   fi

   echo 
   echo "Continue the build process for the python root? <y/n>"
   echo

   #read answer
   answer=Y
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the python build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_PYTHON_ROOT ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PYTHON_ROOT/lib
     fi
   else
     if [ $KRELL_ROOT_PYTHON_ROOT ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PYTHON_ROOT/lib:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_PYTHON_ROOT ]; then 
         export PATH=$KRELL_ROOT_PYTHON_ROOT/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_PYTHON_ROOT ]; then 
         export PATH=$KRELL_ROOT_PYTHON_ROOT/bin:$PATH
     fi
   fi

   # python
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/Python-$Pythonver.tgz
   rm -rf BUILD/$sys/Python-$Pythonver
   cp SOURCES/Python-$Pythonver.tgz BUILD/$sys/Python-$Pythonver.tgz
   #cd BUILD/$sys
   pushd BUILD/$sys
   tar -xzf Python-$Pythonver.tgz
   #cd Python-$Pythonver
   pushd Python-$Pythonver
   if [ "$build_with_intel" = 1 ]; then
       CC="icc" CXX="icpc" ./configure --prefix=$KRELL_ROOT_PYTHON_ROOT --enable-shared
   else
       CC="gcc" CXX="g++" ./configure --prefix=$KRELL_ROOT_PYTHON_ROOT --enable-shared
   fi
   make; make install
   #cd ../../..
   popd
   popd
}

function build_GOTCHA_routine() {
   echo ""
   echo "Building GOTCHA."
   echo ""
   echo "The script will use $CBTF_PREFIX as installation."
   echo ""
   
   #echo "GOTCHA build, sys=$sys"

   # GOTCHA
   build_GOTCHA_script=""
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/GOTCHA-$GOTCHAver.tar.gz
   cp SOURCES/GOTCHA-$GOTCHAver.tar.gz BUILD/$sys/GOTCHA-$GOTCHAver.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   rm -rf GOTCHA-$GOTCHAver
   tar -xzf GOTCHA-$GOTCHAver.tar.gz
   pushd GOTCHA-$GOTCHAver

   build_oss_with_cmake=1
   if [ "$build_oss_with_cmake" = 1 ] ; then

       # setup environment variables and phrases for build below
       setup_for_oss_cbtf

       echo "build-debug: build_GOTCHA_routine(), Using cmake from=`which cmake`"
       echo "build-debug: build_GOTCHA_routine(), PATH=$PATH"

       rm -rf build_GOTCHA
       mkdir build_GOTCHA
       pushd build_GOTCHA

       # Add cmake build here
       echo "build_with_intel=$build_with_intel"
       if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
           if [ "$build_with_intel" = 1 ]; then
               export cc="icc -mmic"
               export CXX="icpc -mmic"
               export CC="icc -mmic"
               export PATH=/usr/linux-k1om-4.7/bin:$PATH
           else
               export cc="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" 
               export CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" 
               export CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" 
           fi
       else
           if [ "$build_with_intel" = 1 ]; then
               export cc=icc
               export CXX=icpc
               export CC=icc
           else
               export cc=gcc
               export CXX=g++
               export CC=gcc
           fi
       fi

       export CBTF_CXX_FLAGS="-g -O2"
       echo "Building GOTCHA with CBTF_CXX_FLAGS=${CBTF_CXX_FLAGS}"
       echo "cmake ..  -DCMAKE_BUILD_TYPE=None -DCMAKE_CXX_FLAGS=${CBTF_CXX_FLAGS} -DCMAKE_C_FLAGS=-g -O2 -DCMAKE_INSTALL_PREFIX=${CBTF_PREFIX}" > ../build_GOTCHA_cmake.txt

       cmake .. \
        -DCMAKE_BUILD_TYPE=None \
        -DCMAKE_CXX_FLAGS="${CBTF_CXX_FLAGS}" \
        -DCMAKE_C_FLAGS="-g -O2" \
        -DCMAKE_INSTALL_PREFIX=${KRELL_ROOT_PREFIX}
       
       make clean; make ; make install
   
   fi

   #cd ../../..
   popd
   popd
}


function build_cbtf_routine() {
   echo ""
   echo "Building cbtf."
   echo ""
   echo "The script will use $CBTF_PREFIX as installation."
   echo ""
   
   #echo "cbtf build, sys=$sys"

   # cbtf
   build_cbtf_script=""
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/cbtf-$cbtfver.tar.gz
   cp SOURCES/cbtf-$cbtfver.tar.gz BUILD/$sys/cbtf-$cbtfver.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   rm -rf cbtf
   tar -xzf cbtf-$cbtfver.tar.gz
   #cd cbtf
   pushd cbtf


   build_oss_with_cmake=1
   #build_oss_with_cmake=0
   if [ "$build_oss_with_cmake" = 1 ] ; then

       # setup environment variables and phrases for build below
       setup_for_oss_cbtf

       echo "build-debug: build_cbtf_routine(), Using cmake from=`which cmake`"
       echo "build-debug: build_cbtf_routine(), PATH=$PATH"

       rm -rf build_cbtf
       mkdir build_cbtf
       pushd build_cbtf

       # Add cmake build here
       echo "build_with_intel=$build_with_intel"
       if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
           if [ "$build_with_intel" = 1 ]; then
               export cc="icc -mmic"
               export CXX="icpc -mmic"
               export CC="icc -mmic"
               export PATH=/usr/linux-k1om-4.7/bin:$PATH
           else
               export cc="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" 
               export CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" 
               export CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" 
           fi
       else
           if [ "$build_with_intel" = 1 ]; then
               export cc=icc
               export CXX=icpc
               export CC=icc
           else
               export cc=gcc
               export CXX=g++
               export CC=gcc
           fi
       fi

       export CBTF_CXX_FLAGS="-g -O2"
       echo "Building cbtf with CBTF_CXX_FLAGS=${CBTF_CXX_FLAGS}"
       echo "cmake ..  -DCMAKE_BUILD_TYPE=None -DCMAKE_CXX_FLAGS=${CBTF_CXX_FLAGS} -DCMAKE_C_FLAGS=-g -O2 -DCMAKE_INSTALL_PREFIX=${CBTF_PREFIX} -DCMAKE_PREFIX_PATH=${KRELL_ROOT_PREFIX} ${CMAKE_RUNTIME_ONLY_PHRASE} ${CMAKE_TARGET_ARCH_PHRASE} ${CMAKE_BOOST_PHRASE1} ${CMAKE_BOOST_PHRASE2} ${CMAKE_BOOST_LIB_PHRASE} ${CMAKE_BOOST_SYSPATH_PHRASE} ${CMAKE_BOOST_CMAKE_PHRASE} ${CMAKE_XERCESC_PHRASE} ${CMAKE_MRNET_PHRASE}" > ../build_cbtf_cmake.txt

       cmake .. \
        -DCMAKE_BUILD_TYPE=None \
        -DCMAKE_CXX_FLAGS="${CBTF_CXX_FLAGS}" \
        -DCMAKE_C_FLAGS="-g -O2" \
        -DCMAKE_INSTALL_PREFIX=${CBTF_PREFIX}\
        -DCMAKE_PREFIX_PATH=${KRELL_ROOT_PREFIX} \
        ${CMAKE_RUNTIME_ONLY_PHRASE} \
        ${CMAKE_TARGET_ARCH_PHRASE} \
        ${CMAKE_BOOST_PHRASE1} \
        ${CMAKE_BOOST_PHRASE2} \
        ${CMAKE_BOOST_LIB_PHRASE} \
        ${CMAKE_BOOST_SYSPATH_PHRASE} \
        ${CMAKE_BOOST_CMAKE_PHRASE} \
        ${CMAKE_XERCESC_PHRASE} \
        ${CMAKE_MRNET_PHRASE} 
       
        # if RUNTIME_ONLY we are only installing an include file
        # no make clean targets are present
        if [ -z ${CMAKE_RUNTIME_ONLY_PHRASE} ]; then
            make clean; make ; make install
        else
            make ; make install
        fi
   
   else
       if [ -z $CBTF_KRELL_ROOT ]; then 
         if [ -z $KRELL_ROOT_PREFIX ]; then 
            echo "Please set CBTF_KRELL_ROOT to the location of the krell root installation director and retry"
            exit
         else
            export CBTF_KRELL_ROOT=$KRELL_ROOT_PREFIX
         fi
       else
         echo "Using CBTF_KRELL_ROOT=$CBTF_KRELL_ROOT as the krell root in building CBTF"
       fi
    
       if [ -z $CBTF_BOOST_ROOT ]; then 
         if [ -f /$CBTF_KRELL_ROOT/$LIBDIR/libboost_system.so -o -f /$CBTF_KRELL_ROOT/$LIBDIR/libboost_system-mt.so ]; then
            export CBTF_BOOST_ROOT=$CBTF_KRELL_ROOT
            export CBTF_BOOST_ROOT_LIB=$CBTF_KRELL_ROOT/$LIBDIR
         elif [ -f /$CBTF_KRELL_ROOT/$ALTLIBDIR/libboost_system.so -o -f /$CBTF_KRELL_ROOT/$ALTLIBDIR/libboost_system-mt.so ]; then
            export CBTF_BOOST_ROOT=$CBTF_KRELL_ROOT
            export CBTF_BOOST_ROOT_LIB=$CBTF_KRELL_ROOT/$ALTLIBDIR
         elif [ -f /usr/$LIBDIR/libboost_system.so -o -f /usr/$LIBDIR/libboost_system-mt.so ]; then
            export CBTF_BOOST_ROOT=/usr
            export CBTF_BOOST_ROOT_LIB=/usr/$LIBDIR
         elif [ -f /usr/$ALTLIBDIR/libboost_system.so -o -f /usr/$ALTLIBDIR/libboost_system-mt.so ]; then
            export CBTF_BOOST_ROOT=/usr
            export CBTF_BOOST_ROOT_LIB=/usr/$ALTLIBDIR
         else
            echo "Please set CBTF_BOOST_ROOT to the location of the boost installation directory and retry. We could not detect a boost installation in CBTF_KRELL_ROOT=$CBTF_KRELL_ROOT or /usr"
            exit
         fi
       else
         echo "Using CBTF_BOOST_ROOT=$CBTF_BOOST_ROOT as the boost root in building CBTF"
       fi
    
       if [ -z $CBTF_MRNET_ROOT ]; then 
         echo "CBTF_MRNET_ROOT is not set to the location of the MRNet installation directory, must be in KRELLROOT"
       else
         echo "Using CBTF_MRNET_ROOT=$CBTF_MRNET_ROOT for the MRNet installation directory."
         export MRNET_ROOT=$CBTF_MRNET_ROOT
       fi
    
       if [ -z $CBTF_PREFIX ]; then 
         echo "Please set CBTF_PREFIX to the location of the CBTF installation directory and retry"
         exit
       else
         echo "Using CBTF_PREFIX=$CBTF_PREFIX as the CBTF installation directory."
       fi

       if [ -z $CBTF_TARGET_ARCH ]; then
         echo "Not Using CBTF_TARGET_ARCH for build_cbtf_script."
          ../../../detect_installed.sh   > ./build_cbtf_script
       else
         echo "Using CBTF_TARGET_ARCH=$CBTF_TARGET_ARCH as the CBTF target arch for build_cbtf_script."
          ../../../detect_installed.sh  --target-arch $CBTF_TARGET_ARCH > ./build_cbtf_script
       fi

       while read line
       do
         echo "processing line, top of while read line"
         echo "$line"
         # actual install-cbtf call is below in $line
         eval $line
       done < ./build_cbtf_script
       #rm ./build_cbtf_script
   fi

   #cd ../../..
   popd
   popd
}


function build_cbtf_krell_routine() { 
   echo ""
   echo "Building cbtf-krell."
   echo ""
   echo "The script will use $CBTF_PREFIX as installation."
   echo ""


   # cbtf
   build_cbtf_krell_script=""
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/cbtf-krell-$cbtfver.tar.gz
   cp SOURCES/cbtf-krell-$cbtfver.tar.gz BUILD/$sys/cbtf-krell-$cbtfver.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   rm -rf cbtf-krell
   tar -xzf cbtf-krell-$cbtfver.tar.gz
   #cd cbtf-krell
   pushd cbtf-krell


   build_oss_with_cmake=1
   #build_oss_with_cmake=0

   if [ "$build_oss_with_cmake" = 1 ] ; then

       # Add cmake build here
       setup_for_oss_cbtf

       echo "build-debug: build_cbtf_krell_routine(), Using cmake from=`which cmake`"
       echo "build-debug: build_cbtf_krell_routine(), PATH=$PATH"

       # Create and change into the build directory
       rm -rf build_cbtf_krell
       mkdir build_cbtf_krell
       pushd build_cbtf_krell

       # Add cmake build here
       if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
           if [ "$build_with_intel" = 1 ]; then
               export cc="icc -mmic"
               export CXX="icpc -mmic"
               export CC="icc -mmic"
               export PATH=/usr/linux-k1om-4.7/bin:$PATH
           else
               export cc="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" 
               export CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" 
               export CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" 
           fi
       else
           if [ "$build_with_intel" = 1 ]; then
               export cc=icc
               export CXX=icpc
               export CC=icc
           else
               export cc=gcc
               export CXX=g++
               export CC=gcc
           fi
       fi

       #
       # Need to come up with a check for what compilers handle c++11
       # Commenting out until there is time to figure that out.
       # Maybe this should be done in the CMakeLists.txt file inside the source directory.
       # FIXME - jeg
       #
       export CBTFKRELL_CXX_FLAGS="-g -O2"
       #export CBTFKRELL_CXX_FLAGS="-g -O2 -std=c++11"
       #if [ "compiler check" ] ; then\
       #    export CBTFKRELL_CXX_FLAGS="-g -O2 -std=c++11"
       #fi
       echo "Building cbtf with CBTFKRELL_CXX_FLAGS=${CBTFKRELL_CXX_FLAGS}"

       echo "cmake ..  -DCMAKE_BUILD_TYPE=None -DCMAKE_CXX_FLAGS=${CBTFKRELL_CXX_FLAGS} -DCMAKE_C_FLAGS=-g -O2 -DCMAKE_INSTALL_PREFIX=${CBTF_PREFIX} -DCMAKE_PREFIX_PATH=${KRELL_ROOT_PREFIX} ${CMAKE_RUNTIME_ONLY_PHRASE} ${CMAKE_TARGET_ARCH_PHRASE} ${CMAKE_RUNTIME_TARGET_ARCH_PHRASE} ${CMAKE_CBTF_PHRASE} ${CMAKE_BOOST_PHRASE1} ${CMAKE_BOOST_PHRASE2} ${CMAKE_BOOST_LIB_PHRASE} ${CMAKE_BOOST_SYSPATH_PHRASE} ${CMAKE_BOOST_CMAKE_PHRASE} ${CMAKE_PAPI_PHRASE} ${CMAKE_BINUTILS_PHRASE} ${CMAKE_LIBMONITOR_PHRASE} ${CMAKE_LIBUNWIND_PHRASE} ${CMAKE_XERCESC_PHRASE} ${CMAKE_DYNINST_PHRASE} ${CMAKE_MRNET_PHRASE} ${CMAKE_MPICH_PHRASE} ${CMAKE_MPICH2_PHRASE} ${CMAKE_MVAPICH_PHRASE} ${CMAKE_MVAPICH2_PHRASE} ${CMAKE_MPT_PHRASE} ${CMAKE_CN_CBTF_PHRASE} ${CMAKE_CN_CBTF_KRELL_PHRASE} ${CMAKE_CN_PAPI_PHRASE} ${CMAKE_CN_BOOST_PHRASE} ${CMAKE_CN_LIBMONITOR_PHRASE} ${CMAKE_CN_LIBUNWIND_PHRASE} ${CMAKE_CN_XERCESC_PHRASE} ${CMAKE_CN_DYNINST_PHRASE} ${CMAKE_CN_MRNET_PHRASE} ${CMAKE_OPENMPI_PHRASE} ${CMAKE_CRAYALPS_PHRASE} ${CMAKE_LTDL_PHRASE}" > ../build_cbtf_krell_cmake.txt
       

       cmake .. \
        -DCMAKE_BUILD_TYPE=None \
        -DCMAKE_CXX_FLAGS="${CBTFKRELL_CXX_FLAGS}" \
        -DCMAKE_C_FLAGS="-g -O2" \
        -DCMAKE_INSTALL_PREFIX=${CBTF_PREFIX}\
        -DCMAKE_PREFIX_PATH=${KRELL_ROOT_PREFIX} \
        ${CMAKE_RUNTIME_ONLY_PHRASE} \
        ${CMAKE_TARGET_ARCH_PHRASE} \
        ${CMAKE_RUNTIME_TARGET_ARCH_PHRASE} \
        ${CMAKE_CBTF_PHRASE} \
        ${CMAKE_BOOST_PHRASE1} \
        ${CMAKE_BOOST_PHRASE2} \
        ${CMAKE_BOOST_LIB_PHRASE} \
        ${CMAKE_BOOST_SYSPATH_PHRASE} \
        ${CMAKE_BOOST_CMAKE_PHRASE} \
        ${CMAKE_PAPI_PHRASE} \
        ${CMAKE_BINUTILS_PHRASE} \
        ${CMAKE_LIBMONITOR_PHRASE} \
        ${CMAKE_LIBUNWIND_PHRASE} \
        ${CMAKE_XERCESC_PHRASE} \
        ${CMAKE_DYNINST_PHRASE} \
        ${CMAKE_MRNET_PHRASE} \
        ${CMAKE_LIBIOMP_PHRASE} \
        ${CMAKE_MPICH_PHRASE} \
        ${CMAKE_MPICH2_PHRASE} \
        ${CMAKE_MVAPICH_PHRASE} \
        ${CMAKE_MVAPICH2_PHRASE} \
        ${CMAKE_MPT_PHRASE} \
        ${CMAKE_CN_CBTF_PHRASE} \
        ${CMAKE_CN_CBTF_KRELL_PHRASE} \
        ${CMAKE_CN_PAPI_PHRASE} \
        ${CMAKE_CN_BOOST_PHRASE} \
        ${CMAKE_CN_LIBMONITOR_PHRASE} \
        ${CMAKE_CN_LIBUNWIND_PHRASE} \
        ${CMAKE_CN_XERCESC_PHRASE} \
        ${CMAKE_CN_DYNINST_PHRASE} \
        ${CMAKE_CN_MRNET_PHRASE} \
        ${CMAKE_OPENMPI_PHRASE} \
        ${CMAKE_CRAYALPS_PHRASE} \
        ${CMAKE_LTDL_PHRASE}
       
        make clean; make ; make install

   
   else

       if [ -z $CBTF_KRELL_ROOT ]; then 
         if [ -z $KRELL_ROOT_PREFIX ]; then 
            echo "Please set CBTF_KRELL_ROOT to the location of the krell root installation director and retry"
            exit
         else
            export CBTF_KRELL_ROOT=$KRELL_ROOT_PREFIX
         fi
       else
         echo "Using CBTF_KRELL_ROOT=$CBTF_KRELL_ROOT as the krell root in building CBTF"
       fi
    
       if [ -z $CBTF_BOOST_ROOT ]; then 
         if [ -f /$CBTF_KRELL_ROOT/$LIBDIR/libboost_system.so -o -f /$CBTF_KRELL_ROOT/$LIBDIR/libboost_system-mt.so ]; then
            export CBTF_BOOST_ROOT=$CBTF_KRELL_ROOT
            export CBTF_BOOST_ROOT_LIB=$CBTF_KRELL_ROOT/$LIBDIR
         elif [ -f /$CBTF_KRELL_ROOT/$ALTLIBDIR/libboost_system.so -o -f /$CBTF_KRELL_ROOT/$ALTLIBDIR/libboost_system-mt.so ]; then
            export CBTF_BOOST_ROOT=$CBTF_KRELL_ROOT
            export CBTF_BOOST_ROOT_LIB=$CBTF_KRELL_ROOT/$ALTLIBDIR
         elif [ -f /usr/$LIBDIR/libboost_system.so -o -f /usr/$LIBDIR/libboost_system-mt.so ]; then
            export CBTF_BOOST_ROOT=/usr
            export CBTF_BOOST_ROOT_LIB=/usr/$LIBDIR
         elif [ -f /usr/$ALTLIBDIR/libboost_system.so -o -f /usr/$ALTLIBDIR/libboost_system-mt.so ]; then
            export CBTF_BOOST_ROOT=/usr
            export CBTF_BOOST_ROOT_LIB=/usr/$ALTLIBDIR
         else
            echo "Please set CBTF_BOOST_ROOT to the location of the boost installation directory and retry. We could not detect a boost installation in CBTF_KRELL_ROOT=$CBTF_KRELL_ROOT or /usr"
            exit
         fi
       else
         echo "Using CBTF_BOOST_ROOT=$CBTF_BOOST_ROOT as the boost root in building CBTF"
       fi
    
       if [ -z $CBTF_MRNET_ROOT ]; then 
         echo "CBTF_MRNET_ROOT is not set to the location of the MRNet installation directory, must be in KRELLROOT"
       else
         echo "Using CBTF_MRNET_ROOT=$CBTF_MRNET_ROOT for the MRNet installation directory."
         export MRNET_ROOT=$CBTF_MRNET_ROOT
       fi
    
       if [ -z $CBTF_PREFIX ]; then 
         echo "Please set CBTF_PREFIX to the location of the CBTF installation directory and retry"
         exit
       else
         echo "Using CBTF_PREFIX=$CBTF_PREFIX as the CBTF installation directory."
       fi

       if [ -z $CBTF_TARGET_ARCH ]; then
         echo "Not Using CBTF_TARGET_ARCH for build_cbtf_krell_script."
          ../../../detect_installed.sh   > ./build_cbtf_krell_script
       else
         echo "Using CBTF_TARGET_ARCH=$CBTF_TARGET_ARCH as the CBTF target arch for build_cbtf_krell_script."
          ../../../detect_installed.sh  --target-arch $CBTF_TARGET_ARCH > ./build_cbtf_krell_script
       fi

       while read line
       do
         echo "processing line, top of while read line"
         echo "$line"
         # actual install-cbtf call is below in $line
         eval $line
       done < ./build_cbtf_krell_script
       #rm ./build_cbtf_krell_script

   fi

   #cd ../../..
   popd
   popd
}

function build_cbtf_argonavis_routine() { 
   echo ""
   echo "Building cbtf-argonavis."
   echo ""
   echo "The script will use $CBTF_PREFIX as installation."
   echo ""

   # cbtf
   build_cbtf_argonavis_script=""
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/cbtf-argonavis-$cbtfver.tar.gz
   cp SOURCES/cbtf-argonavis-$cbtfver.tar.gz BUILD/$sys/cbtf-argonavis-$cbtfver.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   rm -rf cbtf-argonavis
   tar -xzf cbtf-argonavis-$cbtfver.tar.gz
   #cd cbtf-argonavis
   pushd cbtf-argonavis

   build_oss_with_cmake=1
   #build_oss_with_cmake=0
   if [ "$build_oss_with_cmake" = 1 ] ; then

       # Add cmake build here
       setup_for_oss_cbtf

       if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
           if [ "$build_with_intel" = 1 ]; then
               export cc="icc -mmic"
               export CXX="icpc -mmic"
               export CC="icc -mmic"
               export PATH=/usr/linux-k1om-4.7/bin:$PATH
           else
               export cc="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" 
               export CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" 
               export CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" 
           fi
       else
           if [ "$build_with_intel" = 1 ]; then
               export cc=icc
               export CXX=icpc
               export CC=icc
           else
               export cc=gcc
               export CXX=g++
               export CC=gcc
           fi
       fi

       rm -rf build_cbtf_argonavis
       mkdir build_cbtf_argonavis
       pushd build_cbtf_argonavis

       # Add cmake build here

       #
       # Need to come up with a check for what compilers handle c++11
       # Commenting out until there is time to figure that out.
       # Maybe this should be done in the CMakeLists.txt file inside the source directory.
       # FIXME - jeg
       export CBTFARGO_CXX_FLAGS="-g -O2"
       #export CBTFARGO_CXX_FLAGS="-g -O2 -std=c++11"
       #if [ "compiler check" ] ; then\
       #    export CBTFARGO_CXX_FLAGS="-g -O2 -std=c++11"
       #fi
       echo "Building cbtf with CBTFARGO_CXX_FLAGS=${CBTFARGO_CXX_FLAGS}"

       echo "cmake .. -DCMAKE_BUILD_TYPE=None -DCMAKE_CXX_FLAGS=${CBTFARGO_CXX_FLAGS} -DCMAKE_C_FLAGS=-g -O2  -DCMAKE_INSTALL_PREFIX=${CBTF_PREFIX} -DCMAKE_PREFIX_PATH=${KRELL_ROOT_PREFIX} ${CMAKE_RUNTIME_ONLY_PHRASE} ${CMAKE_RUNTIME_TARGET_ARCH_PHRASE} ${CMAKE_TARGET_ARCH_PHRASE} ${CMAKE_CBTF_PHRASE} ${CMAKE_CBTF_KRELL_PHRASE} ${CMAKE_CUDA_PHRASE1} ${CMAKE_CUDA_PHRASE2} ${CMAKE_CUPTI_PHRASE1} ${CMAKE_CUPTI_PHRASE2} ${CMAKE_BOOST_PHRASE1} ${CMAKE_BOOST_PHRASE2} ${CMAKE_BOOST_LIB_PHRASE} ${CMAKE_BOOST_SYSPATH_PHRASE} ${CMAKE_BOOST_CMAKE_PHRASE} ${CMAKE_LIBMONITOR_PHRASE} ${CMAKE_MRNET_PHRASE}" > ../build_cbtf_argonavis_cmake.txt

       cmake .. \
        -DCMAKE_BUILD_TYPE=None \
        -DCMAKE_CXX_FLAGS="${CBTFARGO_CXX_FLAGS}" \
        -DCMAKE_C_FLAGS="-g -O2" \
        -DCMAKE_INSTALL_PREFIX=${CBTF_PREFIX}\
        -DCMAKE_PREFIX_PATH=${KRELL_ROOT_PREFIX} \
        ${CMAKE_RUNTIME_ONLY_PHRASE} \
        ${CMAKE_RUNTIME_TARGET_ARCH_PHRASE} \
        ${CMAKE_TARGET_ARCH_PHRASE} \
        ${CMAKE_CBTF_PHRASE} \
        ${CMAKE_CBTF_KRELL_PHRASE} \
        ${CMAKE_CUDA_PHRASE1} \
        ${CMAKE_CUDA_PHRASE2} \
        ${CMAKE_CUPTI_PHRASE1} \
        ${CMAKE_CUPTI_PHRASE2} \
        ${CMAKE_BOOST_PHRASE1} \
        ${CMAKE_BOOST_PHRASE2} \
        ${CMAKE_BOOST_LIB_PHRASE} \
        ${CMAKE_BOOST_SYSPATH_PHRASE} \
        ${CMAKE_BOOST_CMAKE_PHRASE} \
        ${CMAKE_PAPI_PHRASE} \
        ${CMAKE_LIBMONITOR_PHRASE} \
        ${CMAKE_MRNET_PHRASE} 
       
        make clean; make ; make install
   
   else
       if [ -z $CBTF_KRELL_ROOT ]; then 
         if [ -z $KRELL_ROOT_PREFIX ]; then 
            echo "Please set CBTF_KRELL_ROOT to the location of the krell root installation director and retry"
            exit
         else
            export CBTF_KRELL_ROOT=$KRELL_ROOT_PREFIX
         fi
       else
         echo "Using CBTF_KRELL_ROOT=$CBTF_KRELL_ROOT as the krell root in building CBTF"
       fi
    
       if [ -z $CBTF_BOOST_ROOT ]; then 
         if [ -f /$CBTF_KRELL_ROOT/$LIBDIR/libboost_system.so -o -f /$CBTF_KRELL_ROOT/$LIBDIR/libboost_system-mt.so ]; then
            export CBTF_BOOST_ROOT=$CBTF_KRELL_ROOT
            export CBTF_BOOST_ROOT_LIB=$CBTF_KRELL_ROOT/$LIBDIR
         elif [ -f /$CBTF_KRELL_ROOT/$ALTLIBDIR/libboost_system.so -o -f /$CBTF_KRELL_ROOT/$ALTLIBDIR/libboost_system-mt.so ]; then
            export CBTF_BOOST_ROOT=$CBTF_KRELL_ROOT
            export CBTF_BOOST_ROOT_LIB=$CBTF_KRELL_ROOT/$ALTLIBDIR
         elif [ -f /usr/$LIBDIR/libboost_system.so -o -f /usr/$LIBDIR/libboost_system-mt.so ]; then
            export CBTF_BOOST_ROOT=/usr
            export CBTF_BOOST_ROOT_LIB=/usr/$LIBDIR
         elif [ -f /usr/$ALTLIBDIR/libboost_system.so -o -f /usr/$ALTLIBDIR/libboost_system-mt.so ]; then
            export CBTF_BOOST_ROOT=/usr
            export CBTF_BOOST_ROOT_LIB=/usr/$ALTLIBDIR
         else
            echo "Please set CBTF_BOOST_ROOT to the location of the boost installation directory and retry. We could not detect a boost installation in CBTF_KRELL_ROOT=$CBTF_KRELL_ROOT or /usr"
            exit
         fi
       else
         echo "Using CBTF_BOOST_ROOT=$CBTF_BOOST_ROOT as the boost root in building CBTF"
       fi
    
       if [ -z $CBTF_MRNET_ROOT ]; then 
         echo "CBTF_MRNET_ROOT is not set to the location of the MRNet installation directory, must be in KRELLROOT"
       else
         echo "Using CBTF_MRNET_ROOT=$CBTF_MRNET_ROOT for the MRNet installation directory."
         export MRNET_ROOT=$CBTF_MRNET_ROOT
       fi
    
       if [ -z $CBTF_PREFIX ]; then 
         echo "Please set CBTF_PREFIX to the location of the CBTF installation directory and retry"
         exit
       else
         echo "Using CBTF_PREFIX=$CBTF_PREFIX as the CBTF installation directory."
       fi

       if [ -z $CBTF_TARGET_ARCH ]; then
         echo "Not Using CBTF_TARGET_ARCH for build_cbtf_argonavis_script."
          ../../../detect_installed.sh   > ./build_cbtf_argonavis_script
       else
         echo "Using CBTF_TARGET_ARCH=$CBTF_TARGET_ARCH as the CBTF target arch for build_cbtf_argonavis_script."
          ../../../detect_installed.sh  --target-arch $CBTF_TARGET_ARCH > ./build_cbtf_argonavis_script
       fi

       while read line
       do
         echo "processing line, top of while read line"
         echo "$line"
         # actual install-cbtf call is below in $line
         eval $line
       done < ./build_cbtf_argonavis_script
       #rm ./build_cbtf_argonavis_script
   fi

   #cd ../../..
   popd
   popd
}


function build_cbtf_lanl_routine() { 
   echo ""
   echo "Building cbtf-lanl."
   echo ""
   echo "The script will use $CBTF_PREFIX as installation."
   echo ""

   # cbtf
   build_cbtf_lanl_script=""
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/cbtf-lanl-$cbtfver.tar.gz
   cp SOURCES/cbtf-lanl-$cbtfver.tar.gz BUILD/$sys/cbtf-lanl-$cbtfver.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   rm -rf cbtf-lanl
   tar -xzf cbtf-lanl-$cbtfver.tar.gz
   #cd cbtf-lanl
   pushd cbtf-lanl
   if [ -z $CBTF_KRELL_ROOT ]; then 
     if [ -z $KRELL_ROOT_PREFIX ]; then 
        echo "Please set CBTF_KRELL_ROOT to the location of the krell root installation director and retry"
        exit
     else
        export CBTF_KRELL_ROOT=$KRELL_ROOT_PREFIX
     fi
   else
     echo "Using CBTF_KRELL_ROOT=$CBTF_KRELL_ROOT as the krell root in building CBTF"
   fi

   if [ -z $CBTF_BOOST_ROOT ]; then 
     if [ -f /$CBTF_KRELL_ROOT/$LIBDIR/libboost_system.so -o -f /$CBTF_KRELL_ROOT/$LIBDIR/libboost_system-mt.so ]; then
        export CBTF_BOOST_ROOT=$CBTF_KRELL_ROOT
        export CBTF_BOOST_ROOT_LIB=$CBTF_KRELL_ROOT/$LIBDIR
     elif [ -f /$CBTF_KRELL_ROOT/$ALTLIBDIR/libboost_system.so -o -f /$CBTF_KRELL_ROOT/$ALTLIBDIR/libboost_system-mt.so ]; then
        export CBTF_BOOST_ROOT=$CBTF_KRELL_ROOT
        export CBTF_BOOST_ROOT_LIB=$CBTF_KRELL_ROOT/$ALTLIBDIR
     elif [ -f /usr/$LIBDIR/libboost_system.so -o -f /usr/$LIBDIR/libboost_system-mt.so ]; then
        export CBTF_BOOST_ROOT=/usr
        export CBTF_BOOST_ROOT_LIB=/usr/$LIBDIR
     elif [ -f /usr/$ALTLIBDIR/libboost_system.so -o -f /usr/$ALTLIBDIR/libboost_system-mt.so ]; then
        export CBTF_BOOST_ROOT=/usr
        export CBTF_BOOST_ROOT_LIB=/usr/$ALTLIBDIR
     else
        echo "Please set CBTF_BOOST_ROOT to the location of the boost installation directory and retry. We could not detect a boost installation in CBTF_KRELL_ROOT=$CBTF_KRELL_ROOT or /usr"
        exit
     fi
   else
     echo "Using CBTF_BOOST_ROOT=$CBTF_BOOST_ROOT as the boost root in building CBTF"
   fi

   if [ -z $CBTF_MRNET_ROOT ]; then 
     echo "CBTF_MRNET_ROOT is not set to the location of the MRNet installation directory, must be in KRELLROOT"
   else
     echo "Using CBTF_MRNET_ROOT=$CBTF_MRNET_ROOT for the MRNet installation directory."
     export MRNET_ROOT=$CBTF_MRNET_ROOT
   fi

   if [ -z $CBTF_PREFIX ]; then 
     echo "Please set CBTF_PREFIX to the location of the CBTF installation directory and retry"
     exit
   else
     echo "Using CBTF_PREFIX=$CBTF_PREFIX as the CBTF installation directory."
   fi

   build_oss_with_cmake=1
   #build_oss_with_cmake=0
   if [ "$build_oss_with_cmake" = 1 ] ; then

       # Add cmake build here
       setup_for_oss_cbtf

       if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
           if [ "$build_with_intel" = 1 ]; then
               export cc="icc -mmic"
               export CXX="icpc -mmic"
               export CC="icc -mmic"
               export PATH=/usr/linux-k1om-4.7/bin:$PATH
           else
               export cc="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" 
               export CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" 
               export CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" 
           fi
       else
           if [ "$build_with_intel" = 1 ]; then
               export cc=icc
               export CXX=icpc
               export CC=icc
           else
               export cc=gcc
               export CXX=g++
               export CC=gcc
           fi
       fi

       rm -rf build_cbtf_lanl
       mkdir build_cbtf_lanl
       pushd build_cbtf_lanl

       # Add cmake build here

       #
       # Need to come up with a check for what compilers handle c++11
       # Commenting out until there is time to figure that out.
       # Maybe this should be done in the CMakeLists.txt file inside the source directory.
       # FIXME - jeg
       export CBTFLANL_CXX_FLAGS="-g -O2"
       #export CBTFLANL_CXX_FLAGS="-g -O2 -std=c++11"
       #if [ "compiler check" ] ; then\
       #    export CBTFLANL_CXX_FLAGS="-g -O2 -std=c++11"
       #fi
       echo "Building cbtf with CBTFLANL_CXX_FLAGS=${CBTFLANL_CXX_FLAGS}"

       echo "cmake ..  -DCMAKE_BUILD_TYPE=None -DCMAKE_CXX_FLAGS=${CBTFLANL_CXX_FLAGS} -DCMAKE_C_FLAGS=-g -O2 -DCMAKE_INSTALL_PREFIX=${CBTF_PREFIX} -DCMAKE_PREFIX_PATH=${KRELL_ROOT_PREFIX} ${CMAKE_RUNTIME_ONLY_PHRASE} ${CMAKE_TARGET_ARCH_PHRASE} ${CMAKE_CBTF_PHRASE} ${CMAKE_CBTF_KRELL_PHRASE} ${CMAKE_BOOST_PHRASE1} ${CMAKE_BOOST_PHRASE2} ${CMAKE_BOOST_LIB_PHRASE} ${CMAKE_BOOST_SYSPATH_PHRASE} ${CMAKE_BOOST_CMAKE_PHRASE} ${CMAKE_BINUTILS_PHRASE} ${CMAKE_XERCESC_PHRASE} ${CMAKE_MRNET_PHRASE}" > ../build_cbtf_lanl_cmake.txt

       cmake .. \
        -DCMAKE_BUILD_TYPE=None \
        -DCMAKE_CXX_FLAGS="${CBTFLANL_CXX_FLAGS}" \
        -DCMAKE_C_FLAGS="-g -O2" \
        -DCMAKE_INSTALL_PREFIX=${CBTF_PREFIX}\
        -DCMAKE_PREFIX_PATH=${KRELL_ROOT_PREFIX} \
        ${CMAKE_RUNTIME_ONLY_PHRASE} \
        ${CMAKE_TARGET_ARCH_PHRASE} \
        ${CMAKE_CBTF_PHRASE} \
        ${CMAKE_CBTF_KRELL_PHRASE} \
        ${CMAKE_BOOST_PHRASE1} \
        ${CMAKE_BOOST_PHRASE2} \
        ${CMAKE_BOOST_LIB_PHRASE} \
        ${CMAKE_BOOST_SYSPATH_PHRASE} \
        ${CMAKE_BOOST_CMAKE_PHRASE} \
        ${CMAKE_BINUTILS_PHRASE} \
        ${CMAKE_XERCESC_PHRASE} \
        ${CMAKE_MRNET_PHRASE} 
       
        make clean; make ; make install

   else
       if [ -z $CBTF_TARGET_ARCH ]; then
         echo "Not Using CBTF_TARGET_ARCH for build_cbtf_lanl_script."
          ../../../detect_installed.sh   > ./build_cbtf_lanl_script
       else
         echo "Using CBTF_TARGET_ARCH=$CBTF_TARGET_ARCH as the CBTF target arch for build_cbtf_lanl_script."
          ../../../detect_installed.sh  --target-arch $CBTF_TARGET_ARCH > ./build_cbtf_lanl_script
       fi

       while read line
       do
         echo "processing line, top of while read line"
         echo "$line"
         # actual install-cbtf call is below in $line
         eval $line
       done < ./build_cbtf_lanl_script
       #rm ./build_cbtf_lanl_script
   fi

   #cd ../../..
   popd
   popd
   
}


function build_bison_routine() { 
   echo ""
   echo "Building bison."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX/bison_root as installation unless KRELL_ROOT_BISON_ROOT is set."
   echo "If KRELL_ROOT_PREFIX and KRELL_ROOT_BISON_ROOT are both not set then the build script warns and halts."
   echo ""

   if [ -z $KRELL_ROOT_BISON_ROOT ]; then 
        echo "   "
        echo "         KRELL_ROOT_BISON_ROOT is NOT set."
        echo "   "
	if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          export KRELL_ROOT_BISON_ROOT=$KRELL_ROOT_PREFIX/bison_root
          echo "         Using KRELL_ROOT_BISON_ROOT based on KRELL_ROOT_PREFIX, KRELL_ROOT_BISON_ROOT=$KRELL_ROOT_BISON_ROOT"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: KRELL_ROOT_PREFIX"
          echo "             and KRELL_ROOT_BISON_ROOT are not set.  "
          echo "             If KRELL_ROOT_PREFIX is set then KRELL_ROOT_PREFIX/bison_root will be used for"
          echo "             KRELL_ROOT_BISON_ROOT."
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX OR KRELL_ROOT_BISON_ROOT and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         KRELL_ROOT_BISON_ROOT was set."
      echo "         Using KRELL_ROOT_BISON_ROOT=$KRELL_ROOT_BISON_ROOT"
      echo "   "
   fi

   echo 
   echo "Continue the build process for the bison root? <y/n>"
   echo

   read answer
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the bison build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     export LD_LIBRARY_PATH=$KRELL_ROOT_BISON_ROOT/lib
   else
     export LD_LIBRARY_PATH=$KRELL_ROOT_BISON_ROOT/lib:$LD_LIBRARY_PATH
   fi

   if [ -z $PATH ]; then 
     export PATH=$KRELL_ROOT_BISON_ROOT/bin:$PATH
   else
     export PATH=$KRELL_ROOT_BISON_ROOT/bin:$PATH
   fi

   # bison
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/bison-$bisonver.tar.gz
   rm -rf BUILD/$sys/bison-$bisonver
   cp SOURCES/bison-$bisonver.tar.gz BUILD/$sys/bison-$bisonver.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   tar -xzf bison-$bisonver.tar.gz
   #cd bison-$bisonver
   pushd bison-$bisonver
   ./configure --prefix=$KRELL_ROOT_BISON_ROOT
   make; make install
   #cd ../../..
   popd
   popd
}


function build_flex_routine() { 
   echo ""
   echo "Building flex."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX/flex_root as installation unless KRELL_ROOT_FLEX_ROOT is set."
   echo "If KRELL_ROOT_PREFIX and KRELL_ROOT_FLEX_ROOT are both not set then the build script warns and halts."
   echo ""

   if [ -z $KRELL_ROOT_FLEX_ROOT ]; then 
        echo "   "
        echo "         KRELL_ROOT_FLEX_ROOT is NOT set."
        echo "   "
	if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          export KRELL_ROOT_FLEX_ROOT=$KRELL_ROOT_PREFIX
          echo "         Using KRELL_ROOT_FLEX_ROOT based on KRELL_ROOT_PREFIX, KRELL_ROOT_FLEX_ROOT=$KRELL_ROOT_FLEX_ROOT"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: KRELL_ROOT_PREFIX"
          echo "             and KRELL_ROOT_FLEX_ROOT are not set.  "
          echo "             If KRELL_ROOT_PREFIX is set then KRELL_ROOT_PREFIX/flex_root will be used for"
          echo "             KRELL_ROOT_FLEX_ROOT."
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX OR KRELL_ROOT_FLEX_ROOT and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         KRELL_ROOT_FLEX_ROOT was set."
      echo "         Using KRELL_ROOT_FLEX_ROOT=$KRELL_ROOT_FLEX_ROOT"
      echo "   "
   fi

   echo 
   echo "Continue the build process for the flex root? <y/n>"
   echo

   read answer
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the flex build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     export LD_LIBRARY_PATH=$KRELL_ROOT_FLEX_ROOT/lib
   else
     export LD_LIBRARY_PATH=$KRELL_ROOT_FLEX_ROOT/lib:$LD_LIBRARY_PATH
   fi

   if [ -z $PATH ]; then 
     export PATH=$KRELL_ROOT_FLEX_ROOT/bin:$PATH
   else
     export PATH=$KRELL_ROOT_FLEX_ROOT/bin:$PATH
   fi

   # flex
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/flex-$flexver.tar.gz
   rm -rf BUILD/$sys/flex-$flexver
   cp SOURCES/flex-$flexver.tar.gz BUILD/$sys/flex-$flexver.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   tar -xzf flex-$flexver.tar.gz
   #cd flex-$flexver
   pushd flex-$flexver
   ./configure --prefix=$KRELL_ROOT_FLEX_ROOT
   make; make install
   #cd ../../..
   popd
   popd
}


function build_xercesc_routine() { 
   echo ""
   echo "Building xercesc."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation unless KRELL_ROOT_XERCESC is set."
   echo "If KRELL_ROOT_PREFIX and KRELL_ROOT_XERCESC are both not set then the build script warns and halts."
   echo ""

   if [ -z $KRELL_ROOT_XERCESC ]; then 
        echo "   "
        echo "         KRELL_ROOT_XERCESC is NOT set."
        echo "   "
	if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          export KRELL_ROOT_XERCESC=$KRELL_ROOT_PREFIX
          echo "         Using KRELL_ROOT_XERCESC based on KRELL_ROOT_PREFIX, KRELL_ROOT_XERCESC=$KRELL_ROOT_XERCESC"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: KRELL_ROOT_PREFIX"
          echo "             and KRELL_ROOT_XERCESC are not set.  "
          echo "             If KRELL_ROOT_PREFIX is set then KRELL_ROOT_PREFIX will be used for"
          echo "             KRELL_ROOT_XERCESC."
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX OR KRELL_ROOT_XERCESC and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         KRELL_ROOT_XERCESC was set."
      echo "         Using KRELL_ROOT_XERCESC=$KRELL_ROOT_XERCESC"
      echo "   "
   fi

   echo 
   echo "Continue the build process for the xercesc root? <y/n>"
   echo

   if [ "$nanswer" = 9 -o $imode == 0 ]; then
        answer=Y
   else
        read answer
   fi
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the xercesc build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_XERCESC ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_XERCESC/$LIBDIR
     fi
   else
     if [ $KRELL_ROOT_XERCESC ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_XERCESC/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_XERCESC ]; then 
         export PATH=$KRELL_ROOT_XERCESC/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_XERCESC ]; then 
         export PATH=$KRELL_ROOT_XERCESC/bin:$PATH
     fi
   fi

   # xercesc
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf  BUILD/$sys/xerces-c-$xercescver.tar.gz
   rm -rf  BUILD/$sys/xerces-c-$xercescver
   cp SOURCES/xerces-c-$xercescver.tar.gz BUILD/$sys/xerces-c-$xercescver.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   tar -xzf xerces-c-$xercescver.tar.gz
   #cd xerces-c-$xercescver
   pushd xerces-c-$xercescver

   if [ -f ${build_root_home}/SOURCES/xerces-c-$xercescver.patch ]; then
      patch -p1 < ${build_root_home}/SOURCES/xerces-c-$xercescver.patch
   fi

   if [ -f ${build_root_home}/SOURCES/xerces-c-$xercescver.config.patch ]; then
      patch -p1 < ${build_root_home}/SOURCES/xerces-c-$xercescver.config.patch
   fi

   if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
       if [ "$build_with_intel" = 1 ]; then
           export PATH=/usr/linux-k1om-4.7/bin:$PATH
           CC="icc -mmic" CXX="icpc -mmic" ./configure --prefix=$KRELL_ROOT_XERCESC --libdir=$KRELL_ROOT_XERCESC/$LIBDIR --disable-network --host=x86_64-k1om-linux
       else
           CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" ./configure --prefix=$KRELL_ROOT_XERCESC --libdir=$KRELL_ROOT_XERCESC/$LIBDIR --disable-network --host=x86_64-k1om-linux
       fi
   else
      if [ "$build_with_intel" = 1 ]; then
          CC="icc" CXX="icpc" ./configure --prefix=$KRELL_ROOT_XERCESC --libdir=$KRELL_ROOT_XERCESC/$LIBDIR --disable-network
      else
          CC="gcc" CXX="g++" ./configure --prefix=$KRELL_ROOT_XERCESC --libdir=$KRELL_ROOT_XERCESC/$LIBDIR --disable-network
      fi
   fi
   make; make install
   #cd ../../..
   popd
   popd
}

function build_vampirtrace_routine() { 
   echo ""
   echo "Building vampirtrace."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation unless KRELL_ROOT_VAMPIRTRACE is set."
   echo "If KRELL_ROOT_PREFIX and KRELL_ROOT_VAMPIRTRACE are both not set then the build script warns and halts."
   echo ""

   if [ -z $KRELL_ROOT_VAMPIRTRACE ]; then 
        echo "   "
        echo "         KRELL_ROOT_VAMPIRTRACE is NOT set."
        echo "   "
	if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          export KRELL_ROOT_VAMPIRTRACE=$KRELL_ROOT_PREFIX
          echo "         Using KRELL_ROOT_VAMPIRTRACE based on KRELL_ROOT_PREFIX, KRELL_ROOT_VAMPIRTRACE=$KRELL_ROOT_VAMPIRTRACE"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: KRELL_ROOT_PREFIX"
          echo "             and KRELL_ROOT_VAMPIRTRACE are not set.  "
          echo "             If KRELL_ROOT_PREFIX is set then KRELL_ROOT_PREFIX will be used for"
          echo "             KRELL_ROOT_VAMPIRTRACE."
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX OR KRELL_ROOT_VAMPIRTRACE and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         KRELL_ROOT_VAMPIRTRACE was set."
      echo "         Using KRELL_ROOT_VAMPIRTRACE=$KRELL_ROOT_VAMPIRTRACE"
      echo "   "
   fi

   echo 
   echo "Continue the build process for the vampirtrace root? <y/n>"
   echo

   if [ "$nanswer" = 9 -o $imode == 0 ]; then
        answer=Y
   else
        #read answer
        answer=Y
   fi
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the vampirtrace build process."
       echo 
   else
       echo "   "
       exit
   fi

   setup_for_oss_cbtf

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_VAMPIRTRACE ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_VAMPIRTRACE/$LIBDIR
     fi
   else
     if [ $KRELL_ROOT_VAMPIRTRACE ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_VAMPIRTRACE/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_VAMPIRTRACE ]; then 
         export PATH=$KRELL_ROOT_VAMPIRTRACE/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_VAMPIRTRACE ]; then 
         export PATH=$KRELL_ROOT_VAMPIRTRACE/bin:$PATH
     fi
   fi

   if [ $KRELL_ROOT_MPI_OPENMPI ]; then
       export KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_OPENMPI
       export KRELL_ROOT_MPI_LIB_LINE="-lmpi"
   elif [  $KRELL_ROOT_MPI_MPICH ]; then
       export KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_MPICH
       export KRELL_ROOT_MPI_LIB_LINE="-lmpich"
   elif [  $KRELL_ROOT_MPI_MPICH2 ]; then
       export KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_MPICH2
       export KRELL_ROOT_MPI_LIB_LINE="-lmpich"
   elif [  $KRELL_ROOT_MPI_MVAPICH ]; then
       export KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_MVAPICH
       export KRELL_ROOT_MPI_LIB_LINE="-lmpich"
   elif [  $KRELL_ROOT_MPI_MVAPICH2 ]; then
       export KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_MVAPICH2
       export KRELL_ROOT_MPI_LIB_LINE="-lmpich"
   elif [  $KRELL_ROOT_MPI_MPT ]; then
       export KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_MPT
       export KRELL_ROOT_MPI_LIB_LINE="-lmpi"
   elif [  $KRELL_ROOT_MPI_LAM ]; then
       export KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_LAM
       export KRELL_ROOT_MPI_LIB_LINE="-lmpi"
   elif [  $KRELL_ROOT_MPI_LAMPI ]; then
       echo "LAMPI cannot be used for vampirtrace build"
   fi
   echo "KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_PATH"


   if [ -f $KRELL_ROOT_MPI_PATH/include/mpi.h ]; then
      grepname=`which grep`
      if test `$grepname -c SILICON $KRELL_ROOT_MPI_PATH/include/mpi.h` != 0 ; then
          echo "    NOTE: Building with SGI MPT MPI"
          WITHSGIMPT="--with-mpt"
      else
          echo "    NOTE: NOT building with SGI MPT MPI"
          WITHSGIMPT=""
     fi
   fi

   # vampirtrace
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf  BUILD/$sys/vampirtrace-$vampirtracever.tar.gz
   rm -rf  BUILD/$sys/vampirtrace
   cp SOURCES/vampirtrace-$vampirtracever.tar.gz BUILD/$sys/vampirtrace-$vampirtracever.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   tar -xzf vampirtrace-$vampirtracever.tar.gz
   #cd vampirtrace-$vampirtracever
   pushd vampirtrace

   if [ -f ${build_root_home}/SOURCES/vampirtrace-$vampirtracever.patch ]; then
      patch -p1 < ${build_root_home}/SOURCES/vampirtrace-$vampirtracever.patch
   fi

   if [ -f ${build_root_home}/SOURCES/vampirtrace-$vampirtracever.config.patch ]; then
      patch -p1 < ${build_root_home}/SOURCES/vampirtrace-$vampirtracever.config.patch
   fi

   if [ "$build_with_intel" = 1 ]; then
       CC="icc" CXX="icpc" ./configure --prefix=$KRELL_ROOT_VAMPIRTRACE --libdir=${KRELL_ROOT_VAMPIRTRACE}/${LIBDIR} --with-mpi-dir=${KRELL_ROOT_MPI_PATH} --with-mpi-lib=${KRELL_ROOT_MPI_LIB_LINE} --with-mpi-lib-dir=${KRELL_ROOT_MPI_PATH}/lib --disable-papi --with-bfd-dir=$KRELL_ROOT_BINUTILS $WITHSGIMPT
   else
       CC="gcc" CXX="g++" ./configure --prefix=$KRELL_ROOT_VAMPIRTRACE --libdir=${KRELL_ROOT_VAMPIRTRACE}/${LIBDIR} --with-mpi-dir=${KRELL_ROOT_MPI_PATH} --with-mpi-lib=${KRELL_ROOT_MPI_LIB_LINE} --with-mpi-lib-dir=${KRELL_ROOT_MPI_PATH}/lib --disable-papi --with-bfd-dir=$KRELL_ROOT_BINUTILS $WITHSGIMPT
   fi
   make; make install
   #cd ../../..
   popd
   popd
}

function build_libunwind_routine() { 
   echo ""
   echo "Building libunwind."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation."
   echo "If KRELL_ROOT_PREFIX is not set then the build script warns and halts."
   echo ""

   if [ -z $KRELL_ROOT_PREFIX ]; then 
        echo "   "
        echo "         KRELL_ROOT_PREFIX is NOT set."
        echo "   "
	if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          export KRELL_ROOT_LIBUNWIND=$KRELL_ROOT_PREFIX
          echo "         Using KRELL_ROOT_LIBUNWIND based on KRELL_ROOT_PREFIX, KRELL_ROOT_LIBUNWIND=$KRELL_ROOT_LIBUNWIND"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: KRELL_ROOT_PREFIX is not set."
          echo "             If KRELL_ROOT_PREFIX is set then KRELL_ROOT_PREFIX will be used for KRELL_ROOT_LIBUNWIND."
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX (add --krell-root-prefix <path to krell root>) and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         KRELL_ROOT_PREFIX was set."
      echo "         Using KRELL_ROOT_LIBUNWIND=$KRELL_ROOT_PREFIX"
      echo "   "
   fi

   echo 
   echo "Continue the build process for the libunwind? <y/n>"
   echo

   if [ "$nanswer" = 9 -o $imode == 0 ]; then
        answer=Y
   else
      if [ -z $KRELL_ROOT_PREFIX ]; then 
        read answer
      else
        answer=Y
      fi
   fi
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the libunwind build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if  [ $KRELL_ROOT_LIBUNWIND ]; then
        export LD_LIBRARY_PATH=$KRELL_ROOT_LIBUNWIND/$LIBDIR
     fi
   else
     if  [ $KRELL_ROOT_LIBUNWIND ]; then
         export LD_LIBRARY_PATH=$KRELL_ROOT_LIBUNWIND/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if  [ $KRELL_ROOT_LIBUNWIND ]; then
         export PATH=$KRELL_ROOT_LIBUNWIND/bin:$PATH
     fi
   else
     if  [ $KRELL_ROOT_LIBUNWIND ]; then
         export PATH=$KRELL_ROOT_LIBUNWIND/bin:$PATH
     fi
   fi
   
   # Decide if building rpm option was used (--rpm or --create-rpm)
   if [ "$use_rpm" = 1 ] ; then
     rm -rf RPMS/$sys/libunwind.OSS.*.rpm
     ./Build-RPM-krellroot libunwind-$libunwindver
     if [ -s RPMS/$sys/libunwind.OSS.*.rpm ]; then
         echo "LIBUNWIND BUILT SUCCESSFULLY with rpm build option."
     else
         echo "LIBUNWIND FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
         exit
     fi
     
     pushd RPMS/$sys
     rpm2cpio libunwind.OSS.*.rpm > libunwind.cpio
     cpio -id < libunwind.cpio
     cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
     export KRELL_ROOT_LIBUNWIND=$KRELL_ROOT_PREFIX
     popd # Back out of RPMS

   else

     # libunwind
     cd $build_root_home
     mkdir -p BUILD
     mkdir -p BUILD/$sys

     rm -rf BUILD/$sys/libunwind-$libunwindver.tar.gz
     rm -rf BUILD/$sys/libunwind-$libunwindver
     cp SOURCES/libunwind-$libunwindver.tar.gz BUILD/$sys/libunwind-$libunwindver.tar.gz
     #cd BUILD/$sys
     pushd BUILD/$sys
     tar -xzf libunwind-$libunwindver.tar.gz
     #cd libunwind-$libunwindver
     pushd libunwind-$libunwindver

     if [ -f ${build_root_home}/SOURCES/libunwind-$libunwindver.patch ]; then
        patch -p1 < ${build_root_home}/SOURCES/libunwind-$libunwindver.patch
     fi

     if [ -f ${build_root_home}/SOURCES/libunwind-$libunwindver.config.patch ]; then
        patch -p1 < ${build_root_home}/SOURCES/libunwind-$libunwindver.config.patch
     fi

  
    #echo "BUILDING LIBUNWIND, KRELL_ROOT_TARGET_ARCH=$KRELL_ROOT_TARGET_ARCH"
    #echo "BUILDING LIBUNWIND, LD_LIBRARY_PATH=$LD_LIBRARY_PATH"

    if [ "$KRELL_ROOT_TARGET_ARCH" == "bgl" ]; then
     if [ $KRELL_ROOT_TARGET_SHARED ]; then
      CFLAGS="-fPIC -dynamic"./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include \
           --mandir=$KRELL_ROOT_PREFIX/share/man --enable-shared --disable-mincore --target=powerpc-bgp-linux --host=ppc64
     else
      ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include \
           --mandir=$KRELL_ROOT_PREFIX/share/man --disable-shared  \
          --disable-cxx-exceptions --disable-mincore --target=powerpc-bgp-linux --host=ppc64
     fi
    elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgp" ]; then
     if [ $KRELL_ROOT_TARGET_SHARED ]; then
      CFLAGS="-fPIC -dynamic" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include \
           --mandir=$KRELL_ROOT_PREFIX/share/man --enable-shared --disable-mincore --target=powerpc-bgp-linux --host=ppc64
     else
      ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include \
           --mandir=$KRELL_ROOT_PREFIX/share/man --disable-shared \
          --disable-cxx-exceptions --disable-mincore --target=powerpc-bgp-linux --host=ppc64
     fi
    elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
     if [ $KRELL_ROOT_TARGET_SHARED ]; then
      CFLAGS="-fPIC -g -dynamic -m64 -DBGQ" CXXFLAGS="-fPIC -g -m64 -DBGQ" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include \
           --mandir=$KRELL_ROOT_PREFIX/share/man --enable-shared --disable-mincore --target=powerpc64-bgq-linux
     else
       CFLAGS="-fPIC -g -m64 -DBGQ" CXXFLAGS="-g -m64 -DBGQ" LDFLAGS="-m64" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include \
           --mandir=$KRELL_ROOT_PREFIX/share/man --disable-shared --enable-static \
          --disable-cxx-exceptions --disable-mincore --target=powerpc64-bgq-linux
     fi

    elif [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then

         if [ "$build_with_intel" = 1 ]; then
             export PATH=/usr/linux-k1om-4.7/bin:$PATH
             ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man --host=x86_64-k1om-linux cc="icc" CC="icc" CXX="icpc" CFLAGS="-O2 -fPIC -g -mmic" LDFLAGS="-mmic"
             #CC="icc" CXX="icpc" CFLAGS="-O2 -fPIC -g -mmic" LDFLAGS="-mmic" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man --host=x86_64-k1om-linux
         else
             CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" ./configure --prefix=$KRELL_ROOT_PREFIX --mandir=$KRELL_ROOT_PREFIX/share/man --target=x86_64-k1om-linux --host=x86_64-k1om-linux
         fi



    elif [ "$KRELL_ROOT_TARGET_ARCH" == "arm" ]; then

       CC="gcc" CXX="g++" CFLAGS="-funwind-tables -fasynchronous-unwind-tables -O2 -g" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man --enable-debug-frame

    elif [ "$KRELL_ROOT_TARGET_ARCH" == "power8" ]; then

       CC="gcc" CXX="g++" CFLAGS="-O2 -g" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man

    else
  
     if [ `uname -m` = "ppc64" ]; then
      if [ $LIBDIR == "lib64" ]; then
         CC="gcc" CXX="g++" CFLAGS="-fPIC -g -m64" CXXFLAGS="-g -m64" LDFLAGS="-m64" ./configure --prefix=$KRELL_ROOT_PREFIX \
                 --libdir=$KRELL_ROOT_PREFIX/$LIBDIR \
                 --mandir=$KRELL_ROOT_PREFIX/share/man 
      else
         CC="gcc" CXX="g++" CFLAGS=-fPIC ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR \
      	      --mandir=$KRELL_ROOT_PREFIX/share/man 
      fi
     else
         if [ "$build_with_intel" = 1 ]; then
             CC="icc" CXX="icpc" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man 
         else
             CC="gcc" CXX="g++" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man 
         fi
     fi
   fi
  
     make 
     make install
     #cd ../../..
     export KRELL_ROOT_LIBUNWIND=$KRELL_ROOT_PREFIX
     popd
     popd
  fi
}

function build_libmonitor_routine() { 
   echo ""
   echo "Building libmonitor."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation directory."
   echo ""

   if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variable: KRELL_ROOT_PREFIX"
          echo "             is not set.  "
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX and restart the install script.  Thanks."
          echo "   "
          exit
   fi

   echo 
   echo "Continue the build process for libmonitor? <y/n>"
   echo

#   read answer
   answer=Y
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the libmonitor build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   fi

   #os_vers=`uname -r`
   #echo "os_vers=$os_vers"
   #platform=`uname -i`
   #echo "platform=$platform"

  # Decide if building rpm option was used (--rpm or --create-rpm)
  if [ "$use_rpm" = 1 ] ; then
     rm -rf RPMS/$sys/libmonitor.OSS.*.rpm
     ./Build-RPM-krellroot libmonitor-$libmonitorver
     if [ -s RPMS/$sys/libmonitor.OSS.*.rpm ]; then
         echo "LIBMONITOR BUILT SUCCESSFULLY with rpm build option."
     else
         echo "LIBMONITOR FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
         exit
     fi
     pushd RPMS/$sys
     rpm2cpio libmonitor.OSS.*.rpm > libmonitor.cpio
     cpio -id < libmonitor.cpio
     cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
     export KRELL_ROOT_LIBMONITOR=$KRELL_ROOT_PREFIX
     popd # Back out of RPMS
  else

     # libmonitor
     cd $build_root_home
     mkdir -p BUILD
     mkdir -p BUILD/$sys
     rm -rf BUILD/$sys/libmonitor-$libmonitorver.tar.gz
     rm -rf BUILD/$sys/libmonitor-$libmonitorver
     cp SOURCES/libmonitor-$libmonitorver.tar.gz BUILD/$sys/libmonitor-$libmonitorver.tar.gz
     cd BUILD/$sys
     rm -rf libmonitor-$libmonitorver
     tar -xzf libmonitor-$libmonitorver.tar.gz

     cd libmonitor-$libmonitorver

     if [ -f ${build_root_home}/SOURCES/libmonitor-$libmonitorver.patch ]; then
        patch -p1 < ${build_root_home}/SOURCES/libmonitor-$libmonitorver.patch
     fi

     if [ -f ${build_root_home}/SOURCES/libmonitor-$libmonitorver.config.patch ]; then
        patch -p1 < ${build_root_home}/SOURCES/libmonitor-$libmonitorver.config.patch
     fi

    #echo "--BUILDING LIBMONITOR, KRELL_ROOT_TARGET_ARCH=$KRELL_ROOT_TARGET_ARCH"

    if [ "$KRELL_ROOT_TARGET_ARCH" == "bgl" ]; then
     if [ $KRELL_ROOT_TARGET_SHARED ]; then
      CFLAGS="-fPIC -dynamic" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include --bindir=$KRELL_ROOT_PREFIX/bin --enable-fork --enable-dlfcn --enable-link-preload --enable-shared --target=powerpc-bgp-linux --host=ppc64
     else
      ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include --bindir=$KRELL_ROOT_PREFIX/bin --disable-fork --disable-dlfcn --disable-link-preload --disable-shared --target=powerpc-bgp-linux --host=ppc64
     fi
    elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgp" ]; then
     if [ $KRELL_ROOT_TARGET_SHARED ]; then
      CFLAGS="-fPIC -dynamic" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include --bindir=$KRELL_ROOT_PREFIX/bin --enable-fork --enable-dlfcn --enable-link-preload --enable-shared --target=powerpc-bgp-linux --host=ppc64
     else
      ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include --bindir=$KRELL_ROOT_PREFIX/bin --disable-fork --disable-dlfcn --disable-link-preload --disable-shared --target=powerpc-bgp-linux --host=ppc64
     fi
    elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
     if [ $KRELL_ROOT_TARGET_SHARED ]; then
      CFLAGS="-fPIC -dynamic" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include --bindir=$KRELL_ROOT_PREFIX/bin --enable-fork --enable-dlfcn --enable-link-preload --target=powerpc64-bgq-linux --enable-shared
     else
      ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include --bindir=$KRELL_ROOT_PREFIX/bin --disable-fork --disable-dlfcn --disable-link-preload --disable-shared --target=powerpc64-bgq-linux --enable-pthreads
     fi
    elif [ "$KRELL_ROOT_TARGET_ARCH" == "cray" ]; then
     if [ $KRELL_ROOT_TARGET_SHARED ]; then
      #CC="gcc" CXX="g++" CFLAGS="-fPIC -O2 -g" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR
      CC="gcc" CXX="g++" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR
     else
      CC="gcc" CXX="g++" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include --bindir=$KRELL_ROOT_PREFIX/bin --disable-fork --disable-dlfcn --disable-link-preload --disable-shared --host=x86_64 --enable-pthreads
     fi

    elif [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then

        if [ "$build_with_intel" = 1 ]; then
            export PATH=/usr/linux-k1om-4.7/bin:$PATH
            cc="icc" CC="icc" CXX="icpc" CFLAGS="-mmic -O1 -g" LDFLAGS="-mmic" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --host=x86_64-k1om-linux
        else
            CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --host=x86_64-k1om-linux
        fi

    elif [ "$KRELL_ROOT_TARGET_ARCH" == "arm" ]; then

      ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR CFLAGS="-funwind-tables -fasynchronous-unwind-tables -g -O1" CC=gcc

    elif [ "$KRELL_ROOT_TARGET_ARCH" == "power8" ]; then

      ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR CFLAGS="-g -O1" CC=gcc

    else
         # default fall through cluster case
         if [ "$build_with_intel" = 1 ]; then
             ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR  CC=icc
         else
             ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR CC=gcc
         fi
    fi
    make
    make install
    export KRELL_ROOT_LIBMONITOR=$KRELL_ROOT_PREFIX
    cd ../../..
 fi
}


function build_papi_routine() { 
   echo ""
   echo "Building papi."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation directory."
   echo ""

   if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variable: KRELL_ROOT_PREFIX"
          echo "             is not set.  "
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX and restart the install script.  Thanks."
          echo "   "
          exit
   fi

   echo 
   echo "Continue the build process for papi? <y/n>"
   echo

#   read answer
   answer=Y
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the papi build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   fi

   os_vers=`uname -r`
   echo "os_vers=$os_vers"
   platform=`uname -i`
   echo "platform=$platform"

   if [ "$use_rpm" = 1 ] ; then
     rm -rf RPMS/$sys/papi.OSS.*.rpm
     ./Build-RPM-krellroot papi-$papiver
     if [ -s RPMS/$sys/papi.OSS.*.rpm ]; then
        echo "PAPI BUILT SUCCESSFULLY with rpm build option."
     else
        echo "PAPI FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
        exit
     fi
     if [ -z $KRELL_ROOT_PREFIX ]; then
       export KRELL_ROOT_PAPI=/opt/KRELLROOT
     else
       export KRELL_ROOT_PAPI=$KRELL_ROOT_PREFIX
     fi
     pushd RPMS/$sys
     rpm2cpio papi.OSS.*.rpm > papi.cpio
     cpio -id < papi.cpio
     cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
     export KRELL_ROOT_PAPI=$KRELL_ROOT_PREFIX
     popd # Back out of RPMS
   else
     # papi
     cd $build_root_home
     mkdir -p BUILD
     mkdir -p BUILD/$sys
     rm -rf BUILD/$sys/papi-$papiver.tar.gz
     cp SOURCES/papi-$papiver.tar.gz BUILD/$sys/papi-$papiver.tar.gz
     #cd BUILD/$sys
     pushd BUILD/$sys
     rm -rf papi-$papiver
     tar -xzf papi-$papiver.tar.gz
     pushd papi-$papiver/src
     if [ -f ${build_root_home}/SOURCES/papi-$papiver.patch ]; then
        patch -p1 < ${build_root_home}/SOURCES/papi-$papiver.patch
     fi
     #cd papi-$papiver/src
  
     if [ "$KRELL_ROOT_TARGET_ARCH" == "bgp" ]; then
       if [ $KRELL_ROOT_TARGET_SHARED ]; then
         CFLAGS="-fPIC -dynamic" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man --includedir=$KRELL_ROOT_PREFIX/include --with-OS=bgp CC=gcc
       else
         ./configure --prefix=$KRELL_ROOT_PREFIX --mandir=$KRELL_ROOT_PREFIX/share/man --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include --with-OS=bgp CC=gcc
       fi
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
       if [ $KRELL_ROOT_TARGET_SHARED ]; then
         CFLAGS="-fPIC -dynamic" ./configure --prefix=$KRELL_ROOT_PREFIX --with-OS=bgq --with-bgpm_installdir=/bgsys/drivers/ppcfloor CC=/bgsys/drivers/ppcfloor/gnu-linux/bin/powerpc64-bgq-linux-gcc F77=/bgsys/drivers/ppcfloor/gnu-linux/bin/powerpc64-bgq-linux-gfortran --with-components="bgpm/L2unit bgpm/CNKunit bgpm/IOunit bgpm/NWunit" --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man --includedir=$KRELL_ROOT_PREFIX/include --enable-shared
       else
       ./configure --prefix=$KRELL_ROOT_PREFIX --with-OS=bgq --with-bgpm_installdir=/bgsys/drivers/ppcfloor CC=/bgsys/drivers/ppcfloor/gnu-linux/bin/powerpc64-bgq-linux-gcc F77=/bgsys/drivers/ppcfloor/gnu-linux/bin/powerpc64-bgq-linux-gfortran --with-components="bgpm/L2unit bgpm/CNKunit bgpm/IOunit bgpm/NWunit" --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man --includedir=$KRELL_ROOT_PREFIX/include
       fi
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgl" ]; then
       if [ $KRELL_ROOT_TARGET_SHARED ]; then
         CFLAGS="-fPIC -dynamic" ./configure --prefix=$KRELL_ROOT_PREFIX --with-OS=bgp CC=gcc
       else
         ./configure --prefix=$KRELL_ROOT_PREFIX --with-OS=bgl CC=gcc
       fi
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "cray" ]; then
       if [ $KRELL_ROOT_TARGET_SHARED ]; then
         CC="gcc" CXX="g++" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man --includedir=$KRELL_ROOT_PREFIX/include --host=x86_64
       else
         CC="gcc" CXX="g++" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man --includedir=$KRELL_ROOT_PREFIX/include --host=x86_64
       fi
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then

         if [ "$build_with_intel" = 1 ]; then
             export PATH=/usr/linux-k1om-4.7/bin:$PATH
             cc="icc" CC="icc" CXX="icpc" CFLAGS="-O2 -fPIC -g -mmic" LDFLAGS="-mmic" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man --includedir=$KRELL_ROOT_PREFIX/include --host=x86_64-k1om-linux --with-mic --with-ffsll --with-walltimer=cycle --with-tls=__thread --with-virtualtimer=clock_thread_cputime_id  --with-ar=/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-ar --with-strip=/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-strip
         else
         #    cc="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man --includedir=$KRELL_ROOT_PREFIX/include --host=x86_64-k1om-linux --with-mic --with-ffsll --with-walltimer=cycle --with-tls=__thread --with-virtualtimer=clock_thread_cputime_id
             cc="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man --includedir=$KRELL_ROOT_PREFIX/include --with-mic --host=x86_64-k1om-linux --with-arch=k1om --with-ffsll --with-walltimer=cycle --with-tls=__thread --with-virtualtimer=clock_thread_cputime_id
         fi

     else
  
       if [ $platform == "ppc64" ]; then
        if [ $LIBDIR == "lib64" ]; then
          ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man \
      	   --with-tests=ctests --with-debug=yes --with-bitmode=64 \
             --with-no-cpu-counters --with-arch=ppc64 CC=/usr/bin/cc cc=/usr/bin/cc
        else
          ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man \
             --with-tests=ctests --with-debug=yes --with-bitmode=32 \
  	   --with-no-cpu-counters --with-arch=ppc64 CC=/usr/bin/cc cc=/usr/bin/cc
        fi
       else
          # default fall through case
          if [ "$build_with_intel" = 1 ]; then
              CC="icc" CXX="icpc" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man \
       	                                     --with-tests=ctests --with-debug=yes
          else
              CC="gcc" CXX="g++" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man \
       	                                     --with-tests=ctests --with-debug=yes
          fi
       fi
     fi
  
     make 
     make install
     export KRELL_ROOT_PAPI_ROOT=$KRELL_ROOT_PREFIX
     #cd ../../../..
     popd
     popd
   fi
}
  
function build_sqlite_routine() { 
   echo ""
   echo "Building sqlite."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation directory."
   echo ""

   if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variable: KRELL_ROOT_PREFIX"
          echo "             is not set.  "
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX and restart the install script.  Thanks."
          echo "   "
          exit
   fi

   echo 
   echo "Continue the build process for sqlite? <y/n>"
   echo
  
  #   read answer
   answer=Y
    
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the sqlite build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   fi

   os_vers=`uname -r`
   echo "os_vers=$os_vers"
   platform=`uname -i`
   echo "platform=$platform"
  
   
   # Decide if building rpm option was used (--rpm or --create-rpm)
   if [ "$use_rpm" = 1 ] ; then
     rm -rf RPMS/$sys/sqlite.OSS.*.rpm
     ./Build-RPM-krellroot sqlite-$sqlitever
     if [ -s RPMS/$sys/sqlite.OSS.*.rpm ]; then
         echo "SQLITE BUILT SUCCESSFULLY with rpm build option."
     else
         echo "SQLITE FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
         exit
     fi
     
     pushd RPMS/$sys
     rpm2cpio sqlite.OSS.*.rpm > sqlite.cpio
     cpio -id < sqlite.cpio
     cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
     export KRELL_ROOT_SQLITE=$KRELL_ROOT_PREFIX
     popd # Back out of RPMS

   else

     # sqlite
     cd $build_root_home
     mkdir -p BUILD
     mkdir -p BUILD/$sys
     rm -rf BUILD/$sys/sqlite-$sqlitever.tar.gz
     cp SOURCES/sqlite-$sqlitever.tar.gz BUILD/$sys/sqlite-$sqlitever.tar.gz
     #cd BUILD/$sys
     pushd BUILD/$sys
     rm -rf sqlite-$sqlitever
     tar -xzf sqlite-$sqlitever.tar.gz
     pushd sqlite-$sqlitever

     if [ -f ${build_root_home}/SOURCES/sqlite-$sqlitever.patch ]; then
        patch -p1 < ${build_root_home}/SOURCES/sqlite-$sqlitever.patch
     fi

     if [ -f ${build_root_home}/SOURCES/sqlite-$sqlitever.config.patch ]; then
        patch -p1 < ${build_root_home}/SOURCES/sqlite-$sqlitever.config.patch
     fi

     #cd sqlite-$sqlitever/src
  
    if [ "$KRELL_ROOT_TARGET_ARCH" == "bgl" ]; then
     if [ $KRELL_ROOT_TARGET_SHARED ]; then
       CFLAGS="-fPIC -dynamic" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --enable-threadsafe
       CFLAGS="-fPIC -dynamic" make
       CFLAGS="-fPIC -dynamic" make install
     else
       ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --enable-threadsafe
       make
     fi
    elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgp" ]; then
     if [ $KRELL_ROOT_TARGET_SHARED ]; then
       CFLAGS="-fPIC -dynamic" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --enable-threadsafe
       CFLAGS="-fPIC -dynamic" make
       CFLAGS="-fPIC -dynamic" make install
     else
       ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --enable-threadsafe
       make
     fi
    elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
     if [ $KRELL_ROOT_TARGET_SHARED ]; then
       CFLAGS="-fPIC -dynamic -m64" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR
       CFLAGS="-fPIC -dynamic -m64" make
       CFLAGS="-fPIC -dynamic -m64" make install
     else
       CFLAGS="-fPIC -dynamic -m64" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --disable-shared --enable-threadsafe
       CFLAGS="-fPIC -dynamic -m64" make
       CFLAGS="-fPIC -dynamic -m64" make install
     fi
   else
       # default fall through case
       if [ "$build_with_intel" = 1 ]; then
           CC="icc" CXX="icpc" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --enable-threadsafe
       else
           CC="gcc" CXX="g++" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --enable-threadsafe
       fi
       make 
       make install
   fi
  
     export KRELL_ROOT_SQLITE_ROOT=$KRELL_ROOT_PREFIX
     #cd ../../../..
     popd
     popd
   fi
}
  
function build_ompt_routine() {
     echo ""
     echo "Building ompt."
     echo ""
     echo "The script will use $KRELL_ROOT_PREFIX as installation directory."
     echo ""
  
     if [ $KRELL_ROOT_PREFIX ]; then
            echo "   "
   	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
            echo "   "
  	else
            echo "   "
            echo "    PROBLEM: The installation path environment variable: KRELL_ROOT_PREFIX"
            echo "             is not set.  "
            echo "   "
            echo "    PLEASE SET KRELL_ROOT_PREFIX and restart the install script.  Thanks."
            echo "   "
            exit
     fi
  
     echo 
     echo "Continue the build process for libiomp? <y/n>"
     echo
  
  #   read answer
     answer=Y
    
     if [ "$answer" = Y -o "$answer" = y ]; then
         echo
         echo "Continuing the libiomp build process."
         echo 
     else
         echo "   "
         exit
     fi
  
     if [ -z $LD_LIBRARY_PATH ]; then 
       if [ $KRELL_ROOT_PREFIX ]; then 
           export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
       fi
     else
       if [ $KRELL_ROOT_PREFIX ]; then 
           export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
       fi
     fi
  
     if [ -z $PATH ]; then 
       if [ $KRELL_ROOT_PREFIX ]; then 
           export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
       fi
     else
       if [ $KRELL_ROOT_PREFIX ]; then 
           export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
       fi
     fi
  
     os_vers=`uname -r`
     echo "os_vers=$os_vers"
     platform=`uname -i`
     echo "platform=$platform"
  
     # Runtime tool interface library for openmp: ompt
     cd $build_root_home
     mkdir -p BUILD
     mkdir -p BUILD/$sys
     rm -rf BUILD/$sys/libomp_${omptver}_oss.tgz
     cp SOURCES/libomp_${omptver}_oss.tgz BUILD/$sys/.
     pushd BUILD/$sys
     rm -rf libomp_oss
     tar -xzf libomp_${omptver}_oss.tgz
     pushd libomp_oss
     # Is this a special --build-ompt request, if so only use ${KRELL_ROOT_PREFIX}
     # as the CMAKE_INSTALL_PREFIX, otherwise add the ../ompt
     # 1 = special --build-ompt request
     # 0 = part of normal --build-krell-root
     if [ $1 == 1 ] ; then
         export OMPT_INSTALL_PATH=$KRELL_ROOT_PREFIX
     else
         export OMPT_INSTALL_PATH=$KRELL_ROOT_PREFIX/ompt
     fi

     if [ "$build_with_intel" = 1 ]; then
         cmake . \
             -DCMAKE_VERBOSE_MAKEFILE=ON \
             -DCMAKE_BUILD_TYPE=Release \
             -DCMAKE_CXX_FLAGS="-g -O2" \
             -DCMAKE_C_FLAGS="-g -O2" \
             -DCMAKE_INSTALL_PREFIX=${OMPT_INSTALL_PATH} \
             -DLIBOMP_OMP_VERSION=45 \
             -DLIBOMP_USE_DEBUGGER=false \
             -DCMAKE_C_COMPILER=icc \
             -DCMAKE_CXX_COMPILER=icpc \
             -DLIBOMP_OMPT_SUPPORT=on
     else
         cmake . \
             -DCMAKE_VERBOSE_MAKEFILE=ON \
             -DCMAKE_BUILD_TYPE=Release \
             -DCMAKE_CXX_FLAGS="-g -O2" \
             -DCMAKE_C_FLAGS="-g -O2" \
             -DCMAKE_INSTALL_PREFIX=${OMPT_INSTALL_PATH} \
             -DLIBOMP_OMP_VERSION=45 \
             -DLIBOMP_USE_DEBUGGER=false \
             -DCMAKE_C_COMPILER=gcc \
             -DCMAKE_CXX_COMPILER=g++ \
             -DLIBOMP_OMPT_SUPPORT=on
     fi
     make
     make install
  
     export KRELL_ROOT_OMPT_ROOT=$KRELL_ROOT_PREFIX/ompt
     popd
     popd
}
 
function build_llvm_openmp_routine() {
     echo ""
     echo "Building LLVM-opemmp."
     echo ""
     echo "The script will use $KRELL_ROOT_PREFIX as installation directory."
     echo ""
  
     if [ $KRELL_ROOT_PREFIX ]; then
            echo "   "
   	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
            echo "   "
  	else
            echo "   "
            echo "    PROBLEM: The installation path environment variable: KRELL_ROOT_PREFIX"
            echo "             is not set.  "
            echo "   "
            echo "    PLEASE SET KRELL_ROOT_PREFIX and restart the install script.  Thanks."
            echo "   "
            exit
     fi
  
     echo 
     echo "Continue the build process for LLVM-openmp? <y/n>"
     echo
  
  #   read answer
     answer=Y
    
     if [ "$answer" = Y -o "$answer" = y ]; then
         echo
         echo "Continuing the LLVM-openmp build process."
         echo 
     else
         echo "   "
         exit
     fi
  
     if [ -z $LD_LIBRARY_PATH ]; then 
       if [ $KRELL_ROOT_PREFIX ]; then 
           export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
       fi
     else
       if [ $KRELL_ROOT_PREFIX ]; then 
           export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
       fi
     fi
  
     if [ -z $PATH ]; then 
       if [ $KRELL_ROOT_PREFIX ]; then 
           export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
       fi
     else
       if [ $KRELL_ROOT_PREFIX ]; then 
           export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
       fi
     fi
  
     os_vers=`uname -r`
     echo "os_vers=$os_vers"
     platform=`uname -i`
     echo "platform=$platform"
  
     # Runtime tool interface library for openmp: LLVM-openmp
     cd $build_root_home
     mkdir -p BUILD
     mkdir -p BUILD/$sys
     rm -rf BUILD/$sys/LLVM-openmp-${llvm_openmpver}.tar.gz
     cp SOURCES/LLVM-openmp-${llvm_openmpver}.tar.gz BUILD/$sys/.
     pushd BUILD/$sys
     rm -rf LLVM-openmp
     tar -xzf LLVM-openmp-${llvm_openmpver}.tar.gz
     pushd LLVM-openmp
     # Is this a special --build-llvm-openmp request, if so only use ${KRELL_ROOT_PREFIX}
     # as the CMAKE_INSTALL_PREFIX, otherwise add the ../llvm-openmp
     # 1 = special --build-llvm-openmp request
     # 0 = part of normal --build-krell-root
     if [ $1 == 1 ] ; then
         export LLVM_OPENMP_INSTALL_PATH=$KRELL_ROOT_PREFIX
     else
         export LLVM_OPENMP_INSTALL_PATH=$KRELL_ROOT_PREFIX/ompt
     fi

     if [ "$build_with_intel" = 1 ]; then
         cmake . \
             -DCMAKE_VERBOSE_MAKEFILE=ON \
             -DCMAKE_BUILD_TYPE=Release \
             -DCMAKE_CXX_FLAGS="-g -O2" \
             -DCMAKE_C_FLAGS="-g -O2" \
             -DCMAKE_VERBOSE_MAKEFILE=ON \
             -DCMAKE_INSTALL_PREFIX=${LLVM_OPENMP_INSTALL_PATH} \
             -DLIBOMP_OMP_VERSION=50 \
             -DLIBOMP_USE_DEBUGGER=false \
             -DLIBOMP_STANDALONE_BUILD=true \
             -DCMAKE_C_COMPILER=icc \
             -DCMAKE_CXX_COMPILER=icpc \
             -DLIBOMP_OMPT_SUPPORT=on
     else
         cmake . \
             -DCMAKE_VERBOSE_MAKEFILE=ON \
             -DCMAKE_BUILD_TYPE=Release \
             -DCMAKE_CXX_FLAGS="-g -O2" \
             -DCMAKE_C_FLAGS="-g -O2" \
             -DCMAKE_VERBOSE_MAKEFILE=ON \
             -DCMAKE_INSTALL_PREFIX=${LLVM_OPENMP_INSTALL_PATH} \
             -DLIBOMP_OMP_VERSION=50 \
             -DLIBOMP_USE_DEBUGGER=false \
             -DLIBOMP_STANDALONE_BUILD=true \
             -DCMAKE_C_COMPILER=gcc \
             -DCMAKE_CXX_COMPILER=g++ \
             -DLIBOMP_OMPT_SUPPORT=on
     fi
     make
     make install
  
     export KRELL_ROOT_OMPT_ROOT=$KRELL_ROOT_PREFIX/ompt
     popd
     popd
}
 

function build_qt3_routine() { 
     echo ""
     echo "Building qt3."
     echo ""
     echo "The script will use $KRELL_ROOT_PREFIX as installation directory."
     echo ""
  
     if [ $KRELL_ROOT_PREFIX ]; then
            echo "   "
   	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
            echo "   "
  	else
            echo "   "
            echo "    PROBLEM: The installation path environment variable: KRELL_ROOT_PREFIX"
            echo "             is not set.  "
            echo "   "
            echo "    PLEASE SET KRELL_ROOT_PREFIX and restart the install script.  Thanks."
            echo "   "
            exit
     fi
  
     echo 
     echo "Continue the build process for qt3? <y/n>"
     echo
  
  #   read answer
     answer=Y
    
     if [ "$answer" = Y -o "$answer" = y ]; then
         echo
         echo "Continuing the qt3 build process."
         echo 
     else
         echo "   "
         exit
     fi
  
     if [ -z $LD_LIBRARY_PATH ]; then 
       if [ $KRELL_ROOT_PREFIX ]; then 
           export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
       fi
     else
       if [ $KRELL_ROOT_PREFIX ]; then 
           export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
       fi
     fi
  
     if [ -z $PATH ]; then 
       if [ $KRELL_ROOT_PREFIX ]; then 
           export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
       fi
     else
       if [ $KRELL_ROOT_PREFIX ]; then 
           export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
       fi
     fi
  
     os_vers=`uname -r`
     echo "os_vers=$os_vers"
     platform=`uname -i`
     echo "platform=$platform"
  
     # qt3
     cd $build_root_home
     mkdir -p BUILD
     mkdir -p BUILD/$sys
     rm -rf BUILD/$sys/qt-x11-free-$qtver.tar.gz
     rm -rf BUILD/$sys/qt-x11-free-$qtver.patch
     cp SOURCES/qt-x11-free-$qtver.tar.gz BUILD/$sys/qt-x11-free-$qtver.tar.gz
     if [ -f SOURCES/qt-x11-free-$qtver.patch ]; then
        cp SOURCES/qt-x11-free-$qtver.patch BUILD/$sys/qt-x11-free-$qtver.patch
     fi
     pushd BUILD/$sys
     rm -rf qt-x11-free-$qtver
     tar -xzf qt-x11-free-$qtver.tar.gz
     pushd qt-x11-free-$qtver
  
     if [ -f ../qt-x11-free-$qtver.patch ]; then
        patch -p1 < ../qt-x11-free-$qtver.patch
     fi
  
     set backup_QTDIR = $QTDIR
     set backup_PATH = $PATH
     set backup_LD_LIBRARY_PATH = $LD_LIBRARY_PATH
  
     export QTDIR=$PWD
     export PATH="$PWD/bin:$PATH"
     export LD_LIBRARY_PATH="$PWD/lib:$LD_LIBRARY_PATH"
  
     if [ $LIBDIR == "lib64" ]; then 
        echo "yes" | ./configure -thread -platform linux-g++-64 --prefix=$KRELL_ROOT_PREFIX/qt3 --libdir=$KRELL_ROOT_PREFIX/qt3/$LIBDIR --headerdir=$KRELL_ROOT_PREFIX/qt3/include
     else
        echo "yes" | ./configure -thread -platform linux-g++ --prefix=$KRELL_ROOT_PREFIX/qt3 --libdir=$KRELL_ROOT_PREFIX/qt3/$LIBDIR --headerdir=$KRELL_ROOT_PREFIX/qt3/include
     fi 
  
     make 
  
     mkdir -p $KRELL_ROOT_PREFIX/qt3
     mkdir -p $KRELL_ROOT_PREFIX/qt3/bin
     mkdir -p $KRELL_ROOT_PREFIX/qt3/include
     mkdir -p $KRELL_ROOT_PREFIX/qt3/etc
     mkdir -p $KRELL_ROOT_PREFIX/qt3/doc
     mkdir -p $KRELL_ROOT_PREFIX/qt3/$LIBDIR
     #make INSTALL_ROOT=$KRELL_ROOT_PREFIX/qt3 install
     make install
  
     export QTDIR $backup_QTDIR
     export PATH $backup_PATH
     export LD_LIBRARY_PATH $backup_LD_LIBRARY_PATH
  #
  # copy additional files
  #
     install -m 0755 bin/qmake bin/moc $KRELL_ROOT_PREFIX/qt3/bin/
     install -m 0755 -d $KRELL_ROOT_PREFIX/qt3/translations/
     install -m 0644 translations/*.qm $KRELL_ROOT_PREFIX/qt3/translations/
  #
  # default qt settings
  #
     mkdir -p $KRELL_ROOT_PREFIX/qt3/etc
     mkdir -p $KRELL_ROOT_PREFIX/qt3/etc/X11
  
     install -d -m 0755 $KRELL_ROOT_PREFIX/qt3/doc
     install -d -m 0755 $KRELL_ROOT_PREFIX/qt3/mkspecs/
  
     install -d -m 0755 $KRELL_ROOT_PREFIX/qt3/mkspecs/
     cp -a mkspecs/*    $KRELL_ROOT_PREFIX/qt3/mkspecs/
     install -m 0644 README* LICENSE* MANIFEST FAQ $KRELL_ROOT_PREFIX/qt3/doc
  #
  # create links in ld.so.conf path
  #
     install -d -m 0755 $KRELL_ROOT_PREFIX/qt3/$LIBDIR
     install -d -m 0755 $KRELL_ROOT_PREFIX/qt3/bin
  
     export KRELL_ROOT_QT3_ROOT=$KRELL_ROOT_PREFIX/qt3
     popd
     popd
}

function build_cbtf_argonavis_gui_routine() { 
     echo ""
     echo "Building cbtf_argonavis_gui qt gui"
     echo ""
     echo "The script will use $KRELL_ROOT_PREFIX as installation directory."
     echo ""
  
     if [ $KRELL_ROOT_PREFIX ]; then
            echo "   "
   	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
            echo "   "
  	else
            echo "   "
            echo "    PROBLEM: The installation path environment variable: KRELL_ROOT_PREFIX"
            echo "             is not set.  "
            echo "   "
            echo "    PLEASE SET KRELL_ROOT_PREFIX and restart the install script.  Thanks."
            echo "   "
            exit
     fi
  
     echo 
     echo "Continue the build process for cuda qtgui? <y/n>"
     echo
  
  #   read answer
     answer=Y
    
     if [ "$answer" = Y -o "$answer" = y ]; then
         echo
         echo "Continuing the cuda qtgui build process."
         echo 
     else
         echo "   "
         exit
     fi
  
     if [ -z $LD_LIBRARY_PATH ]; then 
       if [ $KRELL_ROOT_PREFIX ]; then 
           export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
       fi
     else
       if [ $KRELL_ROOT_PREFIX ]; then 
           export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
       fi
     fi
  
     if [ -z $PATH ]; then 
       if [ $KRELL_ROOT_PREFIX ]; then 
           export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
       fi
     else
       if [ $KRELL_ROOT_PREFIX ]; then 
           export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
       fi
     fi
  
     os_vers=`uname -r`
     echo "os_vers=$os_vers"
     platform=`uname -i`
     echo "platform=$platform"
  
     # qt3
     cd $build_root_home
     mkdir -p BUILD
     mkdir -p BUILD/$sys
     rm -rf BUILD/$sys/cbtf-argonavis-gui-$cbtfargoguiver.tar.gz
     rm -rf BUILD/$sys/cbtf-argonavis-gui-$cbtfargoguiver.patch
     cp SOURCES/cbtf-argonavis-gui-$cbtfargoguiver.tar.gz BUILD/$sys/cbtf-argonavis-gui-$cbtfargoguiver.tar.gz
     if [ -f SOURCES/cbtf-argonavis-gui-$cbtfargoguiver.patch ]; then
        cp SOURCES/cbtf-argonavis-gui-$cbtfargoguiver.patch BUILD/$sys/cbtf-argonavis-gui-$cbtfargoguiver.patch
     fi
     pushd BUILD/$sys
     rm -rf cbtf-argonavis-gui-$cbtfargoguiver
     tar -xzf cbtf-argonavis-gui-$cbtfargoguiver.tar.gz
     pushd cbtf-argonavis-gui
  
     if [ -f ../cbtf-argonavis-gui-$cbtfargoguiver.patch ]; then
        patch -p1 < ../cbtf-argonavis-gui-$cbtfargoguiver.patch
     fi
  
     set backup_QTDIR = $QTDIR
     set backup_PATH = $PATH
     set backup_LD_LIBRARY_PATH = $LD_LIBRARY_PATH
  
     export KRELL_ROOT=$KRELL_ROOT_PREFIX
     export KRELL_ROOT_MRNET=$KRELL_ROOT_PREFIX
     export KRELL_ROOT_XERCES=$KRELL_ROOT_PREFIX
     export CBTF_ROOT=$KRELL_ROOT_CBTF
     export CBTF_KRELL_ROOT=$KRELL_ROOT_CBTF
     export CBTF_ARGONAVIS_ROOT=$KRELL_ROOT_CBTF
     export OSS_CBTF_ROOT=$KRELL_ROOT_OPENSPEEDSHOP
     export INSTALL_PATH=$KRELL_ROOT_OPENSPEEDSHOP
     export BOOST_ROOT=$KRELL_ROOT_BOOST

     echo "cbtf-argonavis-gui build: KRELL_ROOT_QT=$KRELL_ROOT_QT"
     if [ ! -z $KRELL_ROOT_QT ]; then
         export QTDIR=$KRELL_ROOT_QT 
         echo "cbtf-argonavis-gui build: QTDIR=$KRELL_ROOT_QT"
     else
         if [ -f /usr/lib64/qt5/bin/qmake ]; then
             export QTDIR=/usr/lib64/qt5
         elif [ -f /usr/lib64/qt4/bin/qmake ]; then
             export QTDIR=/usr/lib64/qt4
         fi
     fi
         
     export GRAPHVIZ_ROOT=$KRELL_ROOT_GRAPHVIZ
     export QTGRAPHLIB_ROOT=$KRELL_ROOT_QTGRAPHLIB
     #export PATH="$PWD/bin:$PATH"
     #export LD_LIBRARY_PATH="$PWD/lib:$LD_LIBRARY_PATH"
     #export LD_LIBRARY_PATH="$PWD/build/release/.obj:$LD_LIBRARY_PATH"
  
     # this is required - w/o the make clean we get build errors

     ${QTDIR}/bin/qmake -o Makefile ./openss-gui.pro
     make clean
     make 
     make install

     #
     # copy the openss-gui executable over to the bin directory manually
     # until this is automated in the cbtf-argonavis-gui build infrastructure
     #
     if [ -e $PWD/build/release/openss-gui -a -d $OSS_CBTF_ROOT/bin ]; then
        chmod 755 $PWD/build/release/openss-gui
        cp $PWD/build/release/openss-gui $OSS_CBTF_ROOT/bin/openss-gui
     else
        echo "cbtf-argonavis-gui FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
        exit
     fi
  
     export QTDIR $backup_QTDIR
     export PATH $backup_PATH
     export LD_LIBRARY_PATH $backup_LD_LIBRARY_PATH

     popd
     popd
}
  
function build_mrnet_routine() { 
   echo ""
   echo "Building mrnet."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation directory."
   echo ""

   if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variable: KRELL_ROOT_PREFIX"
          echo "             is not set.  "
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX and restart the install script.  Thanks."
          echo "   "
          exit
   fi

   echo 
   echo "Continue the build process for mrnet? <y/n>"
   echo

#   read answer
   answer=Y
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the mrnet build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
     fi 
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   fi

   #os_vers=`uname -r`
   #echo "os_vers=$os_vers"
   #platform=`uname -i`
   #echo "platform=$platform"

   # mrnet
   echo "pwd 1 = $PWD"
   ls

   if [ "$use_rpm" = 1 ] ; then
     rm -rf RPMS/$sys/mrnet.OSS.*.rpm
     ./Build-RPM-krellroot mrnet-$mrnetver
     if [ -s RPMS/$sys/mrnet.OSS.*.rpm ]; then
        echo "MRNET BUILT SUCCESSFULLY with rpm build option."
     else
        echo "MRNET FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
        exit
     fi
     if [ -z $KRELL_ROOT_PREFIX ]; then
       export KRELL_ROOT_MRNET=/opt/KRELLROOT
     else
       export KRELL_ROOT_MRNET=$KRELL_ROOT_PREFIX
     fi
     pushd RPMS/$sys
     rpm2cpio mrnet.OSS.*.rpm > mrnet.cpio
     cpio -id < mrnet.cpio
     cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
     export KRELL_ROOT_MRNET=$KRELL_ROOT_PREFIX
     popd # Back out of RPMS
   else

     cd $build_root_home
     mkdir -p BUILD
     mkdir -p BUILD/$sys
     rm -rf BUILD/$sys/mrnet-$mrnetver.tar.gz
     cp SOURCES/mrnet-$mrnetver.tar.gz BUILD/$sys/mrnet-$mrnetver.tar.gz

     pushd BUILD/$sys
     rm -rf mrnet-$mrnetver
     tar -xzf mrnet-$mrnetver.tar.gz
     pushd mrnet-$mrnetver

     if [ -f ${build_root_home}/SOURCES/mrnet-$mrnetver.patch ]; then
        patch -p1 < ${build_root_home}/SOURCES/mrnet-$mrnetver.patch
     fi

     if [ -f ${build_root_home}/SOURCES/mrnet-$mrnetver.config.patch ]; then
        patch -p1 < ${build_root_home}/SOURCES/mrnet-$mrnetver.config.patch
     fi
  
     setup_for_oss_cbtf

     #echo "BUILDING MRNET, KRELL_ROOT_ALPS=$KRELL_ROOT_ALPS"
     #echo "BUILDING MRNET, KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
     #echo "BUILDING MRNET, SYSROOT_DIR=$SYSROOT_DIR"
     #echo "BUILDING MRNET, KRELL_ROOT_BOOST=$KRELL_ROOT_BOOST"
     #echo "BUILDING MRNET, pwd=`pwd`"
     #echo "BUILDING MRNET, LIBDIR=$LIBDIR"
  
     # Special processing if on a Cray FE
     # Expecting more special cases to be included in the future

     # on the new Cori machine NERSC this include is needed to find rli.h, otherwise the configure fails
     if (test -d /opt/cray/sysutils/default/include); then
        mrnet_include_clause="-I/opt/cray/sysutils/default/include"
     else
        mrnet_include_clause=""
     fi

     if (test -z $KRELL_ROOT_EXPAT_ROOT); then
        MRNET_WITH_EXPAT_CLAUSE=""
     else
        MRNET_WITH_EXPAT_CLAUSE="--with-expat=$KRELL_ROOT_EXPAT_ROOT"
     fi

     if (! test -z $KRELL_ROOT_ALPS); then
       # On a Cray FE with KRELL_ROOT_ALPS set
       # echo "BUILDING MRNET, On a Cray FE with KRELL_ROOT_ALPS set, KRELL_ROOT_ALPS=$KRELL_ROOT_ALPS"

        if ([ "$use_alps" = 1 ] && test -d $KRELL_ROOT_ALPS/$LIBDIR -a -e $KRELL_ROOT_ALPS/$LIBDIR/alps/libalps.so); then
            CXX="g++" CC="gcc" CXXFLAGS="${mrnet_include_clause} -O2 -g" ./configure --prefix=$KRELL_ROOT_PREFIX --enable-verbosebuild --enable-shared --with-boost=$KRELL_ROOT_BOOST --with-startup=cray --with-alpstoolhelp-inc=$KRELL_ROOT_ALPS/include --with-alpstoolhelp-lib=$KRELL_ROOT_ALPS/$LIBDIR/alps --with-alpstoolhelp-extra-libs=$KRELL_ROOT_ALPS/$LIBDIR/alps --enable-ltwt-threadsafe --libdir=$KRELL_ROOT_PREFIX/$LIBDIR $MRNET_WITH_EXPAT_CLAUSE
        elif ([ "$use_alps" = 1 ] && test -d $KRELL_ROOT_ALPS/$LIBDIR -a -e $KRELL_ROOT_ALPS/$LIBDIR/libalps.so); then
            CXX="g++" CC="gcc" CXXFLAGS="${mrnet_include_clause} -O2 -g" ./configure --prefix=$KRELL_ROOT_PREFIX --enable-verbosebuild --enable-shared --with-boost=$KRELL_ROOT_BOOST --with-startup=cray --with-alpstoolhelp-inc=$KRELL_ROOT_ALPS/include --with-alpstoolhelp-lib=$KRELL_ROOT_ALPS/$LIBDIR --with-alpstoolhelp-extra-libs=$KRELL_ROOT_ALPS/$LIBDIR --enable-ltwt-threadsafe --libdir=$KRELL_ROOT_PREFIX/$LIBDIR  $MRNET_WITH_EXPAT_CLAUSE
        elif ([ "$use_alps" = 1 ] && test -d $KRELL_ROOT_ALPS/lib  -a -e $KRELL_ROOT_ALPS/lib/alps/libalps.so ); then
            CXX="g++" CC="gcc" CXXFLAGS="${mrnet_include_clause} -O2 -g" ./configure --prefix=$KRELL_ROOT_PREFIX --enable-verbosebuild --enable-shared --with-boost=$KRELL_ROOT_BOOST --with-startup=cray --with-alpstoolhelp-inc=$KRELL_ROOT_ALPS/include --with-alpstoolhelp-lib=$KRELL_ROOT_ALPS/lib/alps --with-alpstoolhelp-extra-libs=$KRELL_ROOT_ALPS/lib/alps --enable-ltwt-threadsafe --libdir=$KRELL_ROOT_PREFIX/$LIBDIR  $MRNET_WITH_EXPAT_CLAUSE
        elif ([ "$use_alps" = 1 ] && test -d $KRELL_ROOT_ALPS/lib  -a -e $KRELL_ROOT_ALPS/lib/libalps.so ); then
            CXX="g++" CC="gcc" CXXFLAGS="${mrnet_include_clause} -O2 -g" ./configure --prefix=$KRELL_ROOT_PREFIX --enable-verbosebuild --enable-shared --with-boost=$KRELL_ROOT_BOOST --with-startup=cray --with-alpstoolhelp-inc=$KRELL_ROOT_ALPS/include --with-alpstoolhelp-lib=$KRELL_ROOT_ALPS/lib --with-alpstoolhelp-extra-libs=$KRELL_ROOT_ALPS/lib --enable-ltwt-threadsafe --libdir=$KRELL_ROOT_PREFIX/$LIBDIR  $MRNET_WITH_EXPAT_CLAUSE
        else
            echo "BUILDING MRNET, On a Cray FE with KRELL_ROOT_ALPS set, KRELL_ROOT_ALPS=$KRELL_ROOT_ALPS FAILURE, exiting"
        fi
  
     elif ( [ "$use_alps" = 1 ] &&  ! test -z $SYSROOT_DIR ); then
       # On a Cray FE with SYSROOT_DIR set
       # echo "BUILDING MRNET, On a Cray FE with SYSROOT_DIR set, SYSROOT_DIR=$SYSROOT_DIR"
        CXX="g++" CC="gcc" CXXFLAGS="${mrnet_include_clause} -O2 -g"  ./configure --prefix=$KRELL_ROOT_PREFIX --enable-verbosebuild --enable-shared --with-boost=$KRELL_ROOT_BOOST --with-startup=cray --with-alpstoolhelp-inc=$SYSROOT_DIR/usr/include --with-alpstoolhelp-lib=$SYSROOT_DIR/usr/lib/alps --with-alpstoolhelp-extra-libs=$SYSROOT_DIR/usr/$LIBDIR --enable-ltwt-threadsafe --libdir=$KRELL_ROOT_PREFIX/$LIBDIR  $MRNET_WITH_EXPAT_CLAUSE
  
     elif ([ "$use_alps" = 1 ] && test -d /usr/lib/alps); then
  
       # Also on a Cray FE but no SYSROOT_DIR set
       #echo "BUILDING MRNET, On a Cray FE with no SYSROOT_DIR set, SYSROOT_DIR=$SYSROOT_DIR"
       CXX="g++" CC="gcc"  CXXFLAGS="${mrnet_include_clause} -O2 -g" ./configure --prefix=$KRELL_ROOT_PREFIX --enable-verbosebuild --enable-shared --with-boost=$KRELL_ROOT_BOOST --with-startup=cray --with-alpstoolhelp-inc=/usr/include --with-alpstoolhelp-lib=/usr/lib/alps --enable-ltwt-threadsafe --libdir=$KRELL_ROOT_PREFIX/$LIBDIR  $MRNET_WITH_EXPAT_CLAUSE

     elif [ "$use_alps" = 0 -a "$KRELL_ROOT_TARGET_ARCH" == "cray" ]; then
       CXX="g++" CC="gcc"  CXXFLAGS="${mrnet_include_clause} -O2 -g" ./configure --prefix=$KRELL_ROOT_PREFIX --enable-verbosebuild --enable-shared --with-boost=$KRELL_ROOT_BOOST --with-startup=cray-cti  --enable-ltwt-threadsafe --libdir=$KRELL_ROOT_PREFIX/$LIBDIR  $MRNET_WITH_EXPAT_CLAUSE --with-craycti-lib=$KRELL_ROOT_CTI/lib --with-craycti-inc=$KRELL_ROOT_CTI/include

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
  
       ./configure --prefix=$KRELL_ROOT_PREFIX --enable-shared --enable-verbosebuild --with-boost=$KRELL_ROOT_BOOST --enable-ltwt-threadsafe --libdir=$KRELL_ROOT_PREFIX/$LIBDIR
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "arm" ]; then
       CXX="g++" CC="gcc" CFLAGS="-funwind-tables -fasynchronous-unwind-tables -g -O2 ${CFLAGS}" CXXFLAGS="-funwind-tables -fasynchronous-unwind-tables -g -O2 ${CXXFLAGS}"  ./configure --prefix=$KRELL_ROOT_PREFIX --enable-shared --enable-verbosebuild --with-boost=$KRELL_ROOT_BOOST --enable-ltwt-threadsafe --libdir=$KRELL_ROOT_PREFIX/$LIBDIR

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "power8" ]; then

       CXX="g++" CC="gcc" CFLAGS="-g -O2 ${CFLAGS}" CXXFLAGS="-g -O2 ${CXXFLAGS}"  ./configure --prefix=$KRELL_ROOT_PREFIX --enable-shared --enable-verbosebuild --with-boost=$KRELL_ROOT_BOOST --enable-ltwt-threadsafe --libdir=$KRELL_ROOT_PREFIX/$LIBDIR

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then

         if [ "$build_with_intel" = 1 ]; then
             export PATH=/usr/linux-k1om-4.7/bin:$PATH
             CXX="icpc" CC="icc" CFLAGS="-mmic -g -O2 ${CFLAGS}" CXXFLAGS="-mmic -g -O2 ${CXXFLAGS}" LDFLAGS="-mmic" ./configure --prefix=$KRELL_ROOT_PREFIX --enable-shared --enable-verbosebuild --with-boost=$KRELL_ROOT_BOOST --enable-ltwt-threadsafe --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --host=x86_64-k1om-linux
         else
             cc="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" ./configure --prefix=$KRELL_ROOT_PREFIX --enable-shared --enable-verbosebuild --with-boost=$KRELL_ROOT_BOOST --enable-ltwt-threadsafe --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --host=x86_64-k1om-linux
         fi
  
     elif [ `uname -m` = "ppc64" ]; then
  
           ./configure --prefix=$KRELL_ROOT_PREFIX --enable-shared --enable-verbosebuild --with-boost=$KRELL_ROOT_BOOST --enable-ltwt-threadsafe --libdir=$KRELL_ROOT_PREFIX/$LIBDIR CXX=g++ CC=gcc
  
     else
         # default fall through case
         if [ "$build_with_intel" = 1 ]; then
             CXX="icpc" CC="icc" ./configure --prefix=$KRELL_ROOT_PREFIX --enable-shared --enable-verbosebuild --with-boost=$KRELL_ROOT_BOOST --enable-ltwt-threadsafe --libdir=$KRELL_ROOT_PREFIX/$LIBDIR
         else
             CXX="g++" CC="gcc" ./configure --prefix=$KRELL_ROOT_PREFIX --enable-shared --enable-verbosebuild --with-boost=$KRELL_ROOT_BOOST --enable-ltwt-threadsafe --libdir=$KRELL_ROOT_PREFIX/$LIBDIR
  
         fi
     fi
  
     # NOTE - CHECK THIS OUT MIGHT BE WRONG NOW - FIXME JEG
     if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
        export PATH=/usr/linux-k1om-4.7/bin:$PATH
        cd build/x86_64-k1om-linux-gnu
        make xplat_lightweight-all ;
        make xplat_lightweight-sharedobj;
        make lightweight-all;
        make lightweight-sharedobj ;
        make xplat_lightweight-install;
        make lightweight-install
     else
        make; make install
     fi

     export KRELL_ROOT_MRNET=$KRELL_ROOT_PREFIX
     #cd ../../..
     popd
     popd
   fi
}



function build_libdwarf_routine() { 
   echo ""
   echo "Building libdwarf."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation unless KRELL_ROOT_LIBDWARF is set."
   echo "If KRELL_ROOT_PREFIX and KRELL_ROOT_LIBDWARF are both not set then the build script warns and halts."
   echo ""

   if [ -z $KRELL_ROOT_LIBDWARF ]; then 
        echo "   "
        echo "         KRELL_ROOT_LIBDWARF is NOT set."
        echo "   "
	if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          export KRELL_ROOT_LIBDWARF=$KRELL_ROOT_PREFIX
          echo "         Using KRELL_ROOT_LIBDWARF based on KRELL_ROOT_PREFIX, KRELL_ROOT_LIBDWARF=$KRELL_ROOT_LIBDWARF"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: KRELL_ROOT_PREFIX"
          echo "             and KRELL_ROOT_LIBDWARF are not set.  "
          echo "             If KRELL_ROOT_PREFIX is set then KRELL_ROOT_PREFIX will be used for"
          echo "             KRELL_ROOT_LIBDWARF."
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX OR KRELL_ROOT_LIBDWARF and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         KRELL_ROOT_LIBDWARF was set."
      echo "         Using KRELL_ROOT_LIBDWARF=$KRELL_ROOT_LIBDWARF"
      echo "   "
   fi

   echo 
   echo "Continue the build process for the libdwarf? <y/n>"
   echo

   if [ "$nanswer" = 9 -o $imode == 0 ]; then
        answer=Y
   else
        answer=Y
        #read answer
   fi
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the libdwarf build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_LIBDWARF ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_LIBDWARF/$LIBDIR
     fi
   else
     if [ $KRELL_ROOT_LIBDWARF ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_LIBDWARF/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_LIBDWARF ]; then 
         export PATH=$KRELL_ROOT_LIBDWARF/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_LIBDWARF ]; then 
         export PATH=$KRELL_ROOT_LIBDWARF/bin:$PATH
     fi
   fi

   echo "check libelf"
   if [ -f $KRELL_ROOT_LIBELF/$LIBDIR/libelf.so ]; then
       echo "KRELL_ROOT_LIBELF built libelf.so"
       set elfdir=$KRELL_ROOT_LIBELF
       set elflibdir=$KRELL_ROOT_LIBELF/$LIBDIR
       export elfdir=$KRELL_ROOT_LIBELF
       export elflibdir=$KRELL_ROOT_LIBELF/$LIBDIR
       echo "- libelf is KRELL_ROOT_LIBELF built case 1: prefix macro is $KRELL_ROOT_LIBELF"
   elif [ -f $KRELL_ROOT_LIBELF/$LIBDIR/libelf.a ]; then
       echo "KRELL_ROOT_LIBELF built libelf.a"
       set elfdir=$KRELL_ROOT_LIBELF
       set elflibdir=$KRELL_ROOT_LIBELF/$LIBDIR
       set elfliball=$KRELL_ROOT_LIBELF/$LIBDIR/libelf.a
       export elfdir=$KRELL_ROOT_LIBELF
       export elflibdir=$KRELL_ROOT_LIBELF/$LIBDIR
       echo "- libelf is KRELL_ROOT_LIBELF built case 1: prefix macro is $KRELL_ROOT_LIBELF"
   elif [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libelf.so ]; then
       echo "KRELLROOT built libelf"
       set elfdir=$KRELL_ROOT_PREFIX
       set elflibdir=$KRELL_ROOT_PREFIX/$LIBDIR
       export elfdir=$KRELL_ROOT_PREFIX
       export elflibdir=$KRELL_ROOT_PREFIX/$LIBDIR
       echo "- libelf is KRELLROOT built case 1: prefix macro is $KRELL_ROOT_PREFIX"
   elif [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libelf.a ]; then
       echo "KRELLROOT built libelf"
       set elfdir=$KRELL_ROOT_PREFIX
       set elflibdir=$KRELL_ROOT_PREFIX/$LIBDIR
       export elfdir=$KRELL_ROOT_PREFIX
       export elflibdir=$KRELL_ROOT_PREFIX/$LIBDIR
       echo "- libelf is KRELLROOT built case 2: prefix macro is $KRELL_ROOT_PREFIX"
   elif [ -f $KRELL_ROOT_PREFIX/$ALTLIBDIR/libelf.so ]; then
       echo "KRELLROOT built libelf"
       set elfdir=$KRELL_ROOT_PREFIX
       set elflibdir=$KRELL_ROOT_PREFIX/$ALTLIBDIR
       export elfdir=$KRELL_ROOT_PREFIX
       export elflibdir=$KRELL_ROOT_PREFIX/$ALTLIBDIR
       echo "- libelf is KRELLROOT built case 3: prefix macro is $KRELL_ROOT_PREFIX"
   elif [ -f $KRELL_ROOT_PREFIX/$ALTLIBDIR/libelf.a ]; then
       echo "KRELLROOT built libelf"
       set elfdir=$KRELL_ROOT_PREFIX
       set elflibdir=$KRELL_ROOT_PREFIX/$ALTLIBDIR
       export elfdir=$KRELL_ROOT_PREFIX
       export elflibdir=$KRELL_ROOT_PREFIX/$ALTLIBDIR
       echo "- libelf is KRELLROOT built case 4: prefix macro is $KRELL_ROOT_PREFIX"
   else
       set elfdir=/usr
       export elfdir=/usr
       echo "- libelf not KRELLROOT built: prefix macro is $elfdir"
   fi

   if [ -f $KRELL_ROOT_LIBELF/$LIBDIR/libelf.so ]; then
       echo "KRELL_ROOT_LIBELF built libelf"
       if [ -d $KRELL_ROOT_LIBELF/include/elfutils ]; then
           set elfincdir=$KRELL_ROOT_LIBELF/include
           export elfincdir=$KRELL_ROOT_LIBELF/include
           echo "- libelf include dir is KRELL_ROOT_LIBELF built: $KRELL_ROOT_LIBELF/include"
       else
           set elfincdir=$KRELL_ROOT_LIBELF/include
           export elfincdir=$KRELL_ROOT_LIBELF/include
           echo "- libelf include dir is KRELL_ROOT_LIBELF built: $KRELL_ROOT_LIBELF/include"
       fi
   elif [ -f $KRELL_ROOT_PREFIX/include/libelf.h ]; then
       echo "KRELLROOT built libelf"
       set elfincdir=$KRELL_ROOT_PREFIX/include
       export elfincdir=$KRELL_ROOT_PREFIX/include
       echo "- libelf include dir is KRELLROOT built: $KRELL_ROOT_PREFIX/include"
   elif [ -f /usr/include/libelf.h ]; then
       set elfincdir=/usr/include
       export elfincdir=/usr/include
       echo "- libelf include dir is from system: /usr/include"
   elif [ -f /usr/include/libelf/libelf.h ]; then
       set elfincdir=/usr/include/libelf
       export elfincdir=/usr/include/libelf
       echo "- libelf include dir is from system: /usr/include/libelf"
   fi

   # Decide if building rpm option was used (--rpm or --create-rpm)
   if [ "$use_rpm" = 1 ] ; then
     rm -rf RPMS/$sys/libdwarf.OSS.*.rpm
     ./Build-RPM-krellroot libdwarf-$libdwarfver
     if [ -s RPMS/$sys/libdwarf.OSS.*.rpm ]; then
         echo "LIBDWARF BUILT SUCCESSFULLY with rpm build option."
     else
         echo "LIBDWARF FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
         exit
     fi
     if [ $KRELL_ROOT_PREFIX ]; then
       export KRELL_ROOT_LIBDWARF=$KRELL_ROOT_PREFIX
     else
       export KRELL_ROOT_LIBDWARF=/opt/OSS
     fi
     pushd RPMS/$sys
     rpm2cpio libdwarf.OSS.*.rpm > libdwarf.cpio
     cpio -id < libdwarf.cpio
     cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
     export KRELL_ROOT_LIBDWARF=$KRELL_ROOT_PREFIX
     popd # Back out of RPMS

   else
     # libdwarf
     cd $build_root_home
     mkdir -p BUILD
     mkdir -p BUILD/$sys

     rm -rf BUILD/$sys/libdwarf-$libdwarfver.tar.gz
     cp SOURCES/libdwarf-$libdwarfver.tar.gz BUILD/$sys/libdwarf-$libdwarfver.tar.gz
     #cd BUILD/$sys
     pushd BUILD/$sys
     rm -rf libdwarf-$libdwarfver
     tar -xzf libdwarf-$libdwarfver.tar.gz

     pushd libdwarf-$libdwarfver

     # if a patch exists for this version, apply it, otherwise ignore
     if [ -f ${build_root_home}/SOURCES/libdwarf-$libdwarfver.patch ]; then
        patch -p1 < ${build_root_home}/SOURCES/libdwarf-$libdwarfver.patch
     fi

     ELFINCLUDE_PHRASE="-I${elfincdir}"

     cd libdwarf

     echo "IN LIBDWARF DIRECTORY ----------------- "
     echo "IN LIBDWARF DIRECTORY, CFLAGS=$CFLAGS, ELFINCLUDE_PHRASE=${ELFINCLUDE_PHRASE} ----------------- "

     if [ "$KRELL_ROOT_TARGET_ARCH" == "bgp" ]; then
         ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE}" --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/lib LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
        if [ $KRELL_ROOT_TARGET_SHARED ]; then
           ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE}" --enable-shared --enable-static --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/lib64 LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include
        else
           ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE}" --disable-shared --enable-static --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/lib64 LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include
        fi
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgl" ]; then
         ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE}" --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/lib LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "cray" ]; then
         ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE}" --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include --mandir=$KRELL_ROOT_PREFIX/share/man --host=x86_64

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then

         if [ "$build_with_intel" = 1 ]; then
             export PATH=/usr/linux-k1om-4.7/bin:$PATH
             cc="icc" CC="icc" CXX="icpc" ./configure CFLAGS="$CFLAGS -mmic -g -O2 -fPIC ${ELFINCLUDE_PHRASE}" --enable-shared --disable-nonshared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR LDFLAGS="-L$elflibdir -lelf -mmic" --includedir=$KRELL_ROOT_PREFIX/include --mandir=$KRELL_ROOT_PREFIX/share/man --host=x86_64-k1om-linux
         else
             CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" ./configure CFLAGS="$CFLAGS -g -O2 -fPIC ${ELFINCLUDE_PHRASE}" --enable-shared --disable-nonshared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include --mandir=$KRELL_ROOT_PREFIX/share/man --host=x86_64-k1om-linux
         fi


     elif [ "$KRELL_ROOT_TARGET_ARCH" == "arm" ]; then

         CC="gcc" CXX="g++" ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE} -funwind-tables -fasynchronous-unwind-tables -g -O2" --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include --mandir=$KRELL_ROOT_PREFIX/share/man

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "power8" ]; then

         CC="gcc" CXX="g++" ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE} -g -O2" --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include --mandir=$KRELL_ROOT_PREFIX/share/man



     else
        if [ `uname -m` = "ppc64" ]; then
         if [ $LIBDIR == "lib64" ]; then
            CFLAGS="-fPIC -g -O2 -m64" CXXFLAGS="-g -O2 -m64" LDFLAGS="-m64" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man LDFLAGS="-L$elflibdir -lelf" 
         else
            CFLAGS=-fPIC ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR \
       	        --mandir=$KRELL_ROOT_PREFIX/share/man LDFLAGS="-L$elflibdir -lelf" 
         fi
        else
            # default fall through case
            if [ "$build_with_intel" = 1 ]; then
                CC="icc" CXX="icpc" ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE}" --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include --mandir=$KRELL_ROOT_PREFIX/share/man
            else
                CC="gcc" CXX="g++" ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE} -g -O0 -I." --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include --mandir=$KRELL_ROOT_PREFIX/share/man
            fi
        fi
     fi

     make libdwarf.a
     cd ../dwarfdump
     if [ "$KRELL_ROOT_TARGET_ARCH" == "bgp" ]; then
         ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE}" --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/lib LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
        if [ $KRELL_ROOT_TARGET_SHARED ]; then
           ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE}" --enable-shared --enable-static --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/lib64 LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include
        else
           ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE}" --disable-shared --enable-static --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/lib64 LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include
        fi
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgl" ]; then
         ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE}" --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/lib LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "cray" ]; then
         ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE}" --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include --mandir=$KRELL_ROOT_PREFIX/share/man --host=x86_64

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then

         if [ "$build_with_intel" = 1 ]; then
             export PATH=/usr/linux-k1om-4.7/bin:$PATH
             cc="icc" CC="icc" CXX="icpc" LDFLAGS="-L$elflibdir -lelf -mmic" ./configure CFLAGS="$CFLAGS -mmic -O2 -g ${ELFINCLUDE_PHRASE}" --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR LDFLAGS="-L$elflibdir -lelf -mmic" --includedir=$KRELL_ROOT_PREFIX/include --mandir=$KRELL_ROOT_PREFIX/share/man --host=x86_64-k1om-linux 
         else
             CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" LDFLAGS="-L$elflibdir -lelf" ./configure CFLAGS="$CFLAGS -O2 -g ${ELFINCLUDE_PHRASE}" --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include --mandir=$KRELL_ROOT_PREFIX/share/man --host=x86_64-k1om-linux
         fi

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "arm" ]; then

         CC="gcc" CXX="g++" ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE} -funwind-tables -fasynchronous-unwind-tables -g -O2" --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include --mandir=$KRELL_ROOT_PREFIX/share/man

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "power8" ]; then

         CC="gcc" CXX="g++" ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE} -g -O2" --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include --mandir=$KRELL_ROOT_PREFIX/share/man

     else
        if [ `uname -m` = "ppc64" ]; then
         if [ $LIBDIR == "lib64" ]; then
            CFLAGS="-fPIC -g -m64" CXXFLAGS="-g -m64" LDFLAGS="-m64" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --mandir=$KRELL_ROOT_PREFIX/share/man LDFLAGS="-L$elflibdir -lelf" 
         else
            CFLAGS=-fPIC ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR \
    	        --mandir=$KRELL_ROOT_PREFIX/share/man LDFLAGS="-L$elflibdir -lelf" 
         fi
        else
            # default fall through case
            if [ "$build_with_intel" = 1 ]; then
                 CC="icc" CXX="icpc" ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE}" --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include --mandir=$KRELL_ROOT_PREFIX/share/man
            else
                 CC="gcc" CXX="g++" ./configure CFLAGS="$CFLAGS ${ELFINCLUDE_PHRASE}" --enable-shared --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR LDFLAGS="-L$elflibdir -lelf" --includedir=$KRELL_ROOT_PREFIX/include --mandir=$KRELL_ROOT_PREFIX/share/man
            fi
        fi
     fi
     make
     cd ../libdwarf
     make libdwarf.so

     install -D libdwarf.so $KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.so
     install -D libdwarf.a $KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.a
     install -D -m u+rw,go+r dwarf.h $KRELL_ROOT_PREFIX/include/dwarf.h
     install -D -m u+rw,go+r libdwarf.h $KRELL_ROOT_PREFIX/include/libdwarf.h

     cd ../dwarfdump
     install -D dwarfdump $KRELL_ROOT_PREFIX/dwarfdump
     install -D -m u+rw,go+r dwarfdump.1 $KRELL_ROOT_PREFIX/share/man/man1/dwarfdump.1
     popd
     popd
     export KRELL_ROOT_LIBDWARF=$KRELL_ROOT_PREFIX
   fi
}

function build_launchmon_routine() { 
   echo ""
   echo "Building launchmon."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation unless KRELL_ROOT_LAUNCHMON_ROOT is set."
   echo "If KRELL_ROOT_PREFIX and KRELL_ROOT_LAUNCHMON_ROOT are both not set then the build script warns and halts."
   echo ""

   if [ -z $KRELL_ROOT_LAUNCHMON_ROOT ]; then 
        echo "   "
        echo "         KRELL_ROOT_LAUNCHMON_ROOT is NOT set."
        echo "   "
	if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          export KRELL_ROOT_LAUNCHMON_ROOT=$KRELL_ROOT_PREFIX
          echo "         Using KRELL_ROOT_LAUNCHMON_ROOT based on KRELL_ROOT_PREFIX, KRELL_ROOT_LAUNCHMON_ROOT=$KRELL_ROOT_LAUNCHMON_ROOT"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: KRELL_ROOT_PREFIX"
          echo "             and KRELL_ROOT_LAUNCHMON_ROOT are not set.  "
          echo "             If KRELL_ROOT_PREFIX is set then KRELL_ROOT_PREFIX will be used for"
          echo "             KRELL_ROOT_LAUNCHMON_ROOT."
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX OR KRELL_ROOT_LAUNCHMON_ROOT and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         KRELL_ROOT_LAUNCHMON_ROOT was set."
      echo "         Using KRELL_ROOT_LAUNCHMON_ROOT=$KRELL_ROOT_LAUNCHMON_ROOT"
      echo "   "
   fi

   echo 
   echo "Continue the build process for the launchmon root? <y/n>"
   echo

   if [ "$nanswer" = 9 -o $imode == 0 ]; then
        answer=Y
   else
        read answer
   fi
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the launchmon build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_LAUNCHMON_ROOT ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_LAUNCHMON_ROOT/$LIBDIR
     fi
   else
     if [ $KRELL_ROOT_LAUNCHMON_ROOT ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_LAUNCHMON_ROOT/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_LAUNCHMON_ROOT ]; then 
         export PATH=$KRELL_ROOT_LAUNCHMON_ROOT/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_LAUNCHMON_ROOT ]; then 
         export PATH=$KRELL_ROOT_LAUNCHMON_ROOT/bin:$PATH
     fi
   fi

   # launchmon
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/launchmon-$launchmonver.tar.gz
   cp SOURCES/launchmon-$launchmonver/launchmon.tar.gz BUILD/$sys/launchmon-$launchmonver.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   rm -rf launchmon
   tar -xzf launchmon-$launchmonver.tar.gz
   pushd launchmon
   if [ -f $build_root_home/SOURCES/launchmon-$launchmonver.patch ]; then
      patch -p1 < $build_root_home/SOURCES/launchmon-$launchmonver.patch
   fi

#   LAUNCHMON_PATCH_LIST=`ls -1 ../../SOURCES/launchmon-$launchmonver/launchmon-*.patch`
#   echo $LAUNCHMON_PATCH_LIST
#   for i in $LAUNCHMON_PATCH_LIST; do
#      echo APPLYING \"$i\"
#      patch -p0 < $i
#   done

   #cd launchmon
   export USE="-nls"
   ./bootstrap
   if [ $KRELL_ROOT_MPI_OPENMPI ]; then

     CC="gcc" CXX="g++" ./configure --prefix=$KRELL_ROOT_PREFIX --with-rm=orte --with-rm-launcher=${KRELL_ROOT_MPI_OPENMPI}/bin/orterun --with-rm-inc=${KRELL_ROOT_MPI_OPENMPI}/include --with-rm-lib=${KRELL_ROOT_MPI_OPENMPI}/lib --enable-verbose 

   elif  [ $KRELL_ROOT_MPI_MVAPICH ]; then

      CC="gcc" CXX="g++" ./configure --prefix=$KRELL_ROOT_PREFIX --with-bootfabric=pmgr --with-rm=slurm

   fi

   make -j check
   make 
   make install
   #cd ../../..
   popd
   popd
}


function build_boost_routine() {
   echo ""
   echo "Building boost."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation unless KRELL_ROOT_BOOST is set."
   echo "If KRELL_ROOT_PREFIX and KRELL_ROOT_BOOST are both not set then the build script warns and halts."
   echo ""

   if [ -z $KRELL_ROOT_BOOST ]; then 
        echo "   "
        echo "         KRELL_ROOT_BOOST is NOT set."
        echo "   "
	if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          export KRELL_ROOT_BOOST=$KRELL_ROOT_PREFIX
          echo "         Using KRELL_ROOT_BOOST based on KRELL_ROOT_PREFIX, KRELL_ROOT_BOOST=$KRELL_ROOT_BOOST"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: KRELL_ROOT_PREFIX"
          echo "             and KRELL_ROOT_BOOST are not set.  "
          echo "             If KRELL_ROOT_PREFIX is set then KRELL_ROOT_PREFIX will be used for"
          echo "             KRELL_ROOT_BOOST."
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX OR KRELL_ROOT_BOOST and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         KRELL_ROOT_BOOST was set."
      echo "         Using KRELL_ROOT_BOOST=$KRELL_ROOT_BOOST"
      echo "   "
   fi

   echo 
   echo "Continue the build process for the boost root? <y/n>"
   echo
   if [ "$nanswer" = 9 -o $imode == 0 ]; then
        answer=Y
   else
        read answer
   fi
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the boost build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_BOOST ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_BOOST/$LIBDIR
     fi
   else
     if [ $KRELL_ROOT_BOOST ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_BOOST/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_BOOST ]; then 
         export PATH=$KRELL_ROOT_BOOST/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_BOOST ]; then 
         export PATH=$KRELL_ROOT_BOOST/bin:$PATH
     fi
   fi

   # boost
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/boost_$boostver.tar.gz
   rm -rf BUILD/$sys/boost_$boostver.patch
   rm -rf BUILD/$sys/boost_$boostver
   cp SOURCES/boost_$boostver.tar.gz BUILD/$sys/boost_$boostver.tar.gz

   if [ -f SOURCES/boost_$boostver.patch ]; then
      cp SOURCES/boost_$boostver.patch BUILD/$sys/boost_$boostver.patch
   fi
   echo "checking for ${build_root_home}/SOURCES/boost_$boostver.patch" 

   #cd BUILD/$sys
   pushd BUILD/$sys
   tar -xzf boost_$boostver.tar.gz
   #cd boost_$boostver
   pushd boost_$boostver
   if [ -f ${build_root_home}/SOURCES/boost_$boostver.patch ]; then
       echo "before applying ${build_root_home}/SOURCES/boost_$boostver.patch" 
       patch -p1 < ${build_root_home}/SOURCES/boost_$boostver.patch
       echo "after applying ${build_root_home}/SOURCES/boost_$boostver.patch" 
   fi
   if [ $1 == 1 ] ; then
       echo "Begin installing the boost includes in install directory: $KRELL_ROOT_BOOST/include/boost"
       cp -rf boost $KRELL_ROOT_BOOST/include/. 
       echo "End   installing the boost includes in install directory: $KRELL_ROOT_BOOST/include/boost"
       #cd ../../..
       popd
       popd
       return
   fi
    
   if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
       if [ "$build_with_intel" = 1 ]; then
          #echo "Begin building and installing the boost libraries (MIC) in install directory: $KRELL_ROOT_BOOST/lib with Intel"
          export PATH=/usr/linux-k1om-4.7/bin:$PATH
          export cc=icc
          export CC=icc
          export CXX=icpc
          ./bootstrap.sh --with-libraries=all toolset=intel threading=multi --disable-icu --without-iostreams cflags="-mmic" cxxflags="-mmic" linkflags="-mmic" 
          ./b2 --prefix=$KRELL_ROOT_BOOST --libdir=$KRELL_ROOT_BOOST/lib --includedir=$KRELL_ROOT_BOOST/include link=shared toolset=intel threading=multi --disable-icu --without-iostreams cflags="-mmic" cxxflags="-mmic" linkflags="-mmic" install
       else
           #echo "Begin building and installing the boost libraries (MIC) in install directory: $KRELL_ROOT_BOOST/lib with GCC"
           export PATH=/usr/linux-k1om-4.7/bin:$PATH
           export cc="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc"
           export CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc"
           export CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++"
           alias g++="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++"
           alias gcc="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc"
           #echo "Begin bootstrap.sh GCC"
           ./bootstrap.sh toolset=gcc --prefix=$KRELL_ROOT_BOOST --libdir=$KRELL_ROOT_BOOST/lib --includedir=$KRELL_ROOT_BOOST/include --without-libraries=iostreams
           #echo "Begin bjam GCC"
           ./bjam  toolset=gcc -j 6 --disable-icu
           #echo "Begin b2 GCC"
           ./b2 install toolset=gcc --prefix=$KRELL_ROOT_BOOST --libdir=$KRELL_ROOT_BOOST/lib --includedir=$KRELL_ROOT_BOOST/include
       fi
   else
       # default fall through case
       #echo "Begin building and installing the boost libraries (default path) in install directory: $KRELL_ROOT_BOOST/lib with GCC"
       if [ "$build_with_intel" = 1 ]; then
           #echo "Begin building and installing the boost libraries (default path-intel) in install directory: $KRELL_ROOT_BOOST/lib with Intel"
           export CC=icc
           export cc=icc
           export CXX=icpc
          ./bootstrap.sh toolset=intel --prefix=$KRELL_ROOT_BOOST --libdir=$KRELL_ROOT_BOOST/lib --includedir=$KRELL_ROOT_BOOST/include threading=multi --without-libraries=iostreams,context
          ./b2 --prefix=$KRELL_ROOT_BOOST --libdir=$KRELL_ROOT_BOOST/lib --includedir=$KRELL_ROOT_BOOST/include link=shared toolset=intel threading=multi install

       else
           #echo "Begin building and installing the boost libraries (default path-gnu) in install directory: $KRELL_ROOT_BOOST/lib with GCC"
           export CC=gcc
           export cc=gcc
           export CXX=g++
          ./bootstrap.sh --with-libraries=all
           #echo "After bootstrap.sh building and installing the boost libraries (default path-gnu) in install directory: $KRELL_ROOT_BOOST/lib with GCC"
          ./b2 --prefix=$KRELL_ROOT_BOOST --libdir=$KRELL_ROOT_BOOST/lib --includedir=$KRELL_ROOT_BOOST/include link=shared toolset=gcc threading=multi install 
       fi
   fi

   #cd ../../..
   export KRELL_ROOT_BOOST=$KRELL_ROOT_PREFIX
   popd
   popd
}

function build_dyninst_routine() {
   echo ""
   echo "Building dyninst."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation directory."
   echo ""

   if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variable: KRELL_ROOT_PREFIX"
          echo "             is not set.  "
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX and restart the install script.  Thanks."
          echo "   "
          exit
   fi

   echo 
   echo "Continue the build process for dyninst? <y/n>"
   echo

#   read answer
   answer=Y
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the dyninst build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   fi

   if [  ! -z $KRELL_ROOT_BOOST ] && [ -d $KRELL_ROOT_BOOST/include -a -f $KRELL_ROOT_BOOST/include/boost/shared_ptr.hpp ]; then
        #echo "KRELLROOT built boost"
        export DYNINST_BOOST_ROOT=$KRELL_ROOT_BOOST/include
        export BOOST_ROOT=$KRELL_ROOT_BOOST
   elif [ ! -z $KRELL_ROOT_BOOST ] && [ -f $KRELL_ROOT_BOOST/boost/shared_ptr.hpp ]; then
        #echo "KRELLROOT built boost"
        export DYNINST_BOOST_ROOT=$KRELL_ROOT_BOOST/include
        export BOOST_ROOT=$KRELL_ROOT_BOOST
   elif [ -d $KRELL_ROOT_PREFIX ] && [ -d $KRELL_ROOT_PREFIX/include -a -f $KRELL_ROOT_PREFIX/include/boost/shared_ptr.hpp ]; then
        #echo "KRELLROOT built boost"
        export DYNINST_BOOST_ROOT=$KRELL_ROOT_PREFIX/include
        export BOOST_ROOT=$KRELL_ROOT_PREFIX
   elif [ -d $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/boost/shared_ptr.hpp ]; then
        #echo "KRELLROOT built boost"
        export DYNINST_BOOST_ROOT=$KRELL_ROOT_PREFIX
        export BOOST_ROOT=$KRELL_ROOT_PREFIX/..
   elif [ -d /usr ] && [ -d /usr/include/boost -a -f /usr/include/boost/shared_ptr.hpp ]; then
        #echo "KRELLROOT built boost"
        export DYNINST_BOOST_ROOT=/usr/include
        export BOOST_ROOT=/usr/include
   elif [ -d /usr ] && [ -f /usr/boost/shared_ptr.hpp ]; then
        #echo "KRELLROOT built boost"
        export DYNINST_BOOST_ROOT=/usr
        export BOOST_ROOT=/usr/..
   else
        export DYNINST_BOOST_ROOT=
   fi



   #echo "check libelf"
   #echo "KRELL_ROOT_LIBELF=$KRELL_ROOT_LIBELF"
   #echo "KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"

   if [ ! -z $KRELL_ROOT_LIBELF ] && [ -f $KRELL_ROOT_LIBELF/$LIBDIR/libelf.so ]; then
        #echo "KRELL_ROOT_LIBELF found or user specified libelf found "
        export LIBELFDIR=$KRELL_ROOT_LIBELF
        export LIBELF_LIBNAME=$KRELL_ROOT_LIBELF/$LIBDIR/libelf.so
   elif [ ! -z $KRELL_ROOT_LIBELF ] && [ -f $KRELL_ROOT_LIBELF/$LIBDIR/libelf.a ]; then
        #echo "KRELL_ROOT_LIBELF found or user specified libelf found "
        export LIBELFDIR=$KRELL_ROOT_LIBELF
        export LIBELF_LIBNAME=$KRELL_ROOT_LIBELF/$LIBDIR/libelf.a
   elif [ ! -z $KRELL_ROOT_LIBELF ] && [ -f $KRELL_ROOT_LIBELF/$ALTLIBDIR/libelf.so ]; then
        #echo "KRELL_ROOT_LIBELF found "
        export LIBELFDIR=$KRELL_ROOT_LIBELF
        export LIBELF_LIBNAME=$KRELL_ROOT_LIBELF/$ALTLIBDIR/libelf.so
   elif [ ! -z $KRELL_ROOT_LIBELF ] && [ -f $KRELL_ROOT_LIBELF/$ALTLIBDIR/libelf.a ]; then
        #echo "KRELL_ROOT_LIBELF found "
        export LIBELFDIR=$KRELL_ROOT_LIBELF
        export LIBELF_LIBNAME=$KRELL_ROOT_LIBELF/$ALTLIBDIR/libelf.a
   elif [ ! -z $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libelf.so ]; then
        #echo "KRELL_ROOT_PREFIX libelf found"
        export LIBELFDIR=$KRELL_ROOT_PREFIX
        export LIBELF_LIBNAME=$KRELL_ROOT_PREFIX/$LIBDIR/libelf.so
   elif [ ! -z $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libelf.a ]; then
        #echo "KRELL_ROOT_PREFIX libelf found"
        export LIBELFDIR=$KRELL_ROOT_PREFIX
        export LIBELF_LIBNAME=$KRELL_ROOT_PREFIX/$LIBDIR/libelf.a
   elif [  ! -z $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$ALTLIBDIR/libelf.so ]; then
        #echo "KRELL_ROOT_PREFIX based libelf found "
        export LIBELFDIR=$KRELL_ROOT_LIBELF
        export LIBELF_LIBNAME=$KRELL_ROOT_PREFIX/$ALTLIBDIR/libelf.so
   elif [  ! -z $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$ALTLIBDIR/libelf.a ]; then
        #echo "KRELL_ROOT_PREFIX based libelf found "
        export LIBELFDIR=$KRELL_ROOT_LIBELF
        export LIBELF_LIBNAME=$KRELL_ROOT_PREFIX/$ALTLIBDIR/libelf.a
   elif [ -d $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libelf.so ]; then
        #echo "KRELLROOT built libelf"
        export LIBELFDIR=$KRELL_ROOT_PREFIX
        export LIBELF_LIBNAME=$KRELL_ROOT_PREFIX/$LIBDIR/libelf.so
   elif [ -d $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libelf.a ]; then
        #echo "KRELLROOT built libelf"
        export LIBELFDIR=$KRELL_ROOT_PREFIX
        export LIBELF_LIBNAME=$KRELL_ROOT_PREFIX/$LIBDIR/libelf.a
   else
        export LIBELFDIR=/usr
        export LIBELF_LIBNAME=/usr/$LIBDIR/libelf.so
   fi

   if [ -f $LIBELFDIR/include/libelf.h ]; then
        export LIBELFINC=$LIBELFDIR/include
   else
        export LIBELFINC=$LIBELFDIR/include/libelf
   fi

   #echo "LIBELFINC=$LIBELFINC"
   #echo "KRELL_ROOT_LIBDWARF=$KRELL_ROOT_LIBDWARF"
   #echo "KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"

   #echo "check libdwarf"
   # Find libdwarf libraries in elfutils for newer dyninst versions
   if [ $dyninstver == "20171003" ]; then
       if [ ! -z $KRELL_ROOT_LIBELF ] && [ -f $KRELL_ROOT_LIBELF/$LIBDIR/libdw.so ]; then
            export LIBDWARFDIR=$KRELL_ROOT_LIBELF
            export LIBDWARF_LIBNAME=$KRELL_ROOT_LIBELF/$LIBDIR/libdw.so
       elif [ ! -z $KRELL_ROOT_LIBELF ] && [ -f $KRELL_ROOT_LIBELF/$ALTLIBDIR/libdw.so ]; then
            export LIBDWARFDIR=$KRELL_ROOT_LIBELF
            export LIBDWARF_LIBNAME=$KRELL_ROOT_LIBELF/$ALTLIBDIR/libdw.so
       fi

   elif [ $dyninstver == "9.3.2" ]; then
       if [ ! -z $KRELL_ROOT_LIBDWARF ] && [ -f $KRELL_ROOT_LIBDWARF/$LIBDIR/libdwarf.so ]; then
            #echo "KRELL_ROOT_LIBDWARF built libdwarf or user specified libdwarf found"
            export LIBDWARFDIR=$KRELL_ROOT_LIBDWARF
            export LIBDWARF_LIBNAME=$KRELL_ROOT_LIBDWARF/$LIBDIR/libdwarf.so
       elif [ ! -z $KRELL_ROOT_LIBDWARF ] && [ -f $KRELL_ROOT_LIBDWARF/$LIBDIR/libdwarf.a ]; then
            #echo "KRELL_ROOT_LIBDWARF built libdwarf or user specified libdwarf found"
            export LIBDWARFDIR=$KRELL_ROOT_LIBDWARF
            export LIBDWARF_LIBNAME=$KRELL_ROOT_LIBDWARF/$LIBDIR/libdwarf.a
       elif [ ! -z $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.so ]; then
            #echo "KRELL_ROOT_PREFIX built libdwarf"
            export LIBDWARFDIR=$KRELL_ROOT_PREFIX
            export LIBDWARF_LIBNAME=$KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.so
       elif [ ! -z $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.a ]; then
            #echo "KRELL_ROOT_PREFIX built libdwarf"
            export LIBDWARFDIR=$KRELL_ROOT_PREFIX
            export LIBDWARF_LIBNAME=$KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.a
       elif [ -d $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.so ]; then
            #echo "root_prefix built libdwarf"
            export LIBDWARFDIR=$KRELL_ROOT_PREFIX
            export LIBDWARF_LIBNAME=$KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.so
       elif [ -d $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.a ]; then
            #echo "root_prefix built libdwarf"
            export LIBDWARFDIR=$KRELL_ROOT_PREFIX
            export LIBDWARF_LIBNAME=$KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.a
       else
            export LIBDWARFDIR=/usr/lib
            export LIBDWARF_LIBNAME=/usr/lib/libdwarf.so
       fi
    fi

   # Find libdwarf includes in elfutils for newer dyninst versions
   if [ $dyninstver == "20171003" ]; then
       export LIBDWARFINC=$KRELL_ROOT_LIBELF/include
   elif [ $dyninstver == "9.3.2" ]; then
       if [ ! -z $KRELL_ROOT_LIBDWARF ] && [ -f $KRELL_ROOT_LIBDWARF/include/libdwarf.h ]; then
            export LIBDWARFINC=$KRELL_ROOT_LIBDWARF/include
       elif [ ! -z $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/include/libdwarf.h ]; then
            export LIBDWARFINC=$KRELL_ROOT_PREFIX/include
       elif [ -d $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/include/libdwarf.h ]; then
            export LIBDWARFINC=$KRELL_ROOT_PREFIX/include
       fi
   fi

   #echo "KRELL_ROOT_BINUTILS=$KRELL_ROOT_BINUTILS"
   #echo "KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX" 

   #echo "check libiberty libdir"
   if [ ! -z $KRELL_ROOT_BINUTILS ] && [ -f $KRELL_ROOT_BINUTILS/$LIBDIR/libiberty_pic.a ]; then
        echo "KRELL_ROOT_BINUTILS built libiberty_pic"
        export LIBIBERTYLIBDIR=$KRELL_ROOT_BINUTILS/$LIBDIR
        export LIBIBERTY_LIBNAME=$KRELL_ROOT_BINUTILS/$LIBDIR/libiberty_pic.a
   elif [ ! -z $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libiberty_pic.a ]; then
        echo "KRELL_ROOT_PREFIX built libiberty_pic"
        export LIBIBERTYLIBDIR=$KRELL_ROOT_PREFIX/$LIBDIR
        export LIBIBERTY_LIBNAME=$KRELL_ROOT_PREFIX/$LIBDIR/libiberty_pic.a
   elif [ ! -z $KRELL_ROOT_BINUTILS ] && [ -f $KRELL_ROOT_BINUTILS/$LIBDIR/libiberty.a ]; then
        echo "KRELL_ROOT_BINUTILS built libiberty"
        export LIBIBERTYLIBDIR=$KRELL_ROOT_BINUTILS/$LIBDIR
        export LIBIBERTY_LIBNAME=$KRELL_ROOT_BINUTILS/$LIBDIR/libiberty.a
   elif [ ! -z $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libiberty.a ]; then
        echo "KRELL_ROOT_PREFIX built libiberty"
        export LIBIBERTYLIBDIR=$KRELL_ROOT_PREFIX/$LIBDIR
        export LIBIBERTY_LIBNAME=$KRELL_ROOT_PREFIX/$LIBDIR/libiberty.a
   elif [ -d $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libiberty_pic.a ]; then
        echo "KRELL_ROOT_PREFIX built libdir, libiberty_pic, KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
        export LIBIBERTYLIBDIR=$KRELL_ROOT_PREFIX/$LIBDIR
        export LIBIBERTY_LIBNAME=$KRELL_ROOT_PREFIX/$LIBDIR/libiberty_pic.a
   elif [ -d $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/lib/libiberty_pic.a ]; then
        echo "KRELL_ROOT_PREFIX built lib, libiberty_pic, KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
        export LIBIBERTYLIBDIR=$KRELL_ROOT_PREFIX/lib
        export LIBIBERTY_LIBNAME=$KRELL_ROOT_PREFIX/lib/libiberty_pic.a
   elif [ -f /usr/lib/libiberty_pic.a ]; then
        echo "found /usr/lib libiberty_pic, KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
        export LIBIBERTYLIBDIR=/usr/lib
        export LIBIBERTY_LIBNAME=/usr/lib/libiberty_pic.a
   elif [ -f /usr/lib64/libiberty_pic.a ]; then
        echo "found /usr/lib64 libiberty_pic, KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
        export LIBIBERTYLIBDIR=/usr/lib64
        export LIBIBERTY_LIBNAME=/usr/lib64/libiberty_pic.a
   elif [ ! -z $KRELL_ROOT_BINUTILS ] && [ -f $KRELL_ROOT_BINUTILS/$LIBDIR/libiberty_pic.a ]; then
        echo "KRELL_ROOT_BINUTILS built libiberty_pic"
        export LIBIBERTYLIBDIR=$KRELL_ROOT_BINUTILS/$LIBDIR
        export LIBIBERTY_LIBNAME=$KRELL_ROOT_BINUTILS/$LIBDIR/libiberty_pic.a
   elif [ ! -z $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libiberty.a ]; then
        echo "KRELL_ROOT_PREFIX built libiberty"
        export LIBIBERTYLIBDIR=$KRELL_ROOT_PREFIX/$LIBDIR
        export LIBIBERTY_LIBNAME=$KRELL_ROOT_PREFIX/$LIBDIR/libiberty.a
   elif [ -d $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libiberty_pic.a ]; then
        echo "KRELL_ROOT_PREFIX built libdir, libiberty_pic, KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
        export LIBIBERTYLIBDIR=$KRELL_ROOT_PREFIX/$LIBDIR
        export LIBIBERTY_LIBNAME=$KRELL_ROOT_PREFIX/$LIBDIR/libiberty_pic.a
   elif [ ! -z $KRELL_ROOT_BINUTILS ] && [ -f $KRELL_ROOT_BINUTILS/$LIBDIR/libiberty.a ]; then
        echo "KRELL_ROOT_BINUTILS built libiberty"
        export LIBIBERTYLIBDIR=$KRELL_ROOT_BINUTILS/$LIBDIR
        export LIBIBERTY_LIBNAME=$KRELL_ROOT_BINUTILS/$LIBDIR/libiberty.a
   elif [ ! -z $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libiberty.a ]; then
        echo "KRELL_ROOT_PREFIX built libiberty"
        export LIBIBERTYLIBDIR=$KRELL_ROOT_PREFIX
        export LIBIBERTY_LIBNAME=$KRELL_ROOT_PREFIX/$LIBDIR/libiberty.a
   elif [ -d $KRELL_ROOT_PREFIX ] && [ -f $KRELL_ROOT_PREFIX/lib/libiberty.a ]; then
        echo "KRELL_ROOT_PREFIX built lib, libiberty, KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
        export LIBIBERTYLIBDIR=$KRELL_ROOT_PREFIX/lib
        export LIBIBERTY_LIBNAME=$KRELL_ROOT_PREFIX/lib/libiberty.a
   elif [ -f /usr/lib/libiberty.a ]; then
        echo "found /usr/lib libiberty, KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
        export LIBIBERTYLIBDIR=/usr/lib
        export LIBIBERTY_LIBNAME=/usr/lib/libiberty.a
   elif [ -f /usr/lib64/libiberty.a ]; then
        echo "found /usr/lib64 libiberty, KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
        export LIBIBERTYLIBDIR=/usr/lib64
        export LIBIBERTY_LIBNAME=/usr/lib64/libiberty.a
   else
        export LIBIBERTYLIBDIR=/usr/$LIBDIR
        export LIBIBERTY_LIBNAME=/usr/$LIBDIR/libiberty.a
   fi

   if [ "$build_with_intel" = 1 ]; then
       export cc=icc
       export CXX=icpc
       export CC=icc
   else
       export cc=gcc
       export CXX=g++
       export CC=gcc
   fi

   cd $build_root_home
   # Decide if building rpm option was used (--rpm or --create-rpm)
   if [ "$use_rpm" = 1 ] ; then
     rm -rf RPMS/$sys/dyninst.OSS.*.rpm
     ./Build-RPM-krellroot dyninst-$dyninstver
     if [ -s RPMS/$sys/dyninst.OSS.*.rpm ]; then
         echo "DYNINST BUILT SUCCESSFULLY with rpm build option."
     else
         echo "DYNINST FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors.  sys=$sys"
         exit
     fi
     pushd RPMS/$sys
     rpm2cpio dyninst.OSS.*.rpm > dyninst.cpio
     cpio -id < dyninst.cpio
     cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
     export KRELL_ROOT_DYNINST=$KRELL_ROOT_PREFIX
     popd # Back out of RPMS

   else

     cd $build_root_home
     mkdir -p BUILD
     mkdir -p BUILD/$sys
     rm -rf BUILD/$sys/dyninst-$dyninstver.tar.gz
     rm -rf BUILD/$sys/dyninst-$dyninstver
     cp SOURCES/dyninst-$dyninstver.tar.gz BUILD/$sys/dyninst-$dyninstver.tar.gz
     cp SOURCES/dyninst-$dyninstver.patch BUILD/$sys/dyninst-$dyninstver.patch
     #cd BUILD/$sys
     pushd BUILD/$sys
  
     rm -rf dyninst-$dyninstver
     tar -xzf dyninst-$dyninstver.tar.gz
  
     pushd dyninst-$dyninstver
  
     echo "checking for ${build_root_home}/SOURCES/dyninst-$dyninstver.patch" 
     if [ -f ${build_root_home}/SOURCES/dyninst-$dyninstver.patch ]; then
        echo "before applying ${build_root_home}/SOURCES/dyninst-$dyninstver.patch" 
        patch -p1 < ${build_root_home}/SOURCES/dyninst-$dyninstver.patch
        echo "after applying ${build_root_home}/SOURCES/dyninst-$dyninstver.patch" 
     fi
  
     # Set DYNINST_ROOT to the location of the Dyninst source tree
     export DYNINST_ROOT=`pwd`/dyninst-$dyninstver
  
     #echo "DYNINST_ROOT" %{DYNINST_ROOT} 
     #export DYNINST_ROOT=%{DYNINST_ROOT}
  
     #cd src/dyninst
  
  
     if [ "$KRELL_ROOT_TARGET_ARCH" == "bgp" ]; then
    
       CXXFLAGS="-std=c++0x" ./configure --prefix=$KRELL_ROOT_PREFIX --with-libelf-incdir=$LIBELFINC --with-libelf-libdir=$LIBELFDIR/$LIBDIR --with-libdwarf-incdir=$LIBDWARFDIR/include --with-libdwarf-libdir=$LIBDWARFDIR/$LIBDIR --with-libiberty-libdir=$LIBIBERTYLIBDIR --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include/dyninst --with-boost=$DYNINST_BOOST_ROOT --disable-testsuite 
    
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then

       cmake . -DCMAKE_INSTALL_PREFIX=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -DINSTALL_LIB_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/$LIBDIR -DINSTALL_INCLUDE_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/include/dyninst -DCMAKE_PREFIX_PATH=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLIBDWARF_LIBRARIES=$LIBDWARF_LIBNAME -DLIBDWARF_INCLUDE_DIR=$LIBDWARFINC -DLIBELF_LIBRARIES=$LIBELF_LIBNAME -DLIBELF_INCLUDE_DIR=$LIBELFINC -DPATH_BOOST=$DYNINST_BOOST_ROOT -DIBERTY_LIBRARIES=$LIBIBERTY_LIBNAME -DIBERTY_LIBRARY=$LIBIBERTY_LIBNAME
    
       #CXXFLAGS="-std=c++0x" ./configure --prefix=$KRELL_ROOT_PREFIX --with-libelf-incdir=$LIBELFINC --with-libelf-libdir=$LIBELFDIR/$LIBDIR --with-libdwarf-incdir=$LIBDWARFDIR/include --with-libdwarf-libdir=$LIBDWARFDIR/$LIBDIR --with-libiberty-libdir=$LIBIBERTYLIBDIR --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include/dyninst --with-boost=$DYNINST_BOOST_ROOT --disable-testsuite "CC=g++" "cc=gcc"
    
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "cray" ]; then

       cmake . -DCMAKE_INSTALL_PREFIX=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -DINSTALL_LIB_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/$LIBDIR -DINSTALL_INCLUDE_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/include/dyninst -DCMAKE_PREFIX_PATH=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLIBDWARF_LIBRARIES=$LIBDWARF_LIBNAME -DLIBDWARF_INCLUDE_DIR=$LIBDWARFINC -DLIBELF_LIBRARIES=$LIBELF_LIBNAME -DLIBELF_INCLUDE_DIR=$LIBELFINC -DPATH_BOOST=$DYNINST_BOOST_ROOT -DIBERTY_LIBRARIES=$LIBIBERTY_LIBNAME -DIBERTY_LIBRARY=$LIBIBERTY_LIBNAME

       #cmake -DCMAKE_TOOLCHAIN_FILE=$build_root_home/Cray-gnu-toolchain.cmake . -DCMAKE_INSTALL_PREFIX=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -DINSTALL_LIB_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/$LIBDIR -DINSTALL_INCLUDE_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/include/dyninst -DCMAKE_PREFIX_PATH=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLIBDWARF_LIBRARIES=$LIBDWARF_LIBNAME -DLIBDWARF_INCLUDE_DIR=$LIBDWARFINC -DLIBELF_LIBRARIES=$LIBELF_LIBNAME -DLIBELF_INCLUDE_DIR=$LIBELFINC -DPATH_BOOST=$DYNINST_BOOST_ROOT -DIBERTY_LIBRARIES=$LIBIBERTY_LIBNAME -DIBERTY_LIBRARY=$LIBIBERTY_LIBNAME

       #cmake -DCMAKE_TOOLCHAIN_FILE=$build_root_home/Cray-gnu-toolchain.cmake . -DCMAKE_INSTALL_PREFIX=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -DINSTALL_LIB_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/$LIBDIR -DINSTALL_INCLUDE_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/include/dyninst -DCMAKE_PREFIX_PATH=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLIBDWARF_LIBRARIES=$LIBDWARF_LIBNAME -DLIBDWARF_INCLUDE_DIR=$LIBDWARFINC -DLIBELF_LIBRARIES=$LIBELF_LIBNAME -DLIBELF_INCLUDE_DIR=$LIBELFINC -DPATH_BOOST=$DYNINST_BOOST_ROOT -DIBERTY_LIBRARIES=$LIBIBERTY_LIBNAME -DIBERTY_LIBRARY=$LIBIBERTY_LIBNAME -DBUILD_RTLIB_32=OFF -DCHECK_RTLIB_32=OFF -Dos_linux -Darch_x86_64 -Darch_64bit -Dos_linux -Dx86_64_unknown_linux2_4

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then

        if [ "$build_with_intel" = 1 ]; then
            export cc=icc
            export CXX=icpc
            export CC=icc
            export PATH=/usr/linux-k1om-4.7/bin:$PATH
            cmake .  -DCMAKE_INSTALL_PREFIX=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -DINSTALL_LIB_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/$LIBDIR -DINSTALL_INCLUDE_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/include/dyninst -DCMAKE_PREFIX_PATH=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -DCROSS_COMPILING=1 -DCMAKE_BUILD_TYPE=None -DCMAKE_CXX_FLAGS="-mmic -g -O2 " -DCMAKE_C_FLAGS="-mmic -g -O2" -DLIBDWARF_LIBRARIES=$LIBDWARF_LIBNAME -DLIBDWARF_INCLUDE_DIR=$LIBDWARFINC -DLIBELF_LIBRARIES=$LIBELF_LIBNAME -DLIBELF_INCLUDE_DIR=$LIBELFINC -DPATH_BOOST=$DYNINST_BOOST_ROOT -DIBERTY_LIBRARIES=$LIBIBERTY_LIBNAME -DIBERTY_LIBRARY=$LIBIBERTY_LIBNAME
        else
            export cc="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc"
            export CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc"
            export CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++"
            cmake .  -DCMAKE_INSTALL_PREFIX=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -DINSTALL_LIB_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/$LIBDIR -DINSTALL_INCLUDE_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/include/dyninst -DCMAKE_PREFIX_PATH=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -DCROSS_COMPILING=1 -DCMAKE_BUILD_TYPE=None -DCMAKE_CXX_FLAGS="-g -O2 " -DCMAKE_C_FLAGS="-g -O2" -DLIBDWARF_LIBRARIES=$LIBDWARF_LIBNAME -DLIBDWARF_INCLUDE_DIR=$LIBDWARFINC -DLIBELF_LIBRARIES=$LIBELF_LIBNAME -DLIBELF_INCLUDE_DIR=$LIBELFINC -DPATH_BOOST=$DYNINST_BOOST_ROOT -DIBERTY_LIBRARIES=$LIBIBERTY_LIBNAME -DIBERTY_LIBRARY=$LIBIBERTY_LIBNAME
        fi
 
     else
    
       #echo "platform=$platform"
       #echo "PLATFORM=$PLATFORM"

       # default fall through case
       #echo "Building dyninst - DEFAULT case."
       if [ "$build_with_intel" = 1 ]; then
           #echo "Building dyninst - DEFAULT case - with Intel."
           export cc=icc
           export CXX=icpc
           export CC=icc
       else
           #echo "Building dyninst - DEFAULT case - with GNU."
           export cc=gcc
           export CXX=g++
           export CC=gcc
       fi
       #cmake . -DCMAKE_INSTALL_PREFIX=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -Dcap_dwarf=1 -DCMAKE_CXX_FLAGS="-dcap_dwarf -std=c++11 -g -O2" -DCMAKE_C_FLAGS="-dcap_dwarf -std=c++11 -g -O2"  -DINSTALL_LIB_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/$LIBDIR -DINSTALL_INCLUDE_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/include/dyninst -DCMAKE_PREFIX_PATH=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLIBDWARF_LIBRARIES=$LIBDWARF_LIBNAME -DLIBDWARF_INCLUDE_DIR=$LIBDWARFINC -DLIBELF_LIBRARIES=$LIBELF_LIBNAME -DLIBELF_INCLUDE_DIR=$LIBELFINC -DPATH_BOOST=$DYNINST_BOOST_ROOT -DIBERTY_LIBRARIES=$LIBIBERTY_LIBNAME -DIBERTY_LIBRARY=$LIBIBERTY_LIBNAME -DBUILD_RTLIB_32=OFF -DCHECK_RTLIB_32=OFF
       cmake . -DCMAKE_INSTALL_PREFIX=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -Dcap_dwarf=1  -DINSTALL_LIB_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/$LIBDIR -DINSTALL_INCLUDE_DIR=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX/include/dyninst -DCMAKE_PREFIX_PATH=$RPM_BUILD_ROOT/$KRELL_ROOT_PREFIX -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLIBDWARF_LIBRARIES=$LIBDWARF_LIBNAME -DLIBDWARF_INCLUDE_DIR=$LIBDWARFINC -DLIBELF_LIBRARIES=$LIBELF_LIBNAME -DLIBELF_INCLUDE_DIR=$LIBELFINC -DPATH_BOOST=$DYNINST_BOOST_ROOT -DIBERTY_LIBRARIES=$LIBIBERTY_LIBNAME -DIBERTY_LIBRARY=$LIBIBERTY_LIBNAME -DBUILD_RTLIB_32=OFF -DCHECK_RTLIB_32=OFF
    
     fi
    
# JEG - commented out the manual setting of platform that used to be required (Sept 30, 2015)
     # Set PLATFORM according to the build platform
#     echo "platform=$platform"
#     if [ "$platform" == "ppc64" ]; then
#       if [ -e /bgsys/drivers/ppcfloor/../ppc ]; then
#        export PLATFORM=ppc32_linux
#       elif [ -e /bgsys/drivers/ppcfloor/../ppc64 ]; then
#        export PLATFORM=ppc64_linux
#       else
#        export PLATFORM=ppc64_linux
#       fi
#     elif [ "$platform" == "ppc32" ] || [ "$platform" == "ppc" ] ; then
#        export PLATFORM=ppc32_linux
#     elif [ "$platform" == "x86_64" ]; then
#        export PLATFORM=x86_64-unknown-linux2.4
#     elif [ "$platform" == "ia64" ]; then
#        export PLATFORM=ia64-unknown-linux2.4
#     else
#        export PLATFORM=i386-unknown-linux2.4
#     fi
  
     make SKIP_BUILD_RTLIB_32=1 
     make SKIP_BUILD_RTLIB_32=1 install
     export KRELL_ROOT_DYNINST=$KRELL_ROOT_PREFIX
  
     popd
     popd
   fi
}

function build_symtabapi_routine() { 
   echo ""
   echo "Building symtabapi."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation directory."
   echo ""

   if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variable: KRELL_ROOT_PREFIX"
          echo "             is not set.  "
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX and restart the install script.  Thanks."
          echo "   "
          exit
   fi

   echo 
   echo "Continue the build process for symtabapi? <y/n>"
   echo

#   read answer
   answer=Y
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the symtabapi build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   fi

   if [ -d $KRELL_ROOT_BOOST/include -a -f $KRELL_ROOT_BOOST/include/boost/shared_ptr.hpp ]; then
        echo "KRELLROOT built boost"
        export DYNINST_BOOST_ROOT=$KRELL_ROOT_BOOST/include
   elif [ -f $KRELL_ROOT_BOOST/boost/shared_ptr.hpp ]; then
        echo "KRELLROOT built boost"
        export DYNINST_BOOST_ROOT=$KRELL_ROOT_BOOST
   elif [ -d $KRELL_ROOT_PREFIX/include -a -f $KRELL_ROOT_PREFIX/include/boost/shared_ptr.hpp ]; then
        echo "KRELLROOT built boost"
        export DYNINST_BOOST_ROOT=$KRELL_ROOT_PREFIX/include
   elif [ -f $KRELL_ROOT_PREFIX/boost/shared_ptr.hpp ]; then
        echo "KRELLROOT built boost"
        export DYNINST_BOOST_ROOT=$KRELL_ROOT_PREFIX
   else
        export DYNINST_BOOST_ROOT=/usr
   fi


   if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libelf.so ]; then
        echo "krellroot built libelf"
        export LIBELFDIR=$KRELL_ROOT_PREFIX
else
        export LIBELFDIR=/usr
fi

if [ -f $LIBELFDIR/include/libelf.h ]; then
        export LIBELFINC=$LIBELFDIR/include
else
        export LIBELFINC=$LIBELFDIR/include/libelf
fi

echo "check libdwarf"
if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.so ]; then
        echo "krellroot built libdwarf"
        export LIBDWARFDIR=$KRELL_ROOT_PREFIX
else
        export LIBDWARFDIR=/usr
fi
echo "check libunwind"
if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libunwind.so ]; then
        echo "krellroot built libunwind"
        export LIBUNWINDDIR=$KRELL_ROOT_PREFIX
else
        export LIBUNWINDDIR=/usr
fi

echo "check libiberty libdir"
if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libiberty.a ]; then
        echo "krellroot built LIBDIR libiberty"
        export LIBIBERTYLIBDIR=$KRELL_ROOT_PREFIX/$LIBDIR
elif [ -f $KRELL_ROOT_PREFIX/lib/libiberty.a ]; then
        echo "krellroot built lib libiberty"
        export LIBIBERTYLIBDIR=$KRELL_ROOT_PREFIX/lib
elif [ -f /usr/lib/libiberty.a ]; then
        echo "/usr lib libiberty"
        export LIBIBERTYLIBDIR=/usr/lib
elif [ -f /usr/lib64/libiberty.a ]; then
        echo "/usr lib64 libiberty"
        export LIBIBERTYLIBDIR=/usr/lib64
else
        echo "no libiberty found"
        export LIBIBERTYLIBDIR=""
fi

   #os_vers=`uname -r`
   #echo "os_vers=$os_vers"
   platform=`uname -i`
   echo "platform=$platform"

   # symtabapi
   export CBTF_DYNINST_VERS=$symtabapiver
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/symtabapi-$symtabapiver.tar.gz
   cp SOURCES/symtabapi-$symtabapiver.tar.gz BUILD/$sys/symtabapi-$symtabapiver.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   rm -rf symtabapi-$symtabapiver
   tar -xzf symtabapi-$symtabapiver.tar.gz

   pushd symtabapi-$symtabapiver

   # Apply the patches. The "%patch" command isn't used so that we can keep the
   # DYNINST patches in a directory seaparate from the RPM SOURCES directory.
   if [ -f ${build_root_home}/SOURCES/symtabapi-$symtabapiver.patch ]; then
      patch -p1 < ${build_root_home}/SOURCES/symtabapi-$symtabapiver.patch
   fi

# Set PLATFORM according to the build platform
#   echo "platform=$platform"
#   if [ "$platform" == "ppc64" ]; then
#     if [ -e /bgsys/drivers/ppcfloor/../ppc ]; then
#      export PLATFORM=ppc32_linux
#     elif [ -e /bgsys/drivers/ppcfloor/../ppc64 ]; then
#      export PLATFORM=ppc64_linux
#     else
#      export PLATFORM=ppc64_linux
#     fi
#   elif [ "$platform" == "ppc32" ] || [ "$platform" == "ppc" ] ; then
#      export PLATFORM=ppc32_linux
#   elif [ "$platform" == "x86_64" ]; then
#      export PLATFORM=x86_64-unknown-linux2.4
#   elif [ "$platform" == "ia64" ]; then
#      export PLATFORM=ia64-unknown-linux2.4
#   else
#      export PLATFORM=i386-unknown-linux2.4
#   fi

   CXXFLAGS="-std=c++0x" ./configure --prefix=$KRELL_ROOT_PREFIX --with-libelf-incdir=$LIBELFINC --with-libelf-libdir=$LIBELFDIR/$LIBDIR --with-libdwarf-incdir=$LIBDWARFDIR/include --with-libdwarf-libdir=$LIBDWARFDIR/$LIBDIR --with-libunwind-incdir=$LIBUNWINDDIR/include --with-libunwind-libdir=$LIBUNWINDDIR/$LIBDIR --with-libiberty-libdir=$LIBIBERTYLIBDIR --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --includedir=$KRELL_ROOT_PREFIX/include/dyninst --with-boost=$DYNINST_BOOST_ROOT

   make SKIP_BUILD_RTLIB_32=1 DESTDIR=$KRELL_ROOT_PREFIX symtabAPI
   make SKIP_BUILD_RTLIB_32=1 install
   export KRELL_ROOT_DYNINST=$KRELL_ROOT_PREFIX
   #cd ../../..
   popd
   popd
}

function build_binutils_routine() { 
   echo ""
   echo "Building binutils."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation directory."
   echo ""

   if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variable: KRELL_ROOT_PREFIX"
          echo "             is not set.  "
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX and restart the install script.  Thanks."
          echo "   "
          exit
   fi

   echo 
   echo "Continue the build process for binutils? <y/n>"
   echo

#   read answer
   answer=Y
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the binutils build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   fi

   #os_vers=`uname -r`
   #echo "os_vers=$os_vers"
   #platform=`uname -i`
   #echo "platform=$platform"

   if [ "$use_rpm" = 1 ] ; then
     rm -rf RPMS/$sys/binutils.OSS.*.rpm
     ./Build-RPM-krellroot binutils-$binutilsver
     if [ -s RPMS/$sys/binutils.OSS.*.rpm ]; then
         echo "BINUTILS BUILT SUCCESSFULLY with rpm build option."
         export KRELL_ROOT_BINUTILS=$KRELL_ROOT_PREFIX
     else
         echo "BINUTILS FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
         exit
     fi
     pushd RPMS/$sys
     rpm2cpio binutils.OSS.*.rpm > binutils.cpio
     cpio -id < binutils.cpio
     cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
     export KRELL_ROOT_BINUTILS=$KRELL_ROOT_PREFIX
     popd # Back out of RPMS
   else
     # binutils
     cd $build_root_home
     mkdir -p BUILD
     if [ "$tsys" == "" ]; then
         echo "binutils, tsys should be null"
         mkdir -p BUILD/$sys
         rm -rf BUILD/$sys/binutils-$binutilsver.tar.gz BUILD/$sys/binutils-$binutilsver
         cp SOURCES/binutils-$binutilsver.tar.gz BUILD/$sys/binutils-$binutilsver.tar.gz
         pushd BUILD/$sys
     else
         echo "binutils, tsys should NOT be null"
         mkdir -p BUILD/$sys/$tsys
         rm -rf BUILD/$sys/$tsys/binutils-$binutilsver.tar.gz BUILD/$sys/$tsys/binutils-$binutilsver
         cp SOURCES/binutils-$binutilsver.tar.gz BUILD/$sys/$tsys/binutils-$binutilsver.tar.gz
         pushd BUILD/$sys/$tsys
     fi

     rm -rf binutils-$binutilsver
     tar -xzf binutils-$binutilsver.tar.gz
     pushd binutils-$binutilsver

     if [ -f ${build_root_home}/SOURCES/binutils-$binutilsver.patch ]; then
       patch -p1 < ${build_root_home}/SOURCES/binutils-$binutilsver.patch
     fi

     if [ -f ${build_root_home}/SOURCES/binutils-$binutilsver.config.patch ]; then
       patch -p1 < ${build_root_home}/SOURCES/binutils-$binutilsver.config.patch
     fi

     BINUTILS_INSTALL_PATH=$KRELL_ROOT_PREFIX/binutils
  
     if [ "$KRELL_ROOT_TARGET_ARCH" == "bgp" ]; then
      if [ $KRELL_ROOT_TARGET_SHARED ]; then
        CFLAGS="-fPIC -dynamic" ./configure --prefix=$BINUTILS_INSTALL_PATH --libdir=$BINUTILS_INSTALL_PATH/$LIBDIR --includedir=$BINUTILS_INSTALL_PATH/include --mandir=$BINUTILS_INSTALL_PATH/share/man  --build=ppc64 --enable-shared --enable-install-libiberty --disable-multilib
      else
        CFLAGS=-fPIC ./configure --prefix=$BINUTILS_INSTALL_PATH --libdir=$BINUTILS_INSTALL_PATH/$LIBDIR --includedir=$BINUTILS_INSTALL_PATH/include --mandir=$BINUTILS_INSTALL_PATH/share/man  --build=ppc64 --disable-shared --enable-install-libiberty --disable-multilib
      fi
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
      if [ $KRELL_ROOT_TARGET_SHARED ]; then
        CFLAGS="-fPIC -dynamic" ./configure --prefix=$BINUTILS_INSTALL_PATH --libdir=$BINUTILS_INSTALL_PATH/$LIBDIR --includedir=$BINUTILS_INSTALL_PATH/include --mandir=$BINUTILS_INSTALL_PATH/share/man  --build=ppc64 --enable-shared --enable-install-libiberty --disable-multilib --enable-ld=no --disable-ld
      else
        CFLAGS=-fPIC ./configure --prefix=$BINUTILS_INSTALL_PATH --libdir=$BINUTILS_INSTALL_PATH/$LIBDIR --includedir=$BINUTILS_INSTALL_PATH/include --mandir=$BINUTILS_INSTALL_PATH/share/man  --disable-shared --enable-static --enable-install-libiberty --disable-multilib --enable-ld=no --disable-ld
      fi
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "cray" ]; then
      if [ $KRELL_ROOT_TARGET_SHARED ]; then
        ./configure --prefix=$BINUTILS_INSTALL_PATH --libdir=$BINUTILS_INSTALL_PATH/$LIBDIR --includedir=$BINUTILS_INSTALL_PATH/include --mandir=$BINUTILS_INSTALL_PATH/share/man --enable-shared --enable-install-libiberty --disable-multilib --with-ar=/usr/bin/ar --with-strip=/usr/bin/strip --enable-ld=no --disable-ld
      else
        ./configure --prefix=$BINUTILS_INSTALL_PATH --libdir=$BINUTILS_INSTALL_PATH/$LIBDIR --includedir=$BINUTILS_INSTALL_PATH/include --mandir=$BINUTILS_INSTALL_PATH/share/man  --disable-shared --enable-static --enable-install-libiberty --disable-multilib --enable-ld=no --disable-ld --with-ar=/usr/bin/ar --with-strip=/usr/bin/strip
      fi

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then

        echo "BINUTILS BUILD for INTEL MIC."
        if [ "$build_with_intel" = 1 ]; then
            export PATH=/usr/linux-k1om-4.7/bin:$PATH
            CC="icc" CXX="icpc" cc="icc" CFLAGS="-O2 -fPIC -g -mmic" CXXFLAGS="-O2 -fPIC -g -mmic"  ./configure --prefix=$BINUTILS_INSTALL_PATH --libdir=$BINUTILS_INSTALL_PATH/$LIBDIR --includedir=$BINUTILS_INSTALL_PATH/include --bindir=$BINUTILS_INSTALL_PATH/bin-notused --mandir=$BINUTILS_INSTALL_PATH/share/man  --enable-shared --enable-install-libiberty --disable-multilib --enable-ld=no --disable-ld --host=x86_64-k1om-linux --with-ar=/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-ar --with-strip=/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-strip
        else
            CC="x86_64-k1om-linux-gcc" CXX="x86_64-k1om-linux-g++" ./configure --prefix=$BINUTILS_INSTALL_PATH --libdir=$BINUTILS_INSTALL_PATH/$LIBDIR --includedir=$BINUTILS_INSTALL_PATH/include --mandir=$BINUTILS_INSTALL_PATH/share/man  --enable-shared --enable-install-libiberty --disable-multilib --enable-ld=no --disable-ld --with-ar=/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-ar --with-strip=/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-strip --host=x86_64-k1om-linux
        fi


     elif [ "$KRELL_ROOT_TARGET_ARCH" == "arm" ]; then

         CC="gcc" CXX="g++" CFLAGS="-funwind-tables -fasynchronous-unwind-tables -g -O2 ${CFLAGS}" ./configure --prefix=$BINUTILS_INSTALL_PATH --libdir=$BINUTILS_INSTALL_PATH/$LIBDIR --includedir=$BINUTILS_INSTALL_PATH/include --mandir=$BINUTILS_INSTALL_PATH/share/man  --enable-shared --enable-install-libiberty --disable-multilib --enable-ld=no --disable-ld

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "power8" ]; then

         CC="gcc" CXX="g++" CFLAGS="-g -O2 ${CFLAGS}" ./configure --prefix=$BINUTILS_INSTALL_PATH --libdir=$BINUTILS_INSTALL_PATH/$LIBDIR --includedir=$BINUTILS_INSTALL_PATH/include --mandir=$BINUTILS_INSTALL_PATH/share/man  --enable-shared --enable-install-libiberty --disable-multilib --enable-ld=no --disable-ld

     else
        # default fall through - cluster/laptop case
        if [ "$build_with_intel" = 1 ]; then
           CC="icc" CXX="icpc" ./configure --prefix=$BINUTILS_INSTALL_PATH --libdir=$BINUTILS_INSTALL_PATH/$LIBDIR --includedir=$BINUTILS_INSTALL_PATH/include --mandir=$BINUTILS_INSTALL_PATH/share/man  --enable-shared --enable-install-libiberty --disable-multilib --enable-ld=no --disable-ld --build=x86_64-linux-gnu --host=x86_64-linux-gnu
        else
           #CC="gcc" CXX="g++" ./configure --prefix=$BINUTILS_INSTALL_PATH --libdir=$BINUTILS_INSTALL_PATH/$LIBDIR --includedir=$BINUTILS_INSTALL_PATH/include --mandir=$BINUTILS_INSTALL_PATH/share/man  --enable-shared --enable-install-libiberty --disable-multilib --enable-ld=no --disable-ld --build=x86_64-linux-gnu --host=x86_64-linux-gnu
           CC="gcc" CXX="g++" CFLAGS="-g -O2 -fPIC" ./configure --prefix=$BINUTILS_INSTALL_PATH --libdir=$BINUTILS_INSTALL_PATH/$LIBDIR --includedir=$BINUTILS_INSTALL_PATH/include --mandir=$BINUTILS_INSTALL_PATH/share/man  --enable-shared --enable-install-libiberty --disable-multilib --enable-ld=no --disable-ld
        fi
     fi
  
  
     if [ "$KRELL_ROOT_TARGET_ARCH" == "bgp" ]; then
       if [ $KRELL_ROOT_TARGET_SHARED ]; then
         export CXFLAGS=${CXFLAGS:-fPIC -dynamic}
         make CFLAGS="-fPIC -dynamic"
         make CFLAGS="-fPIC -dynamic" install
         make CFLAGS="-fPIC -dynamic" install-libiberty
       else
         export CXFLAGS=${CXFLAGS:-fPIC}
         make CFLAGS="-fPIC"
         make CFLAGS="-fPIC" install
         make CFLAGS="-fPIC" install-libiberty
       fi
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
       if [ $KRELL_ROOT_TARGET_SHARED ]; then
         export CXFLAGS=${CXFLAGS:-fPIC -dynamic}
         make CFLAGS="-fPIC -dynamic"
         make CFLAGS="-fPIC -dynamic" install
         make CFLAGS="-fPIC -dynamic" install-libiberty
       else
         export CXFLAGS=${CXFLAGS:-fPIC}
         make CFLAGS="-fPIC"
         make CFLAGS="-fPIC" install
         make CFLAGS="-fPIC" install-libiberty
       fi
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "cray" ]; then
       if [ $KRELL_ROOT_TARGET_SHARED ]; then
         export CXFLAGS=${CXFLAGS:-fPIC -dynamic}
         make 
         make install
         make install-libiberty
       else
         make 
         make install
         make install-libiberty
       fi
     else
       make 
       make install
       make install-libiberty
     fi
     
     cp include/*.h $BINUTILS_INSTALL_PATH/include/.
     export KRELL_ROOT_BINUTILS=$BINUTILS_INSTALL_PATH
     popd
     popd
   fi
}

function build_libelf_routine() { 
   echo ""
   echo "Building libelf."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation directory."
   echo ""

   if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variable: KRELL_ROOT_PREFIX"
          echo "             is not set.  "
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX and restart the install script.  Thanks."
          echo "   "
          exit
   fi

   echo 
   echo "Continue the build process for libelf? <y/n>"
   echo

   answer=Y
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the libelf build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   fi

   # Decide if building rpm option was used (--rpm or --create-rpm)
   if [ "$use_rpm" = 1 ] ; then
     rm -rf RPMS/$sys/libelf.OSS.*.rpm
     ./Build-RPM-krellroot libelf-$libelfver
     if [ -s RPMS/$sys/libelf.OSS.*.rpm ]; then
         echo "LIBELF BUILT SUCCESSFULLY with rpm build option."
     else
         echo "LIBELF FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
         exit
     fi
     if [ $KRELL_ROOT_PREFIX ]; then
       export KRELL_ROOT_LIBELF=$KRELL_ROOT_PREFIX
     else
       export KRELL_ROOT_LIBELF=/opt/OSS
     fi
     pushd RPMS/$sys
     rpm2cpio libelf.OSS.*.rpm > libelf.cpio
     cpio -id < libelf.cpio
     cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
     export KRELL_ROOT_LIBELF=$KRELL_ROOT_PREFIX
     popd # Back out of RPMS
   else
     #os_vers=`uname -r`
     #echo "os_vers=$os_vers"
     #platform=`uname -i`
     #echo "platform=$platform"
  
     # libelf
     pwd
     cd $build_root_home
     mkdir -p BUILD
     if [ "$tsys" == "" ]; then
         mkdir -p BUILD/$sys
         rm -rf BUILD/$sys/libelf-$libelfver.tar.gz BUILD/$sys/libelf-$libelfver
         cp SOURCES/libelf-$libelfver.tar.gz BUILD/$sys/libelf-$libelfver.tar.gz
         pushd BUILD/$sys
     else
         mkdir -p BUILD/$sys/$tsys
         rm -rf BUILD/$sys/$tsys/libelf-$libelfver.tar.gz BUILD/$sys/$tsys/libelf-$libelfver
         cp SOURCES/libelf-$libelfver.tar.gz BUILD/$sys/$tsys/libelf-$libelfver.tar.gz
         pushd BUILD/$sys/$tsys
     fi
     tar -xzf libelf-$libelfver.tar.gz
     pushd libelf-$libelfver

     if [ -f ${build_root_home}/SOURCES/libelf-$libelfver.patch ]; then
        patch -p1 < ${build_root_home}/SOURCES/libelf-$libelfver.patch
     fi

     if [ -f ${build_root_home}/SOURCES/libelf-$libelfver.config.patch ]; then
        patch -p1 < ${build_root_home}/SOURCES/libelf-$libelfver.config.patch
     fi

     if [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
       if [ $KRELL_ROOT_TARGET_SHARED ]; then
         ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/lib --enable-shared --enable-static
       else
         ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/lib --disable-shared --enable-static
       fi
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgl" -o "$KRELL_ROOT_TARGET_ARCH" == "bgp" ]; then
         ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/lib

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then

         if [ "$build_with_intel" = 1 ]; then
             export PATH=/usr/linux-k1om-4.7/bin:$PATH
             CC="icc" CXX="icpc" cc="icc" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --datadir=$KRELL_ROOT_PREFIX/share --enable-compat --enable-shared --host=x86_64-k1om-linux --enable-elf64=yes --build=x86_64-unknown-linux-gnu
         else
             cc="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CXX="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-g++" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --datadir=$KRELL_ROOT_PREFIX/share  --host=x86_64-k1om-linux
         fi

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "arm" ]; then

         CC="gcc" CXX="g++" CFLAGS="-funwind-tables -fasynchronous-unwind-tables -g ${CFLAGS}" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --datadir=$KRELL_ROOT_PREFIX/share --enable-compat --enable-shared

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "power8" ]; then

         CC="gcc" CXX="g++" CFLAGS="-g ${CFLAGS}" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --datadir=$KRELL_ROOT_PREFIX/share --enable-compat --enable-shared

     else
        if [ "$build_with_intel" = 1 ]; then
         CC="icc" CXX="icpc" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --datadir=$KRELL_ROOT_PREFIX/share --enable-compat --enable-shared
        else
         CC="gcc" CXX="g++" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --datadir=$KRELL_ROOT_PREFIX/share --enable-compat --enable-shared
        fi
     fi

     make; make install
     #cp libelf-$libelfver/lib/gelf.h $KRELL_ROOT_PREFIX/include/gelf.h
     #cp libelf-$libelfver/lib/libelf.h $KRELL_ROOT_PREFIX/include/libelf.h
     #cp libelf-$libelfver/lib/nlist.h $KRELL_ROOT_PREFIX/include/nlist.h

     export KRELL_ROOT_LIBELF=$KRELL_ROOT_PREFIX
     popd
     popd
   fi
}

function build_elfutils_routine() { 
   echo ""
   echo "Building elfutils."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation directory."
   echo ""

   if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variable: KRELL_ROOT_PREFIX"
          echo "             is not set.  "
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX and restart the install script.  Thanks."
          echo "   "
          exit
   fi

   echo 
   echo "Continue the build process for elfutils? <y/n>"
   echo

   answer=Y
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the elfutils build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   fi

   # setup the autotools or cmake arguments used below
   setup_for_oss_cbtf

   # Decide if building rpm option was used (--rpm or --create-rpm)
   if [ "$use_rpm" = 1 ] ; then
     rm -rf RPMS/$sys/elfutils.OSS.*.rpm
     ./Build-RPM-krellroot elfutils-$elfutilsver
     if [ -s RPMS/$sys/elfutils.OSS.*.rpm ]; then
         echo "ELFUTILS BUILT SUCCESSFULLY with rpm build option."
     else
         echo "ELFUTILS FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
         exit
     fi
     if [ $KRELL_ROOT_PREFIX ]; then
       export KRELL_ROOT_ELFUTILS=$KRELL_ROOT_PREFIX
     else
       export KRELL_ROOT_ELFUTILS=/opt/OSS
     fi
     pushd RPMS/$sys
     rpm2cpio elfutils.OSS.*.rpm > elfutils.cpio
     cpio -id < elfutils.cpio
     cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
     export KRELL_ROOT_ELFUTILS=$KRELL_ROOT_PREFIX
     popd # Back out of RPMS
   else
     #os_vers=`uname -r`
     #echo "os_vers=$os_vers"
     #platform=`uname -i`
     #echo "platform=$platform"
  
     # elfutils
     pwd
     cd $build_root_home
     mkdir -p BUILD
     mkdir -p BUILD/$sys
     rm -rf BUILD/$sys/elfutils-$elfutilsver.tar.gz BUILD/$sys/elfutils-$elfutilsver
     cp SOURCES/elfutils-$elfutilsver.tar.gz BUILD/$sys/elfutils-$elfutilsver.tar.gz
     pushd BUILD/$sys
     tar -xzf elfutils-$elfutilsver.tar.gz
     pushd elfutils-$elfutilsver

     if [ -f ${build_root_home}/SOURCES/elfutils-$elfutilsver.patch ]; then
        patch -p1 < ${build_root_home}/SOURCES/elfutils-$elfutilsver.patch
     fi

     if [ -f ${build_root_home}/SOURCES/elfutils-$elfutilsver.config.patch ]; then
        patch -p1 < ${build_root_home}/SOURCES/elfutils-$elfutilsver.config.patch
     fi
   
     if [ "$found_libz" = 1 ]; then
         ZLIB_INCLUDE=""
         ZLIB_LIBS=""
     else
         ZLIB_INCLUDE="CPPFLAGS=-I${KRELL_ROOT_ZLIB}/include"
         ZLIB_LIBS="LDFLAGS=-L${KRELL_ROOT_ZLIB}/$LIBDIR"
     fi

     if [ "$KRELL_ROOT_TARGET_ARCH" == "bgq" ]; then
       if [ $KRELL_ROOT_TARGET_SHARED ]; then
         ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/lib CC="gcc" CFLAGS="-g -O2" ${ZLIB_INCLUDE} ${ZLIB_LIBS}
       else
         ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/lib CC="gcc" CFLAGS="-g -O2" ${ZLIB_INCLUDE} ${ZLIB_LIBS}
       fi
     elif [ "$KRELL_ROOT_TARGET_ARCH" == "bgl" -o "$KRELL_ROOT_TARGET_ARCH" == "bgp" ]; then
         ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/lib CC="gcc" CFLAGS="-g -O2" ${ZLIB_INCLUDE} ${ZLIB_LIBS}

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then

         if [ "$build_with_intel" = 1 ]; then
             export PATH=/usr/linux-k1om-4.7/bin:$PATH
             ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --datadir=$KRELL_ROOT_PREFIX/share --host=x86_64-k1om-linux --enable-elf64=yes --build=x86_64-unknown-linux-gnu CC="icc" CFLAGS="-g -O2" ${ZLIB_INCLUDE} ${ZLIB_LIBS}
         else
             ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --datadir=$KRELL_ROOT_PREFIX/share  --host=x86_64-k1om-linux CC="/usr/linux-k1om-4.7/bin/x86_64-k1om-linux-gcc" CFLAGS="-g -O2" ${ZLIB_INCLUDE} ${ZLIB_LIBS}
         fi

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "arm" ]; then

         ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --datadir=$KRELL_ROOT_PREFIX/share CC="gcc" CFLAGS="-funwind-tables -fasynchronous-unwind-tables -g -O2" ${ZLIB_INCLUDE} ${ZLIB_LIBS}

     elif [ "$KRELL_ROOT_TARGET_ARCH" == "power8" ]; then

         ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --datadir=$KRELL_ROOT_PREFIX/share CC="gcc" CFLAGS="-g -O2" ${ZLIB_INCLUDE} ${ZLIB_LIBS}

     else
        if [ "$build_with_intel" = 1 ]; then
         ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR CC="gcc" CFLAGS="-g -O2" ${ZLIB_INCLUDE} ${ZLIB_LIBS}
         # BUG WITH INTEL CC="icc" CFLAGS="-g -O2" ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR --datadir=$KRELL_ROOT_PREFIX/share --enable-compat --enable-shared  ${ZLIB_INCLUDE} ${ZLIB_LIBS}
        else
         ./configure --prefix=$KRELL_ROOT_PREFIX --libdir=$KRELL_ROOT_PREFIX/$LIBDIR CC="gcc" CFLAGS="-g -O2" ${ZLIB_INCLUDE} ${ZLIB_LIBS}
        fi
     fi

     make; make install
     cp libelf/elf.h $KRELL_ROOT_PREFIX/include/elf.h
     #cp elfutils-$elfutilsver/lib/elfutils.h $KRELL_ROOT_PREFIX/include/elfutils.h
     #cp elfutils-$elfutilsver/lib/nlist.h $KRELL_ROOT_PREFIX/include/nlist.h

     export KRELL_ROOT_ELFUTILS=$KRELL_ROOT_PREFIX
     popd
     popd
   fi
}

function build_ptgf_routine() { 
   echo ""
   echo "Building PTGF."
   echo ""
   echo "The script will use $KRELL_ROOT_PTGF_ROOT as installation."
   echo ""
   
   #echo "ptgf build, sys=$sys"
   export INSTALL_ROOT=$KRELL_ROOT_PTGF_ROOT
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/ptgf-$ptgfver.tar.gz
   cp SOURCES/ptgf-$ptgfver.tar.gz BUILD/$sys/ptgf-$ptgfver.tar.gz
   pushd BUILD/$sys
   rm -rf ptgf-$ptgfver
   tar -xzf ptgf-$ptgfver.tar.gz
   #cp ../../SOURCES/ptgf-$ptgfver.patch ptgf-$ptgfver/.
   pushd ptgf-$ptgfver
   #patch -p1 < ptgf-$ptgfver.patch
   pushd src
   qmake-qt4 -r && make && make install
   popd
   popd
   popd
}

function build_ptgfossgui_routine() { 
   echo ""
   echo "Building OSS PTGF Based GUI."
   echo ""
   echo "The script will use $KRELL_ROOT_PTGFOSSGUI_ROOT as installation."
   echo "The script will use $OPENSS_PREFIX as OPENSS_PATH."
   echo "The script will use $KRELL_ROOT_PTGF_ROOT as PTGF_INSTALLROOT."
   echo ""
   
   #echo "ptgfossgui build, sys=$sys"
   export INSTALL_ROOT=$KRELL_ROOT_PTGFOSSGUI_ROOT
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/ptgfossgui-$ptgfossguiver.tar.gz
   cp SOURCES/ptgfossgui-$ptgfossguiver.tar.gz BUILD/$sys/ptgfossgui-$ptgfossguiver.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   rm -rf ptgfossgui-$ptgfossguiver
   tar -xzf ptgfossgui-$ptgfossguiver.tar.gz
   cp ../../SOURCES/ptgfossgui-$ptgfossguiver.patch ptgfossgui-$ptgfossguiver/.
   pushd ptgfossgui-$ptgfossguiver
   #patch -p1 < ptgfossgui-$ptgfossguiver.patch
   pushd src
   if [ $KRELL_ROOT_OPENSPEEDSHOP ]; then 
      qmake-qt4 -r PTGF_INSTALLROOT=$KRELL_ROOT_PTGF_ROOT OPENSS_PATH=$KRELL_ROOT_OPENSPEEDSHOP && make && make install
   elif [ $OPENSS_PREFIX ]; then 
      qmake-qt4 -r PTGF_INSTALLROOT=$KRELL_ROOT_PTGF_ROOT OPENSS_PATH=$OPENSS_PREFIX && make && make install
   else
      echo "WARNING: Location of OpenSpeedShop install director not specified using /opt/OSS as OPENSS_PATH for build of ptgfossgui."
      qmake-qt4 -r PTGF_INSTALLROOT=$KRELL_ROOT_PTGF_ROOT OPENSS_PATH=/opt/OSS && make && make install
   fi
   popd
   popd
   popd
}

function build_qcustomplot_routine() { 
   echo ""
   echo "Building qcustomplot."
   echo ""
   echo "The script will use $KRELL_ROOT_QCUSTOMPLOT_ROOT as installation."
   echo ""
   
   echo "qcustomplot build, KRELL_ROOT_PTGF_ROOT=$KRELL_ROOT_PTGF_ROOT"
   echo "qcustomplot build, KRELL_ROOT_QCUSTOMPLOT_ROOT=$KRELL_ROOT_QCUSTOMPLOT_ROOT"

   export INSTALL_ROOT=$KRELL_ROOT_QCUSTOMPLOT_ROOT
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/qcustomplot-$qcustomplotver.tar.gz
   cp SOURCES/qcustomplot-$qcustomplotver.tar.gz BUILD/$sys/qcustomplot-$qcustomplotver.tar.gz
   #cd BUILD/$sys
   pushd BUILD/$sys
   #rm -rf qcustomplot
   rm -rf qcustomplot-$qcustomplotver
   tar -xzf qcustomplot-$qcustomplotver.tar.gz
   #cp ../../SOURCES/qcustomplot-$qcustomplotver.patch qcustomplot-$qcustomplotver/.
   pushd qcustomplot-$qcustomplotver
   #patch -p1 < qcustomplot-$qcustomplotver.patch
   pushd src
   qmake-qt4 -r PTGF_INSTALLROOT=$KRELL_ROOT_PTGF_ROOT && make && make install
   popd
   popd
   popd
}


function build_QtGraph_routine() { 
   echo ""
   echo "Building QtGraph."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation."
   echo ""
   
   echo "QtGraph build, KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"

   export INSTALL_ROOT=$KRELL_ROOT_PREFIX
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/QtGraph-$QtGraphver.tar.gz
   cp SOURCES/QtGraph-$QtGraphver.tar.gz BUILD/$sys/QtGraph-$QtGraphver.tar.gz
   pushd BUILD/$sys
   rm -rf QtGraph-$QtGraphver
   tar -xzf QtGraph-$QtGraphver.tar.gz
   pushd QtGraph-$QtGraphver
   if [ -f ${build_root_home}/SOURCES/QtGraph-$QtGraphver.patch ]; then
      patch -p1 < ${build_root_home}/SOURCES/QtGraph-$QtGraphver.patch
   fi
   export GRAPHVIZ_ROOT=$KRELL_ROOT_GRAPHVIZ

   echo "QtGraph build: KRELL_ROOT_QT=$KRELL_ROOT_QT"
   if [ ! -z $KRELL_ROOT_QT ]; then
       export QTDIR=$KRELL_ROOT_QT 
       echo "QtGraph build: QTDIR=$KRELL_ROOT_QT"
   else
       if [ -f /usr/lib64/qt5/bin/qmake ]; then
           export QTDIR=/usr/lib64/qt5
       elif [ -f /usr/lib64/qt4/bin/qmake ]; then
           export QTDIR=/usr/lib64/qt4
       fi
   fi

   ${QTDIR}/bin/qmake

   make
   make install
   popd
   popd
}


function build_graphviz_routine() { 
   echo ""
   echo "Building graphviz."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation."
   echo ""
   
   echo "graphviz build will set, KRELL_ROOT_GRAPHVIZ=$KRELL_ROOT_PREFIX"
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/graphviz-$graphvizver.tar.gz
   cp SOURCES/graphviz-$graphvizver.tar.gz BUILD/$sys/graphviz-$graphvizver.tar.gz
   pushd BUILD/$sys
   rm -rf graphviz-$graphvizver
   tar -xzf graphviz-$graphvizver.tar.gz
   pushd graphviz-$graphvizver
   if [ -f ${build_root_home}/SOURCES/graphviz-$graphvizver.patch ]; then
      patch -p1 < ${build_root_home}/SOURCES/graphviz-$graphvizver.patch
   fi
   ./configure --prefix=$KRELL_ROOT_PREFIX
   make clean; make; make install
   export KRELL_ROOT_GRAPHVIZ=$KRELL_ROOT_PREFIX
   popd
   popd
}

function build_openspeedshop_routine() {
   echo ""
   echo "Building openspeedshop."
   echo ""
   echo "The script will use $KRELL_ROOT_PREFIX as installation directory."
   echo ""

   if [ $KRELL_ROOT_PREFIX ]; then
          echo "   "
 	  echo "         Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variable: KRELL_ROOT_PREFIX"
          echo "             is not set.  "
          echo "   "
          echo "    PLEASE SET KRELL_ROOT_PREFIX and restart the install script.  Thanks."
          echo "   "
          exit
   fi

   echo 
   echo "Continue the build process for openspeedshop? <y/n>"
   echo

#   read answer
   answer=Y
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the openspeedshop build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
     fi
   fi

   if [ -z $PATH ]; then 
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin
     fi
   else
     if [ $KRELL_ROOT_PREFIX ]; then 
         export PATH=$KRELL_ROOT_PREFIX/bin:$PATH
     fi
   fi

   # setup the autotools or cmake arguments used below
   setup_for_oss_cbtf

   #os_vers=`uname -r`
   #echo "os_vers=$os_vers"
   #platform=`uname -i`
   #echo "platform=$platform"

   # openspeedshop
   pwd
   cd $build_root_home
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   rm -rf BUILD/$sys/openspeedshop-$openspeedshopver.tar.gz BUILD/$sys/openspeedshop-$openspeedshopver
   cp SOURCES/openspeedshop-$openspeedshopver.tar.gz BUILD/$sys/openspeedshop-$openspeedshopver.tar.gz
   pushd BUILD/$sys
   tar -xzf openspeedshop-$openspeedshopver.tar.gz
   pushd openspeedshop-$openspeedshopver

   if [ -f ${build_root_home}/SOURCES/openspeedshop-$openspeedshopver.patch ]; then
      patch -p1 < ${build_root_home}/SOURCES/openspeedshop-$openspeedshopver.patch
   fi
 

   # Toggle this flag to experiment with cmake builds
   build_oss_with_cmake=1
   #build_oss_with_cmake=0
   if [ "$build_oss_with_cmake" = 1 ] ; then
           echo "PATH=$PATH"
           if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
              # From experiences on maia at NASA, these variables need to be set 
              # for successful target builds for mic
              export LD=x86_64-k1om-linux-ld
              export AR=x86_64-k1om-linux-ar
              export RANLIB=x86_64-k1om-linux-ranlib
              export cc="icc -mmic"
              export CC="icc -mmic"
              export CXX="icpc -mmic"
              export PATH=/usr/linux-k1om-4.7/bin:$PATH
              #echo "BUILDING OPENSPEEDSHOP, KRELL_ROOT_TARGET_ARCH=$KRELL_ROOT_TARGET_ARCH"
              #echo "BUILDING OPENSPEEDSHOP, LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
           else
              if [ "$build_with_intel" = 1 ]; then
                  export cc="icc"
                  export CC="icc"
                  export CXX="icpc"
              else
                  export CC="gcc"
                  export CXX="g++"
                  export cc="gcc"
              fi
           fi

           if [ $QTDIR ]; then
              # On systems with multiple qt (qt3 and qt4, etc.) installations available
              # we can pick up the wrong qmake and moc executables causing compile errors
              # like: error: Not a signal or slot declaration in the building of the OSS qt3 GUI
              # setting the path to point to the specified qt3 bin path fixes this.
              # NOTE: if QTDIR is not set, then install-tool argument --with-qt3=<path to qt3> is needed
              # The situation where ${QTDIR} == "/usr/" needs to be looked at and ignore the setting of PATH to /usr/bin
              if [ "${QTDIR}" != "/usr" ]; then
                 export PATH=$QTDIR/bin:$PATH
              fi
           fi

           #
           # Need to come up with a check for what compilers handle c++11
           # Commenting out until there is time to figure that out.
           # Maybe this should be done in the CMakeLists.txt file inside the source directory.
           # FIXME - jeg
           #
           export OSS_CXX_FLAGS="-g -O2"
           #export OSS_CXX_FLAGS="-g -O2 -std=c++11"
           #if [ "compiler check" ] ; then\
           #    export OSS_CXX_FLAGS="-g -O2 -std=c++11"
           #fi
           echo "Building OpenSpeedShop with OSS_CXX_FLAGS=${OSS_CXX_FLAGS}"

           echo "PATH=$PATH"
           mkdir build
           pushd build

           echo "cmake ..  -DCMAKE_BUILD_TYPE=None -DCMAKE_CXX_FLAGS=${OSS_CXX_FLAGS} -DCMAKE_C_FLAGS=-g -O2 ${CMAKE_TLS_TYPE_PHRASE} -DRESOLVE_SYMBOLS=symtabapi ${CMAKE_INSTRUMENTOR_PHRASE} -DCMAKE_INSTALL_PREFIX=$OPENSS_PREFIX -DCMAKE_PREFIX_PATH=$KRELL_ROOT_PREFIX ${CMAKE_TARGET_ARCH_PHRASE} ${CMAKE_RUNTIME_DIR_PHRASE} ${CMAKE_RUNTIME_ONLY_PHRASE} ${CMAKE_BINUTILS_PHRASE} ${CMAKE_LIBELF_PHRASE} ${CMAKE_LIBDWARF_PHRASE} ${CMAKE_LIBMONITOR_PHRASE} ${CMAKE_LIBUNWIND_PHRASE} ${CMAKE_PAPI_PHRASE} ${CMAKE_SQLITE3_PHRASE} ${CMAKE_QTDIR_PHRASE} ${CMAKE_QT_QMAKE_EXECUTABLE_PHRASE} ${CMAKE_QT_MOC_EXECUTABLE_PHRASE} ${CMAKE_PYTHON_PHRASE1} ${CMAKE_PYTHON_PHRASE2} ${CMAKE_PYTHON_PHRASE3} ${CMAKE_PYTHON_PHRASE4} ${CMAKE_BOOST_PHRASE1} ${CMAKE_BOOST_PHRASE2} ${CMAKE_BOOST_LIB_PHRASE} ${CMAKE_BOOST_SYSPATH_PHRASE} ${CMAKE_BOOST_CMAKE_PHRASE} ${CMAKE_XERCESC_PHRASE} ${CMAKE_DYNINST_PHRASE} ${CMAKE_MRNET_PHRASE} ${CMAKE_CBTF_PHRASE} ${CMAKE_CBTF_KRELL_PHRASE} ${CMAKE_CBTF_ARGONAVIS_PHRASE} ${CMAKE_MPICH_PHRASE} ${CMAKE_MPICH2_PHRASE} ${CMAKE_MVAPICH_PHRASE} ${CMAKE_MVAPICH2_PHRASE} ${CMAKE_MPT_PHRASE} ${CMAKE_OPENMPI_PHRASE} ${CMAKE_VT_PHRASE} ${CMAKE_CN_CBTF_KRELL_PHRASE} ${CMAKE_OTF_PHRASE} ${CMAKE_PERSONALITY_PHRASE} ${CMAKE_LIBRT_PHRASE} ${CMAKE_LIBPTHREAD_PHRASE} ${CMAKE_PPC64_BITMODE_PHRASE} ${CMAKE_STDC_PLUS_PLUS_PHRASE} ${CMAKE_LTDL_PHRASE}" > ../build_openspeedshop_${OPENSS_INSTRUMENTOR}_cmake.txt

           cmake .. \
                 -DCMAKE_BUILD_TYPE=None \
                 -DCMAKE_CXX_FLAGS="${OSS_CXX_FLAGS}" \
                 -DCMAKE_C_FLAGS="-g -O2" \
                 ${CMAKE_TLS_TYPE_PHRASE} \
                 -DRESOLVE_SYMBOLS=symtabapi \
                 ${CMAKE_INSTRUMENTOR_PHRASE} \
                 -DCMAKE_INSTALL_PREFIX=$OPENSS_PREFIX \
                 -DCMAKE_PREFIX_PATH=$KRELL_ROOT_PREFIX \
                 ${CMAKE_TARGET_ARCH_PHRASE} \
                 ${CMAKE_RUNTIME_DIR_PHRASE} \
                 ${CMAKE_RUNTIME_ONLY_PHRASE} \
                 ${CMAKE_BINUTILS_PHRASE} \
                 ${CMAKE_LIBELF_PHRASE} \
                 ${CMAKE_LIBDWARF_PHRASE} \
                 ${CMAKE_LIBMONITOR_PHRASE} \
                 ${CMAKE_LIBUNWIND_PHRASE} \
                 ${CMAKE_PAPI_PHRASE} \
                 ${CMAKE_SQLITE3_PHRASE} \
                 ${CMAKE_QTDIR_PHRASE} \
                 ${CMAKE_QT_QMAKE_EXECUTABLE_PHRASE} \
                 ${CMAKE_QT_MOC_EXECUTABLE_PHRASE} \
                 ${CMAKE_PYTHON_PHRASE1} \
                 ${CMAKE_PYTHON_PHRASE2} \
                 ${CMAKE_PYTHON_PHRASE3} \
                 ${CMAKE_PYTHON_PHRASE4} \
                 ${CMAKE_BOOST_PHRASE1} \
                 ${CMAKE_BOOST_PHRASE2} \
                 ${CMAKE_BOOST_LIB_PHRASE} \
                 ${CMAKE_BOOST_SYSPATH_PHRASE} \
                 ${CMAKE_BOOST_CMAKE_PHRASE} \
                 ${CMAKE_XERCESC_PHRASE} \
                 ${CMAKE_DYNINST_PHRASE} \
                 ${CMAKE_MRNET_PHRASE} \
                 ${CMAKE_CBTF_PHRASE} \
                 ${CMAKE_CBTF_KRELL_PHRASE} \
                 ${CMAKE_CBTF_ARGONAVIS_PHRASE} \
                 ${CMAKE_MPICH_PHRASE} \
                 ${CMAKE_MPICH2_PHRASE} \
                 ${CMAKE_MVAPICH_PHRASE} \
                 ${CMAKE_MVAPICH2_PHRASE} \
                 ${CMAKE_MPT_PHRASE} \
                 ${CMAKE_OPENMPI_PHRASE} \
                 ${CMAKE_VT_PHRASE} \
                 ${CMAKE_CN_CBTF_KRELL_PHRASE} \
		 ${CMAKE_CN_LIBMONITOR_PHRASE} \
                 ${CMAKE_OTF_PHRASE} \
                 ${CMAKE_PERSONALITY_PHRASE} \
                 ${CMAKE_LIBRT_PHRASE} \
                 ${CMAKE_LIBPTHREAD_PHRASE} \
                 ${CMAKE_PPC64_BITMODE_PHRASE} \
	         ${CMAKE_STDC_PLUS_PLUS_PHRASE} \
	         ${CMAKE_PTGF_BUILD_OPTION_PHRASE} \
                 ${CMAKE_LTDL_PHRASE}

           make clean
           make 
           make install


   else

      # This is the master configure line, preceded by special flags, followed by allowable OSS configure
      # options covering the range of possible install-tool options.
      $cc_PHRASE 
      $CC_PHRASE 
      $CXX_PHRASE 
      $CFLAGS_PHRASE 
      $CPPFLAGS_PHRASE 
      $CXXFLAGS_PHRASE 
      $LDFLAGS_PHRASE 
       ./configure \
                $KRELL_ROOT_TARGET_ARCH_PHRASE \
                --prefix=$OPENSS_PREFIX \
                --libdir=$OPENSS_PREFIX/$LIBDIR \
                --with-included-ltdl  \
                $OPENSS_INSTRUMENTOR_PHRASE \
                $OPENSS_ENABLE_DEBUG_PHRASE \
                $KRELL_ROOT_TLS_TYPE_PHRASE  \
                $KRELL_ROOT_LIBELF_PHRASE  \
                $KRELL_ROOT_LIBDWARF_PHRASE  \
                $KRELL_ROOT_BINUTILS_PHRASE  \
                $KRELL_ROOT_LIBUNWIND_PHRASE \
                $KRELL_ROOT_PAPI_PHRASE  \
                $KRELL_ROOT_SQLITE_PHRASE \
                $QTDIR_PHRASE \
                $KRELL_ROOT_DYNINST_PHRASE \
                $KRELL_ROOT_DYNINST_LIB_PHRASE \
                $KRELL_ROOT_DYNINST_VERS_PHRASE \
                $KRELL_ROOT_MPI_LAMPI_PHRASE  \
                $KRELL_ROOT_MPI_OPENMPI_PHRASE  \
                $KRELL_ROOT_MPI_MPT_PHRASE  \
                $KRELL_ROOT_MPI_MPICH_PHRASE  \
                $KRELL_ROOT_MPI_MPICH2_PHRASE  \
                $KRELL_ROOT_MPI_MPICH2_DRIVER_PHRASE \
                $KRELL_ROOT_MPI_MVAPICH_PHRASE  \
                $KRELL_ROOT_MPI_MVAPICH2_PHRASE  \
                $KRELL_ROOT_MPI_MVAPICH2_OFED_PHRASE \
                $KRELL_ROOT_MPI_LAM_PHRASE  \
                $KRELL_ROOT_MPI_MPICH_DRIVER_PHRASE \
                $KRELL_ROOT_OTF_PHRASE  \
                $KRELL_ROOT_VT_PHRASE  \
                $KRELL_ROOT_LIBMONITOR_PHRASE  \
                $KRELL_ROOT_MRNET_PHRASE \
                $KRELL_ROOT_MRNET_VERS_PHRASE \
                $KRELL_ROOT_PYTHON_PHRASE \
                $KRELL_ROOT_XERCESC_PHRASE  \
                $KRELL_ROOT_XERCESC_LIB_PHRASE \
                $KRELL_ROOT_SYMTABAPI_PHRASE \
                $KRELL_ROOT_SYMTABAPI_LIB_PHRASE  \
                $KRELL_ROOT_SYMTABAPI_VERS_PHRASE  \
                $KRELL_ROOT_RESOLVE_SYMBOLS_PHRASE  \
                $KRELL_ROOT_BOOST_PHRASE \
                $KRELL_ROOT_BOOST_LIB_PHRASE \
                $CBTF_PHRASE \
                $CBTF_XML_PHRASE \
                $CBTF_MRNET_PHRASE \
                $CBTF_KRELL_PHRASE \
                $KRELL_ROOT_RUNTIME_ONLY_PHRASE  \
                $KRELL_ROOT_RUNTIME_DIR_PHRASE \
                $KRELL_ROOT_PTGF_BUILD_OPTION_PHRASE\
                $KRELL_ROOT_CONFIG_HOST_PHRASE \
                $KRELL_ROOT_CONFIG_TARGET_PHRASE \
                $KRELL_ROOT_ENABLE_TARGET_DLOPEN_PHRASE \
                $KRELL_ROOT_PERSONALITY_PHRASE \
                $KRELL_ROOT_LIBRT_PHRASE \
                $KRELL_ROOT_LIBPTHREAD_PHRASE \
                $KRELL_ROOT_PPC64_BITMODE_PHRASE \
	        $KRELL_ROOT_STDC_PLUS_PLUS_PHRASE \
                $KRELL_ROOT_ENABLE_TARGET_FORK_PHRASE

      make; make install
   fi
   export KRELL_ROOT_OPENSPEEDSHOP=$OPENSS_PREFIX
   popd
   popd
}

# Main Build Function
function build() { 

    #echo "IN FUNCTION BUILD"
    if [ -z "$1" ]; then #If no parameter is passed to the function, we are in
        about            #interactive mode
        buildtask        
        #echo "IN FUNCTION BUILD, calling prereq"
        report_missing_packages=1
        #prereq        
	envvars
        # Comment out these checks because we didn't do anything with the results.
        # We used to, but now install-tool does the checking
        # Keeping in here for a while - jeg 12/22/16
        #if [ -z $OPENSS_BUILD_TASK ]; then
        #  echo "IN FUNCTION BUILD, no OPENSS_BUILD_TASK,calling prefixPrereqOSS"
        #  #prefixPrereqOSS        
	#elif [ "$OPENSS_BUILD_TASK" == "mrnet" ] || \
	#     [ "$OPENSS_BUILD_TASK" == "offline" ] ; then
        #  echo "IN FUNCTION BUILD, mrnet,offline,calling prefixPrereqOSS"
        #  #prefixPrereqOSS        
	#elif [ "$OPENSS_BUILD_TASK" == "krellroot" ]; then
        #  echo "IN FUNCTION BUILD, krellroot,calling prefixPrereqKRELLROOT"
        #  #prefixPrereqKRELLROOT        
	#elif [ "$OPENSS_BUILD_TASK" == "cbtf" ]; then
        #  echo "IN FUNCTION BUILD, cbtf,calling prefixPrereqCBTF"
        #  #prefixPrereqCBTF        
        #fi
 
        # These are now set by the install-tool
	#default_envs
        #choices
        if [ -f LAST_OPTION ];then
            echo "-last option: " 
            cat LAST_OPTION
        fi
        echo "Enter Option: "
        read nanswer
    else #If parameter is passed, set nanswer and default buildtask
        # The build task is set by install-tool now
        #buildtask
        report_missing_packages=0
        # The prereqs are now checked by the install-tool
        #prereq        
        nanswer=$1
    fi
    echo $nanswer > LAST_OPTION
    if [ -z $OPENSS_PREFIX ]; then
       ./Build-RPM-krellroot newrpmloc
    else
       ./Build-RPM newrpmloc
    fi
    more ~/.rpmmacros
    envvars
#    if [ "$nanswer" = 0  -o "$nanswer" = 9 ]; then
#        echo 
#        echo "Re-write ~/.rpmmacros file to point to local directories."
#        echo "Your original will be saved as ~/.rpmmacros.$$ - rename manually"
#        echo "when build process is completed"
#        echo 
#        echo "Re-Write ~/.rpmmacros? <y/n>"
#        echo
#        
#        if [ "$nanswer" = 9 ]; then
#            answer=Y
#        else
#            read answer
#        fi
#        
#        if [ "$answer" = Y -o "$answer" = y ]; then
#            ./Build-RPM-krellroot newrpmloc
#            more ~/.rpmmacros
#            echo
#            echo "ready to continue..."
#        fi
#    fi
#    if [ "$nanswer" = 0a ]; then
#        envvars
#    fi
    echo "--------------------- BEGIN CMAKE BUILD ---------------------------"
    echo "--------------------- BEGIN CMAKE BUILD ---------------------------"

    if [ "$OPENSS_BUILD_TASK" == "krellroot" ] ; then
       # if the user forces the build then build even if skip was also set
       if [ "$skip_cmake_build" = 1  -a  "$force_cmake_build" = 0 ] ; then
         echo "SKIPPING CMAKE build due to --skip-cmake-build on install tool line"
       else
          # Is cmake for building OSS already built?   Then don't build again
          if [ -f $KRELL_ROOT_PREFIX/cmake-$cmakever/share/cmake-3.2/Modules/FindPythonLibs.cmake -a -f $KRELL_ROOT_PREFIX/cmake-$cmakever/bin/cmake ]; then
              echo "SKIPPING CMAKE build due to it is already installed in $KRELL_ROOT_PREFIX/cmake-$cmakever directory"
              export PATH=$KRELL_ROOT_PREFIX/cmake-$cmakever/bin:$PATH
          else
              # Is this a special --build-cmake request, if so only use ${KRELL_ROOT_PREFIX}
              # as the CMAKE_INSTALL_PREFIX, otherwise add the ../cmake
              # 1 = special --build-cmake request
              # 0 = part of normal --build-krell-root
              build_cmake_routine 0
              if [ -f $KRELL_ROOT_PREFIX/cmake-$cmakever/share/cmake-3.2/Modules/FindPythonLibs.cmake -a -f $KRELL_ROOT_PREFIX/cmake-$cmakever/bin/cmake ]; then
                  echo "CMAKE BUILD TOOL BUILT SUCCESSFULLY into $KRELL_ROOT_PREFIX/cmake"
                  # use this cmake for the rest of the build
                  export PATH=$KRELL_ROOT_PREFIX/cmake-$cmakever/bin:$PATH
              else
                  echo "CMAKE BUILD TOOL FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                  exit
              fi
          fi
       fi
    fi

    echo "--------------------- END   CMAKE BUILD ---------------------------"
    echo "--------------------- END   CMAKE BUILD ---------------------------"


    echo "--------------------- BEGIN OMPT BUILD ---------------------------"
    echo "--------------------- BEGIN OMPT BUILD ---------------------------"

    if [ "$OPENSS_BUILD_TASK" == "krellroot" ] ; then
       # if the user forces the build then build even if skip was also set
       if [ "$skip_ompt_build" = 1 -a "$force_ompt_build" = 0 -o "$use_llvm_openmp" = 1 ] ; then
         echo "SKIPPING OMPT build due to --skip-ompt-build on install tool line"
       else
          if [ "$machine_name" != "ppc64le" ]; then
              build_ompt_routine 0
              if [ -f $KRELL_ROOT_PREFIX/ompt/include/ompt.h -a -f $KRELL_ROOT_PREFIX/ompt/lib/libiomp5.so ]; then
                  echo "OMPT RUNTIME LIBRARY (libompt5.so) BUILT SUCCESSFULLY into $KRELL_ROOT_PREFIX/ompt"
              else
                  echo "OMPT RUNTIME LIBRARY (libompt5.so) FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                  exit
              fi
          else
              echo "SKIPPING OMPT build due to machine type == ppc64le"
          fi
       fi
    fi

    echo "--------------------- END   OMPT BUILD ---------------------------"
    echo "--------------------- END   OMPT BUILD ---------------------------"


    echo "--------------------- BEGIN LLVM-openmp BUILD ---------------------------"
    echo "--------------------- BEGIN LLVM-openmp BUILD ---------------------------"

    if [ "$OPENSS_BUILD_TASK" == "krellroot" ] ; then
       # if the user forces the build then build even if skip was also set
       if [ "$skip_llvm_openmp_build" = 1 -a "$force_llvm_openmp_build" = 0 -o "$use_llvm_openmp" = 0 ] ; then
         echo "SKIPPING LLVM-openmp build due to --skip-llvm_openmp-build on install tool line"
       else
          build_llvm_openmp_routine 0
          if [ -f $KRELL_ROOT_PREFIX/ompt/include/omp.h -a -f $KRELL_ROOT_PREFIX/ompt/lib/libiomp5.so ]; then
              echo "LLVM-openmp RUNTIME LIBRARY (libompt5.so) BUILT SUCCESSFULLY into $KRELL_ROOT_PREFIX/ompt"
          else
              echo "LLVM-openmp RUNTIME LIBRARY (libompt5.so) FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
              exit
          fi
       fi
    fi

    echo "--------------------- END   LLVM-openmp BUILD ---------------------------"
    echo "--------------------- END   LLVM-openmp BUILD ---------------------------"


    if [ "$nanswer" = 1  -o "$nanswer" = 9 ] ; then
      echo "OPENSS_BUILD_TASK=$OPENSS_BUILD_TASK"
      if [ "$OPENSS_BUILD_TASK" != "onlyosscbtf" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossoffline" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossonline" ] ; then

        echo "build_binutils=$build_binutils"
	if [ $build_binutils == 1 -a $skip_binutils == 0 ] && [ "$KRELL_ROOT_TARGET_ARCH" != "mic" ]; then

          echo
          echo "Build binutils? <y/n>"
          echo

          if [ $KRELL_ROOT_PREFIX ]; then
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
            else
              export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
            fi
          else
              if [ -z $LD_LIBRARY_PATH ]; then 
                export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR
              else
                export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR:$LD_LIBRARY_PATH
              fi
              export KRELL_ROOT_PREFIX=/opt/OSS
              # set KRELL_ROOT_PREFIX to prefix to facilitate RPM build
          fi

          if [ "$nanswer" = 9 -o $imode == 0 ]; then
              answer=Y
          else
              read answer
          fi
          if [ "$answer" = Y -o "$answer" = y ]; then
            # Decide if building rpm option was used (--rpm or --create-rpm)
            if [ "$use_rpm" = 1 ] ; then
              rm -rf RPMS/$sys/binutils.OSS.*.rpm
              ./Build-RPM-krellroot binutils-$binutilsver
              if [ -s RPMS/$sys/binutils.OSS.*.rpm ]; then
                  echo "BINUTILS BUILT SUCCESSFULLY."
                  export KRELL_ROOT_BINUTILS=$KRELL_ROOT_PREFIX
              else
                  echo "BINUTILS FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                  exit
              fi
            else
              echo "Need alternative for rpm here - binutils"
              build_binutils_routine
              if [ -d $BINUTILS_INSTALL_PATH -a -f $BINUTILS_INSTALL_PATH/include/bfd.h -a -f $BINUTILS_INSTALL_PATH/include/libiberty.h ]; then
                   echo "BINUTILS BUILT SUCCESSFULLY."
                   export KRELL_ROOT_BINUTILS=$BINUTILS_INSTALL_PATH
              else
                   echo "BINUTILS FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                   exit
              fi
            fi
          fi
        fi

        
        #if [ $build_oss_gui_only == 0 ] && [ $build_oss_runtime_only == 0 ] ; then
        if [ $build_oss_gui_only == 0 ] ; then

          echo
          echo "Checking to see if libelf is available..."
          echo; echo

	  if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
              echo
              echo "SKIPPING LIBELF BUILD, because KRELL_ROOT_SKIP_LIBELF_BUILD was set."
              echo
              install_libelf=0
          elif [ $skip_libelf_build == 1 ]; then
              echo
              echo "SKIPPING LIBELF BUILD, because KRELL_ROOT_SKIP_LIBELF_BUILD was set."
              echo
              install_libelf=0
          elif [ $build_libelf_by_default == 0 ] && [ $force_libelf_build == 0 -a -f $KRELL_ROOT_LIBELF/$LIBDIR/libelf.so ] && [ -f $KRELL_ROOT_LIBELF/include/libelf.h -o \
               -f $KRELL_ROOT_LIBELF/include/libelf/libelf.h ]; then
              echo "libelf detected in $KRELL_ROOT_LIBELF/<lib>, will not be built..."
              echo
              install_libelf=0
          elif [ $build_libelf_by_default == 0 ] && [ $force_libelf_build == 0 -a -f /usr/$LIBDIR/libelf.so ] && [ -f /usr/include/libelf.h -o \
               -f /usr/include/libelf/libelf.h ]; then
              echo "libelf detected in /usr/<lib>, will not be built..."
              install_libelf=0
              echo
          else
              echo "libelf not detected - please build"
              echo 
              echo "Build libelf? <y/n>"
              echo
              if [ "$nanswer" = 9 -o $imode == 0 ]; then
                  answer=Y
              else
                  read answer
              fi
              if [ "$answer" = Y -o "$answer" = y ]; then
                # Decide if building rpm option was used (--rpm or --create-rpm)
                if [ "$use_rpm" = 1 ] ; then
                  install_libelf=1
                  rm -rf RPMS/$sys/libelf.OSS.*.rpm
                  ./Build-RPM-krellroot libelf-$libelfver
                  if [ -s RPMS/$sys/libelf.OSS.*.rpm ]; then
                      echo "LIBELF BUILT SUCCESSFULLY."
                  else
                      echo "LIBELF FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                      exit
                  fi
                  if [ $KRELL_ROOT_PREFIX ]; then
                    export KRELL_ROOT_LIBELF=$KRELL_ROOT_PREFIX
                  else
                    export KRELL_ROOT_LIBELF=/opt/OSS
                  fi
                else
                  echo "Need alternative for rpm here - elf"
                  # Dyninst-9.3.1 and above need to use elfutils only, not libelf
                  if [ $dyninstver == "9.3.2" -o $dyninstver == "20171003" ]; then
                      if [ "$found_libz" = 0 ]; then
                          build_zlib_routine
                      fi
                      build_elfutils_routine
                  else
                      build_libelf_routine
                  fi

                  if [ $KRELL_ROOT_PREFIX/$LIBDIR/libelf.so ] && [ -f $KRELL_ROOT_PREFIX/include/libelf.h -o \
                       -f $KRELL_ROOT_PREFIX/include/libelf/libelf.h ]; then
                    if [ $KRELL_ROOT_PREFIX ]; then
                      export KRELL_ROOT_LIBELF=$KRELL_ROOT_PREFIX
                    else
                      export KRELL_ROOT_LIBELF=/opt/OSS
                    fi
                    echo "LIBELF BUILT SUCCESSFULLY."
                  else
                      echo "LIBELF FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                      exit
                  fi

                fi
              fi
          fi
        fi
      fi # only osscbtf build task
    fi

    # Decide if building rpm option was used (--rpm or --create-rpm)
    if [ "$use_rpm" = 1 ] ; then
     #if [ "$nanswer" = 1a -o "$nanswer" = 9 ] ; then
     if [ "$nanswer" = 1a -o "$nanswer" = 9 ] || [ $build_binutils == 1 -a "$nanswer" = 1 ]  ; then
      if [ "$OPENSS_BUILD_TASK" != "onlyosscbtf" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossoffline" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossonline" ] ; then

        # IF COMING IN FROM A SEPERATE INNOCATION OF INSTALL.SH THEN DETECT LIBELF INSTALLATIONS
        echo "RPMS/$sys/libelf.OSS.*.rpm=RPMS/$sys/libelf.OSS.*.rpm"
        if [ -z $KRELL_ROOT_LIBELF ]; then
          if [ -f RPMS/$sys/libelf.OSS.*.rpm ]; then
            echo "libelf detected as built into RPMS/$sys/libelf.OSS.*.rpm will be installed into $KRELL_ROOT_PREFIX/<lib>"
            install_libelf=1
            echo
          fi
        else
          echo "KRELL_ROOT_LIBELF is set, use this for building other components"
        fi

        if [ "$install_libelf" = 1 ] && [ $skip_libelf_build == 0 ] &&[ $build_oss_gui_only == 0 ] && [ $build_oss_runtime_only == 0 ] ; then
          echo "Install base Support libraries: libelf"
          echo "This is non-root cpio process."
          echo "Installing in /opt/OSS unless KRELL_ROOT_PREFIX set"
          echo
          if [ $KRELL_ROOT_PREFIX ]; then
              echo "Install Path:  : ", $KRELL_ROOT_PREFIX
          else
              echo "Install Path:  : /opt/OSS"
          fi
          #cd RPMS/$sys
          pushd RPMS/$sys
          echo "starting RPM to cpio process..."
          if [ -f libelf.OSS.*.rpm ]; then
              rpm2cpio libelf.OSS.*.rpm > libelf.cpio
          fi
          echo "starting cpio to local path install process..."
          rm -rf opt
          if [ -f libelf.cpio ]; then
              cpio -id < libelf.cpio
          fi
          echo "moving files to target path..."
          if [ $KRELL_ROOT_PREFIX ]; then
              if [ -e $KRELL_ROOT_PREFIX ]; then
                  echo "KRELL_ROOT_PREFIX exists"
              else
                  mkdir -p $KRELL_ROOT_PREFIX
              fi
              cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
              #cp -r opt/OSS/* $KRELL_ROOT_PREFIX
          else
              cp -r opt/* /opt
          fi
          #cd ../.. # Back out of RPMS
          popd # Back out of RPMS
        fi

	if [ $build_binutils == 1 ] && [ $skip_binutils == 0 ]; then
          #cd RPMS/$sys
          pushd RPMS/$sys
          echo "starting RPM to cpio process..."
          if [ -f binutils.OSS.*.rpm ]; then
              rpm2cpio binutils.OSS.*.rpm > binutils.cpio
          fi
          echo "starting cpio to local path install process..."
          rm -rf opt
          if [ -f binutils.cpio ]; then
              cpio -id < binutils.cpio
          fi
          echo "moving files to target path..."
          if [ $KRELL_ROOT_PREFIX ]; then
              if [ -e $KRELL_ROOT_PREFIX ]; then
                  echo "KRELL_ROOT_PREFIX exists"
              else
                  mkdir -p $KRELL_ROOT_PREFIX
              fi
              cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
              echo "copying from `pwd`$KRELL_ROOT_PREFIX to $KRELL_ROOT_PREFIX"
              export KRELL_ROOT_BINUTILS=$KRELL_ROOT_PREFIX
          else
              cp -r opt/* /opt
              echo "copy to /opt"
              export KRELL_ROOT_BINUTILS=/opt
          fi
          #cd ../.. # Back out of RPMS
          popd # Back out of RPMS
        fi
      fi # only osscbtf build task
    fi
   fi # use_rpm 

	#[ $build_oss_gui_only == 0 ] && [ $build_oss_runtime_only == 0 ] ; then
    install_libdwarf=1
    export suggest_libdwarf_build=0
    if [ "$nanswer" = 2  -o "$nanswer" = 9 ] && \
	[ $build_oss_gui_only == 0 ] ; then
      if [ "$OPENSS_BUILD_TASK" != "onlyosscbtf" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossoffline" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossonline" ] ; then

	if [ "$OPENSS_BUILD_TASK" == "mrnet" ] || \
             [ "$OPENSS_BUILD_TASK" == "cbtf" ] || \
             [ "$OPENSS_BUILD_TASK" == "krellroot" ]; then
           # SUGGEST THE BUILD BECAUSE DYNINST NEEDS A VERY NEW DWARF 
           # BUT IF LIBDWARF INSTALLED, THEN USE THAT LIBDWARF 
           #echo "build debug: set suggest_libdwarf_build=1......"
           suggest_libdwarf_build=1
        fi
         
        # DETECT LIBDWARF INSTALLATIONS
        echo "KRELL_ROOT_LIBDWARF=$KRELL_ROOT_LIBDWARF"
        echo "KRELL_ROOT_LIBDWARF/LIBDIR=$KRELL_ROOT_LIBDWARF/$LIBDIR"

	if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
            install_libdwarf=0
            echo "skipping libdwarf build, because required to be built for Intel MIC compute nodes."
        elif [ $skip_libdwarf_build == 1 ]; then
            install_libdwarf=0
            echo "skipping libdwarf build, because it was requested not to be built..."
        elif [ $force_libdwarf_build == 0 ] && [ $suggest_libdwarf_build == 1 ] && [ $KRELL_ROOT_LIBDWARF ] && [ -f $KRELL_ROOT_LIBDWARF/$LIBDIR/libdwarf.so -a -f $KRELL_ROOT_LIBDWARF/include/libdwarf.h ]; then
            echo "libdwarf detected in $KRELL_ROOT_LIBDWARF/<lib>, will not be built..."
            echo
            install_libdwarf=0
        elif [ $force_libdwarf_build == 0 ] && [ $suggest_libdwarf_build == 0 ] && [ -f /usr/lib64/libdwarf.so -o -f /usr/lib/libdwarf.so ] && [ -f /usr/include/libdwarf.h -o -f /usr/include/libdwarf/libdwarf.h ] ; then
            echo "libdwarf detected in /usr/<lib>, will not be built..."
            echo
            install_libdwarf=0
            export KRELL_ROOT_LIBDWARF=/usr
        else
          echo
          echo "Build libdwarf? <y/n>"
          echo

          if [ $KRELL_ROOT_PREFIX ]; then
              if [ -z $LD_LIBRARY_PATH ]; then 
                export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
              else
                export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
              fi
          else
              if [ -z $LD_LIBRARY_PATH ]; then 
                export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR
              else
                export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR:$LD_LIBRARY_PATH
              fi
              export KRELL_ROOT_PREFIX=/opt/OSS
              # set KRELL_ROOT_PREFIX to prefix to facilitate RPM build
          fi

          if [ "$nanswer" = 9 -o $imode == 0 ]; then
              answer=Y
          else
              read answer
          fi
          if [ "$answer" = Y -o "$answer" = y ]; then
            # Decide if building rpm option was used (--rpm or --create-rpm)
            if [ "$use_rpm" = 1 ] ; then
              rm -rf RPMS/$sys/libdwarf.OSS.*.rpm
              ./Build-RPM-krellroot libdwarf-$libdwarfver
              if [ -s RPMS/$sys/libdwarf.OSS.*.rpm ]; then
                  echo "LIBDWARF BUILT SUCCESSFULLY."
              else
                  echo "LIBDWARF FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                  exit
              fi
              if [ $KRELL_ROOT_PREFIX ]; then
                export KRELL_ROOT_LIBDWARF=$KRELL_ROOT_PREFIX
              else
                export KRELL_ROOT_LIBDWARF=/opt/OSS
              fi
            else
              build_libdwarf_routine
              if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.so -a -f $KRELL_ROOT_PREFIX/include/libdwarf.h ]; then
                  export KRELL_ROOT_LIBDWARF=$KRELL_ROOT_PREFIX
                  echo "LIBDWARF BUILT SUCCESSFULLY."
              else
                  echo "LIBDWARF FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                  exit
              fi
            fi
          fi
        fi
      fi # only osscbtf build task
    fi

    if [ "$nanswer" = 2a -o "$nanswer" = 9 ] && \
	[ $build_oss_gui_only == 0 ] && [ $build_oss_runtime_only == 0 ] && [ $skip_libdwarf_build == 0 ]; then

     # Decide if building rpm option was used (--rpm or --create-rpm)
     if [ "$use_rpm" = 1 ] ; then
      if [ "$OPENSS_BUILD_TASK" != "onlyosscbtf" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossoffline" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossonline" ] ; then

        # IF COMING IN FROM A SEPERATE INNOCATION OF INSTALL.SH THEN DETECT LIBELF INSTALLATIONS
        #echo "RPMS/$sys/libdwarf.OSS.*.rpm=RPMS/$sys/libdwarf.OSS.*.rpm"
        if [ -z $KRELL_ROOT_LIBDWARF ]; then
          if [ -f RPMS/$sys/libdwarf.OSS.*.rpm ]; then
            echo "libdwarf detected as built into RPMS/$sys/libdwarf.OSS.*.rpm will be installed into $KRELL_ROOT_PREFIX/<lib>"
            install_libdwarf=1
            echo
          fi
        else
          echo "KRELL_ROOT_LIBDWARF is set, use this for building other components"
        fi

        echo "Install base Support libraries: libdwarf"
        echo "This is non-root cpio process."
        echo "Installing in /opt/OSS unless KRELL_ROOT_PREFIX set"
        echo
        if [ $KRELL_ROOT_PREFIX ]; then
            echo "Install Path:  : ", $KRELL_ROOT_PREFIX
        else
            echo "Install Path:  : /opt/OSS"
        fi

        #cd RPMS/$sys
        pushd RPMS/$sys
        echo "starting RPM to cpio process..."
        if [ $install_libdwarf == 1 ]; then
          if [ -f libdwarf.OSS.*.rpm ]; then
              rpm2cpio libdwarf.OSS.*.rpm > libdwarf.cpio
          fi
        fi
        echo "starting cpio to local path install process..."
        rm -rf opt
        if [ $install_libdwarf == 1 ]; then
          if [ -f libdwarf.cpio ]; then
              cpio -id < libdwarf.cpio
          fi
        fi
        echo "moving files to target path..."
        if [ $KRELL_ROOT_PREFIX ]; then
            if [ -e $KRELL_ROOT_PREFIX ]; then
                echo "KRELL_ROOT_PREFIX exists"
            else
                mkdir -p $KRELL_ROOT_PREFIX
            fi
# jeg changed 10/27/10
#            cp -r opt/OSS/* $KRELL_ROOT_PREFIX
#            echo "copy to KRELL_ROOT_PREFIX"
            cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
            echo "copying from `pwd`$KRELL_ROOT_PREFIX to $KRELL_ROOT_PREFIX"
        else
            cp -r opt/* /opt
            echo "copy to /opt"
        fi
        #cd ../.. # Back out of RPMS
        popd # Back out of RPMS
      fi # only osscbtf build task
     fi # use_rpm
    fi

    install_libpapi=1

    if [ "$nanswer" = 3 -o "$nanswer" = 9 ]; then

      if [ "$OPENSS_BUILD_TASK" != "onlyosscbtf" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossoffline" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossonline" ] ; then

        echo "Build base Support libraries: libunwind, papi, sqlite, monitor"
        echo "- will build RPMs - these can be used for installation as either"
        echo "RPMs or we can do a non-root install utilizing cpio"
        echo 

        if [ $KRELL_ROOT_PREFIX ]; then
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
            else
              export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
            fi
        else
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR
            else
              export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR:$LD_LIBRARY_PATH
            fi
            export KRELL_ROOT_PREFIX=/opt/OSS
            # set KRELL_ROOT_PREFIX to prefix to facilitate RPM build
        fi

        install_libunwind=1
        if [ $skip_libunwind_build == 1 ]; then
            install_libunwind=0
            echo "skipping libunwind build, because it was requested not to be built..."
        elif [ $force_libunwind_build == 0 ] && [ $KRELL_ROOT_LIBUNWIND ] && [ -f $KRELL_ROOT_LIBUNWIND/$LIBDIR/libunwind.so -a -f $KRELL_ROOT_LIBUNWIND/include/libunwind.h ]; then
            echo "libunwind detected in $KRELL_ROOT_LIBUNWIND/<lib>, will not be built..."
            echo
            install_libunwind=0
        elif [ $build_libunwind_by_default == 0 ] && [ $force_libunwind_build == 0 ] && [ -f /usr/lib64/libunwind.so -o -f /usr/lib/libunwind.so ] && [ -f /usr/include/libunwind.h ] ; then
            echo "libunwind detected in /usr/<lib>, will not be built..."
            echo
            install_libunwind=0
            export KRELL_ROOT_LIBUNWIND=/usr
        else
          echo "Build libunwind? <y/n>"
          echo 
          if [ "$nanswer" = 9 -o $imode == 0 ]; then
              answer=Y
          else
              read answer
          fi
          if [ "$answer" = Y -o "$answer" = y ] && \
	     [ $build_oss_gui_only == 0 ] || [ $build_oss_runtime_only == 1 ] ; then
            # Decide if building rpm option was used (--rpm or --create-rpm)
            if [ "$use_rpm" = 1 ] ; then
                rm -rf RPMS/$sys/libunwind.OSS.*.rpm
                ./Build-RPM-krellroot libunwind-$libunwindver
                if [ -s RPMS/$sys/libunwind.OSS.*.rpm ]; then
                    echo "LIBUNWIND BUILT SUCCESSFULLY."
                else
                    echo "LIBUNWIND FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                    exit
                fi
            else
              build_libunwind_routine
              if test -f ${KRELL_ROOT_PREFIX}/$ALTLIBDIR/libunwind.so -o -f ${KRELL_ROOT_PREFIX}/$LIBDIR/libunwind.so ; then
                    export KRELL_ROOT_LIBUNWIND=$KRELL_ROOT_PREFIX
                    echo "LIBUNWIND BUILT SUCCESSFULLY."
              else
                    echo "LIBUNWIND FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                    exit
              fi
            fi
          fi
        fi

        # DETECT PAPI INSTALLATIONS
        #echo "KRELL_ROOT_PAPI=$KRELL_ROOT_PAPI"
        #echo "KRELL_ROOT_PAPI/LIBDIR=$KRELL_ROOT_PAPI/$LIBDIR"
         
        # jeg 10/9/2012 - don't find libpapi in /usr instead always build our own version
        # unless the user asks for KRELL_ROOT_PAPI then use that
        if [ "$skip_papi_build" = 0 ] && [ "$force_papi_build" = 0 ] && \
           [ -f $KRELL_ROOT_PAPI/$LIBDIR/libpapi.so -o $KRELL_ROOT_PAPI/$ALTLIBDIR/libpapi.so ] && \
           [ -f $KRELL_ROOT_PAPI/include/papi.h ]; then
            echo "libpapi detected in $KRELL_ROOT_PAPI/<lib>, will not be built..."
            install_libpapi=0
            echo
        elif [ $build_papi_by_default == 0 ] && [ $force_papi_build == 0 ] && [ -f /usr/$LIBDIR/libpapi.so -a -f /usr/include/papi.h ]; then
            echo "libpapi detected in /usr/<lib>, will not be built..."
            install_libpapi=0
            export KRELL_ROOT_PAPI=/usr
            echo
        elif [ $skip_papi_build == 1 ]; then
            echo "SKIP libpapi option detected, papi will not be built..."
            install_libpapi=0
        else
           echo
           echo "Build papi? <y/n>"
           echo
           if [ "$nanswer" = 9 -o $imode == 0 ]; then
               answer=Y
           else
               read answer
           fi
           if [ "$answer" = Y -o "$answer" = y ] || [ $build_oss_runtime_only == 1 ] ; then
            # Decide if building rpm option was used (--rpm or --create-rpm)
            if [ "$use_rpm" = 1 ] ; then
               rm -rf RPMS/$sys/papi.OSS.*.rpm
               ./Build-RPM-krellroot papi-$papiver
               if [ -s RPMS/$sys/papi.OSS.*.rpm ]; then
                  echo "PAPI BUILT SUCCESSFULLY."
               else
                  echo "PAPI FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                  exit
               fi
               if [ -z $KRELL_ROOT_PREFIX ]; then
                 export KRELL_ROOT_PAPI=/opt/KRELLROOT
               else
                 export KRELL_ROOT_PAPI=$KRELL_ROOT_PREFIX
               fi
               install_libpapi=1
            else
              build_papi_routine
              if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libpapi.so ] && [ -f $KRELL_ROOT_PREFIX/include/papi.h ]; then
                  export KRELL_ROOT_PAPI=$KRELL_ROOT_PREFIX
                  echo "PAPI BUILT SUCCESSFULLY."
               else
                  echo "PAPI FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                  exit
               fi
            fi
           fi
        fi

        # DETECT SQLITE INSTALLATIONS
        echo "KRELL_ROOT_SQLITE=$KRELL_ROOT_SQLITE"
        echo "KRELL_ROOT_SQLITE/LIBDIR=$KRELL_ROOT_SQLITE/$LIBDIR"

        if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ]; then
            install_libsqlite=0
            echo "skipping libsqlite build, because it is not required to be built for the Intel MIC compute nodes."
        elif [ $skip_sqlite_build == 1 ]; then
            install_libsqlite=0
            echo "skipping libsqlite build, because it was requested not to be built..."
        elif [ $force_sqlite_build == 0 ] && \
             [ -f $KRELL_ROOT_SQLITE/$LIBDIR/libsqlite3.so -o -f $KRELL_ROOT_SQLITE/lib/x86_64-linux-gnu/libsqlite3.so ] && \
             [ -f $KRELL_ROOT_SQLITE/include/sqlite3.h ]; then
            echo "libsqlite detected in $KRELL_ROOT_SQLITE/<lib>, will not be built..."
            install_libsqlite=0
            echo
        elif [ $force_sqlite_build == 0 ] && \
             [ -f /usr/$LIBDIR/libsqlite3.so -o /usr/lib/x86_64-linux-gnu/libsqlite3.so ] && \
             [ -f /usr/include/sqlite3.h ]; then
            echo "libsqlite detected in /usr/<lib>, will not be built..."
            install_libsqlite=0
            export KRELL_ROOT_SQLITE=/usr
            echo
        else
          echo
          echo "Build sqlite? <y/n>"
          echo
          if [ "$nanswer" = 9 -o $imode == 0 ]; then
              answer=Y
          else
              read answer
          fi
          if [ "$answer" = Y -o "$answer" = y ] && [ $build_oss_runtime_only == 0 ] ; then
            # Decide if building rpm option was used (--rpm or --create-rpm)
            if [ "$use_rpm" = 1 ] ; then
               rm -rf RPMS/$sys/sqlite.OSS.*.rpm
               ./Build-RPM-krellroot sqlite-$sqlitever
               if [ -s RPMS/$sys/sqlite.OSS.*.rpm ]; then
                  echo "SQLITE BUILT SUCCESSFULLY."
               else
                  echo "SQLITE FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                  exit
               fi
               if [ $KRELL_ROOT_PREFIX ]; then
                 export KRELL_ROOT_SQLITE=$KRELL_ROOT_PREFIX
               else
                 export KRELL_ROOT_SQLITE=/opt/KRELLROOT
               fi
               install_libsqlite=1
            else
              build_sqlite_routine
              if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libsqlite3.so -o -f $KRELL_ROOT_PREFIX/lib/x86_64-linux-gnu/libsqlite3.so ] && 
                 [ -f $KRELL_ROOT_PREFIX/include/sqlite3.h ]; then
                  export KRELL_ROOT_SQLITE=$KRELL_ROOT_PREFIX
                  echo "SQLITE BUILT SUCCESSFULLY."
              else
                  echo "SQLITE FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                  exit
              fi
            fi
          fi
        fi

        install_libmonitor=1
        if [ $skip_libmonitor_build == 1 ] && [ $force_libmonitor_build == 0 ]; then
            install_libmonitor=0
            echo "skipping libmonitor build, because it was requested not to be built..."
        else
          echo
          echo "Build libmonitor? <y/n>"
          echo
          if [ "$nanswer" = 9 -o $imode == 0 ]; then
              answer=Y
          else
              read answer
          fi
          if [ "$answer" = Y -o "$answer" = y ] && \
     	     [ $build_oss_gui_only == 0 ] || [ $build_oss_runtime_only == 1 ] ; then
            # Decide if building rpm option was used (--rpm or --create-rpm)
            if [ "$use_rpm" = 1 ] ; then
              rm -rf RPMS/$sys/libmonitor.OSS.*.rpm
              ./Build-RPM-krellroot libmonitor-$libmonitorver
              if [ -s RPMS/$sys/libmonitor.OSS.*.rpm ]; then
                  echo "LIBMONITOR BUILT SUCCESSFULLY."
                  install_libmonitor=1
              else
                  echo "LIBMONITOR FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                  exit
              fi
            else
              build_libmonitor_routine
              if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libmonitor.a -o -f $KRELL_ROOT_PREFIX/$LIBDIR/libmonitor.so ]; then
                 export KRELL_ROOT_LIBMONITOR=$KRELL_ROOT_PREFIX
                 echo "LIBMONITOR BUILT SUCCESSFULLY."
              else
                 echo "LIBMONITOR FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                 exit
              fi
            fi
          fi
        fi
        echo
      fi # only osscbtf build task
    fi

    if [ "$nanswer" = 3a  -o "$nanswer" = 9 ]; then

     # Decide if building rpm option was used (--rpm or --create-rpm)
     if [ "$use_rpm" = 1 ] ; then
      if [ "$OPENSS_BUILD_TASK" != "onlyosscbtf" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossoffline" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossonline" ] ; then

	if [ $build_oss_gui_only == 1 ] ; then
            echo "Install base Support libraries:  papi, sqlite."
	elif [ $build_oss_runtime_only == 1 ] ; then
            echo "Install base Support libraries: libunwind, papi, libmonitor, "
	else
            echo "Install base Support libraries: libunwind, papi, sqlite, "
            echo "libmonitor"
	fi
        echo "This is non-root cpio process."
        echo "Installing in /opt/KRELLROOT unless KRELL_ROOT_PREFIX set"
        echo
        if [ $KRELL_ROOT_PREFIX ]; then
            echo "Install Path:  : ", $KRELL_ROOT_PREFIX
        else
            echo "Install Path:  : /opt/KRELLROOT"
        fi

        # IF COMING IN FROM A SEPERATE INNOCATION OF INSTALL.SH THEN DETECT PAPI INSTALLATIONS
        #echo "RPMS/$sys/papi.KRELLROOT.*.rpm=RPMS/$sys/papi.KRELLROOT.*.rpm"
        if [ -z $KRELL_ROOT_PAPI ]; then
          if [ -s RPMS/$sys/papi.OSS.*.rpm ]; then
            echo "papi detected as built into RPMS/$sys/papi.OSS.*.rpm will be installed into $KRELL_ROOT_PREFIX/<lib>"
            install_libpapi=1
            echo
          fi
        else
          echo "KRELL_ROOT_PAPI is set, use this for building other components"
        fi

        # IF COMING IN FROM A SEPERATE INNOCATION OF INSTALL.SH THEN DETECT LIBELF INSTALLATIONS
        #echo "RPMS/$sys/sqlite.OSS.*.rpm=RPMS/$sys/sqlite.OSS.*.rpm"
        if [ -z $KRELL_ROOT_SQLITE ]; then
	  if [ -f RPMS/$sys/sqlite.OSS.*.rpm ]; then
            echo "sqlite detected as built into RPMS/$sys/sqlite.OSS.*.rpm will be installed into $KRELL_ROOT_PREFIX/<lib>"
            install_libsqlite=1
            echo
          fi
        else
          echo "KRELL_ROOT_SQLITE is set, use this for building other components"
        fi

        #cd RPMS/$sys
        pushd RPMS/$sys
        echo "starting RPM to cpio process..."
	if [ $skip_libunwind_build == 0 ] && [ $install_libunwind == 1 ] && [ $build_oss_gui_only == 0 ] || [ $build_oss_runtime_only == 1 ] ; then
            rpm2cpio libunwind.OSS.*.rpm > libunwind.cpio
	fi

	if [ $skip_libmonitor_build == 0 ] && [ $install_libmonitor == 1 ] && [ $build_oss_gui_only == 0 ] || [ $build_oss_runtime_only == 1 ] ; then
            rpm2cpio libmonitor.OSS.*.rpm > libmonitor.cpio
	fi

        if [ $skip_papi_build == 0 ] && [ $install_libpapi == 1 ]; then
          rpm2cpio papi.OSS.*.rpm > papi.cpio
        fi

	if [ $skip_sqlite_build == 0 ] && [ $build_oss_runtime_only == 0 -a "$install_libsqlite" = 1 ] ; then
            rpm2cpio sqlite.OSS.*.rpm > sqlite.cpio
	fi

        echo "cpio to local path install process"
        if [ $KRELL_ROOT_PREFIX ]; then
            rm -rf `pwd`/$KRELL_ROOT_PREFIX/*
        else
            rm -rf opt
        fi

	if [ $skip_libunwind_build == 0 ] && [ $install_libunwind == 1 ] && [ $build_oss_gui_only == 0 ] || [ $build_oss_runtime_only == 1 ] ; then
            cpio -id < libunwind.cpio
	fi
	if [ $skip_libmonitor_build == 0 ] && [ $install_libmonitor == 1 ] && [ $build_oss_gui_only == 0 ] || [ $build_oss_runtime_only == 1 ] ; then
            cpio -id < libmonitor.cpio
	fi

        if [ $skip_papi_build == 0 ] && [ $install_libpapi == 1 ]; then
          cpio -id < papi.cpio
	fi

	if [ $skip_sqlite_build == 0 ] && [ "$install_libsqlite" = 1 -a $build_oss_runtime_only == 0 ]; then
            cpio -id < sqlite.cpio
	fi

        if [ $skip_libunwind_build == 0 ] || [ $skip_libmonitor_build == 0 ] || [ $skip_papi_build == 0 ] || [ $skip_sqlite_build == 0 ]; then
          echo "moving files to target path..."
          if [ $KRELL_ROOT_PREFIX ]; then
            if [ -e $KRELL_ROOT_PREFIX ]; then
                echo "KRELL_ROOT_PREFIX exists"
            else
                mkdir -p $KRELL_ROOT_PREFIX
            fi
            cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
          else
              cp -r opt/* /opt
          fi
          #cd ../.. # Back out of RPMS
          popd # Back out of RPMS
        fi
      fi # only osscbtf build task
     fi # use rpm
    fi

    if [ "$nanswer" = 4  -o "$nanswer" = 9 ]; then
      if [ "$OPENSS_BUILD_TASK" != "onlyosscbtf" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossoffline" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossonline" ] ; then
       	if [ "$OPENSS_BUILD_TASK" == "offline" ]; then
	        echo "Build vampirtrace"
       	else
	        echo "Build vampirtrace and dyninst"
	fi
	echo "- steps 1,2 and 3 must be completed before this step."
        echo "  Libraries must be accessible"
        echo
#
        if [ $KRELL_ROOT_PREFIX ]; then
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
            else
              export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
            fi
            export KRELL_ROOT_DOC_DIR=$KRELL_ROOT_PREFIX/share/doc/packages/OpenSpeedShop
#        else
#            export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR
#            export KRELL_ROOT_PREFIX=/opt/OSS
#            export KRELL_ROOT_DOC_DIR=opt/OSS/share/doc/packages/OpenSpeedShop
             # set KRELL_ROOT_PREFIX to prefix to facilitate RPM build
        fi
        echo $KRELL_ROOT_PREFIX
        echo $LD_LIBRARY_PATH

#           [ $build_oss_runtime_only == 0  ]; then
             if [ "$KRELL_ROOT_TARGET_ARCH" != "mic" ] && \
                [ "$OPENSS_BUILD_TASK" == "mrnet" -o "$OPENSS_BUILD_TASK" == "cbtf" -o \
                  "$OPENSS_BUILD_TASK" == "offline" -o "$OPENSS_BUILD_TASK" == "krellroot" ] ; then
                echo "Build boost? <y/n>"
                echo
                if [ "$nanswer" = 9 -o $imode == 0 ]; then
                    answer=Y
                else
                    read answer
                fi

                if [ "$answer" = Y -o "$answer" = y ] && [ $skip_boost_build == 0 ] ; then

                  # First check if boost is USER specifed
                  # It must pass the check of a few of the need libs and includes
                  # and then must be the correct, required version level

                  found_good_boost=0
                  if test -f $KRELL_ROOT_BOOST/include/boost/regex.hpp &&  \
                           [ -f $KRELL_ROOT_BOOST/$ALTLIBDIR/libboost_serialization.so -o  \
                             -f $KRELL_ROOT_BOOST/$ALTLIBDIR/libboost_serialization-mt.so -o \
                             -f $KRELL_ROOT_BOOST/$LIBDIR/libboost_serialization.so -o  \
                             -f $KRELL_ROOT_BOOST/$LIBDIR/libboost_serialization-mt.so ] && \
                           [ -f $KRELL_ROOT_BOOST/$ALTLIBDIR/libboost_program_options.so -o  \
                             -f $KRELL_ROOT_BOOST/$ALTLIBDIR/libboost_program_options-mt.so -o \
                             -f $KRELL_ROOT_BOOST/$LIBDIR/libboost_program_options.so -o  \
                             -f $KRELL_ROOT_BOOST/$LIBDIR/libboost_program_options-mt.so ] && \
                           [ -f $KRELL_ROOT_BOOST/$ALTLIBDIR/libboost_unit_test_framework.so -o  \
                             -f $KRELL_ROOT_BOOST/$ALTLIBDIR/libboost_unit_test_framework-mt.so -o \
                             -f $KRELL_ROOT_BOOST/$LIBDIR/libboost_unit_test_framework.so -o  \
                             -f $KRELL_ROOT_BOOST/$LIBDIR/libboost_unit_test_framework-mt.so ] && \
                           [ -f $KRELL_ROOT_BOOST/$ALTLIBDIR/libboost_filesystem.so -o  \
                             -f $KRELL_ROOT_BOOST/$ALTLIBDIR/libboost_filesystem-mt.so -o \
                             -f $KRELL_ROOT_BOOST/$LIBDIR/libboost_filesystem.so -o  \
                             -f $KRELL_ROOT_BOOST/$LIBDIR/libboost_filesystem-mt.so ] ; then
                    if [ -f $KRELL_ROOT_BOOST/include/boost/version.hpp ]; then
                       BOOSTVER=`grep "define BOOST_VERSION " $KRELL_ROOT_BOOST/include/boost/version.hpp`
                       echo "KRELL_ROOT_BOOST, BOOSTVER=$BOOSTVER"
                       POS1=`expr index "$BOOSTVER" "10"`
                       POS2=`expr $POS1 + 2`
                       VERS=`expr substr "$BOOSTVER" "$POS2" 2`
                       #echo "POS1=$POS1"
                       #echo "POS2=$POS2"
                       #echo "VERS=$VERS"
                       if test "$VERS" -gt 49; then
                         echo "BOOST FOUND VERS=$VERS, no need to build boost"
                         found_good_boost=1
                       else
                         found_good_boost=0
                       fi
                    else
                       found_good_boost=0
                    fi
                  fi

                  # Second, if not found in the USER specified path check if the /usr specifed boost is ok
                  # It must pass the check of a few of the need libs and includes
                  # and then must be the correct, required version level

                  if [ $found_good_boost == 0 ] &&  \
                        [ -f /usr/include/boost/regex.hpp ] &&  \
                          [ -f /usr/$LIBDIR/libboost_system.so -o  \
                            -f /usr/lib/x86_64-linux-gnu/libboost_system.so -o \
                            -f /usr/lib/x86_64-linux-gnu/libboost_system-mt.so -o \
                            -f /usr/$ALTLIBDIR/libboost_system.so -o  \
                            -f /usr/$ALTLIBDIR/libboost_system-mt.so -o  \
                            -f /usr/$LIBDIR/libboost_system-mt.so ] && \
                          [ -f /usr/$LIBDIR/libboost_program_options.so -o  \
                            -f /usr/lib/x86_64-linux-gnu/libboost_program_options.so -o \
                            -f /usr/lib/x86_64-linux-gnu/libboost_program_options-mt.so -o \
                            -f /usr/$ALTLIBDIR/libboost_program_options.so -o  \
                            -f /usr/$ALTLIBDIR/libboost_program_options-mt.so -o  \
                            -f /usr/$LIBDIR/libboost_program_options-mt.so ] && \
                          [ -f /usr/$LIBDIR/libboost_unit_test_framework.so -o  \
                            -f /usr/lib/x86_64-linux-gnu/libboost_unit_test_framework.so -o \
                            -f /usr/lib/x86_64-linux-gnu/libboost_unit_test_framework-mt.so -o \
                            -f /usr/$ALTLIBDIR/libboost_unit_test_framework.so -o  \
                            -f /usr/$ALTLIBDIR/libboost_unit_test_framework-mt.so -o  \
                            -f /usr/$LIBDIR/libboost_unit_test_framework-mt.so ] && \
                          [ -f /usr/$LIBDIR/libboost_filesystem.so -o  \
                            -f /usr/lib/x86_64-linux-gnu/libboost_filesystem.so -o \
                            -f /usr/lib/x86_64-linux-gnu/libboost_filesystem-mt.so -o \
                            -f /usr/$ALTLIBDIR/libboost_filesystem.so -o  \
                            -f /usr/$ALTLIBDIR/libboost_filesystem-mt.so -o  \
                            -f /usr/$LIBDIR/libboost_filesystem-mt.so ]  ; then
                    if [ -f /usr/include/boost/version.hpp ]; then
                       BOOSTVER=`grep "define BOOST_VERSION " /usr/include/boost/version.hpp`
                       #echo "BOOSTVER=$BOOSTVER"
                       POS1=`expr index "$BOOSTVER" "10"`
                       POS2=`expr $POS1 + 2`
                       VERS=`expr substr "$BOOSTVER" "$POS2" 2`
                       #echo "POS1=$POS1"
                       #echo "POS2=$POS2"
                       #echo "VERS=$VERS"
                       if test "$VERS" -gt 49 && [ $force_boost_build == 0 ]; then
                         echo "BOOST FOUND VERS=$VERS, no need to build boost"
                         found_good_boost=1
                       else
                         found_good_boost=0
                       fi
                    else
                       found_good_boost=0
                    fi
                  fi

                  if [ $found_good_boost == 0 ] ; then

                     if [ "$OPENSS_BUILD_TASK" == "offline" ] ; then
                         build_boost_routine 1
                      else 
                         build_boost_routine 0
                     fi
                  fi

                fi

       	        if [ "$OPENSS_BUILD_TASK" == "krellroot" ] || \
                   [ "$OPENSS_BUILD_TASK" == "cbtf" ] && \
#                   [ $build_oss_runtime_only == 0  ] && \
                   [ "$KRELL_ROOT_TARGET_ARCH" != "mic" ] && \
                   [ $skip_xercesc_build == 0 ]; then
                  echo "Build xercesc? <y/n>"
                  echo
                  if [ "$nanswer" = 9 -o $imode == 0 ]; then
                      answer=Y
                  else
                      read answer
                  fi
                  if [ "$answer" = Y -o "$answer" = y ] ; then
                   if [ -f /usr/include/xercesc/dom/DOM.hpp ] && \
                      [ -f /usr/lib64/libxerces-c.so -o -f /usr/lib/libxerces-c.so -o /usr/lib/x86_64-linux-gnu/libxerces-c.so ] ; then
                        echo "XERCESC ALREADY INSTALLED, skipping build."
                        export KRELL_ROOT_XERCESC=/usr
                   else
                    build_xercesc_routine
                    if [ -f $KRELL_ROOT_PREFIX/include/xercesc/util/XercesVersion.hpp ] && \
                       [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libxerces-c.so -o $KRELL_ROOT_PREFIX/$ALTLIBDIR/libxerces-c.so ]; then
                       export KRELL_ROOT_XERCESC=$KRELL_ROOT_PREFIX
                       echo "XERCESC BUILT SUCCESSFULLY."

                    else
                       echo "XERCESC FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                       exit
                    fi
                   fi
                  fi
                fi
        fi

        echo
        echo "Build vampirtrace? <y/n>"
        echo

        if [ "$nanswer" = 9 -o $imode == 0 ]; then
            answer=Y
        else
            read answer
        fi
        if [ "$answer" = Y -o "$answer" = y ] && \
	    [ $skip_vampirtrace == 0 ] && [ $build_oss_gui_only == 0 ] && [ $build_oss_runtime_only == 0 ] ; then
            if [ $KRELL_ROOT_MPI_OPENMPI ]; then
                export KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_OPENMPI
                export KRELL_ROOT_MPI_LIB_LINE="-lmpi"
            elif [  $KRELL_ROOT_MPI_MPICH ]; then
                export KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_MPICH
                export KRELL_ROOT_MPI_LIB_LINE="-lmpich"
            elif [  $KRELL_ROOT_MPI_MPICH2 ]; then
                export KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_MPICH2
                export KRELL_ROOT_MPI_LIB_LINE="-lmpich"
            elif [  $KRELL_ROOT_MPI_MVAPICH ]; then
                export KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_MVAPICH
                export KRELL_ROOT_MPI_LIB_LINE="-lmpich"
            elif [  $KRELL_ROOT_MPI_MVAPICH2 ]; then
                export KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_MVAPICH2
                export KRELL_ROOT_MPI_LIB_LINE="-lmpich"
            elif [  $KRELL_ROOT_MPI_MPT ]; then
                export KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_MPT
                export KRELL_ROOT_MPI_LIB_LINE="-lmpi"
            elif [  $KRELL_ROOT_MPI_LAM ]; then
                export KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_LAM
                export KRELL_ROOT_MPI_LIB_LINE="-lmpi"
            elif [  $KRELL_ROOT_MPI_LAMPI ]; then
                echo "LAMPI cannot be used for vampirtrace build"
            fi
            echo "KRELL_ROOT_MPI_PATH=$KRELL_ROOT_MPI_PATH"
            
            if [ $KRELL_ROOT_MPI_PATH ]; then
             # Decide if building rpm option was used (--rpm or --create-rpm)
             if [ "$use_rpm" = 1 ] ; then
                rm -rf RPMS/$sys/vampirtrace.OSS.*.rpm
                ./Build-RPM-krellroot vampirtrace-$vampirtracever
                if [ -s RPMS/$sys/vampirtrace.OSS.*.rpm ]; then
                    echo "VAMPIRTRACE BUILT SUCCESSFULLY."
                else
                    if [ -f $KRELL_ROOT_VAMPIRTRACE/include/vt_user.h -a -f $KRELL_ROOT_VAMPIRTRACE/$LIBDIR/libvt.a ]; then
                        echo "VAMPIRTRACE FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                        # Do not exit now, because this version is old and is not in sync with MPI-3, it fails to 
                        # build on some platforms, with OSS we just will not see the mpiotf collector, but otherwise
                        # no negative effects.
                        #exit
                    fi
                fi
             else
              #export KRELL_ROOT_LIBDWARF=/opt/junk
              build_vampirtrace_routine
              if [ -f $KRELL_ROOT_VAMPIRTRACE/include/vt_user.h -a -f $KRELL_ROOT_VAMPIRTRACE/$LIBDIR/libvt.a ]; then
                  echo "VAMPIRTRACE BUILT SUCCESSFULLY."
              else
                  echo "VAMPIRTRACE FAILED TO BUILD.  Please check for errors."
              fi
             fi
            else
                echo "vampirtrace cannot be built - "
                echo "must identify an MPI implementation"
            fi
        fi

	echo "Build dyninst? <y/n>"
	echo
	if [ "$nanswer" = 9 -o $imode == 0 ]; then
	    answer=Y
	else
	    read answer
	fi

	echo "Dyninst build, BEFORE CHECKS."
        if [ "$KRELL_ROOT_TARGET_ARCH" == "mic" ] ; then
	       skip_dyninst_build=1
	       echo "SKIPPING Dyninst build, Dyninst not required for the Intel MIC compute nodes."
        elif [ $build_dyninst_by_default == 1 ] && [ $skip_dyninst_build != 1 ]; then
	    echo "Building dyninst due to default setting."
        elif [ $force_dyninst_build == 0 ] && \
	   [ -f /usr/$LIBDIR/dyninst/libdyninstAPI.so ] && [ -f /usr/include/dyninst/BPatch_module.h ] ; then
	       skip_dyninst_build=1
	       echo "SKIPPING Dyninst build, Dyninst found in /usr/$LIBDIR."
        elif [ $force_dyninst_build == 0 ] && \
	     [ -f /$KRELL_ROOT_DYNINST/$LIBDIR/libdyninstAPI.so ] && [ -f $KRELL_ROOT_DYNINST/include/dyninst/BPatch_module.h ]; then
	       skip_dyninst_build=1
	       echo "SKIPPING Dyninst build, Dyninst found in $KRELL_ROOT_DYNINST/$LIBDIR."
	fi

	if [ "$answer" = Y -o "$answer" = y ] && [ $skip_dyninst_build == 0 ] && \
           [ $build_oss_gui_only == 0 ]  ; then
           #[ $build_oss_gui_only == 0 ] && [ $build_oss_runtime_only == 0 ] ; then
#       If there is an buildtask specified and it is mrnet then use the latest
#       dyninst version, else use 5.1r.  By default if OPENSS_BUILD_TASK is not
#       set choose to build mrnet version also
#

           # Decide if building rpm option was used (--rpm or --create-rpm)
           if [ "$use_rpm" = 1 ] ; then
	        if [ "$OPENSS_BUILD_TASK" == "mrnet" ]; then
                    rm -rf RPMS/$sys/dyninst.OSS.*.rpm
	     .       /Build-RPM-krellroot dyninst-$dyninstver
       	        elif [ "$OPENSS_BUILD_TASK" == "krellroot" ] || \
                     [ "$OPENSS_BUILD_TASK" == "offline" ]  || \
                     [ "$OPENSS_BUILD_TASK" == "cbtf" ] ; then
                    rm -rf RPMS/$sys/dyninst.OSS.*.rpm
	            ./Build-RPM-krellroot dyninst-$dyninstver
		else 
                    rm -rf RPMS/$sys/dyninst.OSS.*.rpm
	            ./Build-RPM-krellroot dyninst-$dyninstver
		fi
                if [ -s RPMS/$sys/dyninst.OSS.*.rpm ]; then
                    echo "DYNINST BUILT SUCCESSFULLY."
                else
                    echo "DYNINST FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors.  sys=$sys"
                    exit
                fi
           else
           # No rpm build option was used (--no-rpm or no rpm specification at all)
               build_dyninst_routine
               if [ -f $KRELL_ROOT_PREFIX/include/dyninst/BPatch.h -a -f $KRELL_ROOT_PREFIX/$LIBDIR/libsymtabAPI.so ]; then
                  export KRELL_ROOT_DYNINST=$KRELL_ROOT_PREFIX
                  echo "DYNINST BUILT SUCCESSFULLY into $KRELL_ROOT_DYNINST."
               else
                  echo "DYNINST FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                  exit
               fi
           fi
        else
           echo "SKIPPING Dyninst build, multiple checks including:skip_dyninst_build, build_oss_gui_only, build_oss_runtime_only ."
	fi
      fi # only osscbtf build task
    fi # nanswer 4
#
    # Decide if building rpm option was used (--rpm or --create-rpm)
    if [ "$use_rpm" = 1 ] ; then
     if [ "$nanswer" = 4a  -o "$nanswer" = 9 ] && \
	    [ $build_oss_gui_only == 0 ] || [ $build_oss_runtime_only == 1 ] ; then
      if [ "$OPENSS_BUILD_TASK" != "onlyosscbtf" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossoffline" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossonline" ] ; then

       	if [ "$OPENSS_BUILD_TASK" == "offline" ]; then
	        echo "Install vampirtrace"
	else
	        echo "Install vampirtrace and dyninst"
	fi
        echo "- steps 1 and 2 must be completed before this step."
        echo "  Libraries must be accessible"
        echo "This is non-root cpio process."
        echo "Installing in /opt/OSS unless KRELL_ROOT_PREFIX set"
        echo

        #cd RPMS/$sys
        pushd RPMS/$sys
        echo "starting RPM to cpio process..."
        if [ $skip_vampirtrace == 0 ] && [ -f vampirtrace.OSS.*.rpm ]; then
            rpm2cpio vampirtrace.OSS.*.rpm > vampirtrace.cpio
        fi

        if [ "$OPENSS_BUILD_TASK" == "krellroot" ] || \
             [ "$OPENSS_BUILD_TASK" == "offline" ] || \
             [ "$OPENSS_BUILD_TASK" == "cbtf" ] ; then
		if [ $skip_dyninst_build == 0 ] && [ $build_oss_runtime_only == 0 ]; then
	            rpm2cpio dyninst.OSS.*.rpm > dyninst.cpio
	            echo "cpio to local path install process"
	            rm -rf opt
		fi
       	elif [ "$OPENSS_BUILD_TASK" == "mrnet" ]; then
		if [ $skip_dyninst_build == 0 ] && [ $build_oss_runtime_only == 0 ]; then
	            rpm2cpio dyninst.OSS.*.rpm > dyninst.cpio
	            echo "cpio to local path install process"
	            rm -rf opt
		fi
	fi
#
        if [ $skip_vampirtrace == 0 ] && [ -f vampirtrace.OSS.*.rpm ]; then
            cpio -id < vampirtrace.cpio
            echo "installing vampirtrace..."
            echo "moving files to target path: "
            if [ $KRELL_ROOT_PREFIX ]; then
              #cp -r opt/OSS/* $KRELL_ROOT_PREFIX
              cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
              echo "copying from opt/OSS/* to $KRELL_ROOT_PREFIX"
            else
              cp -r opt/* /opt
              echo "copying from opt/* to /opt/OSS"
            fi
        fi
        if [ "$OPENSS_BUILD_TASK" == "krellroot" ] || \
             [ "$OPENSS_BUILD_TASK" == "offline" ] || \
             [ "$OPENSS_BUILD_TASK" == "cbtf" ] ; then
		if [ $skip_dyninst_build == 0 ] && [ $build_oss_runtime_only == 0 ]; then
	            cpio -id < dyninst.cpio
	            echo "installing dyninst..."
		fi
       	elif [ "$OPENSS_BUILD_TASK" == "mrnet" ]; then
		if [ $skip_dyninst_build == 0 ] && [ $build_oss_runtime_only == 0 ]; then
	            cpio -id < dyninst.cpio
	            echo "installing dyninst..."
		fi
	fi
        echo "moving files to target path: "
        if [ $KRELL_ROOT_PREFIX ]; then
            if [ -e $KRELL_ROOT_PREFIX ]; then
                echo "KRELL_ROOT_PREFIX exists"
            else
                mkdir -p $KRELL_ROOT_PREFIX
            fi
            if [ "$OPENSS_BUILD_TASK" == "krellroot" ] || \
                 [ "$OPENSS_BUILD_TASK" == "offline" ]  || \
                 [ "$OPENSS_BUILD_TASK" == "cbtf" ] ; then
	      if [ $skip_dyninst_build == 0 ] && [ $build_oss_runtime_only == 0 ]; then
                echo "dyninstvers = $dyninstver"
                cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
                echo "copying from `pwd`$KRELL_ROOT_PREFIX to $KRELL_ROOT_PREFIX"
              fi
       	    elif [ "$OPENSS_BUILD_TASK" == "mrnet" ]; then
	      if [ $skip_dyninst_build == 0 ] && [ $build_oss_runtime_only == 0 ]; then
                echo "dyninstvers = $dyninstver"
                cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
                echo "copying from `pwd`$KRELL_ROOT_PREFIX to $KRELL_ROOT_PREFIX"
              fi
            fi
        else
	    if [ $skip_dyninst_build == 0 ] && [ $build_oss_runtime_only == 0 ]; then
              cp -r opt/* /opt
              echo "copying from opt/* to /opt/OSS"
            fi
        fi
        #cd ../.. # Back out of RPMS
        popd  # Back out of RPMS

      fi # only osscbtf build task
     fi
    fi # use_rpm

    if [ "$nanswer" = 5  -o "$nanswer" = 9 ] && \
	[ $skip_mrnet_build == 0 ] && \
	#[ $build_oss_gui_only == 0 ] && [ $build_oss_runtime_only == 0 ]; then 
	[ $build_oss_gui_only == 0 ] ; then 

      if [ "$OPENSS_BUILD_TASK" != "onlyosscbtf" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossoffline" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossonline" ] ; then

	if [ "$OPENSS_BUILD_TASK" == "mrnet" ] || \
           [ "$OPENSS_BUILD_TASK" == "cbtf" ] || \
           [ "$OPENSS_BUILD_TASK" == "krellroot" ]; then
		echo "Build mrnet"
       	elif [ "$OPENSS_BUILD_TASK" == "offline" ]; then
		echo "No need to build mrnet"
        else
		echo "Build mrnet"
	        echo "- steps 1,2,3 and 4 must be completed before this step."
	        echo "  Libraries must be accessible"
        fi
        echo
        if [ $KRELL_ROOT_PREFIX ]; then
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
            else
              export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
            fi
        else
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR
            else
              export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR:$LD_LIBRARY_PATH
            fi
            export KRELL_ROOT_PREFIX=/opt/OSS
            # set KRELL_ROOT_PREFIX to prefix to facilitate RPM build
        fi

#       If there is an buildtask specified and it is mrnet then use the latest
#       dyninst version. 
	if [ "$OPENSS_BUILD_TASK" == "mrnet" ] || \
           [ "$OPENSS_BUILD_TASK" == "cbtf" ] || \
           [ "$OPENSS_BUILD_TASK" == "krellroot" ]; then
        	echo "Build mrnet? <y/n>"
        	echo
        	if [ "$nanswer" = 9 -o $imode == 0 ]; then
            		answer=Y
        	else
            		read answer
        	fi
        	if [ "$answer" = Y -o "$answer" = y ]; then
                 # Decide if building rpm option was used (--rpm or --create-rpm)
                 if [ "$use_rpm" = 1 ] ; then
                   rm -rf RPMS/$sys/mrnet.OSS.*.rpm 
            	   ./Build-RPM-krellroot mrnet-$mrnetver
                   if [ -s RPMS/$sys/mrnet.OSS.*.rpm ]; then
                       echo "MRNet BUILT SUCCESSFULLY."
                   else
                       echo "MRNet FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                       exit
                   fi
                 else
                    build_mrnet_routine 
                    if [ -f $KRELL_ROOT_PREFIX/include/mrnet_lightweight/MRNet.h -a -f $KRELL_ROOT_PREFIX/$LIBDIR/libmrnet_lightweight_r.so ]; then
                       export KRELL_ROOT_MRNET_PREFIX=$KRELL_ROOT_PREFIX
                       echo "MRNET BUILT SUCCESSFULLY into $KRELL_ROOT_MRNET."
                    else
                       echo "MRNET FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                       exit
                    fi
                 fi
        	fi
	elif [ "$OPENSS_BUILD_TASK" == "offline" ]; then
        	echo
      	else
        	echo "Build mrnet? <y/n>"
        	echo
        	if [ "$nanswer" = 9 -o $imode == 0 ]; then
            		answer=Y
        	else
            		read answer
        	fi
        	if [ "$answer" = Y -o "$answer" = y ]; then
                 # Decide if building rpm option was used (--rpm or --create-rpm)
                 if [ "$use_rpm" = 1 ] ; then
                   rm -rf RPMS/$sys/mrnet.OSS.*.rpm 
            	   ./Build-RPM-krellroot mrnet-$mrnetver
                   if [ -s RPMS/$sys/mrnet.OSS.*.rpm ]; then
                       echo "MRNet BUILT SUCCESSFULLY."
                   else
                       echo "MRNet FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                       exit
                   fi
                 else
                    build_mrnet_routine 
                    if [ -f $KRELL_ROOT_PREFIX/include/mrnet_lightweight/MRNet.h -a -f $KRELL_ROOT_PREFIX/$LIBDIR/libmrnet_lightweight_r.so ]; then
                       export KRELL_ROOT_MRNET_PREFIX=$KRELL_ROOT_PREFIX
                       echo "MRNET BUILT SUCCESSFULLY into $KRELL_ROOT_MRNET."
                    else
                       echo "MRNET FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                       exit
                    fi
                 fi
        	fi
       	fi
      fi # only osscbtf build task
    fi # nanswer

    # Decide if building rpm option was used (--rpm or --create-rpm)
    if [ "$use_rpm" = 1 ] ; then
     if [ "$nanswer" = 5a  -o "$nanswer" = 9 ] && \
	[ $skip_mrnet_build == 0 ] && \
	[ $build_oss_gui_only == 0 ] && [ $build_oss_runtime_only == 0 ]; then

      if [ "$OPENSS_BUILD_TASK" != "onlyosscbtf" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossoffline" ] && \
         [ "$OPENSS_BUILD_TASK" != "onlyossonline" ] ; then

	if [ "$OPENSS_BUILD_TASK" == "mrnet" ] || \
           [ "$OPENSS_BUILD_TASK" == "cbtf" ] || \
           [ "$OPENSS_BUILD_TASK" == "krellroot" ]; then
        	echo "Install mrnet"
	elif [ "$OPENSS_BUILD_TASK" == "offline" ]; then
        	echo
        else
        	echo "Install mrnet"
        fi
        echo "- steps 1,2,3 and 4 must be completed before this step."
        echo "Libraries must be accessible"
        echo "This is non-root cpio process."
        echo "Installing in /opt/OSS unless KRELL_ROOT_PREFIX set"
        echo
        #cd RPMS/$sys
        pushd RPMS/$sys
        echo "starting RPM to cpio process..."
	if [ "$OPENSS_BUILD_TASK" == "mrnet" ] || \
           [ "$OPENSS_BUILD_TASK" == "cbtf" ] || \
           [ "$OPENSS_BUILD_TASK" == "krellroot" ]; then
        	if [ -f mrnet.OSS.*.rpm ]; then
            		rpm2cpio mrnet.OSS.*.rpm > mrnet.cpio
        	fi
	elif [ "$OPENSS_BUILD_TASK" == "offline" ]; then
        	echo
	else
        	if [ -f mrnet.OSS.*.rpm ]; then
            		rpm2cpio mrnet.OSS.*.rpm > mrnet.cpio
        	fi
	fi
        echo "starting cpio to local path install process..."
        rm -rf opt
	if [ "$OPENSS_BUILD_TASK" == "mrnet" ] || \
           [ "$OPENSS_BUILD_TASK" == "cbtf" ] || \
           [ "$OPENSS_BUILD_TASK" == "krellroot" ]; then
        	if [ -f mrnet.OSS.*.rpm ]; then
            		cpio -id < mrnet.cpio
            	echo "installing mrnet..."
       		fi
	elif [ "$OPENSS_BUILD_TASK" == "offline" ]; then
        	echo
	else
        	if [ -f mrnet.OSS.*.rpm ]; then
            		cpio -id < mrnet.cpio
            	echo "installing mrnet..."
       		fi
	fi
        echo "moving files to target path: "
        if [ $KRELL_ROOT_PREFIX ]; then
            cp -r `pwd`/$KRELL_ROOT_PREFIX/* $KRELL_ROOT_PREFIX
            echo "copying from `pwd`$KRELL_ROOT_PREFIX to $KRELL_ROOT_PREFIX"
            #cp -r opt/OSS/* $KRELL_ROOT_PREFIX
            #echo $KRELL_ROOT_PREFIX
        else
            cp -r opt/* /opt
            echo "/opt/OSS"
        fi
        #cd ../.. # Back out of RPMS
        popd  # Back out of RPMS
      fi # only osscbtf build task
     fi # nanswer
    fi # use_rpm

    echo "--------------------- PTGF BUILD ---------------------------"
    echo "--------------------- PTGF BUILD ---------------------------"
    echo "--------------------- PTGF BUILD ---------------------------"
    echo "force_ptgf_build= $force_ptgf_build"
    echo "only_build_ptgf= $only_build_ptgf"
    echo "OPENSS_BUILD_TASK= $OPENSS_BUILD_TASK"
    echo "build_oss_runtime_only= $build_oss_runtime_only"
    echo "nanswer= $nanswer"
    echo "--------------------- PTGF BUILD ---------------------------"
    echo "--------------------- PTGF BUILD ---------------------------"
    echo "--------------------- PTGF BUILD ---------------------------"

    if [ $force_ptgf_build != 0 -o $only_build_ptgf == 1 -o $build_ptgf_by_default == 1 ]; then
    # Build ptgf 
      if [ "$OPENSS_BUILD_TASK" == "krellroot" ] || \
         [ "$OPENSS_BUILD_TASK" == "offline" ] ; then
        if [ "$nanswer" = 6  -o "$nanswer" = 9 ] && [ $build_oss_runtime_only == 0 ]; then 
            export KRELL_ROOT_PTGF_ROOT=$KRELL_ROOT_PREFIX
            build_ptgf_routine
            export KRELL_ROOT_QCUSTOMPLOT_ROOT=$KRELL_ROOT_PREFIX
            build_qcustomplot_routine
            #export KRELL_ROOT_GRAPHVIZ_ROOT=$KRELL_ROOT_PREFIX
            #build_qgraphviz_routine
            #export KRELL_ROOT_PTGFOSSGUI_ROOT=$KRELL_ROOT_PREFIX
            #build_ptgfossgui_routine
        fi # nanswer
      fi # build_task
    fi # force ptgf build

    if [ $only_build_ptgf == 0 ]; then
      # Build qt3 for old GUI support
      if [ "$OPENSS_BUILD_TASK" == "krellroot" ] || \
         [ "$OPENSS_BUILD_TASK" == "offline" ] ; then
        if [ "$nanswer" = 6  -o "$nanswer" = 9 ] && [ $build_oss_runtime_only == 0 ]; then 
          if [ $force_qt3_build == 0 -a -f ${KRELL_ROOT_QT3}/lib/libqui.so.1.0 -a \
                -f ${KRELL_ROOT_QT3}/bin/qmake -a -f ${KRELL_ROOT_QT3}/include/qt.h ] ; then
                 echo "Qt version 3 detected in $KRELL_ROOT_QT3, Qt will not be built..."
                 install_qt3=0
          elif [ $force_qt3_build == 0 -a -f /usr/$LIBDIR/qt-3.3/lib/libqui.so.1.0 -a \
                -f /usr/$LIBDIR/qt-3.3/bin/qmake -a -f /usr/$LIBDIR/qt-3.3/include/qt.h ] ; then
                 echo "Qt version 3 detected in /usr/$LIBDIR/qt-3.3, Qt will not be built..."
                 install_qt3=0
          elif [ $force_qt3_build == 0 -a -f /usr/$LIBDIR/qt3/bin/qmake -a  \
                 -f /usr/$LIBDIR/qt3/lib/libqui.so.1.0 -a  \
                 -f /usr/$LIBDIR/qt3/include/qt.h ] ; then
                 echo "Qt version 3 detected in /usr/$LIBDIR/qt3, Qt will not be built..."
                 install_qt3=0
          elif [ $force_qt3_build == 0 -a -f /usr/bin/qmake -a  \
                 -f /usr/$LIBDIR/libqui.so.1.0 -a  \
                 -f /usr/include/qt3/qassistantclient.h -a  \
                 -f /usr/include/qt3/qt.h ] ; then
                 echo "Qt version 3 detected in /usr/include/qt3 and /usr/$LIBDIR, Qt will not be built..."
               install_qt3=0
          else
            echo "Build Qt version 3"
            echo
            if [ $KRELL_ROOT_PREFIX ]; then
                if [ -z $LD_LIBRARY_PATH ]; then 
                  export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
                else
                  export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
                fi
            else
                if [ -z $LD_LIBRARY_PATH ]; then 
                  export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR
                else
                  export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR:$LD_LIBRARY_PATH
                fi
                export KRELL_ROOT_PREFIX=/opt/OSS
                # set KRELL_ROOT_PREFIX to prefix to facilitate RPM build
            fi

            echo
            echo "Build Qt version 3? <y/n>"
            echo
            if [ "$nanswer" = 9 -o $imode == 0 ]; then
                answer=Y
            else
                read answer
            fi
            if [ "$answer" = Y -o "$answer" = y ]; then
              # Decide if building rpm option was used (--rpm or --create-rpm)
              if [ "$use_rpm" = 1 ] ; then
                rm -rf RPMS/$sys/qt-x11-free.OSS.*.rpm
                ./Build-RPM-krellroot qt-x11-free-$qtver
                if [ -s RPMS/$sys/qt-x11-free.OSS.*.rpm ]; then
                    echo "QT3 BUILT SUCCESSFULLY."
                    install_qt3=1
                else
                    echo "QT3 FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                    #exit
                fi
              else
                 build_qt3_routine
                 if [ -f $KRELL_ROOT_PREFIX/qt3/lib/libqui.so.1.0.0 -o -f $KRELL_ROOT_PREFIX/qt3/$LIBDIR/libqui.so.1.0.0 ] && \
                    [ -f $KRELL_ROOT_PREFIX/qt3/bin/qmake -a -f $KRELL_ROOT_PREFIX/qt3/include/qassistantclient.h -a -f $KRELL_ROOT_PREFIX/qt3/include/qt.h ] ; then 
                    export KRELL_ROOT_QT3=${KRELL_ROOT_PREFIX}
                    echo "QT3 BUILT SUCCESSFULLY."
                    # qt3 already installed via build script
                    install_qt3=0
                else
                    echo "QT3 FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                    #exit
                fi
              fi # use_rpm
            fi # answer check
            echo
          fi # force checks
        fi # nanswer check
      fi # build_task check
    fi # not only ptgf, build qt3, if needed

    if [ $only_build_ptgf == 1 ]; then
      echo "The install of ptgf was already done in step 6."
    else
     # Decide if building rpm option was used (--rpm or --create-rpm)
     if [ "$use_rpm" = 1 ] ; then
      if [ "$nanswer" = 6a -o "$nanswer" = 9 -a "$install_qt3" = 1 ] && [ $build_oss_runtime_only == 0 ]; then
        if [ "$OPENSS_BUILD_TASK" != "onlyosscbtf" ] && \
           [ "$OPENSS_BUILD_TASK" != "onlyossoffline" ] && \
           [ "$OPENSS_BUILD_TASK" != "onlyossonline" ] ; then

          # IF COMING IN FROM A SEPERATE INNOCATION OF INSTALL.SH THEN DETECT QT3 INSTALLATIONS
          echo "RPMS/$sys/qt-x11-free.OSS.*.rpm=RPMS/$sys/qt-x11-free.OSS.*.rpm"
          if [ -f RPMS/$sys/qt-x11-free.OSS.*.rpm ]; then
            echo "qt3 detected as built into RPMS/$sys/qt-x11-free.OSS.*.rpm will be installed into $KRELL_ROOT_PREFIX/<lib>"
            install_qt3=1
            echo
          fi

          if [ $install_qt3 == 1 ]; then
            echo "Install Qt"
            echo "This is non-root cpio process."
            echo "Installing in /opt/OSS unless KRELL_ROOT_PREFIX set"
            echo
            #cd RPMS/$sys
            pushd RPMS/$sys
            echo "starting RPM to cpio process..."
            rpm2cpio qt-x11-free.OSS.*.rpm > qt.cpio
            echo "starting cpio to local path install process..."
            rm -rf opt
            cpio -id < qt.cpio
            echo "installing Qt..."
            echo "moving files to target path: "
            if [ $KRELL_ROOT_PREFIX ]; then
                #cp -r opt/OSS/qt3 $KRELL_ROOT_PREFIX/.
                cp -r `pwd`/$KRELL_ROOT_PREFIX $KRELL_ROOT_PREFIX/qt3
                echo "QTDIR=$KRELL_ROOT_PREFIX/qt3"
                export QTDIR=$KRELL_ROOT_PREFIX/qt3
            else
                cp -r opt/OSS/qt3 /opt/OSS/.
                echo "QTDIR= /opt/OSS/qt3"
                export QTDIR=/opt/OSS/qt3
            fi
            # Back out of RPMS
            #cd ../..
            popd 
          fi # install check
        fi # build_task
      fi # nanswer check
     fi # use_rpm
    fi # else only ptgf, no qt3

    if [ "$OPENSS_BUILD_TASK" == "cbtf" ] ; then
      if  [ "$nanswer" == 6b -o "$nanswer" == 9 ] ; then
            echo "Before Build CBTF"

            #if (! test -z $SYSROOT_DIR); then
            #   # If on a cray, need to make the libalps.so file visable, there is no module, at least on titan at ORNL
            #   export LD_LIBRARY_PATH=/opt/cray/xe-sysroot/default/usr/lib/alps:$LD_LIBRARY_PATH
            #fi

            build_cbtf_routine
            echo "After Build CBTF"
            build_cbtf_krell_routine
            echo "After Build CBTF-KRELL"
            if [ "$KRELL_ROOT_TARGET_ARCH" != "mic" ]; then
              build_cbtf_argonavis_routine
              echo "After Build CBTF-ARGONAVIS"
              build_cbtf_lanl
              echo "After Build CBTF-LANL"
            fi
      fi
    fi

    if [ "$OPENSS_BUILD_TASK" != "krellroot" ] ; then
      # Set the correct instrumentor for the build task being asked for
      if [ "$OPENSS_BUILD_TASK" == "onlyosscbtf" ] ; then

         export OPENSS_INSTRUMENTOR=cbtf 

         if [ $KRELL_ROOT_XERCESC ]; then
	   echo "Using KRELL_ROOT_XERCESC=$KRELL_ROOT_XERCESC"
           if [ -f $KRELL_ROOT_PREFIX/include/xercesc/util/XercesVersion.hpp -a \
                -f $KRELL_ROOT_PREFIX/$LIBDIR/libxerces-c.so ]; then
               echo "XERCESC DETECTED IN KRELL_ROOT_PREFIX."
               export LD_LIBRARY_PATH=$KRELL_ROOT_XERCESC/$LIBDIR:$LD_LIBRARY_PATH
               export KRELL_ROOT_XERCESC=$KRELL_ROOT_PREFIX
           elif [ -f $KRELL_ROOT_PREFIX/include/xercesc/util/XercesVersion.hpp -a \
                  -f $KRELL_ROOT_PREFIX/$ALTLIBDIR/libxerces-c.so ]; then
               echo "XERCESC DETECTED IN KRELL_ROOT_PREFIX."
               export LD_LIBRARY_PATH=$KRELL_ROOT_XERCESC/$ALTLIBDIR:$LD_LIBRARY_PATH
               export KRELL_ROOT_XERCESC=$KRELL_ROOT_PREFIX
           fi
         else
               #export KRELL_ROOT_XERCESC=/usr
               echo "XERCESC DETECTED IN /usr ?"
         fi

      elif [ $build_oss_gui_only == 1 ] ; then
         OPENSS_INSTRUMENTOR=none 
      elif [ "$OPENSS_BUILD_TASK" == "onlyossoffline" ]; then
         OPENSS_INSTRUMENTOR=offline 
      elif [ "$OPENSS_BUILD_TASK" == "offline" ]; then
         OPENSS_INSTRUMENTOR=offline 
      elif [ "$OPENSS_BUILD_TASK" == "mrnet" ]; then
         OPENSS_INSTRUMENTOR=mrnet 
      elif [ "$OPENSS_BUILD_TASK" == "onlyossonline" ]; then
         OPENSS_INSTRUMENTOR=mrnet 
      fi

      if  [ "$nanswer" == 7 -o "$nanswer" == 9 ] && [ $build_oss == 1 ] ; then
        echo "Build Open|SpeedShop"
        echo "- steps 1, 2/2a, 3/3a, 4/4a and 5/5a must be completed before"
        echo "this step. Libraries must be accessible"
        echo "Set QTDIR to location of Qt."
        echo "Current default is /usr/$LIBDIR/qt-3-3"
        echo
        if [ $KRELL_ROOT_PREFIX ]; then
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR
            else
              export LD_LIBRARY_PATH=$KRELL_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
            fi
        else
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR
            else
              export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR:$LD_LIBRARY_PATH
            fi
            export KRELL_ROOT_PREFIX=/opt/OSS
            # set KRELL_ROOT_PREFIX to prefix to facilitate RPM build
        fi

	echo "Checking prior to OSS build, KRELL_ROOT_XERCESC=$KRELL_ROOT_XERCESC"
        if [ $KRELL_ROOT_XERCESC ]; then
	   echo "Using KRELL_ROOT_XERCESC=$KRELL_ROOT_XERCESC"
        else
           if test -f /usr/include/xercesc/dom/DOM.hpp -a -f /usr/$LIBDIR/libxerces-c.so; then
                KRELL_ROOT_XERCESC=/usr
           elif test -f ${KRELL_ROOT_PREFIX}/$LIBDIR/libxerces.so -a -f ${KRELL_ROOT_PREFIX}/include/xercesc/dom/DOM.hpp ; then
                KRELL_ROOT_XERCESC=${KRELL_ROOT_PREFIX}
           else
                echo "xercesc installation not found"
           fi
        fi

	echo "Checking prior to OSS build, KRELL_ROOT_BOOST=$KRELL_ROOT_BOOST"
        if [ $KRELL_ROOT_BOOST ]; then
	     echo "Using KRELL_ROOT_BOOST=$KRELL_ROOT_BOOST"
             if test -f ${KRELL_ROOT_BOOST}/lib64/libboost_system.so -o -f ${KRELL_ROOT_BOOST}/lib64/libboost_system-mt.so ; then
               export KRELL_ROOT_BOOST=$KRELL_ROOT_BOOST
               export KRELL_ROOT_BOOST_LIB=$KRELL_ROOT_BOOST/$LIBDIR
               echo "BOOST DETECTED IN KRELL_ROOT_BOOST."
	       echo "Using KRELL_ROOT_BOOST_LIB=$KRELL_ROOT_BOOST_LIB"
               export LD_LIBRARY_PATH=$KRELL_ROOT_BOOST/$LIBDIR:$LD_LIBRARY_PATH
             elif test -f ${KRELL_ROOT_BOOST}/lib/libboost_system.so -o -f ${KRELL_ROOT_BOOST}/lib/libboost_system-mt.so ; then
               export KRELL_ROOT_BOOST=$KRELL_ROOT_BOOST
               export KRELL_ROOT_BOOST_LIB=$KRELL_ROOT_BOOST/$ALTLIBDIR
               echo "BOOST DETECTED IN KRELL_ROOT_BOOST."
	       echo "Using KRELL_ROOT_BOOST_LIB=$KRELL_ROOT_BOOST_LIB"
               export LD_LIBRARY_PATH=$KRELL_ROOT_BOOST/$ALTLIBDIR:$LD_LIBRARY_PATH
             fi

        elif [ $KRELL_ROOT_PREFIX ]; then
             if test -f ${KRELL_ROOT_PREFIX}/lib64/libboost_system.so -o -f ${KRELL_ROOT_PREFIX}/lib64/libboost_system-mt.so ; then
               export KRELL_ROOT_BOOST=$KRELL_ROOT_PREFIX
               export KRELL_ROOT_BOOST_LIB=$KRELL_ROOT_PREFIX/$LIBDIR
               echo "BOOST DETECTED IN KRELL_ROOT_PREFIX."
	       echo "Using KRELL_ROOT_BOOST_LIB=$KRELL_ROOT_BOOST_LIB"
               export LD_LIBRARY_PATH=$KRELL_ROOT_BOOST/$LIBDIR:$LD_LIBRARY_PATH
             elif test -f ${KRELL_ROOT_PREFIX}/lib/libboost_system.so -o -f ${KRELL_ROOT_PREFIX}/lib/libboost_system-mt.so ; then
               export KRELL_ROOT_BOOST=$KRELL_ROOT_PREFIX
               export KRELL_ROOT_BOOST_LIB=$KRELL_ROOT_PREFIX/$ALTLIBDIR
               echo "BOOST DETECTED IN KRELL_ROOT_PREFIX."
	       echo "Using KRELL_ROOT_BOOST_LIB=$KRELL_ROOT_BOOST_LIB"
               export LD_LIBRARY_PATH=$KRELL_ROOT_BOOST/$ALTLIBDIR:$LD_LIBRARY_PATH
             fi

        else
             export KRELL_ROOT_BOOST=/usr
             if [ -f $KRELL_ROOT_BOOST/$LIBDIR/libboost_system.so -o -f $KRELL_ROOT_BOOST/$LIBDIR/libboost_system-mt.so ]; then
                export KRELL_ROOT_BOOST_LIB=/usr/$LIBDIR
             elif [ -f $KRELL_ROOT_BOOST/$ALTLIBDIR/libboost_system.so -o -f $KRELL_ROOT_BOOST/$ALTLIBDIR/libboost_system-mt.so ]; then
                export KRELL_ROOT_BOOST_LIB=/usr/$ALTLIBDIR
             fi
             echo "BOOST DETECTED IN /usr."
        fi
	# if KRELL_ROOT_RUNTIME_DIR is set then echo it for debug purposes
        if [ $KRELL_ROOT_RUNTIME_DIR ]; then
	     echo "Using KRELL_ROOT_RUNTIME_DIR=$KRELL_ROOT_RUNTIME_DIR"
        else
	     echo "KRELL_ROOT_RUNTIME_DIR is not set"
        fi

	# if KRELL_ROOT_RUNTIME_ONLY is set then echo it for debug purposes
        if [ $KRELL_ROOT_RUNTIME_ONLY ]; then
	     echo "Using KRELL_ROOT_RUNTIME_ONLY=$KRELL_ROOT_RUNTIME_ONLY"
        else
	     echo "KRELL_ROOT_RUNTIME_ONLY is not set"
        fi

	# if KRELL_ROOT_LIBUNWIND is set then export the library path for the build/configure to use
        if [ $KRELL_ROOT_LIBUNWIND ]; then
	     echo "Using KRELL_ROOT_LIBUNWIND=$KRELL_ROOT_LIBUNWIND"
             export LD_LIBRARY_PATH=$KRELL_ROOT_LIBUNWIND/$LIBDIR:$LD_LIBRARY_PATH
             export LD_LIBRARY_PATH=$KRELL_ROOT_LIBUNWIND/$ALTLIBDIR:$LD_LIBRARY_PATH
        elif test -f ${KRELL_ROOT_PREFIX}/$ALTLIBDIR/libunwind.so -o -f ${KRELL_ROOT_PREFIX}/$LIBDIR/libunwind.so ; then
	     export KRELL_ROOT_LIBUNWIND=$KRELL_ROOT_PREFIX
        fi

	# if KRELL_ROOT_LIBDWARF is set then export the library path for the build/configure to use
        if [ $KRELL_ROOT_LIBDWARF ]; then
	     echo "Using KRELL_ROOT_LIBDWARF=$KRELL_ROOT_LIBDWARF"
             export LD_LIBRARY_PATH=$KRELL_ROOT_LIBDWARF/$LIBDIR:$LD_LIBRARY_PATH
             export LD_LIBRARY_PATH=$KRELL_ROOT_LIBDWARF/$ALTLIBDIR:$LD_LIBRARY_PATH
        elif test -f ${KRELL_ROOT_PREFIX}/$ALTLIBDIR/libdwarf.so -o -f ${KRELL_ROOT_PREFIX}/$LIBDIR/libdwarf.so ; then
	     export KRELL_ROOT_LIBDWARF=$KRELL_ROOT_PREFIX
        fi

        if [ $force_ptgf_build != 0 -o $only_build_ptgf == 1 -o $build_ptgf_by_default == 1 ]; then
           export KRELL_ROOT_PTGF_BUILD_OPTION="all"
        else
           export KRELL_ROOT_PTGF_BUILD_OPTION="none"
        fi

	# if KRELL_ROOT_QT3 is set then export the library path for the build/configure to use
        if [ ${KRELL_ROOT_QT3} ]; then
	     echo "Using KRELL_ROOT_QT3=$KRELL_ROOT_QT3"
             export LD_LIBRARY_PATH=${KRELL_ROOT_QT3}/$LIBDIR:$LD_LIBRARY_PATH
             export LD_LIBRARY_PATH=${KRELL_ROOT_QT3}/$ALTLIBDIR:$LD_LIBRARY_PATH
        fi

	# if KRELL_ROOT_PAPI is set then export the library path for the build/configure to use
        if [ $KRELL_ROOT_PAPI ]; then
	     echo "Using KRELL_ROOT_PAPI=$KRELL_ROOT_PAPI"
             export LD_LIBRARY_PATH=$KRELL_ROOT_PAPI/$LIBDIR:$LD_LIBRARY_PATH
             export LD_LIBRARY_PATH=$KRELL_ROOT_PAPI/$ALTLIBDIR:$LD_LIBRARY_PATH
        fi
	# if KRELL_ROOT_SQLITE is set then export the library path for the build/configure to use
        if [ $KRELL_ROOT_SQLITE ]; then
	     echo "Using KRELL_ROOT_SQLITE=$KRELL_ROOT_SQLITE"
             export LD_LIBRARY_PATH=$KRELL_ROOT_SQLITE/$LIBDIR:$LD_LIBRARY_PATH
             export LD_LIBRARY_PATH=$KRELL_ROOT_SQLITE/$ALTLIBDIR:$LD_LIBRARY_PATH
        fi
	# if KRELL_ROOT_PYTHON is set then export the library path for the build/configure to use
        if [ $KRELL_ROOT_PYTHON ]; then
	     echo "Using KRELL_ROOT_PYTHON=$KRELL_ROOT_PYTHON"
             export LD_LIBRARY_PATH=$KRELL_ROOT_PYTHON/$LIBDIR:$LD_LIBRARY_PATH
             export LD_LIBRARY_PATH=$KRELL_ROOT_PYTHON/$ALTLIBDIR:$LD_LIBRARY_PATH
        fi
	# if KRELL_ROOT_LIBXML2 is set then export the library path for the build/configure to use
        if [ $KRELL_ROOT_LIBXML2 ]; then
	     echo "Using KRELL_ROOT_LIBXML2=$KRELL_ROOT_LIBXML2"
             export LD_LIBRARY_PATH=$KRELL_ROOT_LIBXML2/$LIBDIR:$LD_LIBRARY_PATH
             export LD_LIBRARY_PATH=$KRELL_ROOT_LIBXML2/$ALTLIBDIR:$LD_LIBRARY_PATH
        fi
	# if KRELL_ROOT_BINUTILS is set then export the library path for the build/configure to use
        echo "In BINUTILS SECTION, KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX, KRELL_ROOT_BINUTILS=$KRELL_ROOT_BINUTILS"
	if [ -z "$KRELL_ROOT_BINUTILS" ]; then
         if [ $KRELL_ROOT_PREFIX ] ; then
           if test -d $KRELL_ROOT_PREFIX/binutils -a -f $KRELL_ROOT_PREFIX/binutils/$LIBDIR/libbfd.so; then
               echo "Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX/binutils"
               export KRELL_ROOT_BINUTILS=$KRELL_ROOT_PREFIX/binutils
               echo "Using build_binutils=$build_binutils"
           elif test -d $KRELL_ROOT_PREFIX/binutils -a -f $KRELL_ROOT_PREFIX/binutils/$ALTLIBDIR/libbfd.so; then
               echo "Using KRELL_ROOT_PREFIX=$KRELL_ROOT_PREFIX/binutils"
               export KRELL_ROOT_BINUTILS=$KRELL_ROOT_PREFIX/binutils
               echo "Using build_binutils=$build_binutils"
           elif [ $build_binutils == 1  -o -f $KRELL_ROOT_PREFIX/$LIBDIR/libbfd.so ]; then
            export KRELL_ROOT_BINUTILS=$KRELL_ROOT_PREFIX
            echo "Using (1) KRELL_ROOT_BINUTILS=$KRELL_ROOT_BINUTILS"
           else
            export KRELL_ROOT_BINUTILS=/usr
            echo "Using (2) KRELL_ROOT_BINUTILS=$KRELL_ROOT_BINUTILS"
           fi
         else
           if [ $build_binutils == 1  -o -f /opt/OSS/$LIBDIR/libbfd.so ]; then
            export KRELL_ROOT_BINUTILS=/opt/OSS
            echo "Using (3) KRELL_ROOT_BINUTILS=$KRELL_ROOT_BINUTILS"
           else
            export KRELL_ROOT_BINUTILS=/usr
            echo "Using (4) KRELL_ROOT_BINUTILS=$KRELL_ROOT_BINUTILS"
           fi
         fi
        fi
        if [ $KRELL_ROOT_BINUTILS ]; then
             export LD_LIBRARY_PATH=$KRELL_ROOT_BINUTILS/$LIBDIR:$LD_LIBRARY_PATH
             export LD_LIBRARY_PATH=$KRELL_ROOT_BINUTILS/$ALTLIBDIR:$LD_LIBRARY_PATH
        fi

        echo ""
	export KRELL_ROOT_DYNINST_VERS=$dyninstver
        echo ""

        echo ""
	export KRELL_ROOT_MRNET_VERS=$mrnetver
        echo ""
	echo "Using KRELL_ROOT_MRNET_VERS=$KRELL_ROOT_MRNET_VERS"
	echo "Using KRELL_ROOT_DYNINST_VERS=$KRELL_ROOT_DYNINST_VERS"
        echo ""

        echo ""
	export KRELL_ROOT_SYMTABAPI_VERS=$symtabapiver
        echo ""
	echo "Using KRELL_ROOT_SYMTABAPI_VERS=$KRELL_ROOT_SYMTABAPI_VERS"
	echo "Using KRELL_ROOT_DYNINST_VERS=$KRELL_ROOT_DYNINST_VERS"
	echo "KRELL_ROOT_TARGET_ARCH=$KRELL_ROOT_TARGET_ARCH"
        echo ""

        echo "Build Open|SpeedShop? <y/n>"
        echo ""
        if [ "$nanswer" == 9 -a $build_oss == 1 ]; then
            answer=Y
        else
            read answer
        fi
        if [ "$answer" == Y -o "$answer" == y ]; then
            if [ ! -f SOURCES/openspeedshop-${openspeedshopver}.tar.gz ];then
                if [ -d ../OpenSpeedShop ];then
                    echo "Building tarball from CVS checkout..."
                    ( cd ..
                      mv OpenSpeedShop openspeedshop-${openspeedshopver}
                      tar cf - openspeedshop-${openspeedshopver} | \
                        gzip > OpenSpeedShop_ROOT/SOURCES/openspeedshop-${openspeedshopver}.tar.gz
                      mv openspeedshop-${openspeedshopver} OpenSpeedShop
                    )
                fi
            fi
            # Decide if building rpm option was used (--rpm or --create-rpm)
            if [ "$use_rpm" = 1 ] ; then
              rm -rf RPMS/$sys/openspeedshop.OSS.*.rpm
              ./Build-RPM openspeedshop-$openspeedshopver
              if [ -s RPMS/$sys/openspeedshop.OSS.*.rpm ]; then
                  echo "OpenSpeedShop BUILT SUCCESSFULLY."
              else
                  echo "OpenSpeedShop FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                  exit
              fi
            else
              build_openspeedshop_routine
              #if [ -s RPMS/$sys/openspeedshop.OSS.*.rpm ]; then
              #    echo "OpenSpeedShop BUILT SUCCESSFULLY."
              #else
              #    echo "OpenSpeedShop FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
              #    exit
              #fi
            fi
        fi
      fi
    fi

    if [ "$OPENSS_BUILD_TASK" != "krellroot" ]; then
     # Decide if building rpm option was used (--rpm or --create-rpm)
     if [ "$use_rpm" = 1 ] ; then
      if [ "$nanswer" == 7a  -o "$nanswer" == 9 ] && [ $build_oss == 1 ]; then
        echo "Install Open|SpeedShop"
        echo " - steps 1,  2, 3/3a, 4/4a, 5/5a and 7 must be completed before this"
        echo "step. Libraries must be accessible"
        echo "This is non-root cpio process."
        echo "Installing in /opt/OSS unless KRELL_ROOT_PREFIX set"
        echo
        #cd RPMS/$sys
        pushd RPMS/$sys
        echo "starting RPM to cpio process..."
        rpm2cpio openspeedshop.OSS.*.rpm > openspeedshop.cpio
        echo "starting cpio to local path install process..."
        rm -rf opt
        cpio -id < openspeedshop.cpio
        echo "installing openspeedshop..."
        echo "moving files to target path: "
        if [ $OPENSS_PREFIX ]; then
            currentDir=`pwd`
            #echo $currentDir
            cp -r $currentDir/$OPENSS_PREFIX/* $OPENSS_PREFIX
            echo $OPENSS_PREFIX
        else
            cp -r opt/* /opt
            echo " /opt/OSS"
        fi
        # Back out of RPMS
        #cd ../..
        popd
      fi # end of 7a selection
     fi # end of use_rpm
    fi # end of build_task

    echo "--------------------- PTGF OSS GUI BUILD ---------------------------"
    echo "--------------------- PTGF OSS GUI BUILD ---------------------------"
    echo "--------------------- PTGF OSS GUI BUILD ---------------------------"
    echo "force_ptgf_build= $force_ptgf_build"
    echo "only_build_ptgf= $only_build_ptgf"
    echo "build_ptgf_by_default= $build_ptgf_by_default"
    echo "OPENSS_BUILD_TASK= $OPENSS_BUILD_TASK"
    echo "build_oss_runtime_only= $build_oss_runtime_only"
    echo "nanswer= $nanswer"
    echo "--------------------- PTGF OSS GUI BUILD ---------------------------"
    echo "--------------------- PTGF OSS GUI BUILD ---------------------------"
    echo "--------------------- PTGF OSS GUI BUILD ---------------------------"

    if [ $force_ptgf_build != 0 -o $only_build_ptgf == 1 -o $build_ptgf_by_default == 1 ]; then
      # Build ptgf 
        if [ "$OPENSS_BUILD_TASK" == "onlyossoffline" ] || \
           [ "$OPENSS_BUILD_TASK" == "onlyosscbtf" ] || \
           [ "$OPENSS_BUILD_TASK" == "offline" ] ; then
          if [ "$nanswer" = 7b  -o "$nanswer" = 9 ] && [ $build_oss_runtime_only == 0 ]; then 
              export KRELL_ROOT_PTGF_ROOT=$KRELL_ROOT_PREFIX
              #build_ptgf_routine
              export KRELL_ROOT_QCUSTOMPLOT_ROOT=$KRELL_ROOT_PREFIX
              #build_qcustomplot_routine
              #export KRELL_ROOT_GRAPHVIZ_ROOT=$KRELL_ROOT_PREFIX
              #build_qgraphviz_routine
              export KRELL_ROOT_PTGFOSSGUI_ROOT=$KRELL_ROOT_PREFIX
              build_ptgfossgui_routine
          fi
        fi
    # end ptgf build
    fi

    if [ "$nanswer" = 8 ]; then
        if [ $KRELL_ROOT_PREFIX ]; then
            echo "Install path=$KRELL_ROOT_PREFIX"
        else
            echo "Install path=/opt/OSS"
            export KRELL_ROOT_PREFIX=/opt/OSS
        # set KRELL_ROOT_PREFIX to prefix to facilitate RPM build
        fi

        echo 
        echo "Installed components status:"
        echo 
        if [ -f /usr/$LIBDIR/libelf.so ] && [ -f /usr/include/libelf.h -o /usr/include/libelf/libelf.h ]; then 
            echo - libelf- `ls -l --time-style=full-iso /usr/$LIBDIR/libelf.so\
            | awk '{printf "%s", $6}'`" system lib in /usr"
        else
            echo - libelf- `ls -l --time-style=full-iso \
            $KRELL_ROOT_PREFIX/$LIBDIR/libelf.so  | awk '{printf "%s", $6}'`
        fi
        if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.so ]; then
            echo - libdwarf- `ls -l --time-style=full-iso \
            $KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.so  | awk '{printf "%s", $6}'`
        else
            if [ -f /usr/$LIBDIR/libdwarf.so ] && [ -f /usr/include/libdwarf.h -o -f /usr/include/libdwarf/libdwarf.h ]; then
               echo - libdwarf- `ls -l --time-style=full-iso /usr/$LIBDIR/libdwarf.so\
               | awk '{printf "%s", $6}'`" system lib in /usr"
            else
               echo - libdwarf- not installed
            fi
        fi
        if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libunwind.so ]; then
            echo - libunwind- `ls -l --time-style=full-iso \
            $KRELL_ROOT_PREFIX/$LIBDIR/libunwind.so  | awk '{printf "%s", $6}'`
        else
            echo - libunwind- not installed
        fi

        # jeg 10/9/2012 - don't find libpapi in /usr instead always build our own version
        # unless the user asks for KRELL_ROOT_PAPI then use that
        if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libpapi.so ]; then
            echo - papi- `ls -l --time-style=full-iso \
            $KRELL_ROOT_PREFIX/$LIBDIR/libpapi.so  | awk '{printf "%s", $6}'`
        #elif [ -f /usr/$LIBDIR/libpapi.so -a -f /usr/include/papi.h ]; then
        #    echo - papi- `ls -l --time-style=full-iso /usr/$LIBDIR/libpapi.so\
        #    | awk '{printf "%s", $6}'`" system lib in /usr"
        else
            echo - papi- not installed - no hwc,hwctime, or hwcsamp experiment support
        fi
        if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libsqlite3.so ]; then
            echo - sqlite- `ls -l --time-style=full-iso \
            $KRELL_ROOT_PREFIX/$LIBDIR/libsqlite3.so  | awk '{printf "%s", $6}'`
        elif [ "$install_libsqlite" = 1 ]; then
            echo - sqlite- not installed, may be an error in build
        else
            if [ -f /usr/$LIBDIR/libsqlite3.so -a -f /usr/include/sqlite3.h ]; then
               echo - sqlite- `ls -l --time-style=full-iso /usr/$LIBDIR/libsqlite3.so\
               | awk '{printf "%s", $6}'`" system lib in /usr"
            else
               echo - sqlite- using KRELL_ROOT_SQLITE
            fi
        fi
        if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libmonitor.so ]; then
            echo - monitor- `ls -l --time-style=full-iso \
            $KRELL_ROOT_PREFIX/$LIBDIR/libmonitor.so  | awk '{printf "%s", $6}'`
        else
            echo - monitor- not installed
        fi
        if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libvt.a ]; then
            echo - vampirtrace- `ls -l --time-style=full-iso \
            $KRELL_ROOT_PREFIX/$LIBDIR/libvt.a  | awk '{printf "%s", $6}'`
        else
            echo - vampirtrace-  not installed
        fi
        if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libdyninstAPI.so ]; then
            echo - dyninst- `ls -l --time-style=full-iso \
            $KRELL_ROOT_PREFIX/$LIBDIR/libdyninstAPI.so  | awk '{printf "%s", $6}'`
        else
            echo - dyninst-  not installed - not needed if buildtask is offline
        fi
        if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libmrnet.a ]; then
            echo - mrnet- `ls -l --time-style=full-iso \
            $KRELL_ROOT_PREFIX/$LIBDIR/libmrnet.a  | awk '{printf "%s", $6}'`
        else
            echo - MRNet-  not installed - not needed if buildtask is offline
        fi
        if [ -f $OPENSS_PREFIX/$LIBDIR/libopenss-cli.so ]; then
            echo - OpenSpeedShop- `ls -l --time-style=full-iso \
            $OPENSS_PREFIX/$LIBDIR/libopenss-cli.so  | awk '{printf "%s", $6}'`
        else
            echo - OpenSpeedShop-  not installed
        fi
        echo
        echo "Environment variables set:"
        echo 
        env | grep KRELL_
        env | grep CBTF_
        env | grep OPENSS_
        echo
    fi
}
#End Functions ----------------------------------------------------------------

export build_root_home=`pwd`
echo "BUILD NOTE: build_root_home=$build_root_home"
export machine_name=`uname -m`

if [ `uname -m` = "x86_64" -o `uname -m` = " x86-64" ]; then
    if [ -d /usr/lib/x86_64-linux-gnu ] ; then
       LIBDIR="lib"
       ALTLIBDIR="lib"
       export LIBDIR="lib"
       #echo "build debug: UNAME IS X86_64 FAMILY, on UBUNTU: LIBDIR=$LIBDIR"
    else
       LIBDIR="lib64"
       ALTLIBDIR="lib"
       export LIBDIR="lib64"
       #echo "build debug: UNAME IS X86_64 FAMILY: on non-UBUNTU LIBDIR=$LIBDIR"
     fi
elif [ `uname -m` = "ppc64" ]; then
   if [ -e /bgsys/drivers/ppcfloor/../ppc ]; then
    LIBDIR="lib"
    ALTLIBDIR="lib64"
    export LIBDIR="lib" 
    #echo "build debug: UNAME IS PPC (32) BGP FAMILY: LIBDIR=$LIBDIR"
   elif [ -e /bgsys/drivers/ppcfloor/../ppc64 ]; then
    LIBDIR="lib64"
    ALTLIBDIR="lib"
    #echo "build debug: UNAME IS PPC (64) BGQ - FAMILY: LIBDIR=$LIBDIR"
    export LIBDIR="lib64"
    export CFLAGS=" -m64 $CFLAGS "
    export CXXFLAGS=" -m64 $CXXFLAGS "
    export CPPFLAGS=" -m64 $CPPFLAGS "
    #echo "build debug: UNAME IS PPC FAMILY: LIBDIR=$LIBDIR" 
   else
    LIBDIR="lib64"
    ALTLIBDIR="lib"
    #echo "build debug: UNAME IS PPC (64) NON-BG FAMILY: LIBDIR=$LIBDIR"
    export LIBDIR="lib64"
    export CFLAGS=" -m64 $CFLAGS "
    export CXXFLAGS=" -m64 $CXXFLAGS "
    export CPPFLAGS=" -m64 $CPPFLAGS "
    #echo "build debug: UNAME IS PPC FAMILY: LIBDIR=$LIBDIR" 
   fi
elif [ `uname -m` = "ppc" ]; then
    LIBDIR="lib"
    ALTLIBDIR="lib64"
    #echo "build debug: UNAME IS PPC FAMILY: LIBDIR=$LIBDIR"
    export LIBDIR="lib" 
elif [ `uname -m` = "aarch64" ]; then
    LIBDIR="lib"
    ALTLIBDIR="lib64"
    #echo "build debug: UNAME IS ARM FAMILY: LIBDIR=$LIBDIR"
    export LIBDIR="lib" 
else
    LIBDIR="lib" 
    ALTLIBDIR="lib64"
    export LIBDIR="lib"
    #echo "build debug: UNAME IS X86 FAMILY: LIBDIR=$LIBDIR"
fi

#sys=`uname -n | grep -o '[^0-9]\{0,\}'`
sys=`uname -n `
export MACHINE=$sys
echo 'BUILD NOTE: machine:' $sys
echo ""

export build_binutils=1
export force_libdwarf_build=1

export imode=1  #Interactive Mode left as true if no args passed
export build_oss=1
export build_symtabapi=1
export build_oss_gui_only=0
export build_oss_runtime_only=0
export report_missing_packages=1
export skip_cmake_build=0
export force_cmake_build=0
export skip_binutils=0
export skip_libelf_build=0
export skip_sqlite_build=0
export skip_libmonitor_build=0
export skip_papi_build=0
export skip_symtabapi_build=0
export skip_dyninst_build=0
# change this to 1 to enable building
# llvm_openmp instead of ompt by default 
export use_llvm_openmp=1

export skip_ompt_build=0
export force_ompt_build=0
export skip_llvm_openmp_build=0
export force_llvm_openmp_build=0
export skip_xercesc_build=0
export skip_ptgf_build=0
export force_ptgf_build=0
export only_build_ptgf=0

# change this to build ptgf as part of the normal
# builds of krell root and oss
export build_ptgf_by_default=0
export force_libdwarf_build=0
export force_libelf_build=0
export force_dyninst_build=0
export build_libelf_by_default=1
export build_dyninst_by_default=1
export build_libunwind_by_default=1
export build_papi_by_default=1
export force_xercesc_build=0
export build_compiler="--use-gnu"

# default value for whether or not to build rpms when building component (use_rpm=1) or not (use_rpm=0)
export use_rpm=0
export use_alps=1
export build_with_intel=0
export tsys=""

# If install-tool --verbose is enabled
export display_summary=0
if [ -z $KRELL_ROOT_BUILD_VERBOSE ] ; then
    export display_summary=0
else
    export display_summary=1
fi

#
# Process most skip and force build options
# Some are intermixed with other special processing code that influences
# the setting of the flags for force and skip
#

if [ -z $KRELL_ROOT_SKIP_CMAKE_BUILD ]; then
   export skip_cmake_build=0
else
   echo "SKIPPING cmake build because KRELL_ROOT_SKIP_CMAKE_BUILD is set."
   export skip_cmake_build=1
fi


if [ -z $KRELL_ROOT_ONLY_BUILD_PTGF ] ; then
   only_build_ptgf=0
else
   only_build_ptgf=1
   echo "BUILD NOTE: KRELL_ROOT_ONLY_BUILD_PTGF is set, PTGF supporting components will be built..."
fi

if [ -z $KRELL_ROOT_FORCE_PTGF_BUILD ] ; then
   force_ptgf_build=0
else
   force_ptgf_build=1
   echo "BUILD NOTE: KRELL_ROOT_FORCE_PTGF_BUILD is set, PTGF supporting components will be built..."
fi

if [ -z $KRELL_ROOT_FORCE_QT3_BUILD ] ; then
   force_qt3_build=0
else
   force_qt3_build=1
   echo "BUILD NOTE: KRELL_ROOT_FORCE_QT3_BUILD is set, Qt will be built..."
fi

if [ -z $KRELL_ROOT_SKIP_QT3_BUILD ] ; then
   #echo "build debug: set skip_qt3_build=0......"
   skip_qt3_build=0
else
   skip_qt3_build=1
   echo "BUILD NOTE: KRELL_ROOT_SKIP_QT3_BUILD is set, Qt will be skipped..."
fi

if [ -z $KRELL_ROOT_FORCE_XERCESC_BUILD ] ; then
   force_xercesc_build=0
else
   force_xercesc_build=1
   echo "BUILD NOTE: KRELL_ROOT_FORCE_XERCESC_BUILD is set, xercesc will be built..."
fi

if [ -z $KRELL_ROOT_SKIP_XERCESC_BUILD ] ; then
   #echo "build debug: set skip_xercesc_build=0......"
   skip_xercesc_build=0
else
   echo "BUILD NOTE: set skip_xercesc_build=1......"
   skip_xercesc_build=1
fi


if [ -z $KRELL_ROOT_FORCE_LIBMONITOR_BUILD ] ; then
   force_libmonitor_build=0
else
   force_libmonitor_build=1
   echo "BUILD NOTE: KRELL_ROOT_FORCE_LIBMONITOR_BUILD is set, libmonitor will be built..."
fi

if [ -z $KRELL_ROOT_SKIP_LIBMONITOR_BUILD ] ; then
    #echo "build debug: set skip_libmonitor_build=0......"
    skip_libmonitor_build=0
else
    echo "BUILD NOTE: set skip_libmonitor_build=1......"
    skip_libmonitor_build=1
fi

if [ -z $KRELL_ROOT_FORCE_SQLITE_BUILD ] ; then
   force_sqlite_build=0
else
   force_sqlite_build=1
   echo "BUILD NOTE: KRELL_ROOT_FORCE_SQLITE_BUILD is set, sqlite will be built..."
fi

if [ -z $KRELL_ROOT_SKIP_SQLITE_BUILD ] ; then
    #echo "build debug: set skip_sqlite_build=0......"
    export skip_sqlite_build=0
else
    echo "BUILD NOTE: set skip_sqlite_build=1......"
    export skip_sqlite_build=1
fi

if [ -z $KRELL_ROOT_FORCE_LIBUNWIND_BUILD ] ; then
   export force_libunwind_build=0
else
   export force_libunwind_build=1
   echo "KRELL_ROOT_FORCE_LIBUNWIND_BUILD is set, libunwind will be built..."
fi

if [ -z $KRELL_ROOT_SKIP_LIBUNWIND_BUILD ] ; then
    #echo "build debug: set skip_libunwind_build=0......"
    export skip_libunwind_build=0
else
    echo "BUILD NOTE: set skip_libunwind_build=1......"
    export skip_libunwind_build=1
fi

if [ -z $KRELL_ROOT_SKIP_PAPI_BUILD ] ; then
    #echo "build debug: set skip_papi_build=0......"
    export skip_papi_build=0
else
    echo "BUILD NOTE: set skip_papi_build=1......"
    export skip_papi_build=1
fi

if [ -z $KRELL_ROOT_FORCE_PAPI_BUILD ] ; then
   export force_papi_build=0
else
   export force_papi_build=1
   echo "BUILD NOTE: KRELL_ROOT_FORCE_PAPI_BUILD is set, papi will be built..."
fi

if [ -z $KRELL_ROOT_SKIP_BOOST_BUILD ] ; then
   #echo "build debug: set skip_boost_build=0......"
   skip_boost_build=0
else
   echo "BUILD NOTE: set skip_boost_build=1......"
   skip_boost_build=1
fi

if [ -z $KRELL_ROOT_FORCE_BOOST_BUILD ] ; then
   force_boost_build=0
else
   force_boost_build=1
   build_boost=1
   echo "BUILD NOTE: KRELL_ROOT_FORCE_BOOST_BUILD is set, boost will be built..."
fi

if [ -z $KRELL_ROOT_FORCE_CMAKE_BUILD ] ; then
   force_cmake_build=0
else
   force_cmake_build=1
   echo "BUILD NOTE: KRELL_ROOT_FORCE_BOOST_CMAKE is set, cmake will be built..."
fi

if [ -z $KRELL_ROOT_SKIP_SYMTABAPI_BUILD ] ; then
   #echo "build debug: set skip_symtabapi_build=0......"
   skip_symtabapi_build=0
else
   echo "BUILD NOTE: set skip_symtabapi_build=1......"
   skip_symtabapi_build=1
fi

if [ -z $KRELL_ROOT_FORCE_DYNINST_BUILD ] ; then
   #echo "build debug: set force_dyninst_build=0......"
   export force_dyninst_build=0
else
   echo "BUILD NOTE: set force_dyninst_build=1......"
   export force_dyninst_build=1
   echo "BUILD NOTE: KRELL_ROOT_FORCE_DYNINST_BUILD is set, dyninst will be built..."
fi

if [ -z $KRELL_ROOT_SKIP_DYNINST_BUILD ] ; then
   #echo "build debug: set skip_dyninst_build=0......"
   skip_dyninst_build=0
else
   echo "BUILD NOTE: set skip_dyninst_build=1......"
   skip_dyninst_build=1
fi

if [ -z $KRELL_ROOT_SKIP_MRNET_BUILD ] ; then
   #echo "build debug: set skip_mrnet_build=0......"
   export skip_mrnet_build=0
else
   echo "BUILD NOTE: set skip_mrnet_build=1......"
   export skip_mrnet_build=1
fi

if [ -z $KRELL_ROOT_FORCE_LIBDWARF_BUILD ] ; then
   #echo "build debug: set force_libdwarf_build=0......"
   export force_libdwarf_build=0
else
   echo "BUILD NOTE: set force_libdwarf_build=1......"
   export force_libdwarf_build=1
   echo "BUILD NOTE: KRELL_ROOT_FORCE_LIBDWARF_BUILD is set, libdwarf will be built..."
fi

if [ -z $KRELL_ROOT_SKIP_LIBDWARF_BUILD ] ; then
    #echo "build debug: set skip_libdwarf_build=0......"
    export skip_libdwarf_build=0
else
    echo "BUILD NOTE: set skip_libdwarf_build=1......"
    export skip_libdwarf_build=1
fi

if [ -z $KRELL_ROOT_SKIP_BINUTILS_BUILD ]; then
   export skip_binutils=0
else
   echo "BUILD NOTE: SKIPPING binutils build because KRELL_ROOT_SKIP_BINUTILS_BUILD is set."
   export skip_binutils=1
fi

# --------- OMPT ----------------------
if [ -z $KRELL_ROOT_FORCE_OMPT_BUILD ] ; then
   #echo "build debug: set force_ompt_build=0......"
   force_ompt_build=0
else
   echo "BUILD NOTE: set force_ompt_build=1......"
   force_ompt_build=1
   echo "BUILD NOTE: KRELL_ROOT_FORCE_OMPT_BUILD is set, ompt will be built..."
fi

if [ -z $KRELL_ROOT_SKIP_OMPT_BUILD ] ; then
   #echo "build debug: set skip_ompt_build=0......"
   skip_ompt_build=0
else
   echo "BUILD NOTE: set skip_ompt_build=1......"
   skip_ompt_build=1
   echo "BUILD NOTE: SKIPPING ompt build because KRELL_ROOT_SKIP_OMPT_BUILD is set."
fi


# --------- LLVM-OPENMP ----------------------

if [ -z $KRELL_ROOT_FORCE_LLVM_OPENMP_BUILD ] ; then
   #echo "build debug: set force_llvm_openmp_build=0......"
   force_llvm_openmp_build=0
else
   echo "BUILD NOTE: set force_ompt_build=1......"
   force_llvm_openmp_build=1
   echo "BUILD NOTE: KRELL_ROOT_FORCE_LLVM_OPENMP_BUILD is set, ompt will be built..."
fi

if [ -z $KRELL_ROOT_SKIP_LLVM_OPENMP_BUILD ] ; then
   #echo "build debug: set skip_llvm_openmp_build=0......"
   skip_llvm_openmp_build=0
else
   echo "BUILD NOTE: set skip_llvm_openmp_build=1......"
   skip_llvm_openmp_build=1
   echo "BUILD NOTE: SKIPPING ompt build because KRELL_ROOT_SKIP_LLVM_OPENMP_BUILD is set."
fi

if [ -z $KRELL_ROOT_FORCE_LIBELF_BUILD ] ; then
   #echo "build debug: set force_libelf_build=0......"
   force_libelf_build=0
else
   echo "BUILD NOTE: set force_libelf_build=1......"
   force_libelf_build=1
   echo "BUILD NOTE: KRELL_ROOT_FORCE_LIBELF_BUILD is set, libelf will be built..."
fi

if [ -z $KRELL_ROOT_SKIP_LIBELF_BUILD ] ; then
   #echo "build debug: set skip_libelf_build=0......"
   skip_libelf_build=0
else
   echo "BUILD NOTE: set skip_libelf_build=1......"
   skip_libelf_build=1
   echo "SKIPPING libelf build because KRELL_ROOT_SKIP_LIBELF_BUILD is set."
fi

if [ -z $KRELL_ROOT_SKIP_VAMPIRTRACE_BUILD ]; then
   export skip_vampirtrace=0
else
   echo "SKIPPING binutils build because KRELL_ROOT_SKIP_VAMPIRTRACE_BUILD is set."
   export skip_vampirtrace=1
fi

# FIXME: add checks to see that skip and force are not both set for a component.

#echo 'build debug: ARG1: ' $1

while [ $# -gt 0 ]; do
    #echo 'build debug: IN WHILE, ARG 1: ' $1
    #echo 'build debug: IN WHILE, ARG 1: ' $2
    #echo 'build debug: IN WHILE, ARG 1: ' $3
    case "$1" in

       --rpm|--create-rpm)
            export use_rpm=1
            echo "BUILD NOTE: Build and Install using the rpm tools and creating rpm files."
            shift;;

       --no-rpm)
            export use_rpm=0
            echo "BUILD NOTE: Build and Install but do not use the rpm tools."
            shift;;

       --no-alps)
            export use_alps=0
            echo "BUILD NOTE: Build mrnet but do not use alps.  Some Cray platforms are now using Native SLURM, skipping alps"
            shift;;


       --use-intel)
            export build_compiler="--use-intel"
            export build_with_intel=1
            echo "BUILD NOTE: Build and Install using Intel compilers."
            shift;;

       --use-gnu)
            export build_compiler="--use-gnu"
            echo "BUILD NOTE: Build and Install using GNU compilers."
            shift;;

       --target-arch)
            test "x$2" != x || die "missing argument: $*"
            target="$2"
            export KRELL_ROOT_TARGET_ARCH="${target}"
            export OPENSS_TARGET_ARCH="${target}"
            export CBTF_TARGET_ARCH="${target}"
	    echo "BUILD NOTE: Exporting ${target} as the --target-arch CBTF_TARGET_ARCH value"
	    echo "BUILD NOTE: Exporting ${target} as the --target-arch KRELL_ROOT_TARGET_ARCH value"
            if [ ${target:0:4} == "cray" ]; then
	       #echo "build debug: Skipping altering sys=$sys for cray"
               #tsys=$sys/${target}
               echo "BUILD NOTE: tsys=$tsys"
	       echo "BUILD NOTE: Altering sys=$sys to sys=$tsys for internal build directory management for Cray."
               #sys=$tsys
            elif [ ${target:0:5} == "bgqfe" ]; then
	       echo "BUILD NOTE: Skipping altering sys=$sys for bgqfe"
            elif [ ${target:0:3} == "bgq" ]; then
               tsys=$sys/${target}
               echo "BUILD NOTE: tsys=$tsys"
	       echo "BUILD NOTE: Altering sys=$sys to sys=$tsys for internal build directory management for BGQ."
               #sys=$tsys
            elif [ ${target:0:3} == "mic" ]; then
               tsys=$sys/${target}
               echo "BUILD NOTE: tsys=$tsys"
	       echo "BUILD NOTE: Altering sys=$sys to sys=$tsys for internal build directory management for MIC."
               #sys=$tsys
            fi
	    shift
            shift;;
       --gui-only)
            export OPENSS_BUILD_TASK="none"
            export build_oss_gui_only=1
	    echo "BUILD NOTE: Enabling build of openss gui version. No buildtask is built.."
            shift;;
       --runtime-only)
            export build_oss_runtime_only=1
	    echo "BUILD NOTE: Enabling build of openss collector runtimes. No client is built.."
            shift;;
       --with-cbtf)
            export OPENSS_BUILD_TASK="cbtf"
	    echo "BUILD NOTE: Enabling build and install of cbtf and openspeedshop with the cbtf buildtask."
            shift;;
       --with-root)
            export OPENSS_BUILD_TASK="krellroot"
	    echo "BUILD NOTE: Enabling build and install of the krell root required in order to build cbtf and openspeedshop."
            shift;;
       --with-online)
            export OPENSS_BUILD_TASK="mrnet"
	    echo "BUILD NOTE: Enabling build and install of dyninst and mrnet."
            shift;;
       --with-symtabapi)
            export build_symtabapi=1
	    echo "BUILD NOTE: Enabling build and install of symtabapi (offline only)."
            shift;;
       --exclude-oss)
            export build_oss=0
	    echo "BUILD NOTE: Build and Install of Open|SpeedShop is disabled for this run."
            shift;;
       --devel)
            build_autotools
            exit;;
       --build-cmake)
            echo "BUILD NOTE: Build and Install of the cmake package."
            # Is this a special --build-cmake request, if so only use ${KRELL_ROOT_PREFIX}
            # as the CMAKE_INSTALL_PREFIX, otherwise add the ../cmake
            # 1 = special --build-cmake request
            # 0 = part of normal --build-krell-root
            build_cmake_routine 1
            if [ -f $KRELL_ROOT_PREFIX/share/cmake-3.2/Modules/FindPythonLibs.cmake -a -f $KRELL_ROOT_PREFIX/bin/cmake ]; then
                echo "CMAKE BUILD TOOL BUILT SUCCESSFULLY into $KRELL_ROOT_PREFIX"
                export CBTF_CMAKE_ROOT=$KRELL_ROOT_PREFIX
            else
                echo "CMAKE BUILD TOOL FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                exit
            fi
            #if [ -z CBTF_CMAKE_ROOT ]; then
            #  export CBTF_CMAKE_ROOT=$KRELL_ROOT_PREFIX
            #  echo "BUILD NOTE: USING CBTF_CMAKE_ROOT=$KRELL_ROOT_PREFIX as the cmake install directory"
            #else
            #  echo "BUILD NOTE: USING CBTF_CMAKE_ROOT=$CBTF_CMAKE_ROOT as the cmake install directory"
            #fi
            exit;;

       --build-expat)
            echo "BUILD NOTE: Build and Install of the expat package."
            build_expat_routine
            export KRELL_ROOT_EXPAT_ROOT=$KRELL_ROOT_PREFIX
            if [ -f $KRELL_ROOT_EXPAT_ROOT/lib/libexpat.a ]; then
               echo "BUILD NOTE: EXPAT BUILT SUCCESSFULLY into $KRELL_ROOT_EXPAT_ROOT"
            else
               echo "BUILD NOTE: EXPAT FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
               exit
            fi
            exit;;

       --build-ptgfall)
            export KRELL_ROOT_PTGF_ROOT=$KRELL_ROOT_PREFIX
            build_ptgf_routine
            export KRELL_ROOT_QCUSTOMPLOT_ROOT=$KRELL_ROOT_PREFIX
            build_qcustomplot_routine
            #export KRELL_ROOT_GRAPHVIZ_ROOT=$KRELL_ROOT_PREFIX
            #build_qgraphviz_routine
            export KRELL_ROOT_PTGFOSSGUI_ROOT=$KRELL_ROOT_PREFIX
            build_ptgfossgui_routine
            exit;;
       --build-ptgf)
            export KRELL_ROOT_PTGF_ROOT=$KRELL_ROOT_PREFIX
            build_ptgf_routine
            exit;;
       --build-qcustomplot)
            export KRELL_ROOT_QCUSTOMPLOT_ROOT=$KRELL_ROOT_PREFIX
            build_qcustomplot_routine
            exit;;
       --build-QtGraph)
            build_QtGraph_routine
            exit;;
       --build-graphviz)
            export KRELL_ROOT_GRAPHVIZ_ROOT=$KRELL_ROOT_PREFIX
            build_graphviz_routine
            exit;;
       --build-ptgfossgui)
            export KRELL_ROOT_PTGFOSSGUI_ROOT=$KRELL_ROOT_PREFIX
            build_ptgfossgui_routine
            exit;;
       --build-llvm-openmp)
            # Is this a special --build-llvm-openmp request, if so only use ${KRELL_ROOT_PREFIX}
            # as the CMAKE_INSTALL_PREFIX, otherwise add the ../ompt
            # 1 = special --build-llvm-openmp request
            # 0 = part of normal --build-krell-root
            build_llvm_openmp_routine 1
            if [ -f $KRELL_ROOT_PREFIX/include/omp.h -a -f $KRELL_ROOT_PREFIX/lib/libiomp5.so ]; then
                echo "LLVM_OPENMP RUNTIME LIBRARY (libompt5.so) BUILT SUCCESSFULLY into $KRELL_ROOT_PREFIX"
            else
                echo "LLVM_OPENMP RUNTIME LIBRARY (libompt5.so) FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                exit
            fi
            exit;;
       --build-ompt)
            # Is this a special --build-ompt request, if so only use ${KRELL_ROOT_PREFIX}
            # as the CMAKE_INSTALL_PREFIX, otherwise add the ../ompt
            # 1 = special --build-ompt request
            # 0 = part of normal --build-krell-root
            build_ompt_routine 1
            if [ -f $KRELL_ROOT_PREFIX/include/ompt.h -a -f $KRELL_ROOT_PREFIX/lib/libiomp5.so ]; then
                echo "OMPT RUNTIME LIBRARY (libompt5.so) BUILT SUCCESSFULLY into $KRELL_ROOT_PREFIX"
            else
                echo "OMPT RUNTIME LIBRARY (libompt5.so) FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                exit
            fi
            exit;;
       --bison)
            build_bison_routine
            exit;;
       --flex)
            build_flex_routine
            exit;;
       --boost-headers)
            build_boost=1
            build_boost_routine 1
            exit;;

       --boost)
            build_boost=1

            if test -f /usr/include/boost/regex.hpp -a  \
                    -f /usr/$LIBDIR/libboost_system.so -o  \
                    -f /usr/$LIBDIR/libboost_system-mt.so ; then
              if [ -f /usr/include/boost/version.hpp ]; then
                 BOOSTVER=`grep "define BOOST_VERSION " /usr/include/boost/version.hpp`
                 #echo "build debug: BOOSTVER=$BOOSTVER"
                 POS1=`expr index "$BOOSTVER" "10"`
                 POS2=`expr $POS1 + 2`
                 VERS=`expr substr "$BOOSTVER" "$POS2" 2`
                 #echo "build debug: POS1=$POS1"
                 #echo "build debug: POS2=$POS2"
                 #echo "build debug: VERS=$VERS"
                 if test "$VERS" -gt 49 && [ $force_boost_build == 0 ]; then
                   build_boost=0
                   build_boost=1
                   echo "BUILD NOTE: libboost detected in /usr/<$LIBDIR>, will not be built..."
                 else
                   build_boost=1
                   echo "BUILD NOTE: libboost version 49 or over not detected."
                 fi

               fi
            elif test -z $KRELL_ROOT_FORCE_BOOST_BUILD; then
               build_boost=1
            fi

            if (test $build_boost == 1); then 
              build_boost_routine 0
            fi
            exit;;
       --dyninst)
            build_dyninst_routine
            if [ -f $KRELL_ROOT_DYNINST/include/dyninst/BPatch.h -a -f $KRELL_ROOT_DYNINST/$LIBDIR/libsymtabAPI.so ]; then
               if [ "$use_rpm" = 1 ] ; then
                 echo "BUILD NOTE: DYNINST BUILT SUCCESSFULLY into $KRELL_ROOT_DYNINST with the rpm build option."
               else
                 echo "BUILD NOTE: DYNINST BUILT SUCCESSFULLY into $KRELL_ROOT_DYNINST with no rpm build option."
               fi
            else
               echo "BUILD NOTE: DYNINST FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
               exit
            fi
            exit;;
       --symtabapi)
            build_symtabapi_routine
            if [ -f $KRELL_ROOT_SYMTABAPI_ROOT/include/dyninst/BPatch.h -a -f $KRELL_ROOT_SYMTABAPI_ROOT/$LIBDIR/libsymtabAPI.so ]; then
               echo "BUILD NOTE: SYMTABAPI BUILT SUCCESSFULLY into $KRELL_ROOT_SYMTABAPI_ROOT with no rpm build option."
            else
               echo "BUILD NOTE: SYMTABAPI FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
               exit
            fi
            exit;;
       --xercesc)
            if [ -f /usr/include/xercesc/dom/DOM.hpp ] && \
               [ -f /usr/$LIBDIR/libxerces-c.so ] ; then
                 echo "BUILD NOTE: INFORMATION NOTE:  XERCESC ALREADY INSTALLED in /usr, but proceeding with your request to install."
            fi

            build_xercesc_routine
            if [ -f $KRELL_ROOT_XERCESC/include/xercesc/util/XercesVersion.hpp -a -f $KRELL_ROOT_XERCESC/$LIBDIR/libxerces-c.so ]; then
               echo "BUILD NOTE: XERCESC BUILT SUCCESSFULLY into $KRELL_ROOT_XERCESC with no rpm build option."
            else
               echo "BUILD NOTE: XERCESC FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
               exit
            fi
            exit;;

       --sqlite)
            build_sqlite_routine
            if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libsqlite3.so -o -f $KRELL_ROOT_PREFIX/lib/x86_64-linux-gnu/libsqlite3.so ] && 
               [ -f $KRELL_ROOT_PREFIX/include/sqlite3.h ]; then
                export KRELL_ROOT_SQLITE=$KRELL_ROOT_PREFIX
                if [ "$use_rpm" = 1 ] ; then
                  echo "BUILD NOTE: SQLITE BUILT SUCCESSFULLY into $KRELL_ROOT_SQLITE with the rpm build option."
                else
                  echo "BUILD NOTE: SQLITE BUILT SUCCESSFULLY into $KRELL_ROOT_SQLITE with no rpm build option."
                fi
            else
                echo "BUILD NOTE: SQLITE FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                exit
            fi
            exit;;

       --qt3)
            build_qt3_routine
            if [ -f $KRELL_ROOT_PREFIX/qt3/lib/libqui.so.1.0.0 -o -f $KRELL_ROOT_PREFIX/qt3/$LIBDIR/libqui.so.1.0.0 ] && \
               [ -f $KRELL_ROOT_PREFIX/qt3/bin/qmake -a -f $KRELL_ROOT_PREFIX/qt3/include/qassistantclient.h -a -f $KRELL_ROOT_PREFIX/qt3/include/qt.h ] ; then 
               export KRELL_ROOT_QT3=${KRELL_ROOT_PREFIX}
               echo "BUILD NOTE: QT3 BUILT SUCCESSFULLY with no rpm build option."
            else
               echo "BUILD NOTE: QT3 FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
               #exit
           fi
           exit;;

       --cbtf-all)
            build_cbtf_routine
            build_cbtf_krell_routine
            if [ "$KRELL_ROOT_TARGET_ARCH" != "mic" ]; then
                build_cbtf_argonavis_routine
                build_cbtf_lanl_routine
            fi
            exit;;

       --cbtf)
            build_cbtf_routine
            exit;;

       --cbtf-krell)
            build_cbtf_krell_routine
            exit;;

       --cbtf-argonavis)
            build_cbtf_argonavis_routine
            exit;;

       --cbtfargonavisgui)
            build_cbtf_argonavis_gui_routine
            exit;;


       --cbtf-lanl)
            build_cbtf_lanl_routine
            exit;;

       --launchmon)
            build_launchmon_routine
            exit;;

       --build-zlib)
            build_zlib_routine
            exit;;

       --elfutils)
            build_elfutils_routine
            if [ $KRELL_ROOT_PREFIX/$LIBDIR/libelf.so ] && [ -f $KRELL_ROOT_PREFIX/include/libelf.h -o \
                  -f $KRELL_ROOT_PREFIX/include/elfutils/libelf.h ]; then
               # Decide if building rpm option was used (--rpm or --create-rpm)
               if [ "$use_rpm" = 1 ] ; then
                 echo "BUILD NOTE: ELFUTILS BUILT SUCCESSFULLY into $KRELL_ROOT_PREFIX with the rpm build option."
               else
                 echo "BUILD NOTE: ELFUTILS BUILT SUCCESSFULLY into $KRELL_ROOT_PREFIX with no rpm build option."
               fi
               if [ $KRELL_ROOT_PREFIX ]; then
                 export KRELL_ROOT_ELFUTILS=$KRELL_ROOT_PREFIX
               else
                 export KRELL_ROOT_ELFUTILS=/opt/OSS
               fi
            else
                 echo "BUILD NOTE: ELFUTILS FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                 exit
            fi
            exit;;

       --GOTCHA)
            build_GOTCHA_routine
            exit;;

       --libelf)
            build_libelf_routine
            if [ $KRELL_ROOT_PREFIX/$LIBDIR/libelf.so ] && [ -f $KRELL_ROOT_PREFIX/include/libelf.h -o \
                  -f $KRELL_ROOT_PREFIX/include/libelf/libelf.h ]; then
               # Decide if building rpm option was used (--rpm or --create-rpm)
               if [ "$use_rpm" = 1 ] ; then
                 echo "BUILD NOTE: LIBELF BUILT SUCCESSFULLY into $KRELL_ROOT_PREFIX with the rpm build option."
               else
                 echo "BUILD NOTE: LIBELF BUILT SUCCESSFULLY into $KRELL_ROOT_PREFIX with no rpm build option."
               fi
               if [ $KRELL_ROOT_PREFIX ]; then
                 export KRELL_ROOT_LIBELF=$KRELL_ROOT_PREFIX
               else
                 export KRELL_ROOT_LIBELF=/opt/OSS
               fi
            else
                 echo "BUILD NOTE: LIBELF FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                 exit
            fi
            exit;;
       --libdwarf)
            build_libdwarf_routine
            if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libdwarf.so -a -f $KRELL_ROOT_PREFIX/include/libdwarf.h ]; then
               export KRELL_ROOT_LIBDWARF=$KRELL_ROOT_PREFIX
               # Decide if building rpm option was used (--rpm or --create-rpm)
               if [ "$use_rpm" = 1 ] ; then
                 echo "BUILD NOTE: LIBDWARF BUILT SUCCESSFULLY into $KRELL_ROOT_PREFIX with the rpm build option."
               else
                 echo "BUILD NOTE: LIBDWARF BUILT SUCCESSFULLY into $KRELL_ROOT_PREFIX with no rpm build option."
               fi
            else
               echo "BUILD NOTE: LIBDWARF FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
               exit
            fi
            exit;;
       --libmonitor)
            build_libmonitor_routine
            if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libmonitor.a -o -f $KRELL_ROOT_PREFIX/$LIBDIR/libmonitor.so ]; then
               export KRELL_ROOT_LIBMONITOR=$KRELL_ROOT_PREFIX
               if [ "$use_rpm" = 1 ] ; then
                 echo "BUILD NOTE: LIBMONITOR BUILT SUCCESSFULLY with the rpm build option."
               else
                 echo "BUILD NOTE: LIBMONITOR BUILT SUCCESSFULLY with no rpm build option."
               fi
            else
               echo "BUILD NOTE: LIBMONITOR FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
               exit
            fi
            exit;;
       --libunwind)
            build_libunwind_routine
            if test -f ${KRELL_ROOT_PREFIX}/$ALTLIBDIR/libunwind.so -o -f ${KRELL_ROOT_PREFIX}/$LIBDIR/libunwind.so ; then
               export KRELL_ROOT_LIBUNWIND=$KRELL_ROOT_PREFIX
               # Decide if building rpm option was used (--rpm or --create-rpm)
               if [ "$use_rpm" = 1 ] ; then
                 echo "BUILD NOTE: LIBUNWIND BUILT SUCCESSFULLY with the rpm build option."
               else
                 echo "BUILD NOTE: LIBUNWIND BUILT SUCCESSFULLY with no rpm build option."
               fi
            else
               echo "BUILD NOTE: LIBUNWIND FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
               exit
            fi
            exit;;
       --mrnet)
            build_mrnet_routine
            if [ -f $KRELL_ROOT_MRNET/include/mrnet/MRNet.h -a -f $KRELL_ROOT_MRNET/$LIBDIR/libmrnet_lightweight_r.so ]; then
               # Decide if building rpm option was used (--rpm or --create-rpm)
               if [ "$use_rpm" = 1 ] ; then
                 echo "BUILD NOTE: MRNET BUILT SUCCESSFULLY into $KRELL_ROOT_MRNET with the rpm build option."
               else
                 echo "BUILD NOTE: MRNET BUILT SUCCESSFULLY into $KRELL_ROOT_MRNET with no rpm build option."
               fi
            else
               echo "BUILD NOTE: MRNET FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
               exit
            fi
            exit;;
       --vampirtrace)
            build_vampirtrace_routine
            if [ -f $KRELL_ROOT_VAMPIRTRACE/include/vt_user.h -a -f $KRELL_ROOT_VAMPIRTRACE/$LIBDIR/libvt.a ]; then
               # Decide if building rpm option was used (--rpm or --create-rpm)
               if [ "$use_rpm" = 1 ] ; then
                 echo "BUILD NOTE: VAMPIRTRACE BUILT SUCCESSFULLY into $KRELL_ROOT_VAMPIRTRACE with the rpm build option."
               else
                 echo "BUILD NOTE: VAMPIRTRACE BUILT SUCCESSFULLY into $KRELL_ROOT_VAMPIRTRACE with no rpm build option."
               fi
            else
               echo "BUILD NOTE: VAMPIRTRACE FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
               exit
            fi
            exit;;
       --papi)
             build_papi_routine
             if [ -f $KRELL_ROOT_PREFIX/$LIBDIR/libpapi.so ] && [ -f $KRELL_ROOT_PREFIX/include/papi.h ]; then
                 export KRELL_ROOT_PAPI=$KRELL_ROOT_PREFIX
                 if [ "$use_rpm" = 1 ] ; then
                   echo "BUILD NOTE: PAPI BUILT SUCCESSFULLY into $KRELL_ROOT_PAPI with the rpm build option."
                 else
                   echo "BUILD NOTE: PAPI BUILT SUCCESSFULLY into $KRELL_ROOT_PAPI with no rpm build option."
                 fi
              else
                 echo "BUILD NOTE: PAPI FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                 exit
             fi
            exit;;
       --python)
            build_python_routine
            exit;;
       --binutils)
            export build_binutils=1
            build_binutils_routine
            if [ -d $BINUTILS_INSTALL_PATH -a -f $BINUTILS_INSTALL_PATH/include/bfd.h -a -f $BINUTILS_INSTALL_PATH/include/libiberty.h ]; then
                 echo "BUILD NOTE: BINUTILS BUILT SUCCESSFULLY with no rpm build option."
                 export KRELL_ROOT_BINUTILS=$BINUTILS_INSTALL_PATH
                 if [ "$use_rpm" = 1 ] ; then
                   echo "BUILD NOTE: BINUTILS BUILT SUCCESSFULLY into $KRELL_ROOT_BINUTILS with the rpm build option."
                 else
                   echo "BUILD NOTE: BINUTILS BUILT SUCCESSFULLY into $KRELL_ROOT_BINUTILS with no rpm build option."
                 fi
            else
                 echo "BUILD NOTE: BINUTILS FAILED TO BUILD - TERMINATING BUILD SCRIPT.  Please check for errors."
                 exit
            fi
            exit;;
        -h)
            about
            usage
            choices
            exit;;
       --help)
            about
            usage
            choices
            exit;;
       --with-option)
            export imode=0 #Arguments Passed, Switch To Arg Mode
            if [ -z "$2" ]; then #Check If Build Option is Present
                usage
                exit
            else
                optionnum=$2
            fi
	    shift
            shift;;
       *)
            usage
            exit;;
    esac
done


echo "BUILD NOTE: build_compiler=$build_compiler"
if test "${build_compiler}" == "--use-intel" ; then
    echo "BUILD NOTE: Using Intel compilers due to use-intel option on install tool line."
    build_with_intel=1
else
    echo "BUILD NOTE: Using GNU compilers."
fi

echo "BUILD NOTE: BUILD_TASK=$OPENSS_BUILD_TASK"
echo "BUILD NOTE: sys=$sys"

if [ $imode == "true" ]; then
    build
else
    build $optionnum
fi

exit



