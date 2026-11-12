#ifndef FALCON_BFU_TRACE_H
#define FALCON_BFU_TRACE_H

#include "inner.h"

void falcon_bfu_trace_begin(void);
void falcon_bfu_trace_end(void);

void falcon_bfu_trace_fft(
        fpr x_re, fpr x_im,
        fpr y_re, fpr y_im,
        fpr w_re, fpr w_im,
        fpr o0_re, fpr o0_im,
        fpr o1_re, fpr o1_im);

void falcon_bfu_trace_ifft(
        fpr x_re, fpr x_im,
        fpr y_re, fpr y_im,
        fpr w_re, fpr w_im,
        fpr o0_re, fpr o0_im,
        fpr o1_re, fpr o1_im);

#endif
