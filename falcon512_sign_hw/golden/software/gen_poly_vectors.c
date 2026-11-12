#include "inner.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#define MAX_LOGN   9
#define MAX_N      (1u << MAX_LOGN)

static uint64_t
raw_fpr(fpr x)
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

static void
write_fpr(const char *name, const fpr *a, size_t n)
{
        FILE *fp;
        size_t u;

        fp = open_out(name);

        for (u = 0; u < n; u ++) {
                fprintf(fp, "%016llx\n",
                        (unsigned long long)raw_fpr(a[u]));
        }

        fclose(fp);
}

static fpr
make_a(unsigned cid, size_t u)
{
        int v;
        double x;

        v = (int)((7 * u + 3 * cid) % 37) - 18;
        x = (double)v;

        switch ((u + cid) & 3) {
        case 0:
                x += 0.0;
                break;
        case 1:
                x += 0.125;
                break;
        case 2:
                x += 0.25;
                break;
        default:
                x += 0.5;
                break;
        }

        if (((u + cid) & 1) != 0) {
                x = -x;
        }

        return FPR(x);
}

static fpr
make_b(unsigned cid, size_t u)
{
        int v;
        double x;

        v = (int)((11 * u + 5 * cid + 1) % 41) - 20;
        x = (double)v;

        switch ((u + 2 * cid) & 3) {
        case 0:
                x += 0.0;
                break;
        case 1:
                x += 0.25;
                break;
        case 2:
                x += 0.5;
                break;
        default:
                x += 0.75;
                break;
        }

        if (((u + cid) & 2) != 0) {
                x = -x;
        }

        return FPR(x);
}

static fpr
make_const(unsigned cid)
{
        static const double tab[9] = {
                -2.0,
                -1.5,
                -0.5,
                 0.25,
                 0.5,
                 1.0,
                 1.5,
                 2.0,
                 3.125
        };

        return FPR(tab[cid]);
}

static void
make_dir(const char *op, unsigned cid, char *dir, size_t len)
{
        snprintf(dir, len,
                "../unit/poly/directed/%s/case_%03u",
                op, cid);

        (void)mkdir(dir, 0777);
}

static void
write_meta(const char *dir, unsigned cid,
        unsigned logn, size_t n)
{
        char path[512];
        FILE *fp;

        snprintf(path, sizeof path, "%s/meta.txt", dir);
        fp = open_out(path);

        fprintf(fp, "case=%u\n", cid);
        fprintf(fp, "logn=%u\n", logn);
        fprintf(fp, "n=%zu\n", n);

        fclose(fp);
}

static void
write_binary_case(const char *op,
        unsigned cid, unsigned logn,
        const fpr *a, const fpr *b,
        const fpr *expected, size_t n)
{
        char dir[256];
        char path[512];

        make_dir(op, cid, dir, sizeof dir);

        snprintf(path, sizeof path, "%s/a.memh", dir);
        write_fpr(path, a, n);

        snprintf(path, sizeof path, "%s/b.memh", dir);
        write_fpr(path, b, n);

        snprintf(path, sizeof path, "%s/expected.memh", dir);
        write_fpr(path, expected, n);

        write_meta(dir, cid, logn, n);
}

static void
write_unary_case(const char *op,
        unsigned cid, unsigned logn,
        const fpr *a, const fpr *expected, size_t n)
{
        char dir[256];
        char path[512];

        make_dir(op, cid, dir, sizeof dir);

        snprintf(path, sizeof path, "%s/a.memh", dir);
        write_fpr(path, a, n);

        snprintf(path, sizeof path, "%s/expected.memh", dir);
        write_fpr(path, expected, n);

        write_meta(dir, cid, logn, n);
}

static void
make_case(unsigned cid, unsigned logn)
{
        fpr a[MAX_N];
        fpr b[MAX_N];
        fpr out[MAX_N];
        fpr c;

        size_t n;
        size_t u;

        char dir[256];
        char path[512];
        FILE *fp;

        n = (size_t)1 << logn;

        for (u = 0; u < n; u ++) {
                a[u] = make_a(cid, u);
                b[u] = make_b(cid, u);
        }

        /*
         * ADD
         */
        memcpy(out, a, n * sizeof *out);
        Zf(poly_add)(out, b, logn);
        write_binary_case("add", cid, logn,
                a, b, out, n);

        /*
         * SUB
         */
        memcpy(out, a, n * sizeof *out);
        Zf(poly_sub)(out, b, logn);
        write_binary_case("sub", cid, logn,
                a, b, out, n);

        /*
         * NEG
         */
        memcpy(out, a, n * sizeof *out);
        Zf(poly_neg)(out, logn);
        write_unary_case("neg", cid, logn,
                a, out, n);

        /*
         * MUL
         */
        memcpy(out, a, n * sizeof *out);
        Zf(poly_mul_fft)(out, b, logn);
        write_binary_case("mul", cid, logn,
                a, b, out, n);

        /*
         * MULADJ
         */
        memcpy(out, a, n * sizeof *out);
        Zf(poly_muladj_fft)(out, b, logn);
        write_binary_case("muladj", cid, logn,
                a, b, out, n);

        /*
         * MULSELFADJ
         */
        memcpy(out, a, n * sizeof *out);
        Zf(poly_mulselfadj_fft)(out, logn);
        write_unary_case("mulselfadj", cid, logn,
                a, out, n);

        /*
         * MULCONST
         */
        c = make_const(cid);

        memcpy(out, a, n * sizeof *out);
        Zf(poly_mulconst)(out, c, logn);

        make_dir("mulconst", cid, dir, sizeof dir);

        snprintf(path, sizeof path, "%s/a.memh", dir);
        write_fpr(path, a, n);

        snprintf(path, sizeof path, "%s/constant.memh", dir);
        write_fpr(path, &c, 1);

        snprintf(path, sizeof path, "%s/expected.memh", dir);
        write_fpr(path, out, n);

        snprintf(path, sizeof path, "%s/meta.txt", dir);
        fp = open_out(path);

        fprintf(fp, "case=%u\n", cid);
        fprintf(fp, "logn=%u\n", logn);
        fprintf(fp, "n=%zu\n", n);

        fclose(fp);

        printf("[OK] case_%03u : logn=%u N=%zu\n",
                cid, logn, n);
}

int
main(void)
{
        unsigned logn;
        unsigned cid;

        cid = 0;

        for (logn = 1; logn <= MAX_LOGN; logn ++) {
                make_case(cid, logn);
                cid ++;
        }

        printf("\n");
        printf("Polynomial Directed Golden completed.\n");
        printf("Cases per operation = %u\n", cid);
        printf("Operations = 7\n");

        return 0;
}