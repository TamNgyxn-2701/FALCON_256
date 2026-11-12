#include "inner.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int trace_enabled = 0;

static FILE *fft_x_re, *fft_x_im;
static FILE *fft_y_re, *fft_y_im;
static FILE *fft_w_re, *fft_w_im;
static FILE *fft_o0_re, *fft_o0_im;
static FILE *fft_o1_re, *fft_o1_im;

static FILE *ifft_x_re, *ifft_x_im;
static FILE *ifft_y_re, *ifft_y_im;
static FILE *ifft_w_re, *ifft_w_im;
static FILE *ifft_o0_re, *ifft_o0_im;
static FILE *ifft_o1_re, *ifft_o1_im;

static unsigned long long cnt_fft;
static unsigned long long cnt_ifft;

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
falcon_bfu_trace_begin(void)
{
        fft_x_re  = open_trace("../unit/bfu/trace/fft/x_re.memh");
        fft_x_im  = open_trace("../unit/bfu/trace/fft/x_im.memh");
        fft_y_re  = open_trace("../unit/bfu/trace/fft/y_re.memh");
        fft_y_im  = open_trace("../unit/bfu/trace/fft/y_im.memh");
        fft_w_re  = open_trace("../unit/bfu/trace/fft/w_re.memh");
        fft_w_im  = open_trace("../unit/bfu/trace/fft/w_im.memh");
        fft_o0_re = open_trace("../unit/bfu/trace/fft/out0_re.memh");
        fft_o0_im = open_trace("../unit/bfu/trace/fft/out0_im.memh");
        fft_o1_re = open_trace("../unit/bfu/trace/fft/out1_re.memh");
        fft_o1_im = open_trace("../unit/bfu/trace/fft/out1_im.memh");

        ifft_x_re  = open_trace("../unit/bfu/trace/ifft/x_re.memh");
        ifft_x_im  = open_trace("../unit/bfu/trace/ifft/x_im.memh");
        ifft_y_re  = open_trace("../unit/bfu/trace/ifft/y_re.memh");
        ifft_y_im  = open_trace("../unit/bfu/trace/ifft/y_im.memh");
        ifft_w_re  = open_trace("../unit/bfu/trace/ifft/w_re.memh");
        ifft_w_im  = open_trace("../unit/bfu/trace/ifft/w_im.memh");
        ifft_o0_re = open_trace("../unit/bfu/trace/ifft/out0_re.memh");
        ifft_o0_im = open_trace("../unit/bfu/trace/ifft/out0_im.memh");
        ifft_o1_re = open_trace("../unit/bfu/trace/ifft/out1_re.memh");
        ifft_o1_im = open_trace("../unit/bfu/trace/ifft/out1_im.memh");

        cnt_fft = 0;
        cnt_ifft = 0;
        trace_enabled = 1;
}

void
falcon_bfu_trace_fft(
        fpr x_re, fpr x_im,
        fpr y_re, fpr y_im,
        fpr w_re, fpr w_im,
        fpr o0_re, fpr o0_im,
        fpr o1_re, fpr o1_im)
{
        if (!trace_enabled) {
                return;
        }

        put_raw(fft_x_re, x_re);
        put_raw(fft_x_im, x_im);
        put_raw(fft_y_re, y_re);
        put_raw(fft_y_im, y_im);
        put_raw(fft_w_re, w_re);
        put_raw(fft_w_im, w_im);

        put_raw(fft_o0_re, o0_re);
        put_raw(fft_o0_im, o0_im);
        put_raw(fft_o1_re, o1_re);
        put_raw(fft_o1_im, o1_im);

        cnt_fft ++;
}

void
falcon_bfu_trace_ifft(
        fpr x_re, fpr x_im,
        fpr y_re, fpr y_im,
        fpr w_re, fpr w_im,
        fpr o0_re, fpr o0_im,
        fpr o1_re, fpr o1_im)
{
        if (!trace_enabled) {
                return;
        }

        put_raw(ifft_x_re, x_re);
        put_raw(ifft_x_im, x_im);
        put_raw(ifft_y_re, y_re);
        put_raw(ifft_y_im, y_im);
        put_raw(ifft_w_re, w_re);
        put_raw(ifft_w_im, w_im);

        put_raw(ifft_o0_re, o0_re);
        put_raw(ifft_o0_im, o0_im);
        put_raw(ifft_o1_re, o1_re);
        put_raw(ifft_o1_im, o1_im);

        cnt_ifft ++;
}

void
falcon_bfu_trace_end(void)
{
        FILE *fp;

        if (!trace_enabled) {
                return;
        }

        trace_enabled = 0;

        fclose(fft_x_re);
        fclose(fft_x_im);
        fclose(fft_y_re);
        fclose(fft_y_im);
        fclose(fft_w_re);
        fclose(fft_w_im);
        fclose(fft_o0_re);
        fclose(fft_o0_im);
        fclose(fft_o1_re);
        fclose(fft_o1_im);

        fclose(ifft_x_re);
        fclose(ifft_x_im);
        fclose(ifft_y_re);
        fclose(ifft_y_im);
        fclose(ifft_w_re);
        fclose(ifft_w_im);
        fclose(ifft_o0_re);
        fclose(ifft_o0_im);
        fclose(ifft_o1_re);
        fclose(ifft_o1_im);

        fp = fopen("../unit/bfu/trace/counts.txt", "w");
        if (fp == NULL) {
                perror("../unit/bfu/trace/counts.txt");
                exit(EXIT_FAILURE);
        }

        fprintf(fp, "fft=%llu\n", cnt_fft);
        fprintf(fp, "ifft=%llu\n", cnt_ifft);

        fclose(fp);
}
