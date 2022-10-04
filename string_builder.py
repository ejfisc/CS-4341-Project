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
        print(f'Augend{i}={{Carry{i-1}, Sum{i}[15], Sum{i}[14], Sum{i}[13],\nSum{i}[12], Sum{i}[11], Sum{i}[10], Sum{i}[9],\nSum{i}[8], Sum{i}[7], Sum{i}[6], Sum{i}[5],\nSum{i}[4], Sum{i}[3], Sum{i}[2], Sum{i}[1]}};')
        print(f'Adend{i}={{ A[{i}]&B[15],A[{i}]&B[14],A[{i}]&B[13], A[{i}]&B[12],\nA[{i}]&B[11],A[{i}]&B[10],A[{i}]&B[ 9], A[{i}]&B[ 8],\nA[{i}]&B[ 7],A[{i}]&B[ 6],A[{i}]&B[ 5], A[{i}]&B[ 4],\nA[{i}]&B[ 3],A[{i}]&B[ 2],A[{i}]&B[ 1], A[{i}]&B[ 0]}};')
        print("")

def ten():
    for i in range (1,15):
        print(f'C[{i}] = Sum{i-1}[0];')
def eleven():
    for i in range (15,32):
        print(f'C[{i}] = Sum14[{i-15}];')
eleven()