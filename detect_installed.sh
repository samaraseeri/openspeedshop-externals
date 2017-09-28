#!/bin/bash


die()
{
    echo "$0: error: $*" 1>&2
    exit 1
}

usage() {
    cat << EOF
usage: $0 [option]

-h, --help
This help text.

--install-prefix <directory>

Where directory is the location to install CBTF
and it's supporting tools and libraries.  This will be used
for the install-cbtf --install-prefix value.

--with-krell-root <directory>
This is where the krell root was built into and is referenced 
for most packages not available on the system.  

--with-boost-root <directory>
This is an alternative location for boost.

--target-arch { cray-xk || cray-xe || bgq }

--with-tls { explicit || implicit }
EOF
}

if [ `uname -m` = "x86_64" -o `uname -m` = " x86-64" ]; then
    if [ -d /usr/lib/x86_64-linux-gnu ] ; then
       LIBDIR="lib"
       ALTLIBDIR="lib"
       export LIBDIR="lib"
       #echo "UNAME IS X86_64 FAMILY, on UBUNTU: LIBDIR=$LIBDIR"
    else
       LIBDIR="lib64"
       ALTLIBDIR="lib"
       export LIBDIR="lib64"
       #echo "UNAME IS X86_64 FAMILY: on non-UBUNTU LIBDIR=$LIBDIR"
     fi
elif [ `uname -m` = "ppc64" ]; then
   if [ -e /bgsys/drivers/ppcfloor/../ppc ]; then
    LIBDIR="lib"
    ALTLIBDIR="lib64"
    #echo "UNAME IS PPC (32) BGP FAMILY: LIBDIR=$LIBDIR"
    export LIBDIR="lib"
   elif [ -e /bgsys/drivers/ppcfloor/../ppc64 ]; then
    LIBDIR="lib64"
    ALTLIBDIR="lib"
    #echo "UNAME IS PPC (64) BGQ - FAMILY: LIBDIR=$LIBDIR"
    export LIBDIR="lib64"
    export CFLAGS=" -m64 $CFLAGS "
    export CXXFLAGS=" -m64 $CXXFLAGS "
    export CPPFLAGS=" -m64 $CPPFLAGS "
    #echo "UNAME IS PPC FAMILY: LIBDIR=$LIBDIR" 
   else
    LIBDIR="lib64"
    ALTLIBDIR="lib"
    #echo "UNAME IS PPC (64) NON-BG FAMILY: LIBDIR=$LIBDIR"
    export LIBDIR="lib64"
    export CFLAGS=" -m64 $CFLAGS "
    export CXXFLAGS=" -m64 $CXXFLAGS "
    export CPPFLAGS=" -m64 $CPPFLAGS "
    #echo "UNAME IS PPC FAMILY: LIBDIR=$LIBDIR" 
   fi
elif [ `uname -m` = "ppc" ]; then
    LIBDIR="lib"
    ALTLIBDIR="lib64"
    #echo "UNAME IS PPC FAMILY: LIBDIR=$LIBDIR"
    export LIBDIR="lib"
else
    LIBDIR="lib"
    ALTLIBDIR="lib64"
    export LIBDIR="lib"
    #echo "UNAME IS X86 FAMILY: LIBDIR=$LIBDIR"
fi

sys=`uname -n `
export MACHINE=$sys
output_is_verbose=false

