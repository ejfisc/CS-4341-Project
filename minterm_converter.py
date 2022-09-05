import pandas as pds
import numpy as np

#Extract Data with pandas
file = ("verilog_data.xlsx")

data = pds.read_excel(file)

pTable = data.iloc[:,1:5]
pFuncs = data.iloc[:,5:]

#Convert pandas df's to numpy arrays
table = pTable.to_numpy()
table = np.vstack(table)

funcs = pFuncs.to_numpy()
funcs = np.vstack(funcs)

rows = funcs.shape[0]
cols = funcs.shape[1]

#build "truth string" dictionairy
dict = {
    0: "w'x'y'z'",  #[0 0 0 0]
    1: "w'x'y'z",   #[0 0 0 1]
    2: "w'x'yz'",   #[0 0 1 0]
    3: "w'x'yz",    #[0 0 1 1]
    4: "w'xy'z'",   #[0 1 0 0]
    5: "w'xy'z",    #[0 1 0 1]
    6: "w'xyz'",    #[0 1 1 0]
    7: "w'xyz",     #[0 1 1 1]
    8: "wx'y'z'",   #[1 0 0 0]
    9: "wx'y'z",    #[1 0 0 1]
    10: "wx'yz'",   #[1 0 1 0]
    11: "wx'yz",    #[1 0 1 1]
    12: "wxy'z'",   #[1 1 0 0]
    13: "wxy'z",    #[1 1 0 1]
    14: "wxyz'",    #[1 1 1 0]
    15: "wxyz",     #[1 1 1 1]
}

list = []
for y in range(0, cols): #Traverse through all function columns
    output = ""
    for x in range (0,rows): #Traverse through elements (rows) of function columns
        if funcs[x,y] == 1:  #If element is 1, map to corresponding "truth string" in dict with row #
            output += (dict[x] + " + ")
    output = output[:-3]
    print("F" + str(y) + ": " + output)



