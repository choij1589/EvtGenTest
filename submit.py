#!/usr/bin/python3
import os, shutil
import argparse

CONDORBASE = os.getcwd()
parser = argparse.ArgumentParser()
parser.add_argument("--name", required=True, type=str, help="name of process")
parser.add_argument("--jobscript", required=True, type=str, help="script name")
parser.add_argument("--nevt", default=1000, type=int, help="no. of evts to produce from the gridpack")
parser.add_argument("--backend", default=None, type=str, help="choose backend in multi-backend mode")
parser.add_argument("--no_exec", action="store_true", default=False, help="no submission")
parser.add_argument("--debug", action="store_true", default=False, help="debug mode")
args = parser.parse_args()
CONDORBASE = f"{args.name}-{args.jobscript.upper()}-{args.nevt}"
if args.backend:
    CONDORBASE = f"{args.name}-{args.jobscript.upper()}-{args.backend.upper()}-{args.nevt}"
try:
    os.makedirs(CONDORBASE)
except Exception as e:
    raise e

def prepareSubmitFor(process, jobscript):
    # copy submit file
    if "multibackend" in jobscript:
        submit = "submit.multibackend"
    elif "cuda" in process.lower():
        submit = "submit.cuda"
    else:
        submit = "submit"
    if args.debug:
        print(f"submit: {submit}.jds")
        print(f"jobscript: {jobscript}.sh")

    with open(f"Templates/{submit}.jds", "r") as f:
        template = f.read()
    with open(f"{CONDORBASE}/submit.jds", "w") as f:
        f.write(template.replace("[JOBSCRIPT]", jobscript).replace("[PROC]", process).replace("[BCKEND]", str(args.backend)))

    # copy jobscript
    with open(f"Templates/{jobscript}.sh", "r") as f:
        template = f.read()
    with open(f"{CONDORBASE}/{jobscript}.sh", "w") as f:
        f.write(template.replace("[PROC]", process).replace("[NEVT]", str(args.nevt)).replace("[BCKEND]", str(args.backend)))

if __name__ == "__main__":
    print(f"@@@@ submitting jobs from {CONDORBASE}...")
    print(f"@@@@ submitting {args.name}...")
    prepareSubmitFor(args.name, args.jobscript)
    if not args.no_exec:
        os.chdir(CONDORBASE)
        os.system("condor_submit submit.jds")
