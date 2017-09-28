#!/bin/bash 

#set -x

# Developers Package Version Numbers
autoconfver=2.68
automakever=1.11.1
m4ver=1.4.13
libtoolver=2.4.2
Pythonver=2.7.3
bisonver=2.6
boostver=1_53_0
xercescver=3.1.1
launchmonver=20121010

# Package Version Numbers
binutilsver=2.20.51
qtver=3.3.8b
libelfver=0.8.13
libdwarfver=20130207
libunwindver=20130417
papiver=5.1.1
sqlitever=3.7.12
monitorver=20130218
vampirtracever=5.3.2
dyninstver=8.1.2
symtabapiver=8.1.2
mrnetver=20130726
openspeedshopver=2.0.2
cbtfver=20130729

default_oss_prefix=/opt/OSS

# Variables for the search for prerequisite components.
found_libelf=0
found_libxml2=0
found_binutils=0
found_qt=0
found_python=0
found_bison_flex=0
found_libtool=0
found_ltdl=0
found_qtdir_set=0
found_patch=0
found_autoconf=0
found_automake=0
found_rpm=0

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
##  echo "OSVER=$OSVER"
##  echo "POS1=$POS1"
##  echo "POS2=$POS2"
##  echo "VERS=$VERS"
#
#  # Version 2.6.31 of the kernel uses perf_counter.h and all subsequent versions use perf_event.h
#  if test "$VERS" -gt 30; then
#    papiver=4.1.0
#  fi
#
#fi

# Identifies missing prerequisites
function prefixPrereq() {
	echo "   "
	echo "   "
	echo "    Checking to see if OPENSS_PREFIX is set.  This is the installation path for all "
	echo "    the OpenSpeedShop supporting components and also the OpenSpeedShop components."
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
          echo "                                        export OPENSS_PREFIX=/opt/openspeedshop-2.0.2"
 	  echo "                                      or "
          echo "                                        export OPENSS_PREFIX=/home/<user>/openspeedshop-2.0.2"
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
              echo "Continuing the build process."
              echo 
          else
              echo "   "
              exit
          fi

	fi       
}

# Identifies missing prerequisites
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
     echo "                 if using OPENSS_INSTRUMENTOR=offline, however,"
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
#  Check for autoconf
   if [ -f /usr/bin/autoconf ]; then
     echo "    NOTE: autoconf was detected in /usr/bin"
     found_autoconf=1
   else
     found_autoconf=0
     echo "    CAUTION: autoconf was not detected - please install autoconf or build the OpenSpeedShop"
     echo "             version supplied by using --devel and setting up OPENSS_AUTOTOOLS_ROOT, it is needed to "
     echo "             in the configuration of components needed in order to build OpenSpeedShop."
   fi
#  Check for automake
   if [ -f /usr/bin/automake ]; then
     echo "    NOTE: automake was detected in /usr/bin"
     found_automake=1
   else
     found_automake=0
     echo "    CAUTION: automake was not detected - please install automakeconf or build the OpenSpeedShop"
     echo "             version supplied by using --devel and setting up OPENSS_AUTOTOOLS_ROOT, it is needed to "
     echo "             in the configuration of components needed in order to build OpenSpeedShop."
   fi
#  Check for GNU patch
   if [ -f /usr/bin/patch ]; then
     echo "    NOTE: GNU patch was detected in /usr/bin"
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
#  Check for libxml2-devel
#   echo "OPENSS_LIBXML2/=$OPENSS_LIBXML2/"
#   echo "OPENSS_LIBXML2/$LIBDIR/libxml2.so.2/=$OPENSS_LIBXML2/$LIBDIR/libxml2.so.2"
#   echo "OPENSS_LIBXML2/$ALTLIBDIR/libxml2.so.2/=$OPENSS_LIBXML2/$ALTLIBDIR/libxml2.so.2"
#   echo "OPENSS_LIBXML2/include/libxml2/libxml/xmlwriter.h=$OPENSS_LIBXML2/include/libxml2/libxml/xmlwriter.h"

   if [ -f $OPENSS_LIBXML2/$LIBDIR/libxml2.so.2 -o $OPENSS_LIBXML2/$ALTLIBDIR/libxml2.so.2 ] && [ -f $OPENSS_LIBXML2/include/libxml2/libxml/xmlwriter.h ]; then
     echo "    NOTE: libxml2 and libxml2-devel detected in $OPENSS_LIBXML2/<lib>..."
     found_libxml2=1
   elif [ -f /usr/$LIBDIR/libxml2.so.2 -a -f /usr/include/libxml2/libxml/xmlwriter.h ]; then
     echo "    NOTE: libxml2 and libxml2-devel detected in /usr/<lib>..."
     found_libxml2=1
   else
     found_libxml2=0
     if [ "$found_libxml2" = 0 -a $OPENSS_INSTRUMENTOR == "offline" ]; then
        echo "    CAUTION: libxml2 and libxml2-devel were not detected, but OPENSS_INSTRUMENTOR is offline, so they are not needed."
     else
        echo "    PROBLEM: libxml2 and/or libxml2-devel not detected - please install libxml2"
        echo "              and/or libxml2-devel versions that match your system."
     fi
   fi

#  
#  Check for binutils-devel
#  
   if [ -f /usr/bin/ld -a -f /usr/include/bfd.h -a -f /usr/include/libiberty.h ]; then
     echo "    NOTE: binutils and binutils-devel detected in /usr/bin and /usr/<lib>..."
     found_binutils=1
   else
     found_binutils=0
     echo "    PROBLEM: binutils and/or binutils-devel not detected - please install binutils"
     echo "              and/or binutils-devel versions that match your system."
     if [ -f /usr/bin/ld ]; then
        echo "    binutils-devel: detected missing file: /usr/bin/ld"
        export build_binutils=1
     fi
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
   if [ -z $OPENSS_FORCE_QT_BUILD ] ; then
      force_qt_build=0
   else
      force_qt_build=1
   fi

   # DETECT QT3 INSTALLATIONS
   #echo "OPENSS_QT3=$OPENSS_QT3"
   #echo "OPENSS_QT3/LIBDIR=$OPENSS_QT3/$LIBDIR"

   if [ ! -z $OPENSS_FORCE_QT_BUILD ] ; then
     found_qt=0
     echo "    NOTE: OPENSS_FORCE_QT_BUILD was detected qt3 will be installed."
   elif [ -f $OPENSS_QT3/lib/libqui.so.1.0.0 -a -f $OPENSS_QT3/bin/qmake -o \
          -f $OPENSS_QT3/bin/qmake -a -f $OPENSS_QT3/$LIBDIR/libqui.so.1.0.0 -a -f $OPENSS_QT3/include/qt3/qassistantclient.h -a -f $OPENSS_QT3/qt.h ]; 
   then
     found_qt=1
     export QTDIR=OPENSS_QT3
     echo "    NOTE: qt and qt-devel detected in $OPENSS_QT3."
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
   if [ -f /usr/bin/python -a -f /usr/include/python2.5/Python.h -o \
        -f /usr/include/python2.4/Python.h -o -f /usr/include/python2.6/Python.h -o \
        -f /usr/include/python2.7/Python.h -o -f /usr/include/python2.3/Python.h ]; then
     echo "    NOTE: python and python-devel detected in /usr/bin and /usr/<lib>..."
     found_python=1
   else
     if [ $OPENSS_PYTHON ]; then
       if [ -f $OPENSS_PYTHON/bin/python -a -f $OPENSS_PYTHON/include/python2.5/Python.h -o \
            -f $OPENSS_PYTHON/include/python2.4/Python.h -o -f $OPENSS_PYTHON/include/python2.6/Python.h -o \
            -f $OPENSS_PYTHON/include/python2.7/Python.h -o -f $OPENSS_PYTHON/include/python2.3/Python.h ]; then
            echo "    NOTE: python and python-devel detected in $OPENSS_PYTHON/bin and $OPENSS_PYTHON/<lib>..."
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
   if [ -f /usr/bin/flex -o -f /usr/bin/bison ]; then
     echo "    NOTE: flex and/or bison was detected in /usr/bin"
     found_bison_flex=1
   else
     found_bison_flex=0
     echo "    PROBLEM: flex and/or bison was not detected - please install a flex or bison version that match your system."
     echo "    NOTE: only one, either flex or bison, is needed.."
   fi
#  
#  Check for libtool
#  
   if [ -f /usr/bin/libtool -a -f /usr/bin/libtoolize ]; then
     echo "    NOTE: libtool was detected in /usr/bin"
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
   if [ -f /usr/bin/rpm -o -f /bin/rpm ]; then
     echo "    NOTE: rpm was detected in /usr/bin or /bin"
     found_rpm=1
   else
     found_rpm=0
     echo "    PROBLEM: rpm was not detected - please install rpm, it is needed to "
     echo "             in order to do the installation of the build components"
     echo "             into the OPENSS_PREFIX location."
   fi
#  
#  Check for libltdl and libltdl-devel
#  
   if [ -f /usr/$LIBDIR/libltdl.so ] && [ -f /usr/include/ltdl.h -o -f /usr/share/libtool/libltdl/ltdl.h ]; then
     echo "    NOTE: libltdl and libltdl-devel were detected in /usr/$LIBDIR"
     found_ltdl=1
   else
     found_ltdl=0
     echo "    PROBLEM: libltdl and/or libltdl-devel were not detected - please install the libltdl and/or libltdl-devel version that match your system."
   fi


   echo "   "
   echo "   "
   echo "OPENSS_INSTRUMENTOR=$OPENSS_INSTRUMENTOR"
   echo "found_libxml2=$found_libxml2"


   if [ $report_missing_packages ]; then

     if  [ "$found_libxml2" = 0 -a $OPENSS_INSTRUMENTOR != offline ]  || \
         [  "$found_binutils" = 0 -a $build_binutils == 0 ] || \
         [ "$found_rpm" = 0 ] || \
         [ "$found_patch" = 0  ] || \
         [ "$found_bison_flex" = 0  ] || \
         [ "$found_python" = 0 ] ; then
          echo "   "
          echo "   "
          echo "    PROBLEM: You have the option to stop the build script because it will "
          echo "             fail because of missing packages.  The above mentioned packages which"
          echo "             have been identified as not being present on your system, need to" 
          echo "             be installed before trying to build and install OpenSpeedShop and"
          echo "             its components.   Sorry for this inconvenience."
          echo "   "
          echo "             Please contact us via this email alias: oss-questions@openspeedshop.org "
          echo "   "
          echo 
          echo "Continue the build process anyway? <y/n>"
          echo
         
          read answer
         
          if [ "$answer" = Y -o "$answer" = y ]; then
              echo
              echo "Continuing the build process."
              echo 
          else
              echo "   "
              exit
          fi
     fi
   fi

}


# Prints Script Usage
function usage() {
    cat << EOF
    usage:
        install.sh [--with-option choiceNum] install.sh [-h | --help]

EOF
}

# Prints Script Info
function about() {
    cat << EOF

    ---------------------------------------------------------------------------
    This script builds RPMs and supports installation as non-root through cpio
    
    The default install prefix is /opt/OSS. If another is preferred, please set
    the OPENSS_PREFIX environment variable to reflect the new target directory   
     
    If you plan on installing RPMs as root, it will let you know at what point

    Typical build only needs these OpenSpeedShop build variables set:
    export OPENSS_PREFIX to the directory where you want OpenSpeeShop installed
    export OPENSS_MPI_<mpt type> to install directory of <mpi type> = {MPT, OPENMPI, MPICH2, ...}
    ---------------------------------------------------------------------------

EOF
}

# Prints Script Choices
function choices() {
    cat << EOF
    Choices:
    
    1  - Build binutils (optional), Check/Build libelf libraries
    1a - Install binutils (optional), libelf, if built (non-root/cpio)
    2  - Build base Support libraries: libdwarf
    2a - Install libdwarf if built (non-root/cpio)
         - Otherwise install RPM manually at this point
    3  - Build base Support libraries: libunwind, papi, sqlite, monitor
    3a - Install base Support libraries (non-root/cpio): libunwind, papi,
         sqlite, monitor
         - Otherwise install RPMs manually at this point
    4  - Build base Support libraries: vampirtrace, dyninst (online) or symtabapi (offline)
    4a - Install base Support library (non-root/cpio): vampirtrace, dyninst (online) or symtabapi (offline)
         - Otherwise install RPMs manually at this point
    5  - Build base Support libraries: mrnet
    5a - Install base Support library: mrnet
         - Otherwise install RPMs manually at this point
    6  - Check if base GUI support library is installed, build if necessary: qt3/qt3.3
    6a - Install base GUI support library if built (non-root/cpio): qt3/qt-3.3
         - Otherwise install RPMs manually at this point
    7  - Build Open|SpeedShop
    7a - Install Open|SpeedShop
         - Otherwise install RPMs manually at this point
    8  - Install status

    9  - Automatic - Run all steps with no questions asked. Assume that the
                     answer to any question which will be asked is yes. Please
                     make certain that all required environment variables are
                     set properly. It may be best for fresh installations
                     to run though the choices one at a time, in ascending
                     order, as this may help discover any missing system
                     dependencies.  Everything will be installed in
                     /opt/OSS (if OPENSS_PREFIX is not set) via cpio process

    Please feel free to contact us via this email alias: oss-questions@openspeedshop.org

EOF
}

