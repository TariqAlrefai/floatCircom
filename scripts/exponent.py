# This file generate "if"s for "i2f" circom module

f = open('./exp.gen', 'w')

for a in range(32):
    f.write("if(exp == {}){}\n".format(2**a, '{'))
    f.write("\tholder = {};\n".format(a))
    f.write("{}\n".format("}"))



    