#include "inner.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_CASES 32

static uint64_t
fpr_to_raw(fpr x)
{
        uint64_t r;

        memcpy(&r, &x, sizeof r);
        return r;
}

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

/*
 * Complex multiplication:
 *
 * (a_re + j*a_im) * (b_re + j*b_im)
 */
static void
complex_mul(
        fpr *r_re, fpr *r_im,
        fpr a_re, fpr a_im,
        fpr b_re, fpr b_im)
{
        fpr t0, t1, t2, t3;

        t0 = fpr_mul(a_re, b_re);
        t1 = fpr_mul(a_im, b_im);

        t2 = fpr_mul(a_re, b_im);
        t3 = fpr_mul(a_im, b_re);

        *r_re = fpr_sub(t0, t1);
        *r_im = fpr_add(t2, t3);
}

/*
 * Falcon FFT butterfly:
 *
 * T  = Y * W
 * O0 = X + T
 * O1 = X - T
 */
static void
bfu_fft(
        fpr x_re, fpr x_im,
        fpr y_re, fpr y_im,
        fpr w_re, fpr w_im,
        fpr *o0_re, fpr *o0_im,
        fpr *o1_re, fpr *o1_im)
{
        fpr t_re, t_im;

        complex_mul(&t_re, &t_im,
                y_re, y_im, w_re, w_im);

        *o0_re = fpr_add(x_re, t_re);
        *o0_im = fpr_add(x_im, t_im);

        *o1_re = fpr_sub(x_re, t_re);
        *o1_im = fpr_sub(x_im, t_im);
}

/*
 * Falcon IFFT butterfly:
 *
 * O0 = X + Y
 * D  = X - Y
 * O1 = D * W
 */
static void
bfu_ifft(
        fpr x_re, fpr x_im,
        fpr y_re, fpr y_im,
        fpr w_re, fpr w_im,
        fpr *o0_re, fpr *o0_im,
        fpr *o1_re, fpr *o1_im)
{
        fpr d_re, d_im;

        *o0_re = fpr_add(x_re, y_re);
        *o0_im = fpr_add(x_im, y_im);

        d_re = fpr_sub(x_re, y_re);
        d_im = fpr_sub(x_im, y_im);

        complex_mul(o1_re, o1_im,
                d_re, d_im, w_re, w_im);
}

static void
write_raw(FILE *fp, fpr x)
{
        fprintf(fp, "%016llx\n",
                (unsigned long long)fpr_to_raw(x));
}

