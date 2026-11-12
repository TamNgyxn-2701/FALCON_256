#include "ldl_trace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum {
        TRACE_LDL = 0,
        TRACE_LDLMV = 1,
        TRACE_COUNT = 2
};

static const char *trace_name[TRACE_COUNT] = {
        "ldl",
        "ldlmv"
};

static int trace_enabled = 0;

static FILE *fp_g00[TRACE_COUNT];
static FILE *fp_g01[TRACE_COUNT];
static FILE *fp_g11[TRACE_COUNT];
static FILE *fp_l10[TRACE_COUNT];
static FILE *fp_d11[TRACE_COUNT];
static FILE *fp_calls[TRACE_COUNT];

static unsigned long long call_count[TRACE_COUNT];
static unsigned long long value_offset[TRACE_COUNT];

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

static void
trace_input(
        int op,
        const fpr *g00,
        const fpr *g01,
        const fpr *g11,
        unsigned logn)
{
        size_t n;

        if (!trace_enabled) {
                return;
        }

        n = (size_t)1 << logn;

        write_vec(fp_g00[op], g00, n);
        write_vec(fp_g01[op], g01, n);
        write_vec(fp_g11[op], g11, n);
}

static void
trace_output(
        int op,
        const fpr *l10,
        const fpr *d11,
        unsigned logn)
{
        size_t n;

        if (!trace_enabled) {
                return;
        }

        n = (size_t)1 << logn;

        write_vec(fp_l10[op], l10, n);
        write_vec(fp_d11[op], d11, n);

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
falcon_ldl_trace_begin(void)
{
        int op;
        char path[512];

        for (op = 0; op < TRACE_COUNT; op ++) {

                snprintf(path, sizeof path,
                        "../unit/ldl/trace/%s/g00.memh",
                        trace_name[op]);
                fp_g00[op] = open_file(path);

                snprintf(path, sizeof path,
                        "../unit/ldl/trace/%s/g01.memh",
                        trace_name[op]);
                fp_g01[op] = open_file(path);

                snprintf(path, sizeof path,
                        "../unit/ldl/trace/%s/g11.memh",
                        trace_name[op]);
                fp_g11[op] = open_file(path);

                snprintf(path, sizeof path,
                        "../unit/ldl/trace/%s/l10.memh",
                        trace_name[op]);
                fp_l10[op] = open_file(path);

                snprintf(path, sizeof path,
                        "../unit/ldl/trace/%s/d11.memh",
                        trace_name[op]);
                fp_d11[op] = open_file(path);

                snprintf(path, sizeof path,
                        "../unit/ldl/trace/%s/calls.csv",
                        trace_name[op]);
                fp_calls[op] = open_file(path);

                fprintf(fp_calls[op],
                        "call,logn,n,value_offset\n");

                call_count[op] = 0;
                value_offset[op] = 0;
        }

        trace_enabled = 1;
}

void
falcon_ldl_trace_ldl_in(
        const fpr *g00,
        const fpr *g01,
        const fpr *g11,
        unsigned logn)
{
        trace_input(
                TRACE_LDL,
                g00,
                g01,
                g11,
                logn);
}

void
falcon_ldl_trace_ldl_out(
        const fpr *l10,
        const fpr *d11,
        unsigned logn)
{
        trace_output(
                TRACE_LDL,
                l10,
                d11,
                logn);
}

void
falcon_ldl_trace_ldlmv_in(
        const fpr *g00,
        const fpr *g01,
        const fpr *g11,
        unsigned logn)
{
        trace_input(
                TRACE_LDLMV,
                g00,
                g01,
                g11,
                logn);
}

void
falcon_ldl_trace_ldlmv_out(
        const fpr *l10,
        const fpr *d11,
        unsigned logn)
{
        trace_output(
                TRACE_LDLMV,
                l10,
                d11,
                logn);
}

void
falcon_ldl_trace_end(void)
{
        int op;
        FILE *fp;

        if (!trace_enabled) {
                return;
        }

        trace_enabled = 0;

        for (op = 0; op < TRACE_COUNT; op ++) {
                fclose(fp_g00[op]);
                fclose(fp_g01[op]);
                fclose(fp_g11[op]);
                fclose(fp_l10[op]);
                fclose(fp_d11[op]);
                fclose(fp_calls[op]);
        }

        fp = open_file("../unit/ldl/trace/counts.txt");

        fprintf(fp, "ldl_calls=%llu\n",
                call_count[TRACE_LDL]);

        fprintf(fp, "ldl_values=%llu\n",
                value_offset[TRACE_LDL]);

        fprintf(fp, "ldlmv_calls=%llu\n",
                call_count[TRACE_LDLMV]);

        fprintf(fp, "ldlmv_values=%llu\n",
                value_offset[TRACE_LDLMV]);

        fclose(fp);
}
