/**
 * @file trans.c
 * @brief Contains various implementations of matrix transpose
 *
 * Each transpose function must have a prototype of the form:
 *   void trans(size_t M, size_t N, double A[N][M], double B[M][N],
 *              double tmp[TMPCOUNT]);
 *
 * All transpose functions take the following arguments:
 *
 *   @param[in]     M    Width of A, height of B
 *   @param[in]     N    Height of A, width of B
 *   @param[in]     A    Source matrix
 *   @param[out]    B    Destination matrix
 *   @param[in,out] tmp  Array that can store temporary double values
 *
 * A transpose function is evaluated by counting the number of hits and misses,
 * using the cache parameters and score computations described in the writeup.
 *
 * Programming restrictions:
 *   - No out-of-bounds references are allowed
 *   - No alterations may be made to the source array A
 *   - Data in tmp can be read or written
 *   - This file cannot contain any local or global doubles or arrays of doubles
 *   - You may not use unions, casting, global variables, or
 *     other tricks to hide array data in other forms of local or global memory.
 *
 * @author Yun Hsuan Tsai <yunhsuatsai@andrew.cmu.edu>
 */

#include <assert.h>
#include <stdbool.h>
#include <stdio.h>

#include "cachelab.h"

/**
 * @brief The size of the blocks of cache, used in the transpose functions
 *
 * This is used to optimize cache performance by working on sub-blocks of
 * the matrix rather than the entire matrix at once.
 */
#define TRANSBLOCKSIZE 8

/**
 * @brief Checks if B is the transpose of A.
 *
 * You can call this function inside of an assertion, if you'd like to verify
 * the correctness of a transpose function.
 *
 * @param[in]     M    Width of A, height of B
 * @param[in]     N    Height of A, width of B
 * @param[in]     A    Source matrix
 * @param[out]    B    Destination matrix
 *
 * @return True if B is the transpose of A, and false otherwise.
 */
#ifndef NDEBUG
static bool is_transpose(size_t M, size_t N, double A[N][M], double B[M][N]) {
    for (size_t i = 0; i < N; i++) {
        for (size_t j = 0; j < M; ++j) {
            if (A[i][j] != B[j][i]) {
                fprintf(stderr,
                        "Transpose incorrect.  Fails for B[%zd][%zd] = %.3f, "
                        "A[%zd][%zd] = %.3f\n",
                        j, i, B[j][i], i, j, A[i][j]);
                return false;
            }
        }
    }
    return true;
}
#endif

/**
 * @brief A simple baseline transpose function, not optimized for the cache.
 *
 * Note the use of asserts (defined in assert.h) that add checking code.
 * These asserts are disabled when measuring cycle counts (i.e. when running
 * the ./test-trans) to avoid affecting performance.
 */
static void trans_basic(size_t M, size_t N, double A[N][M], double B[M][N],
                        double tmp[TMPCOUNT]) {
    assert(M > 0);
    assert(N > 0);

    for (size_t i = 0; i < N; i++) {
        for (size_t j = 0; j < M; j++) {
            B[j][i] = A[i][j];
        }
    }

    assert(is_transpose(M, N, A, B));
}

/**
 * @brief Transposes a block of the matrix A into B.
 *
 * This function transposes a sub-block of matrix A into matrix B.
 * It is designed to be called by higher-level transpose functions
 * to improve cache performance.
 *
 * @param[in]     M        Width of A, height of B
 * @param[in]     N        Height of A, width of B
 * @param[in]     A        Source matrix
 * @param[out]    B        Destination matrix
 * @param[in,out] tmp      Array that can store temporary double values
 * @param[in]     M_start  Starting row index for the block
 * @param[in]     N_start  Starting column index for the block
 * @param[in]     M_end    Ending row index for the block
 * @param[in]     N_end    Ending column index for the block
 */
