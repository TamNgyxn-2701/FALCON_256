#include "inner.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int trace_enabled = 0;

static FILE *split_input;
static FILE *split_out0;
static FILE *split_out1;
static FILE *split_calls;

static FILE *merge_in0;
static FILE *merge_in1;
static FILE *merge_output;
static FILE *merge_calls;

static unsigned long long split_count;
static unsigned long long merge_count;

static unsigned long long split_input_offset;
static unsigned long long split_output_offset;

static unsigned long long merge_input_offset;
static unsigned long long merge_output_offset;

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
write_vec(FILE *fp, const fpr *a, size_t n)
{
        size_t u;

        for (u = 0; u < n; u ++) {
                fprintf(fp, "%016llx\n",
                        (unsigned long long)raw_fpr(a[u]));
        }
}

void
falcon_split_merge_trace_begin(void)
{
        split_input =
                open_trace("../unit/split_merge/trace/split/input.memh");
        split_out0 =
                open_trace("../unit/split_merge/trace/split/out0.memh");
        split_out1 =
                open_trace("../unit/split_merge/trace/split/out1.memh");
        split_calls =
                open_trace("../unit/split_merge/trace/split/calls.csv");

        merge_in0 =
                open_trace("../unit/split_merge/trace/merge/in0.memh");
        merge_in1 =
                open_trace("../unit/split_merge/trace/merge/in1.memh");
        merge_output =
                open_trace("../unit/split_merge/trace/merge/expected.memh");
        merge_calls =
                open_trace("../unit/split_merge/trace/merge/calls.csv");

        fprintf(split_calls,
                "call,logn,n,input_offset,output_offset\n");

        fprintf(merge_calls,
                "call,logn,n,input_offset,output_offset\n");

        split_count = 0;
        merge_count = 0;

        split_input_offset = 0;
        split_output_offset = 0;

        merge_input_offset = 0;
        merge_output_offset = 0;

        trace_enabled = 1;
}

void
falcon_split_trace(
        const fpr *input,
        const fpr *out0,
        const fpr *out1,
        unsigned logn)
{
        size_t n;
        size_t hn;

        if (!trace_enabled) {
                return;
        }

        n = (size_t)1 << logn;
        hn = n >> 1;

        fprintf(split_calls,
                "%llu,%u,%zu,%llu,%llu\n",
                split_count,
                logn,
                n,
                split_input_offset,
                split_output_offset);

        write_vec(split_input, input, n);
        write_vec(split_out0, out0, hn);
        write_vec(split_out1, out1, hn);

        split_input_offset += n;
        split_output_offset += hn;

        split_count ++;
}

void
falcon_merge_trace(
        const fpr *in0,
        const fpr *in1,
        const fpr *output,
        unsigned logn)
{
        size_t n;
        size_t hn;

        if (!trace_enabled) {
                return;
        }

        n = (size_t)1 << logn;
        hn = n >> 1;

        fprintf(merge_calls,
                "%llu,%u,%zu,%llu,%llu\n",
                merge_count,
                logn,
                n,
                merge_input_offset,
                merge_output_offset);

        write_vec(merge_in0, in0, hn);
        write_vec(merge_in1, in1, hn);
        write_vec(merge_output, output, n);

        merge_input_offset += hn;
        merge_output_offset += n;

        merge_count ++;
}

void
falcon_split_merge_trace_end(void)
{
        FILE *fp;

        if (!trace_enabled) {
                return;
        }

        trace_enabled = 0;

        fclose(split_input);
        fclose(split_out0);
        fclose(split_out1);
        fclose(split_calls);

        fclose(merge_in0);
        fclose(merge_in1);
        fclose(merge_output);
        fclose(merge_calls);

        fp = fopen("../unit/split_merge/trace/counts.txt", "w");
        if (fp == NULL) {
                perror("../unit/split_merge/trace/counts.txt");
                exit(EXIT_FAILURE);
        }

        fprintf(fp, "split=%llu\n", split_count);
        fprintf(fp, "merge=%llu\n", merge_count);

        fprintf(fp, "split_input_values=%llu\n",
                split_input_offset);
        fprintf(fp, "split_output_values=%llu\n",
                split_output_offset);

        fprintf(fp, "merge_input_values=%llu\n",
                merge_input_offset);
        fprintf(fp, "merge_output_values=%llu\n",
                merge_output_offset);

        fclose(fp);
}
