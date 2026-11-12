#include "sampler_trace.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int trace_enabled;

/* sampler */
static FILE *fp_sampler_mu;
static FILE *fp_sampler_isigma;
static FILE *fp_sampler_sigma_min;
static FILE *fp_sampler_s;
static FILE *fp_sampler_r;
static FILE *fp_sampler_dss;
static FILE *fp_sampler_ccs;
static FILE *fp_sampler_z;
static FILE *fp_sampler_calls;

/* attempt */
static FILE *fp_attempt_z0;
static FILE *fp_attempt_b;
static FILE *fp_attempt_candidate;
static FILE *fp_attempt_x;
static FILE *fp_attempt_ccs;
static FILE *fp_attempt_accept;
static FILE *fp_attempt_calls;

/* BaseSamp */
static FILE *fp_base_lo;
static FILE *fp_base_hi;
static FILE *fp_base_z0;
static FILE *fp_base_calls;

/* BerExp */
static FILE *fp_ber_x;
static FILE *fp_ber_ccs;
static FILE *fp_ber_s;
static FILE *fp_ber_r;
static FILE *fp_ber_threshold;
static FILE *fp_ber_accept;
static FILE *fp_ber_random;
static FILE *fp_ber_calls;

static unsigned long long sampler_calls;
static unsigned long long attempt_calls;
static unsigned long long basesamp_calls;
static unsigned long long berexp_calls;
static unsigned long long berexp_random_bytes;

static unsigned long long current_sampler;
static unsigned current_attempt;

static unsigned long long sampler_attempt_start;
static unsigned long long berexp_byte_start;

static uint64_t
raw_fpr(fpr x)
{
        uint64_t r;

        memcpy(&r, &x, sizeof r);
        return r;
}

static FILE *
open_file(const char *name)
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
write_fpr(FILE *fp, fpr x)
{
        fprintf(fp, "%016llx\n",
                (unsigned long long)raw_fpr(x));
}

void
falcon_sampler_trace_begin(void)
{
        fp_sampler_mu = open_file(
                "../unit/sampler/trace/sampler/mu.memh");

        fp_sampler_isigma = open_file(
                "../unit/sampler/trace/sampler/isigma.memh");

        fp_sampler_sigma_min = open_file(
                "../unit/sampler/trace/sampler/sigma_min.memh");

        fp_sampler_s = open_file(
                "../unit/sampler/trace/sampler/s.memh");

        fp_sampler_r = open_file(
                "../unit/sampler/trace/sampler/r.memh");

        fp_sampler_dss = open_file(
                "../unit/sampler/trace/sampler/dss.memh");

        fp_sampler_ccs = open_file(
                "../unit/sampler/trace/sampler/ccs.memh");

        fp_sampler_z = open_file(
                "../unit/sampler/trace/sampler/expected_z.memh");

        fp_sampler_calls = open_file(
                "../unit/sampler/trace/sampler/calls.csv");

        fprintf(fp_sampler_calls,
                "call,attempt_offset,attempt_count\n");


        fp_attempt_z0 = open_file(
                "../unit/sampler/trace/attempts/z0.memh");

        fp_attempt_b = open_file(
                "../unit/sampler/trace/attempts/b.memh");

        fp_attempt_candidate = open_file(
                "../unit/sampler/trace/attempts/candidate_z.memh");

        fp_attempt_x = open_file(
                "../unit/sampler/trace/attempts/x.memh");

        fp_attempt_ccs = open_file(
                "../unit/sampler/trace/attempts/ccs.memh");

        fp_attempt_accept = open_file(
                "../unit/sampler/trace/attempts/accept.memh");

        fp_attempt_calls = open_file(
                "../unit/sampler/trace/attempts/calls.csv");

        fprintf(fp_attempt_calls,
                "attempt,sampler_call,local_attempt\n");


        fp_base_lo = open_file(
                "../unit/sampler/trace/basesamp/lo.memh");

        fp_base_hi = open_file(
                "../unit/sampler/trace/basesamp/hi.memh");

        fp_base_z0 = open_file(
                "../unit/sampler/trace/basesamp/expected_z0.memh");

        fp_base_calls = open_file(
                "../unit/sampler/trace/basesamp/calls.csv");

        fprintf(fp_base_calls,
                "call,sampler_call,local_attempt\n");


        fp_ber_x = open_file(
                "../unit/sampler/trace/berexp/x.memh");

        fp_ber_ccs = open_file(
                "../unit/sampler/trace/berexp/ccs.memh");

        fp_ber_s = open_file(
                "../unit/sampler/trace/berexp/s.memh");

        fp_ber_r = open_file(
                "../unit/sampler/trace/berexp/r.memh");

        fp_ber_threshold = open_file(
                "../unit/sampler/trace/berexp/threshold.memh");

        fp_ber_accept = open_file(
                "../unit/sampler/trace/berexp/expected_accept.memh");

        fp_ber_random = open_file(
                "../unit/sampler/trace/berexp/random_bytes.memh");

        fp_ber_calls = open_file(
                "../unit/sampler/trace/berexp/calls.csv");

        fprintf(fp_ber_calls,
                "call,sampler_call,local_attempt,random_offset,bytes_used\n");

        sampler_calls = 0;
        attempt_calls = 0;
        basesamp_calls = 0;
        berexp_calls = 0;
        berexp_random_bytes = 0;

        current_sampler = 0;
        current_attempt = 0;

        sampler_attempt_start = 0;
        berexp_byte_start = 0;

        trace_enabled = 1;
}

