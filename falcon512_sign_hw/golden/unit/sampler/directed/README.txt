Falcon-512 SamplerZ Directed Golden

Reference:
Falcon Golden C scalar implementation
FALCON_AVX2 = 0
FALCON_FPNATIVE = 1

Components covered:

1. BaseSamp / gaussian0_sampler

Input:
  lo : 64 random bits
  hi : 8 random bits

Total random input:
  72 bits

Output:
  z0

Cases:
  64 deterministic cases

Files:
  basesamp/lo.memh
  basesamp/hi.memh
  basesamp/expected_z0.memh
  basesamp/cases.csv

2. BerExp

Inputs:
  x
  ccs
  random byte stream

Outputs / intermediate Golden:
  accept
  bytes_used
  s
  r
  threshold

Cases:
  64 deterministic cases

random_bytes.memh contains 8 bytes for each case.
Only the first bytes_used bytes are consumed by that case.

Files:
  berexp/x.memh
  berexp/ccs.memh
  berexp/random_bytes.memh
  berexp/expected_accept.memh
  berexp/bytes_used.memh
  berexp/s.memh
  berexp/r.memh
  berexp/threshold.memh
  berexp/cases.csv

Data format:
  FP values       : IEEE-754 binary64 raw hexadecimal bits
  random bytes    : 8-bit hexadecimal
  integer results : hexadecimal / CSV decimal metadata

Counts:

BaseSamp:
  64 cases
  192 MEMH lines

BerExp:
  64 cases
  960 MEMH lines

Total:
  11 MEMH files
  1152 MEMH lines
