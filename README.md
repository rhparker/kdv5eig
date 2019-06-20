# Kdv5eig

## Eigenfunction continuation for KdV5

This is a collection of AUTO and python scripts to run continuation code for double pulses of KdV5 together with eigenfunctions associated with interaction eigenvalues. Here are the steps we need to run.

Run AUTO using double pulse data from Matlab. First, we continue in dummy parameter 6 to run Newton's method using just the double pulse solution from Matlab. Input from Matlab is the text file ``auto_kdv_double.dat``. Newton's method is run for 10 steps.

```@r auto_kdv```

Run python script to append the eigenfunction data from ``auto_kdv_double.dat`` to the output from the previous step. The parameter ``-l 3`` indicates that we are taking data from Label 3 in the previous output. Output from python script is saved to ``output.dat``. As long as python can locate the AUTO python modules, this should work.

```python appendeig.py -i auto_kdv_double.dat -l 3```

Run AUTO using data from ``output.dat`` from python script. Again, continue in dummy parameter 6 to run Newton's method for 10 steps. Data is saved in ``b.auto_kdv_start``, etc.

```@r auto_kdv 1```

We can now do parameter continuation in the length parameter *L*, which is the whole point of all of this. We start at Label 10 from the previous step. All bifurcation detection is turned off for now. At Label 46 (*L* = 2.91624E+02) there is a turning point and *L* starts to decrease. Looking at a plot of the imaginary part of the eigenvalue vs. *L*, what happens here is that the Krein collision has occurred, and the continuation has switched from the interaction eigenfunction to the "essential spectrum" eigenfunction. Data is saved to ``b.auto_kdv_1``, etc.

```@r auto_kdv 2 auto_kdv_start```

At this point, we would like to continue past this turning point, but we cannot do that the way we have set things up. The first thing we will do is to continue using just the function past the turning point. We restart at Label 46 and take 50 small steps, which should be enough to clear the bubble. Data is saved to ``b.auto_kdv_bubble``, etc.

```@r auto_kdv 3 auto_kdv_1```

Next, we run another python script to use the eigenfunction from right before the bubble (Label 46 in ``b.auto_kdv_1``) as a guess along with the function from in or after the bubble. We will do after the bubble first, since that will work. To do that, we use Label 110 (the last one) from ``b.auto_kdv_bubble``.

```python appendeigAUTO.py -i1 auto_kdv_1 -l1 46 -i2 auto_kdv_bubble -l2 110 -o output_bubble.dat```

We take this merged data and continue in dummy variable 6 to run 10 steps of Newton's method. We have to specify the length parameter *L* from Label 110 of ``b.auto_kdv_bubble`` as PAR(3) in ``c.auto_kdv.4``. Output is in ``auto_kdv_start2``.

```@r auto_kdv 4```

Now, we can continue in *L* in the negative direction to get the other side of the Krein bubble. *L* decreases initially, but we see another turning point as *L* starts to increase, and once again continuation has switched from the interaction eigenfunction to the "essential spectrum" eigenfunction.

```@r auto_kdv 5 auto_kdv_start2```

Now that we have the outside of the Krein bubble, we will try to look inside the Krein bubble. We take the function from just inside the Krein bubble (Label 62 in ``b.auto_kdv_bubble``), and use the eigenfunction from just outside the bubble as a initial guess (Label 46 in ``b.auto_kdv_1``).

```python appendeigAUTO.py -i1 auto_kdv_1 -l1 46 -i2 auto_kdv_bubble -l2 62 -o output_bubble.dat```

Do Newton's method on this as before. Again, we have to specify the value of *L* as PAR(3) in ``c.auto_kdv.6``.

```@r auto_kdv 6```

Newton's method no longer can converge here (which should be inside the Krein bubble), so something is going on.