void
falcon_sampler_trace_sampler_in(
        fpr mu,
        fpr isigma,
        fpr sigma_min)
{
        if (!trace_enabled) {
                return;
        }

        current_sampler = sampler_calls;
        current_attempt = 0;
        sampler_attempt_start = attempt_calls;

        write_fpr(fp_sampler_mu, mu);
        write_fpr(fp_sampler_isigma, isigma);
        write_fpr(fp_sampler_sigma_min, sigma_min);
}

void
falcon_sampler_trace_sampler_derived(
        int s,
        fpr r,
        fpr dss,
        fpr ccs)
{
        if (!trace_enabled) {
                return;
        }

        fprintf(fp_sampler_s, "%08x\n", (uint32_t)s);

        write_fpr(fp_sampler_r, r);
        write_fpr(fp_sampler_dss, dss);
        write_fpr(fp_sampler_ccs, ccs);
}

void
falcon_sampler_trace_sampler_out(int z)
{
        unsigned long long count;

        if (!trace_enabled) {
                return;
        }

        fprintf(fp_sampler_z, "%08x\n", (uint32_t)z);

        count = attempt_calls - sampler_attempt_start;

        fprintf(fp_sampler_calls,
                "%llu,%llu,%llu\n",
                sampler_calls,
                sampler_attempt_start,
                count);

        sampler_calls ++;
}

void
falcon_sampler_trace_basesamp(
        uint64_t lo,
        uint32_t hi,
        int z0)
{
        if (!trace_enabled) {
                return;
        }

        fprintf(fp_base_lo, "%016llx\n",
                (unsigned long long)lo);

        fprintf(fp_base_hi, "%02x\n",
                (unsigned)(hi & 0xFF));

        fprintf(fp_base_z0, "%08x\n",
                (uint32_t)z0);

        fprintf(fp_base_calls,
                "%llu,%llu,%u\n",
                basesamp_calls,
                current_sampler,
                current_attempt);

        basesamp_calls ++;
}

void
falcon_sampler_trace_berexp_begin(
        fpr x,
        fpr ccs,
        int s,
        fpr r,
        uint64_t threshold)
{
        if (!trace_enabled) {
                return;
        }

        berexp_byte_start = berexp_random_bytes;

        write_fpr(fp_ber_x, x);
        write_fpr(fp_ber_ccs, ccs);

        fprintf(fp_ber_s, "%08x\n",
                (uint32_t)s);

        write_fpr(fp_ber_r, r);

        fprintf(fp_ber_threshold, "%016llx\n",
                (unsigned long long)threshold);
}

void
falcon_sampler_trace_berexp_byte(uint8_t b)
{
        if (!trace_enabled) {
                return;
        }

        fprintf(fp_ber_random, "%02x\n",
                (unsigned)b);

        berexp_random_bytes ++;
}

void
falcon_sampler_trace_berexp_end(int accept)
{
        unsigned long long used;

        if (!trace_enabled) {
                return;
        }

        fprintf(fp_ber_accept, "%01x\n",
                accept & 1);

        used = berexp_random_bytes - berexp_byte_start;

        fprintf(fp_ber_calls,
                "%llu,%llu,%u,%llu,%llu\n",
                berexp_calls,
                current_sampler,
                current_attempt,
                berexp_byte_start,
                used);

        berexp_calls ++;
}

void
falcon_sampler_trace_attempt(
        int z0,
        int b,
        int candidate_z,
        fpr x,
        fpr ccs,
        int accept)
{
        if (!trace_enabled) {
                return;
        }

        fprintf(fp_attempt_z0, "%08x\n",
                (uint32_t)z0);

        fprintf(fp_attempt_b, "%01x\n",
                b & 1);

        fprintf(fp_attempt_candidate, "%08x\n",
                (uint32_t)candidate_z);

        write_fpr(fp_attempt_x, x);
        write_fpr(fp_attempt_ccs, ccs);

        fprintf(fp_attempt_accept, "%01x\n",
                accept & 1);

        fprintf(fp_attempt_calls,
                "%llu,%llu,%u\n",
                attempt_calls,
                current_sampler,
                current_attempt);

        attempt_calls ++;
        current_attempt ++;
}

void
falcon_sampler_trace_end(void)
{
        FILE *fp;

        if (!trace_enabled) {
                return;
        }

        trace_enabled = 0;

        fclose(fp_sampler_mu);
        fclose(fp_sampler_isigma);
        fclose(fp_sampler_sigma_min);
        fclose(fp_sampler_s);
        fclose(fp_sampler_r);
        fclose(fp_sampler_dss);
        fclose(fp_sampler_ccs);
        fclose(fp_sampler_z);
        fclose(fp_sampler_calls);

        fclose(fp_attempt_z0);
        fclose(fp_attempt_b);
        fclose(fp_attempt_candidate);
        fclose(fp_attempt_x);
        fclose(fp_attempt_ccs);
        fclose(fp_attempt_accept);
        fclose(fp_attempt_calls);

        fclose(fp_base_lo);
        fclose(fp_base_hi);
        fclose(fp_base_z0);
        fclose(fp_base_calls);

        fclose(fp_ber_x);
        fclose(fp_ber_ccs);
        fclose(fp_ber_s);
        fclose(fp_ber_r);
        fclose(fp_ber_threshold);
        fclose(fp_ber_accept);
        fclose(fp_ber_random);
        fclose(fp_ber_calls);

        fp = open_file(
                "../unit/sampler/trace/counts.txt");

        fprintf(fp, "sampler_calls=%llu\n",
                sampler_calls);

        fprintf(fp, "attempts=%llu\n",
                attempt_calls);

        fprintf(fp, "basesamp_calls=%llu\n",
                basesamp_calls);

        fprintf(fp, "berexp_calls=%llu\n",
                berexp_calls);

        fprintf(fp, "berexp_random_bytes=%llu\n",
                berexp_random_bytes);

        fclose(fp);
}
