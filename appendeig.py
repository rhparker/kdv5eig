# append eigenfunction data from Matlab

import sys
sys.path.insert(0, '../python')
from bifDiag import bifDiag
from numpy import ones, concatenate, loadtxt, interp
import argparse

# parse command line arguments
parser = argparse.ArgumentParser(description='Merge Matlab eigenfunction data')
parser.add_argument('-i', dest='input_name', type=str, default='input.dat')
parser.add_argument('-o', dest='output_name', type=str, default='output.dat')
parser.add_argument('-l', dest='label', type=int, default=1)
args = parser.parse_args()

# load AUTO data
bname, sname, dname = "fort.7", "fort.8", "fort.9"
bd = bifDiag(bname,sname)

# get grid x and solution u
x = bd(args.label).indepvararray
u = bd(args.label).toarray()

# construct eigenfunction
# number of variables for function
fn_vars = 4
# number of variables for eigenfunction
eig_vars = 10
# start with all ones
eigfn = ones((eig_vars,len(x)))

# load Matlab output
try:
    data = loadtxt(args.input_name)
except OSError:
    print("File {} not found".format(args.input_name))
    sys.exit(1)

# interpolate Matlab eigenfunction onto grid x
xold = data[:,0]
for i in range(eig_vars):
    uinterp = interp(x,xold,data[:,i+fn_vars+1])
    eigfn[i,:] = uinterp

# append eigenfunction to solution
output = concatenate((u,eigfn))

# write to file
with open(args.output_name, 'w') as file:
    s = "%24.15E"*(output.shape[0]+1)
    for i in range(output.shape[1]):
        file.write(s%((x[i],) + tuple(output[:,i]))+"\n")