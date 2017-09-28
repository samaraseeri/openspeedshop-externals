#!/bin/bash


# MAIA USAGE INFORMATION
#/u/scicon/tools/doc/Maia_quickstart_guide_Jun2015.html 


# Compute node:
. /usr/share/modules/init/bash

module unload comp-intel/2013.5.192
module load ~/privatemodules/cmake-maia
module load comp-intel/2015.0.090

./install-tool --build-compiler intel --target-arch mic --runtime-only --build-autotools --krell-root-prefix /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3/compute 

./install-tool --build-compiler intel --target-arch mic --runtime-only --build-krell-root --krell-root-prefix /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3/compute 

./install-tool --build-compiler intel --target-arch mic --runtime-only --build-offline --openss-prefix /nobackupnfs2/jgalarow/maia/ossoff_v2.2.3/compute --krell-root-prefix /nobackupnfs2/jgalarow/maia/krellroot_v2.2.2/compute --with-ltdl /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3/compute

/install-tool --build-compiler intel --target-arch mic --runtime-only --build-cbtf-all --cbtf-prefix /nobackupnfs2/jgalarow/maia/cbtf_v2.2.3/compute --krell-root-prefix /nobackupnfs2/jgalarow/maia/krellroot_v2.2.2/compute --with-ltdl /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3/compute


#
# Front-end node:
#
. /usr/share/modules/init/bash
module unload comp-intel/2013.5.192
module load /home4/jgalarow/privatemodules/cmake-maia
export PATH=/nobackup/jgalarow/maia/cmake/bin:$PATH
module load comp-intel/2015.0.090


export CC=icc
export cc=icc
export CXX=icpc

./install-tool  --build-compiler intel --build-krell-root --krell-root-prefix /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3maia_intel --force-boost-build --skip-dyninst-build

./install-tool --build-compiler intel --build-offline --with-runtime-dir /nobackupnfs2/jgalarow/maia/ossoff_v2.2.3/compute --openss-prefix /nobackupnfs2/jgalarow/maia/ossoff_v2.2.3 --krell-root-prefix /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-qt3 /usr/lib64/qt3

# skip for now./install-tool --build-compiler intel --build-krell-root --krell-root-prefix /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --force-boost-build 
#./install-tool --build-compiler intel --build-krell-root --krell-root-prefix /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --skip-binutils-build --skip-libelf-build --skip-libdwarf-build --skip-libmonitor-build --skip-libunwind-build --skip-papi-build --skip-xercesc-build --skip-boost-build --skip-sqlite-build

##./install-tool --build-compiler intel --build-offline --with-runtime-dir /nobackupnfs2/jgalarow/maia/ossoff_v2.2.3/compute --openss-prefix /nobackupnfs2/jgalarow/maia/ossoff_v2.2.3 --krell-root-prefix /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-qt3 /usr/lib64/qt3

./install-tool --build-compiler intel --build-cbtf-all --runtime-target-arch mic --cbtf-prefix /nobackupnfs2/jgalarow/maia/cbtf_v2.2.3 --krell-root-prefix /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-cn-mrnet /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3/compute --with-cn-xercesc /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3/compute --with-cn-libmonitor /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3/compute --with-cn-libunwind /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3/compute --with-cn-dyninst /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3/compute --with-cn-papi /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3/compute --with-cn-cbtf-krell /nobackupnfs2/jgalarow/maia/cbtf_v2.2.3/compute --with-cn-cbtf /nobackupnfs2/jgalarow/maia/cbtf_v2.2.3/compute --with-binutils /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-boost /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-mrnet /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-xercesc /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-libmonitor /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-libunwind /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-dyninst /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-papi /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3

./install-tool --build-compiler intel --target-arch mic --build-onlyosscbtf --openss-prefix /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3/osscbtf_v2.2.3 --with-cn-cbtf-krell /nobackupnfs2/jgalarow/maia/cbtf_v2.2.3/compute --krell-root-prefix /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-papi /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-boost /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-mrnet /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-xercesc /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-libmonitor /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-libunwind /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-dyninst /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-libelf /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-libdwarf /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --with-binutils /nobackupnfs2/jgalarow/maia/krellroot_v2.2.3 --cbtf-prefix /nobackupnfs2/jgalarow/maia/cbtf_v2.2.3
                                                                                                             
