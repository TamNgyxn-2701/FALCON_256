#ifndef FALCON_CONVERT_TRACE_H
#define FALCON_CONVERT_TRACE_H

#include "inner.h"

void falcon_convert_trace_begin(void);
void falcon_convert_trace_end(void);

void falcon_convert_trace_int2fpr(int64_t x, fpr y);
void falcon_convert_trace_fpr2int(fpr x, int64_t y);

/*
 * Call original Falcon functions first, then record input/output.
 */
static inline fpr
falcon_trace_fpr_of_wrap(int64_t x)
{
        fpr y;

        y = fpr_of(x);
        falcon_convert_trace_int2fpr(x, y);
        return y;
}

static inline int64_t
falcon_trace_fpr_rint_wrap(fpr x)
{
        int64_t y;

        y = fpr_rint(x);
        falcon_convert_trace_fpr2int(x, y);
        return y;
}

/*
 * Redefine only after wrapper definitions so the wrappers above
 * still call the original Falcon functions.
 */
#define fpr_of(x)    falcon_trace_fpr_of_wrap((x))
#define fpr_rint(x)  falcon_trace_fpr_rint_wrap((x))

#endif
