#!/bin/bash
set -x

ossrel=2.3
cbtfrel=1.8.1
cbtfagrel=0.8.1

cd SOURCES
rm -rf cbtf-1.8.1.tar.gz
rm -rf cbtf-krell-1.8.1.tar.gz
rm -rf cbtf-argonavis-1.8.1.tar.gz
rm -rf cbtf-lanl-1.8.1.tar.gz
rm -rf openspeedshop-2.3.tar.gz
rm -rf cbtf-argonavis-gui-0.8.1.tar.gz

if test -d cbtf; then
    cd cbtf
    git status
    git pull
    cd ..
else
    git clone https://github.com/OpenSpeedShop/cbtf.git
fi

if test -d cbtf-krell; then
    cd cbtf-krell/
    git status
    git pull
    cd ..
else
    git clone https://github.com/OpenSpeedShop/cbtf-krell.git
fi

if test -d cbtf-argonavis; then
    cd cbtf-argonavis/
    git status
    git pull
    cd ..
else
    git clone https://github.com/OpenSpeedShop/cbtf-argonavis.git
fi

if test -d cbtf-lanl; then
    cd cbtf-lanl/
    git status
    git pull
    cd ..
else
    git clone https://github.com/OpenSpeedShop/cbtf-lanl.git
fi

if test -d openspeedshop-$ossrel; then
    cd openspeedshop-$ossrel
    git status
    git pull
    cd ..
else
    git clone https://github.com/OpenSpeedShop/openspeedshop.git
    mv openspeedshop openspeedshop-$ossrel
fi

if test -d cbtf-argonavis-gui; then
    cd cbtf-argonavis-gui/
    git status
    git pull
    cd ..
else
    git clone https://github.com/OpenSpeedShop/cbtf-argonavis-gui.git
fi


tar -cf cbtf-$cbtfrel.tar cbtf/
gzip cbtf-$cbtfrel.tar
tar -cf cbtf-krell-$cbtfrel.tar cbtf-krell/
gzip cbtf-krell-$cbtfrel.tar
tar -cf cbtf-argonavis-$cbtfrel.tar cbtf-argonavis/
gzip cbtf-argonavis-$cbtfrel.tar
tar -cf cbtf-lanl-$cbtfrel.tar cbtf-lanl/
gzip cbtf-lanl-$cbtfrel.tar

tar -cf openspeedshop-$ossrel.tar openspeedshop-$ossrel/
gzip openspeedshop-$ossrel.tar

tar -cf cbtf-argonavis-gui-$cbtfagrel.tar cbtf-argonavis-gui/
gzip cbtf-argonavis-gui-$cbtfagrel.tar

rm -rf cbtf
rm -rf cbtf-krell
rm -rf cbtf-argonavis
rm -rf cbtf-lanl
rm -rf openspeedshop-2.3
rm -rf cbtf-argonavis-gui


