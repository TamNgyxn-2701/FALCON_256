Falcon-512 BFU Trace Golden

Source:
Falcon-512 sign_dyn case_000

Configuration:
logn = 9
N    = 512
FALCON_AVX2 = 0
FALCON_FPNATIVE = 1

Trace counts:
FFT BFU  = 9216
IFFT BFU = 2048

FFT butterfly:
T  = Y * W
O0 = X + T
O1 = X - T

IFFT butterfly:
O0 = X + Y
D  = X - Y
O1 = D * W

Data format:
IEEE-754 binary64 raw bits

Files per mode:
x_re.memh
x_im.memh
y_re.memh
y_im.memh
w_re.memh
w_im.memh
out0_re.memh
out0_im.memh
out1_re.memh
out1_im.memh

Golden final norm:
sqn_s1    = 14714408
sqn_s2    = 14555634
sqn_total = 29270042
bound     = 34034726
accepted  = 1
