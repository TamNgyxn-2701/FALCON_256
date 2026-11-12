Falcon-512 BFU Directed Golden

Modes:
- FFT butterfly
- IFFT butterfly

Test cases:
32 cases per mode

FFT:
T  = Y * W
O0 = X + T
O1 = X - T

IFFT:
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
