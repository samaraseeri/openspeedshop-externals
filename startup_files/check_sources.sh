#!/bin/bash
#set -x

ossrel=2.3
cbtfrel=1.9
cbtfagrel=1.3.0
QtGraphrel=1.0.0

cd SOURCES

if test -d cbtf; then
    cd cbtf
    echo ""
    echo "-------------------------------------"
    echo "STATUS FOR CBTF ---------------------"
    echo "-------------------------------------"
    git status
    echo "-------------------------------------"
    echo "STATUS FOR CBTF ---------------------"
    echo "-------------------------------------"
    echo ""
    cd ..
fi

if test -d cbtf-krell; then
    cd cbtf-krell/
    echo ""
    echo "-------------------------------------"
    echo "STATUS FOR CBTF KRELL----------------"
    echo "-------------------------------------"
    git status
    echo "-------------------------------------"
    echo "STATUS FOR CBTF KRELL----------------"
    echo "-------------------------------------"
    echo ""
    cd ..
fi

if test -d cbtf-argonavis; then
    cd cbtf-argonavis/
    echo ""
    echo "-------------------------------------"
    echo "STATUS FOR CBTF ARGONAVIS------------"
    echo "-------------------------------------"
    git status
    echo "-------------------------------------"
    echo "STATUS FOR CBTF ARGONAVIS------------"
    echo "-------------------------------------"
    echo ""
    cd ..
fi

if test -d cbtf-lanl; then
    cd cbtf-lanl/
    echo ""
    echo "-------------------------------------"
    echo "STATUS FOR CBTF LANL-----------------"
    echo "-------------------------------------"
    git status
    echo "-------------------------------------"
    echo "STATUS FOR CBTF LANL-----------------"
    echo "-------------------------------------"
    echo ""
    cd ..
fi

if test -d openspeedshop-$ossrel; then
    cd openspeedshop-$ossrel
    echo ""
    echo "-------------------------------------"
    echo "STATUS FOR OPENSPEEDSHOP-------------"
    echo "-------------------------------------"
    git status
    echo "-------------------------------------"
    echo "STATUS FOR OPENSPEEDSHOP-------------"
    echo "-------------------------------------"
    echo ""
    cd ..
fi

if test -d cbtf-argonavis-gui; then
    cd cbtf-argonavis-gui/
    echo ""
    echo "-------------------------------------"
    echo "STATUS FOR CBTF ARGONAVIS GUI--------"
    echo "-------------------------------------"
    git status
    echo "-------------------------------------"
    echo "STATUS FOR CBTF ARGONAVIS GUI--------"
    echo "-------------------------------------"
    echo ""
    cd ..
fi

if test -d QtGraph-${QtGraphrel}; then
    cd QtGraph-${QtGraphrel}
    echo ""
    echo "-------------------------------------"
    echo "STATUS FOR QTGRAPH-------------------"
    echo "-------------------------------------"
    git status
    echo "-------------------------------------"
    echo "STATUS FOR QTGRAPH-------------------"
    echo "-------------------------------------"
    echo ""
    cd ..
fi


