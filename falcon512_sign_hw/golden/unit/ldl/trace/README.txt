Falcon-512 LDL Trace Golden

Source:
Falcon-512 sign_dyn case_000

Configuration:
logn = 9
N    = 512
FALCON_AVX2 = 0
FALCON_FPNATIVE = 1

Traced operations:

1. poly_LDL_fft
   calls  = 511
   values = 4608

2. poly_LDLmv_fft
   calls  = 0
   values = 0

Reason:
The sign_dyn dynamic sampling path uses poly_LDL_fft()
at every internal node of ffSampling_fft_dyntree().

For logn = 9:
internal nodes = 2^9 - 1 = 511

Total processed LDL values:
9 * 512 = 4608

Directory format:

ldl/
  g00.memh
  g01.memh
  g11.memh
  l10.memh
  d11.memh
  calls.csv

ldlmv/
  g00.memh
  g01.memh
  g11.memh
  l10.memh
  d11.memh
  calls.csv

calls.csv format:
call,logn,n,value_offset

Data format:
IEEE-754 binary64 raw bits
16 hexadecimal characters per value.

LDL trace sizes:

g00.memh = 4608 lines
g01.memh = 4608 lines
g11.memh = 4608 lines
l10.memh = 4608 lines
d11.memh = 4608 lines

Total LDL MEMH lines = 23040

LDLmv files contain zero data lines because poly_LDLmv_fft()
is not used by the sign_dyn dynamic sampling path.

Golden final norm:

sqn_s1    = 14714408
sqn_s2    = 14555634
sqn_total = 29270042
bound     = 34034726
accepted  = 1
