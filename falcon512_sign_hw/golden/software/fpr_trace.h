#ifndef FALCON_FPR_TRACE_H
#define FALCON_FPR_TRACE_H

#include "inner.h"

/*
 * Trace control.
 */
void falcon_fpr_trace_begin(void);
void falcon_fpr_trace_end(void);

void falcon_fpr_trace_add(fpr a, fpr b, fpr y);
void falcon_fpr_trace_sub(fpr a, fpr b, fpr y);
void falcon_fpr_trace_mul(fpr a, fpr b, fpr y);
void falcon_fpr_trace_div(fpr a, fpr b, fpr y);
void falcon_fpr_trace_neg(fpr a, fpr y);
void falcon_fpr_trace_sqr(fpr a, fpr y);
void falcon_fpr_trace_sqrt(fpr a, fpr y);

/*
 * These wrappers call the ORIGINAL Falcon fpr operation first,
 * then record its operands and result.
 *
 * The macros are defined only AFTER these wrappers, so the calls
 * inside the wrappers still refer to the original fpr functions.
 */

static inline fpr
falcon_trace_add_wrap(fpr a, fpr b)
{
        fpr y = fpr_add(a, b);
        falcon_fpr_trace_add(a, b, y);
        return y;
}

static inline fpr
falcon_trace_sub_wrap(fpr a, fpr b)
{
        fpr y = fpr_sub(a, b);
        falcon_fpr_trace_sub(a, b, y);
        return y;
}

static inline fpr
falcon_trace_mul_wrap(fpr a, fpr b)
{
        fpr y = fpr_mul(a, b);
        falcon_fpr_trace_mul(a, b, y);
        return y;
}

static inline fpr
falcon_trace_div_wrap(fpr a, fpr b)
{
        fpr y = fpr_div(a, b);
        falcon_fpr_trace_div(a, b, y);
        return y;
}

static inline fpr
falcon_trace_neg_wrap(fpr a)
{
        fpr y = fpr_neg(a);
        falcon_fpr_trace_neg(a, y);
        return y;
}

static inline fpr
falcon_trace_sqr_wrap(fpr a)
{
        fpr y = fpr_sqr(a);
        falcon_fpr_trace_sqr(a, y);
        return y;
}

static inline fpr
falcon_trace_sqrt_wrap(fpr a)
{
        fpr y = fpr_sqrt(a);
        falcon_fpr_trace_sqrt(a, y);
        return y;
}

/*
 * fpr_inv(), fpr_half() and fpr_double() map onto the physical
 * DIV / MUL / ADD resources which the RTL will use.
 */
static inline fpr
falcon_trace_inv_wrap(fpr a)
{
        fpr one = FPR(1.0);
        fpr y = fpr_inv(a);

        falcon_fpr_trace_div(one, a, y);
        return y;
}

static inline fpr
falcon_trace_half_wrap(fpr a)
{
        fpr half = FPR(0.5);
        fpr y = fpr_half(a);

        falcon_fpr_trace_mul(a, half, y);
        return y;
}

static inline fpr
falcon_trace_double_wrap(fpr a)
{
        fpr y = fpr_double(a);

        falcon_fpr_trace_add(a, a, y);
        return y;
}

#define fpr_add(a, b)    falcon_trace_add_wrap((a), (b))
#define fpr_sub(a, b)    falcon_trace_sub_wrap((a), (b))
#define fpr_mul(a, b)    falcon_trace_mul_wrap((a), (b))
#define fpr_div(a, b)    falcon_trace_div_wrap((a), (b))
#define fpr_neg(a)       falcon_trace_neg_wrap((a))
#define fpr_sqr(a)       falcon_trace_sqr_wrap((a))
#define fpr_sqrt(a)      falcon_trace_sqrt_wrap((a))

#define fpr_inv(a)       falcon_trace_inv_wrap((a))
#define fpr_half(a)      falcon_trace_half_wrap((a))
#define fpr_double(a)    falcon_trace_double_wrap((a))

#endif
