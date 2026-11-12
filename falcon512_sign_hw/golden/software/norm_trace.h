#ifndef FALCON_NORM_TRACE_H
#define FALCON_NORM_TRACE_H

#include "inner.h"

#include <stddef.h>
#include <stdint.h>

void falcon_norm_trace_begin(void);

void falcon_norm_trace_s1_step(
        size_t index,
        int32_t z,
        uint32_t square,
        uint32_t running_s1);

void falcon_norm_trace_s2_step(
        size_t index,
        int32_t z,
        uint32_t square,
        uint32_t running_s2,
        uint32_t running_total);

void falcon_norm_trace_finish(
        uint32_t sqn_s1,
        uint32_t sqn_s2,
        uint32_t sqn_total,
        uint32_t bound,
        int accepted);

#endif
