#!/bin/bash
# CPU Information
echo "CPU Information:"
lscpu

# GPU Information (assuming lspci is available)
echo "GPU Information:"
if command -v lspci &>/dev/null; then
    lspci | grep -i vga || echo "No GPU information available."
else
    echo "lspci command not found, unable to check GPU."
fi

# System Architecture
echo "System Architecture:"
uname -m

# Number of Threads
echo "Number of Threads:"
nproc

# copy gridpacks from $EOS area
export WORKDIR=`pwd`/work
mkdir $WORKDIR && cd $WORKDIR
xrdcp root://eosuser.cern.ch//eos/user/c/choij/public/Archive/madgraph4gpu/gridpacks/DY01234j_LO_5f_MULTIBACKEND_el8_amd64_gcc12_CMSSW_14_0_9_tarball.tar.xz $WORKDIR

tar xf DY01234j_LO_5f_MULTIBACKEND_el8_amd64_gcc12_CMSSW_14_0_9_tarball.tar.xz

# preload CMSSW
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh
export SCRAM_ARCH=el8_amd64_gcc12
scramv1 project CMSSW CMSSW_14_0_9
cd CMSSW_14_0_9/src
eval `scramv1 runtime -sh`
cd -

#echo ""
#echo "Generating events with single iteration"
rm runcmsgrid.sh
xrdcp root://eosuser.cern.ch//eos/user/c/choij/public/Archive/madgraph4gpu/patches/runcmsgrid.multibackend.sh runcmsgrid.sh
chmod 755 runcmsgrid.sh
time strace -k -T -o evtgen.log ./runcmsgrid.sh 10000 1  1 cpp512y

# back to $EOS
xrdcp evtgen.log root://eosuser.cern.ch//eos/user/c/choij/public/Archive/madgraph4gpu/condor/DY01234j_LO_5f.cpp512y.evtgen.10000.log
