#!/bin/bash
# Install parallel
#wget https://ftp.gnu.org/gnu/parallel/parallel-latest.tar.bz2
#tar -xjf parallel-latest.tar.bz2
#cd parallel-20240522
#./configure --prefix=$HOME/.local
#make -j 4
#make install
#export PATH=$HOME/.local/bin:$PATH
#cd ..

#parallel --citation

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

# Checking for Vectorization Support (SSE, AVX, etc.)
echo "Vectorization Support:"
cpu_flags=$(grep -m 1 'flags' /proc/cpuinfo | cut -d: -f2)
vector_extensions=("sse" "sse2" "sse3" "ssse3" "sse4_1" "sse4_2" "avx" "avx2" "avx512")
supported_extensions=()

for ext in "${vector_extensions[@]}"; do
    if echo "$cpu_flags" | grep -qw "$ext"; then
        supported_extensions+=("$ext")
    fi
done

if [ ${#supported_extensions[@]} -eq 0 ]; then
    echo "No known vectorization extensions supported."
else
    echo "Supported vectorization extensions: ${supported_extensions[*]}"
fi

# copy gridpacks from $EOS area
export WORKDIR=`pwd`/work
mkdir $WORKDIR && cd $WORKDIR
#xrdcp root://eosuser.cern.ch//eos/user/c/choij/public/Archive/madgraph4gpu/condor/BackUps/GridpackProduction_AUG_Week3/TT3j_CKM_LO_5f_CPP_el8_amd64_gcc12_CMSSW_14_0_9_tarball.tar.xz $WORKDIR
xrdcp root://eosuser.cern.ch//eos/user/c/choij/public/Archive/madgraph4gpu/gridpacks/TT3j_CKM_LO_5f_CPP_el8_amd64_gcc12_CMSSW_14_0_9_tarball.tar.xz $WORKDIR

tar xf TT3j_CKM_LO_5f_CPP_el8_amd64_gcc12_CMSSW_14_0_9_tarball.tar.xz

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
xrdcp root://eosuser.cern.ch//eos/user/c/choij/public/Archive/madgraph4gpu/patches/runcmsgrid.sh .
chmod 755 runcmsgrid.sh
#time strace -k -T -o evtgen.log ./runcmsgrid.sh 50000 1 1

#echo "Running with parallelized restore_data mode"
# copy parallelized restore_data
#rm process/madevent/bin/internal/restore_data
#xrdcp root://eosuser.cern.ch//eos/user/c/choij/public/Archive/madgraph4gpu/patches/restore_data process/madevent/bin/internal/restore_data
#chmod 755 process/madevent/bin/internal/restore_data
time strace -k -T -o evtgen.log ./runcmsgrid.sh 50000 1 1

# back to $EOS
xrdcp evtgen.log root://eosuser.cern.ch//eos/user/c/choij/public/Archive/madgraph4gpu/condor/TT3j_CKM_LO_5f_CPP.evtgen.50000.log
#xrdcp evtgen.paralleized_restore_data.log root://eosuser.cern.ch//eos/user/c/choij/public/Archive/madgraph4gpu/condor/TT3j_CKM_LO_5f_CPP.evtgen.50000.log
