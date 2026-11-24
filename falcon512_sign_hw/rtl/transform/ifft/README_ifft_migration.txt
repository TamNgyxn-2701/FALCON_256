FALCON IFFT: FPC -> FP64 MIGRATION

RTL files (copy into rtl/transform/fft/):
  IFFT.v
  ifft_stage_fp64.v

Compilation script (copy into rtl/transform/tb/falcon_twiddle_index_verify/):
  run_ifft_compile_vcs.sh

Run:
  chmod +x run_ifft_compile_vcs.sh
  ./run_ifft_compile_vcs.sh

Changes from the supplied original IFFT RTL:
  - Preserved eight reverse-ordered stages U=8..1.
  - Preserved butterfly BEFORE complex multiplication.
  - Reused verified fft_butterfly and fft_complex_mul FP64 components.
  - Preserved the original per-stage twiddle-index schedule and controller.
  - Preserved conjugation of external GM coefficients and final output register.
  - Removed dependencies on old FPC.v / BUTTERFLY.v / RADIX2.v.

IMPORTANT:
  Compilation is NOT a Golden verification. The original IFFT RTL does not
  include Falcon IFFT normalization (divide by 256 for logn=9), and therefore
  an end-to-end inverse-Golden test must establish whether scaling or an
  external normalization block is required. Do not report IFFT PASS yet.
