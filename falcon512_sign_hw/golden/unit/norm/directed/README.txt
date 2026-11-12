Falcon-512 Norm Directed Golden

Reference:
Falcon is_short_half()

Configuration:
logn = 9
N    = 512
bound = 34034726

Purpose:
Verify squared L2 norm accumulation, overflow saturation,
and final Falcon-512 signature accept/reject decision.

Cases:
12 deterministic directed cases.

Important boundary cases:

case_004:
  norm = 34034725 = bound - 1
  accepted = 1

case_005:
  norm = 34034726 = bound
  accepted = 1

case_006:
  norm = 34034727 = bound + 1
  accepted = 0

Overflow cases:

case_010:
  input sqn already contains overflow bit
  expected total = FFFFFFFF
  accepted = 0

case_011:
  accumulation exceeds signed 31-bit range
  expected total = FFFFFFFF
  accepted = 0

Files per case:

  sqn_s1.memh
  s2.memh
  expected_sqn_total.memh
  bound.memh
  expected_accept.memh
  meta.txt

Data format:

sqn_s1             : 32-bit hexadecimal
s2                  : signed 16-bit two's-complement hexadecimal
expected_sqn_total : 32-bit hexadecimal
bound               : 32-bit hexadecimal
expected_accept     : 1-bit value

Counts:

cases      = 12
MEMH files = 60
MEMH lines = 6192
