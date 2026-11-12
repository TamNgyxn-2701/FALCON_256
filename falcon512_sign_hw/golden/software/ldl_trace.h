#ifndef FALCON_LDL_TRACE_H
#define FALCON_LDL_TRACE_H

#include "inner.h"

void falcon_ldl_trace_begin(void);
void falcon_ldl_trace_end(void);

void falcon_ldl_trace_ldl_in(
        const fpr *g00,
        const fpr *g01,
        const fpr *g11,
        unsigned logn);

void falcon_ldl_trace_ldl_out(
        const fpr *l10,
        const fpr *d11,
        unsigned logn);

void falcon_ldl_trace_ldlmv_in(
        const fpr *g00,
        const fpr *g01,
        const fpr *g11,
        unsigned logn);

void falcon_ldl_trace_ldlmv_out(
        const fpr *l10,
        const fpr *d11,
        unsigned logn);

#endif
