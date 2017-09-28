#! /bin/bash 
set -x

base_dir=/u/jgalarow
root_dir=$base_dir/krellroot_v2.3.1wrpms
root_lib64dir=$root_dir/lib64
cbtfk_dir=/u/jgalarow/cbtf_v2.3.1wrpms_2
cbtfk_lib64dir=/u/jgalarow/cbtf_v2.3.1wrpms_2/lib64

monitor_libdir=/u/jgalarow/krellroot_v2.3.1wrpms/lib64
libmonitor="${monitor_libdir}/libmonitor.so"
echo "ldd $libmonitor"
/usr/bin/ldd $libmonitor

papi_libdir=/u/jgalarow/krellroot_v2.3.1wrpms/lib64
libpapi="${papi_libdir}/libpapi.so"
libpfm="${papi_libdir}/libpfm.so"
echo "ldd $libpapi"
/usr/bin/ldd $libpapi
echo "ldd $libpfm"
/usr/bin/ldd $libpfm

libunwind_libdir=/u/jgalarow/krellroot_v2.3.1wrpms/lib64
libunwind="${libunwind_libdir}/libunwind.so"
echo "ldd $libunwind"
/usr/bin/ldd $libunwind

## testing for libiomp alone is likely not enough.  We need
## a libiomp with ompt api support.  Maybe add test for ompt.h
## in addition to libiomp5.so to be certain. Of course the
## existance of the ompt_service so below would likely ensure that
## at least when the ctf-krell services where built ompt.h
## was found.  But checking at runtime may be safest.
libiomp_prefix=/u/jgalarow/krellroot_v2.3.1wrpms/ompt
libiomp_libdir=
libiomp=
use_ompt="false"
if test -f ${libiomp_prefix}/${machlibdir}/libiomp5.so; then
  use_ompt="true"
  libiomp_libdir="${libiomp_prefix}/${machlibdir}"
  libiomp="${libiomp_prefix}/${machlibdir}/libiomp5.so"
elif test -f ${libiomp_prefix}/${altmachlibdir}/libiomp5.so; then
  use_ompt="true"
  libiomp_libdir="${libiomp_prefix}/${altmachlibdir}"
  libiomp="${libiomp_prefix}/${altmachlibdir}/libiomp5.so"
fi
echo "ldd $libiomp"
/usr/bin/ldd $libiomp

libmrnet_libdir=/u/jgalarow/krellroot_v2.3.1wrpms/lib64
libmrnet="${libmrnet_libdir}/libmrnet_lightweight.so"
libxplat="${libmrnet_libdir}/libxplat_lightweight.so"
echo "ldd $libmrnet"
/usr/bin/ldd $libmrnet
echo "ldd $libxplat"
/usr/bin/ldd $libxplat

cbtfk_prefix=/u/jgalarow/cbtf_v2.3.1wrpms_2
cbtfk_libdir=/u/jgalarow/cbtf_v2.3.1wrpms_2/lib64
cbtfk_bindir="${cbtfk_prefix}/bin"
cbtfk_plugins="${cbtfk_libdir}/KrellInstitute/Collectors"

binutils_service="${cbtfk_libdir}/libcbtf-services-binutils.so"
common_service="${cbtfk_libdir}/libcbtf-services-common.so"
data_service="${cbtfk_libdir}/libcbtf-services-data.so"
events_service="${cbtfk_libdir}/libcbtf-messages-events.so"
fileio_service="${cbtfk_libdir}/libcbtf-services-fileio.so"
fpe_service="${cbtfk_libdir}/libcbtf-services-fpe.so"
monitor_service="${cbtfk_libdir}/libcbtf-services-monitor.so"
mrnet_service="${cbtfk_libdir}/libcbtf-services-mrnet.so"
papi_service="${cbtfk_libdir}/libcbtf-services-papi.so"
send_service="${cbtfk_libdir}/libcbtf-services-send.so"
timer_service="${cbtfk_libdir}/libcbtf-services-timer.so"
unwind_service="${cbtfk_libdir}/libcbtf-services-unwind.so"

echo "ldd $binutils_service"
/usr/bin/ldd $binutils_service
echo "ldd $common_service"
/usr/bin/ldd $common_service
echo "ldd $data_service"
/usr/bin/ldd $data_service
echo "ldd $events_service"
/usr/bin/ldd $events_service
echo "ldd $fileio_service"
/usr/bin/ldd $fileio_service
echo "ldd $fpe_service"
/usr/bin/ldd $fpe_service
echo "ldd $monitor_service"
/usr/bin/ldd $monitor_service
echo "ldd $mrnet_service"
/usr/bin/ldd $mrnet_service
echo "ldd $papi_service"
/usr/bin/ldd $papi_service
echo "ldd $send_service"
/usr/bin/ldd $send_service
echo "ldd $timer_service"
/usr/bin/ldd $timer_service
echo "ldd $unwind_service"
/usr/bin/ldd $unwind_service

# For target fe mode of operation
offline_service="${cbtfk_libdir}/libcbtf-services-offline.so"
echo "ldd $offline_service"
/usr/bin/ldd $offline_service
base_service="${cbtfk_libdir}/libcbtf-messages-base.so"
echo "ldd $base_service"
/usr/bin/ldd $base_service
perfdata_service="${cbtfk_libdir}/libcbtf-messages-perfdata.so"
echo "ldd $perfdata_service"
/usr/bin/ldd $perfdata_service
collector_mon_mrnet_mpi_service="${cbtfk_libdir}/libcbtf-services-collector-monitor-mrnet-mpi.so"
echo "ldd $collector_mon_mrnet_mpi_service
/usr/bin/ldd $collector_mon_mrnet_mpi_service"
collector_mon_mrnet_service="${cbtfk_libdir}/libcbtf-services-collector-monitor-mrnet.so"
echo "ldd $collector_mon_mrnet_service"
/usr/bin/ldd $collector_mon_mrnet_service
collector_mon_fileio_service="${cbtfk_libdir}/libcbtf-services-collector-monitor-fileio.so"
echo "ldd $collector_mon_fileio_service"
/usr/bin/ldd $collector_mon_fileio_service
libxplat_r="${libmrnet_libdir}/libxplat_lightweight_r.so"
echo "ldd $libxplat_r"
/usr/bin/ldd $libxplat_r
libmrnet_r="${libmrnet_libdir}/libmrnet_lightweight_r.so"
echo "ldd $libmrnet_r"
/usr/bin/ldd $libmrnet_r