static void
generate_mode(const char *dir, int ifft_mode)
{
        /*
         * Directed complex operands.
         */
        static const double xr[NUM_CASES] = {
             1.0,  2.0, -1.0,  0.5,
             3.0, -2.0,  4.0, -4.0,
             0.25, -0.25,  7.0, -7.0,
            10.0, -10.0, 16.0, -16.0,
             1.5, -1.5,  2.5, -2.5,
            32.0, -32.0, 64.0, -64.0,
             0.1, -0.1,  7.25, -7.25,
           123.5, -123.5, 1024.0, -1024.0
        };

        static const double xi[NUM_CASES] = {
             0.0,  1.0, -1.0, -0.5,
             2.0, -2.0, -3.0,  3.0,
             0.5, -0.5,  1.0, -1.0,
             4.0, -4.0,  8.0, -8.0,
             0.25, -0.25,  1.25, -1.25,
            10.0, -10.0, 20.0, -20.0,
             0.2, -0.2,  3.5, -3.5,
            12.25, -12.25, 128.0, -128.0
        };

        static const double yr[NUM_CASES] = {
             2.0, -1.0,  1.0, -0.5,
            -3.0,  2.0, -4.0,  4.0,
             0.75, -0.75, -6.0,  6.0,
            -8.0,  8.0, -12.0, 12.0,
            -1.5,  1.5, -2.5,  2.5,
           -24.0, 24.0, -48.0, 48.0,
             0.3, -0.3, -5.25, 5.25,
           -64.5, 64.5, -512.0, 512.0
        };

        static const double yi[NUM_CASES] = {
             1.0,  0.0, -2.0,  0.5,
            -1.0,  1.0,  2.0, -2.0,
             0.25, -0.25, -3.0,  3.0,
            -2.0,  2.0, -6.0,  6.0,
            -0.75, 0.75, -1.5,  1.5,
            -8.0,  8.0, -16.0, 16.0,
             0.4, -0.4, -2.25, 2.25,
           -10.5, 10.5, -64.0, 64.0
        };

        /*
         * Twiddle-like values used by FFT butterflies.
         */
        static const double wr[8] = {
             1.0000000000000000,
             0.0000000000000000,
             0.7071067811865476,
             0.9238795325112867,
             0.3826834323650898,
            -0.7071067811865476,
            -0.9238795325112867,
            -0.3826834323650898
        };

        static const double wi[8] = {
             0.0000000000000000,
             1.0000000000000000,
             0.7071067811865476,
             0.3826834323650898,
             0.9238795325112867,
             0.7071067811865476,
             0.3826834323650898,
             0.9238795325112867
        };

        char path[256];

        FILE *fxr, *fxi;
        FILE *fyr, *fyi;
        FILE *fwr, *fwi;
        FILE *fo0r, *fo0i;
        FILE *fo1r, *fo1i;

        size_t u;

#define OPEN_FILE(VAR, NAME) \
        do { \
                snprintf(path, sizeof path, \
                        "../unit/bfu/directed/%s/" NAME, dir); \
                VAR = open_out(path); \
        } while (0)

        OPEN_FILE(fxr,  "x_re.memh");
        OPEN_FILE(fxi,  "x_im.memh");

        OPEN_FILE(fyr,  "y_re.memh");
        OPEN_FILE(fyi,  "y_im.memh");

        OPEN_FILE(fwr,  "w_re.memh");
        OPEN_FILE(fwi,  "w_im.memh");

        OPEN_FILE(fo0r, "out0_re.memh");
        OPEN_FILE(fo0i, "out0_im.memh");

        OPEN_FILE(fo1r, "out1_re.memh");
        OPEN_FILE(fo1i, "out1_im.memh");

#undef OPEN_FILE

        for (u = 0; u < NUM_CASES; u ++) {
                fpr x_re, x_im;
                fpr y_re, y_im;
                fpr w_re, w_im;

                fpr o0_re, o0_im;
                fpr o1_re, o1_im;

                x_re = FPR(xr[u]);
                x_im = FPR(xi[u]);

                y_re = FPR(yr[u]);
                y_im = FPR(yi[u]);

                w_re = FPR(wr[u & 7]);

                /*
                 * IFFT uses conjugated twiddle values.
                 */
                if (ifft_mode) {
                        w_im = FPR(-wi[u & 7]);
                } else {
                        w_im = FPR(wi[u & 7]);
                }

                if (ifft_mode) {
                        bfu_ifft(
                                x_re, x_im,
                                y_re, y_im,
                                w_re, w_im,
                                &o0_re, &o0_im,
                                &o1_re, &o1_im);
                } else {
                        bfu_fft(
                                x_re, x_im,
                                y_re, y_im,
                                w_re, w_im,
                                &o0_re, &o0_im,
                                &o1_re, &o1_im);
                }

                write_raw(fxr, x_re);
                write_raw(fxi, x_im);

                write_raw(fyr, y_re);
                write_raw(fyi, y_im);

                write_raw(fwr, w_re);
                write_raw(fwi, w_im);

                write_raw(fo0r, o0_re);
                write_raw(fo0i, o0_im);

                write_raw(fo1r, o1_re);
                write_raw(fo1i, o1_im);
        }

        fclose(fxr);
        fclose(fxi);

        fclose(fyr);
        fclose(fyi);

        fclose(fwr);
        fclose(fwi);

        fclose(fo0r);
        fclose(fo0i);

        fclose(fo1r);
        fclose(fo1i);

        printf("[OK] BFU %-4s : %d cases\n",
                ifft_mode ? "IFFT" : "FFT",
                NUM_CASES);
}

int
main(void)
{
        generate_mode("fft", 0);
        generate_mode("ifft", 1);

        printf("\nBFU Directed Golden generation completed.\n");
        return 0;
}