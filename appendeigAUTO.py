# append eigenfunction data from another AUTO continuation run

import sys
sys.path.insert(0, '../python')
from bifDiag import bifDiag
from numpy import ones, concatenate, loadtxt, interp
import argparse

# parse command line arguments
parser = argparse.ArgumentParser(description='Merge Matlab eigenfunction data')
parser.add_argument('-i1', dest='input_name1', type=str, default='input1.dat')
parser.add_argument('-l1', dest='label1', type=int, default=1)
parser.add_argument('-i2', dest='input_name2', type=str, default='input2.dat')
parser.add_argument('-l2', dest='label2', type=int, default=1)
parser.add_argument('-o', dest='output_name', type=str, default='output1.dat')
args = parser.parse_args()

# load AUTO data
# eigenfunction comes from here, will be used as guess
b1, s1, d1 = "b."+args.input_name1, "s."+args.input_name1, "d."+args.input_name1
bd1 = bifDiag(b1,s1)
# function data comes from here
b2, s2, d2 = "b."+args.input_name2, "s."+args.input_name2, "d."+args.input_name2
bd2 = bifDiag(b2,s2)

# grid x and solution u for input 1 (eigenfunction)
x1 = bd1(args.label1).indepvararray
u1 = bd1(args.label1).toarray()
# grid x and solution u for input 2 (function)
x2 = bd2(args.label2).indepvararray
u2 = bd2(args.label2).toarray()

# construct eigenfunction
# number of variables for function
fn_vars = 4
# number of variables for eigenfunction
eig_vars = 10
# start with all ones
eigfn = ones((eig_vars,len(x2)))

# interpolate actual eigenfunction onto grid x
for i in range(eig_vars):
    uinterp = interp(x2,x1,u1[i+fn_vars,:])
    eigfn[i,:] = uinterp

# append eigenfunction to solution
output = concatenate((u2,eigfn))

# write to file
with open(args.output_name, 'w') as file:
    s = "%24.15E"*(output.shape[0]+1)
    for i in range(output.shape[1]):
        file.write(s%((x2[i],) + tuple(output[:,i]))+"\n")