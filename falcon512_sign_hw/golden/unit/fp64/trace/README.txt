Falcon-512 FP64 Trace Golden

Source:
Falcon-512 sign_dyn case_000

Configuration:
logn = 9
N    = 512
FALCON_FPNATIVE = 1
FALCON_FPEMU    = 0
FALCON_AVX2     = 0

Trace operation counts:
ADD  = 71680
SUB  = 76725
MUL  = 138140
DIV  = 2304
NEG  = 14079
SQR  = 9447
SQRT = 512

Format:
Each MEMH line contains one IEEE-754 binary64 raw bit pattern.

Golden final norm:
sqn_s1    = 14714408
sqn_s2    = 14555634
sqn_total = 29270042
bound     = 34034726
accepted  = 1
