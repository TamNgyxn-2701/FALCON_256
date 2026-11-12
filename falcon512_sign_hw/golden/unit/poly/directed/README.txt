Falcon-512 Polynomial Operations Directed Golden

Reference:
Falcon Golden C

Configuration:
logn = 1..9
N    = 2..512

Operations:
1. ADD
   Zf(poly_add)

2. SUB
   Zf(poly_sub)

3. NEG
   Zf(poly_neg)

4. MUL
   Zf(poly_mul_fft)

5. MULADJ
   Zf(poly_muladj_fft)

6. MULSELFADJ
   Zf(poly_mulselfadj_fft)

7. MULCONST
   Zf(poly_mulconst)

Cases:
9 cases per operation

case_000 : logn=1 N=2
case_001 : logn=2 N=4
case_002 : logn=3 N=8
case_003 : logn=4 N=16
case_004 : logn=5 N=32
case_005 : logn=6 N=64
case_006 : logn=7 N=128
case_007 : logn=8 N=256
case_008 : logn=9 N=512

Binary operation files:
a.memh
b.memh
expected.memh

Unary operation files:
a.memh
expected.memh

MULCONST files:
a.memh
constant.memh
expected.memh

Data format:
IEEE-754 binary64 raw bits

Totals:
63 cases
171 MEMH files
18405 MEMH data lines

Notes:
- MUL and MULADJ operate on Falcon FFT complex representation.
- MULSELFADJ produces a real-only FFT polynomial.
- The imaginary half of MULSELFADJ output is zero.
