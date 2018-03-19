#!/bin/bash
set -x

ossrel=2.3.1
cbtfrel=1.9.1
cbtfagrel=1.3.0
QtGraphrel=1.0.0

cd SOURCES
rm -rf cbtf-${cbtfrel}.tar.gz
rm -rf cbtf-krell-${cbtfrel}.tar.gz
rm -rf cbtf-argonavis-${cbtfrel}.tar.gz
rm -rf cbtf-lanl-${cbtfrel}.tar.gz
rm -rf openspeedshop-${ossrel}.tar.gz
rm -rf cbtf-argonavis-gui-${cbtfagrel}.tar.gz
rm -rf QtGraph-${QtGraphrel}.tar.gz

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

if test -d QtGraph-${QtGraphrel}; then
    cd QtGraph-${QtGraphrel}
    git status
    git pull
    cd ..
else
    git clone https://github.com/OpenSpeedShop/QtGraph.git
    mv QtGraph QtGraph-${QtGraphrel}
fi

tar -cf cbtf-${cbtfrel}.tar cbtf/
gzip cbtf-${cbtfrel}.tar
tar -cf cbtf-krell-${cbtfrel}.tar cbtf-krell/
gzip cbtf-krell-${cbtfrel}.tar
tar -cf cbtf-argonavis-${cbtfrel}.tar cbtf-argonavis/
gzip cbtf-argonavis-${cbtfrel}.tar
tar -cf cbtf-lanl-${cbtfrel}.tar cbtf-lanl/
gzip cbtf-lanl-${cbtfrel}.tar

tar -cf openspeedshop-${ossrel}.tar openspeedshop-${ossrel}/
gzip openspeedshop-${ossrel}.tar

tar -cf cbtf-argonavis-gui-${cbtfagrel}.tar cbtf-argonavis-gui/
gzip cbtf-argonavis-gui-${cbtfagrel}.tar

tar -cf QtGraph-${QtGraphrel}.tar QtGraph-${QtGraphrel}/
gzip QtGraph-${QtGraphrel}.tar

#rm -rf cbtf
#rm -rf cbtf-krell
#rm -rf cbtf-argonavis
#rm -rf cbtf-lanl
#rm -rf openspeedshop-${ossrel}
#rm -rf cbtf-argonavis-gui
#rm -rf QtGraph-${QtGraphrel}

