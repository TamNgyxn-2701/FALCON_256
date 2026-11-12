Falcon-512 FPR2INT Directed Golden

Operation:
IEEE-754 binary64 -> fpr_rint() -> signed integer

Test cases: 32

Files:
input.memh    = raw IEEE-754 binary64
expected.memh = signed 64-bit integer, two's complement

Rounding behavior:
round-to-nearest, ties-to-even

Examples:
 0.5 -> 0
 1.5 -> 2
 2.5 -> 2
 3.5 -> 4

Generated with Falcon Golden C.