static void trans_block(size_t M, size_t N, double A[N][M], double B[M][N],
                        double tmp[TMPCOUNT], size_t M_start, size_t N_start,
                        size_t M_end, size_t N_end) {

    assert(M_start >= 0 && M_end <= M);
    assert(N_start >= 0 && N_end <= N);

    for (size_t i = N_start; i < N_end; i++) {
        for (size_t j = M_start; j < M_end; j++) {
            B[j][i] = A[i][j];
        }
    }
}

/**
 * @brief Transposes a diagonal block of the matrix A into B, using temporary
 * storage.
 *
 * This function handles the special case of transposing a diagonal block.
 * It uses temporary storage to avoid cache conflicts.
 *
 * @param[in]     M        Width of A, height of B
 * @param[in]     N        Height of A, width of B
 * @param[in]     A        Source matrix
 * @param[out]    B        Destination matrix
 * @param[in,out] tmp      Array that can store temporary double values
 * @param[in]     M_start  Starting row index for the block
 * @param[in]     N_start  Starting column index for the block
 * @param[in]     M_end    Ending row index for the block
 * @param[in]     N_end    Ending column index for the block
 */
static void trans_block_diag(size_t M, size_t N, double A[N][M], double B[M][N],
                             double tmp[TMPCOUNT], size_t M_start,
                             size_t N_start, size_t M_end, size_t N_end) {

    assert(M_start >= 0 && M_end <= M);
    assert(N_start >= 0 && N_end <= N);
    assert(M_start == N_start);

    for (size_t i = N_start + 1; i < N_end; i++) {
        size_t tmp_set = (N_start / 8 + (i - N_start) * 4 + 1) % 32;
        for (size_t j = M_start; j < M_end; j++) {
            tmp[tmp_set * 8 + (j - M_start)] = A[i][j];
        }
    }

    for (size_t j = M_end - 1; j > M_start; j--) {
        B[j][N_start] = A[N_start][j];
    }
    B[M_start][N_start] = A[N_start][M_start];

    for (size_t i = N_start + 1; i < N_end; i++) {
        size_t tmp_set = (N_start / 8 + (i - N_start) * 4 + 1) % 32;
        for (size_t j = M_start; j < M_end; j++) {
            B[j][i] = tmp[tmp_set * 8 + (j - M_start)];
        }
    }
}

/**
 * @brief The solution transpose function that will be graded.
 *
 * You can call other transpose functions from here as you please.
 * It's OK to choose different functions based on array size, but
 * this function must be correct for all values of M and N.
 */
static void transpose_submit(size_t M, size_t N, double A[N][M], double B[M][N],
                             double tmp[TMPCOUNT]) {

    if (M != N || M % 8 != 0) {
        trans_basic(M, N, A, B, tmp);
        return;
    }

    for (size_t i = 0; i < N / TRANSBLOCKSIZE * TRANSBLOCKSIZE;
         i += TRANSBLOCKSIZE) {
        for (size_t j = 0; j < M / TRANSBLOCKSIZE * TRANSBLOCKSIZE;
             j += TRANSBLOCKSIZE) {
            if (i != j) {
                trans_block(M, N, A, B, tmp, i, j, i + TRANSBLOCKSIZE,
                            j + TRANSBLOCKSIZE);
            } else {
                trans_block_diag(M, N, A, B, tmp, i, j, i + TRANSBLOCKSIZE,
                                 j + TRANSBLOCKSIZE);
            }
        }
    }

    assert(is_transpose(M, N, A, B));
}

/**
 * @brief Registers all transpose functions with the driver.
 *
 * At runtime, the driver will evaluate each function registered here, and
 * and summarize the performance of each. This is a handy way to experiment
 * with different transpose strategies.
 */
void registerFunctions(void) {
    // Register the solution function. Do not modify this line!
    registerTransFunction(transpose_submit, SUBMIT_DESCRIPTION);

    registerTransFunction(trans_basic, "Basic");
}
