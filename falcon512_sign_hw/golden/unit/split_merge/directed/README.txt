Falcon-512 Split/Merge Directed Golden

Reference:
Falcon Golden C
Zf(poly_split_fft)
Zf(poly_merge_fft)

Configuration:
logn = 1..9
N    = 2..512

Cases:
case_000 : logn=1 N=2
case_001 : logn=2 N=4
case_002 : logn=3 N=8
case_003 : logn=4 N=16
case_004 : logn=5 N=32
case_005 : logn=6 N=64
case_006 : logn=7 N=128
case_007 : logn=8 N=256
case_008 : logn=9 N=512

SPLIT files:
input.memh = source FFT polynomial
out0.memh  = first split polynomial
out1.memh  = second split polynomial

MERGE files:
in0.memh      = first input polynomial
in1.memh      = second input polynomial
expected.memh = Falcon poly_merge_fft result

Data format:
IEEE-754 binary64 raw bits

Notes:
SPLIT -> MERGE is mathematically inverse.
For logn > 1, results are not necessarily bit-exact with the
original input because IEEE-754 floating-point operations introduce
rounding in half, multiply, add and subtract operations.

Total:
9 Split cases
9 Merge cases
54 MEMH files
4088 MEMH data lines
