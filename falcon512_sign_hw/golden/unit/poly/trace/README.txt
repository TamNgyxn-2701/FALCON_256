Falcon-512 Polynomial Operations Trace Golden

Source:
Falcon-512 sign_dyn case_000

Configuration:
logn = 9
N    = 512
FALCON_AVX2 = 0
FALCON_FPNATIVE = 1

Traced polynomial operations:

1. ADD
   Zf(poly_add)
   calls  = 516
   values = 7168

2. SUB
   Zf(poly_sub)
   calls  = 511
   values = 4608

3. NEG
   Zf(poly_neg)
   calls  = 4
   values = 2048

4. MUL
   Zf(poly_mul_fft)
   calls  = 517
   values = 7680

5. MULADJ
   Zf(poly_muladj_fft)
   calls  = 2
   values = 1024

6. MULSELFADJ
   Zf(poly_mulselfadj_fft)
   calls  = 4
   values = 2048

7. MULCONST
   Zf(poly_mulconst)
   calls     = 2
   values    = 1024
   constants = 2

Directory format:

add/
  a.memh
  b.memh
  expected.memh
  calls.csv

sub/
  a.memh
  b.memh
  expected.memh
  calls.csv

neg/
  a.memh
  expected.memh
  calls.csv

mul/
  a.memh
  b.memh
  expected.memh
  calls.csv

muladj/
  a.memh
  b.memh
  expected.memh
  calls.csv

mulselfadj/
  a.memh
  expected.memh
  calls.csv

mulconst/
  a.memh
  constant.memh
  expected.memh
  calls.csv

calls.csv format:
call,logn,n,value_offset

Data format:
IEEE-754 binary64 raw bits

Total MEMH data lines:
71682

Golden final norm:
sqn_s1    = 14714408
sqn_s2    = 14555634
sqn_total = 29270042
bound     = 34034726
accepted  = 1
