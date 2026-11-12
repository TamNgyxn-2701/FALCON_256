#ifndef FALCON_SPLIT_MERGE_TRACE_H
#define FALCON_SPLIT_MERGE_TRACE_H

#include "inner.h"

void falcon_split_merge_trace_begin(void);
void falcon_split_merge_trace_end(void);

void falcon_split_trace(
        const fpr *input,
        const fpr *out0,
        const fpr *out1,
        unsigned logn);

void falcon_merge_trace(
        const fpr *in0,
        const fpr *in1,
        const fpr *output,
        unsigned logn);

#endif
