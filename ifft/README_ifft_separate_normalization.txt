FALCON IFFT -- SEPARATE NORMALIZATION UNIT

Place in rtl/transform/ifft/:
  IFFT.v
  ifft_normalize_fp64.v

Keep the previously installed ifft_stage_fp64.v (unchanged).

Place in rtl/transform/tb/falcon_twiddle_index_verify/:
  run_ifft_compile_vcs.sh
  run_ifft_roundtrip_vcs.sh

Keep tb_ifft_roundtrip_golden.v from the normalized package (unchanged).

Run:
  ./run_ifft_compile_vcs.sh
  ./run_ifft_roundtrip_vcs.sh

Operation:
  IFFT stage U8 -> ... -> stage U1 -> ifft_normalize_fp64
  -> existing final output register

Only ONE normalization per output complex sample is required.
The separate module contains two combinational fp64_mul cells:
  out_re = in_re * (1/256)
  out_im = in_im * (1/256)

No change to the FFT, IFFT stage arithmetic, or pipeline latency.
IFFT parameter NORMALIZE=0 disables the unit at elaboration if required.

Compilation and numerical roundtrip must be re-run in VCS. The package is
not independently verified on the user's Synopsys VM yet.
