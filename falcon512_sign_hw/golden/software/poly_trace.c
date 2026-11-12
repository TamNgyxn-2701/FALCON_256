#include "poly_trace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int trace_enabled = 0;

static const char *op_name[FALCON_POLY_COUNT] = {
        "add",
        "sub",
        "neg",
        "mul",
        "muladj",
        "mulselfadj",
        "mulconst"
};

/*
 * 0 = unary
 * 1 = binary
 * 2 = mulconst
 */
static const int op_type[FALCON_POLY_COUNT] = {
        1,  /* add */
        1,  /* sub */
        0,  /* neg */
        1,  /* mul */
        1,  /* muladj */
        0,  /* mulselfadj */
        2   /* mulconst */
};

static FILE *fp_a[FALCON_POLY_COUNT];
static FILE *fp_b[FALCON_POLY_COUNT];
static FILE *fp_out[FALCON_POLY_COUNT];
static FILE *fp_calls[FALCON_POLY_COUNT];

static FILE *fp_constant;

static unsigned long long call_count[FALCON_POLY_COUNT];
static unsigned long long value_offset[FALCON_POLY_COUNT];
static unsigned long long constant_count;

static uint64_t
raw_fpr(fpr x)
{
        uint64_t r;

        memcpy(&r, &x, sizeof r);
        return r;
}

static FILE *
open_file(const char *name)
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
write_vec(FILE *fp, const fpr *a, size_t n)
{
        size_t u;

        for (u = 0; u < n; u ++) {
                fprintf(fp, "%016llx\n",
                        (unsigned long long)raw_fpr(a[u]));
        }
}

void
falcon_poly_trace_begin(void)
{
        int op;
        char path[512];

        for (op = 0; op < FALCON_POLY_COUNT; op ++) {

                snprintf(path, sizeof path,
                        "../unit/poly/trace/%s/a.memh",
                        op_name[op]);
                fp_a[op] = open_file(path);

                fp_b[op] = NULL;

                if (op_type[op] == 1) {
                        snprintf(path, sizeof path,
                                "../unit/poly/trace/%s/b.memh",
                                op_name[op]);
                        fp_b[op] = open_file(path);
                }

                snprintf(path, sizeof path,
                        "../unit/poly/trace/%s/expected.memh",
                        op_name[op]);
                fp_out[op] = open_file(path);

                snprintf(path, sizeof path,
                        "../unit/poly/trace/%s/calls.csv",
                        op_name[op]);
                fp_calls[op] = open_file(path);

                fprintf(fp_calls[op],
                        "call,logn,n,value_offset\n");

                call_count[op] = 0;
                value_offset[op] = 0;
        }

        fp_constant =
                open_file("../unit/poly/trace/mulconst/constant.memh");

        constant_count = 0;
        trace_enabled = 1;
}

void
falcon_poly_trace_binary_in(
        int op,
        const fpr *a,
        const fpr *b,
        unsigned logn)
{
        size_t n;

        if (!trace_enabled) {
                return;
        }

        if (op < 0 || op >= FALCON_POLY_COUNT) {
                return;
        }

        n = (size_t)1 << logn;

        write_vec(fp_a[op], a, n);
        write_vec(fp_b[op], b, n);
}

void
falcon_poly_trace_unary_in(
        int op,
        const fpr *a,
        unsigned logn)
{
        size_t n;

        if (!trace_enabled) {
                return;
        }

        if (op < 0 || op >= FALCON_POLY_COUNT) {
                return;
        }

        n = (size_t)1 << logn;

        write_vec(fp_a[op], a, n);
}

void
falcon_poly_trace_mulconst_in(
        const fpr *a,
        fpr constant,
        unsigned logn)
{
        size_t n;

        if (!trace_enabled) {
                return;
        }

        n = (size_t)1 << logn;

        write_vec(fp_a[FALCON_POLY_MULCONST], a, n);

        fprintf(fp_constant, "%016llx\n",
                (unsigned long long)raw_fpr(constant));

        constant_count ++;
}

void
falcon_poly_trace_out(
        int op,
        const fpr *out,
        unsigned logn)
{
        size_t n;

        if (!trace_enabled) {
                return;
        }

        if (op < 0 || op >= FALCON_POLY_COUNT) {
                return;
        }

        n = (size_t)1 << logn;

        write_vec(fp_out[op], out, n);

        fprintf(fp_calls[op],
                "%llu,%u,%zu,%llu\n",
                call_count[op],
                logn,
                n,
                value_offset[op]);

        value_offset[op] += n;
        call_count[op] ++;
}

void
falcon_poly_trace_end(void)
{
        int op;
        FILE *fp;

        if (!trace_enabled) {
                return;
        }

        trace_enabled = 0;

        for (op = 0; op < FALCON_POLY_COUNT; op ++) {
                fclose(fp_a[op]);

                if (fp_b[op] != NULL) {
                        fclose(fp_b[op]);
                }

                fclose(fp_out[op]);
                fclose(fp_calls[op]);
        }

        fclose(fp_constant);

        fp = open_file("../unit/poly/trace/counts.txt");

        fprintf(fp, "add_calls=%llu\n",
                call_count[FALCON_POLY_ADD]);
        fprintf(fp, "add_values=%llu\n",
                value_offset[FALCON_POLY_ADD]);

        fprintf(fp, "sub_calls=%llu\n",
                call_count[FALCON_POLY_SUB]);
        fprintf(fp, "sub_values=%llu\n",
                value_offset[FALCON_POLY_SUB]);

        fprintf(fp, "neg_calls=%llu\n",
                call_count[FALCON_POLY_NEG]);
        fprintf(fp, "neg_values=%llu\n",
                value_offset[FALCON_POLY_NEG]);

        fprintf(fp, "mul_calls=%llu\n",
                call_count[FALCON_POLY_MUL]);
        fprintf(fp, "mul_values=%llu\n",
                value_offset[FALCON_POLY_MUL]);

        fprintf(fp, "muladj_calls=%llu\n",
                call_count[FALCON_POLY_MULADJ]);
        fprintf(fp, "muladj_values=%llu\n",
                value_offset[FALCON_POLY_MULADJ]);

        fprintf(fp, "mulselfadj_calls=%llu\n",
                call_count[FALCON_POLY_MULSELFADJ]);
        fprintf(fp, "mulselfadj_values=%llu\n",
                value_offset[FALCON_POLY_MULSELFADJ]);

        fprintf(fp, "mulconst_calls=%llu\n",
                call_count[FALCON_POLY_MULCONST]);
        fprintf(fp, "mulconst_values=%llu\n",
                value_offset[FALCON_POLY_MULCONST]);

        fprintf(fp, "mulconst_constants=%llu\n",
                constant_count);

        fclose(fp);
}