# Print Important Environmental Variables
function envvars() {
    cat << EOF
    
    OPENSS Environment Variables:
        -General
            OPENSS_PREFIX           Set to alternate install prefix.  default is /opt/OSS
            OPENSS_INSTRUMENTOR     Set to the underlying instrumentation type openss will use.  default is offline (does not include online/mrnet)
            OPENSS_TARGET_ARCH      Set to the target architecture to build the Open|SpeedShop runtime environment for.
            OPENSS_PPC64_BITMODE_64 Set to indicate you want a 64 bit version of ppc64 OSS built.  Set to 1 or leave unset to indicate 32 bit build.
            OPENSS_IMPLICIT_TLS     When set, this enables Open|SpeedShop to use implicitly created tls storage. default is explicit.
        
        -Open|SpeedShop MPI and Vampirtrace
            OPENSS_MPI_LAM          Set to MPI LAM installation dir. default is null.
            OPENSS_MPI_LAMPI        Set to MPI LAMPI installation dir. default is null.
            OPENSS_MPI_OPENMPI      Set to MPI OPENMPI installation dir. default is null.
            OPENSS_MPI_MPICH        Set to MPI MPICH installation dir. default is null.
            OPENSS_MPI_MPICH_DRIVER Set to mpich driver name [ch-p4]. default is null.
            OPENSS_MPI_MPICH2       Set to MPI MPICH2 installation dir. default is null.
            OPENSS_MPI_MPICH2_DRIVER  Set to mpich2 driver name [cray]. default is null.
            OPENSS_MPI_MPT          Set to SGI MPI MPT installation dir. default is null.
            OPENSS_MPI_MVAPICH      Set to MPI MVAPICH installation dir. default is null.
            OPENSS_MPI_MVAPICH2     Set to MPI MVAPICH2 installation dir. default is null.
        -Open|SpeedShop Use This Component instead of building it
            OPENSS_OFED             Set to OPEN FABRICS installation dir. default is /usr.
            OPENSS_QT3              Use this qt3 package instead of building it.  default is /usr
            OPENSS_PYTHON           Use this python package instead of building it.  default is /usr
            OPENSS_BINUTILS         Use this binutils package instead of building it.  default is /usr
            OPENSS_LIBXML2          Use this libxml2 package instead of building it.  default is /usr
            OPENSS_LIBELF           Use this libelf package instead of building it.  default is /usr
            OPENSS_LIBDWARF         Use this libdwarf package instead of building it.  default is /usr
            OPENSS_PAPI             Use this papi package instead of building it.  default is /usr
            OPENSS_SQLITE           Use this sqlite package instead of building it.  default is /usr
        -Open|SpeedShop Force the build of this component, even if installed on the system
            OPENSS_FORCE_LIBELF_BUILD         Force the build of libelf even if one is installed
            OPENSS_FORCE_LIBDWARF_BUILD       Force the build of libdwarf even if one is installed
            OPENSS_FORCE_PAPI_BUILD           Force the build of papi even if one is installed
            OPENSS_FORCE_SQLITE_BUILD         Force the build of sqlite even if one is installed
            OPENSS_FORCE_QT_BUILD             Force the build of qt3 even if one is installed
    
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
	if [ $OPENSS_INSTRUMENTOR ]; then
		echo "         Using OPENSS_INSTRUMENTOR=$OPENSS_INSTRUMENTOR"
	fi       
	if [ $OPENSS_TARGET_ARCH ]; then
		echo "         Using target architecture, OPENSS_TARGET_ARCH=$OPENSS_TARGET_ARCH"
	fi       
	if [ $OPENSS_BINUTILS ]; then
		echo "         Using OPENSS_BINUTILS=$OPENSS_BINUTILS"
	fi       
	if [ $OPENSS_OFED ]; then
		echo "         Using OPENSS_OFED=$OPENSS_OFED"
	fi       
	if [ $OPENSS_PYTHON ]; then
		echo "         Using OPENSS_PYTHON=$OPENSS_PYTHON"
	fi       
	if [ $OPENSS_RESOLVE_SYMBOLS ]; then
		echo "         Using OPENSS_RESOLVE_SYMBOLS=$OPENSS_RESOLVE_SYMBOLS"
	fi       
	if [ $OPENSS_SYMTABAPI ]; then
		echo "         Using OPENSS_SYMTABAPI=$OPENSS_SYMTABAPI"
	fi       
	if [ $OPENSS_LIBXML2 ]; then
		echo "         Using OPENSS_LIBXML2=$OPENSS_LIBXML2"
	fi       
	if [ $OPENSS_EXPLICIT_TLS ]; then
		echo "         Using explicitly generated Thread local storage areas within Open|SpeedShop"
	fi       
	if [ $OPENSS_IMPLICIT_TLS ]; then
		echo "         Using implicitly generated Thread local storage areas within Open|SpeedShop"
	fi       
	if [ $OPENSS_DYNINST_VERS ]; then
		echo "         Using OPENSS_DYNINST_VERS=$OPENSS_DYNINST_VERS"
	fi       
	if [ $OPENSS_MRNET_VERS ]; then
		echo "         Using OPENSS_MRNET_VERS=$OPENSS_MRNET_VERS"
	fi       
	if [ $OPENSS_SYMTABAPI_VERS ]; then
		echo "         Using OPENSS_SYMTABAPI_VERS=$OPENSS_SYMTABAPI_VERS"
	fi       
	if [ $OPENSS_PPC64_BITMODE_64 ]; then
		echo "         Using OPENSS_PPC64_BITMODE_64=$OPENSS_PPC64_BITMODE_64"
	fi       
    cat << EOF
    
        -Open|SpeedShop MPI and Vampirtrace

EOF
	if [ $OPENSS_MPI_LAM ]; then
		echo "         Using OPENSS_MPI_LAM=$OPENSS_MPI_LAM"
	fi       
	if [ $OPENSS_MPI_LAMPI ]; then
		echo "         Using OPENSS_MPI_LAMPI=$OPENSS_MPI_LAMPI"
	fi       
	if [ $OPENSS_MPI_OPENMPI ]; then
		echo "         Using OPENSS_MPI_OPENMPI=$OPENSS_MPI_OPENMPI"
	fi       
	if [ $OPENSS_MPI_MPICH ]; then
		echo "         Using OPENSS_MPI_MPICH=$OPENSS_MPI_MPICH"
	fi       
	if [ $OPENSS_MPI_MPICH_DRIVER ]; then
		echo "         Using OPENSS_MPI_MPICH_DRIVER=$OPENSS_MPI_MPICH_DRIVER"
	fi       
	if [ $OPENSS_MPI_MPICH2 ]; then
		echo "         Using OPENSS_MPI_MPICH2=$OPENSS_MPI_MPICH2"
	fi       
        if [ $OPENSS_MPI_MPICH2_DRIVER ]; then
                echo "         Using OPENSS_MPI_MPICH2_DRIVER=$OPENSS_MPI_MPICH2_DRIVER"
        fi
	if [ $OPENSS_MPI_MPT ]; then
		echo "         Using OPENSS_MPI_MPT=$OPENSS_MPI_MPT"
	fi       
	if [ $OPENSS_MPI_MVAPICH ]; then
		echo "         Using OPENSS_MPI_MVAPICH=$OPENSS_MPI_MVAPICH"
	fi       
	if [ $OPENSS_MPI_MVAPICH2 ]; then
		echo "         Using OPENSS_MPI_MVAPICH2=$OPENSS_MPI_MVAPICH2"
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

# Print instrumentor information.  If $OPENSS_INSTRUMENTOR is not defined,
# OPENSS_INSTRUMENTOR is set to offline.
function instrumentor() {
    if [ $OPENSS_INSTRUMENTOR ]; then
        cat << EOF

    You are building for Open|SpeedShop instrumentor: $OPENSS_INSTRUMENTOR
    You have manually specified a Open|SpeedShop instrumentor using
    the environment variable OPENSS_INSTRUMENTOR to override the
    default Open|SpeedShop instrumentor: offline.
        
EOF
    else
        cat << EOF

    You are building for default Open|SpeedShop instrumentor: offline.
    If you wish to change the Open|SpeedShop instrumentor, use
    the OPENSS_INSTRUMENTOR to specify: mrnet, or offline.

EOF
            export OPENSS_INSTRUMENTOR="offline"
    fi 
}

# Main Build Function
function build_autotools() { 
   echo ""
   echo "Building autotools: autoconf, automake, m4, and libtool."
   echo ""
   echo "The script will use $OPENSS_PREFIX/autotools_root as installation unless OPENSS_AUTOTOOLS_ROOT is set."
   echo "If OPENSS_PREFIX and OPENSS_AUTOTOOLS_ROOT are both not set then the build script warns and halts."
   echo ""

   if [ -z $OPENSS_AUTOTOOLS_ROOT ]; then 
        echo "   "
        echo "         OPENSS_AUTOTOOLS_ROOT is NOT set."
        echo "   "
	if [ $OPENSS_PREFIX ]; then
          echo "   "
 	  echo "         Using OPENSS_PREFIX=$OPENSS_PREFIX"
          export OPENSS_AUTOTOOLS_ROOT=$OPENSS_PREFIX/autotools_root
          echo "         Using OPENSS_AUTOTOOLS_ROOT based on OPENSS_PREFIX, OPENSS_AUTOTOOLS_ROOT=$OPENSS_AUTOTOOLS_ROOT"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: OPENSS_PREFIX"
          echo "             and OPENSS_AUTOTOOLS_ROOT are not set.  "
          echo "             If OPENSS_PREFIX is set then OPENSS_PREFIX/autotools_root will be used for"
          echo "             OPENSS_AUTOTOOLS_ROOT."
          echo "   "
          echo "    PLEASE SET OPENSS_PREFIX OR OPENSS_AUTOTOOLS_ROOT and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         OPENSS_AUTOTOOLS_ROOT was set."
      echo "         Using OPENSS_AUTOTOOLS_ROOT=$OPENSS_AUTOTOOLS_ROOT"
      echo "   "
   fi

   echo 
   echo "Continue the build process for the autotools root? <y/n>"
   echo

   read answer
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the autotools build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     export LD_LIBRARY_PATH=$OPENSS_AUTOTOOLS_ROOT/lib
   else
     export LD_LIBRARY_PATH=$OPENSS_AUTOTOOLS_ROOT/lib:$LD_LIBRARY_PATH
   fi

   if [ -z $PATH ]; then 
     export PATH=$OPENSS_AUTOTOOLS_ROOT/bin:$PATH
   else
     export PATH=$OPENSS_AUTOTOOLS_ROOT/bin:$PATH
   fi

   # m4
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   cp SOURCES/m4-$m4ver.tar.gz BUILD/$sys/m4-$m4ver.tar.gz
   cd BUILD/$sys
   tar -xzvf m4-$m4ver.tar.gz
   cd m4-$m4ver
   ./configure --prefix=$OPENSS_AUTOTOOLS_ROOT
   make; make install
   cd ../../..

   if [ -z $OPENSS_AUTOTOOLS_ROOT_ASK ]; then
     echo 
   else
     echo 
     echo "Continue the build process for the autotools root? <y/n>"
     echo
  
     read answer
    
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
   cp SOURCES/autoconf-$autoconfver.tar.gz BUILD/$sys/autoconf-$autoconfver.tar.gz
   cd BUILD/$sys
   tar -xzvf autoconf-$autoconfver.tar.gz
   cd autoconf-$autoconfver
   patch -p1 < autoconf-$autoconfver.patch
   ./configure --prefix=$OPENSS_AUTOTOOLS_ROOT
   make; make install
   cd ../../..

   if [ -z $OPENSS_AUTOTOOLS_ROOT_ASK ]; then
     echo 
   else
     echo 
     echo "Continue the build process for the autotools root? <y/n>"
     echo
  
     read answer
    
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
   cp SOURCES/automake-$automakever.tar.gz BUILD/$sys/automake-$automakever.tar.gz
   cd BUILD/$sys
   tar -xzvf automake-$automakever.tar.gz
   cd automake-$automakever
   ./configure --prefix=$OPENSS_AUTOTOOLS_ROOT
   make; make install
   cd ../../..

   if [ -z $OPENSS_AUTOTOOLS_ROOT_ASK ]; then
     echo 
   else
     echo 
     echo "Continue the build process for the autotools root? <y/n>"
     echo
  
     read answer
    
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
   cp SOURCES/libtool-$libtoolver.tar.gz BUILD/$sys/libtool-$libtoolver.tar.gz
   cd BUILD/$sys
   tar -xzvf libtool-$libtoolver.tar.gz
   cd libtool-$libtoolver
   ./configure --prefix=$OPENSS_AUTOTOOLS_ROOT
   make; make install
   cd ../../..
}


# Main Build Function
function build_python() { 
   echo ""
   echo "Building python."
   echo ""
   echo "The script will use $OPENSS_PREFIX/python_root as installation unless OPENSS_PYTHON_ROOT is set."
   echo "If OPENSS_PREFIX and OPENSS_PYTHON_ROOT are both not set then the build script warns and halts."
   echo ""

   if [ -z $OPENSS_PYTHON_ROOT ]; then 
        echo "   "
        echo "         OPENSS_PYTHON_ROOT is NOT set."
        echo "   "
	if [ $OPENSS_PREFIX ]; then
          echo "   "
 	  echo "         Using OPENSS_PREFIX=$OPENSS_PREFIX"
          export OPENSS_PYTHON_ROOT=$OPENSS_PREFIX/python_root
          echo "         Using OPENSS_PYTHON_ROOT based on OPENSS_PREFIX, OPENSS_PYTHON_ROOT=$OPENSS_PYTHON_ROOT"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: OPENSS_PREFIX"
          echo "             and OPENSS_PYTHON_ROOT are not set.  "
          echo "             If OPENSS_PREFIX is set then OPENSS_PREFIX/python_root will be used for"
          echo "             OPENSS_PYTHON_ROOT."
          echo "   "
          echo "    PLEASE SET OPENSS_PREFIX OR OPENSS_PYTHON_ROOT and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         OPENSS_PYTHON_ROOT was set."
      echo "         Using OPENSS_PYTHON_ROOT=$OPENSS_PYTHON_ROOT"
      echo "   "
   fi

   echo 
   echo "Continue the build process for the python root? <y/n>"
   echo

   read answer
  
   if [ "$answer" = Y -o "$answer" = y ]; then
       echo
       echo "Continuing the python build process."
       echo 
   else
       echo "   "
       exit
   fi

   if [ -z $LD_LIBRARY_PATH ]; then 
     export LD_LIBRARY_PATH=$OPENSS_PYTHON_ROOT/lib
   else
     export LD_LIBRARY_PATH=$OPENSS_PYTHON_ROOT/lib:$LD_LIBRARY_PATH
   fi

   if [ -z $PATH ]; then 
     export PATH=$OPENSS_PYTHON_ROOT/bin:$PATH
   else
     export PATH=$OPENSS_PYTHON_ROOT/bin:$PATH
   fi

   # python
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   cp SOURCES/Python-$Pythonver.tgz BUILD/$sys/Python-$Pythonver.tgz
   cd BUILD/$sys
   tar -xzvf Python-$Pythonver.tgz
   cd Python-$Pythonver
   ./configure --prefix=$OPENSS_PYTHON_ROOT --enable-shared
   make; make install
   cd ../../..
}

function build_cbtf_routine() { 
   echo ""
   echo "Building cbtf."
   echo ""
   echo "The script will use $CBTF_PREFIX as installation."
   echo ""

   # cbtf
   build_cbtf_script=""
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   cp SOURCES/cbtf-$cbtfver.tar.gz BUILD/$sys/cbtf-$cbtfver.tar.gz
   cd BUILD/$sys
   rm -rf cbtf
   #rm -rf cbtf-$cbtfver
   tar -xzvf cbtf-$cbtfver.tar.gz
   cd cbtf
   if [ -z $CBTF_KRELL_ROOT ]; then 
     if [ -z $OPENSS_PREFIX ]; then 
        echo "Please set CBTF_KRELL_ROOT to the location of the krell root installation director and retry"
        exit
     else
        export CBTF_KRELL_ROOT=$OPENSS_PREFIX
     fi
   else
     echo "Using CBTF_KRELL_ROOT=$CBTF_KRELL_ROOT as the krell root in building CBTF"
   fi

   if [ -z $CBTF_BOOST_ROOT ]; then 
     if [ -f /$CBTF_KRELL_ROOT/$LIBDIR/libboost_serialization.so -o -f /$CBTF_KRELL_ROOT/$LIBDIR/libboost_serialization-mt.so ] && \
        [ -f /$CBTF_KRELL_ROOT/$LIBDIR/libboost_system.so -o -f /$CBTF_KRELL_ROOT/$LIBDIR/libboost_system-mt.so ] ; then
        export CBTF_BOOST_ROOT=$CBTF_KRELL_ROOT
        export CBTF_BOOST_ROOT_LIB=$CBTF_KRELL_ROOT/$LIBDIR
     elif [ -f /usr/$LIBDIR/libboost_serialization.so -o -f /usr/$LIBDIR/libboost_serialization-mt.so ]; then
        export CBTF_BOOST_ROOT=/usr
        export CBTF_BOOST_ROOT_LIB=/usr/$LIBDIR
     else
        echo "Please set CBTF_BOOST_ROOT to the location of the boost installation directory and retry. We could not detect a boost installation in CBTF_KRELL_ROOT=$CBTF_KRELL_ROOT or /usr"
        exit
     fi
   else
     echo "Using CBTF_BOOST_ROOT=$CBTF_BOOST_ROOT as the boost root in building CBTF"
   fi
   if [ -z $CBTF_PREFIX ]; then 
     echo "Please set CBTF_PREFIX to the location of the CBTF installation directory and retry"
     exit
   else
     echo "Using CBTF_PREFIX=$CBTF_PREFIX as the CBTF installation directory."
   fi

   ../../../detect_installed.sh > build_cbtf_script
   while read line
   do
     echo "$line"
     eval $line
   done < build_cbtf_script

   cd ../../..
}

function build_bison() { 
   echo ""
   echo "Building bison."
   echo ""
   echo "The script will use $OPENSS_PREFIX/bison_root as installation unless OPENSS_BISON_ROOT is set."
   echo "If OPENSS_PREFIX and OPENSS_BISON_ROOT are both not set then the build script warns and halts."
   echo ""

   if [ -z $OPENSS_BISON_ROOT ]; then 
        echo "   "
        echo "         OPENSS_BISON_ROOT is NOT set."
        echo "   "
	if [ $OPENSS_PREFIX ]; then
          echo "   "
 	  echo "         Using OPENSS_PREFIX=$OPENSS_PREFIX"
          export OPENSS_BISON_ROOT=$OPENSS_PREFIX/bison_root
          echo "         Using OPENSS_BISON_ROOT based on OPENSS_PREFIX, OPENSS_BISON_ROOT=$OPENSS_BISON_ROOT"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: OPENSS_PREFIX"
          echo "             and OPENSS_BISON_ROOT are not set.  "
          echo "             If OPENSS_PREFIX is set then OPENSS_PREFIX/bison_root will be used for"
          echo "             OPENSS_BISON_ROOT."
          echo "   "
          echo "    PLEASE SET OPENSS_PREFIX OR OPENSS_BISON_ROOT and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         OPENSS_BISON_ROOT was set."
      echo "         Using OPENSS_BISON_ROOT=$OPENSS_BISON_ROOT"
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
     export LD_LIBRARY_PATH=$OPENSS_BISON_ROOT/lib
   else
     export LD_LIBRARY_PATH=$OPENSS_BISON_ROOT/lib:$LD_LIBRARY_PATH
   fi

   if [ -z $PATH ]; then 
     export PATH=$OPENSS_BISON_ROOT/bin:$PATH
   else
     export PATH=$OPENSS_BISON_ROOT/bin:$PATH
   fi

   # bison
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   cp SOURCES/bison-$bisonver.tar.gz BUILD/$sys/bison-$bisonver.tar.gz
   cd BUILD/$sys
   tar -xzvf bison-$bisonver.tar.gz
   cd bison-$bisonver
   ./configure --prefix=$OPENSS_BISON_ROOT
   make; make install
   cd ../../..
}


function build_xercesc() { 
   echo ""
   echo "Building xercesc."
   echo ""
   echo "The script will use $OPENSS_PREFIX as installation unless OPENSS_XERCESC_ROOT is set."
   echo "If OPENSS_PREFIX and OPENSS_XERCESC_ROOT are both not set then the build script warns and halts."
   echo ""

   if [ -z $OPENSS_XERCESC_ROOT ]; then 
        echo "   "
        echo "         OPENSS_XERCESC_ROOT is NOT set."
        echo "   "
	if [ $OPENSS_PREFIX ]; then
          echo "   "
 	  echo "         Using OPENSS_PREFIX=$OPENSS_PREFIX"
          export OPENSS_XERCESC_ROOT=$OPENSS_PREFIX
          echo "         Using OPENSS_XERCESC_ROOT based on OPENSS_PREFIX, OPENSS_XERCESC_ROOT=$OPENSS_XERCESC_ROOT"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: OPENSS_PREFIX"
          echo "             and OPENSS_XERCESC_ROOT are not set.  "
          echo "             If OPENSS_PREFIX is set then OPENSS_PREFIX will be used for"
          echo "             OPENSS_XERCESC_ROOT."
          echo "   "
          echo "    PLEASE SET OPENSS_PREFIX OR OPENSS_XERCESC_ROOT and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         OPENSS_XERCESC_ROOT was set."
      echo "         Using OPENSS_XERCESC_ROOT=$OPENSS_XERCESC_ROOT"
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
     export LD_LIBRARY_PATH=$OPENSS_XERCESC_ROOT/$LIBDIR
   else
     export LD_LIBRARY_PATH=$OPENSS_XERCESC_ROOT/$LIBDIR:$LD_LIBRARY_PATH
   fi

   if [ -z $PATH ]; then 
     export PATH=$OPENSS_XERCESC_ROOT/bin:$PATH
   else
     export PATH=$OPENSS_XERCESC_ROOT/bin:$PATH
   fi

   # xercesc
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   cp SOURCES/xerces-c-$xercescver.tar.gz BUILD/$sys/xerces-c-$xercescver.tar.gz
   cd BUILD/$sys
   tar -xzvf xerces-c-$xercescver.tar.gz
   cd xerces-c-$xercescver
   ./configure --prefix=$OPENSS_XERCESC_ROOT --libdir=$OPENSS_XERCESC_ROOT/$LIBDIR --disable-network
   make; make install
   cd ../../..
}

function build_launchmon() { 
   echo ""
   echo "Building launchmon."
   echo ""
   echo "The script will use $OPENSS_PREFIX as installation unless OPENSS_LAUNCHMON_ROOT is set."
   echo "If OPENSS_PREFIX and OPENSS_LAUNCHMON_ROOT are both not set then the build script warns and halts."
   echo ""

   if [ -z $OPENSS_LAUNCHMON_ROOT ]; then 
        echo "   "
        echo "         OPENSS_LAUNCHMON_ROOT is NOT set."
        echo "   "
	if [ $OPENSS_PREFIX ]; then
          echo "   "
 	  echo "         Using OPENSS_PREFIX=$OPENSS_PREFIX"
          export OPENSS_LAUNCHMON_ROOT=$OPENSS_PREFIX
          echo "         Using OPENSS_LAUNCHMON_ROOT based on OPENSS_PREFIX, OPENSS_LAUNCHMON_ROOT=$OPENSS_LAUNCHMON_ROOT"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: OPENSS_PREFIX"
          echo "             and OPENSS_LAUNCHMON_ROOT are not set.  "
          echo "             If OPENSS_PREFIX is set then OPENSS_PREFIX will be used for"
          echo "             OPENSS_LAUNCHMON_ROOT."
          echo "   "
          echo "    PLEASE SET OPENSS_PREFIX OR OPENSS_LAUNCHMON_ROOT and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         OPENSS_LAUNCHMON_ROOT was set."
      echo "         Using OPENSS_LAUNCHMON_ROOT=$OPENSS_LAUNCHMON_ROOT"
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
     export LD_LIBRARY_PATH=$OPENSS_LAUNCHMON_ROOT/$LIBDIR
   else
     export LD_LIBRARY_PATH=$OPENSS_LAUNCHMON_ROOT/$LIBDIR:$LD_LIBRARY_PATH
   fi

   if [ -z $PATH ]; then 
     export PATH=$OPENSS_LAUNCHMON_ROOT/bin:$PATH
   else
     export PATH=$OPENSS_LAUNCHMON_ROOT/bin:$PATH
   fi

   # launchmon
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   cp SOURCES/launchmon-$launchmonver/launchmon.tar.gz BUILD/$sys/launchmon-$launchmonver.tar.gz
   cd BUILD/$sys
   tar -xzvf launchmon-$launchmonver.tar.gz
   LAUNCHMON_PATCH_LIST=`ls -1 ../../SOURCES/launchmon-$launchmonver/launchmon-*.patch`
   echo $LAUNCHMON_PATCH_LIST
   for i in $LAUNCHMON_PATCH_LIST; do
      echo APPLYING \"$i\"
      patch -p0 < $i
   done

   cd launchmon
   export USE="-nls"
   ./bootstrap
   if [ $OPENSS_MPI_OPENMPI ]; then

     ./configure --prefix=$OPENSS_PREFIX --with-rm=orte --with-rm-launcher=${OPENSS_MPI_OPENMPI}/bin/orterun --with-rm-inc=${OPENSS_MPI_OPENMPI}/include --with-rm-lib=${OPENSS_MPI_OPENMPI}/lib --enable-debug --enable-verbose 

   elif  [ $OPENSS_MPI_MVAPICH ]; then

      ./configure --prefix=$OPENSS_PREFIX --with-bootfabric=pmgr --with-rm=slurm

   fi

   make -j check
   make 
   make install
   cd ../../..
}


function build_boost_routine() { 
   echo ""
   echo "Building boost."
   echo ""
   echo "The script will use $OPENSS_PREFIX as installation unless OPENSS_BOOST_ROOT is set."
   echo "If OPENSS_PREFIX and OPENSS_BOOST_ROOT are both not set then the build script warns and halts."
   echo ""

   if [ -z $OPENSS_BOOST_ROOT ]; then 
        echo "   "
        echo "         OPENSS_BOOST_ROOT is NOT set."
        echo "   "
	if [ $OPENSS_PREFIX ]; then
          echo "   "
 	  echo "         Using OPENSS_PREFIX=$OPENSS_PREFIX"
          export OPENSS_BOOST_ROOT=$OPENSS_PREFIX
          echo "         Using OPENSS_BOOST_ROOT based on OPENSS_PREFIX, OPENSS_BOOST_ROOT=$OPENSS_BOOST_ROOT"
          echo "   "
	else
          echo "   "
          echo "    PROBLEM: The installation path environment variables: OPENSS_PREFIX"
          echo "             and OPENSS_BOOST_ROOT are not set.  "
          echo "             If OPENSS_PREFIX is set then OPENSS_PREFIX will be used for"
          echo "             OPENSS_BOOST_ROOT."
          echo "   "
          echo "    PLEASE SET OPENSS_PREFIX OR OPENSS_BOOST_ROOT and restart the install script.  Thanks."
          echo "   "
          exit
        fi
   else
      echo "   "
      echo "         OPENSS_BOOST_ROOT was set."
      echo "         Using OPENSS_BOOST_ROOT=$OPENSS_BOOST_ROOT"
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
     export LD_LIBRARY_PATH=$OPENSS_BOOST_ROOT/$LIBDIR
   else
     export LD_LIBRARY_PATH=$OPENSS_BOOST_ROOT/$LIBDIR:$LD_LIBRARY_PATH
   fi

   if [ -z $PATH ]; then 
     export PATH=$OPENSS_BOOST_ROOT/bin:$PATH
   else
     export PATH=$OPENSS_BOOST_ROOT/bin:$PATH
   fi

   # boost
   mkdir -p BUILD
   mkdir -p BUILD/$sys
   cp SOURCES/boost_$boostver.tar.gz BUILD/$sys/boost_$boostver.tar.gz
   cd BUILD/$sys
   tar -xzvf boost_$boostver.tar.gz
   cd boost_$boostver
   ./bootstrap.sh --with-libraries=all
   ./b2 --prefix=$OPENSS_BOOST_ROOT --libdir=$OPENSS_BOOST_ROOT/lib --includedir=$OPENSS_BOOST_ROOT/include link=shared toolset=gcc threading=multi install 
   cd ../../..
}


# Main Build Function
function build() { 

    if [ -z "$1" ]; then #If no parameter is passed to the function, we are in
        about            #interactive mode
        instrumentor        
        report_missing_packages=1
        prereq        
	envvars
        prefixPrereq        
	default_envs
        choices
        if [ -f LAST_OPTION ];then
            echo "-last option: " 
            cat LAST_OPTION
        fi
        echo "Enter Option: "
        read nanswer
    else #If parameter is passed, set nanswer and default instrumentor
        instrumentor
        report_missing_packages=0
        prereq
        nanswer=$1
    fi
    echo $nanswer > LAST_OPTION
    ./Build-RPM newrpmloc
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
#            ./Build-RPM newrpmloc
#            more ~/.rpmmacros
#            echo
#            echo "ready to continue..."
#        fi
#    fi
#    if [ "$nanswer" = 0a ]; then
#        envvars
#    fi

    if [ "$nanswer" = 1  -o "$nanswer" = 9 ] ; then

        echo "build_binutils=$build_binutils"
	if [ $build_binutils == 1 ] ; then

          echo
          echo "Build binutils? <y/n>"
          echo

          if [ $OPENSS_PREFIX ]; then
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=$OPENSS_PREFIX/$LIBDIR
            else
              export LD_LIBRARY_PATH=$OPENSS_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
            fi
          else
              if [ -z $LD_LIBRARY_PATH ]; then 
                export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR
              else
                export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR:$LD_LIBRARY_PATH
              fi
              export OPENSS_PREFIX=/opt/OSS
              # set OPENSS_PREFIX to prefix to facilitate RPM build
          fi

          if [ "$nanswer" = 9 -o $imode == 0 ]; then
              answer=Y
          else
              read answer
          fi
          if [ "$answer" = Y -o "$answer" = y ]; then
              ./Build-RPM binutils-$binutilsver
              export OPENSS_BINUTILS=$OPENSS_PREFIX
          fi
        fi

        
        if [ $build_oss_gui_only == 0 ] && [ $build_oss_runtime_only == 0 ] ; then

          echo
          echo "Checking to see if libelf is available..."
          echo; echo

          if [ -z $OPENSS_FORCE_LIBELF_BUILD ] ; then
             echo "set force_libelf_build=0......"
             force_libelf_build=0
          else
             echo "set force_libelf_build=1......"
             force_libelf_build=1
          fi
          if [ $force_libelf_build == 0 -a -f $OPENSS_LIBELF/$LIBDIR/libelf.so ] && [ -f $OPENSS_LIBELF/include/libelf.h -o \
               -f $OPENSS_LIBELF/include/libelf/libelf.h ]; then
              echo "libelf detected in $OPENSS_LIBELF/<lib>, will not be built..."
              echo
              install_libelf=0
          elif [ $force_libelf_build == 0 -a -f /usr/$LIBDIR/libelf.so ] && [ -f /usr/include/libelf.h -o \
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
                  install_libelf=1
                  ./Build-RPM libelf-$libelfver
                  if [ $OPENSS_PREFIX ]; then
                    export OPENSS_LIBELF=$OPENSS_PREFIX
                  else
                    export OPENSS_LIBELF=/opt/OSS
                  fi
              fi
          fi
        fi
    fi

    if [ "$nanswer" = 1a -o "$nanswer" = 9 ] ; then

        # IF COMING IN FROM A SEPERATE INNOCATION OF INSTALL.SH THEN DETECT LIBELF INSTALLATIONS
        echo "RPMS/$sys/libelf.OSS.*.rpm=RPMS/$sys/libelf.OSS.*.rpm"
        if [ -z $OPENSS_LIBELF ]; then
          if [ -f RPMS/$sys/libelf.OSS.*.rpm ]; then
            echo "libelf detected as built into RPMS/$sys/libelf.OSS.*.rpm will be installed into $OPENSS_PREFIX/<lib>"
            install_libelf=1
            echo
          fi
        else
          echo "OPENSS_LIBELF is set, use this for building other components"
        fi

        if [ "$install_libelf" = 1 ] && [ $build_oss_gui_only == 0 ] && [ $build_oss_runtime_only == 0 ] ; then
          echo "Install base Support libraries: libelf"
          echo "This is non-root cpio process."
          echo "Installing in /opt/OSS unless OPENSS_PREFIX set"
          echo
          if [ $OPENSS_PREFIX ]; then
              echo "Install Path:  : ", $OPENSS_PREFIX
          else
              echo "Install Path:  : /opt/OSS"
          fi
          cd RPMS/$sys
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
          if [ $OPENSS_PREFIX ]; then
              if [ -e $OPENSS_PREFIX ]; then
                  echo "OPENSS_PREFIX exists"
              else
                  mkdir -p $OPENSS_PREFIX
              fi
              cp -r `pwd`/$OPENSS_PREFIX/* $OPENSS_PREFIX
              #cp -r opt/OSS/* $OPENSS_PREFIX
          else
              cp -r opt/* /opt
          fi
          cd ../.. # Back out of RPMS
        fi

	if [ $build_binutils == 1 ] ; then
          cd RPMS/$sys
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
          if [ $OPENSS_PREFIX ]; then
              if [ -e $OPENSS_PREFIX ]; then
                  echo "OPENSS_PREFIX exists"
              else
                  mkdir -p $OPENSS_PREFIX
              fi
              cp -r `pwd`/$OPENSS_PREFIX/* $OPENSS_PREFIX
              echo "copying from `pwd`$OPENSS_PREFIX to $OPENSS_PREFIX"
              export OPENSS_BINUTILS=$OPENSS_PREFIX
          else
              cp -r opt/* /opt
              echo "copy to /opt"
              export OPENSS_BINUTILS=/opt
          fi
          cd ../.. # Back out of RPMS
        fi

    fi
    install_libdwarf=1
    if [ "$nanswer" = 2  -o "$nanswer" = 9 ] && \
	[ $build_oss_gui_only == 0 ] && [ $build_oss_runtime_only == 0 ] ; then

	if [ "$OPENSS_INSTRUMENTOR" == "mrnet" ] || \
	   [ "$OPENSS_INSTRUMENTOR" == "offline" ] || \
           [ "$OPENSS_INSTRUMENTOR" == "cbtf" ]; then
           # FORCE BECAUSE DYNINST NEEDS A VERY NEW DWARF
           echo "set force_dwarf_build=1......"
           force_dwarf_build=1
        elif [ -z $OPENSS_FORCE_LIBDWARF_BUILD ] ; then
           echo "set force_dwarf_build=0......"
           force_dwarf_build=0
        else
           echo "set force_dwarf_build=1......"
           force_dwarf_build=1
        fi

        # Build the latest version of libdwarf for dyninst-8 and symtabapi-8
        # Put all the instrumentors here but we can prune them out if necessary
       	if [ $OPENSS_INSTRUMENTOR == "mrnet" ]; then
           echo "Need the latest version of libdwarf for Dyninst.  Set force_dwarf_build=1......"
           force_dwarf_build=1
       	elif [ $OPENSS_INSTRUMENTOR == "cbtf" ]; then
           echo "Need the latest version of libdwarf for Dyninst.  Set force_dwarf_build=1......"
           force_dwarf_build=1
       	elif [ $OPENSS_INSTRUMENTOR == "offline" ]; then
           echo "Need the latest version of libdwarf for Dyninst.  Set force_dwarf_build=1......"
        fi
         
        # DETECT LIBDWARF INSTALLATIONS
        echo "OPENSS_LIBDWARF=$OPENSS_LIBDWARF"
        echo "OPENSS_LIBDWARF/LIBDIR=$OPENSS_LIBDWARF/$LIBDIR"
        if [ $force_dwarf_build == 0 -a -f $OPENSS_LIBDWARF/$LIBDIR/libdwarf.so -a -f $OPENSS_LIBDWARF/include/libdwarf.h ]; then
            echo "libdwarf detected in $OPENSS_LIBDWARF/<lib>, will not be built..."
            echo
            install_libdwarf=0
        elif [ $force_dwarf_build == 0 -a -f /usr/$LIBDIR/libdwarf.so ] && [ -f /usr/include/libdwarf.h -o /usr/include/libdwarf/libdwarf.h ] ; then
            echo "libdwarf detected in /usr/<lib>, will not be built..."
            echo
            install_libdwarf=0
            export OPENSS_LIBDWARF=/usr
        else
          echo
          echo "Build libdwarf? <y/n>"
          echo

          if [ $OPENSS_PREFIX ]; then
              if [ -z $LD_LIBRARY_PATH ]; then 
                export LD_LIBRARY_PATH=$OPENSS_PREFIX/$LIBDIR
              else
                export LD_LIBRARY_PATH=$OPENSS_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
              fi
          else
              if [ -z $LD_LIBRARY_PATH ]; then 
                export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR
              else
                export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR:$LD_LIBRARY_PATH
              fi
              export OPENSS_PREFIX=/opt/OSS
              # set OPENSS_PREFIX to prefix to facilitate RPM build
          fi

          if [ "$nanswer" = 9 -o $imode == 0 ]; then
              answer=Y
          else
              read answer
          fi
          if [ "$answer" = Y -o "$answer" = y ]; then
              ./Build-RPM libdwarf-$libdwarfver
              if [ $OPENSS_PREFIX ]; then
                export OPENSS_LIBDWARF=$OPENSS_PREFIX
              else
                export OPENSS_LIBDWARF=/opt/OSS
              fi
          fi
        fi
    fi
    if [ "$nanswer" = 2a -o "$nanswer" = 9 ] && \
	[ $build_oss_gui_only == 0 ] && [ $build_oss_runtime_only == 0 ] ; then

        # IF COMING IN FROM A SEPERATE INNOCATION OF INSTALL.SH THEN DETECT LIBELF INSTALLATIONS
        #echo "RPMS/$sys/libdwarf.OSS.*.rpm=RPMS/$sys/libdwarf.OSS.*.rpm"
        if [ -z $OPENSS_LIBDWARF ]; then
          if [ -f RPMS/$sys/libdwarf.OSS.*.rpm ]; then
            echo "libdwarf detected as built into RPMS/$sys/libdwarf.OSS.*.rpm will be installed into $OPENSS_PREFIX/<lib>"
            install_libdwarf=1
            echo
          fi
        else
          echo "OPENSS_LIBDWARF is set, use this for building other components"
        fi

        echo "Install base Support libraries: libdwarf"
        echo "This is non-root cpio process."
        echo "Installing in /opt/OSS unless OPENSS_PREFIX set"
        echo
        if [ $OPENSS_PREFIX ]; then
            echo "Install Path:  : ", $OPENSS_PREFIX
        else
            echo "Install Path:  : /opt/OSS"
        fi

        cd RPMS/$sys
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
        if [ $OPENSS_PREFIX ]; then
            if [ -e $OPENSS_PREFIX ]; then
                echo "OPENSS_PREFIX exists"
            else
                mkdir -p $OPENSS_PREFIX
            fi
# jeg changed 10/27/10
#            cp -r opt/OSS/* $OPENSS_PREFIX
#            echo "copy to OPENSS_PREFIX"
            cp -r `pwd`/$OPENSS_PREFIX/* $OPENSS_PREFIX
            echo "copying from `pwd`$OPENSS_PREFIX to $OPENSS_PREFIX"
        else
            cp -r opt/* /opt
            echo "copy to /opt"
        fi
        cd ../.. # Back out of RPMS
    fi
    install_libpapi=1
    if [ "$nanswer" = 3 -o "$nanswer" = 9 ]; then

        echo "Build base Support libraries: libunwind, papi, sqlite, monitor"
        echo "- will build RPMs - these can be used for installation as either"
        echo "RPMs or we can do a non-root install utilizing cpio"
        echo 

        if [ $OPENSS_PREFIX ]; then
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=$OPENSS_PREFIX/$LIBDIR
            else
              export LD_LIBRARY_PATH=$OPENSS_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
            fi
        else
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR
            else
              export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR:$LD_LIBRARY_PATH
            fi
            export OPENSS_PREFIX=/opt/OSS
            # set OPENSS_PREFIX to prefix to facilitate RPM build
        fi

        echo "Build libunwind? <y/n>"
        echo 
        if [ "$nanswer" = 9 -o $imode == 0 ]; then
            answer=Y
        else
            read answer
        fi
        if [ "$answer" = Y -o "$answer" = y ] && \
	    [ $build_oss_gui_only == 0 ] || [ $build_oss_runtime_only == 1 ] ; then
            ./Build-RPM libunwind-$libunwindver
        fi

        # DETECT PAPI INSTALLATIONS
        #echo "OPENSS_PAPI=$OPENSS_PAPI"
        #echo "OPENSS_PAPI/LIBDIR=$OPENSS_PAPI/$LIBDIR"
        if [ -z $OPENSS_FORCE_PAPI_BUILD ] ; then
           force_papi_build=0
        else
           force_papi_build=1
        fi
         
        # jeg 10/9/2012 - don't find libpapi in /usr instead always build our own version
        # unless the user asks for OPENSS_PAPI then use that
        if [ $force_papi_build == 0 -a -f $OPENSS_PAPI/$LIBDIR/libpapi.so -a -f $OPENSS_PAPI/include/papi.h ]; then
            echo "libpapi detected in $OPENSS_PAPI/<lib>, will not be built..."
            install_libpapi=0
            echo
        #elif [ $force_papi_build == 0 -a -f /usr/$LIBDIR/libpapi.so -a -f /usr/include/papi.h ]; then
        #    echo "libpapi detected in /usr/<lib>, will not be built..."
        #    install_libpapi=0
        #    export OPENSS_PAPI=/usr
        #    echo
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
               ./Build-RPM papi-$papiver
               if [ $OPENSS_PREFIX ]; then
                 export OPENSS_PAPI=$OPENSS_PREFIX
               else
                 export OPENSS_PAPI=/opt/OSS
               fi
               install_libpapi=1
           fi
        fi

        # DETECT SQLITE INSTALLATIONS
        echo "OPENSS_SQLITE=$OPENSS_SQLITE"
        echo "OPENSS_SQLITE/LIBDIR=$OPENSS_SQLITE/$LIBDIR"
        if [ -z $OPENSS_FORCE_SQLITE_BUILD ] ; then
           force_sqlite_build=0
        else
           force_sqlite_build=1
        fi
         
        if [ $force_sqlite_build == 0 -a -f $OPENSS_SQLITE/$LIBDIR/libsqlite3.so -a -f $OPENSS_SQLITE/include/sqlite3.h ]; then
            echo "libsqlite detected in $OPENSS_SQLITE/<lib>, will not be built..."
            install_libsqlite=0
            echo
        elif [ $force_sqlite_build == 0 -a -f /usr/$LIBDIR/libsqlite3.so -a -f /usr/include/sqlite3.h ]; then
            echo "libsqlite detected in /usr/<lib>, will not be built..."
            install_libsqlite=0
            export OPENSS_SQLITE=/usr
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
              ./Build-RPM sqlite-$sqlitever
               if [ $OPENSS_PREFIX ]; then
                 export OPENSS_SQLITE=$OPENSS_PREFIX
               else
                 export OPENSS_SQLITE=/opt/OSS
               fi
               install_libsqlite=1
          fi
        fi
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
            ./Build-RPM libmonitor-$monitorver
        fi
        echo
    fi
    if [ "$nanswer" = 3a  -o "$nanswer" = 9 ]; then

	if [ $build_oss_gui_only == 1 ] ; then
            echo "Install base Support libraries:  papi, sqlite."
	elif [ $build_oss_runtime_only == 1 ] ; then
            echo "Install base Support libraries: libunwind, papi, libmonitor, "
	else
            echo "Install base Support libraries: libunwind, papi, sqlite, "
            echo "libmonitor"
	fi
        echo "This is non-root cpio process."
        echo "Installing in /opt/OSS unless OPENSS_PREFIX set"
        echo
        if [ $OPENSS_PREFIX ]; then
            echo "Install Path:  : ", $OPENSS_PREFIX
        else
            echo "Install Path:  : /opt/OSS"
        fi

        # IF COMING IN FROM A SEPERATE INNOCATION OF INSTALL.SH THEN DETECT PAPI INSTALLATIONS
        #echo "RPMS/$sys/papi.OSS.*.rpm=RPMS/$sys/papi.OSS.*.rpm"
        if [ -z $OPENSS_PAPI ]; then
          if [ -f RPMS/$sys/papi.OSS.*.rpm ]; then
            echo "papi detected as built into RPMS/$sys/papi.OSS.*.rpm will be installed into $OPENSS_PREFIX/<lib>"
            install_libpapi=1
            echo
          fi
        else
          echo "OPENSS_PAPI is set, use this for building other components"
        fi

        # IF COMING IN FROM A SEPERATE INNOCATION OF INSTALL.SH THEN DETECT LIBELF INSTALLATIONS
        #echo "RPMS/$sys/sqlite.OSS.*.rpm=RPMS/$sys/sqlite.OSS.*.rpm"
        if [ -z $OPENSS_SQLITE ]; then
	  if [ -f RPMS/$sys/sqlite.OSS.*.rpm ]; then
            echo "sqlite detected as built into RPMS/$sys/sqlite.OSS.*.rpm will be installed into $OPENSS_PREFIX/<lib>"
            install_libsqlite=1
            echo
          fi
        else
          echo "OPENSS_SQLITE is set, use this for building other components"
        fi

        cd RPMS/$sys
        echo "starting RPM to cpio process..."
	if [ $build_oss_gui_only == 0 ] || [ $build_oss_runtime_only == 1 ] ; then
            rpm2cpio libunwind.OSS.*.rpm > libunwind.cpio
            rpm2cpio libmonitor.OSS.*.rpm > libmonitor.cpio
	fi

        if [ $install_libpapi == 1 ]; then
          rpm2cpio papi.OSS.*.rpm > papi.cpio
        fi

	if [ $build_oss_runtime_only == 0 -a "$install_libsqlite" = 1 ] ; then
            rpm2cpio sqlite.OSS.*.rpm > sqlite.cpio
	fi

        echo "cpio to local path install process"
        if [ $OPENSS_PREFIX ]; then
            rm -rf `pwd`/$OPENSS_PREFIX/*
        else
            rm -rf opt
        fi

	if [ $build_oss_gui_only == 0 ] || [ $build_oss_runtime_only == 1 ] ; then
            cpio -id < libunwind.cpio
            cpio -id < libmonitor.cpio
	fi

        if [ $install_libpapi == 1 ]; then
          cpio -id < papi.cpio
	fi

	if [ "$install_libsqlite" = 1 -a $build_oss_runtime_only == 0 ]; then
            cpio -id < sqlite.cpio
	fi

        echo "moving files to target path..."
        if [ $OPENSS_PREFIX ]; then
            if [ -e $OPENSS_PREFIX ]; then
                echo "OPENSS_PREFIX exists"
            else
                mkdir -p $OPENSS_PREFIX
            fi
            cp -r `pwd`/$OPENSS_PREFIX/* $OPENSS_PREFIX
        else
            cp -r opt/* /opt
        fi
        cd ../.. # Back out of RPMS
    fi

    if [ "$nanswer" = 4  -o "$nanswer" = 9 ]; then
       	if [ $OPENSS_INSTRUMENTOR == "offline" ]; then
	        echo "Build vampirtrace"
       	else
	        echo "Build vampirtrace and dyninst"
	fi
	echo "- steps 1,2 and 3 must be completed before this step."
        echo "  Libraries must be accessible"
        echo
#
        if [ $OPENSS_PREFIX ]; then
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=$OPENSS_PREFIX/$LIBDIR
            else
              export LD_LIBRARY_PATH=$OPENSS_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
            fi
            export OPENSS_DOC_DIR=$OPENSS_PREFIX/share/doc/packages/OpenSpeedShop
#        else
#            export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR
#            export OPENSS_PREFIX=/opt/OSS
#            export OPENSS_DOC_DIR=opt/OSS/share/doc/packages/OpenSpeedShop
             # set OPENSS_PREFIX to prefix to facilitate RPM build
        fi
        echo $OPENSS_PREFIX
        echo $LD_LIBRARY_PATH

	if [ "$OPENSS_INSTRUMENTOR" == "mrnet" ] || \
           [ "$OPENSS_INSTRUMENTOR" == "offline" ] || \
           [ "$OPENSS_INSTRUMENTOR" == "cbtf" ]; then
                echo "Build boost? <y/n>"
                echo
                if [ "$nanswer" = 9 -o $imode == 0 ]; then
                    answer=Y
                else
                    read answer
                fi
                if [ "$answer" = Y -o "$answer" = y ] ; then

                  echo "OPENSS_BOOST=$OPENSS_BOOST"
                  if test -f $OPENSS_BOOST/include/boost/regex.hpp -a  \
                          -f $OPENSS_BOOST/$ALTLIBDIR/libboost_serialization.so -o  \
                          -f $OPENSS_BOOST/$ALTLIBDIR/libboost_serialization-mt.so -o \
                          -f $OPENSS_BOOST/$LIBDIR/libboost_serialization.so -o  \
                          -f $OPENSS_BOOST/$LIBDIR/libboost_serialization-mt.so ; then
                    if [ -f $OPENSS_BOOST/include/boost/version.hpp ]; then
                       BOOSTVER=`grep "define BOOST_VERSION " $OPENSS_BOOST/include/boost/version.hpp`
                       echo "OPENSS_BOOST, BOOSTVER=$BOOSTVER"
                       POS1=`expr index "$BOOSTVER" "10"`
                       POS2=`expr $POS1 + 2`
                       VERS=`expr substr "$BOOSTVER" "$POS2" 2`
                       #echo "POS1=$POS1"
                       #echo "POS2=$POS2"
                       #echo "VERS=$VERS"
                       if test "$VERS" -gt 40; then
                         echo "BOOST FOUND VERS=$VERS, no need to build boost"
                         export KRELL_ROOT_BOOST=$OPENSS_BOOST
                       else
                          build_boost_routine
                       fi
                    else
                       build_boost_routine
                    fi
                  elif test -f /usr/include/boost/regex.hpp -a  \
                          -f /usr/$LIBDIR/libboost_serialization.so -o  \
                          -f /usr/$LIBDIR/libboost_serialization-mt.so ; then
                    if [ -f /usr/include/boost/version.hpp ]; then
                       BOOSTVER=`grep "define BOOST_VERSION " /usr/include/boost/version.hpp`
                       echo "/usr, BOOSTVER=$BOOSTVER"
                       POS1=`expr index "$BOOSTVER" "10"`
                       POS2=`expr $POS1 + 2`
                       VERS=`expr substr "$BOOSTVER" "$POS2" 2`
                       #echo "POS1=$POS1"
                       #echo "POS2=$POS2"
                       #echo "VERS=$VERS"
                       if test "$VERS" -gt 40; then
                         echo "BOOST FOUND VERS=$VERS, no need to build boost"
                       else
                          build_boost_routine
                       fi
                    else
                       build_boost_routine
                    fi
                  else
                    build_boost_routine
                  fi
                fi

	        if [ "$OPENSS_INSTRUMENTOR" == "cbtf" ]; then
                  echo "Build xerces? <y/n>"
                  echo
                  if [ "$nanswer" = 9 -o $imode == 0 ]; then
                      answer=Y
                  else
                      read answer
                  fi
                  if [ "$answer" = Y -o "$answer" = y ] ; then
                    build_xercesc
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
	    [ $build_oss_gui_only == 0 ] || [ $build_oss_runtime_only == 1 ] ; then
            if [ $OPENSS_MPI_OPENMPI ]; then
                export KRELL_ROOT_MPI_PATH=$OPENSS_MPI_OPENMPI
                export KRELL_ROOT_MPI_LIB_LINE="-lmpi"
            elif [  $OPENSS_MPI_MPICH ]; then
                export KRELL_ROOT_MPI_PATH=$OPENSS_MPI_MPICH
                export KRELL_ROOT_MPI_LIB_LINE="-lmpich"
            elif [  $OPENSS_MPI_MPICH2 ]; then
                export KRELL_ROOT_MPI_PATH=$OPENSS_MPI_MPICH2
                export KRELL_ROOT_MPI_LIB_LINE="-lmpich"
            elif [  $OPENSS_MPI_MVAPICH ]; then
                export KRELL_ROOT_MPI_PATH=$OPENSS_MPI_MVAPICH
                export KRELL_ROOT_MPI_LIB_LINE="-lmpich"
            elif [  $OPENSS_MPI_MVAPICH2 ]; then
                export KRELL_ROOT_MPI_PATH=$OPENSS_MPI_MVAPICH2
                export KRELL_ROOT_MPI_LIB_LINE="-lmpich"
            elif [  $OPENSS_MPI_MPT ]; then
                export KRELL_ROOT_MPI_PATH=$OPENSS_MPI_MPT
                export KRELL_ROOT_MPI_LIB_LINE="-lmpi"
            elif [  $OPENSS_MPI_LAM ]; then
                export KRELL_ROOT_MPI_PATH=$OPENSS_MPI_LAM
                export KRELL_ROOT_MPI_LIB_LINE="-lmpi"
            elif [  $OPENSS_MPI_LAMPI ]; then
                echo "LAMPI cannot be used for vampirtrace build"
            fi
            echo $KRELL_ROOT_MPI_PATH
            
            if [ $KRELL_ROOT_MPI_PATH ]; then
                ./Build-RPM vampirtrace-$vampirtracever
            else
                echo "vampirtrace cannot be built - "
                echo "must identify an MPI implementation"
            fi
        fi

       	if [ "$OPENSS_INSTRUMENTOR" = "offline" ]; then
        	echo "Building symtabapi? <y/n>"
	        echo
	        if [ "$nanswer" = 9 -o $imode == 0 ]; then
	            answer=Y
	        else
	            read answer
	        fi
	        if [ "$answer" = Y -o "$answer" = y ] && [ $build_symtabapi == 1 ] && \
	    	    [ $build_oss_gui_only == 0 ] || [ $build_oss_runtime_only == 1 ] ; then
                    savePLATFORM=$PLATFORM
                    unset PLATFORM
		    ./Build-RPM symtabapi-$symtabapiver
                    PLATFORM=$savePLATFORM
	        fi
	else
	        echo "Build dyninst? <y/n>"
	        echo
	        if [ "$nanswer" = 9 -o $imode == 0 ]; then
	            answer=Y
	        else
	            read answer
	        fi
	        if [ "$answer" = Y -o "$answer" = y ] && \
	    	    [ $build_oss_gui_only == 0 ] || [ $build_oss_runtime_only == 1 ] ; then
#               If there is an instrumentor specified and it is mrnet then use the latest
#               dyninst version, else use 5.1r.  By default if OPENSS_INSTRUMENTOR is not
#               set choose to build mrnet version also
#
                        savePLATFORM=$PLATFORM
                        unset PLATFORM
	                if [ $OPENSS_INSTRUMENTOR == "mrnet" ]; then
		            ./Build-RPM dyninst-$dyninstver
	                elif [ $OPENSS_INSTRUMENTOR == "cbtf" ]; then
		            ./Build-RPM dyninst-$dyninstver
	        	else 
		            ./Build-RPM dyninst-$dyninstver
	        	fi
                        PLATFORM=$savePLATFORM
	        fi
	fi
    fi
#
    if [ "$nanswer" = 4a  -o "$nanswer" = 9 ] && \
	    [ $build_oss_gui_only == 0 ] || [ $build_oss_runtime_only == 1 ] ; then
       	if [ $OPENSS_INSTRUMENTOR == "offline" ]; then
	        echo "Install vampirtrace"
	else
	        echo "Install vampirtrace and dyninst"
	fi
        echo "- steps 1 and 2 must be completed before this step."
        echo "  Libraries must be accessible"
        echo "This is non-root cpio process."
        echo "Installing in /opt/OSS unless OPENSS_PREFIX set"
        echo

        cd RPMS/$sys
        echo "starting RPM to cpio process..."
        if [ -f vampirtrace.OSS.*.rpm ]; then
            rpm2cpio vampirtrace.OSS.*.rpm > vampirtrace.cpio
        fi

       	if [ $OPENSS_INSTRUMENTOR == "offline" ]; then
		if [ $build_oss_runtime_only == 0 ]; then
	            rpm2cpio symtabapi.OSS.*.rpm > symtabapi.cpio
	            echo "cpio to local path install process"
	            rm -rf opt
		fi
       	elif [ $OPENSS_INSTRUMENTOR == "cbtf" ]; then
		if [ $build_oss_runtime_only == 0 ]; then
	            rpm2cpio dyninst.OSS.*.rpm > dyninst.cpio
	            echo "cpio to local path install process"
	            rm -rf opt
		fi
       	elif [ $OPENSS_INSTRUMENTOR == "mrnet" ]; then
		if [ $build_oss_runtime_only == 0 ]; then
	            rpm2cpio dyninst.OSS.*.rpm > dyninst.cpio
	            echo "cpio to local path install process"
	            rm -rf opt
		fi
	fi
#
        if [ -f vampirtrace.OSS.*.rpm ]; then
            cpio -id < vampirtrace.cpio
            echo "installing vampirtrace..."
            echo "moving files to target path: "
            if [ $OPENSS_PREFIX ]; then
              #cp -r opt/OSS/* $OPENSS_PREFIX
              cp -r `pwd`/$OPENSS_PREFIX/* $OPENSS_PREFIX
              echo "copying from opt/OSS/* to $OPENSS_PREFIX"
            else
              cp -r opt/* /opt
              echo "copying from opt/* to /opt/OSS"
            fi
        fi
       	if [ $OPENSS_INSTRUMENTOR == "offline" ]; then
		if [ $build_oss_runtime_only == 0 ] && [ $build_symtabapi == 1 ]; then
	            cpio -id < symtabapi.cpio
	            echo "installing symtabapi..."
	  	fi
       	elif [ $OPENSS_INSTRUMENTOR == "cbtf" ]; then
		if [ $build_oss_runtime_only == 0 ]; then
	            cpio -id < dyninst.cpio
	            echo "installing dyninst..."
		fi
       	elif [ $OPENSS_INSTRUMENTOR == "mrnet" ]; then
		if [ $build_oss_runtime_only == 0 ]; then
	            cpio -id < dyninst.cpio
	            echo "installing dyninst..."
		fi
	fi
        echo "moving files to target path: "
        if [ $OPENSS_PREFIX ]; then
            if [ -e $OPENSS_PREFIX ]; then
                echo "OPENSS_PREFIX exists"
            else
                mkdir -p $OPENSS_PREFIX
            fi
       	    if [ $OPENSS_INSTRUMENTOR == "offline" ]; then
              if [ $build_oss_runtime_only == 0 ] && [ $build_symtabapi == 1 ]; then
                  echo "symtabapivers = $symtabapiver"
                  cp -r `pwd`/$OPENSS_PREFIX/* $OPENSS_PREFIX
                  echo "copying from `pwd`$OPENSS_PREFIX to $OPENSS_PREFIX"
              fi
       	    elif [ $OPENSS_INSTRUMENTOR == "cbtf" ]; then
              echo "dyninstvers = $dyninstver"
              cp -r `pwd`/$OPENSS_PREFIX/* $OPENSS_PREFIX
              echo "copying from `pwd`$OPENSS_PREFIX to $OPENSS_PREFIX"
       	    elif [ $OPENSS_INSTRUMENTOR == "mrnet" ]; then
              echo "dyninstvers = $dyninstver"
              cp -r `pwd`/$OPENSS_PREFIX/* $OPENSS_PREFIX
              echo "copying from `pwd`$OPENSS_PREFIX to $OPENSS_PREFIX"
            fi
        else
            cp -r opt/* /opt
            echo "copying from opt/* to /opt/OSS"
        fi
        cd ../.. # Back out of RPMS

    fi
    if [ "$nanswer" = 5  -o "$nanswer" = 9 ] && \
	[ $build_oss_gui_only == 0 ] && [ $build_oss_runtime_only == 0 ]; then 
	if [ $OPENSS_INSTRUMENTOR == "mrnet" ] || [ $OPENSS_INSTRUMENTOR == "cbtf" ]; then
		echo "Build mrnet"
       	elif [ $OPENSS_INSTRUMENTOR == "offline" ]; then
		echo "No need to build mrnet"
        else
		echo "Build mrnet"
	        echo "- steps 1,2,3 and 4 must be completed before this step."
	        echo "  Libraries must be accessible"
        fi
        echo
        if [ $OPENSS_PREFIX ]; then
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=$OPENSS_PREFIX/$LIBDIR
            else
              export LD_LIBRARY_PATH=$OPENSS_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
            fi
        else
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR
            else
              export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR:$LD_LIBRARY_PATH
            fi
            export OPENSS_PREFIX=/opt/OSS
            # set OPENSS_PREFIX to prefix to facilitate RPM build
        fi

#       If there is an instrumentor specified and it is mrnet then use the latest
#       dyninst version. 
	if [ $OPENSS_INSTRUMENTOR == "mrnet" ] || [ $OPENSS_INSTRUMENTOR == "cbtf" ]; then
        	echo "Build mrnet? <y/n>"
        	echo
        	if [ "$nanswer" = 9 -o $imode == 0 ]; then
            		answer=Y
        	else
            		read answer
        	fi
        	if [ "$answer" = Y -o "$answer" = y ]; then
            		./Build-RPM mrnet-$mrnetver
        	fi
	elif [ $OPENSS_INSTRUMENTOR == "offline" ]; then
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
            		./Build-RPM mrnet-$mrnetver
        	fi
       	fi
    fi
    if [ "$nanswer" = 5a  -o "$nanswer" = 9 ] && \
	[ $build_oss_gui_only == 0 ] && [ $build_oss_runtime_only == 0 ]; then
	if [ $OPENSS_INSTRUMENTOR == "mrnet" ] || [ $OPENSS_INSTRUMENTOR == "cbtf" ]; then
        	echo "Install mrnet"
	elif [ $OPENSS_INSTRUMENTOR == "offline" ]; then
        	echo
        else
        	echo "Install mrnet"
        fi
        echo "- steps 1,2,3 and 4 must be completed before this step."
        echo "Libraries must be accessible"
        echo "This is non-root cpio process."
        echo "Installing in /opt/OSS unless OPENSS_PREFIX set"
        echo
        cd RPMS/$sys
        echo "starting RPM to cpio process..."
	if [ $OPENSS_INSTRUMENTOR == "mrnet" ] || [ $OPENSS_INSTRUMENTOR == "cbtf" ]; then
        	if [ -f mrnet.OSS.*.rpm ]; then
            		rpm2cpio mrnet.OSS.*.rpm > mrnet.cpio
        	fi
	elif [ $OPENSS_INSTRUMENTOR == "offline" ]; then
        	echo
	else
        	if [ -f mrnet.OSS.*.rpm ]; then
            		rpm2cpio mrnet.OSS.*.rpm > mrnet.cpio
        	fi
	fi
        echo "starting cpio to local path install process..."
        rm -rf opt
	if [ $OPENSS_INSTRUMENTOR == "mrnet" ] || [ $OPENSS_INSTRUMENTOR == "cbtf" ]; then
        	if [ -f mrnet.OSS.*.rpm ]; then
            		cpio -id < mrnet.cpio
            	echo "installing mrnet..."
       		fi
	elif [ $OPENSS_INSTRUMENTOR == "offline" ]; then
        	echo
	else
        	if [ -f mrnet.OSS.*.rpm ]; then
            		cpio -id < mrnet.cpio
            	echo "installing mrnet..."
       		fi
	fi
        echo "moving files to target path: "
        if [ $OPENSS_PREFIX ]; then
            cp -r `pwd`/$OPENSS_PREFIX/* $OPENSS_PREFIX
            echo "copying from `pwd`$OPENSS_PREFIX to $OPENSS_PREFIX"
            #cp -r opt/OSS/* $OPENSS_PREFIX
            #echo $OPENSS_PREFIX
        else
            cp -r opt/* /opt
            echo "/opt/OSS"
        fi
        cd ../.. # Back out of RPMS
    fi
    if [ "$OPENSS_INSTRUMENTOR" != "cbtf" ]; then
      if [ "$nanswer" = 6  -o "$nanswer" = 9 ] && [ $build_oss_runtime_only == 0 ]; then 

        if [ -z $OPENSS_FORCE_QT_BUILD ] ; then
           force_qt_build=0
        else
           force_qt_build=1
           echo "OPENSS_FORCE_QT_BUILD is set, Qt will be built..."
        fi

        if [ $force_qt_build == 0 -a -f $OPENSS_QT3/lib/libqui.so.1.0 -a \
              -f $OPENSS_QT3/bin/qmake -a -f $OPENSS_QT3/include/qt.h ] ; then
               echo "Qt version 3 detected in $OPENSS_QT3, Qt will not be built..."
               install_qt=0
        elif [ $force_qt_build == 0 -a -f /usr/$LIBDIR/qt-3.3/lib/libqui.so.1.0 -a \
              -f /usr/$LIBDIR/qt-3.3/bin/qmake -a -f /usr/$LIBDIR/qt-3.3/include/qt.h ] ; then
               echo "Qt version 3 detected in /usr/$LIBDIR/qt-3.3, Qt will not be built..."
               install_qt=0
        elif [ $force_qt_build == 0 -a -f /usr/$LIBDIR/qt3/bin/qmake -a  \
               -f /usr/$LIBDIR/qt3/lib/libqui.so.1.0 -a  \
               -f /usr/$LIBDIR/qt3/include/qt.h ] ; then
               echo "Qt version 3 detected in /usr/$LIBDIR/qt3, Qt will not be built..."
               install_qt=0

        elif [ $force_qt_build == 0 -a -f /usr/bin/qmake -a  \
               -f /usr/$LIBDIR/libqui.so.1.0 -a  \
               -f /usr/include/qt3/qassistantclient.h -a  \
               -f /usr/include/qt3/qt.h ] ; then
               echo "Qt version 3 detected in /usr/include/qt3 and /usr/$LIBDIR, Qt will not be built..."
               install_qt=0

        else
            echo "Build Qt version 3"
            echo
            if [ $OPENSS_PREFIX ]; then
                if [ -z $LD_LIBRARY_PATH ]; then 
                  export LD_LIBRARY_PATH=$OPENSS_PREFIX/$LIBDIR
                else
                  export LD_LIBRARY_PATH=$OPENSS_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
                fi
            else
                if [ -z $LD_LIBRARY_PATH ]; then 
                  export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR
                else
                  export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR:$LD_LIBRARY_PATH
                fi
                export OPENSS_PREFIX=/opt/OSS
                # set OPENSS_PREFIX to prefix to facilitate RPM build
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
                install_qt=1
                ./Build-RPM qt-x11-free-$qtver
            fi
            echo
        fi
    fi

    install_qt3=0
    if [ "$nanswer" = 6a -o "$nanswer" = 9  -a "$install_qt" = 1 ] && \
	[ $build_oss_runtime_only == 0 ]; then

        # IF COMING IN FROM A SEPERATE INNOCATION OF INSTALL.SH THEN DETECT LIBELF INSTALLATIONS
        # echo "RPMS/$sys/sqlite.OSS.*.rpm=RPMS/$sys/sqlite.OSS.*.rpm"
        if [ -f RPMS/$sys/qt-x11-free.OSS.*.rpm ]; then
          echo "qt3 detected as built into RPMS/$sys/qt-x11-free.OSS.*.rpm will be installed into $OPENSS_PREFIX/<lib>"
          install_qt3=1
          echo
        fi

        if [ $install_qt3 == 1 ]; then
          echo "Install Qt"
          echo "This is non-root cpio process."
          echo "Installing in /opt/OSS unless OPENSS_PREFIX set"
          echo
          cd RPMS/$sys
          echo "starting RPM to cpio process..."
          rpm2cpio qt-x11-free.OSS.*.rpm > qt.cpio
          echo "starting cpio to local path install process..."
          rm -rf opt
          cpio -id < qt.cpio
          echo "installing Qt..."
          echo "moving files to target path: "
          if [ $OPENSS_PREFIX ]; then
              #cp -r $OPENSS_PREFIX/qt3 $OPENSS_PREFIX/.
              cp -r `pwd`/$OPENSS_PREFIX $OPENSS_PREFIX/qt3
              echo "QTDIR=" $OPENSS_PREFIX/qt3
              export QTDIR=$OPENSS_PREFIX/qt3
          elif [ $KRELL_ROOT_PREFIX ]; then
              #cp -r $KRELL_ROOT_PREFIX/qt3 $KRELL_ROOT_PREFIX/.
              cp -r `pwd`/$KRELL_ROOT_PREFIX $KRELL_ROOT_PREFIX/qt3
              echo "QTDIR=" $KRELL_ROOT_PREFIX/qt3
              export QTDIR=$KRELL_ROOT_PREFIX/qt3
          else
              cp -r opt/OSS/qt3 /opt/OSS/.
              echo "QTDIR= /opt/OSS/qt3"
              export QTDIR=/opt/OSS/qt3
          fi
          # Back out of RPMS
          cd ../..
        fi
      fi
    fi

    if [ "$OPENSS_INSTRUMENTOR" != "cbtf" ]; then
      if  [ "$nanswer" == 7 -o "$nanswer" == 9 ] && [ $build_oss == 1 ] ; then
        echo "Build Open|SpeedShop"
        echo "- steps 1, 2/2a, 3/3a, 4/4a and 5/5a must be completed before"
        echo "this step. Libraries must be accessible"
        echo "Set QTDIR to location of Qt."
        echo "Current default is /usr/$LIBDIR/qt-3-3"
        echo
        if [ $OPENSS_ROOT_PREFIX ]; then
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=$OPENSS_ROOT_PREFIX/$LIBDIR
            else
              export LD_LIBRARY_PATH=$OPENSS_ROOT_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
            fi
        elif [ $OPENSS_PREFIX ]; then
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=$OPENSS_PREFIX/$LIBDIR
            else
              export LD_LIBRARY_PATH=$OPENSS_PREFIX/$LIBDIR:$LD_LIBRARY_PATH
            fi
        else
            if [ -z $LD_LIBRARY_PATH ]; then 
              export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR
            else
              export LD_LIBRARY_PATH=/opt/OSS/$LIBDIR:$LD_LIBRARY_PATH
            fi
            export OPENSS_PREFIX=/opt/OSS
            # set OPENSS_PREFIX to prefix to facilitate RPM build
        fi

	# if OPENSS_LIBDWARF is set then export the library path for the build/configure to use
        if [ $OPENSS_LIBDWARF ]; then
	     echo "Using OPENSS_LIBDWARF=$OPENSS_LIBDWARF"
             export LD_LIBRARY_PATH=$OPENSS_LIBDWARF/$LIBDIR:$LD_LIBRARY_PATH
             export LD_LIBRARY_PATH=$OPENSS_LIBDWARF/$ALTLIBDIR:$LD_LIBRARY_PATH
        fi

	# if OPENSS_QT3 is set then export the library path for the build/configure to use
        if [ $OPENSS_QT3 ]; then
	     echo "Using OPENSS_QT3=$OPENSS_QT3"
             export LD_LIBRARY_PATH=$OPENSS_QT3/$LIBDIR:$LD_LIBRARY_PATH
             export LD_LIBRARY_PATH=$OPENSS_QT3/$ALTLIBDIR:$LD_LIBRARY_PATH
        fi

	# if OPENSS_PAPI is set then export the library path for the build/configure to use
        if [ $OPENSS_PAPI ]; then
	     echo "Using OPENSS_PAPI=$OPENSS_PAPI"
             export LD_LIBRARY_PATH=$OPENSS_PAPI/$LIBDIR:$LD_LIBRARY_PATH
             export LD_LIBRARY_PATH=$OPENSS_PAPI/$ALTLIBDIR:$LD_LIBRARY_PATH
        fi
	# if OPENSS_SQLITE is set then export the library path for the build/configure to use
        if [ $OPENSS_SQLITE ]; then
	     echo "Using OPENSS_SQLITE=$OPENSS_SQLITE"
             export LD_LIBRARY_PATH=$OPENSS_SQLITE/$LIBDIR:$LD_LIBRARY_PATH
             export LD_LIBRARY_PATH=$OPENSS_SQLITE/$ALTLIBDIR:$LD_LIBRARY_PATH
        fi
	# if OPENSS_PYTHON is set then export the library path for the build/configure to use
        if [ $OPENSS_PYTHON ]; then
	     echo "Using OPENSS_PYTHON=$OPENSS_PYTHON"
             export LD_LIBRARY_PATH=$OPENSS_PYTHON/$LIBDIR:$LD_LIBRARY_PATH
             export LD_LIBRARY_PATH=$OPENSS_PYTHON/$ALTLIBDIR:$LD_LIBRARY_PATH
        fi
	# if OPENSS_LIBXML2 is set then export the library path for the build/configure to use
        if [ $OPENSS_LIBXML2 ]; then
	     echo "Using OPENSS_LIBXML2=$OPENSS_LIBXML2"
             export LD_LIBRARY_PATH=$OPENSS_LIBXML2/$LIBDIR:$LD_LIBRARY_PATH
             export LD_LIBRARY_PATH=$OPENSS_LIBXML2/$ALTLIBDIR:$LD_LIBRARY_PATH
        fi
	# if OPENSS_BINUTILS is set then export the library path for the build/configure to use
        if [ $OPENSS_ROOT_PREFIX ] ; then
           if [ $build_binutils == 1 ] ; then
            export OPENSS_BINUTILS=$OPENSS_ROOT_PREFIX
           else
            export OPENSS_BINUTILS=/usr
           fi
        elif [ $OPENSS_PREFIX ] ; then
           if [ $build_binutils == 1 ] ; then
            export OPENSS_BINUTILS=$OPENSS_PREFIX
           else
            export OPENSS_BINUTILS=/usr
           fi
        else
           if [ $build_binutils == 1 ] ; then
            export OPENSS_BINUTILS=/opt/OSS
           else
            export OPENSS_BINUTILS=/usr
           fi
        fi
        if [ $OPENSS_BINUTILS ]; then
             export LD_LIBRARY_PATH=$OPENSS_BINUTILS/$LIBDIR:$LD_LIBRARY_PATH
             export LD_LIBRARY_PATH=$OPENSS_BINUTILS/$ALTLIBDIR:$LD_LIBRARY_PATH
        fi

        echo ""
	export OPENSS_DYNINST_VERS=$dyninstver
	export KRELL_ROOT_DYNINST_VERS=$dyninstver
        echo ""

        echo ""
	export OPENSS_MRNET_VERS=$mrnetver
	export KRELL_ROOT_MRNET_VERS=$mrnetver
        echo ""
	echo "Using OPENSS_MRNET_VERS=$OPENSS_MRNET_VERS"
	echo "Using OPENSS_DYNINST_VERS=$OPENSS_DYNINST_VERS"
        echo ""

        echo ""
	export OPENSS_SYMTABAPI_VERS=$symtabapiver
	export KRELL_ROOT_SYMTABAPI_VERS=$symtabapiver
        echo ""
	echo "Using OPENSS_SYMTABAPI_VERS=$OPENSS_SYMTABAPI_VERS"
	echo "Using OPENSS_DYNINST_VERS=$OPENSS_DYNINST_VERS"
        echo ""

        if [ $OPENSS_RESOLVE_SYMBOLS ]; then
            export KRELL_ROOT_RESOLVE_SYMBOLS=$OPENSS_RESOLVE_SYMBOLS
	    echo "Using KRELL_ROOT_RESOLVE_SYMBOLS=$OPENSS_RESOLVE_SYMBOLS"
        fi

        if [ $OPENSS_LIBUNWIND ]; then
            export KRELL_ROOT_LIBUNWIND=$OPENSS_LIBUNWIND
	    echo "Using KRELL_ROOT_LIBUNWIND=$OPENSS_LIBUNWIND"
        fi

        if [ $OPENSS_LIBELF ]; then
            export KRELL_ROOT_LIBELF=$OPENSS_LIBELF
	    echo "Using KRELL_ROOT_LIBELF=$OPENSS_LIBELF"
        fi

        if [ $OPENSS_TLS_TYPE ]; then
            export KRELL_ROOT_TLS_TYPE=$OPENSS_TLS_TYPE
	    echo "Using KRELL_ROOT_TLS_TYPE=$OPENSS_TLS_TYPE"
        fi

        if [ $OPENSS_OTF ]; then
            export KRELL_ROOT_OTF=$OPENSS_OTF
	    echo "Using KRELL_ROOT_OTF=$OPENSS_OTF"
        fi

        if [ $OPENSS_VT ]; then
            export KRELL_ROOT_VT=$OPENSS_VT
	    echo "Using KRELL_ROOT_VT=$OPENSS_VT"
        fi

        if [ $OPENSS_LIBMONITOR ]; then
            export KRELL_ROOT_LIBMONITOR=$OPENSS_LIBMONITOR
	    echo "Using KRELL_ROOT_LIBMONITOR=$OPENSS_LIBMONITOR"
        fi

        if [ $OPENSS_LIBDWARF ]; then
            export KRELL_ROOT_LIBDWARF=$OPENSS_LIBDWARF
	    echo "Using KRELL_ROOT_LIBDWARF=$OPENSS_LIBDWARF"
        fi

        if [ $OPENSS_DYNINST ]; then
            export KRELL_ROOT_DYNINST=$OPENSS_DYNINST
	    echo "Using KRELL_ROOT_DYNINST=$OPENSS_DYNINST"
        fi

        if [ $OPENSS_SYMTABAPI ]; then
            export KRELL_ROOT_SYMTABAPI=$OPENSS_SYMTABAPI
	    echo "Using KRELL_ROOT_SYMTABAPI=$OPENSS_SYMTABAPI"
        fi

        if [ $OPENSS_BINUTILS ]; then
            export KRELL_ROOT_BINUTILS=$OPENSS_BINUTILS
	    echo "Using KRELL_ROOT_BINUTILS=$OPENSS_BINUTILS"
        fi

        if [ $OPENSS_SQLITE ]; then
            export KRELL_ROOT_SQLITE=$OPENSS_SQLITE
	    echo "Using KRELL_ROOT_SQLITE=$OPENSS_SQLITE"
        fi

        if [ $OPENSS_PAPI ]; then
            export KRELL_ROOT_PAPI=$OPENSS_PAPI
	    echo "Using KRELL_ROOT_PAPI=$OPENSS_PAPI"
        fi

        if [ $OPENSS_PYTHON ]; then
            export KRELL_ROOT_PYTHON=$OPENSS_PYTHON
	    echo "Using KRELL_ROOT_PYTHON=$OPENSS_PYTHON"
        fi

        if [ $OPENSS_MPI_OPENMPI ]; then
            export KRELL_ROOT_MPI_OPENMPI=$OPENSS_MPI_OPENMPI
	    echo "Using KRELL_ROOT_MPI_OPENMPI=$OPENSS_MPI_OPENMPI"
        fi
        if [  $OPENSS_MPI_MPICH ]; then
            export KRELL_ROOT_MPI_MPICH=$OPENSS_MPI_MPICH
	    echo "Using KRELL_ROOT_MPI_MPICH=$OPENSS_MPI_MPICH"
        fi

        if [ $OPENSS_MPI_MPICH_DRIVER ]; then
            export KRELL_ROOT_MPI_MPICH_DRIVER=$OPENSS_MPI_MPICH_DRIVER
	    echo "Using KRELL_ROOT_MPI_MPICH_DRIVER=$OPENSS_MPI_MPICH_DRIVER"
        fi

        if [  $OPENSS_MPI_MPICH2 ]; then
            export KRELL_ROOT_MPI_MPICH2=$OPENSS_MPI_MPICH2
	    echo "Using KRELL_ROOT_MPI_MPICH2=$OPENSS_MPI_MPICH2"
        fi

        if [ $OPENSS_MPI_MPICH2_DRIVER ]; then
            export KRELL_ROOT_MPI_MPICH2_DRIVER=$OPENSS_MPI_MPICH2_DRIVER
	    echo "Using KRELL_ROOT_MPI_MPICH2_DRIVER=$OPENSS_MPI_MPICH2_DRIVER"
        fi

        if [  $OPENSS_MPI_MVAPICH ]; then
            export KRELL_ROOT_MPI_MVAPICH=$OPENSS_MPI_MVAPICH
	    echo "Using KRELL_ROOT_MPI_MVAPICH=$OPENSS_MPI_MVAPICH"
        fi
        if [  $OPENSS_MPI_MVAPICH2 ]; then
            export KRELL_ROOT_MPI_MVAPICH2=$OPENSS_MPI_MVAPICH2
	    echo "Using KRELL_ROOT_MPI_MVAPICH2=$OPENSS_MPI_MVAPICH2"
        fi
        if [  $OPENSS_MPI_MPT ]; then
            export KRELL_ROOT_MPI_MPT=$OPENSS_MPI_MPT
	    echo "Using KRELL_ROOT_MPI_MPT=$OPENSS_MPI_MPT"
        fi
        if [  $OPENSS_MPI_LAM ]; then
            export KRELL_ROOT_MPI_LAM=$OPENSS_MPI_LAM
	    echo "Using KRELL_ROOT_MPI_LAM=$OPENSS_MPI_LAM"
        fi
        if [  $OPENSS_MPI_LAMPI ]; then
            export KRELL_ROOT_MPI_LAMPI=$OPENSS_MPI_LAMPI
	    echo "Using KRELL_ROOT_MPI_LAMPI=$OPENSS_MPI_LAMPI"
        fi
        if [  $OPENSS_BOOST ]; then
            export KRELL_ROOT_BOOST=$OPENSS_BOOST
	    echo "Using KRELL_ROOT_BOOST=$OPENSS_BOOST"
        fi


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
            ./Build-RPM openspeedshop-$openspeedshopver
        fi
      fi
    fi

    if [ "$OPENSS_INSTRUMENTOR" != "cbtf" ]; then
      if [ "$nanswer" == 7a  -o "$nanswer" == 9 ] && [ $build_oss == 1 ]; then
        echo "Install Open|SpeedShop"
        echo " - steps 1,  2, 3/3a, 4/4a, 5/5a and 7 must be completed before this"
        echo "step. Libraries must be accessible"
        echo "This is non-root cpio process."
        echo "Installing in /opt/OSS unless OPENSS_PREFIX set"
        echo
        cd RPMS/$sys
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
        cd ../..
      fi
    fi
#    if [ "$nanswer" = 8a  -o "$nanswer" = 9 ]; then
#        getstarted
#	if [ $OPENSS_INSTRUMENTOR -a $OPENSS_INSTRUMENTOR == "mrnet" ]; then
#        	echo
#        	echo "We are checking for a site.py file in your OPENSS_PREFIX"
#	        echo "install directory..."
#        	echo
#        	echo "This is necessary for creating a topology file to run the dynamic"
#        	echo "version of Open|SpeedShop using MRNet."
#        	echo
#        	if [ -f $OPENSS_PREFIX/$LIBDIR/openspeedshop/site.py ]; then
#            		echo "We found a site.py file in your OPENSS_PREFIX install directory."
#            		echo "We will not attempt to install another."
#                	answer=n
#        	else
#            		echo "We did not find a site.py file in your OPENSS_PREFIX install directory."
#            		echo
#            		echo "Install base site.py file for you? <y/n>"
#            		echo
#            		if [ "$nanswer" = 9 ]; then
#                		answer=Y
#            		else
#                		read answer
#            	        fi
#            	fi
#            	if [ "$answer" = Y -o "$answer" = y ]; then
#               	 	# copy site.py for the user
#                	cp startup_files/mrnet-site.py.base \
#                	$OPENSS_PREFIX/$LIBDIR/openspeedshop/site.py
#                	if [ -f $OPENSS_PREFIX/$LIBDIR/openspeedshop/site.py ]; then
#                   		echo "A site.py file has been successfully installed in"
#                    		echo "your OPENSS_PREFIX install directory."
#                    		echo "Remember if you are running on a cluster with a"
#                    		echo "batch scheduler, some modification to the"
#                    		echo "site.py file may be necessary.  The base file copied"
#                    		echo "for your batch scheduler related example code in it."
#                	else
#                    		echo "There were problems installing the site.py file into"
#                    		echo "your OPENSS_PREFIX install directory."
#                    		echo "Please check permissions and the OPENSS_PREFIX for"
#                   		echo "possible reasons for the failure."
#                    		echo "Then please try again."
#                	fi
#                fi
#        	echo
#        	echo
#	elif [ $OPENSS_INSTRUMENTOR -a $OPENSS_INSTRUMENTOR == "dpcl" ]; then
#        	echo
#        	echo "We are checking for a site.py file in your OPENSS_PREFIX"
#	        echo "install directory..."
#        	echo
#        	if [ -f $OPENSS_PREFIX/$LIBDIR/openspeedshop/site.py ]; then
#            		echo "We found a site.py file in your OPENSS_PREFIX install directory."
#            		echo "We will not attempt to install another."
#                	answer=n
#        	else
#            		echo "We did not find a site.py file in your OPENSS_PREFIX install directory."
#            		echo
#            		echo "Install base site.py file for you? <y/n>"
#            		echo
#            		if [ "$nanswer" = 9 ]; then
#                		answer=Y
#            		else
#                		read answer
#                        fi 
#            	fi
#            	if [ "$answer" = Y -o "$answer" = y ]; then
#               	 	# copy site.py for the user
#                	cp startup_files/site.py.base \
#                	$OPENSS_PREFIX/$LIBDIR/openspeedshop/site.py
#                	if [ -f $OPENSS_PREFIX/$LIBDIR/openspeedshop/site.py ]; then
#                   		echo "A site.py file has been successfully installed in"
#                    		echo "your OPENSS_PREFIX install directory."
#                    		echo "Remember if you are running on a cluster with a"
#                    		echo "batch scheduler, some modification to the"
#                    		echo "site.py file may be necessary.  The base file copied"
#                    		echo "for your batch scheduler related example code in it."
#                	else
#                    		echo "There were problems installing the site.py file into"
#                    		echo "your OPENSS_PREFIX install directory."
#                    		echo "Please check permissions and the OPENSS_PREFIX for"
#                   		echo "possible reasons for the failure."
#                    		echo "Then please try again."
#                	fi
#                fi
#	else
#        	echo
#        	echo "We are checking for a site.py file in your OPENSS_PREFIX install directory..."
#	        echo "If there is one we will move it to site.py.bak.  site.py is not needed by the"
#		echo "offline instrumentor and if one exists in the install directory, it may be an "
#		echo "old version from a previous build. This could cause problems when building openss"
#		echo "for offline instrumentation only, the components that the site.py file will try to"
#		echo "launch are not built for OPENSS_INSTRUMENTOR=offline."
#        	echo
#               	if [ -f $OPENSS_PREFIX/$LIBDIR/openspeedshop/site.py ]; then
#               		if [ -f $OPENSS_PREFIX/$LIBDIR/openspeedshop/site.py.bak ]; then
#				mv $OPENSS_PREFIX/$LIBDIR/openspeedshop/site.py $OPENSS_PREFIX/$LIBDIR/openspeedshop/site.py.bak2
#		        	echo "A site.py was found and moved to $OPENSS_PREFIX/$LIBDIR/openspeedshop/site.py.bak2."
#		        	echo "A site.py.bak was found so site.py was saved to: "
#				echo "$OPENSS_PREFIX/$LIBDIR/openspeedshop/site.py.bak2, instead of site.py.bak."
#			else
#				mv $OPENSS_PREFIX/$LIBDIR/openspeedshop/site.py $OPENSS_PREFIX/$LIBDIR/openspeedshop/site.py.bak
#		        	echo "A site.py was found and moved to $OPENSS_PREFIX/$LIBDIR/openspeedshop/site.py.bak."
#			fi
#		else
#	        	echo "No site.py was found, so no move to site.py.bak was required. This is the normal desired outcome."
#		fi
#        	echo
#        fi
#    fi
    if [ "$nanswer" = 8 ]; then
        if [ $OPENSS_PREFIX ]; then
            echo "Install path=$OPENSS_PREFIX"
        else
            echo "Install path=/opt/OSS"
            export OPENSS_PREFIX=/opt/OSS
        # set OPENSS_PREFIX to prefix to facilitate RPM build
        fi

        echo 
        echo "Installed components status:"
        echo 
        if [ -f /usr/$LIBDIR/libelf.so ] && [ -f /usr/include/libelf.h -o /usr/include/libelf/libelf.h ]; then 
            echo - libelf- `ls -l --time-style=full-iso /usr/$LIBDIR/libelf.so\
            | awk '{printf "%s", $6}'`" system lib in /usr"
        else
            echo - libelf- `ls -l --time-style=full-iso \
            $OPENSS_PREFIX/$LIBDIR/libelf.so  | awk '{printf "%s", $6}'`
        fi
        if [ -f $OPENSS_PREFIX/$LIBDIR/libdwarf.so ]; then
            echo - libdwarf- `ls -l --time-style=full-iso \
            $OPENSS_PREFIX/$LIBDIR/libdwarf.so  | awk '{printf "%s", $6}'`
        else
            if [ -f /usr/$LIBDIR/libdwarf.so ] && [ -f /usr/include/libdwarf.h -o -f /usr/include/libdwarf/libdwarf.h ]; then
               echo - libdwarf- `ls -l --time-style=full-iso /usr/$LIBDIR/libdwarf.so\
               | awk '{printf "%s", $6}'`" system lib in /usr"
            else
               echo - libdwarf- not installed
            fi
        fi
        if [ -f $OPENSS_PREFIX/$LIBDIR/libunwind.so ]; then
            echo - libunwind- `ls -l --time-style=full-iso \
            $OPENSS_PREFIX/$LIBDIR/libunwind.so  | awk '{printf "%s", $6}'`
        else
            echo - libunwind- not installed
        fi

        # jeg 10/9/2012 - don't find libpapi in /usr instead always build our own version
        # unless the user asks for OPENSS_PAPI then use that
        if [ -f $OPENSS_PREFIX/$LIBDIR/libpapi.so ]; then
            echo - papi- `ls -l --time-style=full-iso \
            $OPENSS_PREFIX/$LIBDIR/libpapi.so  | awk '{printf "%s", $6}'`
        #elif [ -f /usr/$LIBDIR/libpapi.so -a -f /usr/include/papi.h ]; then
        #    echo - papi- `ls -l --time-style=full-iso /usr/$LIBDIR/libpapi.so\
        #    | awk '{printf "%s", $6}'`" system lib in /usr"
        else
            echo - papi- not installed - no hwc,hwctime, or hwcsamp experiment support
        fi
        if [ -f $OPENSS_PREFIX/$LIBDIR/libsqlite3.so ]; then
            echo - sqlite- `ls -l --time-style=full-iso \
            $OPENSS_PREFIX/$LIBDIR/libsqlite3.so  | awk '{printf "%s", $6}'`
        elif [ "$install_libsqlite" = 1 ]; then
            echo - sqlite- not installed, may be an error in build
        else
            if [ -f /usr/$LIBDIR/libsqlite3.so -a -f /usr/include/sqlite3.h ]; then
               echo - sqlite- `ls -l --time-style=full-iso /usr/$LIBDIR/libsqlite3.so\
               | awk '{printf "%s", $6}'`" system lib in /usr"
            else
               echo - sqlite- using OPENSS_SQLITE
            fi
        fi
        if [ -f $OPENSS_PREFIX/$LIBDIR/libmonitor.so ]; then
            echo - monitor- `ls -l --time-style=full-iso \
            $OPENSS_PREFIX/$LIBDIR/libmonitor.so  | awk '{printf "%s", $6}'`
        else
            echo - monitor- not installed
        fi
        if [ -f $OPENSS_PREFIX/$LIBDIR/libvt.a ]; then
            echo - vampirtrace- `ls -l --time-style=full-iso \
            $OPENSS_PREFIX/$LIBDIR/libvt.a  | awk '{printf "%s", $6}'`
        else
            echo - vampirtrace-  not installed
        fi
        if [ -f $OPENSS_PREFIX/$LIBDIR/libdyninstAPI.so ]; then
            echo - dyninst- `ls -l --time-style=full-iso \
            $OPENSS_PREFIX/$LIBDIR/libdyninstAPI.so  | awk '{printf "%s", $6}'`
        else
            echo - dyninst-  not installed - not needed if instrumentor is offline
        fi
        if [ -f $OPENSS_PREFIX/$LIBDIR/libmrnet.a ]; then
            echo - mrnet- `ls -l --time-style=full-iso \
            $OPENSS_PREFIX/$LIBDIR/libmrnet.a  | awk '{printf "%s", $6}'`
        else
            echo - MRNet-  not installed - not needed if instrumentor is offline
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
        env | grep OPENSS
        echo
    fi
}
#End Functions ----------------------------------------------------------------

if [ `uname -m` = "x86_64" -o `uname -m` = " x86-64" ]; then
    LIBDIR="lib64"
    ALTLIBDIR="lib"
#    echo "UNAME IS X86_64 FAMILY: LIBDIR=$LIBDIR"
    export LIBDIR="lib64"
elif [ `uname -m` = "ppc64" ]; then
   if [ -z $OPENSS_PPC64_BITMODE_64 ]; then 
    LIBDIR="lib"
    ALTLIBDIR="lib64"
    echo "UNAME IS PPC FAMILY: LIBDIR=$LIBDIR"
    export LIBDIR="lib" 
   else
    LIBDIR="lib64"
    ALTLIBDIR="lib"
    echo "UNAME IS PPC (64) FAMILY: LIBDIR=$LIBDIR"
    export LIBDIR="lib64"
    export CFLAGS=" -m64 $CFLAGS "
    export CXXFLAGS=" -m64 $CXXFLAGS "
    export CPPFLAGS=" -m64 $CPPFLAGS "
    echo "UNAME IS PPC FAMILY: LIBDIR=$LIBDIR" 
   fi
elif [ `uname -m` = "ppc" ]; then
    LIBDIR="lib"
    ALTLIBDIR="lib64"
    echo "UNAME IS PPC FAMILY: LIBDIR=$LIBDIR"
    export LIBDIR="lib" 
else
    LIBDIR="lib" 
    ALTLIBDIR="lib64"
    export LIBDIR="lib"
#    echo "UNAME IS X86 FAMILY: LIBDIR=$LIBDIR"
fi

#sys=`uname -n | grep -o '[^0-9]\{0,\}'`
sys=`uname -n `
export MACHINE=$sys
echo ""
echo '    machine: ' $sys
echo ""

export imode=1  #Interactive Mode left as true if no args passed
export report_missing_packages=1
export build_oss=1
export build_symtabapi=1
export build_oss_gui_only=0
export build_oss_runtime_only=0
export build_binutils=0

while [ $# -gt 0 ]; do
    case "$1" in
       --gui-only)
            export OPENSS_INSTRUMENTOR="none"
            export build_oss_gui_only=1
	    echo "Enabling build of openss gui version. No instrumentor is built.."
            shift;;
       --runtime-only)
            export build_oss_runtime_only=1
	    echo "Enabling build of openss collector runtimes. No client is built.."
            shift;;
       --with-online)
            export OPENSS_INSTRUMENTOR="mrnet"
	    echo "Enabling build and install of dyninst and mrnet."
            shift;;
       --with-symtabapi)
            export build_symtabapi=1
	    echo "Enabling build and install of symtabapi (offline only)."
            shift;;
       --exclude-oss)
            export build_oss=0
	    echo "Build and Install of Open|SpeedShop is disabled for this run."
            shift;;
       --devel)
            build_autotools
            exit;;
       --bison)
            build_bison
            exit;;
       --boost)
            build_boost=1

            if test $OPENSS_FORCE_BOOST_BUILD; then
               build_boost=1
            elif test -f /usr/include/boost/regex.hpp -a  \
                    -f /usr/$LIBDIR/libboost_serialization.so -o  \
                    -f /usr/$LIBDIR/libboost_serialization-mt.so ; then
              if [ -f /usr/include/boost/version.hpp ]; then
                 BOOSTVER=`grep "define BOOST_VERSION " /usr/include/boost/version.hpp`
                 #echo "BOOSTVER=$BOOSTVER"
                 POS1=`expr index "$BOOSTVER" "10"`
                 POS2=`expr $POS1 + 2`
                 VERS=`expr substr "$BOOSTVER" "$POS2" 2`
                 #echo "POS1=$POS1"
                 #echo "POS2=$POS2"
                 #echo "VERS=$VERS"
                 if test "$VERS" -gt 40; then
                   build_boost=0
                   echo "libboost detected in /usr/<$LIBDIR>, will not be built..."
                 else
                   build_boost=1
                   echo "libboost version 40 or over not detected."
                 fi

               fi
            elif test -z $OPENSS_FORCE_BOOST_BUILD; then
               build_boost=1
            fi

            if (test $build_boost == 1); then 
              build_boost_routine
            fi
            exit;;
       --xercesc)
            build_xercesc
            exit;;
       --cbtf)
            build_cbtf_routine
            exit;;
       --launchmon)
            build_launchmon
            exit;;
       --python)
            build_python
            exit;;
       --binutils)
            export build_binutils=1
            build
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

if [ $imode == "true" ]; then
    build
else
    build $optionnum
fi

exit
