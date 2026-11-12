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
make_fpr(double x)
{
        fpr r;

        r.v = x;
        return r;
}

static void
make_input(unsigned cid, unsigned logn,
        fpr *g00, fpr *g01, fpr *g11)
{
        size_t n, hn, u;

        n = (size_t)1 << logn;
        hn = n >> 1;

        for (u = 0; u < hn; u ++) {
                double a;
                double br, bi;
                double c;

                /*
                 * Hermitian / positive-like deterministic matrix.
                 *
                 * g00 and g11 are auto-adjoint:
                 * imaginary half = 0.
                 *
                 * g01 is complex.
                 */

                a = 8.0
                        + (double)((u + 3 * cid) % 11)
                        + 0.25;

                br = (double)((int)((5 * u + cid) % 7) - 3)
                        * 0.375;

                bi = (double)((int)((3 * u + 2 * cid) % 9) - 4)
                        * 0.25;

                c = 32.0
                        + (double)((7 * u + cid) % 13)
                        + 0.5;

                g00[u] = make_fpr(a);
                g00[u + hn] = make_fpr(0.0);

                g01[u] = make_fpr(br);
                g01[u + hn] = make_fpr(bi);

                g11[u] = make_fpr(c);
                g11[u + hn] = make_fpr(0.0);
        }
}

static void
make_dir(const char *op, unsigned cid,
        char *dir, size_t len)
{
        snprintf(dir, len,
                "../unit/ldl/directed/%s/case_%03u",
                op, cid);

        (void)mkdir(dir, 0777);
}

static void
write_meta(const char *dir,
        unsigned cid, unsigned logn, size_t n)
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
write_case(
        const char *op,
        unsigned cid,
        unsigned logn,
        const fpr *g00,
        const fpr *g01,
        const fpr *g11,
        const fpr *l10,
        const fpr *d11,
        size_t n)
{
        char dir[256];
        char path[512];

        make_dir(op, cid, dir, sizeof dir);

        snprintf(path, sizeof path, "%s/g00.memh", dir);
        write_fpr(path, g00, n);

        snprintf(path, sizeof path, "%s/g01.memh", dir);
        write_fpr(path, g01, n);

        snprintf(path, sizeof path, "%s/g11.memh", dir);
        write_fpr(path, g11, n);

        snprintf(path, sizeof path, "%s/l10.memh", dir);
        write_fpr(path, l10, n);

        snprintf(path, sizeof path, "%s/d11.memh", dir);
        write_fpr(path, d11, n);

        write_meta(dir, cid, logn, n);
}

static void
make_case(unsigned cid, unsigned logn)
{
        fpr g00[MAX_N];
        fpr g01[MAX_N];
        fpr g11[MAX_N];

        fpr ldl_g01[MAX_N];
        fpr ldl_g11[MAX_N];

        fpr mv_l10[MAX_N];
        fpr mv_d11[MAX_N];

        size_t n;

        n = (size_t)1 << logn;

        make_input(cid, logn, g00, g01, g11);

        /*
         * poly_LDL_fft:
         *
         * g01 -> l10
         * g11 -> d11
         */
        memcpy(ldl_g01, g01, n * sizeof *g01);
        memcpy(ldl_g11, g11, n * sizeof *g11);

        Zf(poly_LDL_fft)(
                g00,
                ldl_g01,
                ldl_g11,
                logn);

        /*
         * poly_LDLmv_fft:
         *
         * inputs remain unchanged
         * outputs are separate.
         */
        Zf(poly_LDLmv_fft)(
                mv_d11,
                mv_l10,
                g00,
                g01,
                g11,
                logn);

        /*
         * Both Falcon implementations must yield exactly
         * the same binary64 results.
         */
        if (memcmp(ldl_g01, mv_l10,
                n * sizeof *ldl_g01) != 0)
        {
                fprintf(stderr,
                        "[FAIL] L10 mismatch case_%03u\n",
                        cid);
                exit(EXIT_FAILURE);
        }

        if (memcmp(ldl_g11, mv_d11,
                n * sizeof *ldl_g11) != 0)
        {
                fprintf(stderr,
                        "[FAIL] D11 mismatch case_%03u\n",
                        cid);
                exit(EXIT_FAILURE);
        }

        write_case(
                "ldl",
                cid,
                logn,
                g00,
                g01,
                g11,
                ldl_g01,
                ldl_g11,
                n);

        write_case(
                "ldlmv",
                cid,
                logn,
                g00,
                g01,
                g11,
                mv_l10,
                mv_d11,
                n);

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
        printf("LDL Directed Golden completed.\n");
        printf("Cases per operation = %u\n", cid);
        printf("Operations = 2\n");

        return 0;
}