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
EOF
}

if [ `uname -m` = "x86_64" -o `uname -m` = " x86-64" ]; then
    LIBDIR="lib64"
    ALTLIBDIR="lib"
#    echo "UNAME IS X86_64 FAMILY: LIBDIR=$LIBDIR"
    export LIBDIR="lib64"
elif [ `uname -m` = "ppc64" ]; then
   if [ $CBTF_PPC64_BITMODE_32 ]; then
    LIBDIR="lib"
    ALTLIBDIR="lib64"
#    echo "UNAME IS PPC64 FAMILY, 32 bit: LIBDIR=$LIBDIR"
    export LIBDIR="lib"
   else
    LIBDIR="lib64"
    ALTLIBDIR="lib"
#    echo "UNAME IS PPC (64) FAMILY, 64: LIBDIR=$LIBDIR"
    export LIBDIR="lib64"
    export CFLAGS=" -m64 $CFLAGS "
    export CXXFLAGS=" -m64 $CXXFLAGS "
    export CPPFLAGS=" -m64 $CPPFLAGS "
   fi
elif [ `uname -m` = "ppc" ]; then
    LIBDIR="lib"
    ALTLIBDIR="lib64"
#    echo "UNAME IS PPC FAMILY: LIBDIR=$LIBDIR"
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
output_is_verbose=false
#echo ""
#echo '    machine: ' $sys
#echo ""
#echo '    LIBDIR: ' $LIBDIR

while [ $# -gt 0 ]; do
    case "$1" in
       --bgq)
            export OPENSS_TARGET_ARCH="bgq"
            export CBTF_TARGET_ARCH="bgq"
            echo "Enabling recognition target runtimes for bgq"
            shift;;
       --crayxk)
            export OPENSS_TARGET_ARCH="cray-xk"
            export CBTF_TARGET_ARCH="cray-xk"
            echo "Enabling recognition target runtimes for cray-xk"
            shift;;
       --crayxe)
            export OPENSS_TARGET_ARCH="cray-xe"
            export CBTF_TARGET_ARCH="cray-xe"
            echo "Enabling recognition target runtimes for cray-xe"
            shift;;
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

# If target arch set then add that on to the search path, otherwise use the original path to look for the libraries
#if [ $OPENSS_TARGET_ARCH ]; then
#  if [ $KRELL_ROOT_PREFIX ]; then
#     export SEARCH_KRELL_ROOT=$KRELL_ROOT_PREFIX/$OPENSS_TARGET_ARCH
#     if [ $output_is_verbose == true ]; then
#       echo "Looking for KRELL_ROOT components based, on KRELL_ROOT_PREFIX, in SEARCH_KRELL_ROOT path=$SEARCH_KRELL_ROOT"
#     fi
#  elif [ $CBTF_KRELL_ROOT ]; then
#     export SEARCH_KRELL_ROOT=$CBTF_KRELL_ROOT/$OPENSS_TARGET_ARCH
#     if [ $output_is_verbose == true ]; then
#       echo "Looking for KRELL_ROOT components based, on CBTF_KRELL_ROOT, in SEARCH_KRELL_ROOT path=$SEARCH_KRELL_ROOT"
#     fi
#  fi
#  if [ $OPENSS_BOOST]; then
#     export SEARCH_BOOST_ROOT=$OPENSS_BOOST/$OPENSS_TARGET_ARCH
#     if [ $output_is_verbose == true ]; then
#       echo "Looking for BOOST_ROOT components based, on CBTF_BOOST_ROOT, in SEARCH_BOOST_ROOT path=$SEARCH_BOOST_ROOT"
#     fi
#  elif [ $CBTF_BOOST_ROOT ]; then
#     export SEARCH_BOOST_ROOT=$CBTF_BOOST_ROOT/$OPENSS_TARGET_ARCH
#     if [ $output_is_verbose == true ]; then
#       echo "Looking for BOOST_ROOT components based, on CBTF_BOOST_ROOT, in SEARCH_BOOST_ROOT path=$SEARCH_BOOST_ROOT"
#     fi
#  fi
#else
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
#fi

