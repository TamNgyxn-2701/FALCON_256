#include "inner.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BASE_CASES  64
#define BER_CASES   64

static uint64_t
raw_fpr(fpr x)
{
        uint64_t r;

        memcpy(&r, &x, sizeof r);
        return r;
}

static fpr
make_fpr(double x)
{
        fpr r;

        /*
         * Golden configuration:
         * FALCON_FPNATIVE = 1
         */
        r.v = x;
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

static uint64_t
splitmix64(uint64_t *state)
{
        uint64_t z;

        *state += UINT64_C(0x9E3779B97F4A7C15);
        z = *state;

        z = (z ^ (z >> 30))
                * UINT64_C(0xBF58476D1CE4E5B9);
        z = (z ^ (z >> 27))
                * UINT64_C(0x94D049BB133111EB);

        return z ^ (z >> 31);
}

/*
 * Scalar Falcon BaseSamp / gaussian0_sampler reference.
 *
 * Input:
 *   lo = low 64 random bits
 *   hi = high 8 random bits
 *
 * Total random input = 72 bits.
 */
static int
basesamp_ref(uint64_t lo, uint32_t hi)
{
        static const uint32_t dist[] = {
                10745844u,  3068844u,  3741698u,
                 5559083u,  1580863u,  8248194u,
                 2260429u, 13669192u,  2736639u,
                  708981u,  4421575u, 10046180u,
                  169348u,  7122675u,  4136815u,
                   30538u, 13063405u,  7650655u,
                    4132u, 14505003u,  7826148u,
                     417u, 16768101u, 11363290u,
                      31u,  8444042u,  8086568u,
                       1u, 12844466u,   265321u,
                       0u,  1232676u, 13644283u,
                       0u,    38047u,  9111839u,
                       0u,      870u,  6138264u,
                       0u,       14u, 12545723u,
                       0u,        0u,  3104126u,
                       0u,        0u,    28824u,
                       0u,        0u,      198u,
                       0u,        0u,        1u
        };

        uint32_t v0, v1, v2;
        size_t u;
        int z;

        hi &= 0xFF;

        v0 = (uint32_t)lo & 0xFFFFFF;
        v1 = (uint32_t)(lo >> 24) & 0xFFFFFF;
        v2 = (uint32_t)(lo >> 48) | (hi << 16);

        z = 0;

        for (u = 0;
                u < (sizeof dist) / sizeof(dist[0]);
                u += 3)
        {
                uint32_t w0, w1, w2, cc;

                w0 = dist[u + 2];
                w1 = dist[u + 1];
                w2 = dist[u + 0];

                cc = (v0 - w0) >> 31;
                cc = (v1 - w1 - cc) >> 31;
                cc = (v2 - w2 - cc) >> 31;

                z += (int)cc;
        }

        return z;
}

/*
 * Deterministic version of Falcon BerExp.
 *
 * Instead of taking bytes from prng_get_u8(), the bytes
 * are supplied explicitly in rnd[].
 */
static int
berexp_ref(
        fpr x,
        fpr ccs,
        const uint8_t rnd[8],
        unsigned *bytes_used,
        int *s_out,
        fpr *r_out,
        uint64_t *threshold_out)
{
        int s, i;
        fpr r;
        uint32_t sw, w;
        uint64_t z;
        unsigned k;

        s = (int)fpr_trunc(
                fpr_mul(x, fpr_inv_log2));

        r = fpr_sub(
                x,
                fpr_mul(fpr_of(s), fpr_log2));

        sw = (uint32_t)s;
        sw ^= (sw ^ 63)
                & -((63 - sw) >> 31);

        s = (int)sw;

        z = ((fpr_expm_p63(r, ccs) << 1) - 1)
                >> s;

        i = 64;
        k = 0;

        do {
                uint32_t rb;

                i -= 8;

                rb = rnd[k ++];

                w = rb
                        - ((uint32_t)(z >> i) & 0xFF);

        } while (!w && i > 0);

        *bytes_used = k;
        *s_out = s;
        *r_out = r;
        *threshold_out = z;

        return (int)(w >> 31);
}

static void
generate_basesamp(void)
{
        FILE *flo;
        FILE *fhi;
        FILE *fexp;
        FILE *fcsv;

        uint64_t state;
        unsigned cid;

        flo = open_out(
                "../unit/sampler/directed/basesamp/lo.memh");

        fhi = open_out(
                "../unit/sampler/directed/basesamp/hi.memh");

        fexp = open_out(
                "../unit/sampler/directed/basesamp/expected_z0.memh");

        fcsv = open_out(
                "../unit/sampler/directed/basesamp/cases.csv");

        fprintf(fcsv, "case,lo,hi,z0\n");

        state = UINT64_C(0x53414D504C45525A);

        for (cid = 0; cid < BASE_CASES; cid ++) {
                uint64_t lo;
                uint32_t hi;
                int z0;

                if (cid == 0) {
                        lo = UINT64_C(0);
                        hi = 0;
                } else if (cid == 1) {
                        lo = UINT64_MAX;
                        hi = 0xFF;
                } else if (cid == 2) {
                        lo = UINT64_C(0xAAAAAAAAAAAAAAAA);
                        hi = 0xAA;
                } else if (cid == 3) {
                        lo = UINT64_C(0x5555555555555555);
                        hi = 0x55;
                } else {
                        uint64_t r;

                        r = splitmix64(&state);
                        lo = r;

                        r = splitmix64(&state);
                        hi = (uint32_t)r & 0xFF;
                }

                z0 = basesamp_ref(lo, hi);

                fprintf(flo, "%016llx\n",
                        (unsigned long long)lo);

                fprintf(fhi, "%02x\n",
                        (unsigned)hi);

                fprintf(fexp, "%08x\n",
                        (uint32_t)z0);

                fprintf(fcsv,
                        "%u,%016llx,%02x,%d\n",
                        cid,
                        (unsigned long long)lo,
                        (unsigned)hi,
                        z0);
        }

        fclose(flo);
        fclose(fhi);
        fclose(fexp);
        fclose(fcsv);

        printf("[OK] BaseSamp Directed : %u cases\n",
                BASE_CASES);
}

static void
generate_berexp(void)
{
        static const double xv[16] = {
                0.0,
                0.01,
                0.10,
                0.25,
                0.50,
                0.6931471805599453,
                1.0,
                1.5,
                2.0,
                3.0,
                4.0,
                6.0,
                8.0,
                12.0,
                24.0,
                48.0
        };

        static const double cv[4] = {
                0.50,
                0.625,
                0.75,
                0.95
        };

        FILE *fx;
        FILE *fccs;
        FILE *frnd;
        FILE *faccept;
        FILE *fused;
        FILE *fs;
        FILE *fr;
        FILE *fthreshold;
        FILE *fcsv;

        uint64_t state;
        unsigned xi, ci, cid;

        fx = open_out(
                "../unit/sampler/directed/berexp/x.memh");

        fccs = open_out(
                "../unit/sampler/directed/berexp/ccs.memh");

        frnd = open_out(
                "../unit/sampler/directed/berexp/random_bytes.memh");

        faccept = open_out(
                "../unit/sampler/directed/berexp/expected_accept.memh");

        fused = open_out(
                "../unit/sampler/directed/berexp/bytes_used.memh");

        fs = open_out(
                "../unit/sampler/directed/berexp/s.memh");

        fr = open_out(
                "../unit/sampler/directed/berexp/r.memh");

        fthreshold = open_out(
                "../unit/sampler/directed/berexp/threshold.memh");

        fcsv = open_out(
                "../unit/sampler/directed/berexp/cases.csv");

        fprintf(fcsv,
                "case,x,ccs,random_offset,bytes_used,accept\n");

        state = UINT64_C(0x4245524558503634);

        cid = 0;

        for (xi = 0; xi < 16; xi ++) {
                for (ci = 0; ci < 4; ci ++) {
                        fpr x, ccs, rr;
                        uint8_t rnd[8];
                        uint64_t rv;
                        uint64_t threshold;
                        unsigned used;
                        unsigned k;
                        int ss;
                        int accept;

                        x = make_fpr(xv[xi]);
                        ccs = make_fpr(cv[ci]);

                        rv = splitmix64(&state);

                        for (k = 0; k < 8; k ++) {
                                rnd[k] =
                                        (uint8_t)(rv >> (8 * k));

                                fprintf(frnd,
                                        "%02x\n",
                                        (unsigned)rnd[k]);
                        }

                        accept = berexp_ref(
                                x,
                                ccs,
                                rnd,
                                &used,
                                &ss,
                                &rr,
                                &threshold);

                        fprintf(fx, "%016llx\n",
                                (unsigned long long)raw_fpr(x));

                        fprintf(fccs, "%016llx\n",
                                (unsigned long long)raw_fpr(ccs));

                        fprintf(faccept, "%01x\n",
                                accept & 1);

                        fprintf(fused, "%02x\n",
                                used);

                        fprintf(fs, "%08x\n",
                                (uint32_t)ss);

                        fprintf(fr, "%016llx\n",
                                (unsigned long long)raw_fpr(rr));

                        fprintf(fthreshold, "%016llx\n",
                                (unsigned long long)threshold);

                        fprintf(fcsv,
                                "%u,%016llx,%016llx,%u,%u,%d\n",
                                cid,
                                (unsigned long long)raw_fpr(x),
                                (unsigned long long)raw_fpr(ccs),
                                cid * 8,
                                used,
                                accept);

                        cid ++;
                }
        }

        fclose(fx);
        fclose(fccs);
        fclose(frnd);
        fclose(faccept);
        fclose(fused);
        fclose(fs);
        fclose(fr);
        fclose(fthreshold);
        fclose(fcsv);

        printf("[OK] BerExp Directed   : %u cases\n",
                cid);
}

int
main(void)
{
        generate_basesamp();
        generate_berexp();

        printf("\n");
        printf("Sampler Directed Golden completed.\n");

        return 0;
}