Falcon-512 LDL Directed Golden

Reference:
Falcon Golden C

Functions:
Zf(poly_LDL_fft)
Zf(poly_LDLmv_fft)

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

Files per case:
g00.memh
g01.memh
g11.memh
l10.memh
d11.memh
meta.txt

Data format:
IEEE-754 binary64 raw bits

Notes:
poly_LDL_fft modifies g01 and g11 in place.
The resulting g01 is l10 and resulting g11 is d11.

poly_LDLmv_fft keeps the source operands unchanged and
writes l10 and d11 into separate destination arrays.

Both implementations are checked for bit-exact equality.

Totals:
18 cases
90 MEMH files
10220 MEMH data lines
