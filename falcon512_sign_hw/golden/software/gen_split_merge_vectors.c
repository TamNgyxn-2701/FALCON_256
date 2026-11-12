#include "inner.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

#define MAX_LOGN   9
#define MAX_N      (1u << MAX_LOGN)

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

static void
write_fpr_file(const char *name, const fpr *a, size_t n)
{
        FILE *fp;
        size_t u;

        fp = open_out(name);

        for (u = 0; u < n; u ++) {
                fprintf(fp, "%016llx\n",
                        (unsigned long long)fpr_to_raw(a[u]));
        }

        fclose(fp);
}

/*
 * Deterministic binary-friendly input values.
 *
 * Only integers and fractions that are powers of two are used,
 * therefore the initial values are represented exactly in binary64.
 */
static fpr
make_input(unsigned case_id, size_t u)
{
        int v;
        double x;

        v = (int)((u * 5 + case_id * 3) % 31) - 15;

        x = (double)v;

        switch ((u + case_id) & 3) {
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

        if (((u + case_id) & 1) != 0) {
                x = -x;
        }

        return FPR(x);
}

static void
make_case(unsigned case_id, unsigned logn)
{
        fpr input[MAX_N];
        fpr f0[MAX_N >> 1];
        fpr f1[MAX_N >> 1];
        fpr merged[MAX_N];

        size_t n;
        size_t hn;
        size_t u;

        char split_dir[256];
        char merge_dir[256];
        char path[512];

        FILE *fp;

        n = (size_t)1 << logn;
        hn = n >> 1;

        snprintf(split_dir, sizeof split_dir,
                "../unit/split_merge/directed/split/case_%03u",
                case_id);

        snprintf(merge_dir, sizeof merge_dir,
                "../unit/split_merge/directed/merge/case_%03u",
                case_id);

        if (mkdir(split_dir, 0777) != 0) {
                /*
                 * Directory may already exist.
                 */
        }

        if (mkdir(merge_dir, 0777) != 0) {
                /*
                 * Directory may already exist.
                 */
        }

        /*
         * Generate deterministic source polynomial.
         */
        for (u = 0; u < n; u ++) {
                input[u] = make_input(case_id, u);
        }

        /*
         * Golden SPLIT.
         */
        Zf(poly_split_fft)(f0, f1, input, logn);

        /*
         * Golden MERGE.
         *
         * Use SPLIT outputs as MERGE inputs so that each directed
         * case exercises the natural SPLIT -> MERGE path.
         */
        Zf(poly_merge_fft)(merged, f0, f1, logn);

        /*
         * SPLIT vectors.
         */
        snprintf(path, sizeof path,
                "%s/input.memh", split_dir);
        write_fpr_file(path, input, n);

        snprintf(path, sizeof path,
                "%s/out0.memh", split_dir);
        write_fpr_file(path, f0, hn);

        snprintf(path, sizeof path,
                "%s/out1.memh", split_dir);
        write_fpr_file(path, f1, hn);

        snprintf(path, sizeof path,
                "%s/meta.txt", split_dir);

        fp = open_out(path);
        fprintf(fp, "case=%u\n", case_id);
        fprintf(fp, "logn=%u\n", logn);
        fprintf(fp, "n=%zu\n", n);
        fprintf(fp, "hn=%zu\n", hn);
        fclose(fp);

        /*
         * MERGE vectors.
         */
        snprintf(path, sizeof path,
                "%s/in0.memh", merge_dir);
        write_fpr_file(path, f0, hn);

        snprintf(path, sizeof path,
                "%s/in1.memh", merge_dir);
        write_fpr_file(path, f1, hn);

        snprintf(path, sizeof path,
                "%s/expected.memh", merge_dir);
        write_fpr_file(path, merged, n);

        snprintf(path, sizeof path,
                "%s/meta.txt", merge_dir);

        fp = open_out(path);
        fprintf(fp, "case=%u\n", case_id);
        fprintf(fp, "logn=%u\n", logn);
        fprintf(fp, "n=%zu\n", n);
        fprintf(fp, "hn=%zu\n", hn);
        fclose(fp);

        printf("[OK] case_%03u : logn=%u N=%zu\n",
                case_id, logn, n);
}

int
main(void)
{
        unsigned logn;
        unsigned case_id;

        case_id = 0;

        for (logn = 1; logn <= MAX_LOGN; logn ++) {
                make_case(case_id, logn);
                case_id ++;
        }

        printf("\n");
        printf("Split/Merge Directed Golden completed.\n");
        printf("Cases = %u\n", case_id);

        return 0;
}