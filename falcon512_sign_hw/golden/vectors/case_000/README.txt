Falcon-512 Golden Vector - case_000

Algorithm : Falcon-512 sign_dyn
logn      : 9
N         : 512
RNG label : sign 9

Golden flow:
input
  -> basis
  -> FFT
  -> Gram
  -> target
  -> ffSampling
  -> lattice reconstruction
  -> IFFT
  -> s1/s2
  -> norm check

Norm:
sqn_s1    = 14714408
sqn_s2    = 14555634
sqn_total = 29270042
bound     = 34034726
accepted  = 1