while [ $# -gt 0 ]; do

    #echo "DETECT_INSTALLED, dollar 1=$1"
    #echo "DETECT_INSTALLED, dollar 2=$2"

    case "$1" in
       --target-arch)
            test "x$2" != x || die "missing argument: $*"
            target="$2"
            export KRELL_ROOT_TARGET_ARCH="${target}"
            export OPENSS_TARGET_ARCH="${target}"
            export CBTF_TARGET_ARCH="${target}"
            #echo "Enabling recognition target runtimes for ${target}"
            shift
            shift;;

       --with-tls)
            test "x$2" != x || die "missing argument: $*"
            tls_setting="$2"
            export CBTF_TLS_TYPE="$tls_setting"
            #echo "Setting tls to $tls_setting"
            shift
            shift;;


      --with-cuda)
            test "x$2" != x || die "missing argument: $*"
            case "$2" in
                /* )  dir="$2" ;;
                * )   dir="`pwd`/$2" ;;
            esac
            test -d "$dir" || die "unable to find: $dir"
            export CUDA_INSTALL_PATH="${dir}"
            shift ; shift
            ;;

      --with-cupti)
            test "x$2" != x || die "missing argument: $*"
            case "$2" in
                /* )  dir="$2" ;;
                * )   dir="`pwd`/$2" ;;
            esac
            test -d "$dir" || die "unable to find: $dir"
            export CUPTI_ROOT="${dir}"
            shift ; shift
            ;;



      --with-boost-root)
            test "x$2" != x || die "missing argument: $*"
            case "$2" in
                /* )  dir="$2" ;;
                * )   dir="`pwd`/$2" ;;
            esac
            test -d "$dir" || die "unable to find: $dir"
            export CBTF_BOOST_ROOT="${dir}"
            shift ; shift
            ;;

      --with-papi-root)
            test "x$2" != x || die "missing argument: $*"
            case "$2" in
                /* )  dir="$2" ;;
                * )   dir="`pwd`/$2" ;;
            esac
            test -d "$dir" || die "unable to find: $dir"
            export CBTF_PAPI_ROOT="${dir}"
            shift ; shift
            ;;

      --with-openmpi)
            test "x$2" != x || die "missing argument: $*"
            case "$2" in
                /* )  dir="$2" ;;
                * )   dir="`pwd`/$2" ;;
            esac
            test -d "$dir" || die "unable to find: $dir"
            export CBTF_MPI_OPENMPI="${dir}"
            export KRELL_ROOT_MPI_OPENMPI="${dir}"
            shift ; shift
            ;;

      --with-krell-root)
            test "x$2" != x || die "missing argument: $*"
            case "$2" in
                /* )  dir="$2" ;;
                * )   dir="`pwd`/$2" ;;
            esac
            test -d "$dir" || die "unable to find: $dir"
            export CBTF_KRELL_ROOT="${dir}"
            shift ; shift
            ;;
       --install-prefix)
            test "x$2" != x || die "missing argument: $*"
            case "$2" in
                /* )  dir="$2" ;;
                * )   dir="`pwd`/$2" ;;
            esac
            test -d "$dir" || die "unable to find: $dir"
            export CBTF_PREFIX="${dir}"
            shift ; shift
            ;;
       -v | --verbose)
            output_is_verbose=true
            shift;
            ;;
       -h | --help)
            usage
            exit
            ;;
       *)
            usage
            exit;;
    esac
done

  if [ $KRELL_ROOT_PREFIX ]; then
     export SEARCH_KRELL_ROOT=$KRELL_ROOT_PREFIX
     if [ $output_is_verbose == true ]; then
       echo "Looking for KRELL_ROOT components based, on KRELL_ROOT_PREFIX, in SEARCH_KRELL_ROOT path=$SEARCH_KRELL_ROOT"
     fi
  elif [ $CBTF_KRELL_ROOT ]; then
     export SEARCH_KRELL_ROOT=$CBTF_KRELL_ROOT
     if [ $output_is_verbose == true ]; then
       echo "Looking for KRELL_ROOT components based, on CBTF_KRELL_ROOT, in SEARCH_KRELL_ROOT path=$SEARCH_KRELL_ROOT"
     fi
  fi

  if [ $CBTF_LIBDWARF_ROOT ]; then
     export SEARCH_LIBDWARF_ROOT=$CBTF_LIBDWARF_ROOT
     if [ $output_is_verbose == true ]; then
       echo "Looking for LIBDWARF_ROOT components based, on CBTF_LIBDWARF_ROOT, in SEARCH_LIBDWARF_ROOT path=$SEARCH_LIBDWARF_ROOT"
     fi
  else
     if [ $output_is_verbose == true ]; then
       echo "CBTF_LIBDWARF_ROOT is NOT SET"
     fi
  fi

  if [ $CBTF_LIBELF_ROOT ]; then
     export SEARCH_LIBELF_ROOT=$CBTF_LIBELF_ROOT
     if [ $output_is_verbose == true ]; then
       echo "Looking for LIBELF_ROOT components based, on CBTF_LIBELF_ROOT, in SEARCH_LIBELF_ROOT path=$SEARCH_LIBELF_ROOT"
     fi
  else
     if [ $output_is_verbose == true ]; then
       echo "CBTF_LIBELF_ROOT is NOT SET"
     fi
  fi

  if [ $CBTF_LIBUNWIND_ROOT ]; then
     export SEARCH_LIBUNWIND_ROOT=$CBTF_LIBUNWIND_ROOT
     if [ $output_is_verbose == true ]; then
       echo "Looking for LIBUNWIND_ROOT components based, on CBTF_LIBUNWIND_ROOT, in SEARCH_LIBUNWIND_ROOT path=$SEARCH_LIBUNWIND_ROOT"
     fi
  else
     if [ $output_is_verbose == true ]; then
       echo "CBTF_LIBUNWIND_ROOT is NOT SET"
     fi
  fi

  if [ $CBTF_DYNINST_ROOT ]; then
     export SEARCH_DYNINST_ROOT=$CBTF_DYNINST_ROOT
     if [ $output_is_verbose == true ]; then
       echo "Looking for DYNINST_ROOT components based, on CBTF_DYNINST_ROOT, in SEARCH_DYNINST_ROOT path=$SEARCH_DYNINST_ROOT"
     fi
  else
     if [ $output_is_verbose == true ]; then
       echo "CBTF_DYNINST_ROOT is NOT SET"
     fi
  fi

  if [ $CBTF_MRNET_ROOT ]; then
     export SEARCH_MRNET_ROOT=$CBTF_MRNET_ROOT
     if [ $output_is_verbose == true ]; then
       echo "Looking for MRNET_ROOT components based, on CBTF_MRNET_ROOT, in SEARCH_MRNET_ROOT path=$SEARCH_MRNET_ROOT"
     fi
  fi

  if [ $CBTF_PAPI_ROOT ]; then
     export SEARCH_PAPI_ROOT=$CBTF_PAPI_ROOT
     if [ $output_is_verbose == true ]; then
       echo "Looking for PAPI_ROOT components based, on CBTF_PAPI_ROOT, in SEARCH_PAPI_ROOT path=$SEARCH_PAPI_ROOT"
     fi
  fi

  if [ $CBTF_PYTHON_ROOT ]; then
     export SEARCH_PYTHON_ROOT=$CBTF_PYTHON_ROOT
     if [ $output_is_verbose == true ]; then
       echo "Looking for PYTHON_ROOT components based, on CBTF_PYTHON_ROOT, in SEARCH_PYTHON_ROOT path=$SEARCH_PYTHON_ROOT"
     fi
  fi

  if [ $CBTF_BOOST_ROOT ]; then
     export SEARCH_BOOST_ROOT=$CBTF_BOOST_ROOT
     if [ $output_is_verbose == true ]; then
       echo "Looking for BOOST_ROOT components based, on CBTF_BOOST_ROOT, in SEARCH_BOOST_ROOT path=$SEARCH_BOOST_ROOT"
     fi
  elif [ $OPENSS_BOOST]; then
     export SEARCH_BOOST_ROOT=$OPENSS_BOOST
     if [ $output_is_verbose == true ]; then
       echo "Looking for BOOST_ROOT components based, on CBTF_BOOST_ROOT, in SEARCH_BOOST_ROOT path=$SEARCH_BOOST_ROOT"
     fi
  fi

  if [ $SEARCH_KRELL_ROOT ]; then
      if [ $output_is_verbose == true ]; then
        echo "Looking for components in SEARCH_KRELL_ROOT path=$SEARCH_KRELL_ROOT"
      fi
  else
      echo "Please set either KRELL_ROOT_PREFIX or CBTF_KRELL_ROOT, this script looks for components in the path set by either of those env variables"
      echo "Also set either CBTF_PREFIX if you want the script to generate the --install-prefix CBTF build clause"
      echo "Also set either CBTF_BOOST_ROOT if you if boost is found in a directory outside of the xxx_KRELL_ROOT"
      exit
  fi

binutils_installed_in_cbtf_prefix=1
libelf_installed_in_cbtf_prefix=1
libelf_installed_in_user_prefix=0
libdwarf_installed_in_cbtf_prefix=1
libdwarf_installed_in_user_prefix=0
libunwind_installed_in_cbtf_prefix=0
libunwind_installed_in_user_prefix=0
libunwind_installed_in_root_prefix=1
papi_installed_in_cbtf_prefix=1
libmonitor_installed_in_cbtf_prefix=1
dyninst_installed_in_cbtf_prefix=1
dyninst_installed_in_user_specified_prefix=0
mrnet_installed_in_cbtf_prefix=1
mrnet_installed_in_user_prefix=0
CBTF_installed_in_cbtf_prefix=1
boost_installed_in_cbtf_prefix=1
xercesc_installed_in_cbtf_prefix=1
xercesc_installed_in_user_prefix=0

if [ $output_is_verbose == true ]; then
  echo
  echo "Installed components status:"
  echo
fi

ompt_installed_in_ompt_root=0
if [ -z $CBTF_LIBIOMP_ROOT ]; then
    if [ $output_is_verbose == true ]; then
      echo - ompt- not specified
    fi
else
    if [ -f $CBTF_LIBIOMP_ROOT/include/ompt.h ]; then
      ompt_installed_in_ompt_root=1
      if [ $output_is_verbose == true ]; then
        echo - ompt - `ls -l --time-style=full-iso $CBTF_LIBIOMP_ROOT/include/ompt.h  | awk '{printf "%s", $6}'`
        echo - ompt - specified/installed in $CBTF_LIBIOMP_ROOT
      fi
    fi
fi

cuda_installed_in_cuda_root=0
if [ -z $CUDA_INSTALL_PATH ]; then
    if [ $output_is_verbose == true ]; then
      echo - cuda- not specified
    fi
else
    if [ -f $CUDA_INSTALL_PATH/include/cuda_profiler_api.h ]; then
      cuda_installed_in_cuda_root=1
      if [ $output_is_verbose == true ]; then
        echo - cuda- `ls -l --time-style=full-iso $CUDA_INSTALL_PATH/include/cuda_profiler_api.h  | awk '{printf "%s", $6}'`
        echo - cuda - specified/installed in $CUDA_INSTALL_PATH
      fi
    fi
fi

cupti_installed_in_cupti_root=0
if [ -z $CUPTI_ROOT ]; then
    if [ $output_is_verbose == true ]; then
      echo - cupti- not specified
    fi
else
    if [ -f $CUPTI_ROOT/include/cupti_version.h ]; then
      cupti_installed_in_cupti_root=1
      if [ $output_is_verbose == true ]; then
        echo - cupti- `ls -l --time-style=full-iso $CUPTI_ROOT/include/cupti_version.h  | awk '{printf "%s", $6}'`
        echo - cupti - specified/installed in $CUPTI_ROOT
      fi
    fi
fi

mvapich_installed_in_krellroot_prefix=0
if [ -z $KRELL_ROOT_MPI_MVAPICH ]; then
    if [ $output_is_verbose == true ]; then
      echo - mvapich- not specified
    fi
else
    if [ -f $KRELL_ROOT_MPI_MVAPICH/include/mpi.h ]; then
      mvapich2_installed_in_krellroot_prefix=1
      if [ $output_is_verbose == true ]; then
        echo - mvapich- `ls -l --time-style=full-iso $KRELL_ROOT_MPI_MVAPICH/include/mpi.h  | awk '{printf "%s", $6}'`
        echo - mvapich- specified/installed in $KRELL_ROOT_MPI_MVAPICH
      fi
    fi
fi
  

mvapich2_installed_in_krellroot_prefix=0
if [ -z $KRELL_ROOT_MPI_MVAPICH2 ]; then
    if [ $output_is_verbose == true ]; then
      echo - mvapich2- not specified
    fi
else
    if [ -f $KRELL_ROOT_MPI_MVAPICH2/include/mpi.h ]; then
      mvapich2_installed_in_krellroot_prefix=1
      if [ $output_is_verbose == true ]; then
        echo - mvapich2- `ls -l --time-style=full-iso $KRELL_ROOT_MPI_MVAPICH2/include/mpi.h  | awk '{printf "%s", $6}'`
        echo - mvapich2- specified/installed in $KRELL_ROOT_MPI_MVAPICH2
      fi
    fi
fi
  

mpich2_installed_in_krellroot_prefix=0
if [ -z $KRELL_ROOT_MPI_MPICH2 ]; then
    if [ $output_is_verbose == true ]; then
      echo - mpich2- not specified
    fi
else
    if [ -f $KRELL_ROOT_MPI_MPICH2/include/mpi.h ]; then
      mpich2_installed_in_krellroot_prefix=1
    if [ $output_is_verbose == true ]; then
      echo - mpich2- `ls -l --time-style=full-iso $KRELL_ROOT_MPI_MPICH2/include/mpi.h  | awk '{printf "%s", $6}'`
      echo - mpich2- specified/installed in $KRELL_ROOT_MPI_MPICH2
    fi
  fi
fi
  

mpt_installed_in_krellroot_prefix=0
if [ -z $KRELL_ROOT_MPI_MPT ]; then
    if [ $output_is_verbose == true ]; then
      echo - mpt- not specified
    fi
else
    if [ -f $KRELL_ROOT_MPI_MPT/include/mpi.h ]; then
    mpt_installed_in_krellroot_prefix=1
    if [ $output_is_verbose == true ]; then
      echo - mpt- `ls -l --time-style=full-iso $KRELL_ROOT_MPI_MPT/include/mpi.h  | awk '{printf "%s", $6}'`
      echo - mpt- specified/installed in $KRELL_ROOT_MPI_MPT
    fi
  fi
fi
  

openmpi_installed_in_krellroot_prefix=0
if [ -z $KRELL_ROOT_MPI_OPENMPI ]; then
    if [ $output_is_verbose == true ]; then
      echo - openmpi- not specified
    fi
else
    if [ -f $KRELL_ROOT_MPI_OPENMPI/bin/orterun ]; then
      openmpi_installed_in_krellroot_prefix=1
      if [ $output_is_verbose == true ]; then
        echo - openmpi- `ls -l --time-style=full-iso $KRELL_ROOT_MPI_OPENMPI/bin/orterun  | awk '{printf "%s", $6}'`
        echo - openmpi- specified/installed in $KRELL_ROOT_MPI_OPENMPI
      fi
    fi
fi
  

if [ ! -z $SEARCH_KRELL_ROOT ] && [ -f $SEARCH_KRELL_ROOT/include/bfd.h -a -f $SEARCH_KRELL_ROOT/include/libiberty.h ]; then
    if [ $output_is_verbose == true ]; then
      echo - binutils- `ls -l --time-style=full-iso $SEARCH_KRELL_ROOT/include/bfd.h  | awk '{printf "%s", $6}'`
      echo - binutils- installed in $SEARCH_KRELL_ROOT
    fi
    binutils_installed_in_cbtf_prefix=1
elif [ -f /usr/include/bfd.h -a -f /usr/include/libiberty.h ]; then
    if [ $output_is_verbose == true ]; then
      echo - binutils- `ls -l --time-style=full-iso /usr/include/bfd.h  | awk '{printf "%s", $6}'`
      echo - binutils- installed in /usr
    fi
    binutils_installed_in_cbtf_prefix=0
else
    if [ $output_is_verbose == true ]; then
      echo - binutils- not installed
    fi
    binutils_installed_in_cbtf_prefix=0
fi

if [ $output_is_verbose == true ]; then
  echo "SEARCH_KRELL_ROOT, libelf, $SEARCH_KRELL_ROOT"
fi

if [ ! -z $SEARCH_LIBELF_ROOT ] && [ -f $SEARCH_LIBELF_ROOT/$LIBDIR/libelf.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libelf- `ls -l --time-style=full-iso $SEARCH_LIBELF_ROOT/$LIBDIR/libelf.so  | awk '{printf "%s", $6}'`
      echo - libelf-  installed in $SEARCH_LIBELF_ROOT
    fi
    libelf_installed_in_user_prefix=1
    libelf_installed_in_cbtf_prefix=0
elif [ ! -z $SEARCH_LIBELF_ROOT ] && [ -f $SEARCH_LIBELF_ROOT/$ALTLIBDIR/libelf.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libelf- `ls -l --time-style=full-iso $SEARCH_LIBELF_ROOT/$ALTLIBDIR/libelf.so  | awk '{printf "%s", $6}'`
      echo - libelf-  installed in $SEARCH_LIBELF_ROOT
    fi
    libelf_installed_in_user_prefix=1
    libelf_installed_in_cbtf_prefix=0
elif [ ! -z $SEARCH_KRELL_ROOT ] && [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libelf.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libelf- `ls -l --time-style=full-iso $SEARCH_KRELL_ROOT/$LIBDIR/libelf.so  | awk '{printf "%s", $6}'`
      echo - libelf- installed in $SEARCH_KRELL_ROOT
    fi
    libelf_installed_in_user_prefix=0
    libelf_installed_in_cbtf_prefix=1
elif [ ! -z $SEARCH_KRELL_ROOT ] && [ -f $SEARCH_KRELL_ROOT/$ALTLIBDIR/libelf.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libelf- `ls -l --time-style=full-iso $SEARCH_KRELL_ROOT/$ALTLIBDIR/libelf.so  | awk '{printf "%s", $6}'`
      echo - libelf- installed in $SEARCH_KRELL_ROOT
    fi
    libelf_installed_in_user_prefix=0
    libelf_installed_in_cbtf_prefix=1
elif [ -f /usr/$LIBDIR/libelf.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libelf- `ls -l --time-style=full-iso /usr/$LIBDIR/libelf.so  | awk '{printf "%s", $6}'`
      echo - libelf- installed /usr
    fi
    libelf_installed_in_cbtf_prefix=0
    libelf_installed_in_user_prefix=0
else
    if [ $output_is_verbose == true ]; then
      echo - libelf- not installed
    fi
    libelf_installed_in_cbtf_prefix=0
    libelf_installed_in_user_prefix=0
fi

if  [ ! -z $SEARCH_LIBDWARF_ROOT ] && [ -f $SEARCH_LIBDWARF_ROOT/$LIBDIR/libdwarf.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libdwarf- `ls -l --time-style=full-iso $SEARCH_LIBDWARF_ROOT/$LIBDIR/libdwarf.so  | awk '{printf "%s", $6}'`
      echo - libdwarf-  installed in $SEARCH_LIBDWARF_ROOT
    fi
    libdwarf_installed_in_user_prefix=1
    libdwarf_installed_in_cbtf_prefix=0
elif [ ! -z $SEARCH_LIBDWARF_ROOT ] && [ -f $SEARCH_LIBDWARF_ROOT/$ALTLIBDIR/libdwarf.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libdwarf- `ls -l --time-style=full-iso $SEARCH_LIBDWARF_ROOT/$ALTLIBDIR/libdwarf.so  | awk '{printf "%s", $6}'`
      echo - libdwarf-  installed in $SEARCH_LIBDWARF_ROOT
    fi
    libdwarf_installed_in_user_prefix=1
    libdwarf_installed_in_cbtf_prefix=0
elif [ ! -z $SEARCH_KRELL_ROOT ] && [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libdwarf.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libdwarf- `ls -l --time-style=full-iso $SEARCH_KRELL_ROOT/$LIBDIR/libdwarf.so  | awk '{printf "%s", $6}'`
      echo - libdwarf- installed in $SEARCH_KRELL_ROOT
    fi
    libdwarf_installed_in_user_prefix=0
    libdwarf_installed_in_cbtf_prefix=1
elif [ -f /usr/$LIBDIR/libdwarf.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libdwarf- `ls -l --time-style=full-iso /usr/$LIBDIR/libdwarf.so  | awk '{printf "%s", $6}'`
      echo - libdwarf- installed in /usr
    fi
    libdwarf_installed_in_user_prefix=0
    libdwarf_installed_in_cbtf_prefix=0
else
    if [ $output_is_verbose == true ]; then
      echo - libdwarf- not installed
    fi
    libdwarf_installed_in_cbtf_prefix=0
    libdwarf_installed_in_user_prefix=0
fi

if  [ ! -z $SEARCH_LIBUNWIND_ROOT ] && [ -f $SEARCH_LIBUNWIND_ROOT/$LIBDIR/libunwind.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libunwind- `ls -l --time-style=full-iso $SEARCH_LIBUNWIND_ROOT/$LIBDIR/libunwind.so  | awk '{printf "%s", $6}'`
      echo - libunwind-  installed in $SEARCH_LIBUNWIND_ROOT
    fi
    libunwind_installed_in_root_prefix=0
    libunwind_installed_in_user_prefix=0
    libunwind_installed_in_cbtf_prefix=1
elif [ ! -z $SEARCH_LIBUNWIND_ROOT ] && [ -f $SEARCH_LIBUNWIND_ROOT/$ALTLIBDIR/libunwind.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libunwind- `ls -l --time-style=full-iso $SEARCH_LIBUNWIND_ROOT/$ALTLIBDIR/libunwind.so  | awk '{printf "%s", $6}'`
      echo - libunwind-  installed in $SEARCH_LIBDWARF_ROOT
    fi
    libunwind_installed_in_root_prefix=0
    libunwind_installed_in_user_prefix=0
    libunwind_installed_in_cbtf_prefix=1
elif [ ! -z $SEARCH_KRELL_ROOT ] && [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libunwind.so ]; then
    libunwind_installed_in_root_prefix=1
    libunwind_installed_in_user_prefix=0
    libunwind_installed_in_user_prefix=0
    if [ $output_is_verbose == true ]; then
      echo - libunwind- `ls -l --time-style=full-iso $SEARCH_KRELL_ROOT/$LIBDIR/libunwind.so  | awk '{printf "%s", $6}'`
      echo - libunwind- installed in $SEARCH_KRELL_ROOT
    fi
elif [ -f /usr/$LIBDIR/libunwind.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libunwind- `ls -l --time-style=full-iso /usr/$LIBDIR/libunwind.so  | awk '{printf "%s", $6}'`
      echo - libunwind- installed in /usr
    fi
    libunwind_installed_in_root_prefix=0
    libunwind_installed_in_cbtf_prefix=0
    libunwind_installed_in_user_prefix=1
elif [ -f /usr/$ALTLIBDIR/libunwind.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libunwind- `ls -l --time-style=full-iso /usr/$LIBDIR/libunwind.so  | awk '{printf "%s", $6}'`
      echo - libunwind- installed in /usr
    fi
    libunwind_installed_in_root_prefix=0
    libunwind_installed_in_cbtf_prefix=0
    libunwind_installed_in_user_prefix=1
else
    if [ $output_is_verbose == true ]; then
      echo - libunwind- not installed
    fi
    libunwind_installed_in_root_prefix=0
    libunwind_installed_in_cbtf_prefix=0
    libunwind_installed_in_user_prefix=0
fi

papi_installed_in_papi_root_prefix=0
papi_installed_in_krell_root_prefix=0
if [ $output_is_verbose == true ]; then
  echo - checking for papi- is it installed in SEARCH_PAPI_ROOT=$SEARCH_PAPI_ROOT
  echo - checking for papi- is it installed in SEARCH_KRELL_ROOT=$SEARCH_KRELL_ROOT
fi

if [ ! -z $SEARCH_PAPI_ROOT ] && [ -f $SEARCH_PAPI_ROOT/$LIBDIR/libpapi.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - papi- `ls -l --time-style=full-iso $SEARCH_PAPI_ROOT/$LIBDIR/libpapi.so  | awk '{printf "%s", $6}'`
      echo - papi- installed in $SEARCH_PAPI_ROOT
    fi
    papi_installed_in_papi_root_prefix=1
elif [ ! -z $SEARCH_PAPI_ROOT ] && [ -f $SEARCH_PAPI_ROOT/$ALTLIBDIR/libpapi.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - papi- `ls -l --time-style=full-iso $SEARCH_PAPI_ROOT/$ALTLIBDIR/libpapi.so  | awk '{printf "%s", $6}'`
      echo - papi- installed in $SEARCH_PAPI_ROOT
    fi
    papi_installed_in_papi_root_prefix=1
elif [ ! -z $SEARCH_KRELL_ROOT ] && [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libpapi.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - papi- `ls -l --time-style=full-iso  $SEARCH_KRELL_ROOT/$LIBDIR/libpapi.so  | awk '{printf "%s", $6}'`
      echo - papi- installed in $SEARCH_KRELL_ROOT
    fi
    papi_installed_in_krell_root_prefix=1
elif [ -f /usr/$LIBDIR/libpapi.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - papi- `ls -l --time-style=full-iso /usr/$LIBDIR/libpapi.so  | awk '{printf "%s", $6}'`
      echo - papi- installed in /usr 
    fi
else
    echo - papi- not installed - no hwc,hwctime, or hwcsamp experiment support
fi

python_installed_in_python_root_prefix=0
python_installed_in_krell_root_prefix=0
if [ $output_is_verbose == true ]; then
  echo - checking for python- is it installed in SEARCH_PYTHON_ROOT=$SEARCH_PYTHON_ROOT
  echo - checking for python- is it installed in SEARCH_KRELL_ROOT=$SEARCH_KRELL_ROOT
fi

if [ ! -z $SEARCH_PYTHON_ROOT ] && [ -f $SEARCH_PYTHON_ROOT/$LIBDIR/libpython2.6.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - python- `ls -l --time-style=full-iso $SEARCH_PYTHON_ROOT/$LIBDIR/libpython2.6.so  | awk '{printf "%s", $6}'`
      echo - python- installed in $SEARCH_PYTHON_ROOT
    fi
    python_installed_in_python_root_prefix=1
elif [ ! -z $SEARCH_PYTHON_ROOT ] && [ -f $SEARCH_PYTHON_ROOT/$LIBDIR/libpython2.7.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - python- `ls -l --time-style=full-iso $SEARCH_PYTHON_ROOT/$LIBDIR/libpython2.7.so  | awk '{printf "%s", $6}'`
      echo - python- installed in $SEARCH_PYTHON_ROOT
    fi
    python_installed_in_python_root_prefix=1
elif [ ! -z $SEARCH_PYTHON_ROOT ] && [ -f $SEARCH_PYTHON_ROOT/$ALTLIBDIR/libpython2.6.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - python- `ls -l --time-style=full-iso $SEARCH_PYTHON_ROOT/$ALTLIBDIR/libpython2.6.so  | awk '{printf "%s", $6}'`
      echo - python- installed in $SEARCH_PYTHON_ROOT
    fi
    python_installed_in_python_root_prefix=1
elif [ ! -z $SEARCH_PYTHON_ROOT ] && [ -f $SEARCH_PYTHON_ROOT/$ALTLIBDIR/libpython2.7.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - python- `ls -l --time-style=full-iso $SEARCH_PYTHON_ROOT/$ALTLIBDIR/libpython2.7.so  | awk '{printf "%s", $6}'`
      echo - python- installed in $SEARCH_PYTHON_ROOT
    fi
    python_installed_in_python_root_prefix=1
elif [ ! -z $SEARCH_KRELL_ROOT ] && [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libpython2.6.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - python- `ls -l --time-style=full-iso  $SEARCH_KRELL_ROOT/$LIBDIR/libpython2.6.so  | awk '{printf "%s", $6}'`
      echo - python- installed in $SEARCH_KRELL_ROOT
    fi
    python_installed_in_krell_root_prefix=1
elif [ ! -z $SEARCH_KRELL_ROOT ] && [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libpython2.7.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - python- `ls -l --time-style=full-iso  $SEARCH_KRELL_ROOT/$LIBDIR/libpython2.7.so  | awk '{printf "%s", $6}'`
      echo - python- installed in $SEARCH_KRELL_ROOT
    fi
    python_installed_in_krell_root_prefix=1
elif [ -f /usr/$LIBDIR/libpython2.6.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - python- `ls -l --time-style=full-iso /usr/$LIBDIR/libpython2.6.so  | awk '{printf "%s", $6}'`
      echo - python- installed in /usr 
    fi
elif [ -f /usr/$LIBDIR/libpython2.7.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - python- `ls -l --time-style=full-iso /usr/$LIBDIR/libpython2.7.so  | awk '{printf "%s", $6}'`
      echo - python- installed in /usr 
    fi
else
    echo - python- not installed - no hwc,hwctime, or hwcsamp experiment support
fi


if [ ! -z $SEARCH_KRELL_ROOT ] && [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libmonitor.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - monitor- `ls -l --time-style=full-iso $SEARCH_KRELL_ROOT/$LIBDIR/libmonitor.so  | awk '{printf "%s", $6}'`
      echo - monitor- installed in $SEARCH_KRELL_ROOT
    fi
elif [ ! -z $SEARCH_KRELL_ROOT ] && [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libmonitor_wrap.a ]; then
    if [ $output_is_verbose == true ]; then
      echo - monitor- `ls -l --time-style=full-iso $SEARCH_KRELL_ROOT/$LIBDIR/libmonitor_wrap.a  | awk '{printf "%s", $6}'`
      echo - monitor- installed in $SEARCH_KRELL_ROOT
    fi
elif [ -f /usr/$LIBDIR/libmonitor.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - monitor- `ls -l --time-style=full-iso /usr/$LIBDIR/libmonitor.so  | awk '{printf "%s", $6}'`
      echo - monitor- installed in /usr
    fi
elif [ -f /usr/$LIBDIR/libmonitor_wrap.a ]; then
    if [ $output_is_verbose == true ]; then
      echo - monitor- `ls -l --time-style=full-iso /usr/$LIBDIR/libmonitor_wrap.a | awk '{printf "%s", $6}'`
      echo - monitor- installed in /usr
    fi
    libmonitor_installed_in_cbtf_prefix=0
else
    if [ $output_is_verbose == true ]; then
      echo - monitor- not installed
    fi
    libmonitor_installed_in_cbtf_prefix=0
fi

# Default dyninst-libdir library name to default for platform
DYNLIB=$LIBDIR
if [ ! -z $SEARCH_DYNINST_ROOT ] && [ -f $SEARCH_DYNINST_ROOT/$LIBDIR/libdyninstAPI.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - dyninst- `ls -l --time-style=full-iso \
      $SEARCH_DYNINST_ROOT/$LIBDIR/libdyninstAPI.so  | awk '{printf "%s", $6}'`
      echo - dyninst-  installed in $SEARCH_DYNINST_ROOT
    fi
    dyninst_installed_in_user_specified_prefix=1
    dyninst_installed_in_cbtf_prefix=0
elif [ ! -z $SEARCH_DYNINST_ROOT ] && [ -f $SEARCH_DYNINST_ROOT/$ALTLIBDIR/libdyninstAPI.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - dyninst- `ls -l --time-style=full-iso \
      $SEARCH_DYNINST_ROOT/$ALTLIBDIR/libdyninstAPI.so  | awk '{printf "%s", $6}'`
      echo - dyninst-  installed in $SEARCH_DYNINST_ROOT
    fi
    dyninst_installed_in_user_specified_prefix=1
    dyninst_installed_in_cbtf_prefix=0
elif [ ! -z $SEARCH_KRELL_ROOT ] && [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libdyninstAPI.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - dyninst- `ls -l --time-style=full-iso \
      $SEARCH_KRELL_ROOT/$LIBDIR/libdyninstAPI.so  | awk '{printf "%s", $6}'`
      echo - dyninst-  installed in $SEARCH_KRELL_ROOT
    fi
    dyninst_installed_in_cbtf_prefix=1
    DYNLIB=$LIBDIR
elif [ ! -z $SEARCH_KRELL_ROOT ] && [ -f $SEARCH_KRELL_ROOT/$ALTLIBDIR/libdyninstAPI.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - dyninst- `ls -l --time-style=full-iso \
      $SEARCH_KRELL_ROOT/$LIBDIR/libdyninstAPI.so  | awk '{printf "%s", $6}'`
      echo - dyninst-  installed in $SEARCH_KRELL_ROOT
    fi
    dyninst_installed_in_cbtf_prefix=1
    DYNLIB=$ALTLIBDIR
elif [ -f /usr/$LIBDIR/libdyninstAPI.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - dyninst- `ls -l --time-style=full-iso \
      /usr/$LIBDIR/libdyninstAPI.so  | awk '{printf "%s", $6}'`
      echo - dyninst-  installed in /usr
    fi
    dyninst_installed_in_cbtf_prefix=0
elif [ -f /usr/$LIBDIR/dyninst/libdyninstAPI.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - dyninst- `ls -l --time-style=full-iso \
      /usr/$LIBDIR/dyninst/libdyninstAPI.so  | awk '{printf "%s", $6}'`
      echo - dyninst-  installed in /usr
    fi
    dyninst_installed_in_cbtf_prefix=0
else
    if [ $output_is_verbose == true ]; then
      echo - dyninst-  not installed
    fi
    dyninst_installed_in_cbtf_prefix=0
fi

if [ -f $SEARCH_MRNET_ROOT/$LIBDIR/libmrnet.a ]; then
    mrnet_installed_in_user_prefix=1
    mrnet_installed_in_cbtf_prefix=0
    if [ $output_is_verbose == true ]; then
      echo - mrnet- `ls -l --time-style=full-iso \
      $SEARCH_MRNET_ROOT/$LIBDIR/libmrnet.a  | awk '{printf "%s", $6}'`
      echo - mrnet-  installed in $SEARCH_MRNET_ROOT
    fi
elif [ -f $SEARCH_MRNET_ROOT/$ALTLIBDIR/libmrnet.a ]; then
    mrnet_installed_in_user_prefix=1
    mrnet_installed_in_cbtf_prefix=0
    if [ $output_is_verbose == true ]; then
      echo - mrnet- `ls -l --time-style=full-iso \
      $SEARCH_MRNET_ROOT/$ALTLIBDIR/libmrnet.a  | awk '{printf "%s", $6}'`
      echo - mrnet-  installed in $SEARCH_MRNET_ROOT
    fi
elif [ ! -z $SEARCH_KRELL_ROOT ] && [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libmrnet.a ]; then
    if [ $output_is_verbose == true ]; then
      echo - mrnet- `ls -l --time-style=full-iso \
      $SEARCH_KRELL_ROOT/$LIBDIR/libmrnet.a  | awk '{printf "%s", $6}'`
      echo - mrnet-  installed in $SEARCH_KRELL_ROOT
    fi
elif [ -f /usr/$LIBDIR/libmrnet.a ]; then
    if [ $output_is_verbose == true ]; then
        echo - mrnet- `ls -l --time-style=full-iso \
        /usr/$LIBDIR/libmrnet.a  | awk '{printf "%s", $6}'`
        echo - mrnet-  installed in /usr
    fi
    mrnet_installed_in_cbtf_prefix=0
else
   if [ $output_is_verbose == true ]; then
       echo - mrnet-  not installed
   fi
    mrnet_installed_in_cbtf_prefix=0
fi

boost_installed_in_boost_root_prefix=0
if [ -f $SEARCH_BOOST_ROOT/include/boost/regex.hpp -a \
     -f $SEARCH_BOOST_ROOT/$LIBDIR/libboost_serialization.so -o -f $SEARCH_BOOST_ROOT/$LIBDIR/libboost_serialization-mt.so -o -f $SEARCH_BOOST_ROOT/lib/libboost_serialization.so ]; then
    if [ $output_is_verbose == true ]; then
      if [ -f $SEARCH_BOOST_ROOT/$LIBDIR/libboost_serialization.so ]; then
        echo - boost- `ls -l --time-style=full-iso \
        $SEARCH_BOOST_ROOT/$LIBDIR/libboost_serialization.so  | awk '{printf "%s", $6}'`
      elif [ -f $SEARCH_BOOST_ROOT/lib/libboost_serialization.so ]; then
        echo - boost- `ls -l --time-style=full-iso \
        $SEARCH_BOOST_ROOT/lib/libboost_serialization.so  | awk '{printf "%s", $6}'`
      elif [ -f $SEARCH_BOOST_ROOT/$LIBDIR/libboost_serialization-mt.so ]; then
        echo - boost- `ls -l --time-style=full-iso \
        $SEARCH_BOOST_ROOT/$LIBDIR/libboost_serialization-mt.so  | awk '{printf "%s", $6}'`
      elif [ -f $SEARCH_BOOST_ROOT/lib/libboost_serialization-mt.so]; then
        echo - boost- `ls -l --time-style=full-iso \
        $SEARCH_BOOST_ROOT/lib/libboost_serialization-mt.so  | awk '{printf "%s", $6}'`
      fi
    fi
    boost_installed_in_boost_root_prefix=1
elif [ ! -z $SEARCH_KRELL_ROOT ] && [ -f $SEARCH_KRELL_ROOT/include/boost/regex.hpp -a \
     -f /$SEARCH_KRELL_ROOT/$LIBDIR/libboost_serialization.so -o -f /$SEARCH_KRELL_ROOT/$LIBDIR/libboost_serialization-mt.so ]; then
    if [ $output_is_verbose == true ]; then
      if [ ! -z $SEARCH_KRELL_ROOT ] && [ -f /$SEARCH_KRELL_ROOT/$LIBDIR/libboost_serialization.so ]; then
        echo - boost- `ls -l --time-style=full-iso \
        $SEARCH_KRELL_ROOT/$LIBDIR/libboost_serialization.so  | awk '{printf "%s", $6}'`
      elif [ ! -z $SEARCH_KRELL_ROOT ] && [ -f /$SEARCH_KRELL_ROOT/$LIBDIR/libboost_serialization-mt.so ]; then
        echo - boost- `ls -l --time-style=full-iso \
        $SEARCH_KRELL_ROOT/$LIBDIR/libboost_serialization-mt.so  | awk '{printf "%s", $6}'`
      fi
    fi
elif [ -f /usr/include/boost/regex.hpp -a \
     -f /usr/$LIBDIR/libboost_serialization.so -o -f /usr/$LIBDIR/libboost_serialization-mt.so ]; then
    if [ $output_is_verbose == true ]; then
      if [ -f /usr/$LIBDIR/libboost_serialization.so ]; then
         echo - boost- `ls -l --time-style=full-iso \
         /usr/$LIBDIR/libboost_serialization.so  | awk '{printf "%s", $6}'`
       elif [ -f /usr/$LIBDIR/libboost_serialization-mt.so ]; then
         echo - boost- `ls -l --time-style=full-iso \
         /usr/$LIBDIR/libboost_serialization-mt.so  | awk '{printf "%s", $6}'`
      fi
      echo - boost-  installed in /usr
    fi
    boost_installed_in_cbtf_prefix=0
else
    if [ $output_is_verbose == true ]; then
       echo - boost-  not installed
    fi
    boost_installed_in_cbtf_prefix=0
fi

if [ ! -z $SEARCH_KRELL_ROOT ] && [ -f $SEARCH_KRELL_ROOT/include/xercesc/util/XercesVersion.hpp -a -f $SEARCH_KRELL_ROOT/$LIBDIR/libxerces-c.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - xerces-c- `ls -l --time-style=full-iso \
      $SEARCH_KRELL_ROOT/$LIBDIR/libxerces-c.so  | awk '{printf "%s", $6}'`
      echo - xerces-c-  installed in $SEARCH_KRELL_ROOT 
    fi
    xercesc_installed_in_user_prefix=0
    xercesc_installed_in_cbtf_prefix=1
elif [ -f /usr/include/xercesc/util/XercesVersion.hpp -a -f /usr/$LIBDIR/libxerces-c.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - xerces-c- `ls -l --time-style=full-iso \
      /usr/$LIBDIR/libxerces-c.so  | awk '{printf "%s", $6}'`
      echo - xerces-c-  installed in /usr
    fi
    xercesc_installed_in_user_prefix=1
    xercesc_installed_in_cbtf_prefix=0
else
    if [ $output_is_verbose == true ]; then
      echo - xerces-c-  not installed
    fi
    xercesc_installed_in_cbtf_prefix=0
    xercesc_installed_in_user_prefix=0
fi

if [ $output_is_verbose == true ]; then
  echo
  echo "Environment variables set:"
  echo
  env | grep CBTF
  echo ""
fi

if [ -z $CBTF_PREFIX ]; then
   echo "WARNING ---- CBTF_PREFIX was not set.  No --install-prefix path was added to the install line."
   echo "WARNING ---- Either manually add or set CBTF_PREFIX and re-run script."
fi

# Now put out a suggested install-cbtf for building the cbtf infrastructure and tool components
if [ $output_is_verbose == true ]; then
  echo ""
  echo "Suggested install-cbtf line for building the CBTF infrastructure (framework and tools):"
  echo ""
fi

if [ $CBTF_TARGET_ARCH ]; then
  cbtf_install_line="./install-cbtf --install-prefix $CBTF_PREFIX --target-arch $CBTF_TARGET_ARCH --with-cbtf-root $SEARCH_KRELL_ROOT " 
else
  cbtf_install_line="./install-cbtf --install-prefix $CBTF_PREFIX --with-cbtf-root $SEARCH_KRELL_ROOT " 
fi

  if [ $CBTF_TLS_TYPE ]; then
     tls_install_line=" --with-tls $CBTF_TLS_TYPE "
  else
     tls_install_line=""
  fi
  

  if [ "$binutils_installed_in_cbtf_prefix" = 0 ]; then
     binutils_install_line=" --with-binutils-root /usr  "
  else
     binutils_install_line=" --with-binutils-root $SEARCH_KRELL_ROOT"
  fi

  if [ $output_is_verbose == true ]; then
    echo "libelf_installed_in_user_prefix=$libelf_installed_in_user_prefix"
    echo "libelf_installed_in_cbtf_prefix=$libelf_installed_in_cbtf_prefix"
  fi

  if [ "$libelf_installed_in_user_prefix" = 1 ]; then
     libelf_install_line=" --with-libelf-root $SEARCH_LIBELF_ROOT"
  elif [ "$libelf_installed_in_cbtf_prefix" = 0 ]; then
     libelf_install_line=" --with-libelf-root /usr"
  else
     libelf_install_line=" --with-libelf-root $SEARCH_KRELL_ROOT"
  fi

  if [ $output_is_verbose == true ]; then
    echo "libdwarf_installed_in_user_prefix=$libdwarf_installed_in_user_prefix"
    echo "libdwarf_installed_in_cbtf_prefix=$libdwarf_installed_in_cbtf_prefix"
  fi

  if [ "$libdwarf_installed_in_user_prefix" = 1 ]; then
     libdwarf_install_line=" --with-libdwarf-root $SEARCH_LIBDWARF_ROOT"
  elif [ "$libdwarf_installed_in_cbtf_prefix" = 0 ]; then
     libdwarf_install_line=" --with-libdwarf-root /usr"
  else
     libdwarf_install_line=" --with-libdwarf-root $SEARCH_KRELL_ROOT"
  fi

  libdwarf_lib_line=""
  if [ $CBTF_LIBDWARF_ROOT_LIB ]; then
     libdwarf_lib_line=" --with-libdwarf-libdir $CBTF_LIBDWARF_ROOT_LIB"
  fi

  if [ $output_is_verbose == true ]; then
    echo "libunwind_installed_in_user_prefix=$libunwind_installed_in_user_prefix"
    echo "libunwind_installed_in_cbtf_prefix=$libunwind_installed_in_cbtf_prefix"
  fi

  libunwind_install_line=""
  if [ "$libunwind_installed_in_root_prefix" = 1 ]; then
     libunwind_install_line=" --with-libunwind-root $SEARCH_KRELL_ROOT"
  elif [ "$libunwind_installed_in_user_prefix" = 1 ] ; then
     libunwind_install_line=" --with-libunwind-root /usr"
  elif [ "$libunwind_installed_in_cbtf_prefix" = 1 ] ; then
     libunwind_install_line=" --with-libunwind-root $SEARCH_LIBUNWIND_ROOT"
  else
     libunwind_install_line=" --with-libunwind-root /usr"
  fi

  if [ $output_is_verbose == true ]; then
    echo "libunwind_install_line=$libunwind_install_line"
  fi

  if [ "$papi_installed_in_papi_root_prefix" = 1 ]; then
     papi_install_line=" --with-papi-root $SEARCH_PAPI_ROOT"
     if [ $output_is_verbose == true ]; then
       echo "papi_install_line=$papi_install_line"
     fi
  elif [ "$papi_installed_in_krell_root_prefix" = 1 ]; then
     papi_install_line=" --with-papi-root $SEARCH_KRELL_ROOT"
     if [ $output_is_verbose == true ]; then
       echo "papi_install_line=$papi_install_line"
     fi
  else
     papi_install_line=""
  fi

  if [ "$python_installed_in_python_root_prefix" = 1 ]; then
     python_install_line=" --with-python-root $SEARCH_PYTHON_ROOT"
     if [ $output_is_verbose == true ]; then
       echo "python_install_line=$python_install_line"
     fi
  elif [ "$python_installed_in_krell_root_prefix" = 1 ]; then
     python_install_line=" --with-python-root $SEARCH_KRELL_ROOT"
     if [ $output_is_verbose == true ]; then
       echo "python_install_line=$python_install_line"
     fi
  else
     python_install_line=""
  fi

   libmonitor_install_line=" --with-libmonitor-root $SEARCH_KRELL_ROOT"

  dyninst_install_line=""
  if [ "$dyninst_installed_in_user_specified_prefix" = 1 ]; then
     dyninst_install_line=" --with-dyninst-root $SEARCH_DYNINST_ROOT"
  elif [ "$dyninst_installed_in_cbtf_prefix" = 1 ]; then
     dyninst_install_line=" --with-dyninst-root $SEARCH_KRELL_ROOT"
  fi

  dyninst_lib_line=""
  if [ "$dyninst_installed_in_user_specified_prefix" = 1 ]; then
     dyninst_lib_line=" --with-dyninst-libdir $SEARCH_DYNINST_ROOT_LIB"
  elif [ "$dyninst_installed_in_cbtf_prefix" = 1 ]; then
     dyninst_install_line=" --with-dyninst-libdir $SEARCH_KRELL_ROOT/$DYNLIB"
  elif [ -f /usr/$LIBDIR/dyninst/libdyninstAPI.so ]; then
     dyninst_lib_line=" --with-dyninst-libdir /usr/$LIBDIR/dyninst"
  fi

  if [ "$mrnet_installed_in_user_prefix" = 1 ]; then
     mrnet_install_line=" --with-mrnet-root $SEARCH_MRNET_ROOT"
  elif [ "$mrnet_installed_in_cbtf_prefix" = 1 ]; then
     mrnet_install_line=" --with-mrnet-root $SEARCH_KRELL_ROOT"
  else
     mrnet_install_line=""
  fi

  if [ "$boost_installed_in_boost_root_prefix" = 1 ]; then
     boost_install_line=" --with-boost-root $SEARCH_BOOST_ROOT"
  else
     boost_install_line=" --with-boost-root $SEARCH_KRELL_ROOT"
  fi

  if [ "$xercesc_installed_in_user_prefix" = 1 ]; then
     xercesc_install_line=" --with-xercesc-root /usr" 
  elif [ "$xercesc_installed_in_cbtf_prefix" = 1 ]; then
     xercesc_install_line=" --with-xercesc-root $SEARCH_KRELL_ROOT" 
  else
     xercesc_install_line="" 
  fi

openmpi_install_line=""
if [ "$openmpi_installed_in_krellroot_prefix" = 1 ]; then
   openmpi_install_line=" --with-openmpi $KRELL_ROOT_MPI_OPENMPI"
fi

mpich2_install_line=""
if [ "$mpich2_installed_in_krellroot_prefix" = 1 ]; then
   mpich2_install_line=" --with-mpich2 $KRELL_ROOT_MPI_MPICH2"
fi

mvapich2_install_line=""
if [ "$mvapich2_installed_in_krellroot_prefix" = 1 ]; then
   mvapich2_install_line=" --with-mvapich2 $KRELL_ROOT_MPI_MVAPICH2"
fi

mvapich_install_line=""
if [ "$mvapich_installed_in_krellroot_prefix" = 1 ]; then
   mvapich_install_line=" --with-mvapich $KRELL_ROOT_MPI_MVAPICH"
fi

mpt_install_line=""
if [ "$mpt_installed_in_krellroot_prefix" = 1 ]; then
   mpt_install_line=" --with-mpt $KRELL_ROOT_MPI_MPT"
fi
   
ompt_install_line=""
if [ "$ompt_installed_in_ompt_root" = 1 ]; then
   ompt_install_line=" --with-libiomp $CBTF_LIBIOMP_ROOT"
fi
   
cuda_install_line=""
if [ "$cuda_installed_in_cuda_root" = 1 ]; then
   cuda_install_line=" --with-cuda $CUDA_INSTALL_PATH"
fi

cupti_install_line=""
if [ "$cupti_installed_in_cupti_root" = 1 ]; then
   cupti_install_line=" --with-cupti $CUPTI_ROOT"
fi


new_line=${cbtf_install_line}${binutils_install_line}${libelf_install_line}${libdwarf_install_line}${libdwarf_lib_line}${libunwind_install_line}${papi_install_line}${python_install_line}${libmonitor_install_line}${dyninst_install_line}${dyninst_lib_line}${mrnet_install_line}${boost_install_line}${xercesc_install_line}${openmpi_install_line}${mpich2_install_line}${mvapich2_install_line}${mvapich_install_line}${mpt_install_line}${cuda_install_line}${cupti_install_line}${ompt_install_line}${tls_install_line}

echo ${new_line}
if [ $output_is_verbose == true ]; then
  echo ""
fi
