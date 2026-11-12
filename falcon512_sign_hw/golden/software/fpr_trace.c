#include "inner.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int trace_enabled = 0;

static FILE *fp_add_a, *fp_add_b, *fp_add_y;
static FILE *fp_sub_a, *fp_sub_b, *fp_sub_y;
static FILE *fp_mul_a, *fp_mul_b, *fp_mul_y;
static FILE *fp_div_a, *fp_div_b, *fp_div_y;

static FILE *fp_neg_a, *fp_neg_y;
static FILE *fp_sqr_a, *fp_sqr_y;
static FILE *fp_sqrt_a, *fp_sqrt_y;

static unsigned long long cnt_add;
static unsigned long long cnt_sub;
static unsigned long long cnt_mul;
static unsigned long long cnt_div;
static unsigned long long cnt_neg;
static unsigned long long cnt_sqr;
static unsigned long long cnt_sqrt;

static uint64_t
raw_fpr(fpr x)
{
        uint64_t r;

        memcpy(&r, &x, sizeof r);
        return r;
}

static FILE *
open_trace(const char *name)
{
        FILE *fp;

        fp = fopen(name, "w");
        if (fp == NULL) {
                perror(name);
                exit(EXIT_FAILURE);
        }
        return fp;
}

static void
put_raw(FILE *fp, fpr x)
{
        fprintf(fp, "%016llx\n",
                (unsigned long long)raw_fpr(x));
}

void
falcon_fpr_trace_begin(void)
{
        fp_add_a = open_trace("../unit/fp64/trace/add_a.memh");
        fp_add_b = open_trace("../unit/fp64/trace/add_b.memh");
        fp_add_y = open_trace("../unit/fp64/trace/add_y.memh");

        fp_sub_a = open_trace("../unit/fp64/trace/sub_a.memh");
        fp_sub_b = open_trace("../unit/fp64/trace/sub_b.memh");
        fp_sub_y = open_trace("../unit/fp64/trace/sub_y.memh");

        fp_mul_a = open_trace("../unit/fp64/trace/mul_a.memh");
        fp_mul_b = open_trace("../unit/fp64/trace/mul_b.memh");
        fp_mul_y = open_trace("../unit/fp64/trace/mul_y.memh");

        fp_div_a = open_trace("../unit/fp64/trace/div_a.memh");
        fp_div_b = open_trace("../unit/fp64/trace/div_b.memh");
        fp_div_y = open_trace("../unit/fp64/trace/div_y.memh");

        fp_neg_a = open_trace("../unit/fp64/trace/neg_a.memh");
        fp_neg_y = open_trace("../unit/fp64/trace/neg_y.memh");

        fp_sqr_a = open_trace("../unit/fp64/trace/sqr_a.memh");
        fp_sqr_y = open_trace("../unit/fp64/trace/sqr_y.memh");

        fp_sqrt_a = open_trace("../unit/fp64/trace/sqrt_a.memh");
        fp_sqrt_y = open_trace("../unit/fp64/trace/sqrt_y.memh");

        cnt_add = 0;
        cnt_sub = 0;
        cnt_mul = 0;
        cnt_div = 0;
        cnt_neg = 0;
        cnt_sqr = 0;
        cnt_sqrt = 0;

        trace_enabled = 1;
}

void
falcon_fpr_trace_add(fpr a, fpr b, fpr y)
{
        if (!trace_enabled) {
                return;
        }

        put_raw(fp_add_a, a);
        put_raw(fp_add_b, b);
        put_raw(fp_add_y, y);
        cnt_add ++;
}

void
falcon_fpr_trace_sub(fpr a, fpr b, fpr y)
{
        if (!trace_enabled) {
                return;
        }

        put_raw(fp_sub_a, a);
        put_raw(fp_sub_b, b);
        put_raw(fp_sub_y, y);
        cnt_sub ++;
}

void
falcon_fpr_trace_mul(fpr a, fpr b, fpr y)
{
        if (!trace_enabled) {
                return;
        }

        put_raw(fp_mul_a, a);
        put_raw(fp_mul_b, b);
        put_raw(fp_mul_y, y);
        cnt_mul ++;
}

void
falcon_fpr_trace_div(fpr a, fpr b, fpr y)
{
        if (!trace_enabled) {
                return;
        }

        put_raw(fp_div_a, a);
        put_raw(fp_div_b, b);
        put_raw(fp_div_y, y);
        cnt_div ++;
}

void
falcon_fpr_trace_neg(fpr a, fpr y)
{
        if (!trace_enabled) {
                return;
        }

        put_raw(fp_neg_a, a);
        put_raw(fp_neg_y, y);
        cnt_neg ++;
}

void
falcon_fpr_trace_sqr(fpr a, fpr y)
{
        if (!trace_enabled) {
                return;
        }

        put_raw(fp_sqr_a, a);
        put_raw(fp_sqr_y, y);
        cnt_sqr ++;
}

void
falcon_fpr_trace_sqrt(fpr a, fpr y)
{
        if (!trace_enabled) {
                return;
        }

        put_raw(fp_sqrt_a, a);
        put_raw(fp_sqrt_y, y);
        cnt_sqrt ++;
}

void
falcon_fpr_trace_end(void)
{
        FILE *fp;

        if (!trace_enabled) {
                return;
        }

        trace_enabled = 0;

        fclose(fp_add_a);
        fclose(fp_add_b);
        fclose(fp_add_y);

        fclose(fp_sub_a);
        fclose(fp_sub_b);
        fclose(fp_sub_y);

        fclose(fp_mul_a);
        fclose(fp_mul_b);
        fclose(fp_mul_y);

        fclose(fp_div_a);
        fclose(fp_div_b);
        fclose(fp_div_y);

        fclose(fp_neg_a);
        fclose(fp_neg_y);

        fclose(fp_sqr_a);
        fclose(fp_sqr_y);

        fclose(fp_sqrt_a);
        fclose(fp_sqrt_y);

        fp = fopen("../unit/fp64/trace/counts.txt", "w");
        if (fp == NULL) {
                perror("../unit/fp64/trace/counts.txt");
                exit(EXIT_FAILURE);
        }

        fprintf(fp, "add=%llu\n", cnt_add);
        fprintf(fp, "sub=%llu\n", cnt_sub);
        fprintf(fp, "mul=%llu\n", cnt_mul);
        fprintf(fp, "div=%llu\n", cnt_div);
        fprintf(fp, "neg=%llu\n", cnt_neg);
        fprintf(fp, "sqr=%llu\n", cnt_sqr);
        fprintf(fp, "sqrt=%llu\n", cnt_sqrt);

        fclose(fp);
}
