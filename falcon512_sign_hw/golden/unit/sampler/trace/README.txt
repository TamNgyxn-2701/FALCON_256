Falcon-512 SamplerZ Trace Golden

Reference:
Falcon sign_dyn dynamic sampling
FALCON_AVX2 = 0
FALCON_FPNATIVE = 1
logn = 9
N = 512

Sampler trace results:

sampler_calls=1024
attempts=1767
basesamp_calls=1767
berexp_calls=1767
berexp_random_bytes=1775

Structure:

sampler/
  mu.memh
  isigma.memh
  sigma_min.memh
  s.memh
  r.memh
  dss.memh
  ccs.memh
  expected_z.memh
  calls.csv

attempts/
  z0.memh
  b.memh
  candidate_z.memh
  x.memh
  ccs.memh
  accept.memh
  calls.csv

basesamp/
  lo.memh
  hi.memh
  expected_z0.memh
  calls.csv

berexp/
  x.memh
  ccs.memh
  s.memh
  r.memh
  threshold.memh
  expected_accept.memh
  random_bytes.memh
  calls.csv

Counts:

Sampler:
  1024 calls

Attempts:
  1767

BaseSamp:
  1767 calls

BerExp:
  1767 calls

BerExp random bytes:
  1775 bytes

Golden norm:

sqn_s1=14714408
sqn_s2=14555634
sqn_total=29270042
bound=34034726
accepted=1
