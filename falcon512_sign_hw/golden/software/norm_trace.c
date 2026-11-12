#include "norm_trace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

static int trace_enabled;

static FILE *fp_s1;
static FILE *fp_s2;

static FILE *fp_s1_square;
static FILE *fp_s2_square;

static FILE *fp_running_s1;
static FILE *fp_running_s2;
static FILE *fp_running_total;

static FILE *fp_sqn_s1;
static FILE *fp_sqn_s2;
static FILE *fp_sqn_total;
static FILE *fp_bound;
static FILE *fp_accept;

static unsigned long long s1_values;
static unsigned long long s2_values;

static FILE *
open_out(const char *name)
{
        FILE *fp;

        fp = fopen(name, "w");

        if (fp == NULL) {
                perror(name);
                exit(EXIT_FAILURE);
        }

        return fp;
}

void
falcon_norm_trace_begin(void)
{
        fp_s1 = open_out(
                "../unit/norm/trace/s1.memh");

        fp_s2 = open_out(
                "../unit/norm/trace/s2.memh");

        fp_s1_square = open_out(
                "../unit/norm/trace/s1_square.memh");

        fp_s2_square = open_out(
                "../unit/norm/trace/s2_square.memh");

        fp_running_s1 = open_out(
                "../unit/norm/trace/running_s1.memh");

        fp_running_s2 = open_out(
                "../unit/norm/trace/running_s2.memh");

        fp_running_total = open_out(
                "../unit/norm/trace/running_total.memh");

        fp_sqn_s1 = open_out(
                "../unit/norm/trace/sqn_s1.memh");

        fp_sqn_s2 = open_out(
                "../unit/norm/trace/sqn_s2.memh");

        fp_sqn_total = open_out(
                "../unit/norm/trace/sqn_total.memh");

        fp_bound = open_out(
                "../unit/norm/trace/bound.memh");

        fp_accept = open_out(
                "../unit/norm/trace/expected_accept.memh");

        s1_values = 0;
        s2_values = 0;

        trace_enabled = 1;
}

void
falcon_norm_trace_s1_step(
        size_t index,
        int32_t z,
        uint32_t square,
        uint32_t running_s1)
{
        (void)index;

        if (!trace_enabled) {
                return;
        }

        fprintf(fp_s1,
                "%04x\n",
                (uint16_t)z);

        fprintf(fp_s1_square,
                "%08x\n",
                square);

        fprintf(fp_running_s1,
                "%08x\n",
                running_s1);

        s1_values ++;
}

void
falcon_norm_trace_s2_step(
        size_t index,
        int32_t z,
        uint32_t square,
        uint32_t running_s2,
        uint32_t running_total)
{
        (void)index;

        if (!trace_enabled) {
                return;
        }

        fprintf(fp_s2,
                "%04x\n",
                (uint16_t)z);

        fprintf(fp_s2_square,
                "%08x\n",
                square);

        fprintf(fp_running_s2,
                "%08x\n",
                running_s2);

        fprintf(fp_running_total,
                "%08x\n",
                running_total);

        s2_values ++;
}

void
falcon_norm_trace_finish(
        uint32_t sqn_s1,
        uint32_t sqn_s2,
        uint32_t sqn_total,
        uint32_t bound,
        int accepted)
{
        FILE *fp_counts;

        if (!trace_enabled) {
                return;
        }

        fprintf(fp_sqn_s1,
                "%08x\n",
                sqn_s1);

        fprintf(fp_sqn_s2,
                "%08x\n",
                sqn_s2);

        fprintf(fp_sqn_total,
                "%08x\n",
                sqn_total);

        fprintf(fp_bound,
                "%08x\n",
                bound);

        fprintf(fp_accept,
                "%01x\n",
                accepted & 1);

        fclose(fp_s1);
        fclose(fp_s2);

        fclose(fp_s1_square);
        fclose(fp_s2_square);

        fclose(fp_running_s1);
        fclose(fp_running_s2);
        fclose(fp_running_total);

        fclose(fp_sqn_s1);
        fclose(fp_sqn_s2);
        fclose(fp_sqn_total);
        fclose(fp_bound);
        fclose(fp_accept);

        fp_counts = open_out(
                "../unit/norm/trace/counts.txt");

        fprintf(fp_counts,
                "s1_values=%llu\n",
                s1_values);

        fprintf(fp_counts,
                "s2_values=%llu\n",
                s2_values);

        fclose(fp_counts);

        trace_enabled = 0;
}
