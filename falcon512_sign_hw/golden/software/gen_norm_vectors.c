#include "inner.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#define NORM_LOGN   9
#define NORM_N      512
#define NORM_CASES  12
#define NORM_BOUND  34034726u

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
 * Reproduce the saturated squared-norm accumulation used
 * by Falcon is_short_half().
 */
static uint32_t
norm_total_ref(uint32_t sqn, const int16_t *s2)
{
        uint32_t ng;
        size_t u;

        ng = -(sqn >> 31);

        for (u = 0; u < NORM_N; u ++) {
                int32_t z;

                z = s2[u];

                sqn += (uint32_t)(z * z);
                ng |= sqn;
        }

        sqn |= -(ng >> 31);

        return sqn;
}

static void
setup_case(
        unsigned cid,
        uint32_t *sqn_s1,
        int16_t *s2,
        const char **description)
{
        size_t u;

        memset(s2, 0, NORM_N * sizeof *s2);

        switch (cid) {

        case 0:
                *sqn_s1 = 0;
                *description = "all zero";
                break;

        case 1:
                *sqn_s1 = 123456;
                *description = "nonzero sqn_s1, s2 zero";
                break;

        case 2:
                *sqn_s1 = 0;

                for (u = 0; u < NORM_N; u ++) {
                        s2[u] = 1;
                }

                *description = "s2 all +1";
                break;

        case 3:
                *sqn_s1 = 0;

                for (u = 0; u < NORM_N; u ++) {
                        s2[u] = (u & 1) ? -1 : 1;
                }

                *description = "s2 alternating +1/-1";
                break;

        /*
         * 1026^2 + 5743^2 = 34034725 = bound - 1
         */
        case 4:
                *sqn_s1 = 0;

                s2[0] = 1026;
                s2[1] = 5743;

                *description = "norm = bound - 1";
                break;

        /*
         * 1^2 + 1026^2 + 5743^2 = 34034726 = bound
         */
        case 5:
                *sqn_s1 = 0;

                s2[0] = -1;
                s2[1] = 1026;
                s2[2] = -5743;

                *description = "norm = bound exactly";
                break;

        /*
         * 1^2 + 1^2 + 1026^2 + 5743^2
         * = 34034727 = bound + 1
         */
        case 6:
                *sqn_s1 = 0;

                s2[0] = 1;
                s2[1] = -1;
                s2[2] = 1026;
                s2[3] = -5743;

                *description = "norm = bound + 1";
                break;

        case 7:
                *sqn_s1 = NORM_BOUND - 1;

                s2[0] = -1;

                *description =
                        "sqn_s1=bound-1 plus s2 square 1";
                break;

        case 8:
                *sqn_s1 = NORM_BOUND;

                s2[0] = 1;

                *description =
                        "sqn_s1=bound plus s2 square 1";
                break;

        case 9:
                *sqn_s1 = UINT32_C(0x7FFFFFFF);

                *description =
                        "maximum positive 31-bit sqn";
                break;

        case 10:
                *sqn_s1 = UINT32_C(0x80000000);

                *description =
                        "input sqn already has overflow bit";
                break;

        case 11:
                *sqn_s1 = 0;

                s2[0] = 32767;
                s2[1] = -32767;
                s2[2] = 32767;

                *description =
                        "accumulation overflow saturation";
                break;

        default:
                fprintf(stderr, "Invalid case\n");
                exit(EXIT_FAILURE);
        }
}

int
main(void)
{
        unsigned cid;

        for (cid = 0; cid < NORM_CASES; cid ++) {
                char dir[256];
                char path[512];

                int16_t s2[NORM_N];
                uint32_t sqn_s1;
                uint32_t total;
                int accept;
                const char *description;

                FILE *fp;
                size_t u;

                setup_case(
                        cid,
                        &sqn_s1,
                        s2,
                        &description);

                /*
                 * Golden function from Falcon common.c.
                 */
                accept = Zf(is_short_half)(
                        sqn_s1,
                        s2,
                        NORM_LOGN);

                total = norm_total_ref(
                        sqn_s1,
                        s2);

                snprintf(
                        dir,
                        sizeof dir,
                        "../unit/norm/directed/case_%03u",
                        cid);

                if (mkdir(dir, 0777) != 0) {
                        /*
                         * Directory may already exist.
                         */
                }

                snprintf(
                        path,
                        sizeof path,
                        "%s/sqn_s1.memh",
                        dir);

                fp = open_out(path);
                fprintf(fp, "%08x\n", sqn_s1);
                fclose(fp);


                snprintf(
                        path,
                        sizeof path,
                        "%s/s2.memh",
                        dir);

                fp = open_out(path);

                for (u = 0; u < NORM_N; u ++) {
                        fprintf(
                                fp,
                                "%04x\n",
                                (uint16_t)s2[u]);
                }

                fclose(fp);


                snprintf(
                        path,
                        sizeof path,
                        "%s/expected_sqn_total.memh",
                        dir);

                fp = open_out(path);
                fprintf(fp, "%08x\n", total);
                fclose(fp);


                snprintf(
                        path,
                        sizeof path,
                        "%s/bound.memh",
                        dir);

                fp = open_out(path);
                fprintf(fp, "%08x\n", NORM_BOUND);
                fclose(fp);


                snprintf(
                        path,
                        sizeof path,
                        "%s/expected_accept.memh",
                        dir);

                fp = open_out(path);
                fprintf(fp, "%01x\n", accept);
                fclose(fp);


                snprintf(
                        path,
                        sizeof path,
                        "%s/meta.txt",
                        dir);

                fp = open_out(path);

                fprintf(fp, "case=%u\n", cid);
                fprintf(fp, "logn=%u\n", NORM_LOGN);
                fprintf(fp, "n=%u\n", NORM_N);
                fprintf(fp, "description=%s\n",
                        description);
                fprintf(fp, "sqn_s1=%u\n",
                        sqn_s1);
                fprintf(fp, "sqn_total=%u\n",
                        total);
                fprintf(fp, "sqn_total_hex=%08x\n",
                        total);
                fprintf(fp, "bound=%u\n",
                        NORM_BOUND);
                fprintf(fp, "accepted=%d\n",
                        accept);

                fclose(fp);

                printf(
                        "[OK] case_%03u : "
                        "total=%08x accept=%d : %s\n",
                        cid,
                        total,
                        accept,
                        description);
        }

        printf("\n");
        printf("Norm Directed Golden completed.\n");
        printf("Cases = %u\n", NORM_CASES);

        return 0;
}