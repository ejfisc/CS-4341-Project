def one():
    for i in range(0,16):
        print(f'assign b{i} = inputB[{i}] ^ mode;')

def two():
    for i in range(0,16):
        print(f'FullAdder FA{i}(inputA[{i}],b{i}, c{i}, c{i+1},sum[{i}]);')

def three():
    for i in range(0,16):
        print(f'c{i+1}', end=",")

def four():
    for i in range(16,32):
        print(f'assign sum[{i}]=sum[15];')

def five():
    for i in range(16,32):
        print(f'modulus[{i}]=modulus[{15}];')

def six():
    for i in range(15,-1,-1):
        print(f'denominator[{i}]', end="|")

def seven():
    for i in range(4,16):
        print(f'reg [15:0] Augend{i};')
        print(f'reg [15:0] Adend{i};')
        print(f'wire [15:0] Sum{i};')
        print(f'wire Carry{i};')
        print("")

def eight():
    for i in range(4,16):
        print(f'SixteenFullAdder add{i}(Augend{i},Adend{i},1\'b0,Carry{i},Sum{i});')

def nine():
    for i in range(1, 15):
        print(f'Augend{i}={{Carry{i-1}, Sum{i-1}[15], Sum{i-1}[14], Sum{i-1}[13],\n\t\t\tSum{i-1}[12], Sum{i-1}[11], Sum{i-1}[10], Sum{i-1}[9],\n\t\t\tSum{i-1}[8], Sum{i-1}[7], Sum{i-1}[6], Sum{i-1}[5],\n\t\t\tSum{i-1}[4], Sum{i-1}[3], Sum{i-1}[2], Sum{i-1}[1]}};')
        print(f'Adend{i}={{ A[{i+1}]&B[15],A[{i+1}]&B[14],A[{i+1}]&B[13], A[{i+1}]&B[12],\n\t\t\tA[{i+1}]&B[11],A[{i+1}]&B[10],A[{i+1}]&B[ 9], A[{i+1}]&B[ 8],\n\t\t\tA[{i+1}]&B[ 7],A[{i+1}]&B[ 6],A[{i+1}]&B[ 5], A[{i+1}]&B[ 4],\n\t\t\tA[{i+1}]&B[ 3],A[{i+1}]&B[ 2],A[{i+1}]&B[ 1], A[{i+1}]&B[ 0]}};')
        print("")

def ten():
    for i in range (1,15):
        print(f'C[{i}] = Sum{i-1}[0];')
def eleven():
    for i in range (15,32):
        print(f'C[{i}] = Sum14[{i-15}];')
nine()