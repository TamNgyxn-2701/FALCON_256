Falcon-512 Conversion Trace Golden

Source:
Falcon-512 sign_dyn case_000

Configuration:
logn = 9
N    = 512

Trace counts:
INT2FPR = 11957
FPR2INT = 1024

Files:
int2fpr_in.memh
int2fpr_out.memh
fpr2int_in.memh
fpr2int_out.memh

Format:
INT2FPR input  = signed 64-bit two's complement
INT2FPR output = IEEE-754 binary64 raw bits

FPR2INT input  = IEEE-754 binary64 raw bits
FPR2INT output = signed 64-bit two's complement

Golden final norm:
sqn_s1    = 14714408
sqn_s2    = 14555634
sqn_total = 29270042
bound     = 34034726
accepted  = 1
