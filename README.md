# EvtGenTest
This repositoy is for test timing of event generation from gridpack in CERN lxplus htcondor pool.
Please find the templates below:
- `Templates/submit.jds`: for submitting FORTRAN / CPP based gridpcaks
- `Templates/submit.cuda.jds`: for submitting CUDA based gridpacks
- `Templates/evtgen.sh`: script running within submit\*.jds

## Test gridpack
`evtgen.sh` copies the gridpack from personal EOS area by xrootd protocol, which is not permitted to access from other user.
For the test purpose, I have put the example gridpack in:
```
/afs/cern.ch/work/c/choij/public/MG4GPU/gridpacks/DY3j_LO_5f_CUDA_el9_amd64_gcc12_CMSSW_14_0_9_tarball.tar.xz
```
