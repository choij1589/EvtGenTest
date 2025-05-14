#!/bin/bash

PROCs=("DY4j_LO_5f_Simplified")
BACKENDs=("FORTRAN" "CPP" "CUDA")

for proc in "${PROCs[@]}"; do
	for backend in "${BACKENDs[@]}"; do
		./submit.py --name "${proc}_${backend}" --jobscript evtgen.simplified --nevt 5000
		./submit.py --name "${proc}_${backend}" --jobscript evtgen.simplified --nevt 10000
		./submit.py --name "${proc}_${backend}" --jobscript evtgen.simplified --nevt 20000
		./submit.py --name "${proc}_${backend}" --jobscript evtgen.simplified --nevt 50000
		./submit.py --name "${proc}_${backend}" --jobscript evtgen.simplified --nevt 100000
		./submit.py --name "${proc}_${backend}" --jobscript evtgen.simplified --nevt 200000
	done
done
