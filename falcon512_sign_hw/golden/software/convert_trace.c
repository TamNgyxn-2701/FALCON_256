#include "inner.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int trace_enabled = 0;

static FILE *fp_i2f_in;
static FILE *fp_i2f_out;

static FILE *fp_f2i_in;
static FILE *fp_f2i_out;

static unsigned long long cnt_i2f;
static unsigned long long cnt_f2i;

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

void
falcon_convert_trace_begin(void)
{
        fp_i2f_in =
                open_trace("../unit/convert/trace/int2fpr_in.memh");
        fp_i2f_out =
                open_trace("../unit/convert/trace/int2fpr_out.memh");

        fp_f2i_in =
                open_trace("../unit/convert/trace/fpr2int_in.memh");
        fp_f2i_out =
                open_trace("../unit/convert/trace/fpr2int_out.memh");

        cnt_i2f = 0;
        cnt_f2i = 0;

        trace_enabled = 1;
}

void
falcon_convert_trace_int2fpr(int64_t x, fpr y)
{
        if (!trace_enabled) {
                return;
        }

        fprintf(fp_i2f_in, "%016llx\n",
                (unsigned long long)(uint64_t)x);

        fprintf(fp_i2f_out, "%016llx\n",
                (unsigned long long)raw_fpr(y));

        cnt_i2f ++;
}

void
falcon_convert_trace_fpr2int(fpr x, int64_t y)
{
        if (!trace_enabled) {
                return;
        }

        fprintf(fp_f2i_in, "%016llx\n",
                (unsigned long long)raw_fpr(x));

        fprintf(fp_f2i_out, "%016llx\n",
                (unsigned long long)(uint64_t)y);

        cnt_f2i ++;
}

void
falcon_convert_trace_end(void)
{
        FILE *fp;

        if (!trace_enabled) {
                return;
        }

        trace_enabled = 0;

        fclose(fp_i2f_in);
        fclose(fp_i2f_out);

        fclose(fp_f2i_in);
        fclose(fp_f2i_out);

        fp = fopen("../unit/convert/trace/counts.txt", "w");
        if (fp == NULL) {
                perror("../unit/convert/trace/counts.txt");
                exit(EXIT_FAILURE);
        }

        fprintf(fp, "int2fpr=%llu\n", cnt_i2f);
        fprintf(fp, "fpr2int=%llu\n", cnt_f2i);

        fclose(fp);
}
