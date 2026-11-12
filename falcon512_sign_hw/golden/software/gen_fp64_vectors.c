#include "inner.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_CASES 32

/*
 * Convert raw IEEE-754 64-bit pattern into Falcon fpr.
 * memcpy() works for both internal fpr representations.
 */
static fpr
fpr_from_raw(uint64_t raw)
{
        fpr x;

        memcpy(&x, &raw, sizeof raw);
        return x;
}

/*
 * Extract exact 64 raw bits from Falcon fpr.
 */
static uint64_t
fpr_to_raw(fpr x)
{
        uint64_t raw;

        memcpy(&raw, &x, sizeof raw);
        return raw;
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

static void
gen_binary(
        const char *name,
        fpr (*op)(fpr, fpr),
        const uint64_t *a_raw,
        const uint64_t *b_raw)
{
        char pa[256];
        char pb[256];
        char py[256];
        FILE *fa, *fb, *fy;
        size_t i;

        snprintf(pa, sizeof pa,
                "../unit/fp64/directed/%s_a.memh", name);
        snprintf(pb, sizeof pb,
                "../unit/fp64/directed/%s_b.memh", name);
        snprintf(py, sizeof py,
                "../unit/fp64/directed/%s_y.memh", name);

        fa = open_out(pa);
        fb = open_out(pb);
        fy = open_out(py);

        for (i = 0; i < NUM_CASES; i ++) {
                fpr a, b, y;

                a = fpr_from_raw(a_raw[i]);
                b = fpr_from_raw(b_raw[i]);
                y = op(a, b);

                fprintf(fa, "%016llx\n",
                        (unsigned long long)a_raw[i]);
                fprintf(fb, "%016llx\n",
                        (unsigned long long)b_raw[i]);
                fprintf(fy, "%016llx\n",
                        (unsigned long long)fpr_to_raw(y));
        }

        fclose(fa);
        fclose(fb);
        fclose(fy);

        printf("[OK] %-5s : %d cases\n", name, NUM_CASES);
}

static void
gen_unary(
        const char *name,
        fpr (*op)(fpr),
        const uint64_t *a_raw)
{
        char pa[256];
        char py[256];
        FILE *fa, *fy;
        size_t i;

        snprintf(pa, sizeof pa,
                "../unit/fp64/directed/%s_a.memh", name);
        snprintf(py, sizeof py,
                "../unit/fp64/directed/%s_y.memh", name);

        fa = open_out(pa);
        fy = open_out(py);

        for (i = 0; i < NUM_CASES; i ++) {
                fpr a, y;

                a = fpr_from_raw(a_raw[i]);
                y = op(a);

                fprintf(fa, "%016llx\n",
                        (unsigned long long)a_raw[i]);
                fprintf(fy, "%016llx\n",
                        (unsigned long long)fpr_to_raw(y));
        }

        fclose(fa);
        fclose(fy);

        printf("[OK] %-5s : %d cases\n", name, NUM_CASES);
}

static fpr op_add(fpr a, fpr b) { return fpr_add(a, b); }
static fpr op_sub(fpr a, fpr b) { return fpr_sub(a, b); }
static fpr op_mul(fpr a, fpr b) { return fpr_mul(a, b); }
static fpr op_div(fpr a, fpr b) { return fpr_div(a, b); }

static fpr op_neg(fpr a)  { return fpr_neg(a); }
static fpr op_sqr(fpr a)  { return fpr_sqr(a); }
static fpr op_sqrt(fpr a) { return fpr_sqrt(a); }

int
main(void)
{
        /*
         * All values are finite normal values or zero.
         * No NaN, Inf or subnormal values are included.
         */
        static const uint64_t a[NUM_CASES] = {
                0x0000000000000000ULL, /*  0.0 */
                0x3FF0000000000000ULL, /*  1.0 */
                0xBFF0000000000000ULL, /* -1.0 */
                0x4000000000000000ULL, /*  2.0 */
                0xC000000000000000ULL, /* -2.0 */
                0x3FE0000000000000ULL, /*  0.5 */
                0xBFE0000000000000ULL, /* -0.5 */
                0x3FD0000000000000ULL, /*  0.25 */
                0x3FF8000000000000ULL, /*  1.5 */
                0x4008000000000000ULL, /*  3.0 */
                0xC008000000000000ULL, /* -3.0 */
                0x4024000000000000ULL, /* 10.0 */
                0xC024000000000000ULL, /* -10.0 */
                0x400921FB54442D18ULL, /* pi */
                0xC00921FB54442D18ULL, /* -pi */
                0x4005BF0A8B145769ULL, /* e */
                0xC005BF0A8B145769ULL, /* -e */
                0x3FF6A09E667F3BCDULL, /* sqrt(2) */
                0xBFF6A09E667F3BCDULL, /* -sqrt(2) */
                0x4090000000000000ULL, /* 1024 */
                0xC090000000000000ULL, /* -1024 */
                0x3F50000000000000ULL, /* 2^-10 */
                0xBF50000000000000ULL, /* -2^-10 */
                0x405EE00000000000ULL, /* 123.5 */
                0xC05EE00000000000ULL, /* -123.5 */
                0x40B0000000000000ULL, /* 4096 */
                0xC0B0000000000000ULL, /* -4096 */
                0x3FB999999999999AULL, /* 0.1 */
                0xBFB999999999999AULL, /* -0.1 */
                0x401D000000000000ULL, /* 7.25 */
                0xC01D000000000000ULL, /* -7.25 */
                0x3FE8000000000000ULL  /* 0.75 */
        };

        /*
         * b[] never contains zero, so every DIV testcase is valid.
         */
        static const uint64_t b[NUM_CASES] = {
                0x3FF0000000000000ULL, /*  1.0 */
                0x4000000000000000ULL, /*  2.0 */
                0x3FE0000000000000ULL, /*  0.5 */
                0xBFF0000000000000ULL, /* -1.0 */
                0x4008000000000000ULL, /*  3.0 */
                0xC000000000000000ULL, /* -2.0 */
                0x3FD0000000000000ULL, /*  0.25 */
                0x4010000000000000ULL, /*  4.0 */
                0xBFE0000000000000ULL, /* -0.5 */
                0x3FF8000000000000ULL, /*  1.5 */
                0xBFF8000000000000ULL, /* -1.5 */
                0x3FE8000000000000ULL, /*  0.75 */
                0xBFE8000000000000ULL, /* -0.75 */
                0x4004000000000000ULL, /*  2.5 */
                0xC004000000000000ULL, /* -2.5 */
                0x4020000000000000ULL, /*  8.0 */
                0xC020000000000000ULL, /* -8.0 */
                0x3FC0000000000000ULL, /*  0.125 */
                0xBFC0000000000000ULL, /* -0.125 */
                0x4024000000000000ULL, /* 10.0 */
                0xC024000000000000ULL, /* -10.0 */
                0x3FB999999999999AULL, /*  0.1 */
                0xBFB999999999999AULL, /* -0.1 */
                0x401D000000000000ULL, /*  7.25 */
                0xC01D000000000000ULL, /* -7.25 */
                0x4030000000000000ULL, /* 16 */
                0xC030000000000000ULL, /* -16 */
                0x400921FB54442D18ULL, /* pi */
                0xC00921FB54442D18ULL, /* -pi */
                0x4005BF0A8B145769ULL, /* e */
                0xC005BF0A8B145769ULL, /* -e */
                0x3FF6A09E667F3BCDULL  /* sqrt(2) */
        };

        /*
         * sqrt() inputs must be non-negative.
         */
        static const uint64_t sqrt_a[NUM_CASES] = {
                0x0000000000000000ULL,
                0x3FF0000000000000ULL,
                0x4000000000000000ULL,
                0x4008000000000000ULL,
                0x4010000000000000ULL,
                0x4014000000000000ULL,
                0x4018000000000000ULL,
                0x401C000000000000ULL,
                0x4020000000000000ULL,
                0x4022000000000000ULL,
                0x3FE0000000000000ULL,
                0x3FD0000000000000ULL,
                0x3FC0000000000000ULL,
                0x3FB999999999999AULL,
                0x3FF8000000000000ULL,
                0x4004000000000000ULL,
                0x400921FB54442D18ULL,
                0x4005BF0A8B145769ULL,
                0x3FF6A09E667F3BCDULL,
                0x4090000000000000ULL,
                0x40B0000000000000ULL,
                0x3F50000000000000ULL,
                0x405EE00000000000ULL,
                0x401D000000000000ULL,
                0x3FE8000000000000ULL,
                0x4040000000000000ULL,
                0x4050000000000000ULL,
                0x4060000000000000ULL,
                0x4070000000000000ULL,
                0x4080000000000000ULL,
                0x3FA0000000000000ULL,
                0x3F90000000000000ULL
        };

        gen_binary("add", op_add, a, b);
        gen_binary("sub", op_sub, a, b);
        gen_binary("mul", op_mul, a, b);
        gen_binary("div", op_div, a, b);

        gen_unary("neg", op_neg, a);
        gen_unary("sqr", op_sqr, a);
        gen_unary("sqrt", op_sqrt, sqrt_a);

        printf("\nFP64 directed Golden generation completed.\n");
        return 0;
}
