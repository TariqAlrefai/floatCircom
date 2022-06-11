
import numpy as np

I = 5

def pe(i):
    if i == 0:
        return 0
    return np.floor(np.log2(i))+1

def i2f(i):
    e = pe(i)
    E = e+127

    

print(pe(I))