#ifndef FALCON_POLY_TRACE_H
#define FALCON_POLY_TRACE_H

#include "inner.h"

enum {
        FALCON_POLY_ADD = 0,
        FALCON_POLY_SUB,
        FALCON_POLY_NEG,
        FALCON_POLY_MUL,
        FALCON_POLY_MULADJ,
        FALCON_POLY_MULSELFADJ,
        FALCON_POLY_MULCONST,
        FALCON_POLY_COUNT
};

void falcon_poly_trace_begin(void);
void falcon_poly_trace_end(void);

void falcon_poly_trace_binary_in(
        int op,
        const fpr *a,
        const fpr *b,
        unsigned logn);

void falcon_poly_trace_unary_in(
        int op,
        const fpr *a,
        unsigned logn);

void falcon_poly_trace_mulconst_in(
        const fpr *a,
        fpr constant,
        unsigned logn);

void falcon_poly_trace_out(
        int op,
        const fpr *out,
        unsigned logn);

#endif
