## Kdv5eig
# Eigenfunction continuation for KdV5

This is a collection of AUTO and python scripts to run continuation code for double pulses of KdV5 together with eigengfunctions associated with interaction eigenvalues.

Run Auto using double pulse data from Matlab. First, we continue in dummy parameter 6 to run Newton's method using just the double pulse solution from Matlab. Input from Matlab is the text file ``auto_kdv_double.dat``. Newton's method is run for 10 steps.

```@r auto_kdv```

Next, run python script to append the eigenfunction data from ``auto_kdv_double.dat`` to the output from the previous step. The parameter ``-l 3`` indicates that we are taking data from Label 3 in the previous output.

```python appendeig.py -i auto_kdv_double.dat -l 3```
