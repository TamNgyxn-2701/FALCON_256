#include "inner.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_INT2FPR 32
#define NUM_FPR2INT 32

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
gen_int2fpr(void)
{
        static const int64_t input[NUM_INT2FPR] = {
                0,
                1,
                -1,
                2,
                -2,
                3,
                -3,
                7,
                -7,
                10,
                -10,
                127,
                -128,
                255,
                256,
                511,
                512,
                1024,
                -1024,
                12289,
                -12289,
                32767,
                -32768,
                65535,
                -65535,
                100000,
                -100000,
                1048576,
                -1048576,
                16777216,
                2147483647LL,
                -2147483647LL
        };

        FILE *fi;
        FILE *fo;
        size_t u;

        fi = open_out("../unit/convert/int2fpr/input.memh");
        fo = open_out("../unit/convert/int2fpr/expected.memh");

        for (u = 0; u < NUM_INT2FPR; u ++) {
                fpr y;

                y = fpr_of(input[u]);

                /*
                 * Integer input is stored as 64-bit two's complement.
                 */
                fprintf(fi, "%016llx\n",
                        (unsigned long long)(uint64_t)input[u]);

                /*
                 * Output is raw IEEE-754 binary64.
                 */
                fprintf(fo, "%016llx\n",
                        (unsigned long long)fpr_to_raw(y));
        }

        fclose(fi);
        fclose(fo);

        printf("[OK] INT2FPR : %d cases\n", NUM_INT2FPR);
}

static void
gen_fpr2int(void)
{
        static const double input[NUM_FPR2INT] = {
                 0.0,
                 1.0,
                -1.0,
                 2.0,
                -2.0,

                 0.5,
                -0.5,
                 1.5,
                -1.5,
                 2.5,
                -2.5,
                 3.5,
                -3.5,

                 0.25,
                -0.25,
                 0.49,
                -0.49,
                 0.51,
                -0.51,

                 7.25,
                -7.25,
                 10.75,
                -10.75,

                 127.4,
                 127.5,
                 127.6,
                -127.4,
                -127.5,
                -127.6,

                 12289.4,
                 12289.5,
                -12289.5
        };

        FILE *fi;
        FILE *fo;
        size_t u;

        fi = open_out("../unit/convert/fpr2int/input.memh");
        fo = open_out("../unit/convert/fpr2int/expected.memh");

        for (u = 0; u < NUM_FPR2INT; u ++) {
                fpr x;
                int64_t y;

                x = FPR(input[u]);
                y = fpr_rint(x);

                /*
                 * Input is raw IEEE-754 binary64.
                 */
                fprintf(fi, "%016llx\n",
                        (unsigned long long)fpr_to_raw(x));

                /*
                 * Output integer is 64-bit two's complement.
                 */
                fprintf(fo, "%016llx\n",
                        (unsigned long long)(uint64_t)y);
        }

        fclose(fi);
        fclose(fo);

        printf("[OK] FPR2INT : %d cases\n", NUM_FPR2INT);
}

int
main(void)
{
        gen_int2fpr();
        gen_fpr2int();

        printf("\nConversion Golden generation completed.\n");
        return 0;
}