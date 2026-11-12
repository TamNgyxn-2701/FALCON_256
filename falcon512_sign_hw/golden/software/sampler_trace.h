#ifndef FALCON_SAMPLER_TRACE_H
#define FALCON_SAMPLER_TRACE_H

#include "inner.h"

#include <stdint.h>

void falcon_sampler_trace_begin(void);
void falcon_sampler_trace_end(void);

void falcon_sampler_trace_sampler_in(
        fpr mu,
        fpr isigma,
        fpr sigma_min);

void falcon_sampler_trace_sampler_derived(
        int s,
        fpr r,
        fpr dss,
        fpr ccs);

void falcon_sampler_trace_sampler_out(int z);

void falcon_sampler_trace_basesamp(
        uint64_t lo,
        uint32_t hi,
        int z0);

void falcon_sampler_trace_berexp_begin(
        fpr x,
        fpr ccs,
        int s,
        fpr r,
        uint64_t threshold);

void falcon_sampler_trace_berexp_byte(uint8_t b);
void falcon_sampler_trace_berexp_end(int accept);

void falcon_sampler_trace_attempt(
        int z0,
        int b,
        int candidate_z,
        fpr x,
        fpr ccs,
        int accept);

#endif
