Falcon-512 Split/Merge Trace Golden

Source:
Falcon-512 sign_dyn case_000

Configuration:
logn = 9
N    = 512
FALCON_AVX2 = 0
FALCON_FPNATIVE = 1

Functions:
Zf(poly_split_fft)
Zf(poly_merge_fft)

Trace counts:
split = 2044
merge = 1022

Split values:
input  = 18432
out0   = 9216
out1   = 9216

Merge values:
in0      = 4608
in1      = 4608
expected = 9216

Files:

split/
  input.memh
  out0.memh
  out1.memh
  calls.csv

merge/
  in0.memh
  in1.memh
  expected.memh
  calls.csv

calls.csv stores:
call index
logn
N
input offset
output offset

Data format:
IEEE-754 binary64 raw bits

Golden final norm:
sqn_s1    = 14714408
sqn_s2    = 14555634
sqn_total = 29270042
bound     = 34034726
accepted  = 1