#if [ $OPENSS_TARGET_ARCH ]; then
#  if [ $SEARCH_KRELL_ROOT ]; then
#      if [ $output_is_verbose == true ]; then
#        echo "Looking for components in SEARCH_KRELL_ROOT path=$SEARCH_KRELL_ROOT"
#      fi
#  else
#      echo "Please set either KRELL_ROOT_PREFIX or CBTF_KRELL_ROOT, this script looks for components in the path set by either of those env variables"
#      echo "Also set either CBTF_PREFIX if you want the script to generate the --install-prefix CBTF build clause"
#      echo "Also set either CBTF_BOOST_ROOT if you if boost is found in a directory outside of the xxx_KRELL_ROOT"
#      exit
#  fi
#else
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
#fi

binutils_installed_in_cbtf_prefix=1
libelf_installed_in_cbtf_prefix=1
libdwarf_installed_in_cbtf_prefix=1
libunwind_installed_in_cbtf_prefix=1
papi_installed_in_cbtf_prefix=1
libmonitor_installed_in_cbtf_prefix=1
dyninst_installed_in_cbtf_prefix=1
mrnet_installed_in_cbtf_prefix=1
CBTF_installed_in_cbtf_prefix=1
boost_installed_in_cbtf_prefix=1
xercesc_installed_in_cbtf_prefix=1

if [ $output_is_verbose == true ]; then
  echo
  echo "Installed components status:"
  echo
fi

if [ -f $SEARCH_KRELL_ROOT/bin/ld -a -f $SEARCH_KRELL_ROOT/include/bfd.h -a -f $SEARCH_KRELL_ROOT/include/libiberty.h ]; then
    if [ $output_is_verbose == true ]; then
      echo - binutils- `ls -l --time-style=full-iso \
      $SEARCH_KRELL_ROOT/bin/ld  | awk '{printf "%s", $6}'`
      echo - binutils- installed in $SEARCH_KRELL_ROOT
    fi
elif [ -f /usr/bin/ld -a -f /usr/include/bfd.h -a -f /usr/include/libiberty.h ]; then
    if [ $output_is_verbose == true ]; then
      echo - binutils- `ls -l --time-style=full-iso \
      /usr/bin/ld  | awk '{printf "%s", $6}'`
      echo - binutils- installed in /usr
    fi
    binutils_installed_in_cbtf_prefix=0
else
    if [ $output_is_verbose == true ]; then
      echo - binutils- not installed
    fi
    binutils_installed_in_cbtf_prefix=0
fi

