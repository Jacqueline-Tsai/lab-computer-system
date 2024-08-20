/*
 * CS:APP Data Lab
 *
 * <Please put your name and userid here>
 *
 * bits.c - Source file with your solutions to the Lab.
 *          This is the file you will hand in to your instructor.
 */

/* Instructions to Students:

You will provide your solution to the Data Lab by
editing the collection of functions in this source file.

INTEGER CODING RULES:

  Replace the "return" statement in each function with one
  or more lines of C code that implements the function. Your code
  must conform to the following style:

  long Funct(long arg1, long arg2, ...) {
      // brief description of how your implementation works
      long var1 = Expr1;
      ...
      long varM = ExprM;

      varJ = ExprJ;
      ...
      varN = ExprN;
      return ExprR;
  }

  Each "Expr" is an expression using ONLY the following:
  1. (Long) integer constants 0 through 255 (0xFFL), inclusive. You are
      not allowed to use big constants such as 0xffffffffL.
  2. Function arguments and local variables (no global variables).
  3. Local variables of type int and long
  4. Unary integer operations ! ~
     - Their arguments can have types int or long
     - Note that ! always returns int, even if the argument is long
  5. Binary integer operations & ^ | + << >>
     - Their arguments can have types int or long
  6. Casting from int to long and from long to int

  Some of the problems restrict the set of allowed operators even further.
  Each "Expr" may consist of multiple operators. You are not restricted to
  one operator per line.

  You are expressly forbidden to:
  1. Use any control constructs such as if, do, while, for, switch, etc.
  2. Define or use any macros.
  3. Define any additional functions in this file.
  4. Call any functions.
  5. Use any other operations, such as &&, ||, -, or ?:
  6. Use any form of casting other than between int and long.
  7. Use any data type other than int or long.  This implies that you
     cannot use arrays, structs, or unions.

  You may assume that your machine:
  1. Uses 2s complement representations for int and long.
  2. Data type int is 32 bits, long is 64.
  3. Performs right shifts arithmetically.
  4. Has unpredictable behavior when shifting if the shift amount
     is less than 0 or greater than 31 (int) or 63 (long)

EXAMPLES OF ACCEPTABLE CODING STYLE:
  //
  // pow2plus1 - returns 2^x + 1, where 0 <= x <= 63
  //
  long pow2plus1(long x) {
     // exploit ability of shifts to compute powers of 2
     // Note that the 'L' indicates a long constant
     return (1L << x) + 1L;
  }

  //
  // pow2plus4 - returns 2^x + 4, where 0 <= x <= 63
  //
  long pow2plus4(long x) {
     // exploit ability of shifts to compute powers of 2
     long result = (1L << x);
     result += 4L;
     return result;
  }

NOTES:
  1. Use the dlc (data lab checker) compiler (described in the handout) to
     check the legality of your solutions.
  2. Each function has a maximum number of operations (integer, logical,
     or comparison) that you are allowed to use for your implementation
     of the function.  The max operator count is checked by dlc.
     Note that assignment ('=') is not counted; you may use as many of
     these as you want without penalty.
  3. Use the btest test harness to check your functions for correctness.
  4. Use the BDD checker to formally verify your functions
  5. The maximum number of ops for each function is given in the
     header comment for each function. If there are any inconsistencies
     between the maximum ops in the writeup and in this file, consider
     this file the authoritative source.

CAUTION:
  Do not add an #include of <stdio.h> (or any other C library header)
  to this file.  C library headers almost always contain constructs
  that dlc does not understand.  For debugging, you can use printf,
  which is declared for you just below.  It is normally bad practice
  to declare C library functions by hand, but in this case it's less
  trouble than any alternative.

  dlc will consider each call to printf to be a violation of the
  coding style (function calls, after all, are not allowed) so you
  must remove all your debugging printf's again before submitting your
  code or testing it with dlc or the BDD checker.  */

extern int printf(const char *, ...);

/* Edit the functions below.  Good luck!  */
// 2
/*
 * implication - given input x and y, which are binary
 * (taking  the values 0 or 1), return x -> y in propositional logic -
 * 0 for false, 1 for true
 *
 * Below is a truth table for x -> y where A is the result
 *
 * |-----------|-----|
 * |  x  |  y  |  A  |
 * |-----------|-----|
 * |  1  |  1  |  1  |
 * |-----------|-----|
 * |  1  |  0  |  0  |
 * |-----------|-----|
 * |  0  |  1  |  1  |
 * |-----------|-----|
 * |  0  |  0  |  1  |
 * |-----------|-----|
 *
 *
 *   Example: implication(1L,1L) = 1L
 *            implication(1L,0L) = 0L
 *   Legal ops: ! ~ ^ |
 *   Max ops: 5
 *   Rating: 2
 */
long implication(long x, long y) {
    return (!x) | y;
}
/*
 * dividePower2 - Compute x/(2^n), for 0 <= n <= 62
 *  Round toward zero
 *   Examples: dividePower2(15L,1L) = 7L, dividePower2(-33L,4L) = -2L
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 2
 */
long dividePower2(long x, long n) {
    long sign_bit = (x >> 63) & 1L;
    long last_n_bit = x & ((1L << n) + ~0L);
    return (x >> n) + ((!!last_n_bit) & sign_bit);
}
/*
 * anyOddBit - return 1 if any odd-numbered bit in word set to 1
 *   where bits are numbered from 0 (least significant) to 63 (most significant)
 *   Examples anyOddBit(0x5L) = 0L, anyOddBit(0x7L) = 1L
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 14
 *   Rating: 2
 */
