// REQUIRED_ARGS: -HCf=${RESULTS_DIR}/compilable/dtoh_enum.out -c
// PERMUTE_ARGS:
// POST_SCRIPT: compilable/extra-files/dtoh-postscript.sh

/*
TEST_OUTPUT:
---
---
*/

enum Dummy
{
    One,
    Two
}