if [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libelf.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libelf- `ls -l --time-style=full-iso \
      $SEARCH_KRELL_ROOT/$LIBDIR/libelf.so  | awk '{printf "%s", $6}'`
      echo - libelf- installed in $SEARCH_KRELL_ROOT
    fi
elif [ -f /usr/$LIBDIR/libelf.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libelf- `ls -l --time-style=full-iso \
      /usr/$LIBDIR/libelf.so  | awk '{printf "%s", $6}'`
      echo - libelf- installed /usr
    fi
    libelf_installed_in_cbtf_prefix=0
else
    if [ $output_is_verbose == true ]; then
      echo - libelf- not installed
    fi
    libelf_installed_in_cbtf_prefix=0
fi

if [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libdwarf.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libdwarf- `ls -l --time-style=full-iso \
      $SEARCH_KRELL_ROOT/$LIBDIR/libdwarf.so  | awk '{printf "%s", $6}'`
      echo - libdwarf- installed in $SEARCH_KRELL_ROOT
    fi
elif [ -f /usr/$LIBDIR/libdwarf.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libdwarf- `ls -l --time-style=full-iso \
      /usr/$LIBDIR/libdwarf.so  | awk '{printf "%s", $6}'`
      echo - libdwarf- installed in /usr
    fi
    libdwarf_installed_in_cbtf_prefix=0
else
    if [ $output_is_verbose == true ]; then
      echo - libdwarf- not installed
    fi
    libdwarf_installed_in_cbtf_prefix=0
fi

if [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libunwind.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libunwind- `ls -l --time-style=full-iso \
      $SEARCH_KRELL_ROOT/$LIBDIR/libunwind.so  | awk '{printf "%s", $6}'`
      echo - libunwind- installed in $SEARCH_KRELL_ROOT
    fi
elif [ -f /usr/$LIBDIR/libunwind.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - libunwind- `ls -l --time-style=full-iso \
      /usr/$LIBDIR/libunwind.so  | awk '{printf "%s", $6}'`
      echo - libunwind- installed in /usr
    fi
    libunwind_installed_in_cbtf_prefix=0
else
    if [ $output_is_verbose == true ]; then
      echo - libunwind- not installed
    fi
    libunwind_installed_in_cbtf_prefix=0
fi

if [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libpapi.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - papi- `ls -l --time-style=full-iso \
      $SEARCH_KRELL_ROOT/$LIBDIR/libpapi.so  | awk '{printf "%s", $6}'`
      echo - papi- installed in $SEARCH_KRELL_ROOT
    fi
elif [ -f /usr/$LIBDIR/libpapi.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - papi- `ls -l --time-style=full-iso \
      /usr/$LIBDIR/libpapi.so  | awk '{printf "%s", $6}'`
      echo - papi- installed in /usr 
    fi
    papi_installed_in_cbtf_prefix=0
else
    echo - papi- not installed - no hwc,hwctime, or hwcsamp experiment support
    papi_installed_in_cbtf_prefix=0
fi

if [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libmonitor.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - monitor- `ls -l --time-style=full-iso \
      $SEARCH_KRELL_ROOT/$LIBDIR/libmonitor.so  | awk '{printf "%s", $6}'`
      echo - monitor- installed in $SEARCH_KRELL_ROOT
    fi
elif [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libmonitor_wrap.a ]; then
    if [ $output_is_verbose == true ]; then
      echo - monitor- `ls -l --time-style=full-iso \
      $SEARCH_KRELL_ROOT/$LIBDIR/libmonitor_wrap.a  | awk '{printf "%s", $6}'`
      echo - monitor- installed in $SEARCH_KRELL_ROOT
    fi
elif [ -f /usr/$LIBDIR/libmonitor.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - monitor- `ls -l --time-style=full-iso \
      /usr/$LIBDIR/libmonitor.so  | awk '{printf "%s", $6}'`
      echo - monitor- installed in /usr
    fi
elif [ -f /usr/$LIBDIR/libmonitor_wrap.a ]; then
    if [ $output_is_verbose == true ]; then
      echo - monitor- `ls -l --time-style=full-iso \
      /usr/$LIBDIR/libmonitor_wrap.a | awk '{printf "%s", $6}'`
      echo - monitor- installed in /usr
    fi
    libmonitor_installed_in_cbtf_prefix=0
else
    if [ $output_is_verbose == true ]; then
      echo - monitor- not installed
    fi
    libmonitor_installed_in_cbtf_prefix=0
fi

if [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libdyninstAPI.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - dyninst- `ls -l --time-style=full-iso \
      $SEARCH_KRELL_ROOT/$LIBDIR/libdyninstAPI.so  | awk '{printf "%s", $6}'`
      echo - dyninst-  installed in $SEARCH_KRELL_ROOT
    fi
elif [ -f /usr/$LIBDIR/libdyninstAPI.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - dyninst- `ls -l --time-style=full-iso \
      /usr/$LIBDIR/libdyninstAPI.so  | awk '{printf "%s", $6}'`
      echo - dyninst-  installed in /usr
    fi
    dyninst_installed_in_cbtf_prefix=0
else
    if [ $output_is_verbose == true ]; then
      echo - dyninst-  not installed
    fi
    dyninst_installed_in_cbtf_prefix=0
fi

if [ -f $SEARCH_KRELL_ROOT/$LIBDIR/libmrnet.a ]; then
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
elif [ -f $SEARCH_KRELL_ROOT/include/boost/regex.hpp -a \
     -f /$SEARCH_KRELL_ROOT/$LIBDIR/libboost_serialization.so -o -f /$SEARCH_KRELL_ROOT/$LIBDIR/libboost_serialization-mt.so ]; then
    if [ $output_is_verbose == true ]; then
      if [ -f /$SEARCH_KRELL_ROOT/$LIBDIR/libboost_serialization.so ]; then
        echo - boost- `ls -l --time-style=full-iso \
        $SEARCH_KRELL_ROOT/$LIBDIR/libboost_serialization.so  | awk '{printf "%s", $6}'`
      elif [ -f /$SEARCH_KRELL_ROOT/$LIBDIR/libboost_serialization-mt.so ]; then
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
if [ -f $SEARCH_KRELL_ROOT/include/xercesc/util/XercesVersion.hpp -a -f $SEARCH_KRELL_ROOT/$LIBDIR/libxerces-c.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - xerces-c- `ls -l --time-style=full-iso \
      $SEARCH_KRELL_ROOT/$LIBDIR/libxerces-c.so  | awk '{printf "%s", $6}'`
      echo - xerces-c-  installed in $SEARCH_KRELL_ROOT 
    fi
elif [ -f /usr/include/xercesc/util/XercesVersion.hpp -a -f /usr/$LIBDIR/libxerces-c.so ]; then
    if [ $output_is_verbose == true ]; then
      echo - xerces-c- `ls -l --time-style=full-iso \
      /usr/$LIBDIR/libxerces-c.so  | awk '{printf "%s", $6}'`
      echo - xerces-c-  installed in /usr
    fi
else
    if [ $output_is_verbose == true ]; then
      echo - xerces-c-  not installed
    fi
    xercesc_installed_in_cbtf_prefix=0
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
if [ $OPENSS_TARGET_ARCH ]; then
  cbtf_install_line="./install-cbtf --install-prefix $CBTF_PREFIX --target-arch $OPENSS_TARGET_ARCH --with-target-cbtf-root $SEARCH_KRELL_ROOT" 
else
  cbtf_install_line="./install-cbtf --install-prefix $CBTF_PREFIX --with-cbtf-root $SEARCH_KRELL_ROOT" 
fi

#if [ $OPENSS_TARGET_ARCH ]; then
#  if [ "$binutils_installed_in_cbtf_prefix" = 0 ]; then
#     binutils_install_line=" --with-target-binutils-root /usr  "
#  else
#     binutils_install_line=" --with-target-binutils-root $SEARCH_KRELL_ROOT"
#  fi
#else
  if [ "$binutils_installed_in_cbtf_prefix" = 0 ]; then
     binutils_install_line=" --with-binutils-root /usr  "
  else
     binutils_install_line=" --with-binutils-root $SEARCH_KRELL_ROOT"
  fi
#fi

#if [ $OPENSS_TARGET_ARCH ]; then
#  if [ "$libelf_installed_in_cbtf_prefix" = 0 ]; then
#     libelf_install_line=" --with-target-libelf-root /usr"
#  else
#     libelf_install_line=" --with-target-libelf-root $SEARCH_KRELL_ROOT"
#  fi
#else
  if [ "$libelf_installed_in_cbtf_prefix" = 0 ]; then
     libelf_install_line=" --with-libelf-root /usr"
  else
     libelf_install_line=" --with-libelf-root $SEARCH_KRELL_ROOT"
  fi
#fi

#if [ $OPENSS_TARGET_ARCH ]; then
#  if [ "$libdwarf_installed_in_cbtf_prefix" = 0 ]; then
#     libdwarf_install_line=" --with-target-libdwarf-root /usr"
#  else
#     libdwarf_install_line=" --with-target-libdwarf-root $SEARCH_KRELL_ROOT"
#  fi
#else
  if [ "$libdwarf_installed_in_cbtf_prefix" = 0 ]; then
     libdwarf_install_line=" --with-libdwarf-root /usr"
  else
     libdwarf_install_line=" --with-libdwarf-root $SEARCH_KRELL_ROOT"
  fi
#fi

#if [ $OPENSS_TARGET_ARCH ]; then
#  if [ "$libunwind_installed_in_cbtf_prefix" = 0 ]; then
#     libunwind_install_line=" --with-target-libunwind-root /usr"
#  else
#     libunwind_install_line=" --with-target-libunwind-root $SEARCH_KRELL_ROOT"
#  fi
#else
  if [ "$libunwind_installed_in_cbtf_prefix" = 0 ]; then
     libunwind_install_line=" --with-libunwind-root /usr"
  else
     libunwind_install_line=" --with-libunwind-root $SEARCH_KRELL_ROOT"
  fi
#fi

#if [ $OPENSS_TARGET_ARCH ]; then
#  if [ "$papi_installed_in_cbtf_prefix" = 0 ]; then
#     papi_install_line=" --with-target-papi-root /usr"
#  else
#     papi_install_line=" --with-target-papi-root $SEARCH_KRELL_ROOT"
#  fi
#else
  if [ "$papi_installed_in_cbtf_prefix" = 0 ]; then
     papi_install_line=" --with-papi-root /usr"
  else
     papi_install_line=" --with-papi-root $SEARCH_KRELL_ROOT"
  fi
#fi

#if [ $OPENSS_TARGET_ARCH ]; then
#  if [ "$libmonitor_installed_in_cbtf_prefix" = 0 ]; then
#     libmonitor_install_line=" --with-target-libmonitor-root /usr"
#  else
#     libmonitor_install_line=" --with-target-libmonitor-root $SEARCH_KRELL_ROOT"
#  fi
#else
  if [ "$libmonitor_installed_in_cbtf_prefix" = 0 ]; then
     libmonitor_install_line=" --with-libmonitor-root /usr"
  else
     libmonitor_install_line=" --with-libmonitor-root $SEARCH_KRELL_ROOT"
  fi
#fi

#if [ $OPENSS_TARGET_ARCH ]; then
#  if [ "$dyninst_installed_in_cbtf_prefix" = 0 ]; then
#     dyninst_install_line=" --with-target-dyninst-root /usr"
#  else
#     dyninst_install_line=" --with-target-dyninst-root $SEARCH_KRELL_ROOT"
#  fi
#else
  if [ "$dyninst_installed_in_cbtf_prefix" = 0 ]; then
     dyninst_install_line=" --with-dyninst-root /usr"
  else
     dyninst_install_line=" --with-dyninst-root $SEARCH_KRELL_ROOT"
  fi
#fi

#if [ $OPENSS_TARGET_ARCH ]; then
#  if [ "$mrnet_installed_in_cbtf_prefix" = 0 ]; then
#     mrnet_install_line=" --with-target-mrnet-root /usr"
#  else
#     mrnet_install_line=" --with-target-mrnet-root $SEARCH_KRELL_ROOT"
#  fi
#else
  if [ "$mrnet_installed_in_cbtf_prefix" = 0 ]; then
     mrnet_install_line=" --with-mrnet-root /usr"
  else
     mrnet_install_line=" --with-mrnet-root $SEARCH_KRELL_ROOT"
  fi
#fi

#if [ $OPENSS_TARGET_ARCH ]; then
#  if [ "$boost_installed_in_cbtf_prefix" = 0 ]; then
#     boost_install_line=" --with-target-boost-root /usr"
#  elif [ "$boost_installed_in_boost_root_prefix" = 1 ]; then
#     boost_install_line=" --with-target-boost-root $SEARCH_BOOST_ROOT"
#  else
#     boost_install_line=" --with-target-boost-root $SEARCH_KRELL_ROOT"
#  fi
#else
  if [ "$boost_installed_in_cbtf_prefix" = 0 ]; then
     boost_install_line=" --with-boost-root /usr"
  elif [ "$boost_installed_in_boost_root_prefix" = 1 ]; then
     boost_install_line=" --with-boost-root $SEARCH_BOOST_ROOT"
  else
     boost_install_line=" --with-boost-root $SEARCH_KRELL_ROOT"
  fi
#fi

#if [ $OPENSS_TARGET_ARCH ]; then
#  if [ "$xercesc_installed_in_cbtf_prefix" = 0 ]; then
#     xercesc_install_line=" --with-target-xercesc-root /usr"
#  else
#     xercesc_install_line=" --with-target-xercesc-root $SEARCH_KRELL_ROOT" 
#  fi
#else
  if [ "$xercesc_installed_in_cbtf_prefix" = 0 ]; then
     xercesc_install_line=" --with-xercesc-root /usr"
  else
     xercesc_install_line=" --with-xercesc-root $SEARCH_KRELL_ROOT" 
  fi
#fi

new_line=${cbtf_install_line}${binutils_install_line}${libelf_install_line}${libdwarf_install_line}${libunwind_install_line}${papi_install_line}${libmonitor_install_line}${dyninst_install_line}${mrnet_install_line}${boost_install_line}${xercesc_install_line}

echo ${new_line}
if [ $output_is_verbose == true ]; then
  echo ""
fi
