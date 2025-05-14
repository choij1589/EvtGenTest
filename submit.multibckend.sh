#!/bin/bash
PROCs=("DY01234j_LO_5f")
BACKENDs=("fortran" "cppavx2" "cpp512y" "cpp512z" "cuda")

for proc in "${PROCs[@]}"; do
	for backend in "${BACKENDs[@]}"; do
		./submit.py --name ${proc} --jobscript evtgen.multibackend --nevt 5000 --backend $backend
		./submit.py --name ${proc} --jobscript evtgen.multibackend --nevt 10000 --backend $backend
		./submit.py --name ${proc} --jobscript evtgen.multibackend --nevt 20000 --backend $backend
		./submit.py --name ${proc} --jobscript evtgen.multibackend --nevt 50000 --backend $backend
		./submit.py --name ${proc} --jobscript evtgen.multibackend --nevt 100000 --backend $backend
		./submit.py --name ${proc} --jobscript evtgen.multibackend --nevt 200000 --backend $backend
	done
done