long anyOddBit(long x) {
    x = x | (x >> 32);
    x = x | (x >> 16);
    x = x | (x >> 8);
    return !!(x & 170L);
}
/*
 * byteSwap - swaps the nth byte and the mth byte
 *  Bytes numbered from 0 (least significant) to 7 (most significant)
 *  Examples: byteSwap(0x0000000012345678L, 1, 7) = 0x5600000034120078L
 *            byteSwap(0x0000DEADBEEF0000L, 2, 4) = 0x0000DEEFBEAD0000L
 *  You may assume that 0 <= n <= 7, 0 <= m <= 7
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 25
 *  Rating: 2
 */
long byteSwap(long x, long n, long m) {
    long n8 = n << 3;
    long m8 = m << 3;
    long bit_n_xor_m = ((x >> n8) ^ (x >> m8)) & 255;
    return x ^ (bit_n_xor_m << n8) ^ (bit_n_xor_m << m8);
}
// 3
/*
 * addOK - Determine if can compute x+y without overflow
 *   Example: addOK(0x8000000000000000L,0x8000000000000000L) = 0L,
 *            addOK(0x8000000000000000L,0x7000000000000000L) = 1L,
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3
 */
long addOK(long x, long y) {
    long sign_x = (x >> 63);
    long sign_y = (y >> 63);
    long mask = ~(1L << 63);
    long add_result = ((x & mask) >> 1) + ((y & mask) >> 1) + (x & y & 1L);
    long overflow_bit = add_result >> 62;
    return ((sign_x ^ sign_y) | ~(overflow_bit ^ sign_x)) & 1L;
}
/*
 * logicalShift - shift x to the right by n, using a logical shift
 *   Can assume that 0 <= n <= 63
 *   Examples: logicalShift(0x8765432100000000L,4L) = 0x0876543210000000L
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3
 */
long logicalShift(long x, long n) {
    long sign_bit_shifted = (x >> n) & (1L << (63 + (~n + 1)));
    long mask_63 = ~(1L << 63);
    return ((x & mask_63) >> n) | sign_bit_shifted;
}
/*
 * conditional - same as x ? y : z
 *   Example: conditional(2,4L,5L) = 4L
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 16
 *   Rating: 3
 */
long conditional(long x, long y, long z) {
    return ((!x + ~0L) & y) | ((!!x + ~0L) & z);
}
/*
 * remainderPower2 - Compute x%(2^n), for 0 <= n <= 30
 *   Negative arguments should yield negative remainders
 *   Examples: remainderPower2(15L,2L) = 3, remainderPower2(-35L,3L) = -3L
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3
 */
long remainderPower2(long x, long n) {
    long sign_bit = (x >> 63) & 1L;
    long last_n_bit = x & ((1L << n) + ~0L);
    long divide_power_2 = (x >> n) + ((!!last_n_bit) & sign_bit);
    return x + ~(divide_power_2 << n) + 1;
}
// 4
/*
 * isNonZero - Check whether x is nonzero using
 *              the legal operators except !
 *   Examples: isNonZero(3L) = 1L, isNonZero(0L) = 0L
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 10
 *   Rating: 4
 */
long isNonZero(long x) {
    long mask = 1L << 63;
    return ((x | ~(((~x) ^ mask) + 1)) >> 63) & 1L;
}
/*
 * trueFiveEighths - multiplies by 5/8 rounding toward 0,
 *  avoiding errors due to overflow
 *  Examples:
 *    trueFiveEighths(11L) = 6L
 *    trueFiveEighths(-9L) = -5L
 *    trueFiveEighths(0x3000000000000000L) = 0x1E00000000000000L (no overflow)
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 20
 *  Rating: 4
 */
long trueFiveEighths(long x) {
    long sign_bit = (x >> 63) & 1L;
    long last_3_bit = x & 7L;
    long mask_63 = ~(1L << 63);
    long lower_bits = x & (x >> 2) & 1L;
    return ((x >> 3) & mask_63) + ((x >> 1) & mask_63) + lower_bits +
           ((!!last_3_bit) & sign_bit);
}

/*
 * isPalindrome - Return 1 if bit pattern in x is equal to its mirror image
 *   Example: isPalindrome(0x6F0F0123c480F0F6L) = 1L
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 70
 *   Rating: 4
 */
long isPalindrome(long x) {
    long mask_32 = (1L << 32) + ~0;
    long upper_32_bits = x >> 32;
    long lower_32_bits = x;

    long mask_16_right = (255L << 8) | 255L;
    long reverse_16 =
        ((upper_32_bits >> 16) & mask_16_right) | (upper_32_bits << 16);

    long mask_8_right = (255L << 16) | 255L;
    long mask_8_left = mask_8_right << 8;
    long reverse_8 =
        ((reverse_16 >> 8) & mask_8_right) | ((reverse_16 << 8) & mask_8_left);

    long mask_4_right = (15L << 24) | (15L << 16) | (15L << 8) | 15L;
    long mask_4_left = mask_4_right << 4;
    long reverse_4 =
        ((reverse_8 >> 4) & mask_4_right) | ((reverse_8 << 4) & mask_4_left);

    long mask_2_right = (51L << 24) | (51L << 16) | (51L << 8) | 51L;
    long mask_2_left = mask_2_right << 2;
    long reverse_2 =
        ((reverse_4 >> 2) & mask_2_right) | ((reverse_4 << 2) & mask_2_left);

    long mask_1_right = (85L << 24) | (85L << 16) | (85L << 8) | 85L;
    long mask_1_left = mask_1_right << 1;
    long reverse_1 =
        ((reverse_2 >> 1) & mask_1_right) | ((reverse_2 << 1) & mask_1_left);

    return !((lower_32_bits ^ reverse_1) & mask_32);
}