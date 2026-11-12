Falcon-512 FP64 Directed Golden Vectors

Operations:
- ADD
- SUB
- MUL
- DIV
- NEG
- SQR
- SQRT

Number of test cases per operation: 32

Format:
- one 64-bit hexadecimal value per line
- raw fpr representation
- binary operations use:
    <op>_a.memh
    <op>_b.memh
    <op>_y.memh
- unary operations use:
    <op>_a.memh
    <op>_y.memh

Restrictions:
- no NaN
- no Inf
- no subnormal
- DIV has no zero divisor
- SQRT inputs are non-negative
